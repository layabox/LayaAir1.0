package laya.display.cmd {
	import laya.utils.Pool;
	
	/**
	 * 绘制Canvas贴图
	 * @private
	 */
	public class DrawCanvasCmd {
		public static const ID:String = "DrawCanvasCmd";
		/**@private */
		public static var _DRAW_IMAGE_CMD_ENCODER_:* = null;
		/**@private */
		public static var _PARAM_TEXTURE_POS_:int = 2;
		/**@private */
		public static var _PARAM_VB_POS_:int = 5;
		
		private var _graphicsCmdEncoder:*;
		private var _index:int;
		private var _paramData:* = null;
		/**
		 * 绘图数据
		 */
		public var texture:*/*RenderTexture2D*/;
		/**
		 * 绘制区域起始位置x
		 */
		public var x:Number;
		/**
		 * 绘制区域起始位置y
		 */
		public var y:Number;
		/**
		 * 绘制区域宽
		 */
		public var width:Number;
		/**
		 * 绘制区域高
		 */
		public var height:Number;
		
		/**@private */
		public static function create(texture:*/*RenderTexture2D*/, x:Number, y:Number, width:Number, height:Number):DrawCanvasCmd {
			return null;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_graphicsCmdEncoder = null;
			Pool.recover("DrawCanvasCmd", this);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}