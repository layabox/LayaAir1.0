package laya.utils {
	
	/**
	 * <code>Dictionary</code> 是一个字典型的数据存取类。
	 */
	public class Dictionary {
		private var _values:Array = [];
		private var _keys:Array = [];
		
		/**
		 * 获取所有的子元素列表。
		 */
		public function get values():Array {
			return _values;
		}
		
		/**
		 * 获取所有的子元素键名列表。
		 */
		public function get keys():Array {
			return _keys;
		}
		
		/**
		 * 给指定的键名设置值。
		 * @param	key 键名。
		 * @param	value 值。
		 */
		public function set(key:*, value:*):void {
			var index:int = indexOf(key);
			if (index >= 0) {
				_values[index] = value;
				return;
			}
			_keys.push(key);
			_values.push(value);
		}
		
		/**
		 * 获取指定对象的键名索引。
		 * @param	key 键名对象。
		 * @return 键名索引。
		 */
		public function indexOf(key:Object):int {
			var index:int = _keys.indexOf(key);
			if (index >= 0) return index;
			key = (key is String) ? Number(key) : ((key is Number) ? key.toString() : key);
			return _keys.indexOf(key);
		}
		
		/**
		 * 返回指定键名的值。
		 * @param	key 键名对象。
		 * @return 指定键名的值。
		 */
		public function get(key:*):* {
			var index:int = indexOf(key);
			return index < 0 ? null : _values[index];
		}
		
		/**
		 * 移除指定键名的值。
		 * @param	key 键名对象。
		 * @return 是否成功移除。
		 */
		public function remove(key:*):Boolean {
			var index:int = indexOf(key);
			if (index >= 0) {
				_keys.splice(index, 1);
				_values.splice(index, 1);
				return true;
			}
			return false;
		}
		
		/**
		 * 清除此对象的键名列表和键值列表。
		 */
		public function clear():void {
			_values.length = 0;
			_keys.length = 0;
		}
	}
}