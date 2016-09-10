package laya.ui {
	import laya.display.css.Font;
	import laya.display.Text;
	import laya.events.Event;
	import laya.ui.Component;
	import laya.ui.UIUtils;
	
	/**
	 * 文本内容发生改变后调度。
	 * @eventType laya.events.Event
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Label</code> 类用于创建显示对象以显示文本。</p>
	 *
	 * @example 以下示例代码，创建了一个 <code>Label</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.ui.Label;
	 *		public class Label_Example
	 *		{
	 *			public function Label_Example()
	 *			{
	 *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				onInit();
	 *			}
	 *			private function onInit():void
	 *			{
	 *				var label:Label = new Label();//创建一个 Label 类的实例对象 label 。
	 *				label.font = "Arial";//设置 label 的字体。
	 *				label.bold = true;//设置 label 显示为粗体。
	 *				label.leading = 4;//设置 label 的行间距。
	 *				label.wordWrap = true;//设置 label 自动换行。
	 *				label.padding = "10,10,10,10";//设置 label 的边距。
	 *				label.color = "#ff00ff";//设置 label 的颜色。
	 *				label.text = "Hello everyone,我是一个可爱的文本！";//设置 label 的文本内容。
	 *				label.x = 100;//设置 label 对象的属性 x 的值，用于控制 label 对象的显示位置。
	 *				label.y = 100;//设置 label 对象的属性 y 的值，用于控制 label 对象的显示位置。
	 *				label.width = 300;//设置 label 的宽度。
	 *				label.height = 200;//设置 label 的高度。
	 *				Laya.stage.addChild(label);//将 label 添加到显示列表。
	 *				var passwordLabel:Label = new Label("请原谅我，我不想被人看到我心里话。");//创建一个 Label 类的实例对象 passwordLabel 。
	 *				passwordLabel.asPassword = true;//设置 passwordLabel 的显示反式为密码显示。
	 *				passwordLabel.x = 100;//设置 passwordLabel 对象的属性 x 的值，用于控制 passwordLabel 对象的显示位置。
	 *				passwordLabel.y = 350;//设置 passwordLabel 对象的属性 y 的值，用于控制 passwordLabel 对象的显示位置。
	 *				passwordLabel.width = 300;//设置 passwordLabel 的宽度。
	 *				passwordLabel.color = "#000000";//设置 passwordLabel 的文本颜色。
	 *				passwordLabel.bgColor = "#ccffff";//设置 passwordLabel 的背景颜色。
	 *				passwordLabel.fontSize = 20;//设置 passwordLabel 的文本字体大小。
	 *				Laya.stage.addChild(passwordLabel);//将 passwordLabel 添加到显示列表。
	 *			}
	 *		}
	 *	}
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
	 * onInit();
	 * function onInit(){
	 *     var label = new laya.ui.Label();//创建一个 Label 类的实例对象 label 。
	 *     label.font = "Arial";//设置 label 的字体。
	 *     label.bold = true;//设置 label 显示为粗体。
	 *     label.leading = 4;//设置 label 的行间距。
	 *     label.wordWrap = true;//设置 label 自动换行。
	 *     label.padding = "10,10,10,10";//设置 label 的边距。
	 *     label.color = "#ff00ff";//设置 label 的颜色。
	 *     label.text = "Hello everyone,我是一个可爱的文本！";//设置 label 的文本内容。
	 *     label.x = 100;//设置 label 对象的属性 x 的值，用于控制 label 对象的显示位置。
	 *     label.y = 100;//设置 label 对象的属性 y 的值，用于控制 label 对象的显示位置。
	 *     label.width = 300;//设置 label 的宽度。
	 *     label.height = 200;//设置 label 的高度。
	 *     Laya.stage.addChild(label);//将 label 添加到显示列表。
	 *     var passwordLabel = new laya.ui.Label("请原谅我，我不想被人看到我心里话。");//创建一个 Label 类的实例对象 passwordLabel 。
	 *     passwordLabel.asPassword = true;//设置 passwordLabel 的显示反式为密码显示。
	 *     passwordLabel.x = 100;//设置 passwordLabel 对象的属性 x 的值，用于控制 passwordLabel 对象的显示位置。
	 *     passwordLabel.y = 350;//设置 passwordLabel 对象的属性 y 的值，用于控制 passwordLabel 对象的显示位置。
	 *     passwordLabel.width = 300;//设置 passwordLabel 的宽度。
	 *     passwordLabel.color = "#000000";//设置 passwordLabel 的文本颜色。
	 *     passwordLabel.bgColor = "#ccffff";//设置 passwordLabel 的背景颜色。
	 *     passwordLabel.fontSize = 20;//设置 passwordLabel 的文本字体大小。
	 *     Laya.stage.addChild(passwordLabel);//将 passwordLabel 添加到显示列表。
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import Label = laya.ui.Label;
	 * class Label_Example {
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         this.onInit();
	 *     }
	 *     private onInit(): void {
	 *         var label: Label = new Label();//创建一个 Label 类的实例对象 label 。
	 *         label.font = "Arial";//设置 label 的字体。
	 *         label.bold = true;//设置 label 显示为粗体。
	 *         label.leading = 4;//设置 label 的行间距。
	 *         label.wordWrap = true;//设置 label 自动换行。
	 *         label.padding = "10,10,10,10";//设置 label 的边距。
	 *         label.color = "#ff00ff";//设置 label 的颜色。
	 *         label.text = "Hello everyone,我是一个可爱的文本！";//设置 label 的文本内容。
	 *         label.x = 100;//设置 label 对象的属性 x 的值，用于控制 label 对象的显示位置。
	 *         label.y = 100;//设置 label 对象的属性 y 的值，用于控制 label 对象的显示位置。
	 *         label.width = 300;//设置 label 的宽度。
	 *         label.height = 200;//设置 label 的高度。
	 *         Laya.stage.addChild(label);//将 label 添加到显示列表。
	 *         var passwordLabel: Label = new Label("请原谅我，我不想被人看到我心里话。");//创建一个 Label 类的实例对象 passwordLabel 。
	 *         passwordLabel.asPassword = true;//设置 passwordLabel 的显示反式为密码显示。
	 *         passwordLabel.x = 100;//设置 passwordLabel 对象的属性 x 的值，用于控制 passwordLabel 对象的显示位置。
	 *         passwordLabel.y = 350;//设置 passwordLabel 对象的属性 y 的值，用于控制 passwordLabel 对象的显示位置。
	 *         passwordLabel.width = 300;//设置 passwordLabel 的宽度。
	 *         passwordLabel.color = "#000000";//设置 passwordLabel 的文本颜色。
	 *         passwordLabel.bgColor = "#ccffff";//设置 passwordLabel 的背景颜色。
	 *         passwordLabel.fontSize = 20;//设置 passwordLabel 的文本字体大小。
	 *         Laya.stage.addChild(passwordLabel);//将 passwordLabel 添加到显示列表。
	 *     }
	 * }
	 * </listing>
	 * @see laya.display.Text
	 */
	public class Label extends Component {
		/**
		 * @private
		 */
		private static var _textReg:RegExp = new RegExp("\\\\n", "g");
		/**
		 * @private
		 * 文本 <code>Text</code> 实例。
		 */
		protected var _tf:Text;
		
		/**
		 * 创建一个新的 <code>Label</code> 实例。
		 * @param text 文本内容字符串。
		 */
		public function Label(text:String = "") {
			Font.defaultColor = Styles.labelColor;
			this.text = text;
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_tf = null;
		}
		
		/**@inheritDoc */
		override protected function createChildren():void {
			addChild(_tf = new Text());
		}
		
		/**
		 * 当前文本内容字符串。
		 * @see laya.display.Text.text
		 */
		public function get text():String {
			return _tf.text;
		}
		
		public function set text(value:String):void {
			if (_tf.text != value) {
				if(value)
				value=(value+"").replace(_textReg,"\n");
				_tf.text = value;
				event(Event.CHANGE);
			}
		}
		
		/**@copy laya.display.Text#changeText()
		 **/
		public function changeText(text:String):void {
			_tf.changeText(text);
		}
		
		/**
		 * @copy laya.display.Text#wordWrap
		 */
		public function get wordWrap():Boolean {
			return _tf.wordWrap;
		}
		
		/**
		 * @copy laya.display.Text#wordWrap
		 */
		public function set wordWrap(value:Boolean):void {
			_tf.wordWrap = value;
		}
		
		/**
		 * @copy laya.display.Text#color
		 */
		public function get color():String {
			return _tf.color;
		}
		
		public function set color(value:String):void {
			_tf.color = value;
		}
		
		/**
		 * @copy laya.display.Text#font
		 */
		public function get font():String {
			return _tf.font;
		}
		
		public function set font(value:String):void {
			_tf.font = value;
		}
		
		/**
		 * @copy laya.display.Text#align
		 */
		public function get align():String {
			return _tf.align;
		}
		
		public function set align(value:String):void {
			_tf.align = value;
		}
		
		/**
		 * @copy laya.display.Text#valign
		 */
		public function get valign():String {
			return _tf.valign;
		}
		
		public function set valign(value:String):void {
			_tf.valign = value;
		}
		
		/**
		 * @copy laya.display.Text#bold
		 */
		public function get bold():Boolean {
			return _tf.bold;
		}
		
		public function set bold(value:Boolean):void {
			_tf.bold = value;
		}
		
		/**
		 * @copy laya.display.Text#italic
		 */
		public function get italic():Boolean {
			return _tf.italic;
		}
		
		public function set italic(value:Boolean):void {
			_tf.italic = value;
		}
		
		/**
		 * @copy laya.display.Text#leading
		 */
		public function get leading():Number {
			return _tf.leading;
		}
		
		public function set leading(value:Number):void {
			_tf.leading = value;
		}
		
		/**
		 * @copy laya.display.Text#fontSize
		 */
		public function get fontSize():int {
			return _tf.fontSize;
		}
		
		public function set fontSize(value:int):void {
			_tf.fontSize = value;
		}
		
		/**
		 * <p>边距信息</p>
		 * <p>"上边距，右边距，下边距 , 左边距（边距以像素为单位）"</p>
		 * @see laya.display.Text.padding
		 */
		public function get padding():String {
			return _tf.padding.join(",");
		}
		
		public function set padding(value:String):void {
			_tf.padding = UIUtils.fillArray(Styles.labelPadding, value, Number);
		}
		
		/**
		 * @copy laya.display.Text#bgColor
		 */
		public function get bgColor():String {
			return _tf.bgColor
		}
		
		public function set bgColor(value:String):void {
			_tf.bgColor = value;
		}
		
		/**
		 * @copy laya.display.Text#borderColor
		 */
		public function get borderColor():String {
			return _tf.borderColor
		}
		
		public function set borderColor(value:String):void {
			_tf.borderColor = value;
		}
		
		/**
		 * @copy laya.display.Text#stroke
		 */
		public function get stroke():Number {
			return this._tf.stroke;
		}
		
		public function set stroke(value:Number):void {
			_tf.stroke = value;
		}
		
		/**
		 * @copy laya.display.Text#strokeColor
		 */
		public function get strokeColor():String {
			return _tf.strokeColor;
		}
		
		public function set strokeColor(value:String):void {
			_tf.strokeColor = value;
		}
		
		/**
		 * 文本控件实体 <code>Text</code> 实例。
		 */
		public function get textField():Text {
			return _tf;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get measureWidth():Number {
			return _tf.width;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get measureHeight():Number {
			return _tf.height;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number {
			if (_width || _tf.text) return super.width;
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void {
			super.width = value;
			_tf.width = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number {
			if (_height || _tf.text) return super.height;
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void {
			super.height = value;
			_tf.height = value;
		}
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			if (value is Number || value is String) text = value + "";
			else super.dataSource = value;
		}
		
		/**
		 * @copy laya.display.Text#overflow
		 */
		public function get overflow():String {
			return _tf.overflow;
		}
		
		/**
		 * @copy laya.display.Text#overflow
		 */
		public function set overflow(value:String):void {
			_tf.overflow = value;
		}
		
		/**
		 * @copy laya.display.Text#underline
		 */
		public function get underline():Boolean {
			return _tf.underline;
		}
		
		/**
		 * @copy laya.display.Text#underline
		 */
		public function set underline(value:Boolean):void {
			_tf.underline = value;
		}
		
		/**
		 * @copy laya.display.Text#underlineColor
		 */
		public function get underlineColor():String {
			return _tf.underlineColor;
		}
		
		/**
		 * @copy laya.display.Text#underlineColor
		 */
		public function set underlineColor(value:String):void {
			_tf.underlineColor = value;
		}
	}
}