package laya.webgl.submit {
	import laya.webgl.submit.ISubmit;
	import laya.utils.Handler;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.Buffer2D;

	public class SubmitCMD implements ISubmit
	{
		
		public static var _cache:Array =/*[STATIC SAFE]*/(_cache=[],_cache._length=0,_cache);
		
		public var fun:Function;
		public var args:Array;
		public function SubmitCMD()
		{
		}
		
		public function renderSubmit():int
		{
			fun.apply(null,args);
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
		
		public static function create(args:Array,fun:Function):SubmitCMD
		{
			var o:SubmitCMD=_cache._length?_cache[--_cache._length]:new SubmitCMD();
			o.fun=fun;
			o.args=args;
			return o;
		}
	}
}