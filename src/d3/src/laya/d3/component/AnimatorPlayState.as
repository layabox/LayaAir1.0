package laya.d3.component {
	
	/**
	 * <code>AnimatorPlayState</code> 类用于创建动画播放状态信息。
	 */
	public class AnimatorPlayState {
		/**@private */
		public var _finish:Boolean;
		/**@private */
		public var _startPlayTime:Number;
		/**@private */
		public var _lastElapsedTime:Number;
		/**@private */
		public var _elapsedTime:Number;
		/**@private */
		public var _normalizedTime:Number;
		/**@private */
		public var _normalizedPlayTime:Number;
		/**@private */
		public var _duration:Number;
		/**@private */
		public var _playEventIndex:int;
		
		/**
		 * 获取播放状态的归一化时间,整数为循环次数，小数为单次播放时间。
		 */
		public function get normalizedTime():Number {
			return _normalizedTime;
		}
		
		/**
		 * 获取当前动画的持续时间，以秒为单位。
		 */
		public function get duration():Number {
			return _duration;
		}
		
		/**
		 * 创建一个 <code>AnimatorPlayState</code> 实例。
		 */
		public function AnimatorPlayState() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * @private
		 */
		public function _resetPlayState(startTime:Number):void {
			_finish = false;
			_startPlayTime = startTime;
			_elapsedTime = startTime;
			_playEventIndex = 0.0;
		}
		
		/**
		 * @private
		 */
		public function _cloneTo(dest:AnimatorPlayState):void {
			dest._finish = _finish;
			dest._startPlayTime = _startPlayTime;
			dest._elapsedTime = _elapsedTime;
			dest._playEventIndex = _playEventIndex;
		}
	
	}

}