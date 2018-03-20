package laya.display {
	
	import laya.display.css.CSSStyle;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.utils.Browser;
	import laya.utils.WordText;
	
	/**
	 * 文本内容发生改变后调度。
	 * @eventType Event.CHANGE
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Text</code> 类用于创建显示对象以显示文本。</p>
	 * <p>
	 * 注意：如果运行时系统找不到设定的字体，则用系统默认的字体渲染文字，从而导致显示异常。(通常电脑上显示正常，在一些移动端因缺少设置的字体而显示异常)。
	 * </p>
	 * @example
	 * package
	 * {
	 * 	import laya.display.Text;
	 * 	public class Text_Example
	 * 	{
	 * 		public function Text_Example()
	 * 		{
	 * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 * 			onInit();
	 * 		}
	 * 		private function onInit():void
	 * 		{
	 * 			var text:Text = new Text();//创建一个 Text 类的实例对象 text 。
	 * 			text.text = "这个是一个 Text 文本示例。";
	 * 			text.color = "#008fff";//设置 text 的文本颜色。
	 * 			text.font = "Arial";//设置 text 的文本字体。
	 * 			text.bold = true;//设置 text 的文本显示为粗体。
	 * 			text.fontSize = 30;//设置 text 的字体大小。
	 * 			text.wordWrap = true;//设置 text 的文本自动换行。
	 * 			text.x = 100;//设置 text 对象的属性 x 的值，用于控制 text 对象的显示位置。
	 * 			text.y = 100;//设置 text 对象的属性 y 的值，用于控制 text 对象的显示位置。
	 * 			text.width = 300;//设置 text 的宽度。
	 * 			text.height = 200;//设置 text 的高度。
	 * 			text.italic = true;//设置 text 的文本显示为斜体。
	 * 			text.borderColor = "#fff000";//设置 text 的文本边框颜色。
	 * 			Laya.stage.addChild(text);//将 text 添加到显示列表。
	 * 		}
	 * 	}
	 * }
	 * @example
	 * Text_Example();
	 * function Text_Example()
	 * {
	 *     Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *     Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *     onInit();
	 * }
	 * function onInit()
	 * {
	 *     var text = new laya.display.Text();//创建一个 Text 类的实例对象 text 。
	 *     text.text = "这个是一个 Text 文本示例。";
	 *     text.color = "#008fff";//设置 text 的文本颜色。
	 *     text.font = "Arial";//设置 text 的文本字体。
	 *     text.bold = true;//设置 text 的文本显示为粗体。
	 *     text.fontSize = 30;//设置 text 的字体大小。
	 *     text.wordWrap = true;//设置 text 的文本自动换行。
	 *     text.x = 100;//设置 text 对象的属性 x 的值，用于控制 text 对象的显示位置。
	 *     text.y = 100;//设置 text 对象的属性 y 的值，用于控制 text 对象的显示位置。
	 *     text.width = 300;//设置 text 的宽度。
	 *     text.height = 200;//设置 text 的高度。
	 *     text.italic = true;//设置 text 的文本显示为斜体。
	 *     text.borderColor = "#fff000";//设置 text 的文本边框颜色。
	 *     Laya.stage.addChild(text);//将 text 添加到显示列表。
	 * }
	 * @example
	 * class Text_Example {
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         this.onInit();
	 *     }
	 *     private onInit(): void {
	 *         var text: laya.display.Text = new laya.display.Text();//创建一个 Text 类的实例对象 text 。
	 *         text.text = "这个是一个 Text 文本示例。";
	 *         text.color = "#008fff";//设置 text 的文本颜色。
	 *         text.font = "Arial";//设置 text 的文本字体。
	 *         text.bold = true;//设置 text 的文本显示为粗体。
	 *         text.fontSize = 30;//设置 text 的字体大小。
	 *         text.wordWrap = true;//设置 text 的文本自动换行。
	 *         text.x = 100;//设置 text 对象的属性 x 的值，用于控制 text 对象的显示位置。
	 *         text.y = 100;//设置 text 对象的属性 y 的值，用于控制 text 对象的显示位置。
	 *         text.width = 300;//设置 text 的宽度。
	 *         text.height = 200;//设置 text 的高度。
	 *         text.italic = true;//设置 text 的文本显示为斜体。
	 *         text.borderColor = "#fff000";//设置 text 的文本边框颜色。
	 *         Laya.stage.addChild(text);//将 text 添加到显示列表。
	 *     }
	 * }
	 */
	public class Text extends Sprite {
		/**@private 预测长度的文字，用来提升计算效率，不同语言找一个最大的字符即可*/
		public static var _testWord:String = "游";
		/**语言包*/
		public static var langPacks:Object;
		/**visible不进行任何裁切。*/
		public static var VISIBLE:String = "visible";
		/**scroll 不显示文本域外的字符像素，并且支持 scroll 接口。*/
		public static var SCROLL:String = "scroll";
		/**hidden 不显示超出文本域的字符。*/
		public static var HIDDEN:String = "hidden";
		/**
		 * WebGL渲染文字时是否启用字符缓存，对于字形多的语种，禁用缓存。<br>
		 * 对于字形随字母组合变化的语种，如阿拉伯文，启用将使显示错误。但是即使禁用，自动换行也会在错误的地方截断。
		 */
		public static var CharacterCache:Boolean = true;
		/**是否是从右向左的显示顺序*/
		public static var RightToLeft:Boolean = false;
		/**位图字体字典。*/
		private static var _bitmapFonts:Object;
		
		/** @private */
		private var _clipPoint:Point;
		/**当前使用的位置字体。*/
		private var _currBitmapFont:BitmapFont;
		/**@private 表示文本内容字符串。*/
		protected var _text:String;
		/** @private 表示文本内容是否发生改变。*/
		protected var _isChanged:Boolean;
		/**@private 表示文本的宽度，以像素为单位。*/
		protected var _textWidth:Number = 0;
		/**@private 表示文本的高度，以像素为单位。*/
		protected var _textHeight:Number = 0;
		/**@private 存储文字行数信息。*/
		protected var _lines:Array = [];
		/**@private 保存每行宽度*/
		protected var _lineWidths:Array = [];
		/**@private 文本的内容位置 X 轴信息。*/
		protected var _startX:Number;
		/**@private 文本的内容位置X轴信息。 */
		protected var _startY:Number;
		/**@private 当前可视行索引。*/
		protected var _lastVisibleLineIndex:int = -1;
		/**@private 当前可视行索引。*/
		protected var _words:Vector.<WordText>;
		/**@private */
		protected var _charSize:Object = {};
		/**
		 * 存在于这个映射表中的字体，在IPhone上，会变成 字体-简|繁
		 * 这个字体列表不包含全部可能的字体集。
		 * 这些字体在不同国家或语言地区的设备上可能名字也不一样。
		 * 所以这个方式不能从根源上解决不同设备的字体集差异。
		 */
		protected static var _fontFamilyMap:Object = {"报隶" : "报隶-简", "黑体" : "黑体-简", "楷体" : "楷体-简", "兰亭黑" : "兰亭黑-简", "隶变" : "隶变-简", "凌慧体" : "凌慧体-简", "翩翩体" : "翩翩体-简", "苹方" : "苹方-简", "手札体" : "手札体-简", "宋体" : "宋体-简", "娃娃体" : "娃娃体-简", "魏碑" : "魏碑-简", "行楷" : "行楷-简", "雅痞" : "雅痞-简", "圆体" : "圆体-简"};
		
		/**
		 * <p>overflow 指定文本超出文本域后的行为。其值为"hidden"、"visible"和"scroll"之一。</p>
		 * <p>性能从高到低依次为：hidden > visible > scroll。</p>
		 */
		public var overflow:String = VISIBLE;
		/**
		 * 是否显示下划线。
		 */
		public var underline:Boolean = false;
		/**
		 * 下划线的颜色，为null则使用字体颜色。
		 */
		private var _underlineColor:String = null;
		
		/**
		 * 创建一个新的 <code>Text</code> 实例。
		 */
		public function Text():void {
			_style = new CSSStyle(this);
			(_style as CSSStyle).wordWrap = false;
		}
		
		/**
		 * 注册位图字体。
		 * @param	name		位图字体的名称。
		 * @param	bitmapFont	位图字体文件。
		 */
		public static function registerBitmapFont(name:String, bitmapFont:BitmapFont):void {
			_bitmapFonts || (_bitmapFonts = {});
			_bitmapFonts[name] = bitmapFont;
		}
		
		/**
		 * 移除注册的位图字体文件。
		 * @param	name		位图字体的名称。
		 * @param	destroy		是否销毁指定的字体文件。
		 */
		public static function unregisterBitmapFont(name:String, destroy:Boolean = true):void {
			if (_bitmapFonts && _bitmapFonts[name]) {
				var tBitmapFont:BitmapFont = _bitmapFonts[name];
				if (destroy) {
					tBitmapFont.destroy();
				}
				delete _bitmapFonts[name];
			}
		}
		
		/**
		 * 设置文字排版模式为右到左。
		 */
		public static function setTextRightToLeft():void
		{
			var style:Object;
			style = Browser.canvas.source.style;
			style.display = "none";
			style.position = "absolute";
			style.direction = "rtl";
			//Browser.document.body.style.direction = "rtl";
			Render._mainCanvas.source.style.direction = "rtl";
			Text.RightToLeft = true;
			Browser.document.body.appendChild(Browser.canvas.source);
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_lines = null;
			if (_words) {
				_words.length = 0;
				_words = null;
			}
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function _getBoundPointsM(ifRotate:Boolean = false):Array {
			var rec:Rectangle = Rectangle.TEMP;
			rec.setTo(0, 0, width, height);
			return rec._getBoundPoints();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getGraphicBounds(realSize:Boolean = false):Rectangle {
			var rec:Rectangle = Rectangle.TEMP;
			rec.setTo(0, 0, width, height);
			return rec;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number {
			if (_width)
				return _width;
			return textWidth + padding[1] + padding[3];
		}
		
		override public function set width(value:Number):void {
			if (value != _width) {
				super.width = value;
				isChanged = true;
			}
		}
		
		/**
		 * @private
		 * @inheritDoc
		 */
		override public function _getCSSStyle():CSSStyle {
			return _style as CSSStyle;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number {
			if (_height) return _height;
			return textHeight + padding[0] + padding[2];
		}
		
		override public function set height(value:Number):void {
			if (value != _height) {
				super.height = value;
				isChanged = true;
			}
		}
		
		/**
		 * 表示文本的宽度，以像素为单位。
		 */
		public function get textWidth():Number {
			_isChanged && Laya.timer.runCallLater(this, typeset);
			return _textWidth;
		}
		
		/**
		 * 表示文本的高度，以像素为单位。
		 */
		public function get textHeight():Number {
			_isChanged && Laya.timer.runCallLater(this, typeset);
			return _textHeight;
		}
		
		/** 当前文本的内容字符串。*/
		public function get text():String {
			return this._text || "";
		}
		
		public function set text(value:String):void {
			if (this._text !== value) {
				lang(value + "");
				isChanged = true;
				event(Event.CHANGE);
			}
		}
		
		/**
		 * <p>根据指定的文本，从语言包中取当前语言的文本内容。并对此文本中的{i}文本进行替换。</p>
		 * <p>设置Text.langPacks语言包后，即可使用lang获取里面的语言</p>
		 * <p>例如：
		 * <li>（1）text 的值为“我的名字”，先取到这个文本对应的当前语言版本里的值“My name”，将“My name”设置为当前文本的内容。</li>
		 * <li>（2）text 的值为“恭喜你赢得{0}个钻石，{1}经验。”，arg1 的值为100，arg2 的值为200。
		 * 			则先取到这个文本对应的当前语言版本里的值“Congratulations on your winning {0} diamonds, {1} experience.”，
		 * 			然后将文本里的{0}、{1}，依据括号里的数字从0开始替换为 arg1、arg2 的值。
		 * 			将替换处理后的文本“Congratulations on your winning 100 diamonds, 200 experience.”设置为当前文本的内容。
		 * </li>
		 * </p>
		 * @param	text 文本内容。
		 * @param	...args 文本替换参数。
		 */
		public function lang(text:String, arg1:* = null, arg2:* = null, arg3:* = null, arg4:* = null, arg5:* = null, arg6:* = null, arg7:* = null, arg8:* = null, arg9:* = null, arg10:* = null):void {
			text = langPacks && langPacks[text] ? langPacks[text] : text;
			if (arguments.length < 2) {
				this._text = text;
			} else {
				for (var i:int = 0, n:int = arguments.length; i < n; i++) {
					text = text.replace("{" + i + "}", arguments[i + 1]);
				}
				this._text = text;
			}
		}
		
		/**
		 * <p>文本的字体名称，以字符串形式表示。</p>
		 * <p>默认值为："Arial"，可以通过Font.defaultFont设置默认字体。</p>
		 * <p>如果运行时系统找不到设定的字体，则用系统默认的字体渲染文字，从而导致显示异常。(通常电脑上显示正常，在一些移动端因缺少设置的字体而显示异常)。</p>
		 * @see laya.display.css.Font#defaultFamily
		 */
		public function get font():String {
			return _getCSSStyle().fontFamily;
		}
		
		public function set font(value:String):void {
			if (_currBitmapFont) {
				_currBitmapFont = null;
				scale(1, 1);
			}
			if (_bitmapFonts && _bitmapFonts[value]) {
				_currBitmapFont = _bitmapFonts[value];
			}
			
			_getCSSStyle().fontFamily = value;
			isChanged = true;
		}
		
		/**
		 * <p>指定文本的字体大小（以像素为单位）。</p>
		 * <p>默认为20像素，可以通过 <code>Text.defaultSize</code> 设置默认大小。</p>
		 */
		public function get fontSize():int {
			return _getCSSStyle().fontSize;
		}
		
		public function set fontSize(value:int):void {
			_getCSSStyle().fontSize = value;
			isChanged = true;
		}
		
		/**
		 * <p>指定文本是否为粗体字。</p>
		 * <p>默认值为 false，这意味着不使用粗体字。如果值为 true，则文本为粗体字。</p>
		 */
		public function get bold():Boolean {
			return _getCSSStyle().bold;
		}
		
		public function set bold(value:Boolean):void {
			_getCSSStyle().bold = value;
			isChanged = true;
		}
		
		/**
		 * <p>表示文本的颜色值。可以通过 <code>Text.defaultColor</code> 设置默认颜色。</p>
		 * <p>默认值为黑色。</p>
		 */
		public function get color():String {
			return _getCSSStyle().color;
		}
		
		public function set color(value:String):void {
			if (_getCSSStyle().color != value) {
				_getCSSStyle().color = value;
				//如果仅仅更新颜色，无需重新排版
				if (!_isChanged && this._graphics) {
					this._graphics.replaceTextColor(color)
				} else {
					isChanged = true;
				}
			}
		}
		
		/**
		 * <p>表示使用此文本格式的文本是否为斜体。</p>
		 * <p>默认值为 false，这意味着不使用斜体。如果值为 true，则文本为斜体。</p>
		 */
		public function get italic():Boolean {
			return _getCSSStyle().italic;
		}
		
		public function set italic(value:Boolean):void {
			_getCSSStyle().italic = value;
			isChanged = true;
		}
		
		/**
		 * <p>表示文本的水平显示方式。</p>
		 * <p><b>取值：</b>
		 * <li>"left"： 居左对齐显示。</li>
		 * <li>"center"： 居中对齐显示。</li>
		 * <li>"right"： 居右对齐显示。</li>
		 * </p>
		 */
		public function get align():String {
			return _getCSSStyle().align;
		}
		
		public function set align(value:String):void {
			_getCSSStyle().align = value;
			isChanged = true;
		}
		
		/**
		 * <p>表示文本的垂直显示方式。</p>
		 * <p><b>取值：</b>
		 * <li>"top"： 居顶部对齐显示。</li>
		 * <li>"middle"： 居中对齐显示。</li>
		 * <li>"bottom"： 居底部对齐显示。</li>
		 * </p>
		 */
		public function get valign():String {
			return _getCSSStyle().valign;
		}
		
		public function set valign(value:String):void {
			_getCSSStyle().valign = value;
			isChanged = true;
		}
		
		/**
		 * <p>表示文本是否自动换行，默认为false。</p>
		 * <p>若值为true，则自动换行；否则不自动换行。</p>
		 */
		public function get wordWrap():Boolean {
			return _getCSSStyle().wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void {
			_getCSSStyle().wordWrap = value;
			isChanged = true;
		}
		
		/**
		 * 垂直行间距（以像素为单位）。
		 */
		public function get leading():Number {
			return _getCSSStyle().leading;
		}
		
		public function set leading(value:Number):void {
			_getCSSStyle().leading = value;
			isChanged = true;
		}
		
		/**
		 * <p>边距信息。</p>
		 * <p>数据格式：[上边距，右边距，下边距，左边距]（边距以像素为单位）。</p>
		 */
		public function get padding():Array {
			return _getCSSStyle().padding;
		}
		
		public function set padding(value:Array):void {
			_getCSSStyle().padding = value;
			isChanged = true;
		}
		
		/**
		 * 文本背景颜色，以字符串表示。
		 */
		public function get bgColor():String {
			return _getCSSStyle().backgroundColor;
		}
		
		public function set bgColor(value:String):void {
			_getCSSStyle().backgroundColor = value;
			isChanged = true;
		}
		
		/**
		 * 文本边框背景颜色，以字符串表示。
		 */
		public function get borderColor():String {
			return _getCSSStyle().borderColor;
		}
		
		public function set borderColor(value:String):void {
			_getCSSStyle().borderColor = value;
			isChanged = true;
		}
		
		/**
		 * <p>描边宽度（以像素为单位）。</p>
		 * <p>默认值0，表示不描边。</p>
		 */
		public function get stroke():Number {
			return this._getCSSStyle().stroke;
		}
		
		public function set stroke(value:Number):void {
			_getCSSStyle().stroke = value;
			isChanged = true;
		}
		
		/**
		 * <p>描边颜色，以字符串表示。</p>
		 * <p>默认值为 "#000000"（黑色）;</p>
		 */
		public function get strokeColor():String {
			return this._getCSSStyle().strokeColor;
		}
		
		public function set strokeColor(value:String):void {
			_getCSSStyle().strokeColor = value;
			isChanged = true;
		}
		
		/**
		 * 一个布尔值，表示文本的属性是否有改变。若为true表示有改变。
		 */
		protected function set isChanged(value:Boolean):void {
			if (this._isChanged !== value) {
				this._isChanged = value;
				value && Laya.timer.callLater(this, typeset);
			}
		}
		
		/**
		 * @private
		 */
		protected function _isPassWordMode():Boolean
		{
			var style:CSSStyle = _style as CSSStyle;
			var password:Boolean = style.password;
			if (("prompt" in this) && this['prompt'] == this._text)
				password = false;
			return password;
		}
		
		/**
		 * @private
		 */
		protected function _getPassWordTxt(txt:String):String
		{
			var len:int = txt.length;
			var word:String;
			word = "";
			for (var j:int = len; j > 0; j--) {
				word += "●";
			}
			return word;
		}
		
		/**
		 * 渲染文字。
		 * @param	begin 开始渲染的行索引。
		 * @param	visibleLineCount 渲染的行数。
		 */
		protected function renderText(begin:int, visibleLineCount:int):void {
			var graphics:Graphics = this.graphics;
			graphics.clear(true);
			var ctxFont:String = (italic ? "italic " : "") + (bold ? "bold " : "") + fontSize + "px " + (Browser.onIPhone ? (Text._fontFamilyMap[font] || font) : font);
			Browser.context.font = ctxFont;
			
			//处理垂直对齐
			var padding:Array = this.padding;
			var startX:Number = padding[3];
			var textAlgin:String = "left";
			var lines:Array = _lines;
			var lineHeight:Number = leading + _charSize.height;
			var tCurrBitmapFont:BitmapFont = _currBitmapFont;
			if (tCurrBitmapFont) {
				lineHeight = leading + tCurrBitmapFont.getMaxHeight();
			}
			var startY:Number = padding[0];
			
			//处理水平对齐
			if ((!tCurrBitmapFont) && this._width > 0 && _textWidth <= _width) {
				if (align == "right") {
					textAlgin = "right";
					startX = this._width - padding[1];
				} else if (align == "center") {
					textAlgin = "center";
					startX = this._width * 0.5 + padding[3] - padding[1];
				}
			}
			
			if (_height > 0) {
				var tempVAlign:String = (_textHeight > _height) ? "top" : valign;
				if (tempVAlign === "middle")
					startY = (_height - visibleLineCount * lineHeight) * 0.5 + padding[0] - padding[2];
				else if (tempVAlign === "bottom")
					startY = _height - visibleLineCount * lineHeight - padding[2];
			}
			
			var style:CSSStyle = _style as CSSStyle;
			//drawBg(style);
			if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize) {
				var bitmapScale:Number = tCurrBitmapFont.fontSize / fontSize;
			}
			
			//渲染
			if (_clipPoint) {
				graphics.save();
				if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize) {
					var tClipWidth:int;
					var tClipHeight:int;
					
					_width ? tClipWidth = (_width - padding[3] - padding[1]) : tClipWidth = _textWidth;
					_height ? tClipHeight = (_height - padding[0] - padding[2]) : tClipHeight = _textHeight;
					
					tClipWidth *= bitmapScale;
					tClipHeight *= bitmapScale;
					
					graphics.clipRect(padding[3], padding[0], tClipWidth, tClipHeight);
				} else {
					graphics.clipRect(padding[3], padding[0], _width ? (_width - padding[3] - padding[1]) : _textWidth, _height ? (_height - padding[0] - padding[2]) : _textHeight);
				}
			}
			
			var password:Boolean = style.password;
			// 输入框的prompt始终显示明文
			if (("prompt" in this) && this['prompt'] == this._text)
				password = false;
			
			var x:Number = 0, y:Number = 0;
			var end:int = Math.min(_lines.length, visibleLineCount + begin) || 1;
			for (var i:int = begin; i < end; i++) {
				var word:String = lines[i];
				var _word:*;
				if (password) {
					var len:int = word.length;
					word = "";
					for (var j:int = len; j > 0; j--) {
						word += "●";
					}
				}
				x = startX - (_clipPoint ? _clipPoint.x : 0);
				y = startY + lineHeight * i - (_clipPoint ? _clipPoint.y : 0);
				
				underline && drawUnderline(textAlgin, x, y, i);
				
				if (tCurrBitmapFont) {
					var tWidth:Number = width;
					if (tCurrBitmapFont.autoScaleSize) {
						tWidth = width * bitmapScale;
					}
					tCurrBitmapFont.drawText(word, this, x, y, align, tWidth);
				} else {
					if (Render.isWebGL) {
						_words || (_words = new Vector.<WordText>());
						_word = _words.length > (i - begin) ? _words[i - begin] : new WordText();
						_word.setText(word);
					} else {
						_word = word;
					}
					style.stroke ? graphics.fillBorderText(_word, x, y, ctxFont, color, style.strokeColor, style.stroke, textAlgin) : graphics.fillText(_word, x, y, ctxFont, color, textAlgin);
				}
			}
			if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize) {
				var tScale:Number = 1 / bitmapScale;
				this.scale(tScale, tScale);
			}
			
			if (_clipPoint)
				graphics.restore();
			
			_startX = startX;
			_startY = startY;
		}
		
		/**
		 * 绘制下划线
		 * @param	x 本行坐标
		 * @param	y 本行坐标
		 * @param	lineIndex 本行索引
		 */
		private function drawUnderline(align:String, x:Number, y:Number, lineIndex:int):void {
			var lineWidth:Number = _lineWidths[lineIndex];
			switch (align) {
			case 'center': 
				x -= lineWidth / 2;
				break;
			case 'right': 
				x -= lineWidth;
				break;
			case 'left': 
			default: 
				break;
			}
			
			y += _charSize.height;
			_graphics.drawLine(x, y, x + lineWidth, y, underlineColor || color, 1);
		}
		
		/**
		 * <p>排版文本。</p>
		 * <p>进行宽高计算，渲染、重绘文本。</p>
		 */
		public function typeset():void {
			this._isChanged = false;
			
			if (!this._text) {
				_clipPoint = null;
				_textWidth = _textHeight = 0;
				graphics.clear(true);
				return;
			}
			
			Browser.context.font = _getCSSStyle().font;
			
			_lines.length = 0;
			_lineWidths.length = 0;
			if (_isPassWordMode())//如果是password显示状态应该使用密码符号计算
			{
				parseLines(_getPassWordTxt(this._text));
			}else
			parseLines(this._text);
			
			evalTextSize();
			//启用Viewport
			if (checkEnabledViewportOrNot())
				_clipPoint || (this._clipPoint = new Point(0, 0));
			//否则禁用Viewport
			else
				_clipPoint = null;
			
			var lineCount:int = _lines.length;
			// overflow为scroll或visible时会截行
			if (overflow != VISIBLE) {
				var func:Function = overflow == HIDDEN ? Math.floor : Math.ceil;
				lineCount = Math.min(lineCount, func((height - padding[0] - padding[2]) / (leading + _charSize.height)));
			}
			
			var startLine:int = scrollY / (_charSize.height + leading) | 0;
			renderText(startLine, lineCount);
			repaint();
		}
		
		private function evalTextSize():void {
			var nw:Number, nh:Number;
			nw = Math.max.apply(this, _lineWidths);
			
			//计算textHeight
			if (_currBitmapFont)
				nh = _lines.length * (_currBitmapFont.getMaxHeight() + leading) + padding[0] + padding[2];
			else
				nh = _lines.length * (_charSize.height + leading) + padding[0] + padding[2];
			if (nw != _textWidth || nh != _textHeight) {
				_textWidth = nw;
				_textHeight = nh;
				if (!_width || !_height)
					conchModel && conchModel.size(_width || _textWidth, _height || _textHeight);
			}
		}
		
		private function checkEnabledViewportOrNot():Boolean {
			return overflow == SCROLL && ((_width > 0 && _textWidth > _width) || (_height > 0 && _textHeight > _height)); // 设置了宽高并且超出了
		}
		
		/**
		 * <p>快速更改显示文本。不进行排版计算，效率较高。</p>
		 * <p>如果只更改文字内容，不更改文字样式，建议使用此接口，能提高效率。</p>
		 * @param text 文本内容。
		 */
		public function changeText(text:String):void {
			if (_text !== text) {
				lang(text + "");
				if (this._graphics && this._graphics.replaceText(_text)) {
					//repaint();
				} else {
					typeset();
				}
			}
		}
		
		/**
		 * @private
		 * 分析文本换行。
		 */
		protected function parseLines(text:String):void {
			//自动换行和HIDDEN都需要计算换行位置或截断位置
			var needWordWrapOrTruncate:Boolean = wordWrap || this.overflow == HIDDEN;
			if (needWordWrapOrTruncate) {
				var wordWrapWidth:Number = getWordWrapWidth();
			}
			
			if (_currBitmapFont) {
				_charSize.width = _currBitmapFont.getMaxWidth();
				_charSize.height = _currBitmapFont.getMaxHeight();
			} else {
				var measureResult:* = Browser.context.measureText(_testWord);
				_charSize.width = measureResult.width;
				_charSize.height = (measureResult.height || fontSize);
			}
			
			var lines:Array = text.replace(/\r\n/g, "\n").split("\n");
			for (var i:int = 0, n:int = lines.length; i < n; i++) {
				var line:String = lines[i];
				// 开启了自动换行需要计算换行位置
				// overflow为hidden需要计算截断位置
				if (needWordWrapOrTruncate)
					parseLine(line, wordWrapWidth);
				else {
					_lineWidths.push(getTextWidth(line));
					_lines.push(line);
				}
			}
		}
		
		/**
		 * @private
		 * 解析行文本。
		 * @param	line 某行的文本。
		 * @param	wordWrapWidth 文本的显示宽度。
		 */
		protected function parseLine(line:String, wordWrapWidth:Number):void {
			var ctx:Context = Browser.context;
			
			var lines:Array = _lines;
			
			var maybeIndex:int = 0;
			var execResult:Array;
			var charsWidth:Number;
			var wordWidth:Number;
			var startIndex:int;
			
			charsWidth = getTextWidth(line);
			//优化1，如果一行小于宽度，则直接跳过遍历
			if (charsWidth <= wordWrapWidth) {
				lines.push(line);
				_lineWidths.push(charsWidth);
				return;
			}
			
			charsWidth = _charSize.width;
			//优化2，预算第几个字符会超出，减少遍历及字符宽度度量
			maybeIndex = Math.floor(wordWrapWidth / charsWidth);
			(maybeIndex == 0) && (maybeIndex = 1);
			charsWidth = getTextWidth(line.substring(0, maybeIndex));
			wordWidth = charsWidth;
			for (var j:int = maybeIndex, m:int = line.length; j < m; j++) {
				// 逐字符测量后加入到总宽度中，在某些情况下自动换行不准确。
				// 目前已知在全是字符1的自动换行就会出现这种情况。
				// 考虑性能，保留这种非方式。
				charsWidth = getTextWidth(line.charAt(j));
				wordWidth += charsWidth;
				if (wordWidth > wordWrapWidth) {
					if (this.wordWrap) {
						//截断换行单词
						var newLine:String = line.substring(startIndex, j);
						if (newLine.charCodeAt(newLine.length - 1) < 255) {
							//按照英文单词字边界截取 因此将会无视中文
							execResult = /(?:\w|-)+$/.exec(newLine);
							if (execResult) {
								j = execResult.index + startIndex;
								//此行只够容纳这一个单词 强制换行
								if (execResult.index == 0)
									j += newLine.length;
								//此行有多个单词 按单词分行
								else
									newLine = line.substring(startIndex, j);
							}
						}else
						if (RightToLeft)
						{
							execResult =/([\u0600-\u06FF])+$/.exec(newLine);
							if(execResult)
							{
								j = execResult.index + startIndex;
									//此行只够容纳这一个单词 强制换行
									if (execResult.index == 0)
										j += newLine.length;
									//此行有多个单词 按单词分行
									else
										newLine = line.substring(startIndex, j);
							}
						}
						
						//如果自动换行，则另起一行
						lines.push(newLine);
						_lineWidths.push(wordWidth - charsWidth);
						//如果非自动换行，则只截取字符串
						
						startIndex = j;
						if (j + maybeIndex < m) {
							j += maybeIndex;
							
							charsWidth = getTextWidth(line.substring(startIndex, j));
							wordWidth = charsWidth;
							j--;
						} else {
							//此处执行将不会在循环结束后再push一次
							lines.push(line.substring(startIndex, m));
							_lineWidths.push(getTextWidth(lines[lines.length - 1]));
							startIndex = -1;
							break;
						}
					} else if (this.overflow == HIDDEN) {
						lines.push(line.substring(0, j));
						_lineWidths.push(getTextWidth(lines[lines.length - 1]));
						return;
					}
				}
			}
			if (wordWrap && startIndex != -1) {
				lines.push(line.substring(startIndex, m));
				_lineWidths.push(getTextWidth(lines[lines.length - 1]));
			}
		}
		
		private function getTextWidth(text:String):Number {
			if (_currBitmapFont)
				return _currBitmapFont.getTextWidth(text);
			else
				return Browser.context.measureText(text).width;
		}
		
		/**
		 * 获取换行所需的宽度。
		 */
		private function getWordWrapWidth():Number {
			var p:Array = padding;
			var w:Number;
			if (_currBitmapFont && _currBitmapFont.autoScaleSize)
				w = this._width * (_currBitmapFont.fontSize / fontSize);
			else
				w = this._width;
			
			if (w <= 0) {
				w = wordWrap ? 100 : Browser.width;
			}
			w <= 0 && (w = 100);
			return w - p[3] - p[1];
		}
		
		/**
		 * 返回字符在本类实例的父坐标系下的坐标。
		 * @param charIndex	索引位置。
		 * @param out		（可选）输出的Point引用。
		 * @return Point 字符在本类实例的父坐标系下的坐标。如果out参数不为空，则将结果赋值给指定的Point对象，否则创建一个新的Point对象返回。建议使用Point.TEMP作为out参数，可以省去Point对象创建和垃圾回收的开销，尤其是在需要频繁执行的逻辑中，比如帧循环和MOUSE_MOVE事件回调函数里面。
		 */
		public function getCharPoint(charIndex:int, out:Point = null):Point {
			_isChanged && Laya.timer.runCallLater(this, typeset);
			var len:int = 0, lines:Array = _lines, startIndex:int = 0;
			for (var i:int = 0, n:int = lines.length; i < n; i++) {
				len += lines[i].length;
				if (charIndex < len) {
					var line:int = i;
					break;
				}
				startIndex = len;
			}
			//计算字符的宽度
			var ctxFont:String = (italic ? "italic " : "") + (bold ? "bold " : "") + fontSize + "px " + font;
			Browser.context.font = ctxFont;
			var width:Number = getTextWidth(_text.substring(startIndex, charIndex));
			var point:Point = out || new Point();
			return point.setTo(_startX + width - (_clipPoint ? _clipPoint.x : 0), _startY + line * (_charSize.height + leading) - (_clipPoint ? _clipPoint.y : 0));
		}
		
		/**
		 * <p>设置横向滚动量。</p>
		 * <p>即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。</p>
		 */
		public function set scrollX(value:Number):void {
			if (overflow != SCROLL || (textWidth < _width || !_clipPoint))
				return;
			
			value = value < padding[3] ? padding[3] : value;
			var maxScrollX:int = _textWidth - _width;
			value = value > maxScrollX ? maxScrollX : value;
			
			var visibleLineCount:int = _height / (_charSize.height + leading) | 0 + 1;
			this._clipPoint.x = value;
			renderText(_lastVisibleLineIndex, visibleLineCount);
		}
		
		/**
		 * 获取横向滚动量。
		 */
		public function get scrollX():Number {
			if (!this._clipPoint)
				return 0;
			return this._clipPoint.x;
		}
		
		/**
		 * 设置纵向滚动量（px)。即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。
		 */
		public function set scrollY(value:Number):void {
			if (overflow != SCROLL || (textHeight < _height || !_clipPoint))
				return;
			
			value = value < padding[0] ? padding[0] : value;
			var maxScrollY:int = _textHeight - _height;
			value = value > maxScrollY ? maxScrollY : value;
			
			var startLine:int = value / (_charSize.height + leading) | 0;
			
			_lastVisibleLineIndex = startLine;
			var visibleLineCount:int = (_height / (_charSize.height + leading) | 0) + 1;
			_clipPoint.y = value;
			renderText(startLine, visibleLineCount);
		}
		
		/**
		 * 获取纵向滚动量。
		 */
		public function get scrollY():Number {
			if (!_clipPoint)
				return 0;
			return _clipPoint.y;
		}
		
		/**
		 * 获取横向可滚动最大值。
		 */
		public function get maxScrollX():int {
			return (textWidth < _width) ? 0 : _textWidth - _width;
		}
		
		/**
		 * 获取纵向可滚动最大值。
		 */
		public function get maxScrollY():int {
			return (textHeight < _height) ? 0 : _textHeight - _height;
		}
		
		public function get lines():Array {
			if (_isChanged)
				typeset();
			
			return _lines;
		}
		
		public function get underlineColor():String {
			return _underlineColor;
		}
		
		public function set underlineColor(value:String):void {
			_underlineColor = value;
			_isChanged = true;
			typeset();
		}
		
		/**
		 * 判断系统是否支持指定的font。
		 * 
		 * @param	font	对font进行支持测试
		 * @return	true表示系统支持
		 */
		public static function supportFont(font:String):Boolean
		{
			Browser.context.font = "10px sans-serif";
			var defaultFontWidth:Number = Browser.context.measureText("abcji").width;
			Browser.context.font = "10px " + font;
			var customFontWidth:Number = Browser.context.measureText("abcji").width;
			
			console.log(defaultFontWidth, customFontWidth);
			if (defaultFontWidth === customFontWidth) return false;
			else return true;
		}
	}
}
