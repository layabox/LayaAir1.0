package laya.ui
{
	import laya.display.FrameAnimation;
		
	/**
	 * 动画播放完毕后调度。
	 * @eventType Event.COMPLETE
	 */
	[Event(name = "complete", type = "laya.events.Event")]
	
	/**
	 * 播放到某标签后调度。
	 * @eventType Event.LABEL
	 */
	[Event(name = "label", type = "laya.events.Event")]
	/**
	 * 关键帧动画播放类
	 * 
	 */
	public class FrameClip extends FrameAnimation
	{
		/**
		 * 创建一个 <code>FrameClip</code> 实例。
		 */
		public function FrameClip()
		{
			super();
		}
	}
}