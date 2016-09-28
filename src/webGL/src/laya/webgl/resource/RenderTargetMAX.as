package laya.webgl.resource {
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.utils.RenderState2D;
	
	public class RenderTargetMAX {
		private static var _matrixDefault:Matrix = new Matrix();
		
		public var targets:Vector.<OneTarget>;//没用到
		public var oneTargets:OneTarget;
		public var repaint:Boolean;
		
		public var _width:Number;
		public var _height:Number;
		
		private var _clipRect:Rectangle = new Rectangle();
		
		public function RenderTargetMAX() {
		
		}
		
		public function size(w:Number, h:Number):void {
			if (_width === w && _height === h) return;
			repaint = true;
			_width = w;
			_height = h;
			
			if (!oneTargets)
				oneTargets = new OneTarget(w, h);
			else
				oneTargets.target.size(w, h);
		
		}
		
		private function _flushToTarget(context:WebGLContext2D, target:RenderTarget2D):void {
			var worldScissorTest:Boolean = RenderState2D.worldScissorTest;
			var preworldClipRect:Rectangle = RenderState2D.worldClipRect;
			
			RenderState2D.worldClipRect = _clipRect;
			_clipRect.x = _clipRect.y = 0;
			_clipRect.width = _width;
			_clipRect.height = _height;
			
			RenderState2D.worldScissorTest = false;
			WebGL.mainContext.disable(WebGLContext.SCISSOR_TEST);
			
			var preAlpha:Number = RenderState2D.worldAlpha;
			var preMatrix4:Array = RenderState2D.worldMatrix4;
			var preMatrix:Matrix = RenderState2D.worldMatrix;
			
			var preFilters:Array = RenderState2D.worldFilters;
			var preShaderDefines:ShaderDefines2D = RenderState2D.worldShaderDefines;
			
			RenderState2D.worldMatrix = _matrixDefault;
			
			RenderState2D.restoreTempArray();
			RenderState2D.worldMatrix4 = RenderState2D.TEMPMAT4_ARRAY;
			RenderState2D.worldAlpha = 1;
			RenderState2D.worldFilters = null;
			RenderState2D.worldShaderDefines = null;
			Shader.activeShader = null;
			
			target.start();
			
			Config.showCanvasMark ? target.clear(0, 1, 0, 0.3) : target.clear(0, 0, 0, 0);
			
			context.flush();
			target.end();
			
			Shader.activeShader = null;
			RenderState2D.worldAlpha = preAlpha;
			RenderState2D.worldMatrix4 = preMatrix4;
			RenderState2D.worldMatrix = preMatrix;
			RenderState2D.worldFilters = preFilters;
			RenderState2D.worldShaderDefines = preShaderDefines;
			
			RenderState2D.worldScissorTest = worldScissorTest
			if (worldScissorTest) {
				var y:Number = RenderState2D.height - preworldClipRect.y - preworldClipRect.height;
				WebGL.mainContext.scissor(preworldClipRect.x, y, preworldClipRect.width, preworldClipRect.height);
				WebGL.mainContext.enable(WebGLContext.SCISSOR_TEST);
			}
			
			RenderState2D.worldClipRect = preworldClipRect;
		}
		
		public function flush(context:WebGLContext2D):void {
			if (repaint) {
				_flushToTarget(context, oneTargets.target);
				repaint = false;
			}
		}
		
		public function drawTo(context:WebGLContext2D, x:Number, y:Number, width:Number, height:Number):void {
			context.drawTexture(oneTargets.target.getTexture(), x, y, width, height, 0, 0);
		}
		
		public function destroy():void {
			if (oneTargets) {
				oneTargets.target.destroy();
				oneTargets.target = null;
				oneTargets = null;
			}
		}
	}

}

import laya.webgl.resource.RenderTarget2D;

class OneTarget {
	/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
	public var x:Number;
	import laya.webgl.resource.RenderTarget2D;
	public var width:Number;
	public var height:Number;
	public var target:RenderTarget2D;
	
	public function OneTarget(w:Number, h:Number) {
		width = w;
		height = h;
		target = RenderTarget2D.create(w, h);
	}
}