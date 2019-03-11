package laya.media {
	import laya.events.Event;
	import laya.media.h5audio.AudioSound;
	import laya.media.webaudio.WebAudioSound;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	/**
	 * <code>SoundManager</code> 是一个声音管理类。提供了对背景音乐、音效的播放控制方法。
	 * 引擎默认有两套声音方案：WebAudio和H5Audio
	 * 播放音效，优先使用WebAudio播放声音，如果WebAudio不可用，则用H5Audio播放，H5Audio在部分机器上有兼容问题（比如不能混音，播放有延迟等）。
	 * 播放背景音乐，则使用H5Audio播放（使用WebAudio会增加特别大的内存，并且要等加载完毕后才能播放，有延迟）
	 * 建议背景音乐用mp3类型，音效用wav或者mp3类型（如果打包为app，音效只能用wav格式）。
	 * 详细教程及声音格式请参考：http://ldc2.layabox.com/doc/?nav=ch-as-1-7-0
	 */
	public class SoundManager {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**
		 * 背景音乐音量。
		 * @default 1
		 */
		public static var musicVolume:Number = 1;
		/**
		 * 音效音量。
		 * @default 1
		 */
		public static var soundVolume:Number = 1;
		/**
		 * 声音播放速率。
		 * @default 1
		 */
		public static var playbackRate:Number = 1;
		/**
		 * 背景音乐使用Audio标签播放。
		 * @default true
		 */
		private static var _useAudioMusic:Boolean = true;
		/**@private 是否静音，默认为false。*/
		private static var _muted:Boolean = false;
		/**@private 是否音效静音，默认为false。*/
		private static var _soundMuted:Boolean = false;
		/**@private 是否背景音乐静音，默认为false。*/
		private static var _musicMuted:Boolean = false;
		/**@private 当前背景音乐url。*/
		public static var _bgMusic:String = null;
		/**@private 当前背景音乐声道。*/
		private static var _musicChannel:SoundChannel = null;
		/**@private 当前播放的Channel列表。*/
		private static var _channels:Array = [];
		/**@private */
		private static var _autoStopMusic:Boolean;
		/**@private */
		private static var _blurPaused:Boolean = false;
		/**@private */
		private static var _isActive:Boolean = true;
		/**@private */
		public static var _soundClass:Class;
		/**@private */
		public static var _musicClass:Class;
		/**@private */
		private static var _lastSoundUsedTimeDic:Object = { };
		/**@private */
		private static var _isCheckingDispose:Boolean = false;
		
		/**@private */
		public static function __init__():Boolean {
			var win:* = Browser.window;
			var supportWebAudio:Boolean = win["AudioContext"] || win["webkitAudioContext"] || win["mozAudioContext"] ? true : false;
			if (supportWebAudio) WebAudioSound.initWebAudio();
			_soundClass = supportWebAudio?WebAudioSound:AudioSound;
			AudioSound._initMusicAudio();
			_musicClass = AudioSound;
			return supportWebAudio;
		}
		
		/**
		 * 音效播放后自动删除。
		 * @default true
		 */
		public static var autoReleaseSound:Boolean = true;
		
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
		
		/**@private */
		public static function disposeSoundLater(url:String):void
		{
			_lastSoundUsedTimeDic[url] = Browser.now();
			if (!_isCheckingDispose)
			{
				_isCheckingDispose = true;
				Laya.timer.loop(5000, null, _checkDisposeSound);
			}
		}
		
		/**@private */
		private static function _checkDisposeSound():void
		{
			var key:String;
			var tTime:Number = Browser.now();
			var hasCheck:Boolean = false;
			for (key in _lastSoundUsedTimeDic)
			{
				if (tTime-_lastSoundUsedTimeDic[key]>30000)
				{
					delete _lastSoundUsedTimeDic[key];
					disposeSoundIfNotUsed(key);
				}else
				{
					hasCheck = true;
				}
			}
			if (!hasCheck)
			{
				_isCheckingDispose = false;
				Laya.timer.clear(null, _checkDisposeSound);
			}
		}
		
		/**@private */
		public static function disposeSoundIfNotUsed(url:String):void
		{
			var i:int;
			for (i = _channels.length - 1; i >= 0; i--) {
				if (_channels[i].url==url) {
					return;
				}
			}
			destroySound(url);
		}
		
		/**
		 * 失去焦点后是否自动停止背景音乐。
		 * @param v Boolean 失去焦点后是否自动停止背景音乐。
		 *
		 */
		public static function set autoStopMusic(v:Boolean):void {
			Laya.stage.off(Event.BLUR, null, _stageOnBlur);
			Laya.stage.off(Event.FOCUS, null, _stageOnFocus);
			Laya.stage.off(Event.VISIBILITY_CHANGE, null, _visibilityChange);
			_autoStopMusic = v;
			if (v) {
				Laya.stage.on(Event.BLUR, null, _stageOnBlur);
				Laya.stage.on(Event.FOCUS, null, _stageOnFocus);
				Laya.stage.on(Event.VISIBILITY_CHANGE, null, _visibilityChange);
			}
		}
		
		/**
		 * 失去焦点后是否自动停止背景音乐。
		 */
		public static function get autoStopMusic():Boolean {
			return _autoStopMusic;
		}
		
		private static function _visibilityChange():void {
			if (Laya.stage.isVisibility) {
				_stageOnFocus();
			} else {
				_stageOnBlur();
			}
		}
		
		private static function _stageOnBlur():void {
			_isActive = false;
			if (_musicChannel) {
				if (!_musicChannel.isStopped) {
					_blurPaused = true;
					_musicChannel.pause();
					
				}
				
			}	
			stopAllSound();
			Laya.stage.once(Event.MOUSE_DOWN, null, _stageOnFocus);
		}
		
		private static function _recoverWebAudio():void
		{
			if(WebAudioSound.ctx&&WebAudioSound.ctx.state!="running"&&WebAudioSound.ctx.resume)
			WebAudioSound.ctx.resume();
		}
		
		private static function _stageOnFocus():void {
			_isActive = true;
			_recoverWebAudio();
			Laya.stage.off(Event.MOUSE_DOWN, null, _stageOnFocus);
			if (_blurPaused) {
				if (_musicChannel && _musicChannel.isStopped)
				{
					_blurPaused = false;
					_musicChannel.resume();
				}				
			}
		}
		
		/**
		 * 背景音乐和所有音效是否静音。
		 */
		public static function set muted(value:Boolean):void {
			if (value == _muted) return;
			if (value) {
				stopAllSound();
			}
			musicMuted = value;
			_muted = value;
		}
		
		public static function get muted():Boolean {
			return _muted;
		}
		
		/**
		 * 所有音效（不包括背景音乐）是否静音。
		 */
		public static function set soundMuted(value:Boolean):void {
			_soundMuted = value;
		}
		
		public static function get soundMuted():Boolean {
			return _soundMuted;
		}
		
		/**
		 * 背景音乐（不包括音效）是否静音。
		 */
		public static function set musicMuted(value:Boolean):void {
			if (value == _musicMuted) return;
			if (value) {
				if (_bgMusic)
				{
					if (_musicChannel&&!_musicChannel.isStopped)
					{
						if (Render.isConchApp) {
							__JS__("if (SoundManager._musicChannel._audio) SoundManager._musicChannel._audio.muted = true;");
						}
						else {
							_musicChannel.pause();
						}
					}else
					{
						_musicChannel = null;
					}
				}else
				{
					_musicChannel = null;
				}
					
				_musicMuted = value;
			} else {
				_musicMuted = value;
				if (_bgMusic) {
					if (_musicChannel)
					{
						if (Render.isConchApp) {
							__JS__("if(SoundManager._musicChannel._audio) SoundManager._musicChannel._audio.muted = false;");
						}
						else {
							_musicChannel.resume();
						}
					}
				}
			}
		
		}
		
		public static function get musicMuted():Boolean {
			return _musicMuted;
		}
		
		static public function get useAudioMusic():Boolean 
		{
			return _useAudioMusic;
		}
		
		static public function set useAudioMusic(value:Boolean):void 
		{
			_useAudioMusic = value;
			if (value)
			{
				_musicClass = AudioSound;
			}else
			{
				_musicClass = null;
			} 
		}
		
		/**
		 * 播放音效。音效可以同时播放多个。
		 * @param url			声音文件地址。
		 * @param loops			循环次数,0表示无限循环。
		 * @param complete		声音播放完成回调  Handler对象。
		 * @param soundClass	使用哪个声音类进行播放，null表示自动选择。
		 * @param startTime		声音播放起始时间。
		 * @return SoundChannel对象，通过此对象可以对声音进行控制，以及获取声音信息。
		 */
		public static function playSound(url:String, loops:int = 1, complete:Handler = null, soundClass:Class = null, startTime:Number = 0):SoundChannel {
			if (!_isActive || !url) return null;
			if (_muted) return null;
			_recoverWebAudio();
			url = URL.formatURL(url);
			if (url == _bgMusic) {
				if (_musicMuted) return null;
			} else {
				if (Render.isConchApp) {
					var ext:String = Utils.getFileExtension(url);
					if (ext != "wav" && ext != "ogg") {
						alert("The sound only supports wav or ogg format,for optimal performance reason,please refer to the official website document.");
						return null;
					}
				}
				if (_soundMuted) return null;
			}
			var tSound:Sound;
			if (!Browser.onMiniGame)
			{
				tSound= Laya.loader.getRes(url);
			}
			if (!soundClass) soundClass = _soundClass;
			if (!tSound) {
				tSound = new soundClass();
				tSound.load(url);
				if (!Browser.onMiniGame)
				{
					Loader.cacheRes(url, tSound);
				}	
			}
			var channel:SoundChannel;
			channel = tSound.play(startTime, loops);
			if (!channel) return null;
			channel.url = url;
			channel.volume = (url == _bgMusic) ? musicVolume : soundVolume;
			channel.completeHandler = complete;
			return channel;
		}
		
		/**
		 * 释放声音资源。
		 * @param url	声音播放地址。
		 */
		public static function destroySound(url:String):void {
			var tSound:Sound = Laya.loader.getRes(url);
			if (tSound) {
				Loader.clearRes(url);
				tSound.dispose();
			}
		}
		
		/**
		 * 播放背景音乐。背景音乐同时只能播放一个，如果在播放背景音乐时再次调用本方法，会先停止之前的背景音乐，再播发当前的背景音乐。
		 * @param url		声音文件地址。
		 * @param loops		循环次数,0表示无限循环。
		 * @param complete	声音播放完成回调。
		 * @param startTime	声音播放起始时间。
		 * @return SoundChannel对象，通过此对象可以对声音进行控制，以及获取声音信息。
		 */
		public static function playMusic(url:String, loops:int = 0, complete:Handler = null, startTime:Number = 0):SoundChannel {
			url = URL.formatURL(url);
			_bgMusic = url;
			if (_musicChannel) _musicChannel.stop();
			return _musicChannel = playSound(url, loops, complete, _musicClass, startTime);
		}
		
		/**
		 * 停止声音播放。此方法能够停止任意声音的播放（包括背景音乐和音效），只需传入对应的声音播放地址。
		 * @param url  声音文件地址。
		 */
		public static function stopSound(url:String):void {
			url = URL.formatURL(url);
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
		 * 停止播放所有声音（包括背景音乐和音效）。
		 */
		public static function stopAll():void {
			_bgMusic = null;
			var i:int;
			var channel:SoundChannel;
			for (i = _channels.length - 1; i >= 0; i--) {
				channel = _channels[i];
				channel.stop();
			}
		}
		
		/**
		 * 停止播放所有音效（不包括背景音乐）。
		 */
		public static function stopAllSound():void {
			var i:int;
			var channel:SoundChannel;
			for (i = _channels.length - 1; i >= 0; i--) {
				channel = _channels[i];
				if (channel.url != _bgMusic) {
					channel.stop();
				}
			}
		}
		
		/**
		 * 停止播放背景音乐（不包括音效）。
		 * @param url  声音文件地址。
		 */
		public static function stopMusic():void {
			if (_musicChannel) _musicChannel.stop();
			_bgMusic = null;
		}
		
		/**
		 * 设置声音音量。根据参数不同，可以分别设置指定声音（背景音乐或音效）音量或者所有音效（不包括背景音乐）音量。
		 * @param volume	音量。初始值为1。音量范围从 0（静音）至 1（最大音量）。
		 * @param url		(default = null)声音播放地址。默认为null。为空表示设置所有音效（不包括背景音乐）的音量，不为空表示设置指定声音（背景音乐或音效）的音量。
		 */
		public static function setSoundVolume(volume:Number, url:String = null):void {
			if (url) {
				url = URL.formatURL(url);
				_setVolume(url, volume);
			} else {
				soundVolume = volume;
				var i:int;
				var channel:SoundChannel;
				for (i = _channels.length - 1; i >= 0; i--) {
					channel = _channels[i];
					if (channel.url != _bgMusic) {
						channel.volume = volume;
					}
				}
			}
		}
		
		/**
		 * 设置背景音乐音量。音量范围从 0（静音）至 1（最大音量）。
		 * @param volume	音量。初始值为1。音量范围从 0（静音）至 1（最大音量）。
		 */
		public static function setMusicVolume(volume:Number):void {
			musicVolume = volume;
			_setVolume(_bgMusic, volume);
		}
		
		/**
		 * 设置指定声音的音量。
		 * @param url		声音文件url
		 * @param volume	音量。初始值为1。
		 */
		private static function _setVolume(url:String, volume:Number):void {
			url = URL.formatURL(url);
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