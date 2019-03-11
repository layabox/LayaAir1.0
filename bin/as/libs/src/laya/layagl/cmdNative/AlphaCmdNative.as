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
	public class AlphaCmdNative  {
		public static const ID:String = "Alpha";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private var _graphicsCmdEncoder:*;
		private var _paramData:* = __JS__("new ParamData(4,true)");
		private var _alpha:Number;
		
		
		public static function create(alpha:Number):AlphaCmdNative {
			var cmd:AlphaCmdNative = Pool.getItemByClass("AlphaCmd", AlphaCmdNative);
			var cbuf:* = cmd._graphicsCmdEncoder = __JS__("this._commandEncoder");
			cmd.alpha = alpha;
			cbuf.setGlobalValueEx( LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL,cmd._paramData.getPtrID(),0 );
			LayaGL.syncBufferToRenderThread( cbuf );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {

			Pool.recover("AlphaCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.alpha(_alpha);
		}
		
		public function get cmdID():String
		{
			return ID;
		}

		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			value = value > 1 ? 1:value;
			value = value < 0 ? 0:value;
			_alpha = value;
			var nColor:int = 0x00ffffff;
			nColor = ( (value * 255) << 24 ) | nColor;
			_paramData._int32Data[0] = nColor;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
	}
}