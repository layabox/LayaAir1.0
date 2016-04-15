package laya.events {
	import laya.display.Node;
	import laya.utils.Browser;
	
	/**
	 * 键盘事件管理类
	 * 该类从浏览器中接收键盘事件，并转发该事件
	 * 转发事件时若Stage.focus为空则只从Stage上派发该事件，不然将从Stage.focus对象开始一直冒泡派发该事件
	 * 所以在Laya.stage上监听键盘事件一定能够收到，如果在其他地方监听，则必须处在Stage.focus的冒泡链上才能收到该事件
	 * 用户可以通过代码Laya.stage.focus=someNode的方式来设置focus对象
	 * 用户可统一的根据事件对象中 e.keyCode来判断按键类型，该属性兼容了不同浏览器的实现
	 * 其他事件属性可自行从 e 中获取
	 * @author ww
	 * @version 1.0
	 * @created  2015-9-23 上午10:57:26
	 */
	public class KeyBoardManager {
		private static var pressKeys:Object = {};
		
		/** @private */
		public static function __init__():void {
			addEvent("keydown");
			addEvent("keypress");
			addEvent("keyup");
		}
		
		private static function addEvent(type:String):void {
			Browser.document.addEventListener(type, function(e:*):void {
				KeyBoardManager.dispatch(e, type);
			}, true);
		}
		
		private static function dispatch(e:Object, type:String):void {
			e.keyCode = e.keyCode || e.which || e.charCode;
			
			//判断同时按下的键
			if (type === "keydown") pressKeys[e.keyCode] = true;
			else if (type === "keyup") pressKeys[e.keyCode] = null;
			
			var tar:Node = (Laya.stage.focus && (Laya.stage.focus.event != null)) ? Laya.stage.focus : Laya.stage;
			while (tar) {
				tar.event(type, e);
				tar = tar.parent;
			}
		}
		
		/**
		 * 某个键是否被按下
		 * @param	key 键值
		 * @return
		 */
		public static function hasKeyDown(key:int):Boolean {
			return pressKeys[key];
		}
	}
}