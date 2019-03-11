package laya.utils {
	
	/**
	 * <code>Log</code> 类用于在界面内显示日志记录信息。
	 * 注意：在加速器内不可使用
	 */
	public class Log {
		
		/**@private */
		private static var _logdiv:*;
		/**@private */
		private static var _btn:*;
		/**@private */
		private static var _count:int = 0;
		/**最大打印数量，超过这个数量，则自动清理一次，默认为50次*/
		public static var maxCount:int = 50;
		/**是否自动滚动到底部，默认为true*/
		public static var autoScrollToBottom:Boolean = true;
		
		/**
		 * 激活Log系统，使用方法Laya.init(800,600,Laya.Log);
		 */
		public static function enable():void {
			if (!_logdiv) {
				_logdiv = Browser.createElement('div');
				_logdiv.style.cssText = "border:white;padding:4px;overflow-y:auto;z-index:1000000;background:rgba(100,100,100,0.6);color:white;position: absolute;left:0px;top:0px;width:50%;height:50%;";
				Browser.document.body.appendChild(_logdiv);
				
				_btn = Browser.createElement("button");
				_btn.innerText = "Hide";
				_btn.style.cssText = "z-index:1000001;position: absolute;left:10px;top:10px;";
				_btn.onclick = toggle;
				Browser.document.body.appendChild(_btn);
			}
		}
		
		/**隐藏/显示日志面板*/
		public static function toggle():void {
			var style:* = _logdiv.style;
			if (style.display === "") {
				_btn.innerText = "Show";
				style.display = "none";
			} else {
				_btn.innerText = "Hide";
				style.display = "";
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
				if (autoScrollToBottom) {
					if (_logdiv.scrollHeight - _logdiv.scrollTop - _logdiv.clientHeight < 50) {
						_logdiv.scrollTop = _logdiv.scrollHeight;
					}
				}
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