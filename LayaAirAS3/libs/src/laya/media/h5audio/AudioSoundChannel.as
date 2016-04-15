package laya.media.h5audio {
	import laya.events.Event;
	import laya.media.SoundChannel;
	import laya.media.SoundManager;
	import laya.utils.Pool;
	import laya.utils.Utils;
	
	/**
	 * audio标签播放声音的音轨控制
	 * @author ww
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
			_onEnd = Utils.bind(this.onEnd, this);
			_resumePlay = Utils.bind(this.resumePlay, this);
			audio.addEventListener("ended", _onEnd);
			_audio = audio;
		}
		
		private function onEnd():void {
			if (this.loops == 1) {
				if (completeHandler) {
					completeHandler.run();
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
		
		private function resumePlay():void {
			_audio.removeEventListener("canplay", _resumePlay);
			
			try {
				_audio.currentTime = this.startTime;
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
			_audio.pause();
			_audio.removeEventListener("ended", _onEnd);
			Pool.recover(url,_audio);
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