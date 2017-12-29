package laya.wx.mini {
	import laya.events.Event;
	import laya.media.SoundChannel;
	import laya.media.SoundManager;
	import laya.utils.Utils;
	
	/**
	 * @private
	 * wxaudio 方式播放声音的音轨控制
	 */
	public class MiniSoundChannel extends SoundChannel {
		private var _audio:*;
		private var _onEnd:Function;
		
		public function MiniSoundChannel(audio:*) {
			this._audio = audio;
			_onEnd = Utils.bind(this.__onEnd, this);
			audio.onEnded(_onEnd);
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
		
		/**
		 * 播放
		 */
		override public function play():void {
			this.isStopped = false;
			SoundManager.addChannel(this);
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
		override public function get duration():Number {
			if (!_audio)
				return 0;
			return _audio.duration;
		}
		
		/**
		 * 停止播放
		 *
		 */
		override public function stop():void {
			this.isStopped = true;
			SoundManager.removeChannel(this);
			completeHandler = null;
			if (!_audio)
				return;
			_audio.stop();
			_audio.onEnded(null);
			_audio = null;
		
		}
		
		override public function pause():void {
			this.isStopped = true;
			_audio.pause();
		}
		
		override public function resume():void {
			if (!_audio)
				return;
			this.isStopped = false;
			SoundManager.addChannel(this);
			_audio.play();
		}
		
		/**
		 * 设置音量
		 * @param v
		 *
		 */
		override public function set volume(v:Number):void {
		
		}
		
		/**
		 * 获取音量
		 * @return
		 *
		 */
		override public function get volume():Number {
			return 1;
		}
	}

}