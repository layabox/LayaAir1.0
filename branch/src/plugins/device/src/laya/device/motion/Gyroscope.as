package laya.device.motion
{
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Browser;
	
	/**
	 * 使用Gyroscope.instance获取唯一的Gyroscope引用，请勿调用构造函数。
	 * 
	 * <p>
	 * listen()的回调处理器接受两个参数：
	 * <code>function onOrientationChange(absolute:Boolean, info:RotationInfo):void</code>
	 * <ol>
	 * <li><b>absolute</b>: 指示设备是否可以提供绝对方位数据（指向地球坐标系），或者设备决定的任意坐标系。关于坐标系参见<i>https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Orientation_and_motion_data_explained</i>。</li>
	 * <li><b>info</b>: <code>RotationInfo</code>类型参数，保存设备的旋转值。</li>
	 * </ol>
	 * </p>
	 * 
	 * <p>
	 * 浏览器兼容性参见：<i>http://caniuse.com/#search=deviceorientation</i>
	 * </p>
	 */
	public class Gyroscope extends EventDispatcher
	{
		private static var info:RotationInfo = new RotationInfo();
		
		/**
		 * Gyroscope的唯一引用。
		 */
		private static var _instance:Gyroscope;
		public static function get instance():Gyroscope
		{
			_instance ||= new Gyroscope(0);
			return _instance;
		}
		
		public function Gyroscope(singleton:int)
		{
			__JS__("this.onDeviceOrientationChange = this.onDeviceOrientationChange.bind(this)");
		}
		
		/**
		 * 监视陀螺仪运动。
		 * @param	observer	回调函数接受一个Boolean类型的<code>absolute</code>和<code>GyroscopeInfo</code>类型参数。
		 */
		override public function on(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher 
		{
			super.on(type, caller, listener, args);
			Browser.window.addEventListener('deviceorientation', onDeviceOrientationChange);
			return this;
		}
		
		/**
		 * 取消指定处理器对陀螺仪的监视。
		 * @param	observer
		 */
		override public function off(type:String, caller:*, listener:Function, onceOnly:Boolean = false):EventDispatcher 
		{
			if (!hasListener(type))
				Browser.window.removeEventListener('deviceorientation', onDeviceOrientationChange);
				
			return super.off(type, caller, listener, onceOnly);
		}
		
		private function onDeviceOrientationChange(e:*):void
		{
			info.alpha = e.alpha;
			info.beta = e.beta;
			info.gamma = e.gamma;
			
			// 在Safari中
			if (e.webkitCompassHeading)
			{
				info.alpha = e.webkitCompassHeading * -1;
				info.compassAccuracy = e.webkitCompassAccuracy;
			}
			
			event(Event.CHANGE, [e.absolute, info]);
		}
	}
}