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
	public class SaveCmdNative  {
		public static const ID:String = "Save";
		private var _graphicsCmdEncoder:*;

		public static function create():SaveCmdNative {
			var cmd:SaveCmdNative = Pool.getItemByClass("SaveCmd", SaveCmdNative);
			var cbuf:* = cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			cbuf.save();
			LayaGL.syncBufferToRenderThread( cbuf );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {

			Pool.recover("SaveCmd", this);
		}
		
		public function get cmdID():String
		{
			return ID;
		}


	}
}