package laya.webgl.submit {
	import laya.utils.Handler;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.Mesh2D;
	import laya.webgl.utils.VertexBuffer2D;

	public class SubmitCMD implements ISubmit
	{
		public static var POOL:Array =/*[STATIC SAFE]*/(POOL=[],POOL._length=0,POOL);
		
		public var fun:Function;
		public var _this:Object;	
		public var args:Array;
		public var _ref:int = 1;
		public var _key:SubmitKey=new SubmitKey();
		
		public function SubmitCMD()
		{
		}
		
		public function renderSubmit():int
		{
			fun.apply(_this,args);
			return 1;
		}
		
		//TODO:coverage
		public function getRenderType():int
		{
			return 0;
		}
		
		//TODO:coverage
		public function reUse(context:WebGLContext2D, pos:int):int
		{
			_ref++;
			return pos;
		}
		
		public function releaseRender():void
		{
			if( (--this._ref) <1)
			{
				var pool:Array = POOL;
				pool[pool._length++] = this;
			}
		}
		
		//TODO:coverage
		public function clone(context:WebGLContext2D,mesh:Mesh2D,pos:int):ISubmit
		{
			return null;
		}
		
		public static function create(args:Array,fun:Function,thisobj:Object):SubmitCMD
		{
			var o:SubmitCMD=POOL._length?POOL[--POOL._length]:new SubmitCMD();
			o.fun=fun;
			o.args = args;
			o._this = thisobj;
			o._ref = 1;
			o._key.clear();
			return o;
		}
	}
}