package laya.webgl.submit {
	import laya.webgl.submit.ISubmit;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;

	public class SubmitStencil implements ISubmit
	{

		public static var _cache:Array =/*[STATIC SAFE]*/(_cache=[],_cache._length=0,_cache);
		public var step:int;
		public function SubmitStencil()
		{
		}
		
		public function renderSubmit():int
		{
			switch(step)
			{
				case 1:
					do1();
					break;
				case 2:
					do2();
					break;
				case 3:
					do3();
					break;
			}
			return 1;
		}
		
		public function getRenderType():int
		{
			return 0;
		}
		
		public function releaseRender():void
		{
			var cache:Array = _cache;
			cache[cache._length++] = this;
		}
		
		
		private var level:int=0;
		
		private function do1():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			gl.enable(WebGLContext.STENCIL_TEST);
			gl.clear(WebGLContext.STENCIL_BUFFER_BIT);
			gl.colorMask(false, false, false, false);
			gl.stencilFunc(WebGLContext.EQUAL,level, 0xFF);
			gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.INCR);
			//gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.INVERT);//测试通过给模版缓冲 写入值 一开始是0 现在是 0xFF (模版缓冲中不知道是多少位的数据)
		}
		
		
		private function do2():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			gl.stencilFunc(WebGLContext.EQUAL,level+1, 0xFF);
			gl.colorMask(true, true, true, true);
			gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.KEEP);
		}
		
		
		private function do3():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			gl.clear(WebGLContext.STENCIL_BUFFER_BIT);
			gl.disable(WebGLContext.STENCIL_TEST);
		}
		
		
		public static function create(step:int):SubmitStencil
		{
			var o:SubmitStencil=_cache._length?_cache[--_cache._length]:new SubmitStencil();
			o.step=step;
			return o;
		}
	}
}