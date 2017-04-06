/*[IF-FLASH]*/
package laya.media.flashaudio
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import laya.events.EventDispatcher;
	import laya.media.SoundManager;
	import laya.utils.Handler;
	
	/**
	 * <code>SoundChannel</code> 用来控制程序中的声音。
	 */
	public class FlashSoundChannel extends laya.media.SoundChannel
	{
		
		
		private var _channel:SoundChannel;
		
		override public function set volume(v:Number):void
		{
			if (!_channel) return;
			var st:SoundTransform = new SoundTransform();
			st.volume = v;
			_channel.soundTransform = st;
		}
		
		/**
		 * 音量。
		 */
		override public function get volume():Number
		{
			if (!_channel) return 0;
			return _channel.soundTransform.volume;
		}
		
		/**
		 * 获取当前播放时间。
		 */
		override public function get position():Number
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
		override public function play():void
		{
		
		}
		
		/**
		 * 停止。
		 */
		override public function stop():void
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