package laya.webgl.utils {
	import laya.display.Sprite;
	import laya.display.Sprite;
	import laya.display.css.Style;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Texture;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.SubmitCMD;
	import laya.webgl.submit.SubmitCMDScope;
	import laya.webgl.submit.SubmitStencil;
	
	public class RenderSprite3D extends RenderSprite {
		
		public function RenderSprite3D(type:int, next:RenderSprite) {
			super(type, next);
		}
		
		protected override function onCreate(type:int):void {
			switch (type) {
			case BLEND: 
				_fun = this._blend;
				return;
			case TRANSFORM: 
				_fun = this._transform;
				return;
					//			case FILTERS: 
					//				_fun = _filter;
					//				return;
			}
		}
		
		public static function tmpTarget(scope:SubmitCMDScope, context:RenderContext):void {
			var b:Rectangle = scope.getValue("bounds");
			var tmpTarget:RenderTarget2D = RenderTarget2D.create(b.width, b.height);
			tmpTarget.start();
			tmpTarget.clear(0, 0, 0, 0);
			scope.addValue("tmpTarget", tmpTarget);
		}
		
		public static function endTmpTarget(scope:SubmitCMDScope):void {
			var tmpTarget:* = scope.getValue("tmpTarget");
			tmpTarget.end();
		}
		
		public static function recycleTarget(scope:SubmitCMDScope):void {
			var tmpTarget:* = scope.getValue("tmpTarget");
			tmpTarget.recycle();
			scope.recycle();
		}
		
		override public function _blend(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var style:Style = sprite._style;
			var next:RenderSprite = this._next;
			var mask:Sprite = sprite.mask;
			var submitCMD:SubmitCMD;
			var submitStencil:SubmitStencil;
			context.ctx.save();
			if (mask) {
				var preBlendMode:String = (context.ctx as WebGLContext2D).globalCompositeOperation;
				var tRect:Rectangle = new Rectangle();
				tRect.copyFrom(mask.getBounds());
				if (tRect.width > 0 && tRect.height > 0) {
					var scope:SubmitCMDScope = SubmitCMDScope.create();
					scope.addValue("bounds", tRect);
					submitCMD = SubmitCMD.create([scope, context], RenderSprite3D.tmpTarget);
					context.addRenderObject(submitCMD);
					mask.render(context, -tRect.x, -tRect.y);
					submitCMD = SubmitCMD.create([scope], RenderSprite3D.endTmpTarget);
					context.addRenderObject(submitCMD);
					//裁剪
					context.ctx.save();
					context.clipRect(x + tRect.x, y + tRect.y, tRect.width, tRect.height);
					next._fun.call(next, sprite, context, x, y);
					context.ctx.restore();
					//设置混合模式
					submitStencil = SubmitStencil.create(6);
					preBlendMode = (context.ctx as WebGLContext2D).globalCompositeOperation;
					submitStencil.blendMode = "mask";
					context.addRenderObject(submitStencil);
					Matrix.TEMP.identity();
					var shaderValue:Value2D = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
					(context.ctx as WebGLContext2D).drawTarget(scope, x + tRect.x, y + tRect.y, tRect.width, tRect.height, Matrix.TEMP, "tmpTarget", shaderValue, Texture.INV_UV, 6);
					submitCMD = SubmitCMD.create([scope], RenderSprite3D.recycleTarget);
					context.addRenderObject(submitCMD);
					submitStencil = SubmitStencil.create(6);
					submitStencil.blendMode = preBlendMode;
					context.addRenderObject(submitStencil);
				}
			} else {
				context.ctx.globalCompositeOperation = style.blendMode;
				next = this._next;
				next._fun.call(next, sprite, context, x, y);
			}
			context.ctx.restore();
		
		}
		
		override public function _transform(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			'use strict';
			var transform:Matrix = sprite.transform, _next:RenderSprite = this._next;
			if (transform && _next != NORENDER) {
				var ctx:WebGLContext2D = context.ctx;
				var style:Style = sprite._style;
				transform.tx = x;
				transform.ty = y;
				var m2:Matrix = ctx._getTransformMatrix();
				var m1:Matrix = m2.clone();
				Matrix.mul(transform, m2, m2);
				m2._checkTransform();
				_next._fun.call(_next, sprite, context, 0, 0);
				m1.copyTo(m2);
				m1.destroy();
				transform.tx = transform.ty = 0;
			} else {
				_next._fun.call(_next, sprite, context, x, y);
			}
		}
	}
}