package laya.utils 
{
	/**
	 * 对象缓存统一管理类
	 */
	public class CacheManger 
	{
		/**
		 * 单次清理检测允许执行的时间，单位ms 
		 */
		public static var loopTimeLimit:int = 2;
		/**
		 * @private 
		 */
		private static var _cacheList:Array = [];	
		/**
		 * @private 
		 * 当前检测的索引
		 */
		private static var _index:int = 0;
		
		public function CacheManger() 
		{
			
		}
		
		/**
		 * 注册cache管理函数
		 * @param disposeFunction 释放函数 fun(force:Boolean)
		 * @param getCacheListFunction 获取cache列表函数fun():Array
		 * 
		 */
		public static function regCacheByFunction(disposeFunction:Function, getCacheListFunction:Function):void
		{
			unRegCacheByFunction(disposeFunction,getCacheListFunction);
			var cache:Object;
			cache = 
			{
				tryDispose:disposeFunction,
				getCacheList:getCacheListFunction
			};
			_cacheList.push(cache);
		}
		/**
		 * 移除cache管理函数
		 * @param disposeFunction 释放函数 fun(force:Boolean)
		 * @param getCacheListFunction 获取cache列表函数fun():Array
		 * 
		 */
		public static function unRegCacheByFunction(disposeFunction:Function, getCacheListFunction:Function):void
		{
			var i:int, len:int;
			len = _cacheList.length;
			for (i = 0; i < len; i++)
			{
				if (_cacheList[i].tryDispose == disposeFunction && _cacheList[i].getCacheList == getCacheListFunction)
				{
					_cacheList.splice(i, 1);
					return;
				}
			}
		}
		/**
		 * 强制清理所有管理器 
		 * 
		 */
		public static function forceDispose():void
		{
			var i:int,len:int=_cacheList.length;
			for(i=0;i<len;i++)
			{
				_cacheList[i].tryDispose(true);
			}
		}
		/**
		 * 开始检测循环 
		 * @param waitTime 检测间隔时间
		 * 
		 */
		public static function beginCheck(waitTime:int=15000):void
		{
			Laya.timer.loop(waitTime, null, _checkLoop);
		}

		/**
		 * 停止检测循环 
		 * 
		 */
		public static function stopCheck():void
		{
			Laya.timer.clear(null, _checkLoop);
		}
		/**
		 * @private 
		 * 检测函数
		 */
		private static function _checkLoop():void
		{
			var cacheList:Array = _cacheList;
			if (cacheList.length < 1) return;
			var tTime:int = Browser.now();
			var count:int;		
			var len:int;
			len=count = cacheList.length;
			while (count > 0)
			{
				_index++;
				_index = _index % len;
				cacheList[_index].tryDispose(false);
				if (Browser.now() - tTime > loopTimeLimit) break;
				count--;
			}
		}
	}

}