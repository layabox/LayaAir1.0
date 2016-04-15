package laya.display {
	
	import laya.display.css.CSSStyle;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Browser;
	
	/**
	 * 文本内容发生改变后调度。
	 * @eventType Event.CHANGE
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Text</code> 类用于创建显示对象以显示文本。</p>
	 * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
	 * <p>[EXAMPLE-AS-BEGIN]</p>
	 * <listing version="3.0">
	 * package
	 * {
	 * 	import laya.display.Text;
	 *
	 * 	public class Text_Example
	 * 	{
	 * 		public function Text_Example()
	 * 		{
	 * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 * 			onInit();
	 * 		}
	 *
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
	 * </listing>
	 * <p>[EXAMPLE-AS-END]</p>
	 * <listing version="3.0">
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
	 * </listing>
	 * <listing version="3.0">
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
	 * </listing>
	 * @author yung
	 */
	public class Text extends Sprite {
		/**语言包*/
		public static var langPacks:Object;
		
		/**
		 * 位图字体字典
		 */
		private static var bitmapFonts:Object;
		/**
		 * @private
		 * 表示文本内容字符串。
		 */
		protected var _text:String;
		/**
		 * @private
		 * 表示文本内容是否发生改变。
		 *
		 */
		protected var _isChanged:Boolean;
		/**
		 * @private
		 * 表示文本的宽度，以像素为单位。
		 */
		protected var _textWidth:Number = 0;
		/**
		 * @private
		 * 表示文本的高度，以像素为单位。
		 */
		protected var _textHeight:Number = 0;
		/**
		 * @private
		 * 存储文字行数信息。
		 */
		protected var _lines:Array = [];
		
		/**
		 * @private
		 * 文本的内容位置X轴信息。
		 * @internal #TM
		 */
		protected var _startX:Number;
		
		/**
		 * @private
		 * 文本的内容位置X轴信息
		 * @internal #TM
		 */
		protected var _startY:Number;
		
		/**
		 * @private
		 * 当前可视行索引
		 */
		protected var _lastVisibleLineIndex:int = -1;
		
		/** @private */
		private var _clipPoint:Point;
		
		/**
		 * 当前使用的位置字体
		 */
		private var _currBitmapFont:BitmapFont;
		
		/**
		 * 创建一个新的 <code>Text</code> 实例。
		 */
		public function Text():void {
			_style = new CSSStyle(this);
			(_style as CSSStyle).wordWrap = false;
		}
		
		/**
		 * 注册位图字体
		 * @param	name		位图字体的名称
		 * @param	bitmapFont	位图字体文件
		 */
		public static function registerBitmapFont(name:String, bitmapFont:BitmapFont):void {
			bitmapFonts || (bitmapFonts = { });
			bitmapFonts[name] = bitmapFont;
		}
		
		/**
		 * 取消注册的位图字体文件
		 * @param	name		位图字体的名称
		 * @param	destory		是否销毁当前字体文件
		 */
		public static function unregisterBitmapFont(name:String, destory:Boolean = true):void {
			if (bitmapFonts && bitmapFonts[name]) {
				var tBitmapFont:BitmapFont = bitmapFonts[name];
				if (destory) {
					tBitmapFont.destory();
				}
				delete bitmapFonts[name];
			}
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_lines = null;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 *
		 */
		override public function _getBoundPointsM(ifRotate:Boolean = false):Array {
			// TODO Auto Generated method stub
			var rec:Rectangle = Rectangle.TEMP;
			rec.setTo(0, 0, width, height);
			return rec._getBoundPoints();
		}
		
		/**@inheritDoc */
		override public function getGraphicBounds():Rectangle {
			var rec:Rectangle = Rectangle.TEMP;
			rec.setTo(0, 0, width, height);
			return rec;
		}
		
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function get width():Number {
			if (_width) return _width;
			return textWidth;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			isChanged = true;
		}
		
		/**
		 * @private
		 * @inheritDoc
		 * */
		override public function _getCSSStyle():CSSStyle {
			return _style as CSSStyle;
		}
		
		/**
		 * @inheritDoc
		 * @return
		 *
		 */
		override public function get height():Number {
			if (_height) return _height;
			return textHeight;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			isChanged = true;
		}
		
		/**
		 * 表示文本的宽度，以像素为单位。
		 * @return
		 *
		 */
		public function get textWidth():Number {
			_isChanged && Laya.timer.runCallLater(this, typeset);
			return _textWidth;
		}
		
		/**
		 * 表示文本的高度，以像素为单位。
		 * @return
		 *
		 */
		public function get textHeight():Number {
			_isChanged && Laya.timer.runCallLater(this, typeset);
			return _textHeight;
		}
		
		/**当前文本的内容字符串。*/
		public function get text():String {
			return this._text;
		}
		
		public function set text(value:String):void {
			if (this._text !== value) {
				lang(value + "");
				isChanged = true;
				event(Event.CHANGE);
			}
		}
		
		/**
		 * 设置语言包
		 * @param	text	文本，可以增加参数，比如"abc{0}efg{1}ijk,123{2}"
		 * @param	...args	文本参数，比如"d","h",4
		 */
		public function lang(text:String, arg1:* = null, arg2:* = null, arg3:* = null, arg4:* = null, arg5:* = null, arg6:* = null, arg7:* = null, arg8:* = null, arg9:* = null, arg10:* = null):void {
			if (arguments.length < 2) {
				this._text = langPacks ? langPacks[text] : text;
			} else {
				for (var i:int = 0, n:int = arguments.length; i < n; i++) {
					text = text.replace("{" + i + "}", arguments[i + 1]);
				}
				this._text = text;
			}
		}
		
		/**
		 * 文本的字体名称，以字符串形式表示。
		 *
		 * <p>默认值为："Arial"，可以通过Text.defaultFont设置默认字体。</p>
		 *
		 * @see Text.defaultFont
		 * @return
		 *
		 */
		public function get font():String {
			return _getCSSStyle().fontFamily;
		}
		
		public function set font(value:String):void {
			if (_currBitmapFont) {
				_currBitmapFont = null;
				scale(1, 1);
			}
			if (bitmapFonts && bitmapFonts[value]) {
				_currBitmapFont = bitmapFonts[value];
			}
			_getCSSStyle().fontFamily = value;
			isChanged = true;
		}
		
		/**
		 * 指定文本的字体大小（以像素为单位）。
		 *
		 * <p>默认为20像素，可以通过 <code>Text.defaultSize</code> 设置默认大小。</p>
		 * @return
		 *
		 */
		public function get fontSize():int {
			return _getCSSStyle().fontSize;
		}
		
		public function set fontSize(value:int):void {
			_getCSSStyle().fontSize = value;
			isChanged = true;
		}
		
		/**
		 * 指定文本是否为粗体字。
		 *
		 * <p>默认值为 false，这意味着不使用粗体字。如果值为 true，则文本为粗体字。</p>
		 *
		 * @return
		 *
		 */
		public function get bold():Boolean {
			return _getCSSStyle().bold;
		}
		
		public function set bold(value:Boolean):void {
			_getCSSStyle().bold = value;
			isChanged = true;
		}
		
		/**
		 * 表示文本的颜色值。可以通过 <code>Text.defaultColor</code> 设置默认颜色。
		 * <p>默认值为黑色。</p>
		 * @return
		 *
		 */
		public function get color():String {
			return _getCSSStyle().color;
		}
		
		public function set color(value:String):void {
			_getCSSStyle().color = value;
			//如果仅仅更新颜色，无需重新排版
			if (!_isChanged && this._graphics) {
				this._graphics.replaceTextColor(color)
			} else {
				isChanged = true;
			}
		}
		
		/**
		 * 表示使用此文本格式的文本是否为斜体。
		 *
		 * <p>默认值为 false，这意味着不使用斜体。如果值为 true，则文本为斜体。</p>
		 * @return
		 *
		 */
		public function get italic():Boolean {
			return _getCSSStyle().italic;
		}
		
		public function set italic(value:Boolean):void {
			_getCSSStyle().italic = value;
			isChanged = true;
		}
		
		/**
		 * 表示文本的水平显示方式。
		 *
		 * <p><b>取值：</b>
		 * <li>"left"： 居左对齐显示。</li>
		 * <li>"center"： 居中对齐显示。</li>
		 * <li>"right"： 居右对齐显示。</li>
		 * </p>
		 * @return
		 *
		 */
		public function get align():String {
			return _getCSSStyle().align;
		}
		
		public function set align(value:String):void {
			_getCSSStyle().align = value;
			isChanged = true;
		}
		
		/**
		 * 表示文本的垂直显示方式。
		 *
		 * <p><b>取值：</b>
		 * <li>"top"： 居顶部对齐显示。</li>
		 * <li>"middle"： 居中对齐显示。</li>
		 * <li>"bottom"： 居底部对齐显示。</li>
		 * </p>
		 * @return
		 *
		 */
		public function get valign():String {
			return _getCSSStyle().valign;
		}
		
		public function set valign(value:String):void {
			_getCSSStyle().valign = value;
			isChanged = true;
		}
		
		/**
		 * 表示文本是否自动换行，默认为false。
		 *
		 * <p>若值为true，则自动换行；否则不自动换行。</p>
		 * @return
		 *
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
		 * @return
		 *
		 */
		public function get leading():Number {
			return _getCSSStyle().leading;
		}
		
		public function set leading(value:Number):void {
			_getCSSStyle().leading = value;
			isChanged = true;
		}
		
		/**
		 * 边距信息。
		 *
		 * <p>[上边距，右边距，下边距，左边距]（边距以像素为单位）。</p>
		 * @return
		 *
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
		 * @return
		 *
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
		 * @return
		 *
		 */
		public function get borderColor():String {
			return _getCSSStyle().borderColor;
		}
		
		public function set borderColor(value:String):void {
			_getCSSStyle().borderColor = value;
			isChanged = true;
		}
		
		/**
		 * <p>指定文本字段是否是密码文本字段。</p>
		 * <p>如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。如果为 false，则不会将文本字段视为密码文本字段。</p>
		 * <p>默认值为false。</p>
		 * @return
		 *
		 */
		public function get asPassword():Boolean {
			return _getCSSStyle().password;
		}
		
		public function set asPassword(value:Boolean):void {
			_getCSSStyle().password = value;
			isChanged = true;
		}
		
		/**
		 * <p>描边宽度（以像素为单位）。</p>
		 * 默认值0，表示不描边。
		 * @return
		 *
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
		 * 默认值为 "#000000"（黑色）;
		 * @return
		 *
		 */
		public function get strokeColor():String {
			return this._getCSSStyle().strokeColor;
		}
		
		public function set strokeColor(value:String):void {
			_getCSSStyle().strokeColor = value;
			isChanged = true;
		}
		
		/**
		 * 一个布尔值，表示文本的属性是否有改变。
		 * @param value 是否有改变。若为true表示有改变。
		 *
		 */
		protected function set isChanged(value:Boolean):void {
			if (this._isChanged !== value) {
				this._isChanged = value;
				value && Laya.timer.callLater(this, typeset);
			}
		}
		
		/**
		 * 渲染文字
		 * @param	begin				从begin行开始
		 * @param	visibleLineCount	渲染visibleLineCount行
		 */
		protected function renderTextAndBg(begin:int, visibleLineCount:int):void {
			var graphics:Graphics = this.graphics;
			graphics.clear();
			
			var ctxFont:String = (italic ? "italic " : "") + (bold ? "bold " : "") + fontSize + "px " + font;
			Browser.ctx.font = ctxFont;
			
			//处理垂直对齐
			var padding:Array = this.padding;
			var startX:Number = padding[3];
			var textAlgin:String = "left";
			var lines:Array = _lines;
			var lineHeight:Number = leading + fontSize;
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
				if (tempVAlign === "middle") startY = (_height - visibleLineCount * lineHeight) * 0.5 + padding[0] - padding[2];
				else if (tempVAlign === "bottom") startY = _height - visibleLineCount * lineHeight - padding[2];
			}
			
			var style:CSSStyle = _style as CSSStyle;
			//drawBg(style);
			if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize)
			{
				var bitmapScale:Number = tCurrBitmapFont.fontSize / fontSize;
			}
			
			//渲染
			if (_clipPoint) {
				// trace("[RENDER TEXT] 	Text Clip Enabled actualSize(" + _textWidth + ', ' + _textHeight + ') size(' + _width + ', ' + _height + ")");
				graphics.save();
				if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize)
				{
					var tClipWidth:int;
					var tClipHeight:int;
					
					_width ? tClipWidth = (_width - padding[3] - padding[1]) : tClipWidth = _textWidth;
					_height ? tClipHeight = (_height - padding[0] - padding[2]) :  tClipHeight = _textHeight;
					
					tClipWidth *= bitmapScale;
					tClipHeight *= bitmapScale;
					
					graphics.clipRect(padding[3], padding[0], tClipWidth, tClipHeight);
				}else {
					graphics.clipRect(padding[3], padding[0], _width ? (_width - padding[3] - padding[1]) : _textWidth, _height ? (_height - padding[0] - padding[2]) : _textHeight);
				}
			}
			
			var x:Number = 0, y:Number = 0;
			var end:int = Math.min(_lines.length, visibleLineCount + begin) || 1;
			for (var i:int = begin; i < end; i++) {
				var word:String = lines[i];
				if (style.password) {
					var len:int = word.length;
					word = "";
					for (var j:int = len; j > 0; j--) {
						word += "·";
					}
				}
				x = startX - (_clipPoint ? _clipPoint.x : 0);
				y = startY + lineHeight * i - (_clipPoint ? _clipPoint.y : 0);
				if (tCurrBitmapFont) {
					var tWidth:Number = width;
					if (tCurrBitmapFont.autoScaleSize)
					{
						tWidth = width * bitmapScale;;
					}
					tCurrBitmapFont.drawText(word, this, x, y, align, tWidth);
				} else {
					style.stroke ? graphics.fillBorderText(word, x, y, ctxFont, color, style.strokeColor, style.stroke, textAlgin) : graphics.fillText(word, x, y, ctxFont, color, textAlgin);
				}
			}
			if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize) {
				var tScale:Number = 1/bitmapScale;
				this.scale(tScale, tScale);
			}
			
			if (_clipPoint)
				graphics.restore();
			
			_startX = startX;
			_startY = startY;
		}
		
		//private function drawBg(style:CSSStyle):void {
		//if (style.backgroundColor || style.borderColor) {
		//trace("wwww",width, height);
		////graphics.drawRect(0, 0, width, height, (style.backgroundColor == "") ? null : style.backgroundColor, style.borderColor);
		//}
		//}
		
		/**
		 * <p>排版文本。</p>
		 * <p>进行宽高计算，渲染、重绘文本。</p>
		 */
		public function typeset():void {
			this._isChanged = false;
			
			if (!this._text) {
				_clipPoint = null;
				_textWidth = _textHeight = 0;
				graphics.clear();
				//drawBg(_style as CSSStyle);
				return;
			}
			
			Browser.ctx.font = _getCSSStyle().font;
			_lines = parseWordWrap(this._text);
			_textWidth = 0;
			//计算textWidth
			for (var n:int = 0, len:int = _lines.length; n < len; ++n) {
				var word:String = _lines[n];
				if (_currBitmapFont) {
					_textWidth = Math.max(_currBitmapFont.getTextWidth(word) + padding[3] + padding[1], _textWidth);
				} else {
					_textWidth = Math.max(Browser.ctx.measureText(word).width + padding[3] + padding[1], _textWidth);
				}
			}
			//计算textHeight
			if (_currBitmapFont) {
				_textHeight = _lines.length * (_currBitmapFont.getMaxHeight() + leading) + padding[0] + padding[2];
			} else _textHeight = _lines.length * (fontSize + leading) + padding[0] + padding[2];
			
			//启用Viewport
			if (checkEnabledViewportOrNot()) _clipPoint || (this._clipPoint = new Point(0, 0));
			//否则禁用Viewport
			else _clipPoint = null;
			renderTextAndBg(0, Math.min(_lines.length, Math.ceil((height - padding[0] - padding[2]) / (leading + fontSize))));
			
			repaint();
		}
		
		private function checkEnabledViewportOrNot():Boolean {
			return (_width > 0 && _textWidth > _width) || (_height > 0 && _textHeight > _height);	// 设置了宽高并且超出了
		}
		
		/**
		 * 快速更改显示文本。不进行排版计算，效率较高。
		 *
		 * <p>如果只更改文字内容，不更改文字样式，建议使用此接口，能提高效率。</p>
		 * @param text 文本内容。
		 *
		 */
		public function changeText(text:String):void {
			if (_text !== text) {
				lang(text);
				if (this._graphics && this._graphics.replaceText(text)) {
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
		protected function parseWordWrap(text:String):Array {
			var lines:Array = text.split(/\r|\n|\\n/);
			for (var i:int = 0, n:int = lines.length; i < n - 1; i++)
				lines[i] += "\n";//在换行处补上换行
			
			var width:Number = this._width;
			if (_currBitmapFont && _currBitmapFont.autoScaleSize)
			{
				width = this._width * (_currBitmapFont.fontSize / fontSize);
			}
			var ctx:Context = Browser.ctx;
			
			//获取长度，如果换行并且没有设置长度，则默认为100			
			var wordWrap:Boolean = this.wordWrap;
			if (wordWrap && width <= 0) width = 100;
			
			if (width <= 0 || !wordWrap)
				return lines;
			
			_lines.length = 0;
			var padding:Array = this.padding;
			var result:Array = _lines;
			var wordWrapWidth:Number = width - padding[3] - padding[1];
			var maybeIndex:int = 0;
			var execResult:Array;
			var tCurrBitmapFont:BitmapFont = _currBitmapFont;
			var tWidth:Number = 0;
			
			for (i = 0, n = lines.length; i < n; i++) {
				var word:String = lines[i];
				
				var wordWidth:Number = 0;
				var startIndex:int = 0;
				
				tCurrBitmapFont ? tWidth = tCurrBitmapFont.getTextWidth(word) : tWidth = ctx.measureText(word).width;
				//优化1，如果一行小于宽度，则直接跳过遍历	
				if (tWidth <= wordWrapWidth) {
					result.push(word);
					continue;
				}
				
				tCurrBitmapFont ? tWidth = tCurrBitmapFont.getMaxWidth() : tWidth = ctx.measureText("阳").width;
				//优化2，预算第几个字符会超出，减少遍历及字符宽度度量
				maybeIndex || (maybeIndex = Math.floor(wordWrapWidth / tWidth));
				(maybeIndex == 0) && (maybeIndex = 1);
				tCurrBitmapFont ? tWidth = _currBitmapFont.getTextWidth(word.substring(0, maybeIndex)) : tWidth = ctx.measureText(word.substring(0, maybeIndex)).width;
				wordWidth = tWidth;
				for (var j:int = maybeIndex, m:int = word.length; j < m; j++) {
					tCurrBitmapFont ? tWidth = _currBitmapFont.getCharWidth(word.charAt(j)) : tWidth = ctx.measureText(word.charAt(j)).width;
					wordWidth += tWidth;
					if (wordWidth > wordWrapWidth) {
						//截断换行单词
						var lineString:String = word.substring(startIndex, j);
						//按照英文单词字边界截取 因此将会无视中文
						execResult = /\b\w+$/.exec(lineString);
						if (execResult) {
							j = execResult.index + startIndex;
							//此行只够容纳这一个单词 强制换行
							if (execResult.index == 0) j += lineString.length;
							//此行有多个单词 按单词分行
							else lineString = word.substring(startIndex, j);
						}
						
						//如果自动换行，则另起一行
						result.push(lineString);
						//如果非自动换行，则只截取字符串
						startIndex = j;
						if (j + maybeIndex < m) {
							j += maybeIndex;
							
							tCurrBitmapFont ? tWidth = _currBitmapFont.getTextWidth(word.substring(startIndex, j)) : tWidth = ctx.measureText(word.substring(startIndex, j)).width;
							wordWidth = tWidth;
							j--;
						} else {
							//此处执行将不会在循环结束后再push一次
							result.push(word.substring(startIndex, m));
							startIndex = -1;
							break;
						}
					}
				}
				if (startIndex != -1) result.push(word.substring(startIndex, m));
			}
			return result;
		}
		
		/**
		 * 返回字符的位置信息。
		 * @param	charIndex 索引位置
		 * @param	out 输出的Point引用
		 * @return	返回Point位置信息
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
			Browser.ctx.font = ctxFont;
			var width:Number = Browser.ctx.measureText(_text.substring(startIndex, charIndex)).width;
			var point:Point = out || new Point();
			return point.setTo(_startX + width - (_clipPoint ? _clipPoint.x : 0), _startY + line * (fontSize + leading) - (_clipPoint ? _clipPoint.y : 0));
		}
		
		/**
		 * 设置横向滚动量。
		 * <p>即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。</p>
		 */
		public function set scrollX(value:Number):void {
			if (textWidth < _width || !_clipPoint) return;
			
			value = value < padding[3] ? padding[3] : value;
			var maxScrollX:int = _textWidth - _width;
			value = value > maxScrollX ? maxScrollX : value;
			
			var visibleLineCount:int = _height / (fontSize + leading) | 0 + 1;
			this._clipPoint.x = value;
			renderTextAndBg(_lastVisibleLineIndex, visibleLineCount);
		}
		
		/**
		 * 获取横向滚动量。
		 */
		public function get scrollX():Number {
			if (!this._clipPoint) return 0;
			return this._clipPoint.x;
		}
		
		/**
		 * 设置纵向滚动量（px)。即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。
		 */
		public function set scrollY(value:Number):void {
			if (textHeight < _height || !_clipPoint) return;
			
			value = value < padding[0] ? padding[0] : value;
			var maxScrollY:int = _textHeight - _height;
			value = value > maxScrollY ? maxScrollY : value;
			
			var startLine:int = value / (fontSize + leading) | 0;
			
			_lastVisibleLineIndex = startLine;
			var visibleLineCount:int = (_height / (fontSize + leading) | 0) + 1;
			_clipPoint.y = value;
			renderTextAndBg(startLine, visibleLineCount);
		}
		
		/**
		 * 获取纵向滚动量。
		 */
		public function get scrollY():Number {
			if (!_clipPoint) return 0;
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
	}
}