package laya.utils {
	
	/**
	 * <code>Log</code> 类用于显示日志记录信息。
	 */
	public class Log {
		/**@private */
		private static var _logdiv:*;
		
		/**
		 * 开始显示日志模块。
		 */
		public static function start():void {
			_logdiv = Browser.window.document.createElement('div');
			Browser.window.document.body.appendChild(_logdiv);
			_logdiv.style.cssText = "border:white;overflow:scroll;z-index:1000000;background:rgba(100,100,100,0.7);color:white;position: absolute;left:0px;top:0px;width:100%;height:50%";
			_logdiv.onclick = function():void {
				if (parseInt(this.style.width) == 30) {
					this.style.width = '100%';
					this.style.height = "50%";
					this.style.overflow = "scroll"
					this.style.background = "rgba(100,100,100,0.7)"
				} else {
					this.style.width = this.style.height = "30px";
					this.style.overflow = "hidden";
					this.style.background = "white"
				}
			}
		}
		
		/**
		 * 增加日志内容。
		 * @param	value 需要增加的日志内容。
		 */
		public static function print(value:String):void {
			if (!_logdiv) {
				//trace(value);
				return;
			}
			_logdiv.innerText += value + "\n";
		}
		
		/**
		 * 表示日志模块是否被实例化。
		 * @return 日志模块是否被实例化。
		 */
		public static function enable():Boolean {
			return _logdiv != null;
		}
	
	}

}