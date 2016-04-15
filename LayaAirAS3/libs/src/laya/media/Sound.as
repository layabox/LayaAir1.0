package laya.media {
	import laya.events.EventDispatcher;
	
	/**
	 * 声音类
	 * @author ww
	 */
	public class Sound extends EventDispatcher {
		
		/**
		 * 加载声音
		 * @param url
		 *
		 */
		public function load(url:String):void {
		
		}
		
		/**
		 * 播放声音
		 * @param startTime 开始时间,单位秒
		 * @param loops 循环次数,0表示一直循环
		 * @return
		 *
		 */
		public function play(startTime:Number = 0, loops:Number = 0):SoundChannel {
			return null;
		}
		
		/**
		 * 释放声音资源
		 *
		 */
		public function dispose():void {
		
		}
	
	}

}