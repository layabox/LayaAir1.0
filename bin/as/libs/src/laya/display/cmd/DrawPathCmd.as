package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 根据路径绘制矢量图形
	 */
	public class DrawPathCmd {
		public static const ID:String = "DrawPath";
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
		 * 路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
		 */
		public var paths:Array;
		/**
		 * （可选）刷子定义，支持以下设置{fillStyle:"#FF0000"}。
		 */
		public var brush:Object;
		/**
		 * （可选）画笔定义，支持以下设置{strokeStyle,lineWidth,lineJoin:"bevel|round|miter",lineCap:"butt|round|square",miterLimit}。
		 */
		public var pen:Object;
		
		/**@private */
		public static function create(x:Number, y:Number, paths:Array, brush:Object, pen:Object):DrawPathCmd {
			var cmd:DrawPathCmd = Pool.getItemByClass("DrawPathCmd", DrawPathCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.paths = paths;
			cmd.brush = brush;
			cmd.pen = pen;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			paths = null;
			brush = null;
			pen = null;
			Pool.recover("DrawPathCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._drawPath(x + gx, y + gy, paths, brush, pen);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}