/*[IF-FLASH]*/
package laya.media
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import laya.events.EventDispatcher;
	import laya.utils.Handler;
	
	/**
	 * <code>SoundChannel</code> 用来控制程序中的声音。
	 */
	public class SoundChannel extends EventDispatcher
	{
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
		
		private var _channel:flash.media.SoundChannel;
		
		public function set volume(v:Number):void
		{
			if (!_channel) return;
			var st:SoundTransform = new SoundTransform();
			st.volume = v;
			_channel.soundTransform = st;
		}
		
		/**
		 * 音量。
		 */
		public function get volume():Number
		{
			if (!_channel) return 0;
			return _channel.soundTransform.volume;
		}
		
		/**
		 * 获取当前播放时间。
		 */
		public function get position():Number
		{
			if (!_channel) return 0;
			return _channel.position;
		}
		
		public function set flashChannel(flashChannel:flash.media.SoundChannel):void
		{
			if (_channel)
			{
				_channel.removeEventListener(Event.SOUND_COMPLETE, stoped);
			}	
			_channel = flashChannel;
			if (!flashChannel)
			{
				stoped(null);
				return;
			}
			_channel.addEventListener(Event.SOUND_COMPLETE, stoped);
		}
		
		/**
		 * 播放。
		 */
		public function play():void
		{
		
		}
		
		/**
		 * 停止。
		 */
		public function stop():void
		{
			if (completeHandler)
			{
				completeHandler.run();
				completeHandler = null;
			}			
			if (_channel)
			{
				_channel.stop();
				_channel.removeEventListener(Event.SOUND_COMPLETE, stoped);
			}
			stoped(null);
		}
		
		private function stoped(e:*):void
		{
			SoundManager.removeChannel(this);
		}
	}

}