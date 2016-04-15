package laya.media.h5audio {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.media.SoundChannel;
	import laya.media.SoundManager;
	import laya.utils.Browser;
	import laya.utils.Pool;

	/**
	 * 使用Audio标签播放声音
	 * @author ww
	 */
	public class AudioSound extends EventDispatcher {
		
		/**
		 * 声音URL
		 */
		private var url:String;
		/**
		 * 播放用的audio标签
		 */
		private var audio:Audio;
		/**
		 * 是否已加载完成
		 */
		private var loaded:Boolean = false;
		
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
		
		private static var _audioCache:Object = {};
		
		/**
		 * 加载声音
		 * @param url
		 *
		 */
		public function load(url:String):void {
			this.url = url;
			var ad:Audio = _audioCache[url];
			if (ad && ad.readyState >= 2) {
				event(Event.COMPLETE);
				return;
			}
			if (!ad) {
				ad = Browser.createElement("audio") as Audio;
				ad.src = url;
				_audioCache[url] = ad;
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
				offs();
				me.event(Event.ERROR);
			}
			
			function offs():void {
				ad.removeEventListener("canplaythrough", onLoaded);
				ad.removeEventListener("error", onErr);
			}
			
			this.audio = ad;
			ad.load();
		}
		
		/**
		 * 播放声音
		 * @param startTime 起始时间
		 * @param loops 循环次数
		 * @return
		 *
		 */
		public function play(startTime:Number = 0, loops:Number = 0):SoundChannel {
			if (!url) return null;
			var ad:Audio;
			ad = _audioCache[url];
			if (!ad) return null;
			ad.autoplay = true;
			var tAd:Audio;
			tAd=Pool.getItem(url);
			tAd=tAd?tAd:ad.cloneNode();
			var channel:AudioSoundChannel = new AudioSoundChannel(tAd);
			channel.url = this.url;
			channel.loops = loops;
			channel.startTime = startTime;
			channel.play();
			SoundManager.addChannel(channel);
			return channel;
		}
	
	}

}