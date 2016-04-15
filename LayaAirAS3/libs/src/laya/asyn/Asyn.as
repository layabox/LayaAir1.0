package laya.asyn {
	
	/**
	 * ...
	 * @author laya
	 */
	public dynamic class Asyn {
		private static var _Deferreds:* = {};
		public static var loops:Array =/*[STATIC SAFE]*/ [[], []];
		private static var _loopsIndex:int = 0;
		private static var _loopCount:int = 0;
		private static var _loopsCount:int = 0;
		private static var _callLater:Array = [];
		private static var _waitFunctionId:int = 0;
		
		public static var loadDo:Function;
		public static var onceEvent:Function;
		public static var onceTimer:Function;
		
		public static var _caller_:*;
		public static var _callback_:Function;
		public static var _nextLine_:int;
		
		//要支持多条件，数组
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
		
		public static function callLater(d:Deferred):void {
			_callLater.push(d);
		}
		
		public static function notify(conditions:* = null, value:* = null):void {
			var o:Deferred = _Deferreds[conditions];
			if (o) {
				_Deferreds[conditions] = null;
				o.callback(value);
			}
		}
		
		public static function load(url:String, type:String = null):Deferred {
			return loadDo(url, type, new Deferred());
		}
		
		//如果延时<1，采用帧模式调用
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