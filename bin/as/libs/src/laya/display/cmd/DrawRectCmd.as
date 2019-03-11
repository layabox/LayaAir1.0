package laya.display.cmd {
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	
	/**
	 * 绘制矩形
	 */
	public class DrawRectCmd {
		public static const ID:String = "DrawRect";
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
		 * 矩形宽度。
		 */
		public var width:Number;
		/**
		 * 矩形高度。
		 */
		public var height:Number;
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
		public static function create(x:Number, y:Number, width:Number, height:Number, fillColor:*, lineColor:*, lineWidth:Number):DrawRectCmd {
			var cmd:DrawRectCmd = Pool.getItemByClass("DrawRectCmd", DrawRectCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.width = width;
			cmd.height = height;
			cmd.fillColor = fillColor;
			cmd.lineColor = lineColor;
			cmd.lineWidth = lineWidth;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			fillColor = null;
			lineColor = null;
			Pool.recover("DrawRectCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawRect(x + gx, y + gy, width, height, fillColor, lineColor, lineWidth);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}