package laya.display.css {
	import laya.utils.Color;
	
	/**
	 * @private
	 * <code>Font</code> 类是字体显示定义类。
	 */
	public class Font {
		/**
		 * 一个默认字体 <code>Font</code> 对象。
		 */
		public static var EMPTY:Font;
		/**
		 * 默认的颜色。
		 */
		public static var defaultColor:String = "#000000";
		/**
		 * 默认字体大小。
		 */
		public static var defaultSize:int = 12;
		/**
		 * 默认字体名称系列。
		 */
		public static var defaultFamily:String = "Arial";
		/**
		 * 默认字体属性。
		 */
		public static var defaultFont:String = "12px Arial";
		/**@private  */
		public static var _STROKE:Array = /*[STATIC SAFE]*/ [0, "#000000"];
		
		/**@private  */
		public static function __init__():void {
			EMPTY = new Font(null);
		}
		
		private static const _ITALIC:int = 0x200;
		private static const _PASSWORD:int = 0x400;
		private static const _BOLD:int = 0x800;
		
		private var _type:int = 0;
		private var _weight:int = 0; //粗细 
		private var _color:Color = Color.create(defaultColor);
		private var _decoration:Object;
		private var _text:String;
		
		/**
		 * 字体名称系列。
		 */
		public var family:String = defaultFamily; //字体名称
		/**
		 * 描边宽度（以像素为单位）列表。
		 */
		public var stroke:Array = _STROKE;
		/**
		 * 首行缩进 （以像素为单位）。
		 */
		public var indent:int = 0;
		/**
		 * 字体大小。
		 */
		public var size:int = defaultSize;
		
		/**
		 * 创建一个新的 <code>Font</code> 类实例。
		 * @param	src 将此 Font 的成员属性值复制给当前 Font 对象。
		 */
		public function Font(src:Font):void {
			src && src !== EMPTY && src.copyTo(this);
		}
		
		/**
		 * 字体样式字符串。
		 */
		public function set(value:String):void {
			_text = null;
			
			var strs:Array = value.split(' ');
			
			for (var i:int, n:int = strs.length; i < n; i++) {
				var str:String = strs[i];
				switch (str) {
				case 'italic': 
					italic = true;
					continue;
				case 'bold': 
					bold = true;
					continue;
				}
				if (str.indexOf('px') > 0) {
					size = parseInt(str);
					family = strs[i + 1];
					i++;
					continue;
				}
			}
		}
		
		public function set color(value:String):void {
			_color = Color.create(value);
		}
		
		/**
		 * 表示颜色字符串。
		 */
		public function get color():String {
			return _color.strColor;
		}
		
		/**
		 * 表示是否为斜体。
		 */
		public function get italic():Boolean {
			return (_type & _ITALIC) !== 0;
		}
		
		public function set italic(value:Boolean):void {
			value ? (_type |= _ITALIC) : (_type &= ~_ITALIC);
		}
		
		/**
		 * 表示是否为粗体。
		 */
		public function get bold():Boolean {
			return (_type & _BOLD) !== 0;
		}
		
		public function set bold(value:Boolean):void {
			value ? (_type |= _BOLD) : (_type &= ~_BOLD);
		}
		
		/**
		 * 表示是否为密码格式。
		 */
		public function get password():Boolean {
			return (_type & _PASSWORD) !== 0;
		}
		
		public function set password(value:Boolean):void {
			value ? (_type |= _PASSWORD) : (_type &= ~_PASSWORD);
		}
		
		/**
		 * 返回字体样式字符串。
		 * @return 字体样式字符串。
		 */
		public function toString():String {
			_text = ""
			italic && (_text += "italic ");
			bold && (_text += "bold ");
			return _text += size + "px " + family;
		}
		
		public function set weight(value:String):void {
			var weight:int = 0;
			switch (value) {
			case 'normal': 
				break;
			case 'bold': 
				bold = true;
				weight = 700;
				break;
			case 'bolder': 
				weight = 800;
				break;
			case 'lighter': 
				weight = 100;
				break;
			default: 
				weight = parseInt(value);
			}
			_weight = weight;
			_text = null;
		}
		
		public function set decoration(value:String):void {
			var strs:Array = value.split(' ');
			_decoration || (_decoration = {});
			switch (strs[0]) {
			case '_': //下划线
				_decoration.type = 'underline'
				break;
			case '-': //中划线
				_decoration.type = 'line-through'
				break;
			case 'overline': //上划线
				_decoration.type = 'overline'
				break;
			default: 
				_decoration.type = strs[0];
			}
			strs[1] && (_decoration.color = Color.create(strs));
			_decoration.value = value;
		}
		
		/**
		 * 规定添加到文本的修饰。
		 */
		public function get decoration():String {
			return _decoration ? _decoration.value : "none";
		}
		
		/**
		 * 文本的粗细。
		 */
		public function get weight():String {
			return "" + _weight;
		}
		
		/**
		 * 将当前的属性值复制到传入的 <code>Font</code> 对象。
		 * @param	dec  一个 Font 对象。
		 */
		public function copyTo(dec:Font):void {
			dec._type = _type;
			dec._text = _text;
			dec._weight = _weight;
			dec._color = _color;
			
			dec.family = family; //字体名称
			dec.stroke = stroke != _STROKE ? stroke.slice() : _STROKE;
			dec.indent = indent;
			dec.size = size;
		}
	
	}

}
