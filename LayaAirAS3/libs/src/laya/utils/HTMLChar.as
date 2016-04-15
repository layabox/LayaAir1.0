package laya.utils {
	import laya.display.css.CSSStyle;
	import laya.display.ILayout;
	import laya.display.Sprite;
	
	/**
	 * ...
	 * @author laya
	 */
	public class HTMLChar implements ILayout {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _isWordRegExp:RegExp =/*[STATIC SAFE]*/ new RegExp("[\\w\.]", "");
		
		private var _x:Number;
		private var _y:Number;
		private var _w:Number;
		private var _h:Number;
		
		public var isWord:Boolean;//是否是正常单词(英文|.|数字)
		public var char:String;
		public var charNum:Number;
		public var style:CSSStyle;
		
		private var _sprite:Sprite;
		
		public function HTMLChar(char:String, w:Number, h:Number, style:CSSStyle) {
			this.char = char;
			this.charNum = char.charCodeAt(0);
			_x = _y = 0;
			this.width = w;
			this.height = h;
			this.style = style;
			this.isWord = !_isWordRegExp.test(char);
		}
		
		public function setSprite(sprite:Sprite):void
		{
			_sprite = sprite;
		}
		
		public function getSprite():Sprite
		{
			return _sprite;
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function set x(value:Number):void {
			if (_sprite)
			{
				_sprite.x = value;
			}
			_x = value;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function set y(value:Number):void {
			if (_sprite)
			{
				_sprite.y = value;
			}
			_y = value;
		}
		
		public function get width():Number {
			return _w;
		}
		
		public function set width(value:Number):void {
			_w = value;
		}
		
		public function get height():Number {
			return _h;
		}
		
		public function set height(value:Number):void {
			_h = value;
		}
		
		public function _isChar():Boolean {
			return true;
		}
		
		public function _getCSSStyle():CSSStyle {
			return style;
		}
	}

}