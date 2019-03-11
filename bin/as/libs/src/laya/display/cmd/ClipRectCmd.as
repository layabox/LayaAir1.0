package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 裁剪命令
	 */
	public class ClipRectCmd {
		public static const ID:String = "ClipRect";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**
		 * X 轴偏移量。
		 */
		public var x:Number;
		/**
		 * Y 轴偏移量。
		 */
		public var y:Number;
		/**
		 * 宽度。
		 */
		public var width:Number;
		/**
		 * 高度。
		 */
		public var height:Number;
		
		/**@private */
		public static function create(x:Number, y:Number, width:Number, height:Number):ClipRectCmd {
			var cmd:ClipRectCmd = Pool.getItemByClass("ClipRectCmd", ClipRectCmd);
			cmd.x = x;
			cmd.y = y;
			cmd.width = width;
			cmd.height = height;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("ClipRectCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.clipRect(x + gx, y + gy, width, height);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}