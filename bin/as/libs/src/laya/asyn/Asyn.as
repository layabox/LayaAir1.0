package laya.asyn{
	
	/**
	 * <code>Asyn</code> 用于函数异步处理。
	 */
	public dynamic class Asyn {
		private static var _Deferreds:* = {};
		/** @private */
		public static var loops:Array =/*[STATIC SAFE]*/ [[], []];
		private static var _loopsIndex:int = 0;
		private static var _loopCount:int = 0;
		private static var _loopsCount:int = 0;
		private static var _callLater:Array = [];
		private static var _waitFunctionId:int = 0;
		
		/**
		 * 加载处理函数。
		 */
		public static var loadDo:Function;
		/**
		 * 等待处理函数。
		 */
		public static var onceEvent:Function;
		/**
		 * 休眠一定时间的处理函数。
		 */
		public static var onceTimer:Function;
		/** @private */
		public static var _caller_:*;
		/** @private */
		public static var _callback_:Function;
		/** @private */
		public static var _nextLine_:int;
		
		/**
		 * 函数在此处阻塞，等待条件消息发布后，即当 notify(conditions,value) 执行且 conditions 相等时，唤醒函数继续向下执行。
		 * 其中 wait 的返回值为 notify 的参数 value 的值。
		 * @param	conditions 唤醒条件。
		 * @return 唤醒时被传递的数据。
		 */
		public static function wait(conditions:*):* {
			var d:Deferred = new Deferred();
			if (conditions.indexOf("event:") == 0) {
				onceEvent(conditions.substr(8), function():void {
					d.callback();
				});
				return null;
			}
			d.loopIndex = _loopCount;
			return _Deferreds[conditions] = d;
		}
		
		/**
		 * 稍后执行。
		 * @param	d 一个 Deferred 对象。
		 */
		public static function callLater(d:Deferred):void {
			_callLater.push(d);
		}
		
		/**
		 * 发送消息。
		 * @param	conditions 消息条件。若值为 null，则默认传入当前语句所在的函数。
		 * @param	value 消息传递的数据。
		 */
		public static function notify(conditions:* = null, value:* = null):void {
			var o:Deferred = _Deferreds[conditions];
			if (o) {
				_Deferreds[conditions] = null;
				o.callback(value);
			}
		}
		
		/**
		 * 函数在此处阻塞，等待指定地址的资源加载完成后，唤醒函数继续向下执行。
		 * @param	url 资源地址。
		 * @param	type 资源类型。
		 * @return 处理当前阻塞的一个 Deferred 对象。
		 */
		public static function load(url:String, type:String = null):Deferred {
			return loadDo(url, type, new Deferred());
		}
		
		/**
		 * 函数在休眠一定时间后，继续向下执行。
		 * @param	delay 休眠时间，单位是毫秒。
		 * @internal 如果延时小于1，采用帧模式调用。
		 */
		public static function sleep(delay:int):void {
			if (delay < 1) {
				if (_loopsCount >= loops[_loopsIndex].length) {
					_loopsCount++;
					loops[_loopsIndex].push(new Deferred());
				} else {
					var d:Deferred = loops[_loopsIndex][_loopsCount];
					d._reset();
					_loopsCount++;
				}
				return;
			}
			onceTimer(delay, new Deferred());
		}
		
		/**
		 * @private
		 */
		public static function _loop_():void {
			Deferred._TIMECOUNT_++;
			_loopCount++;
			var sz:int;
			if ((sz = _loopsCount) > 0) {
				var _loops:* = loops[_loopsIndex];
				_loopsCount = 0;
				_loopsIndex = (_loopsIndex + 1) % 2;
				for (var i:int = 0; i < sz; i++)
					_loops[i].callback();
			}
			
			if ((sz = _callLater.length) > 0) {
				var accept:Array = _callLater;
				_callLater = [];
				for (i = 0, sz = accept.length; i < sz; i++) {
					var d:Deferred = accept[i];
					d.callback();
				}
			}
		}
	
	/*
	   Sync.loadDo = function(rtn:Object,url:String, type:String):*{
	   //这里增加文件读取
	   return rtn;
	   }
	   Sync.onceTimer = function(delay:int, method:Function, args:*):void{
	   setTimeout(method, delay, args);
	   }
	   Sync.oneEvent = function(type:String, listener:*):*{
	   //这里增加全局鼠标消息
	   }
	   //增加每帧的调用
	   setInterval(Sync.loop, 10);
	 */
	
	}

}