package laya.wx.mini 
{
	import laya.events.EventDispatcher;
	
	/**@private **/
	public class MiniAccelerator extends EventDispatcher
	{
		
		public function MiniAccelerator() 
		{
			
		}
		/**@private **/
		public static function __init__():void
		{
			try
			{
				var Acc:*;
				Acc = __JS__("laya.device.motion.Accelerator");
				if (!Acc) return;
				Acc["prototype"]["on"] = MiniAccelerator["prototype"]["on"];
				Acc["prototype"]["off"] = MiniAccelerator["prototype"]["off"];
			}catch (e:*)
			{
				
			}
		}
		/**@private **/
		private static var _isListening:Boolean = false;
		/**@private **/
		private static var _callBack:Function;
		/**@private **/
		public static function startListen(callBack:Function):void
		{
			_callBack = callBack;
			if (_isListening) return;
			_isListening = true;
			try
			{
				__JS__("wx.onAccelerometerChange(MiniAccelerator.onAccelerometerChange)");
			}catch(e:*){}
			
		}
		
		/**@private **/
		public static function stopListen():void
		{
			_isListening = false;
			try
			{
				__JS__("wx.stopAccelerometer({})");
			}catch(e:*){}
			
		}
		/**@private **/
		private static function onAccelerometerChange(res:Object):void
		{
			var e:Object;
			e = { };
			e.acceleration = res;
			e.accelerationIncludingGravity = res;
			e.rotationRate = { };
			if (_callBack != null)
			{
				_callBack(e);
			}
		}
		
		/**
		 * 侦听加速器运动。
		 * @param observer	回调函数接受4个参数，见类说明。
		 */
		override public function on(type:String, caller:*, listener:Function, args:Array = null):EventDispatcher
		{
			super.on(type, caller, listener, args);
			startListen(this["onDeviceOrientationChange"]);
			return this;
		}
		
		/**
		 * 取消侦听加速器。
		 * @param	handle	侦听加速器所用处理器。
		 */
		override public function off(type:String, caller:*, listener:Function, onceOnly:Boolean = false):EventDispatcher
		{
			if (!hasListener(type))
				stopListen();
			
			return super.off(type, caller, listener, onceOnly);
		}
	}

}