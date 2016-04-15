package laya.utils {
	
	/**
	 * 时钟管理类，单例，可以通过Laya.timer访问
	 * @author yung
	 */
	public class Timer {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**时针缩放*/
		public var scale:Number = 1;
		/**当前时间*/
		public var currTimer:Number = Browser.now();
		/**当前的帧数*/
		public var currFrame:int = 0;
		/**@private */
		private var _lastTimer:Number = Browser.now();
		/**@private */
		private var _mid:int = 1;
		/**@private */
		private var _map:Array = [];
		/**@private */
		private var _laters:Array = [];
		/**@private */
		private var _handlers:Array = [];
		/**@private */
		private var _temp:Array = [];
		/**@private */
		private var _pool:Array = [];
		/**@private */
		private var _count:int = 0;
		
		public static var DELTA:int = 0;
		
		public function Timer() {
			Laya.timer && Laya.timer.frameLoop(1, this, _update);
		}
		
		public function _update():void {
			if (scale <= 0) {
				_lastTimer = Browser.now();
				return;
			}
			var frame:int = this.currFrame = this.currFrame + scale;
			var now:Number = Browser.now()
			DELTA = now - _lastTimer;
			var timer:Number = this.currTimer = this.currTimer + DELTA * scale;
			_lastTimer = now;
			
			//处理handler
			var handlers:Array = this._handlers;
			_count = 0;
			for (i = 0, n = handlers.length; i < n; i++) {
				handler = handlers[i];
				if (handler.method !== null) {
					var t:int = handler.userFrame ? frame : timer;
					if (t >= handler.exeTime) {
						if (handler.repeat) {
							do {
								handler.exeTime += handler.delay;
								handler.run(false);
							} while (t >= handler.exeTime);
						} else {
							handler.run(true);
						}
					}
				} else {
					_count++;
				}
			}
			
			if (_count > 30 || frame % 200 === 0) _clearHandlers();
			
			//处理callLater
			var laters:Array = this._laters;
			for (var i:int = 0, n:int = laters.length - 1; i <= n; i++) {
				var handler:TimerHandler = laters[i];
				handler.method !== null && handler.run(false);
				_recoverHandler(handler);
				i === n && (n = laters.length - 1);
			}
			laters.length = 0;
		}
		
		private function _clearHandlers():void {
			var handlers:Array = this._handlers;
			for (var i:int = 0, n:int = handlers.length; i < n; i++) {
				var handler:TimerHandler = handlers[i];
				if (handler.method !== null) _temp.push(handler);
				else _recoverHandler(handler);
			}
			this._handlers = _temp;
			_temp = handlers;
			_temp.length = 0;
		}
		
		private function _recoverHandler(handler:TimerHandler):void {
			handler.clear();
			_map[handler.key] = null;
			_pool.push(handler);
		}
		
		public function _create(useFrame:Boolean, repeat:Boolean, delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = false):void {
			//如果延迟为0，则立即执行
			if (!delay) {
				method.apply(caller, args);
				return;
			}
			
			//先覆盖相同函数的计时
			if (coverBefore) {
				var handler:TimerHandler = _getHandler(caller, method);
				if (handler) {
					handler.repeat = repeat;
					handler.userFrame = useFrame;
					handler.delay = delay;
					handler.caller = caller;
					handler.method = method;
					handler.args = args;
					handler.exeTime = delay + (useFrame ? this.currFrame : this.currTimer);
					return;
				}
			}
			
			//找到一个空闲的timerHandler
			handler = _pool.length > 0 ? _pool.pop() : new TimerHandler();
			handler.repeat = repeat;
			handler.userFrame = useFrame;
			handler.delay = delay;
			handler.caller = caller;
			handler.method = method;
			handler.args = args;
			handler.exeTime = delay + (useFrame ? this.currFrame : this.currTimer);
			
			//索引handler
			_indexHandler(handler);
			
			//插入数组
			_handlers.push(handler);
		}
		
		private function _indexHandler(handler:TimerHandler):void {
			var caller:* = handler.caller;
			var method:* = handler.method;
			var cid:int = caller ? caller.$_GID || (caller.$_GID = Utils.getGID()) : 0;
			var mid:int = method.$_TID || (method.$_TID = (_mid++) * 100000);
			handler.key = cid + mid;
			_map[handler.key] = handler;
		}
		
		/**
		 * 定时执行一次
		 * @param	delay	延迟时间(单位毫秒)
		 * @param	caller	执行域(this)
		 * @param	method	定时器回调函数
		 * @param	args	回调参数
		 * @param	coverBefore	是否覆盖之前的延迟执行，默认为false
		 */
		public function once(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = false):void {
			_create(false, false, delay, caller, method, args, coverBefore);
		}
		
		/**
		 * 定时重复执行
		 * @param	delay	间隔时间(单位毫秒)
		 * @param	caller	执行域(this)
		 * @param	method	定时器回调函数
		 * @param	args	回调参数
		 * @param	coverBefore	是否覆盖之前的延迟执行，默认为false
		 */
		public function loop(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = false):void {
			_create(false, true, delay, caller, method, args, coverBefore);
		}
		
		/**
		 * 定时执行一次(基于帧率)
		 * @param	delay	延迟几帧(单位为帧)
		 * @param	caller	执行域(this)
		 * @param	method	定时器回调函数
		 * @param	args	回调参数
		 * @param	coverBefore	是否覆盖之前的延迟执行，默认为false
		 */
		public function frameOnce(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = false):void {
			_create(true, false, delay, caller, method, args, coverBefore);
		}
		
		/**
		 * 定时重复执行(基于帧率)
		 * @param	delay	间隔几帧(单位为帧)
		 * @param	caller	执行域(this)
		 * @param	method	定时器回调函数
		 * @param	args	回调参数
		 * @param	coverBefore	是否覆盖之前的延迟执行，默认为false
		 */
		public function frameLoop(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = false):void {
			_create(true, true, delay, caller, method, args, coverBefore);
		}
		
		/**输出统计信息*/
		public function toString():String {
			return "callLater:" + _laters.length + " handlers:" + _handlers.length + " pool:" + _pool.length;
		}
		
		/**
		 * 清理定时器
		 * @param	caller 执行域(this)
		 * @param	method 定时器回调函数
		 */
		public function clear(caller:*, method:Function):void {
			var handler:TimerHandler = _getHandler(caller, method);
			if (handler) {
				_map[handler.key] = null;
				handler.key = 0;
				handler.clear();
			}
		}
		
		/**
		 * 清理对象身上的所有定时器
		 * @param	caller 执行域(this)
		 */
		public function clearAll(caller:*):void {
			for (var i:int = 0, n:int = _handlers.length; i < n; i++) {
				var handler:TimerHandler = _handlers[i];
				if (handler.caller === caller) {
					_map[handler.key] = null;
					handler.key = 0;
					handler.clear();
				}
			}
		}
		
		private function _getHandler(caller:*, method:*):TimerHandler {
			var cid:int = caller ? caller.$_GID || (caller.$_GID = Utils.getGID()) : 0;
			var mid:int = method.$_TID || (method.$_TID = (_mid++) * 100000);
			return _map[cid + mid];
		}
		
		/**
		 * 延迟执行
		 * @param	caller 执行域(this)
		 * @param	method 定时器回调函数
		 * @param	args 回调参数
		 */
		public function callLater(caller:*, method:Function, args:Array = null):void {
			if (_getHandler(caller, method) == null) {
				//trace(caller, method);
				//找到一个空闲的timerHandler
				if (_pool.length) var handler:TimerHandler = _pool.pop();
				else handler = new TimerHandler();
				//设置属性
				handler.caller = caller;
				handler.method = method;
				handler.args = args;
				//索引handler
				_indexHandler(handler);
				//插入队列
				_laters.push(handler);
			}
		}
		
		/**
		 * 立即执行callLater
		 * @param	caller 执行域(this)
		 * @param	method 定时器回调函数
		 */
		public function runCallLater(caller:*, method:Function):void {
			var handler:TimerHandler = _getHandler(caller, method);
			if (handler && handler.method != null) {
				handler.run(true);
				_map[handler.key] = null;
			}
		}
	}
}

class TimerHandler {
	public var key:int;
	public var repeat:Boolean;
	public var delay:int;
	public var userFrame:Boolean;
	public var exeTime:int;
	public var caller:*
	public var method:Function;
	public var args:Array;
	
	public function clear():void {
		caller = null;
		method = null;
		args = null;
	}
	
	public function run(widthClear:Boolean):void {
		var caller:* = this.caller;
		if (caller && caller.destroyed) return clear();
		var method:Function = this.method;
		var args:Array = this.args;
		widthClear && clear();
		if (method == null) return;
		args ? method.apply(caller, args) : method.call(caller);
	}
}