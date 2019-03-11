package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 透明命令
	 */
	public class AlphaCmd {
		public static const ID:String = "Alpha";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 透明度
		 */
		public var alpha:Number;
		
		/**@private */
		public static function create(alpha:Number):AlphaCmd {
			var cmd:AlphaCmd = Pool.getItemByClass("AlphaCmd", AlphaCmd);
			cmd.alpha = alpha;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {			
			Pool.recover("AlphaCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.alpha(alpha);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	}
}