package laya.media {
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	
	/**
	 * <code>SoundManager</code> 是一个声音管理类。
	 */
	public class SoundManager {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/** 背景音乐音量。*/
		public static var musicVolume:Number = 1;
		/** 音效音量。*/
		public static var soundVolume:Number = 1;
		/**@private 是否静音，默认为false。*/
		private static var _muted:Boolean = false;
		/**@private 是否音效静音，默认为false。*/
		private static var _soundMuted:Boolean = false;
		/**@private 是否背景音乐静音，默认为false。*/
		private static var _musicMuted:Boolean = false;
		/**@private 当前背景音乐url。*/
		private static var _tMusic:String = null;
		/**@private 当前背景音乐声道。*/
		private static var _musicChannel:SoundChannel = null;
		/**@private 当前\播放的Channel列表。*/
		private static var _channels:Array = [];
		/**@private */
		private static var _autoStopMusic:Boolean;
		/**@private */
		private static var _blurPaused:Boolean = false;
		/**@private */
		private static var _musicLoops:int = 0;
		/**@private */
		private static var _musicPosition:Number = 0;
		/**@private */
		private static var _musicCompleteHandler:Handler = null;
		/**@private */
		public static var _soundClass:Class;
		/**
		 * 添加播放的声音实例。
		 * @param channel <code>SoundChannel</code> 对象。
		 */
		public static function addChannel(channel:SoundChannel):void {
			if (_channels.indexOf(channel) >= 0) return;
			_channels.push(channel);
		}
		
		/**
		 * 移除播放的声音实例。
		 * @param channel <code>SoundChannel</code> 对象。
		 */
		public static function removeChannel(channel:SoundChannel):void {
			var i:int;
			for (i = _channels.length - 1; i >= 0; i--) {
				if (_channels[i] == channel) {
					_channels.splice(i, 1);
				}
			}
		}
		
		/**
		 * 设置是否失去焦点后自动停止背景音乐。
		 * @param v Boolean 值。
		 *
		 */
		public static function set autoStopMusic(v:Boolean):void {
			Laya.stage.off(Event.BLUR, null, _stageOnBlur);
			Laya.stage.off(Event.FOCUS, null, _stageOnFocus);
			_autoStopMusic = v;
			if (v) {
				Laya.stage.on(Event.BLUR, null, _stageOnBlur);
				Laya.stage.on(Event.FOCUS, null, _stageOnFocus);
			}
		}
		
		/**
		 * 表示是否失去焦点后自动停止背景音乐。
		 * @return
		 */
		public static function get autoStopMusic():Boolean {
			return _autoStopMusic;
		}
		
		private static function _stageOnBlur():void {
			if (_musicChannel) {
				if (!_musicChannel.isStopped) {
					_blurPaused = true;
					_musicLoops = _musicChannel.loops;
					_musicCompleteHandler = _musicChannel.completeHandler;
					_musicPosition=_musicChannel.position;
					_musicChannel.stop();
					Laya.stage.once(Event.MOUSE_DOWN, null, _stageOnFocus);
				}
				
			}
		}
		
		private static function _stageOnFocus():void {
			Laya.stage.off(Event.MOUSE_DOWN, null, _stageOnFocus);
			if (_blurPaused) {			
				playMusic(_tMusic,_musicLoops,_musicCompleteHandler,_musicPosition);
				_blurPaused = false;
			}
		}
		
		public static function set muted(value:Boolean):void {
			if (value) {
				stopAll();
			}
			_muted = value;
		}
		
		/**
		 * 表示是否静音。
		 */
		public static function get muted():Boolean {
			return _muted;
		}
		
		public static function set soundMuted(value:Boolean):void {			
			_soundMuted = value;
		}
		
		/** 表示是否使音效静音。*/
		public static function get soundMuted():Boolean {
			return _soundMuted;
		}
		
		public static function set musicMuted(value:Boolean):void {
			if (value) {
				if (_tMusic)
					stopSound(_tMusic);
				_musicMuted = value;
			} else {
				_musicMuted = value;
				if (_tMusic) {
					playMusic(_tMusic);
				}
			}
		
		}
		
		/** 表示是否使背景音乐静音。*/
		public static function get musicMuted():Boolean {
			return _musicMuted;
		}
		
		/**
		 * 播放音效。
		 * @param url 声音文件地址。
		 * @param loops 循环次数,0表示无限循环。
		 * @param complete 声音播放完成回调  Handler对象。
		 * @param startTime  声音播放起始时间。
		 * @return SoundChannel对象。
		 */
		public static function playSound(url:String, loops:int = 1, complete:Handler = null, soundClass:Class = null,startTime:Number=0):SoundChannel {
			if (_muted)
				return null;
			if (url == _tMusic) {
				if (_musicMuted) return null;
			} else {
				if (_soundMuted) return null;
			}
			var tSound:Sound = Laya.loader.getRes(url);
			if (!soundClass) soundClass = _soundClass;
			if (!tSound) {
				tSound = new soundClass();
				tSound.load(url);
				Loader.cacheRes(url, tSound);
			}
			var channel:SoundChannel;
			channel = tSound.play(startTime, loops);
			channel.url = url;
			channel.volume = (url == _tMusic) ? musicVolume : soundVolume;
			channel.completeHandler = complete;
			return channel;
		}
		
		/**
		 * 释放声音资源。
		 * @param url 声音文件地址。
		 */
		public static function destroySound(url:String):void {
			var tSound:Sound = Laya.loader.getRes(url);
			if (tSound) {
				Loader.clearRes(url);
				tSound.dispose();
			}
		}
		
		/**
		 * 播放背景音乐。
		 * @param url 声音文件地址。
		 * @param loops 循环次数,0表示无限循环。
		 * @param complete  声音播放完成回调。
		 * @param startTime  声音播放起始时间。
		 * @return audio对象。
		 */
		public static function playMusic(url:String, loops:int = 0, complete:Handler = null,startTime:Number=0):SoundChannel {
			_tMusic = url;
			if (_musicChannel)
				_musicChannel.stop();
			return _musicChannel = playSound(url, loops, complete, null,startTime);
		}
		
		/**
		 * 停止声音播放。
		 * @param url  声音文件地址。
		 */
		public static function stopSound(url:String):void {
			var i:int;
			var channel:SoundChannel;
			for (i = _channels.length - 1; i >= 0; i--) {
				channel = _channels[i];
				if (channel.url == url) {
					channel.stop();
				}
			}
		}
		/**
		 * 停止所有声音播放。
		 */
		public static function stopAll():void
		{
			var i:int;
			var channel:SoundChannel;
			for (i = _channels.length - 1; i >= 0; i--) {
				channel = _channels[i];
				channel.stop();
			}
		}
		/**
		 * 停止背景音乐播放。
		 * @param url  声音文件地址。
		 */
		public static function stopMusic():void {
			if (_musicChannel)
				_musicChannel.stop();
		}
		
		/**
		 * 设置声音音量
		 * @param volume 音量 标准值为1
		 * @param url  声音文件地址。为null(默认值)时对所有音效起作用，不为空时仅对对于声音生效
		 */
		public static function setSoundVolume(volume:Number, url:String = null):void {
			if (url) {
				_setVolume(url, volume);
			} else {
				soundVolume = volume;
			}
		}
		
		/**
		 * 设置背景音乐音量。
		 * @param volume 音量，标准值为1。
		 */
		public static function setMusicVolume(volume:Number):void {
			musicVolume = volume;
			_setVolume(_tMusic, volume);
		}
		
		/**
		 * 设置指定声音的音量。
		 * @param url  声音文件url
		 * @param volume 音量，标准值为1。
		 */
		private static function _setVolume(url:String, volume:Number):void {
			var i:int;
			var channel:SoundChannel;
			for (i = _channels.length - 1; i >= 0; i--) {
				channel = _channels[i];
				if (channel.url == url) {
					channel.volume = volume;
				}
			}
		}
	}
}