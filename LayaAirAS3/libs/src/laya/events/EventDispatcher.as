package laya.events {
	import laya.utils.Handler;
	
	/**
	 * 事件调度类
	 * @author yung
	 */
	public class EventDispatcher {
		/**@private */
		public static const MOUSE_EVENTS:Object =/*[STATIC SAFE]*/ {"rightmousedown": true, "rightmouseup": true, "rightclick": true, "mousedown": true, "mouseup": true, "mousemove": true, "mouseover": true, "mouseout": true, "click": true, "doubleclick": true};
		/**@private */
		private var _events:Object;
		
		/**
		 * 是否有某种事件监听
		 * @param	type 事件名称
		 * @return	是否有某种事件监听
		 */
		public function hasListener(type:String):Boolean {
			var listener:Object = this._events && this._events[type];
			return !!listener;
		}
		
		/**
		 * 发送事件
		 * @param	type 事件类型
		 * @param	data 回调数据，可以是单数据或者Array(作为多参)
		 * @return	如果没有监听者，则返回false，否则true
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
						data != null ? listener.runWith(data) : listener.run();
					}
					if (!listener || listener.once) {
						listeners.splice(i, 1);
						i--;
						n--;
					}
				}
				if (listeners.length === 0) delete this._events[type];
			}
			
			return true;
		}
		
		/**
		 * 增加事件监听
		 * @param	type 事件类型，可以参考Event类定义
		 * @param	caller 执行域(this域)，默认为监听对象的this域
		 * @param	listener 回调方法，如果为空，则移除所有type类型的事件监听
		 * @param	args 回调参数
		 * @return	返回对象本身
		 */
		public function on(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			return _createListener(type, caller, listener, args, false);
		}
		
		/**
		 * 增加一次性事件监听，执行后会自动移除监听
		 * @param	type 事件类型，可以参考Event类定义
		 * @param	caller 执行域(this域)，默认为监听对象的this域
		 * @param	listener 回调方法，如果为空，则移除所有type类型的事件监听
		 * @param	args 回调参数
		 * @return	返回对象本身
		 */
		public function once(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher {
			return _createListener(type, caller, listener, args, true);
		}
		
		private function _createListener(type:String, caller:*, listener:Function, args:Array, once:Boolean):EventDispatcher {
			//移除之前相同的监听
			off(type, caller, listener, once);
			
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
		 * 移除事件监听，同removeListener方法
		 * @param	type 事件类型，可以参考Event类定义
		 * @param	caller 执行域(this域)，默认为监听对象的this域
		 * @param	listener 回调方法，如果为空，则移除所有type类型的事件监听
		 * @param	onceOnly 是否只移除once监听，默认为false
		 * @return	返回对象本身
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
		 * 移除某类型所有事件监听
		 * @param	type 事件类型，如果为空，则移除本对象所有事件监听
		 * @return	返回对象本身
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
		 * 是否是鼠标事件
		 * @param	type 事件类型
		 * @return	是否鼠标事件
		 */
		public function isMouseEvent(type:String):Boolean {
			return MOUSE_EVENTS[type];
		}
	}
}
import laya.utils.Handler;

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
	 * 从对象池内创建一个Handler，默认会执行一次回收，如果不需要自动回收，设置once参数为false
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
