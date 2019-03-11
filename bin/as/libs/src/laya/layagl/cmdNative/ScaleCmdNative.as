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
	public class ScaleCmdNative  {
		public static const ID:String = "Scale";
		private var _graphicsCmdEncoder:*;
		private var _paramData:* = __JS__("new ParamData(4 * 4,true)");
		
		public static function create(scaleX:Number,scaleY:Number,pivotX:Number,pivotY:Number):ScaleCmdNative {
			var cmd:ScaleCmdNative = Pool.getItemByClass("ScaleCmd", ScaleCmdNative);
			var cbuf:* = cmd._graphicsCmdEncoder = __JS__("this._commandEncoder");
			//数据区
			var f32:Float32Array = cmd._paramData._float32Data;
			f32[0] = scaleX;
			f32[1] = scaleY;
			f32[2] = pivotX;
			f32[3] = pivotY;
			var nDataID:int = cmd._paramData.getPtrID();
			LayaGL.syncBufferToRenderThread( cmd._paramData );
			cbuf.setGlobalValueEx(LayaNative2D.GLOBALVALUE_MATRIX32,LayaGL.VALUE_OPERATE_M32_SCALE_PIVOT,nDataID,0);
			LayaGL.syncBufferToRenderThread( cbuf );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {

			Pool.recover("ScaleCmd", this);
		}
		
		public function get cmdID():String
		{
			return ID;
		}

		public function get scaleX():Number
		{
			return _paramData._float32Data[0];
		}
		
		public function set scaleX(value:Number):void
		{
			_paramData._float32Data[0] = value;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get scaleY():Number
		{
			return _paramData._float32Data[1];
		}
		
		public function set scaleY(value:Number):void
		{
			_paramData._float32Data[1] = value;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get pivotX():Number
		{
			return _paramData._float32Data[2];
		}
		
		public function set pivotX(value:Number):void
		{
			_paramData._float32Data[2] = value;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get pivotY():Number
		{
			return _paramData._float32Data[3];
		}
		
		public function set pivotY(value:Number):void
		{
			_paramData._float32Data[3] = value;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
	}
}