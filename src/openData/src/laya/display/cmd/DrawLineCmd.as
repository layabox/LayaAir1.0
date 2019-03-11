package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制单条曲线
	 */
	public class DrawLineCmd {
		public static const ID:String = "DrawLine";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * X轴开始位置。
		 */
		public var fromX:Number;
		/**
		 * Y轴开始位置。
		 */
		public var fromY:Number;
		/**
		 * X轴结束位置。
		 */
		public var toX:Number;
		/**
		 * Y轴结束位置。
		 */
		public var toY:Number;
		/**
		 * 颜色。
		 */
		public var lineColor:String;
		/**
		 * （可选）线条宽度。
		 */
		public var lineWidth:Number;
		/**@private */
		public var vid:int;
		
		/**@private */
		public static function create(fromX:Number, fromY:Number, toX:Number, toY:Number, lineColor:String, lineWidth:Number, vid:int):DrawLineCmd {
			var cmd:DrawLineCmd = Pool.getItemByClass("DrawLineCmd", DrawLineCmd);
			cmd.fromX = fromX;
			cmd.fromY = fromY;
			cmd.toX = toX;
			cmd.toY = toY;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			cmd.vid = vid;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {			
			Pool.recover("DrawLineCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._drawLine(gx, gy, fromX, fromY, toX, toY, lineColor, lineWidth, vid);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}