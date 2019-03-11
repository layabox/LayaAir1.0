package laya.utils {
	
	public class FontInfo{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static var EMPTY:FontInfo =/*[STATIC SAFE]*/ new FontInfo(null);
		
		private static var _cache:Object = { };
		private static var _gfontID:int = 0;
		private static var _lastFont:String = '';
		private static var _lastFontInfo:FontInfo;
		
		public static function Parse(font:String):FontInfo {
			if (font === _lastFont) {
				return _lastFontInfo;
			}
			var r:FontInfo = _cache[font];
			if(!r){
				r = _cache[font] = new FontInfo(font);
			}
			_lastFont = font;
			_lastFontInfo = r;
			return r;
		}
		
		public var _id:uint ;
		public var _font:String="14px Arial";
		public var _family:String="Arial";
		public var _size:int =14;
		public var _italic:Boolean =false;
		public var _bold:Boolean=false ;
		
		public function FontInfo(font:String ) {
			_id =  _gfontID++;
			setFont(font || this._font);
		}
		
		public function setFont(value:String):void {
			_font = value;
			var _words:Array = value.split(' ');
			var l:int = _words.length;
			if (l < 2) {
				if ( l == 1) {
					if (_words[0].indexOf('px') > 0) {
						_size = parseInt(_words[0]);
					}
				}
				return;
			}
			var szpos:int =-1;
			//由于字体可能有空格，例如Microsoft YaHei 所以不能直接取倒数第二个，要先找到px
			for (var i:int = 0; i < l; i++) {
				if (_words[i].indexOf('px') > 0 || _words[i].indexOf('pt') > 0) {
					szpos = i;
					_size = parseInt(_words[i]);
					if (_size <= 0) {
						console.error('font parse error:'+value);
						_size = 14;
					}
					break;
				}
			}
			
			//最后一个是用逗号分开的family
			var fpos:int = szpos + 1;
			var familys:String = _words[fpos];
			fpos++;//下一个
			for (; fpos < l; fpos++) {
				familys += ' ' + _words[fpos];
			}
			_family = (familys.split(','))[0];
			_italic = _words.indexOf('italic')>=0;
			_bold = _words.indexOf('bold') >= 0;
		}
	}
}