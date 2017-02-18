package laya.webgl.text {
	
	public class FontInContext {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static var EMPTY:FontInContext =/*[STATIC SAFE]*/ new FontInContext();
		
		private static var _cache:Object = {};
		
		public static function create(font:String):FontInContext {
			var r:FontInContext = _cache[font];
			if (r) return r;
			r = _cache[font] = new FontInContext(font);
			return r;
		}
		
		private var _text:String;
		private var _words:Array;
		private var _index:int = 0;
		private var _size:int = 14;
		private var _italic:int = -2;
		
		public function FontInContext(font:String = null) {
			setFont(font || "14px Arial");
		}
		
		public function setFont(value:String):void {
			_words = value.split(' ');
			for (var i:int = 0, n:int = _words.length; i < n; i++) {
				if (_words[i].indexOf('px') > 0) {
					_index = i;
					break;
				}
			}
			_size = parseInt(_words[_index]);
			_text = null;
			_italic = -2;
		}
		
		public function set size(value:int):void {
			_size = value;
			_words[_index] = value + "px";
			_text = null;
		}
		
		public function getItalic():int {
			_italic === -2 && (_italic = hasType("italic"));
			return _italic;
		}
		
		public function get size():int {
			return _size;
		}
		
		public function hasType(name:String):int {
			for (var i:int = 0, n:int = _words.length; i < n; i++)
				if (_words[i] === name) return i;
			return -1;
		}
		
		public function removeType(name:String):void {
			for (var i:int = 0, n:int = _words.length; i < n; i++)
				if (_words[i] === name) {
					_words.splice(i, 1);
					if (_index > i) _index--;
					break;
				}
			_text = null;
			_italic = -2;
		}
		
		public function copyTo(dec:FontInContext):FontInContext {
			dec._text = _text;
			dec._size = _size;
			dec._index = _index;
			dec._words = _words.slice();
			dec._italic = -2;
			return dec;
		}
		
		public function toString():String {
			return _text ? _text : (_text = _words.join(' '));
		}
	}

}