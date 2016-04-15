package laya.webgl.text {
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.HTMLChar;
	import laya.utils.Stat;
	import laya.webgl.canvas.DrawStyle;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.submit.Submit;
	
	/**
	 * ...
	 * @author laya
	 */
	public class DrawText {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _wordsMsg:Object = {};
		private static var _charsTemp:Vector.<DrawTextChar> =/*[STATIC SAFE]*/ new Vector.<DrawTextChar>;
		private static var _fontTemp:FontInContext = null;
		public static var _drawValue:CharValue = new CharValue();
		
		public static function getChar(char:String, id:Number, drawValue:CharValue):DrawTextChar {
			return _wordsMsg[id] = DrawTextChar.createOneChar(char, drawValue);
		}
		
		public static function drawText(ctx:WebGLContext2D, txt:String, words:Vector.<HTMLChar>, curMat:Matrix, font:FontInContext, textAlign:String, fillColor:String, borderColor:String, lineWidth:int, x:Number, y:Number):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			if (txt && txt.length === 0) return;
			
			if (words && words.length === 0) return;
			
			_fontTemp || (_fontTemp = new FontInContext());
			
			var i:int, n:int;
			var rot:Number = curMat.b == 0 && curMat.c == 0 ? 0 : 1;
			var sx:Number = curMat.a, sy:Number = curMat.d;
			(rot !== 0) && (sx = sy = 1);
			
			sx = sy = 1;
			
			var sx2:Number = 1, sy2:Number = 1;
			
			var italic:int = font.hasType("italic");
			if (sx != 1 || sy != 1 || italic >= 0) font = font.copyTo(_fontTemp);
			italic >= 0 && font.removeType("italic");
			
			if (sx != 1 || sy != 1) {
				if (sx > sy) {
					font.size = font.size * sx;
					sy2 = sy / sx;
				} else {
					font.size = font.size * sy;
					sx2 = sx / sy;
				}
				font.size = Math.floor(font.size);
			}
			
			var width:int = 0;
			var chars:Vector.<DrawTextChar> = _charsTemp;
			var oneChar:DrawTextChar;
			var htmlWord:HTMLChar;
			var id:Number;
			
			var size:int = Math.floor(font.size / 16 + 0.5) * 16;
			//if (size > 64) alert("font size must <64:" + size + " " + txt);//TODO:没有完成
			
			var drawValue:CharValue = _drawValue;
			drawValue.value(font, fillColor, borderColor, lineWidth, size, sx2, sy2);
			
			if (words) {
				chars.length = words.length;
				for (i = 0, n = words.length; i < n; i++) {
					htmlWord = words[i];
					id = htmlWord.charNum + drawValue.txtID;
					chars[i] = oneChar = _wordsMsg[id] || getChar(htmlWord.char, id, drawValue);
					oneChar.active();//.....
				}
			} else {
				chars.length = txt.length;
				for (i = 0, n = txt.length; i < n; i++) {
					id = txt.charCodeAt(i) + drawValue.txtID;
					chars[i] = oneChar = _wordsMsg[id] || getChar(txt.charAt(i), id, drawValue);
					oneChar.active();//...
					width += oneChar.width;
				}
			}
			
			var curMat2:Matrix = curMat;
			if (sx != 1 || sy != 1 || italic >= 0) {
				curMat2 = WebGLContext2D._tmpMatrix;
				curMat.copy(curMat2);
			}
			
			if (sx != 1 || sy != 1) {
				var tx:Number = curMat2.tx;
				var ty:Number = curMat2.ty;
				curMat2.scale(1 / sx, 1 / sy);
				curMat2.tx = tx;
				curMat2.ty = ty;
				x *= sx;
				y *= sy;
			}
			
			curMat2.tx |= 0;
			curMat2.ty |= 0;
			
			switch (textAlign) {
			case "center": 
				x -= width / 2;
				break;
			case "right": 
				x -= width;
				break;
			}
			var dx:Number;
			var uv:Array;
			var bdSz:Number;
			var texture:Texture;
			if (words) {
				for (i = 0, n = chars.length; i < n; i++) {
					oneChar = chars[i];
					if (!oneChar.isSpace) {
						htmlWord = words[i];
						dx = italic >= 0 ? (oneChar.height * 0.4) : 0;
						bdSz = oneChar.borderSize;
						texture = oneChar.texture;
						ctx._drawText(texture, x + htmlWord.x * sx - bdSz, y + htmlWord.y * sy - bdSz, 
									  texture.width, texture.height, curMat2, 0, 0, dx, 0);
					}
				}
			} else {
				for (i = 0, n = chars.length; i < n; i++) {
					oneChar = chars[i];
					if (!oneChar.isSpace) {
						dx = italic >= 0 ? (oneChar.height * 0.4) : 0;
						bdSz = oneChar.borderSize;
						texture = oneChar.texture;
						ctx._drawText(texture, x - bdSz, y - bdSz, 
									  texture.width, texture.height, curMat2, 0, 0, dx, 0);
					}
					x += oneChar.width;
				}
			}
		}
	}

}