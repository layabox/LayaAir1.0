package laya.utils {
	
	/**
	 * 基于个数的对象缓存管理器
	 */
	public class PoolCache {
		
		/**
		 * 对象在Pool中的标识
		 */
		public var sign:String;
		/**
		 * 允许缓存的最大数量
		 */
		public var maxCount:int = 1000;
		
		/**
		 * 获取缓存的对象列表
		 * @return
		 *
		 */
		public function getCacheList():Array {
			return Pool.getPoolBySign(sign);
		}
		
		/**
		 * 尝试清理缓存
		 * @param force 是否强制清理
		 *
		 */
		public function tryDispose(force:Boolean):void {
			var list:Array;
			list = Pool.getPoolBySign(sign);
			if (list.length > maxCount) {
				list.splice(maxCount, list.length - maxCount);
			}
		}
		
		/**
		 * 添加对象缓存管理
		 * @param sign 对象在Pool中的标识
		 * @param maxCount 允许缓存的最大数量
		 *
		 */
		public static function addPoolCacheManager(sign:String, maxCount:int = 100):void {
			var cache:PoolCache;
			cache = new PoolCache();
			cache.sign = sign;
			cache.maxCount = maxCount;
			CacheManger.regCacheByFunction(Utils.bind(cache.tryDispose, cache), Utils.bind(cache.getCacheList, cache));
		}
	}
}