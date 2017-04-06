package laya.debug.tools 
{
	import laya.utils.Browser;
	/**
	 * 全局时间速率控制类
	 * @author ww
	 */
	public class TimerControlTool 
	{
		
		public function TimerControlTool() 
		{
			
		}
		/**
		 * 获取浏览器当前时间
		 */
		public static function now():Number {
			if (_timeRate != 1) return getRatedNow();
			//[IF-JS]return Date.now();
			/*[IF-FLASH]*/ return 0;
		}
		
		public static function getRatedNow():Number
		{
			var dTime:Number;
			dTime = getNow() - _startTime;
			return dTime * _timeRate + _startTime;
		}
		public static function getNow():Number
		{
			//[IF-JS]return Date.now();
			/*[IF-FLASH]*/ return 0;
		}
		private static var _startTime:Number;
		private static var _timeRate:Number = 1;
		public static var _browerNow:Function;
		public static function setTimeRate(rate:Number):void
		{
			if (_browerNow==null) _browerNow = Browser["now"];
			_startTime = getNow();
			_timeRate = rate;
			if (rate != 1)
			{
				Browser["now"] = now;
			}else
			{
				if(_browerNow!=null)
					Browser["now"] = _browerNow;
			}
		}
		
		public static function recoverRate():void
		{
			setTimeRate(1);
		}
		
	}

}