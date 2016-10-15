package laya.ui {
	import laya.display.Text;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.ui.AutoBitmap;
	import laya.ui.UIUtils;
	import laya.utils.Handler;
	
	/**
	 * 当按钮的选中状态（ <code>selected</code> 属性）发生改变时调度。
	 * @eventType laya.events.Event
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * <code>Button</code> 组件用来表示常用的多态按钮。 <code>Button</code> 组件可显示文本标签、图标或同时显示两者。	 *
	 * <p>可以是单态，两态和三态，默认三态(up,over,down)。</p>
	 *
	 * @example 以下示例代码，创建了一个 <code>Button</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.ui.Button;
	 *		import laya.utils.Handler;
	 *		public class Button_Example
	 *		{
	 *			public function Button_Example()
	 *			{
	 *				Laya.init(640, 800);//设置游戏画布宽高。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				Laya.loader.load("resource/ui/button.png", Handler.create(this,onLoadComplete));//加载资源。
	 *			}
	 *			private function onLoadComplete():void
	 *			{
	 *				trace("资源加载完成！");
	 *				var button:Button = new Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,并传入它的皮肤。
	 *				button.x = 100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
	 *				button.y = 100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
	 *				button.clickHandler = new Handler(this, onClickButton,[button]);//设置 button 的点击事件处理器。
	 *				Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
	 *			}
	 *			private function onClickButton(button:Button):void
	 *			{
	 *				trace("按钮button被点击了！");
	 *			}
	 *		}
	 *	}
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 * Laya.loader.load("resource/ui/button.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	 * function loadComplete()
	 * {
	 *     console.log("资源加载完成！");
	 *     var button = new laya.ui.Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,传入它的皮肤skin和标签label。
	 *     button.x =100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
	 *     button.y =100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
	 *     button.clickHandler = laya.utils.Handler.create(this,onClickButton,[button],false);//设置 button 的点击事件处理函数。
	 *     Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
	 * }
	 * function onClickButton(button)
	 * {
	 *     console.log("按钮被点击了。",button);
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import Button=laya.ui.Button;
	 * import Handler=laya.utils.Handler;
	 * class Button_Example{
	 *     constructor()
	 *     {
	 *         Laya.init(640, 800);
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load("resource/ui/button.png", laya.utils.Handler.create(this,this.onLoadComplete));//加载资源。
	 *     }
	 *     private onLoadComplete()
	 *     {
	 *         var button:Button = new Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,并传入它的皮肤。
	 *         button.x = 100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
	 *         button.y = 100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
	 *         button.clickHandler = new Handler(this, this.onClickButton,[button]);//设置 button 的点击事件处理器。
	 *         Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
	 *     }
	 *     private onClickButton(button:Button):void
	 *     {
	 *         console.log("按钮button被点击了！")
	 *     }
	 * }
	 * </listing>
	 */
	public class Button extends Component implements ISelect {
		/**
		 * 按钮状态集。
		 */
		protected static var stateMap:Object = {"mouseup": 0, "mouseover": 1, "mousedown": 2, "mouseout": 0};
		
		/**
		 * 指定按钮按下时是否是切换按钮的显示状态。
		 *
		 * @example 以下示例代码，创建了一个 <code>Button</code> 实例，并设置为切换按钮。
		 * <listing version="3.0">
		 * package
		 *	{
		 *		import laya.ui.Button;
		 *		import laya.utils.Handler;
		 *		public class Button_toggle
		 *		{
		 *			public function Button_toggle()
		 *			{
		 *				Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
		 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
		 *				Laya.loader.load("resource/ui/button.png", Handler.create(this,onLoadComplete));
		 *			}
		 *			private function onLoadComplete():void
		 *			{
		 *				trace("资源加载完成！");
		 *				var button:Button = new Button("resource/ui/button.png","label");//创建一个 Button 实例对象 button ,传入它的皮肤skin和标签label。
		 *				button.x = 100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
		 *				button.y = 100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
		 *				button.toggle = true;//设置 button 对象为切换按钮。
		 *				button.clickHandler = new Handler(this, onClickButton,[button]);//设置 button 的点击事件处理器。
		 *				Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
		 *	 		}
		 *			private function onClickButton(button:Button):void
		 *			{
		 *				trace("button.selected = "+ button.selected);
		 *			}
		 *		}
		 *	}
		 * </listing>
		 * <listing version="3.0">
		 * Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
		 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
		 * Laya.loader.load("resource/ui/button.png",laya.utils.Handler.create(this,loadComplete));//加载资源
		 * function loadComplete()
		 * {
		 *     console.log("资源加载完成！");
		 *     var button = new laya.ui.Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,传入它的皮肤skin和标签label。
		 *     button.x =100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
		 *     button.y =100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
		 *     button.toggle = true;//设置 button 对象为切换按钮。
		 *     button.clickHandler = laya.utils.Handler.create(this,onClickButton,[button],false);//设置 button 的点击事件处理器。
		 *     Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
		 * }
		 * function onClickButton(button)
		 * {
		 *     console.log("button.selected = ",button.selected);
		 * }
		 * </listing>
		 * <listing version="3.0">
		 * Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
		 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
		 * Laya.loader.load("button.png", null,null, null, null, null);//加载资源
		 * function loadComplete() {
		 *     console.log("资源加载完成！");
		 *     var button:laya.ui.Button = new laya.ui.Button("button.png", "label");//创建一个 Button 类的实例对象 button ,传入它的皮肤skin和标签label。
		 *     button.x = 100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
		 *     button.y = 100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
		 *     button.toggle = true;//设置 button 对象为切换按钮。
		 *     button.clickHandler = laya.utils.Handler.create(this, onClickButton, [button], false);//设置 button 的点击事件处理器。
		 *     Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
		 * }
		 * function onClickButton(button) {
		 *     console.log("button.selected = ", button.selected);
		 * }
		 * </listing>
		 */
		public var toggle:Boolean;
		/**
		 * @private
		 */
		protected var _bitmap:AutoBitmap;
		/**
		 * @private
		 * 按钮上的文本。
		 */
		protected var _text:Text;
		/**
		 * @private
		 * 按钮文本标签的颜色值。
		 */
		protected var _labelColors:Array = Styles.buttonLabelColors;
		/**
		 * @private
		 * 按钮文本标签描边的颜色值。
		 */
		protected var _strokeColors:Array;
		/**
		 * @private
		 * 按钮的状态值。
		 */
		protected var _state:int = 0;
		/**
		 * @private
		 * 表示按钮的选中状态。
		 */
		protected var _selected:Boolean;
		/**
		 * @private
		 * 按钮的皮肤资源。
		 */
		protected var _skin:String;
		/**
		 * @private
		 * 指定此显示对象是否自动计算并改变大小等属性。
		 */
		protected var _autoSize:Boolean = true;
		/**
		 * @private
		 * 按钮的状态数。
		 */
		protected var _stateNum:int = Styles.buttonStateNum;
		/**
		 * @private
		 * 源数据。
		 */
		protected var _sources:Array;
		/**
		 * @private
		 * 按钮的点击事件函数。
		 */
		protected var _clickHandler:Handler;
		/**
		 * @private
		 */
		protected var _stateChanged:Boolean = false;
		
		/**
		 * 创建一个新的 <code>Button</code> 类实例。
		 * @param skin 皮肤资源地址。
		 * @param label 按钮的文本内容。
		 */
		public function Button(skin:String = null, label:String = "") {
			this.skin = skin;
			this.label = label;
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_bitmap && _bitmap.destroy();
			_text && _text.destroy(destroyChild);
			_bitmap = null;
			_text = null;
			_clickHandler = null;
			_labelColors = _sources = _strokeColors = null;
		}
		
		/**@inheritDoc */
		override protected function createChildren():void {
			graphics = _bitmap = new AutoBitmap();
		}
		
		/**@private */
		protected function createText():void {
			if (!_text) {
				_text = new Text();
				_text.overflow = Text.HIDDEN;
				_text.align = "center";
				_text.valign = "middle";
			}
		}
		
		/**@inheritDoc */
		override protected function initialize():void {
			on(Event.MOUSE_OVER, this, onMouse);
			on(Event.MOUSE_OUT, this, onMouse);
			on(Event.MOUSE_DOWN, this, onMouse);
			on(Event.MOUSE_UP, this, onMouse);
			on(Event.CLICK, this, onMouse);
		}
		
		/**
		 * 对象的 <code>Event.MOUSE_OVER、Event.MOUSE_OUT、Event.MOUSE_DOWN、Event.MOUSE_UP、Event.CLICK</code> 事件侦听处理函数。
		 * @param e Event 对象。
		 */
		protected function onMouse(e:Event):void {
			if (toggle === false && _selected) return;
			if (e.type === Event.CLICK) {
				toggle && (selected = !_selected);
				_clickHandler && _clickHandler.run();
				return;
			}
			!_selected && (state = stateMap[e.type]);
		}
		
		/**
		 * <p>对象的皮肤资源地址。</p>
		 * 支持单态，两态和三态，用 <code>stateNum</code> 属性设置
		 * <p>对象的皮肤地址，以字符串表示。</p>
		 * @see #stateNum
		 */
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				callLater(changeClips);
				_setStateChanged();
			}
		}
		
		/**
		 * <p>指定对象的状态值，以数字表示。</p>
		 * <p>默认值为3。此值决定皮肤资源图片的切割方式。</p>
		 * <p><b>取值：</b>
		 * <li>1：单态。图片不做切割，按钮的皮肤状态只有一种。</li>
		 * <li>2：两态。图片将以竖直方向被等比切割为2部分，从上向下，依次为
		 * 弹起状态皮肤、
		 * 按下和经过及选中状态皮肤。</li>
		 * <li>3：三态。图片将以竖直方向被等比切割为2部分，从上向下，依次为
		 * 弹起状态皮肤、
		 * 经过状态皮肤、
		 * 按下和选中状态皮肤</li>
		 * </p>
		 */
		public function get stateNum():int {
			return _stateNum;
		}
		
		public function set stateNum(value:int):void {
			if (_stateNum != value) {
				_stateNum = value < 1 ? 1 : value > 3 ? 3 : value;
				callLater(changeClips);
			}
		}
		
		/**
		 * @private
		 * 对象的资源切片发生改变。
		 */
		protected function changeClips():void {
			var img:Texture = Loader.getRes(_skin);
			if (!img) {
				trace("lose skin", _skin);
				return;
			}
			var width:Number = img.sourceWidth;
			var height:Number = img.sourceHeight / _stateNum;
			var key:String = _skin + _stateNum;
			var clips:Array = AutoBitmap.getCache(key);
			if (clips) _sources = clips;
			else {
				_sources = [];
				if (_stateNum === 1) {
					_sources.push(img);
				} else {
					for (var i:int = 0; i < _stateNum; i++) {
						_sources.push(Texture.createFromTexture(img, 0, height * i, width, height));
					}
				}
				AutoBitmap.setCache(key, _sources);
			}
			
			if (_autoSize) {
				_bitmap.width = _width || width;
				_bitmap.height = _height || height;
				if (_text) {
					_text.width = _bitmap.width;
					_text.height = _bitmap.height;
				}
			} else {
				_text && (_text.x = width);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get measureWidth():Number {
			runCallLater(changeClips);
			if (_autoSize) return _bitmap.width;
			runCallLater(changeState);
			return _bitmap.width + (_text ? _text.width : 0);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get measureHeight():Number {
			runCallLater(changeClips);
			return _text ? Math.max(_bitmap.height, _text.height) : _bitmap.height;
		}
		
		/**
		 * 按钮的文本内容。
		 */
		public function get label():String {
			return _text ? _text.text : null;
		}
		
		public function set label(value:String):void {
			if (!_text && !value) return;
			createText();
			if (_text.text != value) {
				value && !_text.displayedInStage && addChild(_text);
				_text.text = (value+"").replace(/\\n/g, "\n");
				_setStateChanged();
			}
		}
		
		/**
		 * 表示按钮的选中状态。
		 * <p>如果值为true，表示该对象处于选中状态。否则该对象处于未选中状态。</p>
		 */
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set selected(value:Boolean):void {
			if (_selected != value) {
				_selected = value;
				state = _selected ? 2 : 0;
				event(Event.CHANGE);
			}
		}
		
		/**
		 * 对象的状态值。
		 * @see #stateMap
		 */
		protected function get state():int {
			return _state;
		}
		
		protected function set state(value:int):void {
			if (_state != value) {
				_state = value;
				_setStateChanged();
			}
		}
		
		/**
		 * @private
		 * 改变对象的状态。
		 */
		protected function changeState():void {
			_stateChanged = false;
			runCallLater(changeClips);
			var index:int = _state < _stateNum ? _state : _stateNum - 1;
			_sources && (_bitmap.source = _sources[index]);
			if (label) {
				_text.color = _labelColors[index];
				if (_strokeColors) _text.strokeColor = _strokeColors[index];
			}
		}
		
		/**
		 * 表示按钮各个状态下的文本颜色。
		 * <p><b>格式:</b> "upColor,overColor,downColor,disableColor"。</p>
		 */
		public function get labelColors():String {
			return _labelColors.join(",");
		}
		
		public function set labelColors(value:String):void {
			_labelColors = UIUtils.fillArray(Styles.buttonLabelColors, value, String);
			_setStateChanged();
		}
		
		/**
		 * 表示按钮各个状态下的描边颜色。
		 * <p><b>格式:</b> "upColor,overColor,downColor,disableColor"。</p>
		 */
		public function get strokeColors():String {
			return _strokeColors ? _strokeColors.join(",") : "";
		}
		
		public function set strokeColors(value:String):void {
			_strokeColors = UIUtils.fillArray(Styles.buttonLabelColors, value, String);
			_setStateChanged();
		}
		
		/**
		 * 表示按钮文本标签的边距。
		 * <p><b>格式：</b>"上边距,右边距,下边距,左边距"。</p>
		 */
		public function get labelPadding():String {
			createText();
			return _text.padding.join(",");
		}
		
		public function set labelPadding(value:String):void {
			createText();
			_text.padding = UIUtils.fillArray(Styles.labelPadding, value, Number);
		}
		
		/**
		 * 表示按钮文本标签的字体大小。
		 * @see laya.display.Text.fontSize()
		 */
		public function get labelSize():int {
			createText();
			return _text.fontSize;
		}
		
		public function set labelSize(value:int):void {
			createText();
			_text.fontSize = value
		}
		
		/**
		 * <p>描边宽度（以像素为单位）。</p>
		 * 默认值0，表示不描边。
		 * @see laya.display.Text.stroke()
		 */
		public function get labelStroke():Number {
			createText();
			return _text.stroke;
		}
		
		public function set labelStroke(value:Number):void {
			createText();
			_text.stroke = value
		}
		
		/**
		 * <p>描边颜色，以字符串表示。</p>
		 * 默认值为 "#000000"（黑色）;
		 * @see laya.display.Text.strokeColor()
		 */
		public function get labelStrokeColor():String {
			createText();
			return _text.strokeColor;
		}
		
		public function set labelStrokeColor(value:String):void {
			createText();
			_text.strokeColor = value
		}
		
		/**
		 * 表示按钮文本标签是否为粗体字。
		 * @see laya.display.Text.bold()
		 */
		public function get labelBold():Boolean {
			createText();
			return _text.bold;
		}
		
		public function set labelBold(value:Boolean):void {
			createText();
			_text.bold = value;
		}
		
		/**
		 * 表示按钮文本标签的字体名称，以字符串形式表示。
		 * @see laya.display.Text.font()
		 */
		public function get labelFont():String {
			createText();
			return _text.font;
		}
		
		public function set labelFont(value:String):void {
			createText();
			_text.font = value;
		}
		
		/**标签对齐模式，默认为居中对齐。*/
		public function get labelAlign():String {
			createText()
			return _text.align;
		}
		
		public function set labelAlign(value:String):void {
			createText()
			_text.align = value;
		}
		
		/**
		 * 对象的点击事件处理器函数（无默认参数）。
		 */
		public function get clickHandler():Handler {
			return _clickHandler;
		}
		
		public function set clickHandler(value:Handler):void {
			_clickHandler = value;
		}
		
		/**
		 * 按钮文本标签 <code>Text</code> 控件。
		 */
		public function get text():Text {
			createText();
			return _text;
		}
		
		/**
		 * <p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
		 * <p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		 * <ul><li>例如："4,4,4,4,1"</li></ul></p>
		 * @see laya.ui.AutoBitmap.sizeGrid
		 */
		public function get sizeGrid():String {
			if (_bitmap.sizeGrid) return _bitmap.sizeGrid.join(",");
			return null;
		}
		
		public function set sizeGrid(value:String):void {
			_bitmap.sizeGrid = UIUtils.fillArray(Styles.defaultSizeGrid, value, Number);
		}
		
		/**@inheritDoc */
		override public function set width(value:Number):void {
			super.width = value;
			if (_autoSize) {
				_bitmap.width = value;
				_text && (_text.width = value);
			}
		}
		
		/**@inheritDoc */
		override public function set height(value:Number):void {
			super.height = value;
			if (_autoSize) {
				_bitmap.height = value;
				_text && (_text.height = value);
			}
		}
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			if (value is Number || value is String) label = value + "";
			else super.dataSource = value;
		}
		
		/**图标x,y偏移，格式：100,100*/
		public function get iconOffset():String {
			return _bitmap._offset ? null : _bitmap._offset.join(",");
		}
		
		public function set iconOffset(value:String):void {
			if (value) _bitmap._offset = UIUtils.fillArray([1, 1], value, Number);
			else _bitmap._offset = [];
		}
		
		/**@private */
		protected function _setStateChanged():void {
			if (!_stateChanged) {
				_stateChanged = true;
				callLater(changeState);
			}
		}
	}
}