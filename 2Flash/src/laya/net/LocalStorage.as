/*[IF-FLASH]*/package laya.net {
	import flash.net.SharedObject;
	
	/**
	 * <p> <code>LocalStorage</code> 类用于没有时间限制的数据存储。</p>
	 */
	public class LocalStorage {
		
		/**
		 *  数据列表。
		 */
		public static var items:*;
		/**
		 * 表示是否支持  <code>LocalStorage</code>。
		 */
		public static var support:Boolean = false;
		
		private static var _so:SharedObject;
		init();
		private static function init():void
		{
			support = true;
			_so = SharedObject.getLocal("LoacalStorage");
		}
		/**
		 * 存储指定键名和它的字符床型值。
		 * @param key 键名。
		 * @param value 键值。
		 */
		public static function setItem(key:String, value:String):void {
			try {
				if (support)
				{
					_so.data[key] = value;
					_so.flush();
				}
			} catch (e:*) {
				trace("set localStorage failed", e);
			}
		}
		
		/**
		 * 获取指定键名的值。
		 * @param key 键名。
		 * @return 字符串型值。
		 */
		public static function getItem(key:String):String {
			return support ? _so.data[key] : null;
		}
		
		/**
		 * 存储指定键名和它的 <code>Object</code> 类型值。
		 * @param key 键名。
		 * @param value 键值。是 <code>Object</code> 类型，此致会被转化为 JSON 字符串存储。
		 */
		public static function setJSON(key:String, value:Object):void {
			try {
				support && setItem(key, JSON.stringify(value));
			} catch (e:*) {
				trace("set localStorage failed", e);
			}
		}
		
		/**
		 * 获取指定键名的 <code>Object</code> 类型值。
		 * @param key 键名。
		 * @return <code>Object</code> 类型值
		 */
		public static function getJSON(key:String):Object {
			if (!getItem(key)) return null;
			try
			{
				return JSON.parse(support ? getItem(key) : null);
			}catch (e:*)
			{
			}
			return null;
		}
		
		/**
		 * 删除指定键名的信息。
		 * @param key 键名。
		 */
		public static function removeItem(key:String):void {
			if (support)
			{
				delete _so.data[key];
				_so.flush();
			}
			
		}
		
		/**
		 * 清除本地存储信息。
		 */
		public static function clear():void {
			if (support)
			{
				_so.clear();
				_so.flush();
			}
		}
	}
}