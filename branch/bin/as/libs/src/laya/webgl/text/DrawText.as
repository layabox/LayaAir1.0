package laya.webgl.text {
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.HTMLChar;
	import laya.utils.WordText;
	import laya.webgl.canvas.WebGLContext2D;
	
	public class DrawText {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _charsTemp:Vector.<DrawTextChar>;
		
		private static var _textCachesPool:Array = [];
		private static var _curPoolIndex:int = 0;
		private static var _charsCache:Object = {};
		
		private static var _textsCache:Object = {};
		
		public static var _drawValue:CharValue;
		
		public static var d:Array = [];
		
		//private static var _charsCacheCount:int=0;
		///**最大字符缓存数量*/
		//public static var maxCacheCharsCount:int = 10;
		private static var _charSeg:ICharSegment = null;
		
		public static function __init__():void {
			_charsTemp = new Vector.<DrawTextChar>;
			_drawValue = new CharValue();
			_charSeg = new CharSegment();
		}
		
		/**
		 * 项目层根据当前的语言特性，设置自己的分词器，如泰语需要特殊的处理
		 * @param	charseg
		 */
		public static function customCharSeg(charseg:ICharSegment):void {
			_charSeg = charseg;
		}
		
		//如果stage缩放发生变化，应该清除所有文字信息，释放所有资源
		
		public static function getChar(char:String, id:Number, drawValue:CharValue):DrawTextChar {
			//_charsCacheCount ++;
			return _charsCache[id] = DrawTextChar.createOneChar(char, drawValue);
		}
		
		private static function _drawSlow(save:Array, ctx:WebGLContext2D, txt:String, words:Vector.<HTMLChar>, curMat:Matrix, font:FontInContext, textAlign:String, fillColor:String, borderColor:String, lineWidth:int, x:Number, y:Number, sx:Number, sy:Number):void {
			//if (_charsCacheCount > maxCacheCharsCount) {
			//_charsCacheCount = 0;
			//CharValue.clear();
			//for (var char:* in _charsCache)
			//_charsCache[char].dispose();
			//_charsCache = {};
			//}
			
			var drawValue:CharValue = _drawValue.value(font, fillColor, borderColor, lineWidth, sx, sy);
			
			var i:int, n:int;
			var chars:Vector.<DrawTextChar> = _charsTemp;
			var width:int = 0, oneChar:DrawTextChar, htmlWord:HTMLChar, id:Number;
			if (words) {
				chars.length = words.length;
				for (i = 0, n = words.length; i < n; i++) {
					htmlWord = words[i];
					id = htmlWord.charNum + drawValue.txtID;
					chars[i] = oneChar = _charsCache[id] || getChar(htmlWord.char, id, drawValue);
					oneChar.active();
				}
			} else {
				// River: 使用新的分词模式来解决类似于泰文的问题
				if (txt is WordText)
					_charSeg.textToSpit((txt as WordText).toString());
				else
					_charSeg.textToSpit(txt);
				
				var len:int = _charSeg.length();
				chars.length = len;
				for (i = 0, n = len; i < n; i++) {
					id = _charSeg.getCharCode(i) + drawValue.txtID;
					chars[i] = oneChar = _charsCache[id] || getChar(_charSeg.getChar(i), id, drawValue);
					oneChar.active();
					width += oneChar.width;
				}
			}
			
			var dx:Number = 0;
			if (textAlign !== null && textAlign !== "left")
				dx = -(textAlign == "center" ? (width / 2) : width);
			
			var uv:Array, bdSz:Number, texture:Texture, value:Array, saveLength:int = 0;
			if (words) {
				for (i = 0, n = chars.length; i < n; i++) {
					oneChar = chars[i];
					if (!oneChar.isSpace) {
						htmlWord = words[i];
						bdSz = oneChar.borderSize;
						texture = oneChar.texture;
						ctx._drawText(texture, x + dx + htmlWord.x * sx - bdSz, y + htmlWord.y * sy - bdSz, texture.width, texture.height, curMat, 0, 0, 0, 0);
					}
				}
			} else {
				for (i = 0, n = chars.length; i < n; i++) {
					oneChar = chars[i];
					if (!oneChar.isSpace) {
						bdSz = oneChar.borderSize;
						texture = oneChar.texture;
						ctx._drawText(texture, x + dx - bdSz, y - bdSz, texture.width, texture.height, curMat, 0, 0, 0, 0);
						save && (value = save[saveLength++], value || (value = save[saveLength - 1] = []), value[0] = texture, value[1] = dx - bdSz, value[2] = -bdSz);
					}
					dx += oneChar.width;
				}
				save && (save.length = saveLength);
			}
		}
		
		private static function _drawFast(save:Array, ctx:WebGLContext2D, curMat:Matrix, x:Number, y:Number):void {
			var texture:Texture, value:Array;
			for (var i:int = 0, n:int = save.length; i < n; i++) {
				value = save[i];
				texture = value[0];
				texture.active();
				ctx._drawText(texture, x + value[1], y + value[2], texture.width, texture.height, curMat, 0, 0, 0, 0);
			}
		}
		
		public static function drawText(ctx:WebGLContext2D, txt:*, words:Vector.<HTMLChar>, curMat:Matrix, font:FontInContext, textAlign:String, fillColor:String, borderColor:String, lineWidth:int, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			if ((txt && txt.length === 0) || (words && words.length === 0))
				return;
			var sx:Number = curMat.a, sy:Number = curMat.d;
			(curMat.b !== 0 || curMat.c !== 0) && (sx = sy = 1);
			var scale:Boolean = sx !== 1 || sy !== 1;
			
			if (scale && Laya.stage.transform) {
				var t:Matrix = Laya.stage.transform;
				scale = t.a === sx && t.d === sy;
			} else scale = false;
			
			if (scale) {
				curMat = curMat.copyTo(WebGLContext2D._tmpMatrix);
				curMat.scale(1 / sx, 1 / sy);
				curMat._checkTransform();
				x *= sx;
				y *= sy;
			} else sx = sy = 1;
			
			if (words) {
				_drawSlow(null, ctx, txt, words, curMat, font, textAlign, fillColor, borderColor, lineWidth, x, y, sx, sy);
			} else {
				if (txt.toUpperCase === null) {
					var idNum:Number = sx + sy * 100000;
					var myCache:WordText = txt as WordText;
					if (!myCache.changed && myCache.id === idNum) {
						_drawFast(myCache.save, ctx, curMat, x, y);
					} else {
						myCache.id = idNum;
						myCache.changed = false;
						_drawSlow(myCache.save, ctx, txt, words, curMat, font, textAlign, fillColor, borderColor, lineWidth, x, y, sx, sy);
					}
					return;
				}
				
				var id:String = txt + font.toString() + fillColor + borderColor + lineWidth + sx + sy + textAlign;
				
				var cache:Array = _textsCache[id];
				
				if (cache) {
					_drawFast(cache, ctx, curMat, x, y);
				} else {
					_textsCache.__length || (_textsCache.__length = 0);
					if (_textsCache.__length > Config.WebGLTextCacheCount) {
						_textsCache = {};
						_textsCache.__length = 0;
						_curPoolIndex = 0;
					}
					
					_textCachesPool[_curPoolIndex] ? (cache = _textsCache[id] = _textCachesPool[_curPoolIndex], cache.length = 0) : (_textCachesPool[_curPoolIndex] = cache = _textsCache[id] = []);
					_textsCache.__length++
					_curPoolIndex++;
					
					_drawSlow(cache, ctx, txt, words, curMat, font, textAlign, fillColor, borderColor, lineWidth, x, y, sx, sy);
				}
			}
		}
	}

}

class CharValue {
	/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
	private static var _keymap:* = {};
	private static var _keymapCount:int = 1;
	
	public var txtID:Number;
	public var font:*;
	public var fillColor:String;
	public var borderColor:String;
	public var lineWidth:int;
	public var scaleX:Number;
	public var scaleY:Number;
	
	public function value(font:*, fillColor:String, borderColor:String, lineWidth:int, scaleX:Number, scaleY:Number):CharValue {
		this.font = font;
		this.fillColor = fillColor;
		this.borderColor = borderColor;
		this.lineWidth = lineWidth;
		this.scaleX = scaleX;
		this.scaleY = scaleY;
		var key:String = font.toString() + scaleX + scaleY + lineWidth + fillColor + borderColor;
		this.txtID = _keymap[key];
		if (!this.txtID) {
			this.txtID = (++_keymapCount) * 0.0000001;
			_keymap[key] = this.txtID;
		}
		return this;
	}
	
	public static function clear():void {
		_keymap = {};
		_keymapCount = 1;
	}
}
