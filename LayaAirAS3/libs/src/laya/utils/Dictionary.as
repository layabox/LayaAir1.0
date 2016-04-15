package laya.utils {
	
	/**
	 * ...
	 * @author laya
	 */
	public class Dictionary {
		private var _elements:Array = [];
		private var _keys:Array = [];
		
		public function Dictionary() {
		
		}
		
		public function get elements():Array {
			return _elements;
		}
		
		public function get keys():Array {
			return _keys;
		}
		
		public function set(key:*, value:*):void {
			var index:int = indexOf(key);
			if (index >= 0) {
				_elements[index] = value;
				return;
			}
			_keys.push(key);
			_elements.push(value);
		}
		
		public function indexOf(key:Object):int {
			var index:int = _keys.indexOf(key);
			if (index >= 0) return index;
			key = (key is String) ? Number(key) : ((key is Number) ? key.toString() : key);
			return _keys.indexOf(key);
		}
		
		public function get(key:*):* {
			var index:int = indexOf(key);
			return index < 0 ? null : _elements[index];
		}
		
		public function remove(key:*):Boolean {
			var index:int = indexOf(key);
			if (index >= 0) {
				_keys.splice(index, 1);
				_elements.splice(index, 1);
				return true;
			}
			return false;
		}
		
		public function clear():void {
			_elements.length = 0;
			_keys.length = 0;
		}
	}

}