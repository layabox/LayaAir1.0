package laya.webgl.resource {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.utils.RenderState2D;
	
	public class RenderTargetMAX{
		//private static var _matrixDefault:Matrix = new Matrix();//可否换成Matrix的EMPTY
		
		//public var targets:Vector.<OneTarget>;//没用到
		public var target:RenderTarget2D;
		public var repaint:Boolean;
		
		public var _width:Number;
		public var _height:Number;
		private var _sp:Sprite;
		
		private var _clipRect:Rectangle = new Rectangle();
		
		public function RenderTargetMAX() {
			
		}
		
		public function setSP(sp:Sprite):void{
			_sp = sp;
		}
		
		public function size(w:Number, h:Number):void {
			if (_width === w && _height === h) 
			{
				this.target.size(w, h);
				return;
			}
		    repaint = true;
			_width = w;
			_height = h;
			if (!target)
				target = RenderTarget2D.create(w, h);
			else
				target.size(w, h);
			if (!target.hasListener(Event.RECOVERED))
			{
				target.on(Event.RECOVERED, this, function(e:Event):void{
					Laya.timer.callLater(_sp,_sp.repaint);
				});
			}
		}
		
		private function _flushToTarget(context:WebGLContext2D, target:RenderTarget2D):void {
			if (target._destroy) return;
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
			
			RenderState2D.worldMatrix = Matrix.EMPTY;
			
			RenderState2D.restoreTempArray();
			RenderState2D.worldMatrix4 = RenderState2D.TEMPMAT4_ARRAY;
			RenderState2D.worldAlpha = 1;
			RenderState2D.worldFilters = null;
			RenderState2D.worldShaderDefines = null;
			BaseShader.activeShader = null;
			
			target.start();
			
			Config.showCanvasMark ? target.clear(0, 1, 0, 0.3) : target.clear(0, 0, 0, 0);
			
			context.flush();
			target.end();
			
			BaseShader.activeShader = null;
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
				_flushToTarget(context,target);
				repaint = false;
			}
		}
		
		public function drawTo(context:WebGLContext2D, x:Number, y:Number, width:Number, height:Number):void {
			context.drawTexture(target.getTexture(), x, y, width, height, 0, 0);
		}
		
		public function destroy():void {
			if (target) {
				target.destroy();
				target = null;
				_sp = null;
			}
		}
	}

}