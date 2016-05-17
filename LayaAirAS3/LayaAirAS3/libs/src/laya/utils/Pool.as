package laya.utils {
	
	/**
	 * <code>Pool</code> 是对象池类，用于对象的存贮、重复使用。
	 */
	public class Pool {
		
		/**@private */
		public function Pool() {
		
		}
		/**@private  对象存放池。*/
		private static var _poolDic:Object = {};
		
		/**
		 * 用于表示该对象是否在对象池中的对象属性名。
		 * 例如：
		 *   对象[InPoolSign]:用于表示该对象是否在对象池中。
		 */
		public static const InPoolSign:String = "__InPool";
		
		/**
		 * 根据对象类型标识字符，获取对象池。
		 * @param sign 对象类型标识字符。
		 * @return 对象池。
		 */
		private static function getPoolBySign(sign:String):Array {
			return _poolDic[sign] || (_poolDic[sign] = []);
		}
		
		/**
		 * 将对象放到对应类型标识的对象池中。
		 * @param sign 对象类型标识字符。
		 * @param item 对象。
		 */
		public static function recover(sign:String, item:Object):void {
			if (item[InPoolSign]) return;
			item[InPoolSign] = true;
			getPoolBySign(sign).push(item);
		}
		
		/**
		 * 根据传入的对象类型标识字符，获取对象池中此类型标识的一个对象实例。
		 * 当对象池中无此类型标识的对象时，则根据传入的类型，创建一个新的对象返回。
		 * @param sign 对象类型标识字符。
		 * @param clz 用于创建该类型对象的类。
		 * @return 此类型标识的一个对象。
		 */
		public static function getItemByClass(sign:String, clz:Class):* {
			var pool:Array = getPoolBySign(sign);
			var rst:Object = pool.length ? pool.pop() : new clz();
			rst[InPoolSign] = false;
			return rst;
		}
		
		/**
		 * 根据传入的对象类型标识字符，获取对象池中此类型标识的一个对象实例。
		 * 当对象池中无此类型标识的对象时，则使用传入的创建此类型对象的函数，新建一个对象返回。
		 * @param sign 对象类型标识字符。
		 * @param createFun 用于创建该类型对象的方法。
		 * @return 此类型标识的一个对象。
		 */
		public static function getItemByCreateFun(sign:String, createFun:Function):* {
			var pool:Array = getPoolBySign(sign);
			var rst:Object = pool.length ? pool.pop() : createFun();
			rst[InPoolSign] = false;
			return rst;
		}
		
		/**
		 * 根据传入的对象类型标识字符，获取对象池中已存储的此类型的一个对象，如果对象池中无此类型的对象，则返回 null 。
		 * @param sign 对象类型标识字符。
		 * @return 对象池中此类型的一个对象，如果对象池中无此类型的对象，则返回 null 。
		 */
		public static function getItem(sign:String):* {
			var pool:Array = getPoolBySign(sign);
			var rst:Object = pool.length ? pool.pop() : null;
			if (rst) rst[InPoolSign] = false;
			return rst;
		}
	
	}

}