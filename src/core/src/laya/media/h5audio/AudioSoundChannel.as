package laya.media.h5audio {
	import laya.events.Event;
	import laya.media.SoundChannel;
	import laya.media.SoundManager;
	import laya.utils.Browser;
	import laya.utils.Handler;
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
			this.play();
		}
		
		private function __resumePlay():void {		
			try {
				_audio.removeEventListener("canplay", _resumePlay);
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
			try {
				_audio.currentTime = this.startTime;
			} catch (e:*) {
				_audio.addEventListener("canplay", _resumePlay);
				return;
			}
			Browser.container.appendChild(_audio);
			if(_audio.play)
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
			if(_audio.pause)
			_audio.pause();
			_audio.removeEventListener("ended", _onEnd);
			_audio.removeEventListener("canplay", _resumePlay);
			Pool.recover("audio:" + url, _audio);
			Browser.removeElement(_audio);
			_audio = null;
		
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