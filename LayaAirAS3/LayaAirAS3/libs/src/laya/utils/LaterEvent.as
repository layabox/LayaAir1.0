package laya.utils {
	
	/**
	 * <code>LaterEvent</code> 延迟事件。
	 */
	public class LaterEvent {
		private static var _cache:Array =/*[STATIC SAFE]*/ (_cache = [], _cache._length = 0, _cache);
		private static var _events:Array = /*[STATIC SAFE]*/ (_events = [], _events._length = 0, _events);
		
		/** 每帧回调最大超时时间。*/
		public static var maxTimeOut:int = 30;
		
		/**
		 * 创建一个 <code>LaterEvent</code> 类的实例。
		 */
		public function LaterEvent() {
		
		}
		
		/**
		 * 添加需要延迟执行的函数。
		 * @param	caller 函数作用域。
		 * @param	fun 函数。
		 * @param	args 参数。
		 * @param	msg 函数信息。
		 */
		public static function add(caller:*, fun:Function, args:*, msg:String):void {
			var o:LaterOneEvent = _cache._length ? _cache[--_cache._length] : new LaterOneEvent();
			o.caller = caller;
			o.fun = fun;
			o.args = args;
			o.msg = msg;
			_events[_events._length++] = o;
		}
		
		/**
		 * 更新。
		 */
		public static function update():void {
			if (_events.length < 1) return;
			var sz:int = _events._length;
			var startTimer:Number = Browser.now();
			for (var i:int = 0; i < sz; i++) {
				var o:LaterOneEvent = _events[i];
				o.fun.call(o.caller, o.args);
				_cache[_cache._length++] = o;
				if (Browser.now() - startTimer > maxTimeOut) {
					trace("LaterEvent use long time:" + (Browser.now() - startTimer) + ")" + sz + " " + o.msg);
					_events.splice(0, i + 1);
					_events._length -= i + 1;
					return;
				}
			}
			if (sz != _events._length) {
				_events.splice(0, sz);
				_events._length -= sz;
			} else _events._length = 0;
		}
	}

}

/** @private */
class LaterOneEvent {
	public var caller:*;
	public var fun:Function;
	public var args:*;
	public var msg:String;
}