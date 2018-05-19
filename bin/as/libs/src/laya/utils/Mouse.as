package laya.utils {
	
	/**
	 * <code>Mouse</code> 类用于控制鼠标光标。
	 */
	public class Mouse {
		/**@private */
		private static var _style:Object = Browser.document.body.style;
		/**@private */
		private static var _preCursor:String;
		
		public function Mouse() {
		
		}
		
		/**
		 * 设置鼠标样式
		 * @param cursorStr
		 * 例如auto move no-drop col-resize
		 * all-scroll pointer not-allowed row-resize
		 * crosshair progress e-resize ne-resize
		 * default text n-resize nw-resize
		 * help vertical-text s-resize se-resize
		 * inherit wait w-resize sw-resize
		 *
		 */
		public static function set cursor(cursorStr:String):void {
			_style.cursor = cursorStr;
		}
		
		public static function get cursor():String {
			return _style.cursor;
		}
		
		/**
		 * 隐藏鼠标
		 *
		 */
		public static function hide():void {
			if (cursor != "none") {
				_preCursor = cursor;
				cursor = "none";
			}
		}
		
		/**
		 * 显示鼠标
		 *
		 */
		public static function show():void {
			if (cursor == "none") {
				if (_preCursor) {
					cursor = _preCursor;
				} else {
					cursor = "auto";
				}
			}
		}
	}

}