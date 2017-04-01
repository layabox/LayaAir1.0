package laya.display {
	import laya.events.Event;
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.utils.Browser;
	import laya.utils.Utils;
	
	/**
	 * 用户输入一个或多个文本字符时后调度。
	 * @eventType Event.INPUT
	 * */
	[Event(name = "input", type = "laya.events.Event")]
	/**
	 * 用户在输入框内敲回车键后，将会调度 <code>enter</code> 事件。
	 * @eventType Event.ENTER
	 * */
	[Event(name = "enter", type = "laya.events.Event")]
	/**
	 * 显示对象获得焦点后调度。
	 * @eventType Event.FOCUS
	 * */
	[Event(name = "focus", type = "laya.events.Event")]
	/**
	 * 显示对象失去焦点后调度。
	 * @eventType Event.BLUR
	 * */
	[Event(name = "blur", type = "laya.events.Event")]
	
	/**
	 * <p><code>Input</code> 类用于创建显示对象以显示和输入文本。</p>
	 */
	public class Input extends Text {
		/** 常规文本域。*/
		static public const TYPE_TEXT:String = "text";
		/** password 类型用于密码域输入。*/
		static public const TYPE_PASSWORD:String = "password";
		/** email 类型用于应该包含 e-mail 地址的输入域。*/
		public static const TYPE_EMAIL:String = "email";
		/** url 类型用于应该包含 URL 地址的输入域。*/
		public static const TYPE_URL:String = "url";
		/** number 类型用于应该包含数值的输入域。*/
		public static const TYPE_NUMBER:String = "number";
		/**
		 * range 类型用于应该包含一定范围内数字值的输入域。
		 * range 类型显示为滑动条。
		 * 您还能够设定对所接受的数字的限定：
		 */
		public static const TYPE_RANGE:String = "range";
		/**  选取日、月、年。*/
		public static const TYPE_DATE:String = "date";
		/** month - 选取月、年。*/
		public static const TYPE_MONTH:String = "month";
		/** week - 选取周和年。*/
		public static const TYPE_WEEK:String = "week";
		/** time - 选取时间（小时和分钟）。*/
		public static const TYPE_TIME:String = "time";
		/** datetime - 选取时间、日、月、年（UTC 时间）。*/
		public static const TYPE_DATE_TIME:String = "datetime";
		/** datetime-local - 选取时间、日、月、年（本地时间）。*/
		public static const TYPE_DATE_TIME_LOCAL:String = "datetime-local";
		/**
		 * search 类型用于搜索域，比如站点搜索或 Google 搜索。
		 * search 域显示为常规的文本域。
		 */
		public static const TYPE_SEARCH:String = "search";
		
		/**@private */
		protected static var input:*;
		/**@private */
		protected static var area:*;
		/**@private */
		protected static var inputElement:*;
		/**@private */
		protected static var inputContainer:*;
		/**@private */
		protected static var confirmButton:*;
		/**@private */
		protected static var promptStyleDOM:*;
		
		/**@private */
		protected var _focus:Boolean;
		/**@private */
		protected var _multiline:Boolean = false;
		/**@private */
		protected var _editable:Boolean = true;
		/**@private */
		protected var _restrictPattern:Object;
		/**@private */
		protected var _maxChars:int = 1E5;
		
		private var _type:String = "text";
		
		/**输入提示符。*/
		private var _prompt:String = '';
		/**输入提示符颜色。*/
		private var _promptColor:String = "#A9A9A9";
		private var _originColor:String = "#000000";
		private var _content:String = '';
		
		/**@private */
		public static const IOS_IFRAME:Boolean = (Browser.onIOS && Browser.window.top != Browser.window.self);
		private static const inputHeight:int = 45;
		
		/**表示是否处于输入状态。*/
		public static var isInputting:Boolean = false;
		
		/**创建一个新的 <code>Input</code> 类实例。*/
		public function Input() {
			_width = 100;
			_height = 20;
			
			multiline = false;
			overflow = Text.SCROLL;
			
			on(Event.MOUSE_DOWN, this, _onMouseDown);
			on(Event.UNDISPLAY, this, _onUnDisplay);
		}
		
		/**@private */
		public static function __init__():void {
			_createInputElement();
			
			// 移动端通过画布的touchend调用focus
			if (Browser.onMobile)
				Render.canvas.addEventListener(IOS_IFRAME ? "click" : "touchend", _popupInputMethod);
		}
		
		// 移动平台在单击事件触发后弹出输入法
		private static function _popupInputMethod(e:*):void {
			//e.preventDefault();
			if (!Input.isInputting) return;
			
			var input:* = Input.inputElement;
			
			// 弹出输入法。
			input.focus();
		}
		
		/**@private */
		private static function _createInputElement():void {
			_initInput(area = Browser.createElement("textarea"));
			_initInput(input = Browser.createElement("input"));
			
			inputContainer = Browser.createElement("div");
			inputContainer.style.position = "absolute";
			inputContainer.style.zIndex = 1E5;
			Browser.container.appendChild(inputContainer);
			//[IF-SCRIPT] inputContainer.setPos = function(x:int, y:int):void { inputContainer.style.left = x + 'px'; inputContainer.style.top = y + 'px'; };
		}
		
		/**
		 * @private
		 * @param	input 输入框的引用实例。
		 */
		private static function _initInput(input:*):void {
			var style:* = input.style;
			style.cssText = "position:absolute;overflow:hidden;resize:none;transform-origin:0 0;-webkit-transform-origin:0 0;-moz-transform-origin:0 0;-o-transform-origin:0 0;";
			style.resize = 'none';
			style.backgroundColor = 'transparent';
			style.border = 'none';
			style.outline = 'none';
			style.zIndex = 1;
			
			input.addEventListener('input', _processInputting);
			
			input.addEventListener('mousemove', _stopEvent);
			input.addEventListener('mousedown', _stopEvent);
			input.addEventListener('touchmove', _stopEvent);
		
		/*[IF-SCRIPT-BEGIN]
		   if(!Render.isConchApp)
		   {
		   input.setColor = function(color:String):void { input.style.color = color; };
		   input.setFontSize = function(fontSize:int):void { input.style.fontSize = fontSize + 'px'; };
		   input.setSize = function(w:int, h:int):void { input.style.width = w + 'px'; input.style.height = h + 'px'; };
		   }
		   input.setFontFace = function(fontFace:String):void { input.style.fontFamily = fontFace; };
		   [IF-SCRIPT-END]*/
		}
		
		private static function _processInputting(e:*):void {
			var input:Input = Input.inputElement.target;
			if (!input) return;
			
			var value:String = Input.inputElement.value;
			
			// 对输入字符进行限制
			if (input._restrictPattern) {
				// 部分输入法兼容
				value = value.replace(/\u2006|\x27/g, "");
				
				if (input._restrictPattern.test(value)) {
					value = value.replace(input._restrictPattern, "");
					Input.inputElement.value = value;
				}
			}
			
			input._text = value;
			input.event(Event.INPUT);
		}
		
		/**@private */
		private static function _stopEvent(e:*):void {
			if (e.type == 'touchmove')
				e.preventDefault();
			e.stopPropagation && e.stopPropagation();
		}
		
		/**
		 * 设置光标位置和选取字符。
		 * @param	startIndex	光标起始位置。
		 * @param	endIndex	光标结束位置。
		 */
		public function setSelection(startIndex:int, endIndex:int):void {
			Input.inputElement.selectionStart = startIndex;
			Input.inputElement.selectionEnd = endIndex;
		}
		
		/**表示是否是多行输入框。*/
		public function get multiline():Boolean {
			return _multiline;
		}
		
		public function set multiline(value:Boolean):void {
			_multiline = value;
			valign = value ? "top" : "middle";
		}
		
		/**
		 * 获取对输入框的引用实例。
		 */
		public function get nativeInput():* {
			return _multiline ? area : input;
		}
		
		/**@private */
		private function _onUnDisplay(e:Event = null):void {
			focus = false;
		}
		
		/**@private */
		private function _onMouseDown(e:Event):void {
			focus = true;
			Laya.stage.on(Event.MOUSE_DOWN, this, _checkBlur);
		}
		
		/**@private */
		private function _checkBlur(e:*):void {
			// 点击输入框之外的地方会终止输入。
			if (e.nativeEvent.target != Input.input && e.nativeEvent.target != Input.area && e.target != this)
				focus = false;
		}
		
		/**@inheritDoc*/
		override public function render(context:RenderContext, x:Number, y:Number):void {
			super.render(context, x, y);
		}
		
		/**
		 * 在输入期间，如果 Input 实例的位置改变，调用该方法同步输入框的位置。
		 */
		private function _syncInputTransform():void {
			var style:* = nativeInput.style;
			var stage:Stage = Laya.stage;
			var rec:Rectangle;
			rec = Utils.getGlobalPosAndScale(this);
			
			var m:Matrix = stage._canvasTransform.clone();
			
			var tm:Matrix = m.clone();
			tm.rotate(-Math.PI / 180 * Laya.stage.canvasDegree);
			tm.scale(Laya.stage.clientScaleX, Laya.stage.clientScaleY);
			
			var perpendicular:Boolean = (Laya.stage.canvasDegree % 180 != 0);
			var sx:Number = perpendicular ? tm.d : tm.a;
			var sy:Number = perpendicular ? tm.a : tm.d;
			tm.destroy();
			
			var tx:Number = padding[3];
			var ty:Number = padding[0];
			if (Laya.stage.canvasDegree == 0) {
				tx += rec.x;
				ty += rec.y;
				
				tx *= sx;
				ty *= sy;
				
				tx += m.tx;
				ty += m.ty;
			} else if (Laya.stage.canvasDegree == 90) 	// screenMode = horizontal
			{
				tx += rec.y;
				ty += rec.x;
				
				tx *= sx;
				ty *= sy;
				
				tx = m.tx - tx;
				ty += m.ty;
			} else // canvasDegree == -90 screenMode = vertical
			{
				tx += rec.y;
				ty += rec.x;
				
				tx *= sx;
				ty *= sy;
				
				tx += m.tx;
				ty = m.ty - ty;
			}
			
			// 当前渲染节点的全局旋转弧度。
			const quarter:Number = 0.785;
			var r:Number = Math.atan2(rec.height, rec.width) - quarter;
			// 反向旋转。
			var sin:Number = Math.sin(r), cos:Number = Math.cos(r);
			// 计算节点缩放。
			var tsx:Number = cos * rec.width + sin * rec.height;
			var tsy:Number = cos * rec.height - sin * rec.width;
			sx *= (perpendicular ? tsy : tsx);
			sy *= (perpendicular ? tsx : tsy);
			
			m.tx = 0;
			m.ty = 0;
			
			r *= 180 / 3.1415;
			//[IF-SCRIPT]inputContainer.style.transform = "scale(" + sx + "," + sy + ") rotate(" + (Laya.stage.canvasDegree + r) + "deg)";
			//[IF-SCRIPT]inputContainer.style.webkitTransform = "scale(" + sx + "," + sy + ") rotate(" + (Laya.stage.canvasDegree + r) + "deg)";
			inputContainer.setPos(tx, ty);
			m.destroy();
			
			var inputWid:int = _width - padding[1] - padding[3];
			var inputHei:int = _height - padding[0] - padding[2];
			nativeInput.setSize(inputWid, inputHei);
			
			if (Render.isConchApp) {
				nativeInput.setPos(tx, ty);
				nativeInput.setScale(sx, sy);
			}
		}
		
		/**选中所有文本。*/
		public function select():void {
			nativeInput.select();
		}
		
		/**
		 * 表示焦点是否在显示对象上。
		 */
		public function get focus():Boolean {
			return _focus;
		}
		
		// 移动平台最后单击画布才会调用focus
		// 因此 调用focus接口是无法都在移动平台立刻弹出键盘的
		public function set focus(value:Boolean):void {
			var input:* = nativeInput;
			
			if (_focus !== value) {
				if (value) {
					input.target && (input.target.focus = false);
					input.target = this;
					
					_setInputMethod();
					
					_focusIn();
				} else {
					input.target = null;
					_focusOut();
					input.blur();
					
					if (Render.isConchApp) {
						input.setPos(-10000, -10000);
					} else if (inputContainer.contains(input))
						inputContainer.removeChild(input);
				}
			}
		}
		
		/**@private 设置输入法（textarea或input）*/
		private function _setInputMethod():void {
			input.parentElement && (inputContainer.removeChild(input));
			area.parentElement && (inputContainer.removeChild(area));
			
			inputElement = (_multiline ? area : input);
			inputContainer.appendChild(inputElement);
		}
		
		/**@private */
		private function _focusIn():void {
			Input.isInputting = true;
			var input:* = nativeInput;
			/*[IF-FLASH]*/
			input.setRestrict(_restrictPattern);
			
			this._focus = true;
			
			var cssStyle:* = input.style;
			cssStyle.whiteSpace = (wordWrap ? "pre-wrap" : "nowrap");
			_setPromptColor();
			
			input.readOnly = !this._editable;
			input.maxLength = this._maxChars;
			
			var padding:Array = this.padding;
			
			input.type = _type;
			input.value = _content;
			input.placeholder = _prompt;
			
			Laya.stage.off(Event.KEY_DOWN, this, _onKeyDown);
			Laya.stage.on(Event.KEY_DOWN, this, _onKeyDown);
			Laya.stage.focus = this;
			event(Event.FOCUS);
			
			// PC端直接调用focus进入焦点。
			if (Browser.onPC) input.focus();
			
			// PC浏览器隐藏文字
			var temp:String = _text;
			this._text = null;
			typeset();
			
			// PC同步输入框外观。
			input.setColor(_originColor);
			input.setFontSize(fontSize);
			input.setFontFace(font);
			if (Render.isConchApp) {
				input.setMultiAble && input.setMultiAble(_multiline);
			}
			cssStyle.lineHeight = (leading + fontSize) + "px";
			cssStyle.fontStyle = (italic ? "italic" : "normal");
			cssStyle.fontWeight = (bold ? "bold" : "normal");
			cssStyle.textAlign = align;
			cssStyle.padding = "0 0";
			
			// 输入框重定位。
			_syncInputTransform();
			if (!Render.isConchApp && Browser.onPC)
				Laya.timer.frameLoop(1, this, _syncInputTransform);
		}
		
		// 设置DOM输入框提示符颜色。
		private function _setPromptColor():void {
			// 创建style标签
			promptStyleDOM = Browser.getElementById("promptStyle");
			if (!promptStyleDOM) {
				promptStyleDOM = Browser.createElement("style");
				Browser.document.head.appendChild(promptStyleDOM);
			}
			
			// 设置style标签
			promptStyleDOM.innerText = "input::-webkit-input-placeholder, textarea::-webkit-input-placeholder {" + "color:" + _promptColor + "}" + "input:-moz-placeholder, textarea:-moz-placeholder {" + "color:" + _promptColor + "}" + "input::-moz-placeholder, textarea::-moz-placeholder {" + "color:" + _promptColor + "}" + "input:-ms-input-placeholder, textarea:-ms-input-placeholder {" + "color:" + _promptColor + "}";
		}
		
		/**@private */
		private function _focusOut():void {
			Input.isInputting = false;
			this._focus = false;
			
			this._text = null;
			_content = nativeInput.value;
			if (!_content) {
				super.text = _prompt;
				super.color = _promptColor;
			} else {
				super.text = _content;
				super.color = _originColor;
			}
			
			Laya.stage.off(Event.KEY_DOWN, this, _onKeyDown);
			Laya.stage.focus = null;
			event(Event.BLUR);
			if (Render.isConchApp) this.nativeInput.blur();
			// 只有PC会注册此事件。
			Browser.onPC && Laya.timer.clear(this, _syncInputTransform);
			Laya.stage.off(Event.MOUSE_DOWN, this, _checkBlur);
		}
		
		/**@private */
		private function _onKeyDown(e:*):void {
			if (e.keyCode === 13) {
				// 移动平台单行输入状态下点击回车收回输入法。 
				if (Browser.onMobile && !this._multiline)
					this.focus = false;
				
				event(Event.ENTER);
			}
		}
		
		/**@inheritDoc */
		override public function set text(value:String):void {
			super.color = _originColor;
			
			value += '';
			
			if (this._focus) {
				nativeInput.value = value || '';
				event(Event.CHANGE);
			} else {
				// 单行时不允许换行
				if (!this._multiline)
					value = value.replace(/\r?\n/g, '');
				
				_content = value;
				
				if (value)
					super.text = value;
				else {
					super.text = _prompt;
					super.color = promptColor;
				}
			}
		}
		
		override public function get text():String {
			if (this._focus)
				return nativeInput.value;
			else
				return _content || "";
		}
		
		override public function changeText(text:String):void {
			_content = text;
			
			if (this._focus) {
				nativeInput.value = text || '';
				event(Event.CHANGE);
			} else
				super.changeText(text);
		}
		
		/**@inheritDoc */
		override public function set color(value:String):void {
			if (this._focus)
				nativeInput.setColor(value);
			
			super.color = _content ? value : _promptColor;
			_originColor = value;
		}
		
		/**限制输入的字符。*/
		public function get restrict():String {
			if (_restrictPattern) {
				/*[IF-FLASH]*/
				return _restrictPattern as String;
				return _restrictPattern.source;
			}
			return "";
		}
		
		public function set restrict(pattern:String):void {
			// AS保存字符串
			/*[IF-FLASH-BEGIN]*/
			_restrictPattern = pattern;
			return;
			/*[IF-FLASH-END]*/
			
			// H5保存RegExp
			if (pattern) {
				pattern = "[^" + pattern + "]";
				
				// 如果pattern为^\00-\FF，则我们需要的正则表达式是\00-\FF
				if (pattern.indexOf("^^") > -1)
					pattern = pattern.replace("^^", "");
				
				_restrictPattern = new RegExp(pattern, "g");
			} else
				_restrictPattern = null;
		}
		
		/**
		 * 是否可编辑。
		 */
		public function set editable(value:Boolean):void {
			_editable = value;
		}
		
		public function get editable():Boolean {
			return _editable;
		}
		
		/**
		 * 字符数量限制，默认为10000。
		 * 设置字符数量限制时，小于等于0的值将会限制字符数量为10000。
		 */
		public function get maxChars():int {
			return _maxChars;
		}
		
		public function set maxChars(value:int):void {
			if (value <= 0)
				value = 1E5;
			_maxChars = value;
		}
		
		/**
		 * 设置输入提示符。
		 */
		public function get prompt():String {
			return _prompt;
		}
		
		public function set prompt(value:String):void {
			if (!_text && value)
				super.color = _promptColor;
			
			this.promptColor = _promptColor;
			
			if (_text)
				super.text = (_text == _prompt) ? value : _text;
			else
				super.text = value;
			
			_prompt = value;
		}
		
		/**
		 * 设置输入提示符颜色。
		 */
		public function get promptColor():String {
			return _promptColor;
		}
		
		public function set promptColor(value:String):void {
			_promptColor = value;
			if (!_content) super.color = value;
		}
		
		/**
		 * 输入框类型为Input静态常量之一。
		 * 平台兼容性参见http://www.w3school.com.cn/html5/html_5_form_input_types.asp。
		 */
		public function get type():String {
			return _type;
		}
		
		public function set type(value:String):void {
			if (value == "password")
				_getCSSStyle().password = true;
			else
				_getCSSStyle().password = false;
			_type = value;
		}
		
		/**原生输入框 X 轴调整值，用来调整输入框坐标。
		 * 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementXAdjuster已弃用。*/
		//[Deprecated]
		public function get inputElementXAdjuster():int {
			console.warn("deprecated: 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementXAdjuster已弃用。");
			return 0;
		}
		
		public function set inputElementXAdjuster(value:int):void {
			console.warn("deprecated: 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementXAdjuster已弃用。");
		}
		
		/**原生输入框 Y 轴调整值，用来调整输入框坐标。
		 * 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementYAdjuster已弃用。*/
		//[Deprecated]
		public function get inputElementYAdjuster():int {
			console.warn("deprecated: 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementYAdjuster已弃用。");
			return 0;
		}
		
		public function set inputElementYAdjuster(value:int):void {
			console.warn("deprecated: 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementYAdjuster已弃用。");
		}
		
		/**
		 * <p>本API已弃用。使用type="password"替代设置asPassword, asPassword将在下次重大更新时删去。</p>
		 * <p>指定文本字段是否是密码文本字段。</p>
		 * <p>如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。如果为 false，则不会将文本字段视为密码文本字段。</p>
		 * <p>默认值为false。</p>
		 */
		//[Deprecated(replacement="Input.type")]
		public function get asPassword():Boolean {
			return _getCSSStyle().password;
		}
		
		public function set asPassword(value:Boolean):void {
			_getCSSStyle().password = value;
			_type = Input.TYPE_PASSWORD;
			console.warn("deprecated: 使用type=\"password\"替代设置asPassword, asPassword将在下次重大更新时删去");
			isChanged = true;
		}
	}
}