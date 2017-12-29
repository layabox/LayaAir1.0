package laya.media.h5audio {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.media.SoundChannel;
	import laya.media.SoundManager;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Pool;
	
	/**
	 * @private
	 * 使用Audio标签播放声音
	 */
	public class AudioSound extends EventDispatcher {
		
		private static var _audioCache:Object = {};
		/**
		 * 声音URL
		 */
		public var url:String;
		/**
		 * 播放用的audio标签
		 */
		public var audio:Audio;
		/**
		 * 是否已加载完成
		 */
		public var loaded:Boolean = false;
		/**@private */
		public static var _musicAudio:Audio;
		/**
		 * 释放声音
		 *
		 */
		public function dispose():void {
			var ad:Audio = _audioCache[url];
			if (ad) {
				ad.src = "";
				delete _audioCache[url];	
			}
		}
		
		/**@private */
		public static function _initMusicAudio():void
		{
			if (_musicAudio) return;
			if (!_musicAudio) _musicAudio = Browser.createElement("audio") as Audio;
			if (!Render.isConchApp) {
				Browser.document.addEventListener("mousedown", _makeMusicOK);
			}
		}
		
		/**@private */
		private static function _makeMusicOK():void
		{
			Browser.document.removeEventListener("mousedown", _makeMusicOK);
			if (!_musicAudio.src)
			{
				_musicAudio.src = "";
				_musicAudio.load();
			}else
			{
				_musicAudio.play();
			}
		}
		
		
		/**
		 * 加载声音
		 * @param url
		 *
		 */
		public function load(url:String):void {
			url = URL.formatURL(url);
			this.url = url;
			var ad:Audio;
			if (url == SoundManager._tMusic)
			{
				_initMusicAudio();
				ad = _musicAudio;
				if (ad.src != url)
				{
					_audioCache[ad.src] = null;
					ad = null;
				}
			}else
			{
				ad = _audioCache[url];
			}
			if (ad && ad.readyState >= 2) {
				event(Event.COMPLETE);
				return;
			}
			if (!ad) {
				if (url == SoundManager._tMusic)
				{
					_initMusicAudio();
					ad = _musicAudio;
				}else
				{
					ad = Browser.createElement("audio") as Audio;		
				}
				_audioCache[url] = ad;
				ad.src = url;		
			}
			
			ad.addEventListener("canplaythrough", onLoaded);
			ad.addEventListener("error", onErr);
			var me:AudioSound = this;
			function onLoaded():void {
				offs();
				me.loaded = true;
				me.event(Event.COMPLETE);
			}
			
			function onErr():void {
				ad.load = null;
				offs();
				me.event(Event.ERROR);
			}
			
			function offs():void {
				ad.removeEventListener("canplaythrough", onLoaded);
				ad.removeEventListener("error", onErr);
			}
			
			this.audio = ad;
			if (ad.load) {
				ad.load();
			} else {
				onErr();
			}
		
		}
		
		/**
		 * 播放声音
		 * @param startTime 起始时间
		 * @param loops 循环次数
		 * @return
		 *
		 */
		public function play(startTime:Number = 0, loops:Number = 0):SoundChannel {
			//trace("playAudioSound");
			if (!url) return null;
			var ad:Audio;
			if (url == SoundManager._tMusic)
			{
				ad = _musicAudio;
			}else
			{
				ad = _audioCache[url];
			}
			
			if (!ad) return null;
			var tAd:Audio;

			tAd = Pool.getItem("audio:" + url);
			
			if ( Render.isConchApp ){
				if ( !tAd ){
					tAd = Browser.createElement("audio") as Audio;
					tAd.src = this.url;
				}
			}
			else {
				if (url == SoundManager._tMusic)
				{
					_initMusicAudio();
					tAd = _musicAudio;		
					tAd.src = url;
				}else
				{
					tAd = tAd ? tAd : ad.cloneNode(true);
				}			
			}
			var channel:AudioSoundChannel = new AudioSoundChannel(tAd);
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
			var ad:Audio;
			ad = _audioCache[url];
			if (!ad)
				return 0;
			return ad.duration;
		}
	
	}

}