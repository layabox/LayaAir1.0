package laya.asyn {
	
	/**
	 * <code>Deferred</code> 用于延迟处理函数。
	 */
	public dynamic class Deferred {
		/**@private */
		public static var _TIMECOUNT_:int = 0;
		private var _caller:*;
		private var _callback:Function;
		private var _nextLine:int;
		private var _value:*;
		private var _createTime:int;
		
		/**
		 * 创建一个 <code>Deferred</code> 实例。
		 */
		public function Deferred() {
			_reset();
		}
		
		/**
		 * 设置回调参数。
		 * @param	v 回调参数。
		 */
		public function setValue(v:*):void {
			_value = v;
		}
		
		/**
		 * 获取回调参数。
		 * @return 回调参数。
		 */
		public function getValue():* {
			return _value;
		}
		
		/**
		 * @private
		 */
		public function _reset():void {
			_caller = Asyn._caller_;
			_callback = Asyn._callback_;
			_nextLine = Asyn._nextLine_;
			_createTime = _TIMECOUNT_;
		}
		
		/**
		 * 回调此对象存储的函数并传递参数 value。
		 * @param	value 回调数据。
		 */
		public function callback(value:* = null):void {
			(arguments.length > 0) && (_value = value);
			if (_createTime == _TIMECOUNT_)
				Asyn.callLater(this);
			else _callback && _callback.call(_caller, _nextLine);
		}
		
		/**
		 * 失败回调。
		 * @param	value 回调数据。
		 */
		public function errback(value:* = null):void {
			(arguments.length > 0) && (_value = value);
			_callback && _callback.call(_caller, _nextLine);
		}
	}

}