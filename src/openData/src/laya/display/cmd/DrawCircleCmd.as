package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制圆形
	 */
	public class DrawCircleCmd {
		public static const ID:String = "DrawCircle";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 圆点X 轴位置。
		 */
		public var x:Number;
		/**
		 * 圆点Y 轴位置。
		 */
		public var y:Number;
		/**
		 * 半径。
		 */
		public var radius:Number;
		/**
		 * 填充颜色，或者填充绘图的渐变对象。
		 */
		public var fillColor:*;
		/**
		 * （可选）边框颜色，或者填充绘图的渐变对象。
		 */
		public var lineColor:*;
		/**
		 * （可选）边框宽度。
		 */
		public var lineWidth:Number;
		/**@private */
		public var vid:int;
		
		/**@private */
		public static function create(x:Number, y:Number, radius:Number, fillColor:*, lineColor:*, lineWidth:Number, vid:int):DrawCircleCmd {
			var cmd:DrawCircleCmd = Pool.getItemByClass("DrawCircleCmd", DrawCircleCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.radius = radius;
			cmd.fillColor = fillColor;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			cmd.vid = vid;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			fillColor = null;
			lineColor = null;
			Pool.recover("DrawCircleCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._drawCircle(x + gx, y + gy, radius, fillColor, lineColor, lineWidth, vid);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}