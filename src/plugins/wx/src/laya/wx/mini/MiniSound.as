package laya.wx.mini {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.media.SoundManager;
	import laya.net.URL;
	
	public class MiniSound extends EventDispatcher {
		private static var _musicAudio:*;
		private static var _id:int = 0;
		public var _sound:*;
		/**
		 * 声音URL
		 */
		public var url:String;
		/**
		 * 是否已加载完成
		 */
		public var loaded:Boolean = false;
		private static var _audioCache:Object = {};
		
		public function MiniSound() {
			_sound = _createSound();
		}
		
		private static function _createSound():* {
			_id++;
			return MiniAdpter.window.wx.createInnerAudioContext();
		}
		
		/**
		 * 加载声音。
		 * @param url 地址。
		 *
		 */
		public function load(url:String):void {
			url = URL.formatURL(url);
			this.url = url;
			if (_audioCache[url]) {
				event(Event.COMPLETE);
				return;
			}
			_sound.src = url;
			_sound.onCanplay(onCanPlay);
			var me:MiniSound = this;
			function onCanPlay():void {
				_clearSound();
				me.loaded = true;
				me.event(Event.COMPLETE);
				_audioCache[me.url] = me;
			}
			_sound.onError(onError);
			function onError():void {
				_clearSound();
				me.event(Event.ERROR);
			}
			
			function _clearSound():void {
				_sound.onCanplay(null);
				_sound.onError(null);
			}
		
		}
		
		/**
		 * 播放声音。
		 * @param startTime 开始时间,单位秒
		 * @param loops 循环次数,0表示一直循环
		 * @return 声道 SoundChannel 对象。
		 *
		 */
		public function play(startTime:Number = 0, loops:Number = 0):MiniSoundChannel {
			var tSound:*;
			if (url == SoundManager._tMusic) {
				if (!_musicAudio) _musicAudio = _createSound();
				tSound = _musicAudio;
			} else {
				tSound = _createSound();
			}
			
			tSound.src = url;
			var channel:MiniSoundChannel = new MiniSoundChannel(tSound);
			channel.url = this.url;
			channel.loops = loops;
			channel.startTime = startTime;
			channel.play();
			SoundManager.addChannel(channel);
			return channel;
		}
		
		/**
		 * 获取总时间。
		 */
		public function get duration():Number {
			return _sound.duration;
		}
		
		/**
		 * 释放声音资源。
		 *
		 */
		public function dispose():void {
			var ad:Audio = _audioCache[url];
			if (ad) {
				ad.src = "";
				delete _audioCache[url];
			}
		}
	}

}