package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制曲线
	 */
	public class DrawCurvesCmd {
		public static const ID:String = "DrawCurves";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 开始绘制的 X 轴位置。
		 */
		public var x:Number;
		/**
		 * 开始绘制的 Y 轴位置。
		 */
		public var y:Number;
		/**
		 * 线段的点集合，格式[controlX, controlY, anchorX, anchorY...]。
		 */
		public var points:Array;
		/**
		 * 线段颜色，或者填充绘图的渐变对象。
		 */
		public var lineColor:*;
		/**
		 * （可选）线段宽度。
		 */
		public var lineWidth:Number;
		
		/**@private */
		public static function create(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number):DrawCurvesCmd {
			var cmd:DrawCurvesCmd = Pool.getItemByClass("DrawCurvesCmd", DrawCurvesCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.points = points;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			points = null;
			lineColor = null;
			Pool.recover("DrawCurvesCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawCurves(x + gx, y + gy, points, lineColor, lineWidth);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}