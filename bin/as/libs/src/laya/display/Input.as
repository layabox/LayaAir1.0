package laya.display {
	import laya.events.Event;
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
	 *
	 * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
	 * <listing version="3.0">
	 * package
	 * {
	 * 	import laya.display.Input;
	 * 	import laya.events.Event;
	 * 	public class Input_Example
	 * 	{
	 * 		private var input:Input;
	 * 		public function Input_Example()
	 * 		{
	 * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 * 			onInit();
	 * 		}
	 * 		private function onInit():void
	 * 		{
	 * 			input = new Input();//创建一个 Input 类的实例对象 input 。
	 * 			input.text = "这个是一个 Input 文本示例。";
	 * 			input.color = "#008fff";//设置 input 的文本颜色。
	 * 			input.font = "Arial";//设置 input 的文本字体。
	 * 			input.bold = true;//设置 input 的文本显示为粗体。
	 * 			input.fontSize = 30;//设置 input 的字体大小。
	 * 			input.wordWrap = true;//设置 input 的文本自动换行。
	 * 			input.x = 100;//设置 input 对象的属性 x 的值，用于控制 input 对象的显示位置。
	 * 			input.y = 100;//设置 input 对象的属性 y 的值，用于控制 input 对象的显示位置。
	 * 			input.width = 300;//设置 input 的宽度。
	 * 			input.height = 200;//设置 input 的高度。
	 * 			input.italic = true;//设置 input 的文本显示为斜体。
	 * 			input.borderColor = "#fff000";//设置 input 的文本边框颜色。
	 * 			Laya.stage.addChild(input);//将 input 添加到显示列表。
	 * 			input.on(Event.FOCUS, this, onFocus);//给 input 对象添加获得焦点事件侦听。
	 * 			input.on(Event.BLUR, this, onBlur);//给 input 对象添加失去焦点事件侦听。
	 * 			input.on(Event.INPUT, this, onInput);//给 input 对象添加输入字符事件侦听。
	 * 			input.on(Event.ENTER, this, onEnter);//给 input 对象添加敲回车键事件侦听。
	 * 		}
	 * 		private function onFocus():void
	 * 		{
	 * 			trace("输入框 input 获得焦点。");
	 * 		}
	 * 		private function onBlur():void
	 * 		{
	 * 			trace("输入框 input 失去焦点。");
	 * 		}
	 * 		private function onInput():void
	 * 		{
	 * 			trace("用户在输入框 input 输入字符。文本内容：", input.text);
	 * 		}
	 * 		private function onEnter():void
	 * 		{
	 * 			trace("用户在输入框 input 内敲回车键。");
	 * 		}
	 * 	}
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * var input;
	 * Input_Example();
	 * function Input_Example()
	 * {
	 *     Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *     Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *     onInit();
	 * }
	 * function onInit()
	 * {
	 *     input = new laya.display.Input();//创建一个 Input 类的实例对象 input 。
	 *     input.text = "这个是一个 Input 文本示例。";
	 *     input.color = "#008fff";//设置 input 的文本颜色。
	 *     input.font = "Arial";//设置 input 的文本字体。
	 *     input.bold = true;//设置 input 的文本显示为粗体。
	 *     input.fontSize = 30;//设置 input 的字体大小。
	 *     input.wordWrap = true;//设置 input 的文本自动换行。
	 *     input.x = 100;//设置 input 对象的属性 x 的值，用于控制 input 对象的显示位置。
	 *     input.y = 100;//设置 input 对象的属性 y 的值，用于控制 input 对象的显示位置。
	 *     input.width = 300;//设置 input 的宽度。
	 *     input.height = 200;//设置 input 的高度。
	 *     input.italic = true;//设置 input 的文本显示为斜体。
	 *     input.borderColor = "#fff000";//设置 input 的文本边框颜色。
	 *     Laya.stage.addChild(input);//将 input 添加到显示列表。
	 *     input.on(laya.events.Event.FOCUS, this, onFocus);//给 input 对象添加获得焦点事件侦听。
	 *     input.on(laya.events.Event.BLUR, this, onBlur);//给 input 对象添加失去焦点事件侦听。
	 *     input.on(laya.events.Event.INPUT, this, onInput);//给 input 对象添加输入字符事件侦听。
	 *     input.on(laya.events.Event.ENTER, this, onEnter);//给 input 对象添加敲回车键事件侦听。
	 * }
	 * function onFocus()
	 * {
	 *     console.log("输入框 input 获得焦点。");
	 * }
	 * function onBlur()
	 * {
	 *     console.log("输入框 input 失去焦点。");
	 * }
	 * function onInput()
	 * {
	 *     console.log("用户在输入框 input 输入字符。文本内容：", input.text);
	 * }
	 * function onEnter()
	 * {
	 *     console.log("用户在输入框 input 内敲回车键。");
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import Input = laya.display.Input;
	 * class Input_Example {
	 *     private input: Input;
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         this.onInit();
	 *     }
	 *     private onInit(): void {
	 *         this.input = new Input();//创建一个 Input 类的实例对象 input 。
	 *         this.input.text = "这个是一个 Input 文本示例。";
	 *         this.input.color = "#008fff";//设置 input 的文本颜色。
	 *         this.input.font = "Arial";//设置 input 的文本字体。
	 *         this.input.bold = true;//设置 input 的文本显示为粗体。
	 *         this.input.fontSize = 30;//设置 input 的字体大小。
	 *         this.input.wordWrap = true;//设置 input 的文本自动换行。
	 *         this.input.x = 100;//设置 input 对象的属性 x 的值，用于控制 input 对象的显示位置。
	 *         this.input.y = 100;//设置 input 对象的属性 y 的值，用于控制 input 对象的显示位置。
	 *         this.input.width = 300;//设置 input 的宽度。
	 *         this.input.height = 200;//设置 input 的高度。
	 *         this.input.italic = true;//设置 input 的文本显示为斜体。
	 *         this.input.borderColor = "#fff000";//设置 input 的文本边框颜色。
	 *         Laya.stage.addChild(this.input);//将 input 添加到显示列表。
	 *         this.input.on(laya.events.Event.FOCUS, this, this.onFocus);//给 input 对象添加获得焦点事件侦听。
	 *         this.input.on(laya.events.Event.BLUR, this, this.onBlur);//给 input 对象添加失去焦点事件侦听。
	 *         this.input.on(laya.events.Event.INPUT, this, this.onInput);//给 input 对象添加输入字符事件侦听。
	 *         this.input.on(laya.events.Event.ENTER, this, this.onEnter);//给 input 对象添加敲回车键事件侦听。
	 *     }
	 *     private onFocus(): void {
	 *         console.log("输入框 input 获得焦点。");
	 *     }
	 *     private onBlur(): void {
	 *         console.log("输入框 input 失去焦点。");
	 *     }
	 *     private onInput(): void {
	 *         console.log("用户在输入框 input 输入字符。文本内容：", this.input.text);
	 *     }
	 *     private onEnter(): void {
	 *         console.log("用户在输入框 input 内敲回车键。");
	 *     }
	 * }
	 * </listing>
	 */
	public class Input extends Text {
		/**@private */
		private static var inherentStyle:String = /*[STATIC SAFE]*/ "position:absolute;resize:none;z-index:999;transform-origin:0 0;-webkit-transform-origin:0 0;-moz-transform-origin:0 0;-o-transform-origin:0 0;";
		/**@private */
		private static var pcStyle:String = /*[STATIC SAFE]*/ "background-color:transparent;border:none;outline:none;font-family:SimHei;";
		/**@private */
		private static var mobileStyle:String = /*[STATIC SAFE]*/ "font-size:20px;" + "width:100%;" + "border:1px solid rgb(30,30,30);" + "outline:none;";
		
		/**@private */
		protected static var input:*;
		/**@private */
		protected static var area:*;
		/**@private */
		protected static var promptSpan:*;
		/**@private */
		protected static var inputElement:*;
		/**@private */
		protected static var inputContainer:*;
		
		/**@private */
		protected var _focus:Boolean;
		/**@private */
		protected var _multiline:Boolean = false;
		/**@private */
		protected var _editable:Boolean = true;
		/**@private */
		protected var _restrictPattern:RegExp;
		/**@private */
		protected var _maxChars:int = 1E5;
		
		/**原生输入框 X 轴调整值，用来调整输入框坐标。*/
		public var inputElementXAdjuster:int = 0;
		/**原生输入框 Y 轴调整值，用来调整输入框坐标。*/
		public var inputElementYAdjuster:int = 0;
		/**移动平台输入期间的提示符。*/
		public var prompt:String = '';
		
		/**@private */
		private static const inputHeight:int = 40;
		/**@private */
		private static const textAreaHeight:int = 100;
		
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
			Browser.onMobile && _writeInputAniStyle();
			_createInputElement();
			
			// 移动端通过画布的touchend调用focus
			if (Browser.onMobile) {
				Render.canvas.addEventListener("touchend", function():void {
					// 只有 非Mac移动设备的QQ浏览器有效。
					if (Input.isInputting && !(Browser.onIPhone || Browser.onIPad)) {
						var input:* = Input.input.parentElement ? Input.input : Input.area;
						input.focus();
					}
				});
			}
		}
		
		/**
		 * <p>获取活动的输入框。</p>
		 * @internal 调度 <code>focus</code> 事件之后会设置输入框的位置等信息,在移动平台使用。
		 */
		private static function _getActiveInput():* {
			if (Browser.container.contains(input))
				return input;
			else if (Browser.container.contains(area))
				return area;
			return null;
		}
		
		/**@private */
		private static function _createInputElement():void {
			_initInput(area = Browser.createElement("textarea"));
			_initInput(input = Browser.createElement("input"));
			
			inputContainer = Browser.createElement("div");
			inputContainer.appendChild(input);
			inputContainer.appendChild(area);
			inputContainer.style.position = "absolute";
			
			if (Browser.onMobile) {
				// 移动平台输入框动画样式
				var animationStyle:String = "animation:input-ani 0.3s;" + "-moz-animation:input-ani 0.3s;" + "-webkit-animation:input-ani 0.3s;" + "-o-animation:input-ani 0.3s;" + "animation-fill-mode:forwards;" + "-moz-animation-fill-mode:forwards;" + "-webkit-animation-fill-mode:forwards;" + "-o-animation-fill-mode:forwards;";
				var style:* = inputContainer.style;
				inputContainer.style.cssText = animationStyle;
				// style.background = "#000000";
				
				// 移动平台输入框上方的提示符
				promptSpan = Browser.createElement("span");
				style = promptSpan.style;
				style.position = "absolute";
				style.color = "#FFFFFF";
				style.font = "20px simHei";
				style.backgroundColor = "#000000";
				style.width = "100%";
				style.lineHeight = "30px";
				inputContainer.appendChild(promptSpan);
			}
		}
		
		/**@private */
		private static function _writeInputAniStyle():void {
			var aniStyle:String = "{ from {} to { top:0px; }}";
			var mobStyleNode:* = Browser.document.createElement("style");
			mobStyleNode.innerHTML = "@keyframes input-ani" + aniStyle;
			mobStyleNode.innerHTML += "@-webkit-keyframes input-ani" + aniStyle;
			mobStyleNode.innerHTML += "@-moz-keyframes input-ani" + aniStyle;
			mobStyleNode.innerHTML += "@-o-keyframes input-ani" + aniStyle;
			Browser.document.getElementsByTagName("head")[0].appendChild(mobStyleNode);
		}
		
		/**
		 * @private
		 * @param	input 输入框的引用实例。
		 */
		private static function _initInput(input:*):void {
			input.style.cssText = _getCorretStyle();
			
			input.addEventListener('input', function(e:*):void {
				var target:* = input.target;
				if (!target)
					return;
				
				var value:String = input.value;
				
				// 对输入字符进行限制
				if (target._restrictPattern) {
					value = value.replace(target._restrictPattern, "");
					input.value = value;
				}
				
				target._text = value;
				
				target.event(Event.INPUT);
			});
			
			input.addEventListener('mousemove', _stopEvent);
			input.addEventListener('mousedown', _stopEvent);
			input.addEventListener('touchmove', _stopEvent);
		}
		
		/**@private */
		private static function _stopEvent(e:*):void {
			e.stopPropagation();
		}
		
		/**@private
		 * 样式在PC和Mobile两端不同。
		 */
		private static function _getCorretStyle():String {
			return inherentStyle + (Browser.onMobile ? mobileStyle : pcStyle)
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
		private function _onUnDisplay(e:Event):void {
			focus = false;
		}
		
		/**@private */
		private function _onMouseDown(e:Event):void {
			focus = true;
			Browser.document.addEventListener(Browser.onPC ? "mousedown" : "touchstart", Input._checkBlur);
		}
		
		/**@private */
		private static function _checkBlur(e:*):void {
			// 点击输入框之外的地方会终止输入。
			if (e.target != Input.input && e.target != Input.area) {
				Input.inputElement.target.focus = false;
			}
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
			
			var a:Number = stage._canvasTransform.a, d:Number = stage._canvasTransform.d;
			inputContainer.style.left = (rec.x + padding[3] + inputElementXAdjuster) * stage.clientScaleX * a + stage.offset.x + "px";
			inputContainer.style.top = (rec.y + padding[0] + inputElementYAdjuster) * stage.clientScaleY * d + stage.offset.y + "px";
			
			var inputWid:int = _width - padding[1] - padding[3];
			var inputHei:int = _height - padding[0] - padding[2];
			style.width = inputWid + "px";
			style.height = inputHei + "px";
			
			//不可见
			if (!_getVisible()) focus = false;
			
			if (stage.transform || rec.width != 1 || rec.height != 1 || a != 1 || d != 1) {
				var ts:String = "scale(" + stage.clientScaleX * a * rec.width + "," + stage.clientScaleY * d * rec.height + ")";
				if (ts != style.transform)
					style.transform = ts;
			}
		}
		
		/**@private */
		private function _getVisible():Boolean {
			var target:* = this;
			while (target) {
				if (target.visible === false) return false;
				target = target.parent;
			}
			return true;
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
				Input.isInputting = value;
				
				if (value) {
					input.target && (input.target.focus = false);
					input.target = this;
					
					_setInputMethod();
					Browser.container.appendChild(inputContainer);
					
					_focusIn();
				} else {
					input.target = null;
					
					_focusOut();
					Browser.container.removeChild(inputContainer);
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
			var input:* = nativeInput;
			this._focus = true;
			
			var cssStyle:* = input.style;
			cssStyle.cssText = _getCorretStyle();
			cssStyle.whiteSpace = (wordWrap ? "pre-wrap" : "nowrap");
			
			input.readOnly = !this._editable;
			input.maxLength = this._maxChars;
			
			var padding:Array = this.padding;
			
			input.value = _text;
			input.type = asPassword ? "password" : "text";
			
			Laya.stage.off(Event.KEY_DOWN, this, _onKeyDown);
			Laya.stage.on(Event.KEY_DOWN, this, _onKeyDown);
			Laya.stage.focus = this;
			event(Event.FOCUS);
			
			if (Browser.onPC) {
				// PC端直接调用focus进入焦点。
				input.focus();
				
				// PC浏览器隐藏文字
				var temp:String = _text;
				this._text = "";
				typeset();
				
				// PC同步输入框外观。
				cssStyle.color = color;
				cssStyle.fontSize = fontSize + "px";
				cssStyle.fontFamily = font;
				cssStyle.lineHeight = (leading + fontSize) + "px";
				cssStyle.fontStyle = (italic ? "italic" : "normal");
				cssStyle.fontWeight = (bold ? "bold" : "normal");
				cssStyle.textAlign = align;
				
				// 输入框重定位。
				_syncInputTransform();
				Laya.timer.frameLoop(1, this, _syncInputTransform);
			} else {
				promptSpan.innerText = prompt;
				
				var inputContainerStyle:* = inputContainer.style;
				// 决定输入框高度
				var hei:int = (this._multiline ? textAreaHeight : inputHeight);
				cssStyle.height = hei + "px";
				// 是否有prompt
				cssStyle.top = (this.prompt ? 30 : 0) + "px";
				// 动画开始前的位置
				inputContainerStyle.top = -hei + "px";
			}
		}
		
		/**@private */
		private function _focusOut():void {
			this._focus = false;
			
			this._text = '';
			super.text = inputElement.value;
			
			Laya.stage.off(Event.KEY_DOWN, this, _onKeyDown);
			Laya.stage.focus = null;
			event(Event.BLUR);
			
			// 只有PC会注册此事件。
			Browser.onPC && Laya.timer.clear(this, _syncInputTransform);
			
			Browser.document.removeEventListener(Browser.onPC ? "mousedown" : "touchstart", Input._checkBlur);
		}
		
		/**@private */
		private function _removeNeedlessInputMethod():void {
			var body:* = Browser.container;
			if (!this._multiline && body.contains(input) && body.contains(area))
				body.removeChild(input);
			else if (this._multiline && body.contains(area) && body.contains(input))
				body.removeChild(area);
		}
		
		/**@private */
		private function _onKeyDown(e:Event):void {
			if (e.keyCode === 13) event(Event.ENTER);
		}
		
		/**@inheritDoc */
		override public function set text(value:String):void {
			if (this._focus) {
				nativeInput.value = value || '';
			}
			
			// 单行时不允许换行
			if (!this._multiline)
				value = value.replace(/\r\n|\n/g, '');
			
			super.text = value;
		}
		
		override public function get text():String {
			if (this._focus)
				return nativeInput.value;
			else
				return _text || "";
		}
		
		/**@inheritDoc */
		override public function set color(value:String):void {
			if (this._focus)
				nativeInput.style.color = value;
			super.color = value;
		}
		
		/**限制输入的字符。*/
		public function get restrict():String {
			return _restrictPattern ? _restrictPattern.source : "";
		}
		
		public function set restrict(pattern:String):void {
			if (pattern) {
				pattern = "[^" + pattern + "]";
				
				// 如果pattern为^\00-\FF，则我们需要的正则是\00-\FF
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
	}
}
