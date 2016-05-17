package laya.display {
	import laya.events.Event;
	import laya.maths.Rectangle;
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
	 *
	 * 	public class Input_Example
	 * 	{
	 * 		private var input:Input;
	 * 		public function Input_Example()
	 * 		{
	 * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 * 			onInit();
	 * 		}
	 *
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
	 *
	 * 		private function onFocus():void
	 * 		{
	 * 			trace("输入框 input 获得焦点。");
	 * 		}
	 *
	 * 		private function onBlur():void
	 * 		{
	 * 			trace("输入框 input 失去焦点。");
	 * 		}
	 *
	 * 		private function onInput():void
	 * 		{
	 * 			trace("用户在输入框 input 输入字符。文本内容：", input.text);
	 * 		}
	 *
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
		private static var cssStyle:String =/*[STATIC SAFE]*/ "position:absolute;background-color:transparent;border:none;outline:none;resize:none;overflow:hidden;z-index:999";
		
		/**@private */
		protected static var input:*;
		/**@private */
		protected static var area:*;
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
		/**移动平台输入期间的标题。*/
		public var title:String = '';
		/**移动平台进入焦点时是否清空文字。*/
		public var clearOnFocus:Boolean = false;
		
		/**@private */
		private static const inputHeight:int = 50;
		/**@private */
		private static const textAreaHeight:int = 75;
		/**@private */
		private static var inputFontSize:int = 25;
		
		/**
		 * 边框样式。
		 */
		public static var borderStyle:String = "3px solid orange";
		/**
		 * 背景样式。
		 */
		public static var backgroundStyle:String = "Linen";
		/**
		 * 表示是否处于输入状态。
		 */
		public static var isInputting:Boolean = false;
		
		/**
		 * <p>获取活动的输入框。</p>
		 * @internal 调度 <code>focus</code> 事件之后会设置输入框的位置等信息,在移动平台使用。
		 */
		private static function getActiveInput():* {
			if (Browser.document.body.contains(input))
				return input;
			else if (Browser.document.body.contains(area))
				return area;
			return null;
		}
		
		/**
		 * 创建一个新的 <code>Input</code> 类实例。
		 */
		public function Input() {
			_width = 100;
			_height = 20;
			
			multiline = false;
			overflow = Text.SCROLL;
			
			on(Event.MOUSE_DOWN, this, onMouseDown);
			on(Event.UNDISPLAY, this, onUnDisplay);
		}
		
		/**表示是否是多行输入框。*/
		public function get multiline():Boolean {
			return _multiline;
		}
		
		public function set multiline(value:Boolean):void {
			_multiline = value;
			valign = value ? "top" : "middle";
			
			if (!Browser.onMobile) {
				if (value) {
					area || initInput(area = Browser.createElement("textarea"));
				} else {
					input || initInput(input = Browser.createElement("input"));
				}
			}
		}
		
		/**
		 * 获取对输入框的引用实例。
		 */
		public function get nativeInput():* {
			return _multiline ? area : input;
		}
		
		/**
		 * @private
		 * @param	input 输入框的引用实例。
		 */
		private static function initInput(input:*):void {
			var style:* = input.style;
			style.cssText = cssStyle;
			input.setAttribute("class", "laya");
			
			input.addEventListener('input', function(e:*):void {
				var target:* = input.target;
				if (!target)
					return;
				
				var value:String = input.value;
				
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
		
		private static function _stopEvent(e:*):void {
			e.stopPropagation();
		}
		
		/**@private */
		private function onStageDown(e:Event):void {
			if (e.target == this)
				return;
			if (e.target is Input) {
				focusOut();
				removeNeedlessInputMethod();
			} else
				focus = false;
			
			Laya.stage.off(Event.MOUSE_DOWN, this, onStageDown);
		}
		
		/**@private */
		private function onUnDisplay(e:Event):void {
			focus = false;
		}
		
		/**@private */
		private function onMouseDown(e:Event):void {
			focus = true;
			
			if (!Browser.onMobile)
				Laya.stage.on(Event.MOUSE_DOWN, this, onStageDown);
		}
		
		/**@inheritDoc	 */
		override public function render(context:RenderContext, x:Number, y:Number):void {
			super.render(context, x, y);
		}
		
		/**
		 * 在输入期间，如果 Input 实例的位置改变，调用该方法同步输入框的位置。
		 */
		private function syncInputPosition():void {
			var style:* = nativeInput.style;
			var stage:Stage = Laya.stage;
			var rec:Rectangle;
			rec = Utils.getGlobalPosAndScale(this);
			
			var a:Number = stage._canvasTransform.a, d:Number = stage._canvasTransform.d;
			style.left = (rec.x + padding[3] + inputElementXAdjuster) * stage.clientScaleX * a + stage.offset.x + "px";
			style.top = (rec.y + padding[0] + inputElementYAdjuster) * stage.clientScaleY * d + stage.offset.y + "px";
			
			//不可见
			if (!_getVisible()) focus = false;
			
			//场景缩放 手机浏览器不触发
			if (stage.transform || rec.width != 1 || rec.height != 1) {
				var ts:String = "scale(" + stage.clientScaleX * a * rec.width + "," + stage.clientScaleY * d * rec.height + ")";
				if (ts != style.transform) {
					style.transformOrigin = "0 0";
					style.transform = ts;
				}
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
		
		/**
		 * 表示焦点是否在显示对象上。
		 */
		public function get focus():Boolean {
			return _focus;
		}
		
		/**选中所有文本。*/
		public function select():void {
			nativeInput.select();
		}
		
		// 移动平台最后单击画布才会调用focus
		// 因此 调用focus接口是无法都在移动平台立刻弹出键盘的
		public function set focus(value:Boolean):void {
			if (Browser.onMobile) {
				if (value && this._editable) {
					var str:String = Browser.window.prompt(clearOnFocus ? '' : (title, this._text || ''));
					if (str != null) {
						if (this._restrictPattern)
							str = str.replace(this._restrictPattern, '');
						this.text = str;
						event(Event.INPUT);
						event(Event.BLUR);
					}
				}
				return;
			}
			
			var input:* = nativeInput;
			
			if (_focus !== value) {
				Input.isInputting = value;
				
				if (value) {
					input.target && (input.target.focus = false);
					input.target = this;
					Browser.document.body.appendChild(input);
					focusIn();
				} else {
					input.target = null;
					
					focusOut();
					Browser.document.body.removeChild(input);
				}
			}
		}
		
		private function focusIn():void {
			var input:* = nativeInput;
			this._focus = true;
			
			var cssText:String = cssStyle;
			cssText += ";white-space:" + (wordWrap ? "pre-wrap" : "pre");
			
			input.readOnly = !this._editable;
			input.maxLength = this._maxChars;
			
			var padding:Array = this.padding;
			
			var inputWid:int = _width - padding[1] - padding[3];
			var inputHei:int = _height - padding[0] - padding[2];
			cssText += ";width:" + inputWid + "px";
			cssText += ";height:" + inputHei + "px";
			cssText += ";color:" + color;
			cssText += ";font-size:" + fontSize + "px";
			cssText += ";font-family:" + font;
			cssText += ";line-height:" + (leading + fontSize) + "px";
			cssText += ";font-style:" + (italic ? "italic" : "normal");
			cssText += ";font-weight:" + (bold ? "bold" : "normal");
			cssText += ";text-align:" + align;
			
			// PC浏览器隐藏文字
			var temp:String = _text;
			input.value = temp;
			this._text = "";
			typeset();
			this._text = temp;
			
			input.style.cssText = cssText;
			input.type = asPassword ? "password" : "text";
			
			input.focus();
			
			Laya.stage.off(Event.KEY_DOWN, this, onKeyDown);
			Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
			Laya.stage.focus = this;
			event(Event.FOCUS);
			
			syncInputPosition();
			Laya.timer.frameLoop(1, this, syncInputPosition);
		}
		
		private function focusOut():void {
			this._focus = false;
			
			var temp:String = this._text || "";
			this._text = "";
			super.text = temp;
			
			Laya.stage.off(Event.KEY_DOWN, this, onKeyDown);
			Laya.stage.focus = null;
			event(Event.BLUR);
			
			Browser.document.body.scrollTop = 0;
			
			Laya.timer.clear(this, syncInputPosition);
		}
		
		private function removeNeedlessInputMethod():void {
			var body:* = Browser.document.body;
			if (!this._multiline && body.contains(input) && body.contains(area))
				Browser.document.body.removeChild(input);
			else if (this._multiline && body.contains(area) && body.contains(input))
				Browser.document.body.removeChild(area);
		}
		
		/**@private */
		private function onKeyDown(e:Event):void {
			if (e.keyCode === 13) event(Event.ENTER);
		}
		
		/**@inheritDoc */
		override public function set text(value:String):void {
			if (this._focus) {
				nativeInput.value = value || '';
			}
			super.text = value;
		}
		
		override public function get text():String {
			if (this._focus)
				return nativeInput.value;
			else
				return _text;
		}
		
		/**@inheritDoc */
		override public function set color(value:String):void {
			if (this._focus)
				nativeInput.style.color = value;
			super.color = value;
		}
		
		/**限制输入的字符。*/
		public function get restrict():String {
			return _restrictPattern.source;
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