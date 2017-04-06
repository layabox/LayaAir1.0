package laya.device 
{
	import laya.device.motion.AccelerationInfo;
	import laya.device.motion.Accelerator;
	import laya.device.motion.RotationInfo;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Browser;
	import laya.utils.Handler;

	/**
	 * Shake只能在支持此操作的设备上有效。
	 * 
	 * @author Survivor
	 */
	public class Shake extends EventDispatcher
	{
		private var throushold:int;
		private var shakeInterval:int;
		private var callback:Handler;
		
		private var lastX:Number;
		private var lastY:Number;
		private var lastZ:Number;

		private var lastMillSecond:Number;
		
		public function Shake() 
		{
			
		}
		
		private static var _instance:Shake;
		public static function get instance():Shake
		{
			_instance ||= new Shake();
			return _instance;
		}
		
		/**
		 * 开始响应设备摇晃。
		 * @param	throushold	响应的瞬时速度阈值，轻度摇晃的值约在5~10间。
		 * @param	timeout		设备摇晃的响应间隔时间。
		 * @param	callback	在设备摇晃触发时调用的处理器。
		 */
		public function start(throushold:int, interval:int):void
		{
			this.throushold = throushold;
			this.shakeInterval = interval;
			
			lastX = lastY = lastZ = NaN;
			
			// 使用加速器监听设备运动。
			Accelerator.instance.on(Event.CHANGE, this, onShake);
		}

		/**
		 * 停止响应设备摇晃。
		 */
		public function stop():void
		{
			Accelerator.instance.off(Event.CHANGE, this, onShake);
		}
		
		private function onShake(acceleration:AccelerationInfo, accelerationIncludingGravity:AccelerationInfo, rotationRate:RotationInfo, interval:Number):void 
		{
			// 设定摇晃的初始状态。
			if(isNaN(lastX))
			{
				lastX = accelerationIncludingGravity.x;
				lastY = accelerationIncludingGravity.y;
				lastZ = accelerationIncludingGravity.z;

				lastMillSecond = Browser.now();
				return;
			}

			// 速度增量计算。
			var deltaX:Number = Math.abs(lastX - accelerationIncludingGravity.x);
			var deltaY:Number = Math.abs(lastY - accelerationIncludingGravity.y);
			var deltaZ:Number = Math.abs(lastZ - accelerationIncludingGravity.z);

			// 是否满足摇晃选项。
			if(isShaked(deltaX, deltaY, deltaZ))
			{
				var deltaMillSecond:int = Browser.now() - lastMillSecond;
				
				// 按照设定间隔触发摇晃。
				if (deltaMillSecond > shakeInterval)
				{
					event(Event.CHANGE);
					lastMillSecond = Browser.now();
				}
			}

			lastX = accelerationIncludingGravity.x;
			lastY = accelerationIncludingGravity.y;
			lastZ = accelerationIncludingGravity.z;
		} 

		// 通过任意两个分量判断是否满足摇晃设定。
		private function isShaked(deltaX:Number, deltaY:Number, deltaZ:Number):Boolean
		{
			return (deltaX > throushold && deltaY > throushold) ||
				   (deltaX > throushold && deltaZ > throushold) ||
				   (deltaY > throushold && deltaZ > throushold)
		}
	}
}