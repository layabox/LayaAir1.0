/*[IF-FLASH]*/
package laya.flash
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import laya.events.Event;
	
	/**
	 * ...
	 * @author laya
	 */
	public class FlashEvent
	{
		public static var map:Object = {};
		private static var _listenerMap:Dictionary = new Dictionary();
		
		public static function __init__():void
		{
			map[Event.MOUSE_DOWN] = MouseEvent.MOUSE_DOWN;
			map[Event.MOUSE_UP] = MouseEvent.MOUSE_UP;
			map[Event.CLICK] = MouseEvent.CLICK;
			map[Event.MOUSE_MOVE] = MouseEvent.MOUSE_MOVE;
			map[Event.MOUSE_OVER] = MouseEvent.MOUSE_OVER;
			map[Event.DOUBLE_CLICK] = MouseEvent.DOUBLE_CLICK;
			map[Event.KEY_DOWN] = KeyboardEvent.KEY_DOWN;
			map[Event.KEY_UP] = KeyboardEvent.KEY_UP;
			map[Event.RIGHT_MOUSE_DOWN] = MouseEvent.RIGHT_MOUSE_DOWN;
			map[Event.RIGHT_MOUSE_UP] = MouseEvent.RIGHT_MOUSE_UP;
			map[Event.MOUSE_WHEEL] = MouseEvent.MOUSE_WHEEL;
		}
		
		public static function addEventListener(caller:*, type:String, listener:Function, useCapture:Boolean = false):void
		{
			var typeFlash:String = map[type];
			if (typeFlash)
			{
				listener = getListenerCallback(type, listener);
				if (caller == Window.stage && type == Event.MOUSE_DOWN)
				{
					caller.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, listener);
				}
				else if (caller == Window.stage && type == Event.MOUSE_UP)
				{
					caller.addEventListener(MouseEvent.RIGHT_MOUSE_UP, listener);
				}
				caller.addEventListener(typeFlash, listener);
			}
			else caller.addEventListener(type, listener, useCapture);
		}
		
		public static function removeEventListener(caller:*, type:String, listener:Function, useCapture:Boolean = false):void
		{
			type = map[type] || type;
			listener = _listenerMap[listener] ? _listenerMap[listener] : listener;
			caller.removeEventListener(type, listener, useCapture);
		}
		
		private static function getListenerCallback(type:String, listener:Function):Function
		{
			var retVal:Function = function(e:*):void
			{
				if (e is MouseEvent)
				{
					var e2:* = {type: type, clientX: e.stageX, clientY: e.stageY, button: 0,wheelDelta:0,detail:0};
					if (e.type == MouseEvent.RIGHT_MOUSE_DOWN)
					{
						e2.button = 2;
						e2.type = Event.MOUSE_DOWN;
					}
					if (e.type == MouseEvent.RIGHT_MOUSE_UP)
					{
						e2.button = 2;
						e2.type = Event.MOUSE_UP;
					}
					if(e.type ==MouseEvent.MOUSE_WHEEL)
					{
						e2.wheelDelta =e.delta*120;
					}
					e2.preventDefault = function():void
					{
						e.preventDefault();
					}
					listener.call(null, e2);
				}
				else
				{
					listener.call(null, e);
				}
			}
			
			_listenerMap[listener] = retVal;
			
			return retVal;
		}
	}

}
