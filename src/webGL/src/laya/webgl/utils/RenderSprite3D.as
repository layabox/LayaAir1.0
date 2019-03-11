package laya.webgl.utils {
	import laya.display.Sprite;
	import laya.display.SpriteConst;
	import laya.display.css.SpriteStyle;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.renders.RenderSprite;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.RenderTexture2D;
	import laya.webgl.resource.WebGLRTMgr;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.SubmitCMD;
	
	public class RenderSprite3D extends RenderSprite {
		
		public static var tempUV:Array = new Array(8);
		
		public function RenderSprite3D(type:int, next:RenderSprite) {
			super(type, next);
		}
		
		protected override function onCreate(type:int):void {
			switch (type) {
			case SpriteConst.BLEND: 
				_fun = this._blend;
				return;
			}
		}
		
		public static function tmpTarget(ctx:WebGLContext2D, rt:RenderTexture2D,w:int, h:int):void {
			rt.start();
			rt.clear(0, 0, 0, 0);
		}
		
		public static function recycleTarget(rt:RenderTexture2D):void {
			WebGLRTMgr.releaseRT(rt);
		}
		
		public static function setBlendMode(blendMode:String):void {
			var gl : WebGLContext = WebGL.mainContext;
			BlendMode.targetFns[BlendMode.TOINT[blendMode]](gl);
		}
		
		/**
		 * mask的渲染。 sprite有mask属性的情况下，来渲染这个sprite
		 * @param	sprite
		 * @param	context
		 * @param	x
		 * @param	y
		 */
		override public function _mask(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var next:RenderSprite = this._next;
			var mask:Sprite = sprite.mask;
			var submitCMD:SubmitCMD;
			var ctx:WebGLContext2D = context as WebGLContext2D;
			if (mask) {
				ctx.save();
				var preBlendMode:String = ctx.globalCompositeOperation;
				var tRect:Rectangle = new Rectangle();
				//裁剪范围是根据mask来定的
				tRect.copyFrom(mask.getBounds());
				tRect.width = Math.round(tRect.width);
				tRect.height = Math.round(tRect.height);
				tRect.x = Math.round(tRect.x);
				tRect.y = Math.round(tRect.y);
				if (tRect.width > 0 && tRect.height > 0) {
					var w:Number = tRect.width;
					var h:Number = tRect.height;
					var tmpRT:RenderTexture2D = WebGLRTMgr.getRT(w,h);
					
					ctx.breakNextMerge();
					//先把mask画到tmpTarget上
					ctx.pushRT();
					ctx.addRenderObject(SubmitCMD.create([ctx,tmpRT,w,h ], RenderSprite3D.tmpTarget,this));
					mask.render(ctx, -tRect.x, -tRect.y);
					ctx.breakNextMerge();
					ctx.popRT();
					//设置裁剪为mask的大小。要考虑pivot。有pivot的话，可能要从负的开始
					ctx.save();
					ctx.clipRect(x + tRect.x -sprite.getStyle().pivotX, y + tRect.y-sprite.getStyle().pivotY, w,h);
					//画出本节点的内容
					next._fun.call(next, sprite, ctx, x, y);
					ctx.restore();
					
					//设置混合模式
					preBlendMode = ctx.globalCompositeOperation;
					ctx.addRenderObject(SubmitCMD.create(["mask"],RenderSprite3D.setBlendMode,this));
					
					var shaderValue:Value2D = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
					var uv:Array = Texture.INV_UV;
					//这个地方代码不要删除，为了解决在iphone6-plus上的诡异问题
					//renderTarget + StencilBuffer + renderTargetSize < 32 就会变得超级卡
					//所以增加的限制。王亚伟
					//  180725 本段限制代码已经删除，如果出了问题再找王亚伟
					
					ctx.drawTarget(tmpRT, x + tRect.x - sprite.getStyle().pivotX , y + tRect.y-sprite.getStyle().pivotY, w, h, Matrix.TEMP.identity(), shaderValue, uv, 6);
					ctx.addRenderObject(SubmitCMD.create([tmpRT], RenderSprite3D.recycleTarget,this));
					
					//恢复混合模式
					ctx.addRenderObject(SubmitCMD.create([preBlendMode], RenderSprite3D.setBlendMode,this));
				}
				ctx.restore();
			} else {
				next._fun.call(next, sprite, context, x, y);
			}
		
		}
		
		override public function _blend(sprite:Sprite, context:Context, x:Number, y:Number):void {
			var style:SpriteStyle = sprite._style;
			var next:RenderSprite = this._next;
			if (style.blendMode) {
				context.save();
				context.globalCompositeOperation = style.blendMode;
				next._fun.call(next, sprite, context, x, y);
				context.restore();
			} else {
				next._fun.call(next, sprite, context, x, y);
			}
		}
	}
}