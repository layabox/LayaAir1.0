package laya.utils {
	import laya.display.css.CSSStyle;
	import laya.display.ILayout;
	import laya.display.Sprite;
	
	/**
	 * @private
	 * <code>HTMLChar</code> 是一个 HTML 字符类。
	 */
	public class HTMLChar implements ILayout {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _isWordRegExp:RegExp =/*[STATIC SAFE]*/ new RegExp("[\\w\.]", "");
		
		private var _sprite:Sprite;
		private var _x:Number;
		private var _y:Number;
		private var _w:Number;
		private var _h:Number;
		/** 表示是否是正常单词(英文|.|数字)。*/
		public var isWord:Boolean;
		/** 字符。*/
		public var char:String;
		/** 字符数量。*/
		public var charNum:Number;
		/** CSS 样式。*/
		public var style:CSSStyle;
		
		/**
		 * 根据指定的字符、宽高、样式，创建一个 <code>HTMLChar</code> 类的实例。
		 * @param	char 字符。
		 * @param	w 宽度。
		 * @param	h 高度。
		 * @param	style CSS 样式。
		 */
		public function HTMLChar(char:String, w:Number, h:Number, style:CSSStyle) {
			this.char = char;
			this.charNum = char.charCodeAt(0);
			_x = _y = 0;
			this.width = w;
			this.height = h;
			this.style = style;
			this.isWord = !_isWordRegExp.test(char);
		}
		
		/**
		 * 设置与此对象绑定的显示对象 <code>Sprite</code> 。
		 * @param	sprite 显示对象 <code>Sprite</code> 。
		 */
		public function setSprite(sprite:Sprite):void {
			_sprite = sprite;
		}
		
		/**
		 * 获取与此对象绑定的显示对象 <code>Sprite</code>。
		 * @return
		 */
		public function getSprite():Sprite {
			return _sprite;
		}
		
		/**
		 * 此对象存储的 X 轴坐标值。
		 * 当设置此值时，如果此对象有绑定的 Sprite 对象，则改变 Sprite 对象的属性 x 的值。
		 */
		public function get x():Number {
			return _x;
		}
		
		public function set x(value:Number):void {
			if (_sprite) {
				_sprite.x = value;
			}
			_x = value;
		}
		
		/**
		 * 此对象存储的 Y 轴坐标值。
		 * 当设置此值时，如果此对象有绑定的 Sprite 对象，则改变 Sprite 对象的属性 y 的值。
		 */
		public function get y():Number {
			return _y;
		}
		
		public function set y(value:Number):void {
			if (_sprite) {
				_sprite.y = value;
			}
			_y = value;
		}
		
		/**
		 * 宽度。
		 */
		public function get width():Number {
			return _w;
		}
		
		public function set width(value:Number):void {
			_w = value;
		}
		
		/**
		 * 高度。
		 */
		public function get height():Number {
			return _h;
		}
		
		public function set height(value:Number):void {
			_h = value;
		}
		
		/** @private */
		public function _isChar():Boolean {
			return true;
		}
		
		/** @private */
		public function _getCSSStyle():CSSStyle {
			return style;
		}
	}

}