package laya.media.webaudio {
	import laya.events.Event;
	import laya.media.SoundChannel;
	import laya.media.SoundManager;
	import laya.utils.Browser;
	import laya.utils.Utils;
	
	/**
	 * @private
	 * web audio api方式播放声音的音轨控制
	 */
	public class WebAudioSoundChannel extends SoundChannel {
		/**
		 * 声音原始文件数据
		 */
		public var audioBuffer:*;
		
		/**
		 * gain节点
		 */
		private var gain:*;
		
		/**
		 * 播放用的数据
		 */
		private var bufferSource:* = null;
		/**
		 * 当前时间
		 */
		private var _currentTime:Number = 0;
		
		/**
		 * 当前音量
		 */
		private var _volume:Number = 1;
		
		/**
		 * 播放开始时的时间戳
		 */
		private var _startTime:Number = 0;
		
		/**
		 * 播放设备
		 */
		private var context:* = WebAudioSound.ctx;
		
		private var _onPlayEnd:Function;
		private static var _tryCleanFailed:Boolean = false;
		
		public function WebAudioSoundChannel() {
			super();
			_onPlayEnd = Utils.bind(__onPlayEnd, this);
			if (this.context["createGain"]) {
				this.gain = this.context["createGain"]();
			} else {
				this.gain = this.context["createGainNode"]();
			}
		}
		
		/**
		 * 播放声音
		 */
		override public function play():void {
			_clearBufferSource();
			if (!audioBuffer) return;
			var context:* = this.context;
			var gain:* = this.gain;
			var bufferSource:* = context.createBufferSource();
			this.bufferSource = bufferSource;
			bufferSource.buffer = this.audioBuffer;
			bufferSource.connect(gain);
			if (gain)
				gain.disconnect();
			gain.connect(context.destination);
			bufferSource.onended = _onPlayEnd;
			
			this._startTime = Browser.now();
			this.gain.gain.value = this._volume;
			if (loops == 0) {
				bufferSource.loop = true;
			}
			bufferSource.start(0, this.startTime);
			this._currentTime = 0;
		}
		
		
		
		private function __onPlayEnd():void {
			if (this.loops == 1) {
				
				if (completeHandler) {
					Laya.timer.once(10, this, __runComplete, [completeHandler], false);
					completeHandler = null;
				}
				this.stop();
				this.event(Event.COMPLETE);
				return;
			}
			if (this.loops > 0) {
				this.loops--;
			}
			play();
		}
		
		/**
		 * 获取当前播放位置
		 */
		override public function get position():Number {
			if (this.bufferSource) {
				return (Browser.now() - this._startTime) / 1000 + this.startTime;
			}
			return 0;
		}
		private function _clearBufferSource():void
		{
			if (this.bufferSource) {
				var sourceNode:* = this.bufferSource;
				if (sourceNode.stop) {
					sourceNode.stop(0);
				} else {
					sourceNode.noteOff(0);
				}
				sourceNode.disconnect(0);
				sourceNode.onended = null;
				if (!_tryCleanFailed) _tryClearBuffer(sourceNode);
				this.bufferSource = null;			
			}
		}
		private function _tryClearBuffer(sourceNode:*):void
		{
			try { sourceNode.buffer = WebAudioSound._miniBuffer; } catch (e:*) { _tryCleanFailed = true; }
		}
		/**
		 * 停止播放
		 */
		override public function stop():void {
            _clearBufferSource();
			this.audioBuffer = null;
			if (gain)
				gain.disconnect();
			this.isStopped = true;
			SoundManager.removeChannel(this);
			completeHandler = null;
		}
		
		/**
		 * 设置音量
		 */
		override public function set volume(v:Number):void {
			if (this.isStopped) {
				return;
			}
			
			this._volume = v;
			this.gain.gain.value = v;
		}
		
		/**
		 * 获取音量
		 */
		override public function get volume():Number {
			return this._volume;
		}
	
	}

}