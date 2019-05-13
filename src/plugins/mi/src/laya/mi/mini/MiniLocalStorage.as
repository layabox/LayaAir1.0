package laya.mi.mini
{
	/** @private **/
	public class MiniLocalStorage
	{
		/**
		 * 表示是否支持  <code>LocalStorage</code>。
		 */
		public static var support:Boolean = true;
		/**
		 *  数据列表。
		 */
		public static var items:*;
		public function MiniLocalStorage()
		{
		}
		public static function __init__():void {
			items = MiniLocalStorage;
		}
		
		/**
		 * 存储指定键名和键值，字符串类型。
		 * @param key 键名。
		 * @param value 键值。
		 */
		public static function setItem(key:String, value:*):void {
			__JS__('KGMiniAdapter.window.qg.storage.setSync')({key: key,value: value})
		}
		
		/**
		 * 获取指定键名的值。
		 * @param key 键名。
		 * @return 字符串型值。
		 */
		public static function getItem(key:String):* {
			var tempData:* = __JS__('KGMiniAdapter.window.qg.storage.getSync')({key:key})
			return  tempData;
		}
		
		/**
		 * 存储指定键名及其对应的 <code>Object</code> 类型值。
		 * @param key 键名。
		 * @param value 键值。是 <code>Object</code> 类型，此致会被转化为 JSON 字符串存储。
		 */
		public static function setJSON(key:String, value:Object):void {
			try
			{
				setItem(key, JSON.stringify(value));
			} 
			catch(error:Error) 
			{
				setItem(key, value);
			}
		}
		
		/**
		 * 获取指定键名对应的 <code>Object</code> 类型值。
		 * @param key 键名。
		 * @return <code>Object</code> 类型值
		 */
		public static function getJSON(key:String):Object {
			var tempData:* = getItem(key);
			try
			{
				return JSON.parse(tempData);
			} 
			catch(error:Error) 
			{
				return tempData;
			}
		}
		
		/**
		 * 删除指定键名的信息。
		 * @param key 键名。
		 */
		public static function removeItem(key:String):void {
			__JS__('KGMiniAdapter.window.qg.storage.delete')({
				key: key,
				success: function(data) :void
				{
					console.log('handling success')
				},
				fail: function(data, code) :void
				{
					trace("====removeItem data fail code:" + code);
				}
			})
		}
		
		/**
		 * 清除本地存储信息。
		 */
		public static function clear():void {
			KGMiniAdapter.window.qg.storage.clear({
				success: function(data) :void
				{
					console.log('handling success')
				},
				fail: function(data, code) :void
				{
					trace("====clear data fail code:" + code);
				}
			})
		}
		
		/**同步获取当前storage的相关信息**/
		public static function getStorageInfoSync():Object
		{
			return null;
		}
	}
}