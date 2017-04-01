package laya.events {
	import laya.utils.Handler;
	
	/**
	 * <code>EventDispatcher</code> 类是可调度事件的所有类的基类。
	 */
	public class EventDispatcher {
		/**@private */
		public static const MOUSE_EVENTS:Object =/*[STATIC SAFE]*/ {"rightmousedown": true, "rightmouseup": true, "rightclick": true, "mousedown": true, "mouseup": true, "mousemove": true, "mouseover": true, "mouseout": true, "click": true, "doubleclick": true};
		/**@private */
		private var _events:Object;
		
		//[IF-JS]Object.defineProperty(EventDispatcher.prototype, "_events", {enumerable: false,writable:true});
		
		/**
		 * 检查 EventDispatcher 对象是否为特定事件类型注册了任何侦听器。
		 * @param	type 事件的类型。
		 * @return 如果指定类型的侦听器已注册，则值为 true；否则，值为 false。
		 */
		public function hasListener(type:String):Boolean {
			var listener:Object = this._events && this._events[type];
			return !!listener;
		}
		
		/**
		 * 派发事件。
		 * @param	type 事件类型。
		 * @param	data 回调数据。
		 * 				<b>注意：</b>如果是需要传递多个参数 p1,p2,p3,...可以使用数组结构如：[p1,p2,p3,...] ；如果需要回调单个参数 p 是一个数组，则需要使用结构如：[p]，其他的单个参数 p ，可以直接传入参数 p。
		 * @return 此事件类型是否有侦听者，如果有侦听者则值为 true，否则值为 false。
		 */
		public function event(type:String, data:* = null):Boolean {
			if (!this._events || !this._events[type]) return false;
			
			var listeners:* = this._events[type];
			if (listeners.run) {
				if (listeners.once) delete this._events[type];
				data != null ? listeners.runWith(data) : listeners.run();
			} else {
				for (var i:int = 0, n:int = listeners.length; i < n; i++) {
					var listener:Handler = listeners[i];
					if (listener) {
						(data != null) ? listener.runWith(data) : listener.run();
					}
					if (!listener || listener.once) {
						listeners.splice(i, 1);
						i--;
						n--;
					}
				}
				if (listeners.length === 0 && _events) delete this._events[type];
			}
			
			return true;
		}
		
		/**
		 * 使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知。
		 * @param	type 事件的类型。
		 * @param	caller 事件侦听函数的执行域。
		 * @param	listener 事件侦听函数。
		 * @param	args 事件侦听函数的回调参数。
		 * @return 此 EventDispatcher 对象。
		 */
		public function on(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			return _createListener(type, caller, listener, args, false);
		}
		
		/**
		 * 使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知，此侦听事件响应一次后自动移除。
		 * @param	type 事件的类型。
		 * @param	caller 事件侦听函数的执行域。
		 * @param	listener 事件侦听函数。
		 * @param	args 事件侦听函数的回调参数。
		 * @return 此 EventDispatcher 对象。
		 */
		public function once(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			return _createListener(type, caller, listener, args, true);
		}
		
		/**@private */
		public function _createListener(type:String, caller:*, listener:Function, args:Array, once:Boolean, offBefore:Boolean = true):EventDispatcher {
			//移除之前相同的监听
			offBefore && off(type, caller, listener, once);
			
			//使用对象池进行创建回收
			var handler:Handler = EventHandler.create(caller || this, listener, args, once);
			this._events || (this._events = {});
			
			var events:* = this._events;
			//默认单个，每个对象只有多个监听才用数组，节省一个数组的消耗
			if (!events[type]) events[type] = handler;
			else {
				if (!events[type].run) events[type].push(handler);
				else events[type] = [events[type], handler];
			}
			return this;
		}
		
		/**
		 * 从 EventDispatcher 对象中删除侦听器。
		 * @param	type 事件的类型。
		 * @param	caller 事件侦听函数的执行域。
		 * @param	listener 事件侦听函数。
		 * @param	onceOnly 如果值为 true ,则只移除通过 once 方法添加的侦听器。
		 * @return 此 EventDispatcher 对象。
		 */
		public function off(type:String, caller:*, listener:Function, onceOnly:Boolean = false):EventDispatcher {
			if (!this._events || !this._events[type]) return this;
			
			var listeners:Object = this._events[type];
			if (listener != null) {
				if (listeners.run) {
					if ((!caller || listeners.caller === caller) && listeners.method === listener && (!onceOnly || listeners.once)) {
						delete this._events[type];
						listeners.recover();
					}
				} else {
					var count:int = 0;
					for (var i:int = 0, n:int = listeners.length; i < n; i++) {
						var item:Handler = listeners[i];
						if (item && (!caller || item.caller === caller) && item.method === listener && (!onceOnly || item.once)) {
							count++;
							listeners[i] = null;
							item.recover();
						}
					}
					//如果全部移除，则删除索引
					if (count === n) delete this._events[type];
				}
			}
			
			return this;
		}
		
		/**
		 * 从 EventDispatcher 对象中删除指定事件类型的所有侦听器。
		 * @param	type 事件类型，如果值为 null，则移除本对象所有类型的侦听器。
		 * @return 此 EventDispatcher 对象。
		 */
		public function offAll(type:String = null):EventDispatcher {
			var events:Object = this._events;
			if (!events) return this;
			if (type) {
				_recoverHandlers(events[type]);
				delete events[type];
			} else {
				for (var name:String in events) {
					_recoverHandlers(events[name]);
				}
				this._events = null;
			}
			return this;
		}
		
		private function _recoverHandlers(arr:*):void {
			if (!arr) return;
			if (arr.run) {
				arr.recover();
			} else {
				for (var i:int = arr.length - 1; i > -1; i--) {
					if (arr[i]) {
						arr[i].recover();
						arr[i] = null;
					}
				}
			}
		}
		
		/**
		 * 检测指定事件类型是否是鼠标事件。
		 * @param	type 事件的类型。
		 * @return	如果是鼠标事件，则值为 true;否则，值为 false。
		 */
		public function isMouseEvent(type:String):Boolean {
			return MOUSE_EVENTS[type];
		}
	}
}
import laya.utils.Handler;

/**@private */
class EventHandler extends Handler {
	
	/**@private handler对象池*/
	private static var _pool:Array = [];
	
	public function EventHandler(caller:*, method:Function, args:Array, once:Boolean) {
		super(caller, method, args, once);
	}
	
	override public function recover():void {
		if (_id > 0) {
			_id = 0;
			_pool.push(clear());
		}
	}
	
	/**
	 * 从对象池内创建一个Handler，默认会执行一次回收，如果不需要自动回收，设置once参数为false 。
	 * @param	caller 执行域(this)
	 * @param	method 回调方法
	 * @param	args 携带的参数
	 * @param	once 是否只执行一次，如果为true，回调后执行recover()进行回收，默认为true
	 * @return  返回创建的handler实例
	 */
	public static function create(caller:*, method:Function, args:Array = null, once:Boolean = true):Handler {
		if (_pool.length) return _pool.pop().setTo(caller, method, args, once);
		return new EventHandler(caller, method, args, once);
	}
}
