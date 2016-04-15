package laya.utils {
	
	/**
	 * ...
	 * @author laya
	 */
	public class StringKey {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private var _strs:Object = {};
		private var _length:int = 0;
		
		public function add(str:String):int {
			var index:* = _strs[str];
			if (index != null) return index;
			return _strs[str] = _length++;
		}
		
		public function get(str:String):int {
			var index:* = _strs[str];
			return index == null ? -1 : index;
		}	
	}
}