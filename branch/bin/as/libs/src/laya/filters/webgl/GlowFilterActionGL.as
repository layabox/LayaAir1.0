package laya.filters.webgl{
	import laya.display.Sprite;
	import laya.filters.Filter;
	import laya.filters.GlowFilter;
	import laya.filters.IFilterActionGL;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.renders.RenderContext;
	import laya.resource.Texture;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.SubmitCMD;
	import laya.webgl.submit.SubmitCMDScope;
	
	/**
	 * @private
	 */
	public class GlowFilterActionGL extends FilterActionGL implements IFilterActionGL{
		public var data:GlowFilter;
		private var _initKey:Boolean = false;
		private var _textureWidth:int = 0;
		private var _textureHeight:int = 0;
		
		public function GlowFilterActionGL(){}
		
		override public function get typeMix():int{return Filter.GLOW;}
		
		override public function setValueMix(shader:Value2D):void
		{
			/*shader.defines.add(data.type);
			var o:*=shader;
			shader.u_blurX=data._blurX;
			shader.u_offset=data.offX;
			if(data._blurX)shader.u_offset=data.offX;
			else shader.u_offset=data.offY;
			shader.u_strength=data.blur;
			shader.u_color=data._color._color;*/
		}
		
		public static function tmpTarget(scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var b:Rectangle = scope.getValue("bounds");
			var out:*= scope.getValue("out");
			out.end();
			var tmpTarget:RenderTarget2D = RenderTarget2D.create(b.width, b.height);
			tmpTarget.start();
			var color:Array = scope.getValue("color");
			if (color) {	
				tmpTarget.clear(color[0],color[1],color[2],0);
			}
			scope.addValue("tmpTarget", tmpTarget);
		}
		
		public static function startOut(scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var tmpTarget:*= scope.getValue("tmpTarget");
			tmpTarget.end();
			var out:*= scope.getValue("out");
			out.start();
			var color:Array = scope.getValue("color");
			if (color) {	
				out.clear(color[0],color[1],color[2],0);
			}
		}
		
		public static function recycleTarget(scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number):void{
			var src:*= scope.getValue("src");
			var tmpTarget:*= scope.getValue("tmpTarget");
			tmpTarget.recycle();
		}
		
		override public function apply3d(scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number):*{
			var b:Rectangle = scope.getValue("bounds");
			scope.addValue("color", data.getColor());
			var w:int = b.width, h:int = b.height;
			_textureWidth = w;
			_textureHeight = h;
			//生成一个临时的纹理
			var submit:SubmitCMD = SubmitCMD.create([scope, sprite, context, 0, 0], tmpTarget);
			context.ctx.addRenderObject(submit);
			
			//把对象画到临时纹理上（画的时候用滤镜）
			var shaderValue:Value2D;
			var mat:Matrix = Matrix.TEMP;
			mat.identity();
			shaderValue = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
			shaderValue.setFilters([data]); 
			
			context.ctx.drawTarget(scope, 0, 0, _textureWidth, _textureHeight, mat, "src", shaderValue,null,BlendMode.TOINT.overlay);
			//再对生成的临时纹理跟纹理依次画到结果纹理上
			submit = SubmitCMD.create([scope, sprite, context, 0, 0], startOut);
			context.ctx.addRenderObject(submit);
			shaderValue = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
			context.ctx.drawTarget(scope, 0, 0, _textureWidth, _textureHeight, mat, "tmpTarget", shaderValue, Texture.INV_UV,BlendMode.TOINT.overlay);
			shaderValue = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
			context.ctx.drawTarget(scope, 0, 0, _textureWidth, _textureHeight, mat, "src", shaderValue);
			//清临时纹理
			submit = SubmitCMD.create([scope, sprite, context, 0, 0], recycleTarget);
			context.ctx.addRenderObject(submit);
			
			return null;
		}
		
		public function setSpriteWH(sprite:Sprite):void{
			_textureWidth = sprite.width;
			_textureHeight = sprite.height;
		}
		
		override public function setValue(shader:*):void{
			shader.u_offsetX = data.offX;
			shader.u_offsetY = -data.offY;
			shader.u_strength = 1.0;
			shader.u_blurX = data.blur;
			shader.u_blurY = data.blur;
			shader.u_textW = _textureWidth;
			shader.u_textH = _textureHeight;
			shader.u_color = data.getColor();
		}
	}
}