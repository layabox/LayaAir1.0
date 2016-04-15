package laya.media {
	import laya.events.EventDispatcher;
	import laya.utils.Handler;
	/**
	 * 声音播放控制
	 * @author ww
	 */
	public class SoundChannel extends EventDispatcher {
		/**
		 * 声音url
		 */
		public var url:String;
		/**
		 * 循环次数
		 */
		public var loops:int;
		/**
		 * 开始时间
		 */
		public var startTime:Number;
		/**
		 * 是否已暂停
		 */
		public var isStopped:Boolean = false;
		
		public var completeHandler:Handler;
		
		/**
		 * 设置音量
		 * @param v
		 *
		 */
		public function set volume(v:Number):void {
		
		}
		
		/**
		 * 获取音量
		 * @return
		 *
		 */
		public function get volume():Number {
			return 1;
		}
		
		/**
		 * 获取当前播放时间
		 * @return
		 *
		 */
		public function get position():Number {
			return 0;
		}
		
		/**
		 * 播放
		 *
		 */
		public function play():void {
		
		}
		
		/**
		 * 停止
		 *
		 */
		public function stop():void {
		
		}
	}

}