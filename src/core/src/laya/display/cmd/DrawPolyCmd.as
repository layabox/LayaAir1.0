package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制多边形
	 */
	public class DrawPolyCmd {
		public static const ID:String = "DrawPoly";
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
		 * 多边形的点集合。
		 */
		public var points:Array;
		/**
		 * 填充颜色，或者填充绘图的渐变对象。
		 */
		public var fillColor:*;
		/**
		 * （可选）边框颜色，或者填充绘图的渐变对象。
		 */
		public var lineColor:*;
		/**
		 * 可选）边框宽度。
		 */
		public var lineWidth:Number;
		/**@private */
		public var isConvexPolygon:Boolean;
		/**@private */
		public var vid:int;
		
		/**@private */
		public static function create(x:Number, y:Number, points:Array, fillColor:*, lineColor:*, lineWidth:Number, isConvexPolygon:Boolean, vid:int):DrawPolyCmd {
			var cmd:DrawPolyCmd = Pool.getItemByClass("DrawPolyCmd", DrawPolyCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.points = points;
			cmd.fillColor = fillColor;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			cmd.isConvexPolygon = isConvexPolygon;
			cmd.vid = vid;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			points = null;
			fillColor = null;
			lineColor = null;
			Pool.recover("DrawPolyCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._drawPoly(x + gx, y + gy, points, fillColor, lineColor, lineWidth, isConvexPolygon, vid);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}