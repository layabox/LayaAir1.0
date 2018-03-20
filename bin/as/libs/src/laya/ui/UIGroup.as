package laya.ui {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.Button;
	import laya.utils.Handler;
	
	/**
	 * 当 <code>Group</code> 实例的 <code>selectedIndex</code> 属性发生变化时调度。
	 * @eventType laya.events.Event
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * <code>Group</code> 是一个可以自动布局的项集合控件。
	 * <p> <code>Group</code> 的默认项对象为 <code>Button</code> 类实例。
	 * <code>Group</code> 是 <code>Tab</code> 和 <code>RadioGroup</code> 的基类。</p>
	 */
	public class UIGroup extends Box implements IItem {
		
		/**
		 * 改变 <code>Group</code> 的选择项时执行的处理器，(默认返回参数： 项索引（index:int）)。
		 */
		public var selectHandler:Handler;
		
		/**@private */
		protected var _items:Vector.<ISelect>;
		/**@private */
		protected var _selectedIndex:int = -1;
		/**@private */
		protected var _skin:String;
		/**@private */
		protected var _direction:String = "horizontal";
		/**@private */
		protected var _space:Number = 0;
		/**@private */
		protected var _labels:String;
		/**@private */
		protected var _labelColors:String;
		/**@private */
		private var _labelFont:String;
		/**@private */
		protected var _labelStrokeColor:String;
		/**@private */
		protected var _strokeColors:String;
		/**@private */
		protected var _labelStroke:Number;
		/**@private */
		protected var _labelSize:int;
		/**@private */
		protected var _labelBold:Boolean;
		/**@private */
		protected var _labelPadding:String;
		/**@private */
		protected var _labelAlign:String;
		/**@private */
		protected var _stateNum:int;
		/**@private */
		protected var _labelChanged:Boolean;
		
		/**
		 * 创建一个新的 <code>Group</code> 类实例。
		 * @param labels 标签集字符串。以逗号做分割，如"item0,item1,item2,item3,item4,item5"。
		 * @param skin 皮肤。
		 */
		public function UIGroup(labels:String = null, skin:String = null) {
			this.skin = skin;
			this.labels = labels;
		}
		
		/**@inheritDoc */
		override protected function preinitialize():void {
			mouseEnabled = true;
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_items && (_items.length = 0);
			_items = null;
			selectHandler = null;
		}
		
		/**
		 * 添加一个项对象，返回此项对象的索引id。
		 *
		 * @param item 需要添加的项对象。
		 * @param autoLayOut 是否自动布局，如果为true，会根据 <code>direction</code> 和 <code>space</code> 属性计算item的位置。
		 * @return
		 */
		public function addItem(item:ISelect, autoLayOut:Boolean = true):int {
			var display:Sprite = item as Sprite;
			var index:int = _items.length;
			display.name = "item" + index;
			addChild(display);
			initItems();
			
			if (autoLayOut && index > 0) {
				var preItem:Sprite = _items[index - 1] as Sprite;
				if (_direction == "horizontal") {
					display.x = preItem.x + preItem.width + _space;
				} else {
					display.y = preItem.y + preItem.height + _space;
				}
			} else {
				if (autoLayOut) {
					display.x = 0;
					display.y = 0;
				}
			}
			return index;
		}
		
		/**
		 * 删除一个项对象。
		 * @param item 需要删除的项对象。
		 * @param autoLayOut 是否自动布局，如果为true，会根据 <code>direction</code> 和 <code>space</code> 属性计算item的位置。
		 */
		public function delItem(item:ISelect, autoLayOut:Boolean = true):void {
			var index:int = _items.indexOf(item);
			if (index != -1) {
				var display:Sprite = item as Sprite;
				removeChild(display);
				for (var i:int = index + 1, n:int = _items.length; i < n; i++) {
					var child:Sprite = _items[i] as Sprite;
					child.name = "item" + (i - 1);
					if (autoLayOut) {
						if (_direction == "horizontal") {
							child.x -= display.width + _space;
						} else {
							child.y -= display.height + _space;
						}
					}
				}
				initItems();
				if (_selectedIndex > -1) {
					var newIndex:int;
					newIndex = _selectedIndex < _items.length ? _selectedIndex : (_selectedIndex - 1);
					_selectedIndex = -1;
					selectedIndex = newIndex;
				}
			}
		}
		
		/**
		 * 初始化项对象们。
		 */
		public function initItems():void {
			_items || (_items = new Vector.<ISelect>());
			_items.length = 0;
			for (var i:int = 0; i < 10000; i++) {
				var item:ISelect = getChildByName("item" + i) as ISelect;
				if (item == null) break;
				_items.push(item);
				item.selected = (i === _selectedIndex);
				item.clickHandler = Handler.create(this, itemClick, [i], false);
			}
		}
		
		/**
		 * @private
		 * 项对象的点击事件侦听处理函数。
		 * @param index 项索引。
		 */
		protected function itemClick(index:int):void {
			selectedIndex = index;
		}
		
		/**
		 * 表示当前选择的项索引。默认值为-1。
		 */
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void {
			if (_selectedIndex != value) {
				setSelect(_selectedIndex, false);
				_selectedIndex = value;
				setSelect(value, true);
				event(Event.CHANGE);
				selectHandler && selectHandler.runWith(_selectedIndex);
			}
		}
		
		/**
		 * @private
		 * 通过对象的索引设置项对象的 <code>selected</code> 属性值。
		 * @param index 需要设置的项对象的索引。
		 * @param selected 表示项对象的选中状态。
		 */
		protected function setSelect(index:int, selected:Boolean):void {
			if (_items && index > -1 && index < _items.length) _items[index].selected = selected;
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
				_setLabelChanged();
			}
		}
		
		/**
		 * 标签集合字符串。以逗号做分割，如"item0,item1,item2,item3,item4,item5"。
		 */
		public function get labels():String {
			return _labels;
		}
		
		public function set labels(value:String):void {
			if (_labels != value) {
				_labels = value;
				removeChildren();
				_setLabelChanged();
				if (_labels) {
					var a:Array = _labels.split(",");
					for (var i:int = 0, n:int = a.length; i < n; i++) {
						var item:Sprite = createItem(_skin, a[i]);
						item.name = "item" + i;
						addChild(item);
					}
				}
				initItems();
			}
		}
		
		/**
		 * @private
		 * 创建一个项显示对象。
		 * @param skin 项对象的皮肤。
		 * @param label 项对象标签。
		 */
		protected function createItem(skin:String, label:String):Sprite {
			return null;
		}
		
		/**
		 * @copy laya.ui.Button#labelColors()
		 */
		public function get labelColors():String {
			return _labelColors;
		}
		
		public function set labelColors(value:String):void {
			if (_labelColors != value) {
				_labelColors = value;
				_setLabelChanged();
			}
		}
		
		/**
		 * <p>描边宽度（以像素为单位）。</p>
		 * 默认值0，表示不描边。
		 * @see laya.display.Text.stroke()
		 */
		public function get labelStroke():Number {
			return _labelStroke;
		}
		
		public function set labelStroke(value:Number):void {
			if (_labelStroke != value) {
				_labelStroke = value;
				_setLabelChanged();
			}
		}
		
		/**
		 * <p>描边颜色，以字符串表示。</p>
		 * 默认值为 "#000000"（黑色）;
		 * @see laya.display.Text.strokeColor()
		 */
		public function get labelStrokeColor():String {
			return _labelStrokeColor;
		}
		
		public function set labelStrokeColor(value:String):void {
			if (_labelStrokeColor != value) {
				_labelStrokeColor = value;
				_setLabelChanged();
			}
		}
		
		/**
		 * <p>表示各个状态下的描边颜色。</p>
		 * @see laya.display.Text.strokeColor()
		 */
		public function get strokeColors():String {
			return _strokeColors;
		}
		
		public function set strokeColors(value:String):void {
			if (_strokeColors != value) {
				_strokeColors = value;
				_setLabelChanged();
			}
		}
		
		/**
		 * 表示按钮文本标签的字体大小。
		 */
		public function get labelSize():int {
			return _labelSize;
		}
		
		public function set labelSize(value:int):void {
			if (_labelSize != value) {
				_labelSize = value;
				_setLabelChanged();
			}
		}
		
		/**
		 * 表示按钮的状态值，以数字表示，默认为3态。
		 * @see laya.ui.Button#stateNum
		 */
		public function get stateNum():int {
			return _stateNum;
		}
		
		public function set stateNum(value:int):void {
			if (_stateNum != value) {
				_stateNum = value;
				_setLabelChanged();
			}
		}
		
		/**
		 * 表示按钮文本标签是否为粗体字。
		 */
		public function get labelBold():Boolean {
			return _labelBold;
		}
		
		public function set labelBold(value:Boolean):void {
			if (_labelBold != value) {
				_labelBold = value;
				_setLabelChanged();
			}
		}
		
		/**
		 * 表示按钮文本标签的字体名称，以字符串形式表示。
		 * @see laya.display.Text.font()
		 */
		public function get labelFont():String {
			return _labelFont;
		}
		
		public function set labelFont(value:String):void {
			if (_labelFont != value) {
				_labelFont = value;
				_setLabelChanged();
			}
		}
		/**
		 * 表示按钮文本标签的边距。
		 * <p><b>格式：</b>"上边距,右边距,下边距,左边距"。</p>
		 */
		public function get labelPadding():String {
			return _labelPadding;
		}
		
		public function set labelPadding(value:String):void {
			if (_labelPadding != value) {
				_labelPadding = value;
				_setLabelChanged();
			}
		}
		
		/**
		 * 布局方向。
		 * <p>默认值为"horizontal"。</p>
		 * <p><b>取值：</b>
		 * <li>"horizontal"：表示水平布局。</li>
		 * <li>"vertical"：表示垂直布局。</li>
		 * </p>
		 */
		public function get direction():String {
			return _direction;
		}
		
		public function set direction(value:String):void {
			_direction = value;
			_setLabelChanged();
		}
		
		/**
		 * 项对象们之间的间隔（以像素为单位）。
		 */
		public function get space():Number {
			return _space;
		}
		
		public function set space(value:Number):void {
			_space = value;
			_setLabelChanged();
		}
		
		/**
		 * @private
		 * 更改项对象的属性值。
		 */
		protected function changeLabels():void {
			_labelChanged = false;
			if (_items) {
				var left:Number = 0
				for (var i:int = 0, n:int = _items.length; i < n; i++) {
					var btn:Button = _items[i] as Button;
					_skin && (btn.skin = _skin);
					_labelColors && (btn.labelColors = _labelColors);
					_labelSize && (btn.labelSize = _labelSize);
					_labelStroke && (btn.labelStroke = _labelStroke);
					_labelStrokeColor && (btn.labelStrokeColor = _labelStrokeColor);
					_strokeColors && (btn.strokeColors = _strokeColors);
					_labelBold && (btn.labelBold = _labelBold);
					_labelPadding && (btn.labelPadding = _labelPadding);
					_labelAlign && (btn.labelAlign = _labelAlign);
					_stateNum && (btn.stateNum = _stateNum);
					_labelFont && (btn.labelFont=_labelFont);
					if (_direction === "horizontal") {
						btn.y = 0;
						btn.x = left;
						left += btn.width + _space;
					} else {
						btn.x = 0;
						btn.y = left;
						left += btn.height + _space;
					}
				}
			}
			changeSize();
		}
		
		/**@inheritDoc */
		override protected function commitMeasure():void {
			runCallLater(changeLabels);
		}
		
		/**
		 * 项对象们的存放数组。
		 */
		public function get items():Vector.<ISelect> {
			return _items;
		}
		
		/**
		 * 获取或设置当前选择的项对象。
		 */
		public function get selection():ISelect {
			return _selectedIndex > -1 && _selectedIndex < _items.length ? _items[_selectedIndex] : null;
		}
		
		public function set selection(value:ISelect):void {
			selectedIndex = _items.indexOf(value);
		}
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			if (value is int || value is String) selectedIndex = parseInt(value);
			else if (value is Array) labels = (value as Array).join(",");
			else super.dataSource = value;
		}
		
		/**@private */
		protected function _setLabelChanged():void {
			if (!_labelChanged) {
				_labelChanged = true;
				callLater(changeLabels);
			}
		}
	}
}