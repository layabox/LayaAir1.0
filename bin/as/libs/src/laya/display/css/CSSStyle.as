package laya.display.css {
	import laya.display.Sprite;
	import laya.display.css.Style;
	import laya.events.Event;
	import laya.net.URL;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.utils.Color;
	
	/**
	 * @private
	 * <code>CSSStyle</code> 类是元素CSS样式定义类。
	 */
	public class CSSStyle extends Style {
		/**@private */
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static var EMPTY:CSSStyle = /*[STATIC SAFE]*/ new CSSStyle(null);
		private static var _CSSTOVALUE:Object =/*[STATIC SAFE]*/ {'letter-spacing': 'letterSpacing', 'line-spacing': 'lineSpacing', 'white-space': 'whiteSpace', 'line-height': 'lineHeight', 'scale-x': 'scaleX', 'scale-y': 'scaleY', 'translate-x': 'translateX', 'translate-y': 'translateY', 'font-family': 'fontFamily', 'font-weight': 'fontWeight', 'vertical-align': 'valign', 'text-decoration': 'textDecoration', 'background-color': 'backgroundColor', 'border-color': 'borderColor', 'float': 'cssFloat'};
		private static var _parseCSSRegExp:RegExp =/*[STATIC SAFE]*/ new RegExp("([\.\#]\\w+)\\s*{([\\s\\S]*?)}", "g");
		private static var _aligndef:* =/*[STATIC SAFE]*/ {'left': 0, 'center': 1, 'right': 2, 0: 'left', 1: 'center', 2: 'right'};
		private static var _valigndef:* = /*[STATIC SAFE]*/ {'top': 0, 'middle': 1, 'bottom': 2, 0: 'top', 1: 'middle', 2: 'bottom'};
		
		/**
		 * 样式表信息。
		 */
		public static var styleSheets:Object = {};
		/**水平居中对齐方式。 */
		public static const ALIGN_CENTER:int = 1;
		/**水平居右对齐方式。 */
		public static const ALIGN_RIGHT:int = 2;
		/**垂直居中对齐方式。 */
		public static const VALIGN_MIDDLE:int = 1;
		/**垂直居底部对齐方式。 */
		public static const VALIGN_BOTTOM:int = 2;
		/**@private */
		protected static const _CSS_BLOCK:int = 0x1;
		/**@private */
		protected static const _DISPLAY_NONE:int = 0x2;
		/**@private */
		protected static const _ABSOLUTE:int = 0x4;
		/**@private */
		protected static const _WIDTH_SET:int = 0x8;
		
		private static var _PADDING:Array = /*[STATIC SAFE]*/ [0, 0, 0, 0];
		private static var _RECT:Array = /*[STATIC SAFE]*/ [-1, -1, -1, -1];
		private static var _SPACING:Array = /*[STATIC SAFE]*/ [0, 0];
		private static var _ALIGNS:Array = /*[STATIC SAFE]*/ [0, 0, 0];
		
		/**添加布局。 */
		public static const ADDLAYOUTED:int = 0x200;
		
		private static const _NEWFONT:int = 0x1000;
		private static const _HEIGHT_SET:int = 0x2000;
		private static const _BACKGROUND_SET:int = 0x4000;
		private static const _FLOAT_RIGHT:int = 0x8000;
		private static const _LINE_ELEMENT:int = 0x10000;
		private static const _NOWARP:int = 0x20000;
		private static const _WIDTHAUTO:int = 0x40000;
		private static const _LISTERRESZIE:int = 0x80000;
		
		private var _padding:Array = _PADDING;
		private var _spacing:Array = _SPACING;
		private var _aligns:Array = _ALIGNS;
		private var _font:Font = Font.EMPTY;
		private var _bgground:Object = null;
		private var _border:Object = null;
		private var _ower:Sprite;
		private var _rect:Object = null;
		/**@private */
		public var underLine:int = 0;
		
		/**
		 * 是否显示为块级元素。
		 */
		public function set block(value:Boolean):void {
			value ? (_type |= _CSS_BLOCK) : (_type &= (~_CSS_BLOCK));
		}
		
		/**行高。 */
		public var lineHeight:Number = 0;
		
		/**
		 * 创建一个新的 <code>CSSStyle</code> 类实例。
		 * @param	ower 当前 CSSStyle 对象的拥有者。
		 */
		public function CSSStyle(ower:Sprite) {
			_ower = ower;
		}
		
		/**@inheritDoc	 */
		override public function destroy():void {
			_ower = null;
			_font = null;
			_rect = null;
		}
		
		/**
		 * 复制传入的 CSSStyle 属性值。
		 * @param	src 待复制的 CSSStyle 对象。
		 */
		public function inherit(src:CSSStyle):void {
			_font = src._font;
			_spacing = src._spacing === _SPACING ? _SPACING : src._spacing.slice();
			//_aligns = src._aligns === _ALIGNS ? _ALIGNS : src._aligns.slice();
			lineHeight = src.lineHeight;
		}
		
		/**@private */
		public function _widthAuto():Boolean {
			return (_type & _WIDTHAUTO) !== 0;// || (_type & _WIDTH_SET) === 0;
		}
		
		/**@inheritDoc	 */
		public function widthed(sprite:*):Boolean {
			return (_type & _WIDTH_SET) != 0;
		}
		
		/**
		 * @private
		 */
		public function _calculation(type:String, value:String):Boolean {
			if (value.indexOf('%') < 0) return false;
			var ower:Sprite = _ower;
			var parent:Sprite = ower.parent as Sprite;
			var rect:Object = _rect;
			
			function getValue(pw:Number, w:Number, nums:Array):Number {
				return (pw * nums[0] + w * nums[1] + nums[2]);
			}
			function onParentResize(type:String):void {
				var pw:Number = parent.width, w:Number = ower.width;
				rect.width && (ower.width = getValue(pw, w, rect.width));
				rect.height && (ower.height = getValue(pw, w, rect.height));
				rect.left && (ower.x = getValue(pw, w, rect.left));
				rect.top && (ower.y = getValue(pw, w, rect.top));
			}
			
			if (rect === null) {
				parent._getCSSStyle()._type |= _LISTERRESZIE;
				parent.on(Event.RESIZE, this, onParentResize);
				_rect = rect = {input: {}};
			}
			var nums:Array = value.split(' ');
			nums[0] = parseFloat(nums[0]) / 100;
			if (nums.length == 1)
				nums[1] = nums[2] = 0;
			else {
				nums[1] = parseFloat(nums[1]) / 100;
				nums[2] = parseFloat(nums[2]);
			}
			rect[type] = nums;
			rect.input[type] = value;
			onParentResize(type);
			return true;
		}
		
		/**
		 * 宽度。
		 */
		public function set width(w:*):void {
			_type |= _WIDTH_SET;
			if (w is String) {
				var offset:int = w.indexOf('auto');
				if (offset >= 0) {
					_type |= _WIDTHAUTO;
					w = w.substr(0, offset);
				}
				if (_calculation("width", w)) return;
				w = parseInt(w);
			}
			size(w, -1);
		}
		
		/**
		 * 高度。
		 */
		public function set height(h:*):void {
			_type |= _HEIGHT_SET;
			if (h is String) {
				if (_calculation("height", h)) return;
				h = parseInt(h);
			}
			size(-1, h);
		}
		
		/**
		 * 是否已设置高度。
		 * @param	sprite 显示对象 Sprite。
		 * @return 一个Boolean 表示是否已设置高度。
		 */
		public function heighted(sprite:*):Boolean {
			return (_type & _HEIGHT_SET) != 0;
		}
		
		/**
		 * 设置宽高。
		 * @param	w 宽度。
		 * @param	h 高度。
		 */
		public function size(w:Number, h:Number):void {
			var ower:Sprite = _ower;
			var resize:Boolean = false;
			if (w !== -1 && w != _ower.width) {
				_type |= _WIDTH_SET;
				_ower.width = w;
				resize = true;
			}
			if (h !== -1 && h != _ower.height) {
				_type |= _HEIGHT_SET;
				_ower.height = h;
				resize = true;
			}
			if (resize) {
				ower._layoutLater();
				(_type & _LISTERRESZIE) && ower.event(Event.RESIZE, this);
			}
		}
		
		/**
		 * 表示左边距。
		 */
		public function set left(value:*):void {
			var ower:Sprite = _ower;
			if ((value is String)) {
				if (value === "center")
					value = "50% -50% 0";
				else if (value === "right")
					value = "100% -100% 0";
				if (_calculation("left", value)) return;
				value = parseInt(value);
			}
			ower.x = value;
		}
		
		/**
		 * 表示上边距。
		 */
		public function set top(value:*):void {
			var ower:Sprite = _ower;
			if ((value is String)) {
				if (value === "middle")
					value = "50% -50% 0";
				else if (value === "bottom")
					value = "100% -100% 0";
				if (_calculation("top", value)) return;
				value = parseInt(value);
			}
			ower.y = value;
		}
		
		/**
		 * 边距信息。
		 */
		public function get padding():Array {
			return _padding;
		}
		
		public function set padding(value:Array):void {
			_padding = value;
		}
		
		/**
		 * 是否是行元素。
		 */
		public function get lineElement():Boolean {
			return (_type & _LINE_ELEMENT) != 0;
		}
		
		public function set lineElement(value:Boolean):void {
			value ? (_type |= _LINE_ELEMENT) : (_type &= (~_LINE_ELEMENT));
		}
		
		/**
		 * 水平对齐方式。
		 */
		public function get align():String {
			return _aligndef[_aligns[0]];
		}
		
		public function set align(value:String):void {
			_aligns === _ALIGNS && (_aligns = [0, 0, 0]);
			_aligns[0] = _aligndef[value];
		}
		
		/**@private */
		public function _getAlign():int //垂直对齐方式
		{
			return _aligns[0];
		}
		
		/**
		 * 垂直对齐方式。
		 */
		public function get valign():String //垂直对齐方式
		{
			return _valigndef[_aligns[1]];
		}
		
		public function set valign(value:String):void //垂直对齐方式
		{
			_aligns === _ALIGNS && (_aligns = [0, 0, 0]);
			_aligns[1] = _valigndef[value];
		}
		
		/**@private */
		public function _getValign():int //垂直对齐方式
		{
			return _aligns[1];
		}
		
		public function set cssFloat(value:String):void {
			lineElement = false;
			value === "right" ? (_type |= _FLOAT_RIGHT) : (_type &= (~_FLOAT_RIGHT));
		}
		
		/**
		 * 浮动方向。
		 */
		public function get cssFloat():String {
			return (_type & _FLOAT_RIGHT) != 0 ? "right" : "left";
		}
		
		/**@private */
		public function _getCssFloat():int {
			return (_type & _FLOAT_RIGHT) != 0 ? _FLOAT_RIGHT : 0;
		}
		
		public function set whiteSpace(type:String):void {
			type === "nowrap" && (_type |= _NOWARP);
			type === "none" && (_type &= ~_NOWARP);
		}
		
		/**
		 * 设置如何处理元素内的空白。
		 */
		public function get whiteSpace():String {
			return (_type & _NOWARP) ? "nowrap" : "";
		}
		
		/**
		 * 表示是否换行。
		 */
		public function get wordWrap():Boolean {
			return (_type & _NOWARP) === 0;
		}
		
		public function set wordWrap(value:Boolean):void {
			value ? (_type &= ~_NOWARP) : (_type |= _NOWARP);
		}
		
		/**
		 * 表示是否加粗。
		 */
		public function get bold():Boolean {
			return _font.bold;
		}
		
		public function set bold(value:Boolean):void {
			_createFont().bold = value;
		}
		
		private function _createFont():Font {
			return (_type & _NEWFONT) ? _font : (_type |= _NEWFONT, _font = new Font(_font));
		}
		
		/**
		 * <p>指定文本字段是否是密码文本字段。</p>
		 * 如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。如果为 false，则不会将文本字段视为密码文本字段。
		 */
		public function set password(value:Boolean):void {
			_createFont().password = value;
		}
		
		public function get password():Boolean {
			return _font.password;
		}
		
		public function set font(value:String):void {
			_createFont().set(value);
		}
		
		/**
		 * 字体信息。
		 */
		public function get font():String {
			return _font.toString();
		}
		
		/**
		 * 文本的粗细。
		 */
		public function set weight(value:String):void {
			_createFont().weight = value;
		}
		
		public function set letterSpacing(d:int):void {
			(d is String) && (d = parseInt(d + ""));
			_spacing === _SPACING && (_spacing = [0, 0]);
			_spacing[0] = d;
		}
		
		/**
		 * 字体大小。
		 */
		public function get fontSize():int {
			return _font.size;
		}
		
		public function set fontSize(value:int):void {
			_createFont().size = value;
		}
		
		/**
		 * 间距。
		 */
		public function get letterSpacing():int {
			return _spacing[0];
		}
		
		public function set leading(d:int):void {
			(d is String) && (d = parseInt(d + ""));
			_spacing === _SPACING && (_spacing = [0, 0]);
			_spacing[1] = d;
		}
		
		/**
		 * 行间距。
		 */
		public function get leading():int {
			return _spacing[1];
		}
		
		/**
		 * 表示是否为斜体。
		 */
		public function get italic():Boolean {
			return _font.italic;
		}
		
		public function set italic(value:Boolean):void {
			_createFont().italic = value;
		}
		
		public function set fontFamily(value:String):void {
			_createFont().family = value;
		}
		
		/**
		 * 字体系列。
		 */
		public function get fontFamily():String {
			return _font.family;
		}
		
		public function set fontWeight(value:String):void {
			_createFont().weight = value;
		}
		
		/**
		 * 字体粗细。
		 */
		public function get fontWeight():String {
			return _font.weight;
		}
		
		/**
		 * 添加到文本的修饰。
		 */
		public function get textDecoration():String {
			return _font.decoration;
		}
		
		public function set textDecoration(value:String):void {
			_createFont().decoration = value;
		}
		
		/**
		 * 字体颜色。
		 */
		public function get color():String {
			return _font.color;
		}
		
		public function set color(value:String):void {
			_createFont().color = value;
		}
		
		/**
		 * <p>描边宽度（以像素为单位）。</p>
		 * 默认值0，表示不描边。
		 * @default 0
		 */
		public function get stroke():Number {
			return _font.stroke[0];
		}
		
		public function set stroke(value:Number):void {
			if (_createFont().stroke === Font._STROKE) _font.stroke = [0, "#000000"];
			_font.stroke[0] = value;
		}
		
		/**
		 * <p>描边颜色，以字符串表示。</p>
		 * @default "#000000";
		 */
		public function get strokeColor():String {
			return _font.stroke[1];
		}
		
		public function set strokeColor(value:String):void {
			if (_createFont().stroke === Font._STROKE) _font.stroke = [0, "#000000"];
			_font.stroke[1] = value;
		}
		
		/**
		 * 边框属性，比如border="5px solid red"
		 */
		public function get border():String {
			return _border ? _border.value : "";
		}
		
		public function set border(value:String):void//border:5px solid red;
		{
			if (value == 'none') {
				_border = null;
				return;
			}
			_border || (_border = {});
			_border.value = value;
			var values:Array = value.split(' ');
			_border.color = Color.create(values[values.length - 1]);
			if (values.length == 1) {
				_border.size = 1;
				_border.type = 'solid';
				return;
			}
			
			var i:int = 0;
			
			if (values[0].indexOf('px') > 0) {
				_border.size = parseInt(values[0]);
				i++;
			} else _border.size = 1;
			
			_border.type = values[i];
			
			_ower._renderType |= RenderSprite.STYLE;
		}
		
		/**
		 * 边框的颜色。
		 */
		public function get borderColor():String {
			return (_border && _border.color) ? _border.color.strColor : null;
		}
		
		public function set borderColor(value:String):void {
			if (!value) {
				_border = null;
				return;
			}
			_border || (_border = {size: 1, type: 'solid'});
			_border.color = (value == null) ? null : Color.create(value);
			_ower.conchModel && _ower.conchModel.border(_border.color.strColor);
			_ower._renderType |= RenderSprite.STYLE;
		}
		
		public function set backgroundColor(value:String):void {
			if (value === 'none') _bgground = null;
			else (_bgground || (_bgground = {}), _bgground.color = value);
			_ower.conchModel && _ower.conchModel.bgColor(value);
			_ower._renderType |= RenderSprite.STYLE;
		}
		
		/**
		 * 背景颜色。
		 */
		public function get backgroundColor():String {
			return _bgground ? _bgground.color : null;
		}
		
		public function set background(value:String):void {
			if (!value) {
				_bgground = null;
				return;
			}
			_bgground || (_bgground = {});
			_bgground.color = value;
			_ower.conchModel && _ower.conchModel.bgColor(value);
			_type |= _BACKGROUND_SET;
			_ower._renderType |= RenderSprite.STYLE;
		}
		
		/**@inheritDoc	 */
		override public function render(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
			var w:Number = sprite.width;
			var h:Number = sprite.height;
			
			x -= sprite.pivotX;
			y -= sprite.pivotY;
			_bgground && _bgground.color != null && context.ctx.fillRect(x, y, w, h, _bgground.color);
			_border && _border.color && context.drawRect(x, y, w, h, _border.color.strColor, _border.size);
		}
		
		/**@inheritDoc	 */
		override public function getCSSStyle():CSSStyle {
			return this;
		}
		
		/**
		 * 设置 CSS 样式字符串。
		 * @param	text CSS样式字符串。
		 */
		public function cssText(text:String):void {
			attrs(parseOneCSS(text, ';'));
		}
		
		/**
		 * 根据传入的属性名、属性值列表，设置此对象的属性值。
		 * @param	attrs 属性名与属性值列表。
		 */
		public function attrs(attrs:Array):void {
			if (attrs) {
				for (var i:int = 0, n:int = attrs.length; i < n; i++) {
					var attr:Array = attrs[i];
					this[attr[0]] = attr[1];
				}
			}
		}
		
		public function set position(value:String):void {
			value == "absolute" ? (_type |= _ABSOLUTE) : (_type &= ~_ABSOLUTE);
		}
		
		/**
		 * 元素的定位类型。
		 */
		public function get position():String {
			return (_type & _ABSOLUTE) ? "absolute" : "";
		}
		
		/**@inheritDoc	 */
		public override function get absolute():Boolean {
			return (_type & _ABSOLUTE) !== 0;
		}
		
		/**
		 * 规定元素应该生成的框的类型。
		 */
		public function set display(value:String):void {
			switch (value) {
			case '': 
				_type &= ~_DISPLAY_NONE;
				visible = true;
				break;
			case 'none': 
				_type |= _DISPLAY_NONE;
				visible = false;
				_ower._layoutLater();
				break;
			}
		}
		
		/**@inheritDoc	 */
		override public function setTransform(value:*):void {
			(value === 'none') ? (_tf = _TF_EMPTY) : attrs(parseOneCSS(value, ','));
		}
		
		/**@inheritDoc	 */
		override public function get paddingLeft():Number {
			return padding[3];
		}
		
		/**@inheritDoc	 */
		override public function get paddingTop():Number {
			return padding[0];
		}
		
		private function set _scale(value:Array):void {
			_ower.scale(value[0], value[1]);
		}
		
		private function set _translate(value:Array):void {
			translate(value[0], value[1]);
		}
		
		/**
		 * 定义 X 轴、Y 轴移动转换。
		 * @param	x X 轴平移量。
		 * @param	y Y 轴平移量。
		 */
		public function translate(x:Number, y:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.translateX = x;
			_tf.translateY = y;
		}
		
		/**
		 * 定义 缩放转换。
		 * @param	x X 轴缩放值。
		 * @param	y Y 轴缩放值。
		 */
		public function scale(x:Number, y:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.scaleX = x;
			_tf.scaleY = y;
		}
		
		private function set _rotate(value:Number):void {
			_ower.rotation = value;
		}
		
		/**@private */
		public override function _enableLayout():Boolean {
			return (_type & _DISPLAY_NONE) === 0 && (_type & _ABSOLUTE) === 0;
		}
		
		/**
		 * 通过传入的分割符，分割解析CSS样式字符串，返回样式列表。
		 * @param	text CSS样式字符串。
		 * @param	clipWord 分割符；
		 * @return 样式列表。
		 */
		public static function parseOneCSS(text:String, clipWord:String):Array {
			var out:Array = [];
			var attrs:Array = text.split(clipWord);
			var valueArray:Array;
			
			for (var i:int = 0, n:int = attrs.length; i < n; i++) {
				var attr:String = attrs[i];
				var ofs:int = attr.indexOf(':');
				var name:String = attr.substr(0, ofs).replace(/^\s+|\s+$/g, '');
				
				// 最后一个元素是空元素。
				if (name.length == 0)
					continue;
				
				var value:String = attr.substr(ofs + 1).replace(/^\s+|\s+$/g, '');//去掉前后空格和\n\t
				var one:Array = [name, value];
				switch (name) {
				case 'italic': 
				case 'bold': 
					one[1] = value == "true";
					break;
				case 'line-height': 
					one[0] = 'lineHeight';
					one[1] = parseInt(value);
					break;
				case 'font-size': 
					one[0] = 'fontSize';
					one[1] = parseInt(value);
					break;
				case 'padding': 
					valueArray = value.split(' ');
					valueArray.length > 1 || (valueArray[1] = valueArray[2] = valueArray[3] = valueArray[0]);
					one[1] = [parseInt(valueArray[0]), parseInt(valueArray[1]), parseInt(valueArray[2]), parseInt(valueArray[3])];
					break;
				case 'rotate': 
					one[0] = "_rotate";
					one[1] = parseFloat(value);
					break;
				case 'scale': 
					valueArray = value.split(' ');
					one[0] = "_scale";
					one[1] = [parseFloat(valueArray[0]), parseFloat(valueArray[1])];
					break;
				case 'translate': 
					valueArray = value.split(' ');
					one[0] = "_translate";
					one[1] = [parseInt(valueArray[0]), parseInt(valueArray[1])];
					break;
				default: 
					(one[0] = _CSSTOVALUE[name]) || (one[0] = name);
				}
				out.push(one);
			}
			
			return out;
		}
		
		/**
		 * 解析 CSS 样式文本。
		 * @param	text CSS 样式文本。
		 * @param	uri URL对象。
		 * @internal 此处需要再详细点注释。
		 */
		public static function parseCSS(text:String, uri:URL):void {
			var one:Array;
			
			while ((one = _parseCSSRegExp.exec(text)) != null) {
				styleSheets[one[1]] = parseOneCSS(one[2], ';');
			}
		}
	}

}
/*
   所有元素可继承：visibility和cursor。
   内联元素可继承：letter-spacing、word-spacing、white-space、line-height、color、font、 font-family、font-size、font-style、font-variant、font-weight、text- decoration、text-transform、direction。
   块状元素可继承：text-indent和text-align。
   列表元素可继承：list-style、list-style-type、list-style-position、list-style-image。
   表格元素可继承：border - collapse。
 */