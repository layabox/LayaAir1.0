package laya.media.h5audio {
	import laya.events.Event;
	import laya.media.SoundChannel;
	import laya.media.SoundManager;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Pool;
	import laya.utils.Utils;
	
	/**
	 * @private
	 * audio标签播放声音的音轨控制
	 */
	public class AudioSoundChannel extends SoundChannel {
		
		/**
		 * 播放用的audio标签
		 */
		private var _audio:Audio = null;
		private var _onEnd:Function;
		private var _resumePlay:Function;
		
		public function AudioSoundChannel(audio:Audio) {
			super();
			_onEnd = Utils.bind(this.__onEnd, this);
			_resumePlay = Utils.bind(this.__resumePlay, this);
			audio.addEventListener("ended", _onEnd);
			_audio = audio;
		}
		
		private function __onEnd():void {
			if (this.loops == 1) {
				if (completeHandler) {
					Laya.timer.once(10, this, __runComplete, [completeHandler], false);
					completeHandler = null;
				}
				this.stop();
				event(Event.COMPLETE);
				return;
			}
			if (this.loops > 0) {
				this.loops--;
			}
			this.startTime = 0;
			this.play();
		}
		
		private function __resumePlay():void {		
			if(_audio) _audio.removeEventListener("canplay", _resumePlay);
			try {
				_audio.currentTime = this.startTime;
				Browser.container.appendChild(_audio);
				_audio.play();
			} catch (e:*) {
				//this.audio.play();
				event(Event.ERROR);
			}
		}
		
		/**
		 * 播放
		 */
		override public function play():void {
			this.isStopped = false;
			try {
				_audio.playbackRate = SoundManager.playbackRate;
				_audio.currentTime = this.startTime;
			} catch (e:*) {
				_audio.addEventListener("canplay", _resumePlay);
				return;
			}
			SoundManager.addChannel(this);
			Browser.container.appendChild(_audio);
			if("play" in _audio)
			_audio.play();
		}
		
		/**
		 * 当前播放到的位置
		 * @return
		 *
		 */
		override public function get position():Number {
			if (!_audio)
				return 0;
			return _audio.currentTime;
		}
		
		/**
		 * 获取总时间。
		 */
		override public function get duration():Number 
		{
			if (!_audio)
				return 0;
			return _audio.duration;
		}
		
		/**
		 * 停止播放
		 *
		 */
		override public function stop():void {
			//trace("stop and remove event");
			this.isStopped = true;
			SoundManager.removeChannel(this);
			completeHandler = null;
			if (!_audio)
				return;
			if ("pause" in _audio)
			//理论上应该全部使用stop，但是不知为什么，使用pause，为了安全我只修改在加速器模式下再调用一次stop
			if ( Render.isConchApp ){
				_audio.stop();
			}
			_audio.pause();
			_audio.removeEventListener("ended", _onEnd);
			_audio.removeEventListener("canplay", _resumePlay);
			//ie下使用对象池可能会导致后面的声音播放不出来
			if (!Browser.onIE)
			{
				if (_audio!=AudioSound._musicAudio)
				{
					Pool.recover("audio:" + url, _audio);
				}
			}		
			Browser.removeElement(_audio);
			_audio = null;
		
		}
		
		override public function pause():void 
		{
			this.isStopped = true;
			SoundManager.removeChannel(this);
			if("pause" in _audio)
			_audio.pause();
		}
		
		override public function resume():void 
		{		
			if (!_audio)
				return;
			this.isStopped = false;
			SoundManager.addChannel(this);
			if("play" in _audio)
			_audio.play();
		}
		
		/**
		 * 设置音量
		 * @param v
		 *
		 */
		override public function set volume(v:Number):void {
			if (!_audio) return;
			_audio.volume = v;
		}
		
		/**
		 * 获取音量
		 * @return
		 *
		 */
		override public function get volume():Number {
			if (!_audio) return 1;
			return _audio.volume;
		}
	
	}

}