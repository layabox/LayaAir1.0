/*[IF-FLASH]*/package laya.media {
	import flash.media.Sound;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	
	/**
	 * <code>Sound</code> 类是用来播放控制声音的类。
	 */
	public class Sound extends EventDispatcher {
		
		private var _sound:flash.media.Sound;
		public function Sound():void
		{
			_sound = new flash.media.Sound();
		}
		private var _url:String;
		/**
		 * 加载声音。
		 * @param url 地址。
		 *
		 */
		public function load(url:String):void {
			_url = url;
		    _sound.load(new URLRequest(url));
			_sound.addEventListener(Event.COMPLETE, completeHandler);
            _sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function completeHandler(event:*):void {
			this.event(Event.COMPLETE);
        }
        private function ioErrorHandler(event:*):void {
			this.event(Event.ERROR);
        }
		/**
		 * 播放声音。
		 * @param startTime 开始时间,单位秒
		 * @param loops 循环次数,0表示一直循环
		 * @return 声道 SoundChannel 对象。
		 *
		 */
		public function play(startTime:Number = 0, loops:Number = 0):SoundChannel {
			var rst:SoundChannel;
			rst = new SoundChannel();
			rst.flashChannel=_sound.play(startTime, loops);
			rst.url = this._url;
			rst.loops = loops;
			rst.startTime = startTime;
			SoundManager.addChannel(rst);
			return rst;
		}
		
		/**
		 * 释放声音资源。
		 *
		 */
		public function dispose():void {
		
		}
	
	}

}