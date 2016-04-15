package laya.webgl.utils 
{
	import laya.display.Sprite;
	import laya.display.css.Style;
	import laya.maths.Matrix;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitStencil;
	
	/**
	 * ...
	 * @author laya
	 */
	public class RenderSprite3D extends RenderSprite 
	{
		
		public function RenderSprite3D(type:int, next:RenderSprite) 
		{
			super(type, next);
		}
		
		protected override function onCreate(type:int):void
		{
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
		
//		
//		private function _filterStart(scope:*, sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
//			/*var b:Rectangle = scope.getValue("bounds");
//			var source:RenderTarget2D = RenderTarget2D.create(b.width, b.height);
//			source.start();
//			scope.addValue("src", source);*/
//		}
//		
//		private function _filterEnd(scope:*, sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
//			/*var b:Rectangle = scope.getValue("bounds");
//			var source:RenderTarget2D = scope.getValue("src");
//			source.end();
//			var out:RenderTarget2D = RenderTarget2D.create(b.width, b.height);
//			out.start();
//			scope.addValue("out", out);*/
//		}
//		
//		private function _EndTarget(scope:*):void {
//			/*var out:RenderTarget2D = scope.getValue("out");
//			out.end();*/
//		}
//		
//		private function _recycleScope(scope:*):void {
//			/*var out:RenderTarget2D = scope.getValue("out");
//			out.recycle();
//			var src:RenderTarget2D = scope.getValue("src");
//			src.recycle();
//			scope.recycle();*/
//		}
		
		
		
		
		
		override public function _blend(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var style:Style = sprite._style;
//			if (style.blendMode) {
				var submit:SubmitStencil,next:RenderSprite
				context.ctx.save();
				if (sprite.mask){
				
						submit=SubmitStencil.create(1);
						context.addRenderObject(submit);
						sprite.mask.render(context, x, y);
						submit=SubmitStencil.create(2);
						context.addRenderObject(submit);
				
				next = this._next;
				next._fun.call(next, sprite, context, x, y);
				
					submit=SubmitStencil.create(3);
					context.ctx._curSubmit=Submit.RENDERBASE;
					context.addRenderObject(submit);
				}
				else
				{
					context.ctx.globalCompositeOperation = style.blendMode;
					next = this._next;
					next._fun.call(next, sprite, context, x, y);
				}
				context.ctx.restore();
//			}
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
				m1.copy(m2);
				m1.destroy();
				transform.tx = transform.ty = 0;
			} else
				_next._fun.call(_next, sprite, context, x, y);
		}
		
		
	}

}