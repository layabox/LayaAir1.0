package laya.utils {
	
	/**
	 * <code>Timer</code> 是时钟管理类。它是一个单例，不要手动实例化此类，应该通过 Laya.timer 访问。
	 */
	public class Timer {
		
		/**@private */
		private static var _pool:Array = [];
		/**@private */
		public static var _mid:int = 1;
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/** 时针缩放。*/
		public var scale:Number = 1;
		/** 当前帧开始的时间。*/
		public var currTimer:Number = Browser.now();
		/** 当前的帧数。*/
		public var currFrame:int = 0;
		/**@private 两帧之间的时间间隔,单位毫秒。*/
		public var _delta:int = 0;
		/**@private */
		public var _lastTimer:Number = Browser.now();
		/**@private */
		private var _map:Array = [];
		/**@private */
		private var _handlers:Array = [];
		/**@private */
		private var _temp:Array = [];
		/**@private */
		private var _count:int = 0;
		
		/**
		 * 创建 <code>Timer</code> 类的一个实例。
		 */
		public function Timer(autoActive:Boolean = true) {
			autoActive && Laya.systemTimer && Laya.systemTimer.frameLoop(1, this, _update);
		}
		
		/**两帧之间的时间间隔,单位毫秒。*/
		public function get delta():int {
			return _delta;
		}
		
		/**
		 * @private
		 * 帧循环处理函数。
		 */
		public function _update():void {
			if (scale <= 0) {
				_lastTimer = Browser.now();
				return;
			}
			var frame:int = this.currFrame = this.currFrame + scale;
			var now:Number = Browser.now();
			_delta = (now - _lastTimer) * scale;
			var timer:Number = this.currTimer = this.currTimer + _delta;
			_lastTimer = now;
			
			//处理handler
			var handlers:Array = this._handlers;
			_count = 0;
			for (var i:int = 0, n:int = handlers.length; i < n; i++) {
				var handler:TimerHandler = handlers[i];
				if (handler.method !== null) {
					var t:int = handler.userFrame ? frame : timer;
					if (t >= handler.exeTime) {
						if (handler.repeat) {
							if (!handler.jumpFrame) {
								handler.exeTime += handler.delay;
								handler.run(false);
								if (t > handler.exeTime) {
									//如果执行一次后还能再执行，做跳出处理，如果想用多次执行，需要设置jumpFrame=true
									handler.exeTime += Math.ceil((t - handler.exeTime) / handler.delay) * handler.delay;
								}
							} else {
								while (t >= handler.exeTime) {
									handler.exeTime += handler.delay;
									handler.run(false);
								}
							}
						} else {
							handler.run(true);
						}
					}
				} else {
					_count++;
				}
			}
			
			if (_count > 30 || frame % 200 === 0) _clearHandlers();
		}
		
		/** @private */
		private function _clearHandlers():void {
			var handlers:Array = this._handlers;
			for (var i:int = 0, n:int = handlers.length; i < n; i++) {
				var handler:TimerHandler = handlers[i];
				if (handler.method !== null) _temp.push(handler);
				else _recoverHandler(handler);
			}
			this._handlers = _temp;
			handlers.length = 0;
			_temp = handlers;
		}
		
		/** @private */
		private function _recoverHandler(handler:TimerHandler):void {
			if (_map[handler.key] == handler) _map[handler.key] = null;
			handler.clear();
			_pool.push(handler);
		}
		
		/** @private */
		public function _create(useFrame:Boolean, repeat:Boolean, delay:int, caller:*, method:Function, args:Array, coverBefore:Boolean):TimerHandler {
			//如果延迟为0，则立即执行
			if (!delay) {
				method.apply(caller, args);
				return null;
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
					handler.exeTime = delay + (useFrame ? this.currFrame : this.currTimer + Browser.now() - _lastTimer);
					return handler;
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
			handler.exeTime = delay + (useFrame ? this.currFrame : this.currTimer + Browser.now() - _lastTimer);
			
			//索引handler
			_indexHandler(handler);
			
			//插入数组
			_handlers.push(handler);
			
			return handler;
		}
		
		/** @private */
		private function _indexHandler(handler:TimerHandler):void {
			var caller:* = handler.caller;
			var method:* = handler.method;
			var cid:int = caller ? caller.$_GID || (caller.$_GID = Utils.getGID()) : 0;
			var mid:int = method.$_TID || (method.$_TID = (_mid++) * 100000);
			handler.key = cid + mid;
			_map[handler.key] = handler;
		}
		
		/**
		 * 定时执行一次。
		 * @param	delay	延迟时间(单位为毫秒)。
		 * @param	caller	执行域(this)。
		 * @param	method	定时器回调函数。
		 * @param	args	回调参数。
		 * @param	coverBefore	是否覆盖之前的延迟执行，默认为 true 。
		 */
		public function once(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = true):void {
			_create(false, false, delay, caller, method, args, coverBefore);
		}
		
		/**
		 * 定时重复执行。
		 * @param	delay	间隔时间(单位毫秒)。
		 * @param	caller	执行域(this)。
		 * @param	method	定时器回调函数。
		 * @param	args	回调参数。
		 * @param	coverBefore	是否覆盖之前的延迟执行，默认为 true 。
		 * @param	jumpFrame 时钟是否跳帧。基于时间的循环回调，单位时间间隔内，如能执行多次回调，出于性能考虑，引擎默认只执行一次，设置jumpFrame=true后，则回调会连续执行多次
		 */
		public function loop(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = true, jumpFrame:Boolean = false):void {
			var handler:TimerHandler = _create(false, true, delay, caller, method, args, coverBefore);
			if (handler) handler.jumpFrame = jumpFrame;
		}
		
		/**
		 * 定时执行一次(基于帧率)。
		 * @param	delay	延迟几帧(单位为帧)。
		 * @param	caller	执行域(this)。
		 * @param	method	定时器回调函数。
		 * @param	args	回调参数。
		 * @param	coverBefore	是否覆盖之前的延迟执行，默认为 true 。
		 */
		public function frameOnce(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = true):void {
			_create(true, false, delay, caller, method, args, coverBefore);
		}
		
		/**
		 * 定时重复执行(基于帧率)。
		 * @param	delay	间隔几帧(单位为帧)。
		 * @param	caller	执行域(this)。
		 * @param	method	定时器回调函数。
		 * @param	args	回调参数。
		 * @param	coverBefore	是否覆盖之前的延迟执行，默认为 true 。
		 */
		public function frameLoop(delay:int, caller:*, method:Function, args:Array = null, coverBefore:Boolean = true):void {
			_create(true, true, delay, caller, method, args, coverBefore);
		}
		
		/** 返回统计信息。*/
		public function toString():String {
			return " handlers:" + _handlers.length + " pool:" + _pool.length;
		}
		
		/**
		 * 清理定时器。
		 * @param	caller 执行域(this)。
		 * @param	method 定时器回调函数。
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
		 * 清理对象身上的所有定时器。
		 * @param	caller 执行域(this)。
		 */
		public function clearAll(caller:*):void {
			if (!caller) return;
			for (var i:int = 0, n:int = _handlers.length; i < n; i++) {
				var handler:TimerHandler = _handlers[i];
				if (handler.caller === caller) {
					_map[handler.key] = null;
					handler.key = 0;
					handler.clear();
				}
			}
		}
		
		/** @private */
		private function _getHandler(caller:*, method:*):TimerHandler {
			var cid:int = caller ? caller.$_GID || (caller.$_GID = Utils.getGID()) : 0;
			var mid:int = method.$_TID || (method.$_TID = (_mid++) * 100000);
			return _map[cid + mid];
		}
		
		/**
		 * 延迟执行。
		 * @param	caller 执行域(this)。
		 * @param	method 定时器回调函数。
		 * @param	args 回调参数。
		 */
		public function callLater(caller:*, method:Function, args:Array = null):void {
			CallLater.I.callLater(caller, method, args);
		}
		
		/**
		 * 立即执行 callLater 。
		 * @param	caller 执行域(this)。
		 * @param	method 定时器回调函数。
		 */
		public function runCallLater(caller:*, method:Function):void {
			CallLater.I.runCallLater(caller, method);
		}
		
		/**
		 * 立即提前执行定时器，执行之后从队列中删除
		 * @param	caller 执行域(this)。
		 * @param	method 定时器回调函数。
		 */
		public function runTimer(caller:*, method:Function):void {
			var handler:TimerHandler = _getHandler(caller, method);
			if (handler && handler.method != null) {
				_map[handler.key] = null;
				handler.run(true);
			}
		}
		
		/**
		 * 暂停时钟
		 */
		public function pause():void {
			this.scale = 0;
		}
		
		/**
		 * 恢复时钟
		 */
		public function resume():void {
			this.scale = 1;
		}
	}
}

/** @private */
class TimerHandler {
	public var key:int;
	public var repeat:Boolean;
	public var delay:int;
	public var userFrame:Boolean;
	public var exeTime:int;
	public var caller:*
	public var method:Function;
	public var args:Array;
	public var jumpFrame:Boolean;
	
	public function clear():void {
		caller = null;
		method = null;
		args = null;
	}
	
	public function run(withClear:Boolean):void {
		var caller:* = this.caller;
		if (caller && caller.destroyed) return clear();
		var method:Function = this.method;
		var args:Array = this.args;
		withClear && clear();
		if (method == null) return;
		args ? method.apply(caller, args) : method.call(caller);
	}
}