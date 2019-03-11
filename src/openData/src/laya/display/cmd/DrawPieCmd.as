package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制扇形
	 */
	public class DrawPieCmd {
		public static const ID:String = "DrawPie";
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
		 * 扇形半径。
		 */
		public var radius:Number;
		private var _startAngle:Number;
		private var _endAngle:Number;
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
		public static function create(x:Number, y:Number, radius:Number, startAngle:Number, endAngle:Number, fillColor:*, lineColor:*, lineWidth:Number, vid:int):DrawPieCmd {
			var cmd:DrawPieCmd = Pool.getItemByClass("DrawPieCmd", DrawPieCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.radius = radius;
			cmd._startAngle = startAngle;
			cmd._endAngle = endAngle;
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
			Pool.recover("DrawPieCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._drawPie(x + gx, y + gy, radius, _startAngle, _endAngle, fillColor, lineColor, lineWidth, vid);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
		
		/**
		 * 开始角度。
		 */
		public function get startAngle():Number {
			return _startAngle * 180 / Math.PI;
		}
		
		public function set startAngle(value:Number):void {
			_startAngle = value * Math.PI / 180;
		}
		
		/**
		 * 结束角度。
		 */
		public function get endAngle():Number {
			return _endAngle * 180 / Math.PI;
		}
		
		public function set endAngle(value:Number):void {
			_endAngle = value * Math.PI / 180;
		}
	}
}