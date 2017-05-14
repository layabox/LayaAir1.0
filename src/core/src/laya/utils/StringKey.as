package laya.utils {
	
	/**
	 * @private
	 * <code>StringKey</code> 类用于存取字符串对应的数字。
	 */
	public class StringKey {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private var _strsToID:Object = {};
		private var _idToStrs:Array = [];
		private var _length:int = 0;
		
		/**
		 * 添加一个字符。
		 * @param	str 字符，将作为key 存储相应生成的数字。
		 * @return 此字符对应的数字。
		 */
		public function add(str:String):int {
			var index:* = _strsToID[str];
			if (index != null) return index;
			
			_idToStrs[_length] = str;
			return _strsToID[str] = _length++;
		}
		
		/**
		 * 获取指定字符对应的ID。
		 * @param	str 字符。
		 * @return 此字符对应的ID。
		 */
		public function getID(str:String):int {
			var index:* = _strsToID[str];
			return index == null ? -1 : index;
		}
		
		/**
		 * 根据指定ID获取对应字符。
		 * @param  id ID。
		 * @return 此id对应的字符。
		 */
		public function getName(id:int):String {
			var str:* = _idToStrs[id];
			return str == null ? undefined : str;
		}
	}
}