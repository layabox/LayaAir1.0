package laya.layagl.cmdNative {
	import laya.maths.Point;
	import laya.layagl.LayaGL; 
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	/**
	 * ...
	 * @author ww
	 */
	public class RestoreCmdNative  {
		public static const ID:String = "Restore";
		private var _graphicsCmdEncoder:*;
		
		public static function create():RestoreCmdNative {
			var cmd:RestoreCmdNative = Pool.getItemByClass("RestoreCmd", RestoreCmdNative);
			var cbuf:* = cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			cbuf.restore();	
			LayaGL.syncBufferToRenderThread( cbuf );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {

			Pool.recover("RestoreCmd", this);
		}
		
		public function get cmdID():String
		{
			return ID;
		}


	}
}