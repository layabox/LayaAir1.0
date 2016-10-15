package laya.media.webaudio {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.media.SoundChannel;
	import laya.media.SoundManager;
	import laya.utils.Browser;
	
	/**
	 * @private
	 * web audio api方式播放声音
	 */
	public class WebAudioSound extends EventDispatcher {
		
		public static var window:* = Browser.window;
		
		private static var _dataCache:Object = {};
		
		/**
		 * 是否支持web audio api
		 */
		public static var webAudioEnabled:Boolean = window["AudioContext"] || window["webkitAudioContext"] || window["mozAudioContext"];
		
		/**
		 * 播放设备
		 */
		public static var ctx:* = webAudioEnabled ? new (window["AudioContext"] || window["webkitAudioContext"] || window["mozAudioContext"])() : undefined;
		
		/**
		 * 当前要解码的声音文件列表
		 */
		public static var buffs:Array = [];
		
		/**
		 * 是否在解码中
		 */
		public static var isDecoding:Boolean = false;
		
		/**
		 * 用于播放解锁声音以及解决Ios9版本的内存释放 
		 */
		public static var _miniBuffer:* =ctx.createBuffer(1, 1, 22050);
		

		/**
		 * 事件派发器，用于处理加载解码完成事件的广播 
		 */
		public static var e:EventDispatcher = new EventDispatcher();
		/**
		 * 是否已解锁声音播放 
		 */
		private static var _unlocked:Boolean = false;
		/**
		 * 当前解码的声音信息
		 */
		public static var tInfo:*;
		
		private static var __loadingSound:Object = { };
		/**
		 * 声音URL
		 */
		public var url:String;
		/**
		 * 是否已加载完成
		 */
		public var loaded:Boolean = false;
		
		/**
		 * 声音文件数据
		 */
		public var data:ArrayBuffer;
		/**
		 * 声音原始文件数据
		 */
		public var audioBuffer:*;
		/**
		 * 待播放的声音列表 
		 */
		private var __toPlays:Array;
	
		
		
		/**
		 * 解码声音文件
		 *
		 */
		public static function decode():void {
			if (buffs.length <= 0 || isDecoding) {
				return;
			}
			isDecoding = true;
			tInfo = buffs.shift();
			ctx.decodeAudioData(tInfo["buffer"], _done, _fail);
		}
		
		/**
		 * 解码成功回调
		 * @param audioBuffer
		 *
		 */
		private static function _done(audioBuffer:*):void {
			e.event("loaded:"+tInfo.url, audioBuffer);
			isDecoding = false;
			decode();
		}
		
		/**
		 * 解码失败回调
		 * @return
		 *
		 */
		private static function _fail():void {
			e.event("err:"+tInfo.url,null);
			isDecoding = false;
			decode();
		}
		
		/**
		 * 播放声音以解锁IOS的声音 
		 * 
		 */
		private static function _playEmptySound():void{
			if (ctx == null) {return;}
			var source:* = ctx.createBufferSource();
			source.buffer = _miniBuffer;
			source.connect(ctx.destination);
			source.start(0, 0, 0);
		}
		
		
		/**
		 * 尝试解锁声音 
		 * 
		 */
		private static function _unlock():void{
			if (_unlocked) { return; }
			_playEmptySound();
			if (ctx.state == "running") {
				Browser.document.removeEventListener("mousedown", _unlock, true);
				Browser.document.removeEventListener("touchend", _unlock, true);
				_unlocked = true;
			}
		};
		
		public static function initWebAudio():void
		{
			if (ctx.state != "running") {
				_unlock(); // When played inside of a touch event, this will enable audio on iOS immediately.
				Browser.document.addEventListener("mousedown", _unlock, true);
				Browser.document.addEventListener("touchend", _unlock, true);
			}
		}

		/**
		 * 加载声音
		 * @param url
		 *
		 */
		public function load(url:String):void {
			var me:WebAudioSound = this;
			
			this.url = url;
			
			audioBuffer = _dataCache[url];
			if (audioBuffer) {
				_loaded(audioBuffer);
				return;
			}
			e.on("loaded:" + url, this, _loaded);
			e.on("err:" + url, this, _err);		
			if (__loadingSound[url])
			{		
				return;
			}
			__loadingSound[url] = true;

			var request:* = new Browser.window.XMLHttpRequest();
			request.open("GET", url, true);
			request.responseType = "arraybuffer";
			request.onload = function():void {
				me.data = request.response;			
				buffs.push({"buffer": me.data, "url": me.url});
				decode();
			};
			request.onerror = function(e:*):void {
				me._err();
			}
			request.send();		
		}
		private function _err():void {
			    _removeLoadEvents();
				__loadingSound[url] = false;
				this.event(Event.ERROR);
		}
		private function _loaded(audioBuffer:*):void {
			    _removeLoadEvents();
			    this.audioBuffer = audioBuffer;
				_dataCache[url] = this.audioBuffer;
				this.loaded = true;
				this.event(Event.COMPLETE);
		}
		private function _removeLoadEvents():void
		{
			e.off("loaded:" + url, this, _loaded);
			e.off("err:" + url, this, _err);
		}
		
		private function __playAfterLoaded():void
		{
			if (!__toPlays) return;
			var i:int, len:int;
			var toPlays:Array;
			toPlays = __toPlays;
			len = toPlays.length;
			var tParams:Array;
			for (i = 0; i < len; i++)
			{
				tParams = toPlays[i];
				if(tParams[2]&&!(tParams[2] as WebAudioSoundChannel).isStopped)
				{
					play(tParams[0],tParams[1],tParams[2]);
			    }			
			}
			__toPlays.length = 0;
		}
		/**
		 * 播放声音
		 * @param startTime 起始时间
		 * @param loops 循环次数
		 * @return
		 *
		 */
		public function play(startTime:Number = 0, loops:Number = 0, channel:SoundChannel = null):SoundChannel {
			//trace("playWebAudioSound");
			channel = channel ? channel : new WebAudioSoundChannel();
			if (!audioBuffer) {
				if (url) {
					if (!__toPlays) __toPlays = [];
					__toPlays.push([startTime, loops, channel]);
					this.once(Event.COMPLETE, this, __playAfterLoaded);
					load(url);
				}
					//return null;
			}
			channel.url = this.url;
			channel.loops = loops;
			channel["audioBuffer"] = this.audioBuffer;
			channel.startTime = startTime;
			channel.play();
			SoundManager.addChannel(channel);
			return channel;
		}
		
		public function dispose():void {
			delete _dataCache[url];
			delete __loadingSound[url];
		}
	}

}