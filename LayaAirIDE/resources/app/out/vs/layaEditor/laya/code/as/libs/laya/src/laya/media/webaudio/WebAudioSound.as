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
		public static var webAudioOK:Boolean = window["AudioContext"] || window["webkitAudioContext"] || window["mozAudioContext"];
		
		/**
		 * 播放设备
		 */
		public static var ctx:* = webAudioOK ? new (window["AudioContext"] || window["webkitAudioContext"] || window["mozAudioContext"])() : undefined;
		
		/**
		 * 当前要解码的声音文件列表
		 */
		public static var buffs:Array = [];
		
		/**
		 * 是否在解码中
		 */
		private static var isDecoding:Boolean = false;
		
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
		 * 当前解码的声音信息
		 */
		public static var tInfo:*;
		
		/**
		 * 解码成功回调
		 * @param audioBuffer
		 *
		 */
		private static function _done(audioBuffer:*):void {
			tInfo["me"].audioBuffer = audioBuffer;
			
			if (tInfo["loaded"]) {
				tInfo["loaded"]();
			}
			isDecoding = false;
			decode();
		}
		
		/**
		 * 解码失败回调
		 * @return
		 *
		 */
		private static function _fail():void {
			if (tInfo["err"]) {
				tInfo["err"]();
			}
			isDecoding = false;
			decode();
		}
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
		
		public function WebAudioSound() {
		
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
				_loaded();
				return;
			}
			var request:* = new Browser.window.XMLHttpRequest();
			request.open("GET", url, true);
			request.responseType = "arraybuffer";
			request.onload = function():void {
				me.data = request.response;
				
				buffs.push({"buffer": me.data, "loaded": _loaded, "err": _err, "me": me, "url": me.url});
				decode();
			};
			request.send();
			
			function _loaded():void {
				_dataCache[url] = me.audioBuffer;
				me.loaded = true;
				me.event(Event.COMPLETE);
			}
			
			function _err():void {
				me.event(Event.ERROR);
			}
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
					this.once(Event.COMPLETE, this, play, [startTime, loops, channel]);
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
		}
	}

}