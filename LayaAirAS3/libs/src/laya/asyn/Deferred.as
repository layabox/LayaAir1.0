package laya.asyn {
	
	/**
	 * ...
	 * @author laya
	 */
	public dynamic class Deferred {
		public static var _TIMECOUNT_:int = 0;
		private var _caller:*;
		private var _callback:Function;
		private var _nextLine:int;
		private var _value:*;
		private var _createTime:int;
		
		public function Deferred() {
			_reset();
		}
		
		public function setValue(v:*):void {
			_value = v;
		}
		
		public function getValue():* {
			return _value;
		}
		
		public function _reset():void {
			_caller = Asyn._caller_;
			_callback = Asyn._callback_;
			_nextLine = Asyn._nextLine_;
			_createTime = _TIMECOUNT_;
		}
		
		public function callback(value:* = null):void {
			(arguments.length > 0) && (_value = value);
			if (_createTime == _TIMECOUNT_)
				Asyn.callLater(this);
			else _callback && _callback.call(_caller, _nextLine);
		}
		
		public function errback(value:* = null):void {
			(arguments.length > 0) && (_value = value);
			_callback && _callback.call(_caller, _nextLine);
		}
	}

}