package laya.media {
	import laya.events.EventDispatcher;
	
	/**
	 * <code>Sound</code> 类是用来播放控制声音的类。
	 */
	public class Sound extends EventDispatcher {
		
		/**
		 * 加载声音。
		 * @param url 地址。
		 *
		 */
		public function load(url:String):void {
		
		}
		
		/**
		 * 播放声音。
		 * @param startTime 开始时间,单位秒
		 * @param loops 循环次数,0表示一直循环
		 * @return 声道 SoundChannel 对象。
		 *
		 */
		public function play(startTime:Number = 0, loops:Number = 0):SoundChannel {
			return null;
		}
		
		/**
		 * 获取总时间。
		 */
		public function get duration():Number {
			return 0;
		}
		
		/**
		 * 释放声音资源。
		 *
		 */
		public function dispose():void {
		
		}
	
	}

}