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
	public class TransformCmdNative  {
		public static const ID:String = "Transform";
		private var _graphicsCmdEncoder:*;
		private var _paramData:* = __JS__("new ParamData( 8* 4,true)");
		private var _matrix:Matrix;
		
		public static function create(matrix:Matrix,pivotX:Number,pivotY:Number):TransformCmdNative {
			var cmd:TransformCmdNative = Pool.getItemByClass("TransformCmd", TransformCmdNative);
			var cbuf:* = cmd._graphicsCmdEncoder = __JS__("this._commandEncoder");
			//数据区
			var f32:Float32Array = cmd._paramData._float32Data;
			f32[0] = matrix.a; f32[1] = matrix.b;  f32[2] = matrix.c;
			f32[3] = matrix.d; f32[4] = matrix.tx; f32[5] = matrix.ty;
			f32[6] = pivotX; f32[7] = pivotY;
			cmd._matrix = matrix;
			var nDataID:int = cmd._paramData.getPtrID();
			LayaGL.syncBufferToRenderThread( cmd._paramData );
			cbuf.setGlobalValueEx(LayaNative2D.GLOBALVALUE_MATRIX32,LayaGL.VALUE_OPERATE_M32_TRANSFORM_PIVOT,nDataID,0);
			LayaGL.syncBufferToRenderThread( cbuf );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_matrix = null;
			Pool.recover("TransformCmd", this);
		}
		
		public function get cmdID():String
		{
			return ID;
		}

		public function get matrix():Matrix
		{
			return _matrix;
		}
		
		public function set matrix(value:Matrix):void
		{
			_matrix = value;
			var _fb:Float32Array = _paramData._float32Data;
			_fb[0] = _matrix.a; _fb[1] = _matrix.b; _fb[2] = _matrix.c; 
			_fb[3] = _matrix.d; _fb[4] = _matrix.tx; _fb[5] = _matrix.ty;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get pivotX():Number
		{
			return _paramData._float32Data[6];
		}
		
		public function set pivotX(value:Number):void
		{
			_paramData._float32Data[6] = value;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get pivotY():Number
		{
			return _paramData._float32Data[7];
		}
		
		public function set pivotY(value:Number):void
		{
			_paramData._float32Data[7] = value;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
	}
}