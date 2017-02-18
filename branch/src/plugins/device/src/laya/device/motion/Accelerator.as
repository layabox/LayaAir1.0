package laya.device.motion
{
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Browser;
	
	/**
	 * Accelerator.instance获取唯一的Accelerator引用，请勿调用构造函数。
	 *
	 * <p>
	 * listen()的回调处理器接受四个参数：
	 * <ol>
	 * <li><b>acceleration</b>: 表示用户给予设备的加速度。</li>
	 * <li><b>accelerationIncludingGravity</b>: 设备受到的总加速度（包含重力）。</li>
	 * <li><b>rotationRate</b>: 设备的自转速率。</li>
	 * <li><b>interval</b>: 加速度获取的时间间隔（毫秒）。</li>
	 * </ol>
	 * </p>
	 * <p>
	 * <b>NOTE</b><br/>
	 * 如，rotationRate的alpha在apple和moz文档中都是z轴旋转角度，但是实测是x轴旋转角度。为了使各属性表示的值与文档所述相同，实际值与其他属性进行了对调。
	 * 其中：
	 * <ul>
	 * <li>alpha使用gamma值。</li>
	 * <li>beta使用alpha值。</li>
	 * <li>gamma使用beta。</li>
	 * </ul>
	 * 目前孰是孰非尚未可知，以此为注。
	 * </p>
	 */
	public class Accelerator extends EventDispatcher
	{
		/**
		 * Accelerator的唯一引用。
		 */
		private static var _instance:Accelerator;
		
		public static function get instance():Accelerator
		{
			_instance ||= new Accelerator(0)
			return _instance;
		}
		
		private static var acceleration:AccelerationInfo = new AccelerationInfo();
		private static var accelerationIncludingGravity:AccelerationInfo = new AccelerationInfo();
		private static var rotationRate:RotationInfo = new RotationInfo();
		
		private static var onChrome:Boolean = (Browser.userAgent.indexOf("Chrome") > -1);
		
		public function Accelerator(singleton:int)
		{
			__JS__("this.onDeviceOrientationChange = this.onDeviceOrientationChange.bind(this)");
		}
		
		/**
		 * 侦听加速器运动。
		 * @param observer	回调函数接受4个参数，见类说明。
		 */
		override public function on(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher
		{
			super.on(type, caller, listener, args);
			Browser.window.addEventListener('devicemotion', onDeviceOrientationChange);
			return this;
		}
		
		/**
		 * 取消侦听加速器。
		 * @param	handle	侦听加速器所用处理器。
		 */
		override public function off(type:String, caller:*, listener:Function, onceOnly:Boolean = false):EventDispatcher
		{
			if (!hasListener(type))
				Browser.window.removeEventListener('devicemotion', onDeviceOrientationChange)
			
			return super.off(type, caller, listener, onceOnly);
		}
		
		private function onDeviceOrientationChange(e:*):void
		{
			var interval:Number = e.interval;
			
			acceleration.x = e.acceleration.x;
			acceleration.y = e.acceleration.y;
			acceleration.z = e.acceleration.z;
			
			accelerationIncludingGravity.x = e.accelerationIncludingGravity.x;
			accelerationIncludingGravity.y = e.accelerationIncludingGravity.y;
			accelerationIncludingGravity.z = e.accelerationIncludingGravity.z;
			
			rotationRate.alpha = e.rotationRate.gamma * -1;
			rotationRate.beta = e.rotationRate.alpha * -1;
			rotationRate.gamma = e.rotationRate.beta;
			
			if (Browser.onAndriod)
			{
				if (onChrome)
				{
					rotationRate.alpha *= 180 / Math.PI;
					rotationRate.beta *= 180 / Math.PI;
					rotationRate.gamma *= 180 / Math.PI;
				}
				
				acceleration.x *= -1;
				accelerationIncludingGravity.x *= -1;
			}
			else if (Browser.onIOS)
			{
				acceleration.y *= -1;
				acceleration.z *= -1;
				
				accelerationIncludingGravity.y *= -1;
				accelerationIncludingGravity.z *= -1;
				
				interval *= 1000;
			}
			
			event(Event.CHANGE, [acceleration, accelerationIncludingGravity, rotationRate, interval]);
		}
		
		private static var transformedAcceleration:AccelerationInfo;
		/**
		 * 把加速度值转换为视觉上正确的加速度值。依赖于Browser.window.orientation，可能在部分低端机无效。
		 * @param	acceleration
		 * @return
		 */
		public static function getTransformedAcceleration(acceleration:AccelerationInfo):AccelerationInfo
		{
			transformedAcceleration ||= new AccelerationInfo();
			transformedAcceleration.z = acceleration.z;
			
			if (Browser.window.orientation == 90)
			{
				transformedAcceleration.x = acceleration.y;
				transformedAcceleration.y = -acceleration.x;
			}
			else if (Browser.window.orientation == -90)
			{
				transformedAcceleration.x = -acceleration.y;
				transformedAcceleration.y = acceleration.x;
			}
			else if (!Browser.window.orientation)
			{
				transformedAcceleration.x = acceleration.x;
				transformedAcceleration.y = acceleration.y;
			}
			else if (Browser.window.orientation == 180)
			{
				transformedAcceleration.x = -acceleration.x;
				transformedAcceleration.y = -acceleration.y;
			}
			
			var tx:Number;
			if (Laya.stage.canvasDegree == -90)
			{
				tx = transformedAcceleration.x;
				transformedAcceleration.x = -transformedAcceleration.y;
				transformedAcceleration.y = tx;
			}
			else if (Laya.stage.canvasDegree == 90)
			{
				tx = transformedAcceleration.x;
				transformedAcceleration.x = transformedAcceleration.y;
				transformedAcceleration.y = -tx;
			}
			
			return transformedAcceleration;
		}
	}
}

