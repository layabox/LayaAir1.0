package laya.net {
	
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
		__JS__("if (window.localStorage) {LocalStorage.items = window.localStorage;try {localStorage.setItem('laya', '1');localStorage.removeItem('laya');LocalStorage.support = true;} catch (e) {}}if (!LocalStorage.support) console.log('LocalStorage is not supprot or browser is private mode.')");
		
		/**
		 * 存储指定键名和它的字符床型值。
		 * @param key 键名。
		 * @param value 键值。
		 */
		public static function setItem(key:String, value:String):void {
			support && items.setItem(key, value);
		}
		
		/**
		 * 获取指定键名的值。
		 * @param key 键名。
		 * @return 字符串型值。
		 */
		public static function getItem(key:String):String {
			return support ? items.getItem(key) : null;
		}
		
		/**
		 * 存储指定键名和它的 <code>Object</code> 类型值。
		 * @param key 键名。
		 * @param value 键值。是 <code>Object</code> 类型，此致会被转化为 JSON 字符串存储。
		 */
		public static function setJSON(key:String, value:Object):void {
			support && items.setItem(key, JSON.stringify(value));
		}
		
		/**
		 * 获取指定键名的 <code>Object</code> 类型值。
		 * @param key 键名。
		 * @return <code>Object</code> 类型值
		 */
		public static function getJSON(key:String):Object {
			return JSON.parse(support ? items.getItem(key) : null);
		}
		
		/**
		 * 删除指定键名的信息。
		 * @param key 键名。
		 */
		public static function removeItem(key:String):void {
			support && items.removeItem(key);
		}
		
		/**
		 * 清除本地存储信息。
		 */
		public static function clear():void {
			support && items.clear();
		}
	}
}