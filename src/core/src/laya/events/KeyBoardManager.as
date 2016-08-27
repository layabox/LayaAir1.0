package laya.events {
	import laya.display.Node;
	import laya.utils.Browser;
	
	/**
	 * <p><code>KeyBoardManager</code> 是键盘事件管理类。</p>
	 * <p>该类从浏览器中接收键盘事件，并派发该事件。
	 * 派发事件时若 Stage.focus 为空则只从 Stage 上派发该事件，否则将从 Stage.focus 对象开始一直冒泡派发该事件。
	 * 所以在 Laya.stage 上监听键盘事件一定能够收到，如果在其他地方监听，则必须处在Stage.focus的冒泡链上才能收到该事件。</p>
	 * <p>用户可以通过代码 Laya.stage.focus=someNode 的方式来设置focus对象。</p>
	 * <p>用户可统一的根据事件对象中 e.keyCode 来判断按键类型，该属性兼容了不同浏览器的实现。</p>
	 */
	public class KeyBoardManager {
		private static var _pressKeys:Object = {};
		
		/**是否开启键盘事件，默认为true*/
		public static var enabled:Boolean = true;
		/** @private */
		public static var _event:Event = new Event();
		
		/** @private */
		public static function __init__():void {
			_addEvent("keydown");
			_addEvent("keypress");
			_addEvent("keyup");
		}
		
		private static function _addEvent(type:String):void {
			Browser.document.addEventListener(type, function(e:*):void {
				KeyBoardManager._dispatch(e, type);
			}, true);
		}
		
		private static function _dispatch(e:Object, type:String):void {
			if (!enabled) return;
			_event._stoped = false;
			_event.nativeEvent = e;
			_event.keyCode = e.keyCode || e.which || e.charCode;
			//判断同时按下的键
			if (type === "keydown") _pressKeys[_event.keyCode] = true;
			else if (type === "keyup") _pressKeys[_event.keyCode] = null;
			
			var target:* = (Laya.stage.focus && (Laya.stage.focus.event != null)) ? Laya.stage.focus : Laya.stage;
			var ct:* = target;
			while (ct) {
				ct.event(type, _event.setTo(type, ct, target));
				ct = ct.parent;
			}
		}
		
		/**
		 * 返回指定键是否被按下。
		 * @param	key 键值。
		 * @return 是否被按下。
		 */
		public static function hasKeyDown(key:int):Boolean {
			return _pressKeys[key];
		}
	}
}