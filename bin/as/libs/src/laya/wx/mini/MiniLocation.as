package laya.wx.mini 
{
	import laya.utils.Browser;
	/**@private **/
	public class MiniLocation 
	{
		/**@private **/
		private static var _watchDic:Object = { };
		/**@private **/
		private static var _curID:int = 0;
		public function MiniLocation() 
		{
			
		}
		
		/**@private **/
		public static function __init__():void
		{
			MiniAdpter.window.navigator.geolocation.getCurrentPosition = getCurrentPosition;
			MiniAdpter.window.navigator.geolocation.watchPosition = watchPosition;
			MiniAdpter.window.navigator.geolocation.clearWatch = clearWatch;
			
		}
		/**@private **/
		public static function getCurrentPosition(success:Function=null, error:Function=null, options:Object=null):void
		{
			
			var paramO:Object;
			paramO = { };
			paramO.success = getSuccess;
			paramO.fail = error;
			MiniAdpter.window.wx.getLocation(paramO);
			function getSuccess(res:*):void
			{
				if (success != null)
				{
					success(res);
				}
			}
		}
		
		/**@private **/
		public static function watchPosition(success:Function = null, error:Function = null, options:Object = null):int
		{
			_curID++;
			var curWatchO:Object;
			curWatchO = { };
			curWatchO.success = success;
			curWatchO.error = error;
			_watchDic[_curID] = curWatchO;
			Laya.timer.loop(1000, null, _myLoop);
			return _curID;
		}
		/**@private **/
		public static function clearWatch(id:int):void
		{
			delete _watchDic[id];
			if (!_hasWatch())
			{
				Laya.timer.clear(null, _myLoop);
			}
		}
		/**@private **/
		private static function _hasWatch():Boolean
		{
			var key:String;
			for (key in _watchDic)
			{
				if (_watchDic[key]) return true;
			}
			return false;
		}
		/**@private **/
		private static function _myLoop():void
		{
			getCurrentPosition(_mySuccess, _myError);
		}
		/**@private **/
		private static function _mySuccess(res:*):void
		{
			var rst:Object = { };
			rst.coords = res;
			rst.timestamp = Browser.now();
			var key:String;
			for (key in _watchDic)
			{
				if (_watchDic[key].success)
				{
					_watchDic[key].success(rst);
				}
			}
		}
		/**@private **/
		private static function _myError(res:*):void
		{
			var key:String;
			for (key in _watchDic)
			{
				if (_watchDic[key].error)
				{
					_watchDic[key].error(res);
				}
			}
		}
	}

}