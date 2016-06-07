package laya.utils {
	
	/**
	 * <code>StringKey</code> 类用于存取字符串对应的数字。
	 */
	public class StringKey {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private var _strs:Object = {};
		private var _length:int = 0;
		
		/**
		 * 添加一个字符。
		 * @param	str 字符，将作为key 存储相应生成的数字。
		 * @return 此字符对应的数字。
		 */
		public function add(str:String):int {
			var index:* = _strs[str];
			if (index != null) return index;
			return _strs[str] = _length++;
		}
		
		/**
		 * 获取指定字符对应的数字。
		 * @param	str key 字符。
		 * @return 此字符对应的数字。
		 */
		public function get(str:String):int {
			var index:* = _strs[str];
			return index == null ? -1 : index;
		}
	}
}