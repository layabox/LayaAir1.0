package laya.webgl.submit
{
	import laya.maths.Rectangle;
	import laya.webgl.submit.ISubmit;
	import laya.renders.Render;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;

	public class SubmitScissor implements ISubmit
	{
		public static var _cache:Array =/*[STATIC SAFE]*/(_cache=[],_cache._length=0,_cache);

		public var clipRect:Rectangle = new Rectangle();
		public var screenRect:Rectangle = new Rectangle();
		public var submitIndex:int;
		public var submitLength:int;
		public var context:WebGLContext2D;
		
		public function SubmitScissor()
		{
			
		}

		private function  _scissor(x:Number, y:Number, w:Number, h:Number):Boolean
		{
			var m:Array = RenderState2D.worldMatrix4;
			
			var a:Number = m[0], d:Number = m[5], tx:Number = m[12], ty:Number = m[13];
			x = x * a + tx;
			y = y * d + ty;
			w *= a;
			h *= d;
			
			if (w < 1 || h < 1) 
			{
				return false;
			}
			
			var r:Number = x + w;
			var b:Number = y + h;
			x < 0 && (x = 0,w = r - x);
			y < 0 && (y = 0,h = b - y);
			
			var screen:Rectangle = RenderState2D.worldClipRect;
			
			x = Math.max(x, screen.x);
			y = Math.max(y, screen.y);
			w = Math.min(r, screen.right) - x;
			h = Math.min(b, screen.bottom) - y;
			
			if (w < 1 || h < 1)
			{
				return false;
			}

			var worldScissorTest:Boolean = RenderState2D.worldScissorTest;
			screenRect.copyFrom(screen);
			
			screen.x = x;
			screen.y = y;
			screen.width = w;
			screen.height = h;
			
			RenderState2D.worldScissorTest = true;
				
			y = RenderState2D.height - y - h;
			
			WebGL.mainContext.scissor(x, y, w, h);
			WebGL.mainContext.enable(WebGLContext.SCISSOR_TEST);
			
			context.submitElement(submitIndex, submitIndex + submitLength);

			if (worldScissorTest)
			{
				y = RenderState2D.height - screenRect.y - screenRect.height;
				WebGL.mainContext.scissor(screenRect.x, y, screenRect.width, screenRect.height);
				WebGL.mainContext.enable(WebGLContext.SCISSOR_TEST);
			}
			else
			{
				WebGL.mainContext.disable(WebGLContext.SCISSOR_TEST);
				RenderState2D.worldScissorTest = false;
			}
			
			screen.copyFrom(screenRect);
			
			return true;
		}
		
		private function  _scissorWithTagart(x:Number, y:Number, w:Number, h:Number):Boolean
		{
			if (w < 1 || h < 1) 
			{
				return false;
			}
			
			var r:Number = x + w;
			var b:Number = y + h;
			x < 0 && (x = 0,w = r - x);
			y < 0 && (y = 0,h = b - y);
			
			
			var screen:Rectangle = RenderState2D.worldClipRect;
			
			x = Math.max(x, screen.x);
			y = Math.max(y, screen.y);
			w = Math.min(r, screen.right) - x;
			h = Math.min(b, screen.bottom) - y;
			
			if (w < 1 || h < 1)
			{
				return false;
			}

			var worldScissorTest:Boolean = RenderState2D.worldScissorTest;
			screenRect.copyFrom(screen);

			RenderState2D.worldScissorTest = true;

			screen.x = x;
			screen.y = y;
			screen.width = w;
			screen.height = h;
				
			y = RenderState2D.height- y - h;
			
			WebGL.mainContext.scissor(x, y, w, h);
			WebGL.mainContext.enable(WebGLContext.SCISSOR_TEST);
			
			context.submitElement(submitIndex, submitIndex + submitLength);
			
			if (worldScissorTest)
			{
				y = RenderState2D.height - screenRect.y - screenRect.height;
				WebGL.mainContext.scissor(screenRect.x, y, screenRect.width, screenRect.height);
				WebGL.mainContext.enable(WebGLContext.SCISSOR_TEST);
			}
			else
			{
				WebGL.mainContext.disable(WebGLContext.SCISSOR_TEST);
				RenderState2D.worldScissorTest = false;
			}
			
			screen.copyFrom(screenRect);
			
			return true;
		}

		public function renderSubmit():int
		{
			submitLength = Math.min(context._submits._length-1,submitLength);
			if (submitLength < 1 || clipRect.width < 1 || clipRect.height < 1) 
				return submitLength + 1;
				
			//WebGL.mainContext.disable(WebGLContext.SCISSOR_TEST);
			//context.submitElement(submitIndex, submitIndex + submitLength);
			
			if (context._targets)
				 _scissorWithTagart(clipRect.x, clipRect.y, clipRect.width, clipRect.height);
			else _scissor(clipRect.x, clipRect.y, clipRect.width, clipRect.height);
			
			return submitLength+1;
		}
		
		public function getRenderType():int
		{
			return 0;
		}
		
		public function releaseRender():void
		{
			var cache:Array = _cache;
			cache[cache._length++] = this;
			context = null;
		}
		
		public static function create(context:WebGLContext2D):SubmitScissor
		{
			var o:SubmitScissor = _cache._length?_cache[--_cache._length]:new SubmitScissor();
			o.context = context;
			return o;
		}
	}
}