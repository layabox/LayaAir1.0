package laya.layagl.cmdNative {
	import laya.maths.Point;
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	/**
	 * ...
	 * @author ww
	 */
	public class TranslateCmdNative  {
		public static const ID:String = "Translate";
		private var _graphicsCmdEncoder:*;
		private var _paramData:* = __JS__("new ParamData(2 * 4,true)");
		
		public static function create(tx:Number, ty:Number):TranslateCmdNative {
			var cmd:TranslateCmdNative = Pool.getItemByClass("TranslateCmd", TranslateCmdNative);
			var cbuf:* = cmd._graphicsCmdEncoder = __JS__("this._commandEncoder");
			//数据区
			var f32:Float32Array = cmd._paramData._float32Data;
			f32[0] = tx;
			f32[1] = ty;
			var nDataID:int = cmd._paramData.getPtrID();
			LayaGL.syncBufferToRenderThread( cmd._paramData );
			cbuf.setGlobalValueEx(LayaNative2D.GLOBALVALUE_MATRIX32,LayaGL.VALUE_OPERATE_M32_TRANSLATE,nDataID,0);
			LayaGL.syncBufferToRenderThread( cbuf );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {

			Pool.recover("TranslateCmd", this);
		}
		
		public function get cmdID():String
		{
			return ID;
		}

		public function get tx():Number
		{
			return _paramData._float32Data[0];
		}
		
		public function set tx(value:Number):void
		{
			_paramData._float32Data[0] = value;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get ty():Number
		{
			return _paramData._float32Data[1];
		}
		
		public function set ty(value:Number):void
		{
			_paramData._float32Data[1] = value;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
	}
}