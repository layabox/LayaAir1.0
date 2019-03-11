package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 恢复命令，和save配套使用
	 */
	public class RestoreCmd {
		public static const ID:String = "Restore";
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**@private */
		public static function create():RestoreCmd {
			var cmd:RestoreCmd = Pool.getItemByClass("RestoreCmd", RestoreCmd);
			
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("RestoreCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.restore();
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}