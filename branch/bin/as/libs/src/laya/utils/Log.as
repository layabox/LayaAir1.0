package laya.utils {
	
	/**
	 * <code>Log</code> 类用于在界面内显示日志记录信息。
	 */
	public class Log {
		
		/**@private */
		private static var _logdiv:*;
		/**@private */
		private static var _count:int = 0;
		/**最大打印数量，超过这个数量，则自动清理一次*/
		public static var maxCount:int = 20;
		
		/**
		 * 激活Log系统，使用方法Laya.init(800,600,Laya.Log);
		 */
		public static function enable():void {
			if (!_logdiv) {
				_logdiv = Browser.window.document.createElement('div');
				Browser.window.document.body.appendChild(_logdiv);
				_logdiv.style.cssText = "pointer-events:none;border:white;overflow:hidden;z-index:1000000;background:rgba(100,100,100,0.6);color:white;position: absolute;left:0px;top:0px;width:50%;height:50%;";
			}
		}
		
		/**隐藏/显示日志面板*/
		public static function toggle():void {
			var style:* = _logdiv.style;
			if (style.width == "1px") {
				style.width = style.height = "50%";
			} else {
				style.width = style.height = "1px";
			}
		}
		
		/**
		 * 增加日志内容。
		 * @param	value 需要增加的日志内容。
		 */
		public static function print(value:String):void {
			if (_logdiv) {
				//内容太多清理掉
				if (_count >= maxCount) clear();
				_count++;
				
				_logdiv.innerText += value + "\n";
				//自动滚动
				_logdiv.scrollTop = _logdiv.scrollHeight;
			}
		}
		
		/**
		 * 清理日志
		 */
		public static function clear():void {
			_logdiv.innerText = "";
			_count = 0;
		}
	}
}