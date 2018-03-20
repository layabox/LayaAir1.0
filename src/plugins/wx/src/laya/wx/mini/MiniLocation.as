package laya.wx.mini 
{
	import laya.utils.Browser;
	/**
	 * ...
	 * @author ww
	 */
	public class MiniLocation 
	{
		private static var _watchDic:Object = { };
		private static var _curID:int = 0;
		public function MiniLocation() 
		{
			
		}
		
		public static function __init__():void
		{
			MiniAdpter.window.navigator.geolocation.getCurrentPosition = getCurrentPosition;
			MiniAdpter.window.navigator.geolocation.watchPosition = watchPosition;
			MiniAdpter.window.navigator.geolocation.clearWatch = clearWatch;
			
		}
		
		public static function getCurrentPosition(success:Function=null, error:Function=null, options:Object=null):void
		{
			MiniAdpter.window.wx.getLocation(function getSuccess(res:*):void
			{
				var rst:Object = { };
				rst.coords = res;
				rst.timestamp = Browser.now();
				if (success != null)
				{
					success(rst);
				}
			}, error);
			
		}
		
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
		
		public static function clearWatch(id:int):void
		{
			delete _watchDic[id];
			if (!_hasWatch())
			{
				Laya.timer.clear(null, _myLoop);
			}
		}
		
		private static function _hasWatch():Boolean
		{
			var key:String;
			for (key in _watchDic)
			{
				if (_watchDic[key]) return true;
			}
			return false;
		}
		
		private static function _myLoop():void
		{
			getCurrentPosition(_mySuccess, _myError);
		}
		
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