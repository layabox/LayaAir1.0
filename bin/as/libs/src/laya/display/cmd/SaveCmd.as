package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 存储命令，和restore配套使用
	 */
	public class SaveCmd {
		public static const ID:String = "Save";
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**@private */
		public static function create():SaveCmd {
			var cmd:SaveCmd = Pool.getItemByClass("SaveCmd", SaveCmd);
			
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("SaveCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.save();
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}