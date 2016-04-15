package laya.net {
	import laya.utils.Browser;
	
	/**
	 *
	 * <p> <code>LocalStorage</code> 类用于没有时间限制的数据存储。</p>
	 * @author yung
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
		 * 以“key”为名称存储一个值“value”。
		 * @param key
		 * @param value
		 */
		public static function setItem(key:String, value:String):void {
			support && items.setItem(key, value);
		}
		
		/**
		 * 获取以“key”为名称存储的值。
		 * @param key
		 * @return
		 */
		public static function getItem(key:String):String {
			return support ? items.getItem(key) : null;
		}
		
		/**
		 * 以“key”为名称存储的JSON格式的值。
		 * @param key
		 * @param value
		 *
		 */
		public static function setJSON(key:String, value:Object):void {
			support && items.setItem(key, JSON.stringify(value));
		}
		
		/**
		 * 获取以“key”为名称存储的JSON格式的值。
		 * @param key
		 * @return
		 *
		 */
		public static function getJSON(key:String):Object {
			return JSON.parse(support ? items.getItem(key) : null);
		}
		
		/**
		 * 删除名称为“key”的信息。
		 * @param key
		 *
		 */
		public static function removeItem(key:String):void {
			support && items.removeItem(key);
		}
		
		/**
		 * 清除本地存贮信息。
		 */
		public static function clear():void {
			support && items.clear();
		}
	}
}