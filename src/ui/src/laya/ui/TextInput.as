package laya.ui {
	import laya.display.Input;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.ui.AutoBitmap;
	import laya.ui.Styles;
	import laya.ui.UIUtils;
	
	/**
	 * 输入文本后调度。
	 * @eventType Event.INPUT
	 */
	[Event(name = "input", type = "laya.events.Event")]
	/**
	 * 在输入框内敲回车键后调度。
	 * @eventType Event.ENTER
	 */
	[Event(name = "enter", type = "laya.events.Event")]
	/**
	 * 当获得输入焦点后调度。
	 * @eventType Event.FOCUS
	 */
	[Event(name = "focus", type = "laya.events.Event")]
	/**
	 * 当失去输入焦点后调度。
	 * @eventType Event.BLUR
	 */
	[Event(name = "blur", type = "laya.events.Event")]
	
	/**
	 * <code>TextInput</code> 类用于创建显示对象以显示和输入文本。
	 *
	 * @example 以下示例代码，创建了一个 <code>TextInput</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.display.Stage;
	 *		import laya.ui.TextInput;
	 *		import laya.utils.Handler;
	 *		public class TextInput_Example
	 *		{
	 *			public function TextInput_Example()
	 *			{
	 *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				Laya.loader.load(["resource/ui/input.png"], Handler.create(this, onLoadComplete));//加载资源。
	 *			}
	 *			private function onLoadComplete():void
	 *			{
	 *				var textInput:TextInput = new TextInput("这是一个TextInput实例。");//创建一个 TextInput 类的实例对象 textInput 。
	 *				textInput.skin = "resource/ui/input.png";//设置 textInput 的皮肤。
	 *				textInput.sizeGrid = "4,4,4,4";//设置 textInput 的网格信息。
	 *				textInput.color = "#008fff";//设置 textInput 的文本颜色。
	 *				textInput.font = "Arial";//设置 textInput 的文本字体。
	 *				textInput.bold = true;//设置 textInput 的文本显示为粗体。
	 *				textInput.fontSize = 30;//设置 textInput 的字体大小。
	 *				textInput.wordWrap = true;//设置 textInput 的文本自动换行。
	 *				textInput.x = 100;//设置 textInput 对象的属性 x 的值，用于控制 textInput 对象的显示位置。
	 *				textInput.y = 100;//设置 textInput 对象的属性 y 的值，用于控制 textInput 对象的显示位置。
	 *				textInput.width = 300;//设置 textInput 的宽度。
	 *				textInput.height = 200;//设置 textInput 的高度。
	 *				Laya.stage.addChild(textInput);//将 textInput 添加到显示列表。
	 *			}
	 *		}
	 *	}
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
	 * Laya.loader.load(["resource/ui/input.png"], laya.utils.Handler.create(this, onLoadComplete));//加载资源。
	 * function onLoadComplete() {
	 *     var textInput = new laya.ui.TextInput("这是一个TextInput实例。");//创建一个 TextInput 类的实例对象 textInput 。
	 *     textInput.skin = "resource/ui/input.png";//设置 textInput 的皮肤。
	 *     textInput.sizeGrid = "4,4,4,4";//设置 textInput 的网格信息。
	 *     textInput.color = "#008fff";//设置 textInput 的文本颜色。
	 *     textInput.font = "Arial";//设置 textInput 的文本字体。
	 *     textInput.bold = true;//设置 textInput 的文本显示为粗体。
	 *     textInput.fontSize = 30;//设置 textInput 的字体大小。
	 *     textInput.wordWrap = true;//设置 textInput 的文本自动换行。
	 *     textInput.x = 100;//设置 textInput 对象的属性 x 的值，用于控制 textInput 对象的显示位置。
	 *     textInput.y = 100;//设置 textInput 对象的属性 y 的值，用于控制 textInput 对象的显示位置。
	 *     textInput.width = 300;//设置 textInput 的宽度。
	 *     textInput.height = 200;//设置 textInput 的高度。
	 *     Laya.stage.addChild(textInput);//将 textInput 添加到显示列表。
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import Stage = laya.display.Stage;
	 * import TextInput = laya.ui.TextInput;
	 * import Handler = laya.utils.Handler;
	 * class TextInput_Example {
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load(["resource/ui/input.png"], Handler.create(this, this.onLoadComplete));//加载资源。
	 *     }
	 *     private onLoadComplete(): void {
	 *         var textInput: TextInput = new TextInput("这是一个TextInput实例。");//创建一个 TextInput 类的实例对象 textInput 。
	 *         textInput.skin = "resource/ui/input.png";//设置 textInput 的皮肤。
	 *         textInput.sizeGrid = "4,4,4,4";//设置 textInput 的网格信息。
	 *         textInput.color = "#008fff";//设置 textInput 的文本颜色。
	 *         textInput.font = "Arial";//设置 textInput 的文本字体。
	 *         textInput.bold = true;//设置 textInput 的文本显示为粗体。
	 *         textInput.fontSize = 30;//设置 textInput 的字体大小。
	 *         textInput.wordWrap = true;//设置 textInput 的文本自动换行。
	 *         textInput.x = 100;//设置 textInput 对象的属性 x 的值，用于控制 textInput 对象的显示位置。
	 *         textInput.y = 100;//设置 textInput 对象的属性 y 的值，用于控制 textInput 对象的显示位置。
	 *         textInput.width = 300;//设置 textInput 的宽度。
	 *         textInput.height = 200;//设置 textInput 的高度。
	 *         Laya.stage.addChild(textInput);//将 textInput 添加到显示列表。
	 *     }
	 * }
	 * </listing>
	 */
	public class TextInput extends Label {
		/** @private */
		protected var _bg:AutoBitmap;
		/** @private */
		protected var _skin:String;
		
		/**
		 * 创建一个新的 <code>TextInput</code> 类实例。
		 * @param text 文本内容。
		 */
		public function TextInput(text:String = "") {
			this.text = text;
			this.skin = skin;
		}
		
		/**@inheritDoc */
		override protected function preinitialize():void {
			mouseEnabled = true;
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_bg && _bg.destroy();
			_bg = null;
		}
		
		/**@inheritDoc */
		override protected function createChildren():void {
			addChild(_tf = new Input());
			_tf.padding = Styles.inputLabelPadding;
			_tf.on(Event.INPUT, this, _onInput);
			_tf.on(Event.ENTER, this, _onEnter);
			_tf.on(Event.BLUR, this, _onBlur);
			_tf.on(Event.FOCUS, this, _onFocus);
		}
		
		/**
		 * @private
		 */
		private function _onFocus():void {
			event(Event.FOCUS, this);
		}
		
		/**
		 * @private
		 */
		private function _onBlur():void {
			event(Event.BLUR, this);
		}
		
		/**
		 * @private
		 */
		private function _onInput():void {
			event(Event.INPUT, this);
		}
		
		/**
		 * @private
		 */
		private function _onEnter():void {
			event(Event.ENTER, this);
		}
		
		/**@inheritDoc */
		override protected function initialize():void {
			width = 128;
			height = 22;
		}
		
		/**
		 * 表示此对象包含的文本背景 <code>AutoBitmap</code> 组件实例。
		 */
		public function get bg():AutoBitmap {
			return _bg;
		}
		
		public function set bg(value:AutoBitmap):void {
			graphics = _bg = value;
		}
		
		/**
		 * @copy laya.ui.Image#skin
		 */
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				_bg || (graphics = _bg = new AutoBitmap());
				_bg.source = Loader.getRes(_skin);
				_width && (_bg.width = _width);
				_height && (_bg.height = _height);
			}
		}
		
		/**
		 * <p>当前实例的背景图（ <code>AutoBitmap</code> ）实例的有效缩放网格数据。</p>
		 * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		 * <ul><li>例如："4,4,4,4,1"</li></ul></p>
		 * @see laya.ui.AutoBitmap.sizeGrid
		 */
		public function get sizeGrid():String {
			return _bg && _bg.sizeGrid ? _bg.sizeGrid.join(",") : null;
		}
		
		public function set sizeGrid(value:String):void {
			_bg || (graphics = _bg = new AutoBitmap());
			_bg.sizeGrid = UIUtils.fillArray(Styles.defaultSizeGrid, value, Number);
		}
		
		/**@inheritDoc */
		override public function set width(value:Number):void {
			super.width = value;
			_bg && (_bg.width = value);
		}
		
		/**@inheritDoc */
		override public function set height(value:Number):void {
			super.height = value;
			_bg && (_bg.height = value);
		}
		
		/**
		 * <p>指示当前是否是文本域。</p>
		 * 值为true表示当前是文本域，否则不是文本域。
		 */
		public function get multiline():Boolean {
			return (_tf as Input).multiline;
		}
		
		public function set multiline(value:Boolean):void {
			Input(_tf).multiline = value;
		}
		
		/**
		 * 设置可编辑状态。
		 */
		public function set editable(value:Boolean):void {
			Input(_tf).editable = value;
		}
		
		public function get editable():Boolean {
			return Input(_tf).editable;
		}
		
		/**
		 * 设置原生input输入框的x坐标偏移。
		 */
		public function set inputElementXAdjuster(value:int):void {
			Input(_tf).inputElementXAdjuster = value;
		}
		
		public function get inputElementXAdjuster():int {
			return Input(_tf).inputElementXAdjuster;
		}
		
		/**
		 * 设置原生input输入框的y坐标偏移。
		 */
		public function set inputElementYAdjuster(value:int):void {
			Input(_tf).inputElementYAdjuster = value;
		}
		
		public function get inputElementYAdjuster():int {
			return Input(_tf).inputElementYAdjuster;
		}
		
		/**选中输入框内的文本。*/
		public function select():void {
			(_tf as Input).select();
		}
		
		/**限制输入的字符。*/
		public function get restrict():String {
			return Input(_tf).restrict;
		}
		
		public function set restrict(pattern:String):void {
			Input(_tf).restrict = pattern;
		}
		
		/**
		 * @copy laya.display.Input#prompt
		 */
		public function get prompt():String {
			return Input(_tf).prompt;
		}
		
		public function set prompt(value:String):void {
			Input(_tf).prompt = value;
		}
		
		/**
		 * @copy laya.display.Input#promptColor
		 */
		public function get promptColor():String
		{
			return Input(_tf).promptColor;
		}
		
		public function set promptColor(value:String):void
		{
			Input(_tf).promptColor = value;
		}
		
		/**
		 * @copy laya.display.Input#maxChars
		 */
		public function get maxChars():int {
			return Input(_tf).maxChars;
		}
		
		public function set maxChars(value:int):void {
			Input(_tf).maxChars = value;
		}
		
		/**
		 * @copy laya.display.Input#focus
		 */
		public function get focus():Boolean {
			return Input(_tf).focus;
		}
		
		public function set focus(value:Boolean):void {
			Input(_tf).focus = value;
		}
		
		/**
		 * @copy laya.display.Input#type
		 */
		public function get type():String
		{
			return Input(_tf).type;
		}
		
		public function set type(value:String):void
		{
			Input(_tf).type = value;
		}
		
		/**
		 * @copy laya.display.Input#asPassword
		 */
		public function get asPassword():Boolean
		{
			return Input(_tf).asPassword;
		}
		
		public function set asPassword(value:Boolean):void
		{
			Input(_tf).asPassword = value;
		}
		
		public function setSelection(startIndex:int, endIndex:int):void
		{
			Input(_tf).setSelection(startIndex, endIndex);
		}
	}
}