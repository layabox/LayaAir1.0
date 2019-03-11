package laya.display.cmd {
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.utils.Pool;
	/**
	 * 缩放命令
	 */
	public class ScaleCmd {
		public static const ID:String = "Scale";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 水平方向缩放值。
		 */
		public var scaleX:Number;
		/**
		 * 垂直方向缩放值。
		 */
		public var scaleY:Number;
		/**
		 * （可选）水平方向轴心点坐标。
		 */
		public var pivotX:Number;
		/**
		 * （可选）垂直方向轴心点坐标。
		 */
		public var pivotY:Number;
		
		/**@private */
		public static function create(scaleX:Number, scaleY:Number, pivotX:Number, pivotY:Number):ScaleCmd {
			var cmd:ScaleCmd = Pool.getItemByClass("ScaleCmd", ScaleCmd);
			cmd.scaleX = scaleX;
			cmd.scaleY = scaleY;
			cmd.pivotX = pivotX;
			cmd.pivotY = pivotY;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("ScaleCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._scale(scaleX, scaleY, pivotX + gx, pivotY + gy);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}