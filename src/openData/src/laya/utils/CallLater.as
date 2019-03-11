package laya.utils {
	
	/**
	 * @private
	 */
	public class CallLater {
		public static var I:CallLater =/*[STATIC SAFE]*/ new CallLater();
		/**@private */
		private var _pool:Array = [];
		/**@private */
		private var _map:Array = [];
		/**@private */
		private var _laters:Array = [];
		
		/**
		 * @private
		 * 帧循环处理函数。
		 */
		public function _update():void {
			var laters:Array = this._laters;
			var len:int = laters.length;
			if (len > 0) {
				for (var i:int = 0, n:int = len - 1; i <= n; i++) {
					var handler:LaterHandler = laters[i];
					_map[handler.key] = null;
					if (handler.method !== null) {
						handler.run();
						handler.clear();
					}
					_pool.push(handler);
					i === n && (n = laters.length - 1);
				}
				laters.length = 0;
			}
		}
		
		/** @private */
		private function _getHandler(caller:*, method:*):LaterHandler {
			var cid:int = caller ? caller.$_GID || (caller.$_GID = Utils.getGID()) : 0;
			var mid:int = method.$_TID || (method.$_TID = (Timer._mid++) * 100000);
			return _map[cid + mid];
		}
		
		/**
		 * 延迟执行。
		 * @param	caller 执行域(this)。
		 * @param	method 定时器回调函数。
		 * @param	args 回调参数。
		 */
		public function callLater(caller:*, method:Function, args:Array = null):void {
			if (_getHandler(caller, method) == null) {
				if (_pool.length)
					var handler:LaterHandler = _pool.pop();
				else handler = new LaterHandler();
				//设置属性
				handler.caller = caller;
				handler.method = method;
				handler.args = args;
				//索引handler
				var cid:int = caller ? caller.$_GID : 0;
				var mid:int = method["$_TID"];
				handler.key = cid + mid;
				_map[handler.key] = handler
				//插入队列
				_laters.push(handler);
			}
		}
		
		/**
		 * 立即执行 callLater 。
		 * @param	caller 执行域(this)。
		 * @param	method 定时器回调函数。
		 */
		public function runCallLater(caller:*, method:Function):void {
			var handler:LaterHandler = _getHandler(caller, method);
			if (handler && handler.method != null) {
				_map[handler.key] = null;
				handler.run();
				handler.clear();
			}
		}
	}
}

/** @private */
class LaterHandler {
	public var key:int;
	public var caller:*
	public var method:Function;
	public var args:Array;
	
	public function clear():void {
		caller = null;
		method = null;
		args = null;
	}
	
	public function run():void {
		var caller:* = this.caller;
		if (caller && caller.destroyed) return clear();
		var method:Function = this.method;
		var args:Array = this.args;
		if (method == null) return;
		args ? method.apply(caller, args) : method.call(caller);
	}
}