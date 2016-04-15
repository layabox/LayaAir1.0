package laya.media
{
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	
	/**
	 * 声音管理类
	 * @author ww
	 * @version 1.0
	 * @created  2015-9-10 下午2:35:21
	 */
	public class SoundManager
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**背景音乐音量*/
		public static var musicVolume:Number = 1;
		/**音效音量*/
		public static var soundVolume:Number = 1;
		/**@private 是否静音，默认为false*/
		private static var _muted:Boolean = false;
		/**@private 是否音效静音，默认为false*/
		private static var _soundMuted:Boolean = false;
		/**@private 是否背景音乐静音，默认为false*/
		private static var _musicMuted:Boolean = false;
		/**@private 当前背景音乐url*/
		private static var _tMusic:String = null;
		/**@private 当前背景音乐Channel*/
		private static var _musicChannel:SoundChannel = null;
		
		/**@private 当前\播放的Channel列表*/
		private static var _channels:Array = [];
		
		/**
		 * 添加播放的声音实例
		 * @param channel
		 *
		 */
		public static function addChannel(channel:SoundChannel):void
		{
			_channels.push(channel);
		}
		
		/**
		 * 移除播放的声音实例
		 * @param channel
		 *
		 */
		public static function removeChannel(channel:SoundChannel):void
		{
			var i:int;
			for (i = _channels.length - 1; i >= 0; i--)
			{
				if (_channels[i] == channel)
				{
					_channels.splice(i, 1);
				}
			}
		}
		
		private static var _autoStopMusic:Boolean;
		
		/**
		 * 是否失去焦点后自动停止背景音乐 
		 * @param v
		 * 
		 */
		public static function set autoStopMusic(v:Boolean):void
		{
			Laya.stage.off(Event.BLUR, null, stageOnBlur);
			Laya.stage.off(Event.FOCUS, null, stageOnFocus);
			_autoStopMusic = v;
			if (v)
			{
				Laya.stage.on(Event.BLUR, null, stageOnBlur);
				Laya.stage.on(Event.FOCUS, null, stageOnFocus);
			}
		}
		
		/**
		 * 是否失去焦点后自动停止背景音乐 
		 * @return 
		 * 
		 */
		public static function get autoStopMusic():Boolean
		{
			return _autoStopMusic;
		}
		private static var _blurPaused:Boolean = false;

		private static function stageOnBlur():void
		{
			if (_musicChannel)
			{
				if (!_musicChannel.isStopped)
				{
					_blurPaused = true;
					_musicChannel.stop();
				}
				
			}
		}
		
		private static function stageOnFocus():void
		{
			if (_blurPaused)
			{
				playMusic(_tMusic);
				_blurPaused = false;
			}
		}
		
		/**是否静音*/
		public static function set muted(value:Boolean):void
		{
			if (value)
			{
				if (_tMusic)
					stopSound(_tMusic);
			}
			_muted = value;
		}
		
		public static function get muted():Boolean
		{
			return _muted;
		}
		
		/**是否音效静音*/
		public static function set soundMuted(value:Boolean):void
		{
			
			_soundMuted = value;
		}
		
		public static function get soundMuted():Boolean
		{
			return _soundMuted;
		}
		
		/**是否背景音乐静音*/
		public static function set musicMuted(value:Boolean):void
		{
			if (value)
			{
				if (_tMusic)
					stopSound(_tMusic);
			}
			_musicMuted = value;
		}
		
		public static function get musicMuted():Boolean
		{
			return _musicMuted;
		}
		
		/**
		 * 播放音效
		 * @param url 声音文件url
		 * @param loops 循环次数,0表示无限循环
		 * @param complete 声音播放完成回调  Handler对象
		 * @return SoundChannel对象
		 */
		public static function playSound(url:String, loops:int = 1, complete:Handler = null):SoundChannel
		{
			if (_muted)
				return null;
			var tSound:Sound = Laya.loader.getRes(url);
			if (!tSound)
			{
				tSound = new Sound();
				tSound.load(url);
				Loader.cacheRes(url, tSound);
			}
			var channel:SoundChannel;
			channel = tSound.play(0, loops);
			channel.volume = (url == _tMusic) ? musicVolume : soundVolume;
			channel.completeHandler = complete;
			return channel;
		}
		
		/**
		 * 释放声音资源
		 * @param url 声音文件url
		 */
		public static function destroySound(url:String):void
		{
			var tSound:Sound = Laya.loader.getRes(url);
			if (tSound)
			{
				Loader.clearRes(url);
				tSound.dispose();
			}
		}
		
		/**
		 * 播放背景音乐
		 * @param url 声音文件url
		 * @param loops 循环次数,0表示无限循环
		 * @param complete  声音播放完成回调
		 * @return audio对象
		 */
		public static function playMusic(url:String, loops:int = 0, complete:Handler = null):SoundChannel
		{
			_tMusic = url;
			if (_musicChannel)
				_musicChannel.stop();
			return _musicChannel = playSound(url, loops, complete);
		}
		
		/**
		 * 停止声音播放
		 * @param url  声音文件url
		 */
		public static function stopSound(url:String):void
		{
			var i:int;
			var channel:SoundChannel;
			for (i = _channels.length - 1; i >= 0; i--)
			{
				channel = _channels[i];
				if (channel.url == url)
				{
					channel.stop();
				}
			}
		}
		
		/**
		 * 停止背景音乐播放
		 * @param url  声音文件url
		 */
		public static function stopMusic():void
		{
			if (_musicChannel)
				_musicChannel.stop();
		}
		
		/**
		 * 设置声音音量
		 * @param volume 音量 标准值为1
		 * @param url  声音文件url，为null(默认值)时对所有音效起作用，不为空时仅对对于声音生效
		 */
		public static function setSoundVolume(volume:Number, url:String = null):void
		{
			if (url)
			{
				_setVolume(url, volume);
			}
			else
			{
				soundVolume = volume;
			}
		}
		
		/**
		 * 设置背景音乐音量
		 * @param volume 音量  标准值为1
		 */
		public static function setMusicVolume(volume:Number):void
		{
			musicVolume = volume;
			_setVolume(_tMusic, volume);
		}
		
		/**
		 * 设置某个声音音量
		 * @param url  声音文件url
		 * @param volume 音量  标准值为1
		 */
		private static function _setVolume(url:String, volume:Number):void
		{
			var i:int;
			var channel:SoundChannel;
			for (i = _channels.length - 1; i >= 0; i--)
			{
				channel = _channels[i];
				if (channel.url == url)
				{
					channel.volume = volume;
				}
			}
		}
	}
}