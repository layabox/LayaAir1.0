package laya.ani {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Stat;
	
	/**
	 * @private
	 */
	public class AnimationPlayer extends EventDispatcher {
		/** 数据模板*/
		private var _templet:KeyframesAniTemplet;
		/** 当前精确时间，不包括重播时间*/
		private var _currentTime:Number;
		/** 当前帧时间，不包括重播时间*/
		private var _currentFrameTime:Number;
		/** 动画播放总时间*/
		private var _duration:Number;
		/** 是否在一帧结束时停止*/
		private var _stopWhenCircleFinish:Boolean;
		/** 已播放时间，包括重播时间*/
		private var _elapsedPlaybackTime:Number;
		/** 播放时帧数*/
		private var _startPlayLoopCount:Number;
		/** 当前动画索引*/
		private var _currentAnimationClipIndex:int;
		/** 当前帧数*/
		private var _currentKeyframeIndex:int;
		/** 是否暂停*/
		private var _paused:Boolean;
		/** 缓存帧率,必须大于0*/
		private var _cacheFrameRate:int;
		/** 缓存帧率间隔时间*/
		private var _cacheFrameRateInterval:Number;
		/** 播放速率*/
		public var playbackRate:Number = 1.0;
		/**是否缓存*/
		public var isCache:Boolean = true;
		
		/** 停止时是否归零*/
		public var returnToZeroStopped:Boolean = true;
		
		/**
		 * 获取动画数据模板
		 * @param	value 动画数据模板
		 */
		public function get templet():KeyframesAniTemplet {
			return _templet;
		}
		
		/**
		 * 设置动画数据模板
		 * @param	value 动画数据模板
		 */
		public function set templet(value:KeyframesAniTemplet):void {
			if (!State === AnimationState.stopped)
				stop(true);
			_templet = value;
		}
		
		/**
		 * 获取当前动画索引
		 * @return	value 当前动画索引
		 */
		public function get currentAnimationClipIndex():int {
			return _currentAnimationClipIndex;
		}
		
		/**
		 * 获取当前帧数
		 * @return	value 当前帧数
		 */
		public function get currentKeyframeIndex():int {
			return _currentKeyframeIndex;
		}
		
		/**
		 *  获取当前精确时间，不包括重播时间
		 * @return	value 当前时间
		 */
		public function get currentTime():Number {
			return _currentTime;
		}
		
		/**
		 *  获取当前帧时间，不包括重播时间
		 * @return	value 当前时间
		 */
		public function get currentFrameTime():Number {
			return _currentFrameTime;
		}
		
		/**
		 *  获取缓存帧率*
		 * @return	value 缓存帧率
		 */
		public function get cacheFrameRate():Number {
			return _cacheFrameRate;
		}
		
		///**
		//*  设置缓存帧率*
		//* @return	value 缓存帧率
		//*/
		//public function set cacheFrameRate(value:Number):void {
		//_cacheFrameRate = value;
		//_cacheFrameRateInterval = 1000 / _cacheFrameRate;
		//}
		
		/**
		 * 设置当前播放位置
		 * @param	value 当前时间
		 */
		public function set currentTime(value:Number):void {
			_currentTime = value;
			_currentKeyframeIndex = Math.floor((_currentTime % (_templet.getAniDuration(_currentAnimationClipIndex))) / _cacheFrameRateInterval);
			_currentFrameTime = _currentKeyframeIndex * _cacheFrameRateInterval;
		}
		
		/**
		 * 获取当前是否暂停
		 * @return	是否暂停
		 */
		public function get paused():Boolean {
			return _paused;
		}
		
		/**
		 * 设置是否暂停
		 * @param	value 是否暂停
		 */
		public function set paused(value:Boolean):void {
			_paused = value;
			value && this.event(Event.PAUSED);
		}
		
		/**
		 * 获取当前播放状态
		 * @return	当前播放状态
		 */
		public function get State():int {
			if (_currentAnimationClipIndex === -1)
				return AnimationState.stopped;
			if (_paused)
				return AnimationState.paused;
			return AnimationState.playing;
		}
		
		public function AnimationPlayer(cacheFrameRate:int = 60) {
			_currentAnimationClipIndex = -1;
			_currentKeyframeIndex = -1;
			_currentTime = 0.0;
			_duration = Number.MAX_VALUE;
			_stopWhenCircleFinish = false;
			_elapsedPlaybackTime = 0;
			_startPlayLoopCount = -1;
			//cacheFrameRate = 60;
			_cacheFrameRate = cacheFrameRate;
			_cacheFrameRateInterval = 1000 / _cacheFrameRate;
		}
		
		/**
		 * 播放动画
		 * @param	name 动画名字
		 * @param	playbackRate 播放速率
		 * @param	duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）
		 */
		public function play(index:int = 0, playbackRate:Number = 1.0, duration:Number = Number.MAX_VALUE):void {
			_currentTime = 0;
			_elapsedPlaybackTime = 0;
			this.playbackRate = playbackRate;
			_duration = duration;
			_paused = false;
			_currentAnimationClipIndex = index;
			_currentKeyframeIndex = 0;
			_startPlayLoopCount = Stat.loopCount;
			this.event(Event.PLAYED);
		}
		
		/**
		 * 停止播放当前动画
		 * @param	immediate 是否立即停止
		 */
		public function stop(immediate:Boolean = true):void {
			if (immediate) {
				_currentAnimationClipIndex = _currentKeyframeIndex = -1;
				this.event(Event.STOPPED);
			} else {
				_stopWhenCircleFinish = true;
			}
		}
		
		/**更新动画播放器 */
		public function update(elapsedTime:Number):void {
			if (_currentAnimationClipIndex === -1 || _paused || !_templet || !_templet.loaded)//动画停止或暂停，不更新
				return;
			
			var time:Number = 0;
			(_startPlayLoopCount !== Stat.loopCount) && (time = elapsedTime * playbackRate, _elapsedPlaybackTime += time);//elapsedTime为距离上一帧时间,首帧播放如果_startPlayLoopCount===Stat.loopCount，则不累加时间
			
			var currentAniClipDuration:Number = _templet.getAniDuration(_currentAnimationClipIndex);
			
			if ((_duration !== 0 && _elapsedPlaybackTime >= _duration) || (_duration === 0 && _elapsedPlaybackTime >= currentAniClipDuration)) {
				_currentAnimationClipIndex = _currentKeyframeIndex = -1;// 动画结束
				this.event(Event.STOPPED);
				return;
			}
			time += _currentTime;
			
			while (time >= currentAniClipDuration) {
				if (_stopWhenCircleFinish) {
					_currentAnimationClipIndex = _currentKeyframeIndex = -1;
					_stopWhenCircleFinish = false;
					this.event(Event.STOPPED);
					return;
				}
				time -= currentAniClipDuration;
			}
			currentTime = time;
		}
	}
}