package laya.filters.webgl
{
	import laya.display.Sprite;
	import laya.filters.Filter;
	import laya.filters.GlowFilter;
	import laya.filters.IFilterActionGL;
	import laya.maths.Rectangle;
	import laya.renders.RenderContext;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.SubmitCMDScope;
	
	public class GlowFilterActionGL extends FilterActionGL implements IFilterActionGL
	{
		private var data:GlowFilter
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
		
		
		
		public static function tmpTarget(scope, sprite, context, x:Number, y:Number):void {
			var b:Rectangle = scope.getValue("bounds");
			var out:*=scope.getValue("out");
				out.end();
			var tmpTarget:RenderTarget2D = RenderTarget2D.create(b.width + 20, b.height + 20);
			tmpTarget.start();
			scope.addValue("tmpTarget", tmpTarget);
			
		}
		
		public static function startOut(scope, sprite, context, x:Number, y:Number):void {
			var tmpTarget:*= scope.getValue("tmpTarget");
			tmpTarget.end();
			var out:*=scope.getValue("out");
				out.start();
		}
		
		public static function recycleTarget(scope, sprite, context, x:Number, y:Number):void
		{
			var src:*= scope.getValue("src");
			src.recycle();
			src.destroy();
			var tmpTarget:*= scope.getValue("tmpTarget");
			tmpTarget.recycle();
			tmpTarget.destroy();
		}
		
		override public function apply3d(scope:SubmitCMDScope, sprite:Sprite, context:RenderContext, x:Number, y:Number):*
		{
			
			/*var b:Rectangle=scope.getValue("bounds");
			var w:int = b.width, h:int = b.height;
			var submit = SubmitCMD.create([scope, sprite, context, 0, 0], tmpTarget);
					context.addRenderObject(submit);
			var shaderValue:*;
			var mat:Matrix = Matrix.TEMP;
			shaderValue=Value2D.createShderValueMix(ShaderDefines2D.TEXTURE2D,sprite.filters);
			shaderValue.u_texW=w+20;
			shaderValue.u_texH=h+20;
			context.ctx.drawTarget(scope, 0, 0, w + 20, h + 20, mat, "src", shaderValue);
			submit = SubmitCMD.create([scope, sprite, context, 0, 0], startOut);
					context.addRenderObject(submit);
			data._blurX = false;
			shaderValue=Value2D.createShderValueMix(ShaderDefines2D.TEXTURE2D,sprite.filters);
			shaderValue.u_texW=w+20;
			shaderValue.u_texH=h+20;
			context.ctx.drawTarget(scope, 0, 0, w + 20, h + 20, mat, "tmpTarget", shaderValue, Texture.INV_UV);			
			data._blurX=true;
			shaderValue=Value2D.createShderValue(ShaderDefines2D.TEXTURE2D,sprite.filters);
			context.ctx.drawTarget(scope, 0, 0, w + 20, h + 20, mat, "src", shaderValue);
			
			submit = SubmitCMD.create([scope, sprite, context, 0, 0], recycleTarget);
					context.addRenderObject(submit);*/
			
			return null;
		}
	}
}