package laya.media {
	import laya.events.EventDispatcher;
	import laya.utils.Handler;
	
	/**
	 * <code>SoundChannel</code> 用来控制程序中的声音。
	 */
	public class SoundChannel extends EventDispatcher {
		/**
		 * 声音地址。
		 */
		public var url:String;
		/**
		 * 循环次数。
		 */
		public var loops:int;
		/**
		 * 开始时间。
		 */
		public var startTime:Number;
		/**
		 * 表示声音是否已暂停。
		 */
		public var isStopped:Boolean = false;
		/**
		 * 播放完成处理器。
		 */
		public var completeHandler:Handler;
		
		public function set volume(v:Number):void {
		
		}
		
		/**
		 * 音量。
		 */
		public function get volume():Number {
			return 1;
		}
		
		/**
		 * 获取当前播放时间。
		 */
		public function get position():Number {
			return 0;
		}
		
		/**
		 * 播放。
		 */
		public function play():void {
		
		}
		
		/**
		 * 停止。
		 */
		public function stop():void {
		
		}
		/**
		 * private
		 */
		protected function __runComplete(handler:Handler):void
		{
			if (handler)
			{
				handler.run();
			}
		}
	}

}