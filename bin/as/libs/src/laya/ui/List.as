package laya.ui {
	import laya.display.Node;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.utils.Handler;
	import laya.utils.Tween;
	
	/**
	 * 当对象的 <code>selectedIndex</code> 属性发生变化时调度。
	 * @eventType laya.events.Event
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * 渲染列表的单元项对象时调度。
	 * @eventType Event.RENDER
	 */
	[Event(name = "render", type = "laya.events.Event")]
	
	/**
	 * <code>List</code> 控件可显示项目列表。默认为垂直方向列表。可通过UI编辑器自定义列表。
	 *
	 * @example <caption>以下示例代码，创建了一个 <code>List</code> 实例。</caption>
	 * package
	 *	{
	 *		import laya.ui.List;
	 *		import laya.utils.Handler;
	 *		public class List_Example
	 *		{
	 *			public function List_Example()
	 *			{
	 *				Laya.init(640, 800, "false");//设置游戏画布宽高、渲染模式。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, onLoadComplete));
	 *			}
	 *			private function onLoadComplete():void
	 *			{
	 *				var arr:Array = [];//创建一个数组，用于存贮列表的数据信息。
	 *				for (var i:int = 0; i &lt; 20; i++)
	 *				{
	 *					arr.push({label: "item" + i});
	 *				}
	 *				var list:List = new List();//创建一个 List 类的实例对象 list 。
	 *				list.itemRender = Item;//设置 list 的单元格渲染器。
	 *				list.repeatX = 1;//设置 list 的水平方向单元格数量。
	 *				list.repeatY = 10;//设置 list 的垂直方向单元格数量。
	 *				list.vScrollBarSkin = "resource/ui/vscroll.png";//设置 list 的垂直方向滚动条皮肤。
	 *				list.array = arr;//设置 list 的列表数据源。
	 *				list.pos(100, 100);//设置 list 的位置。
	 *				list.selectEnable = true;//设置 list 可选。
	 *				list.selectHandler = new Handler(this, onSelect);//设置 list 改变选择项执行的处理器。
	 *				Laya.stage.addChild(list);//将 list 添加到显示列表。
	 *			}
	 *			private function onSelect(index:int):void
	 *			{
	 *				trace("当前选择的项目索引： index= ", index);
	 *			}
	 *		}
	 *	}
	 *	import laya.ui.Box;
	 *	import laya.ui.Label;
	 *	class Item extends Box
	 *	{
	 *		public function Item()
	 *		{
	 *			graphics.drawRect(0, 0, 100, 20,null, "#ff0000");
	 *			var label:Label = new Label();
	 *			label.text = "100000";
	 *			label.name = "label";//设置 label 的name属性值。
	 *			label.size(100, 20);
	 *			addChild(label);
	 *		}
	 *	}
	 * @example
	 * (function (_super){
	 *     function Item(){
	 *         Item.__super.call(this);//初始化父类
	 *         this.graphics.drawRect(0, 0, 100, 20, "#ff0000");
	 *         var label = new laya.ui.Label();//创建一个 Label 类的实例对象 label 。
	 *         label.text = "100000";//设置 label 的文本内容。
	 *         label.name = "label";//设置 label 的name属性值。
	 *         label.size(100, 20);//设置 label 的宽度、高度。
	 *         this.addChild(label);//将 label 添加到显示列表。
	 *     };
	 *     Laya.class(Item,"mypackage.listExample.Item",_super);//注册类 Item 。
	 * })(laya.ui.Box);
	
	 * Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 * var res = ["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"];
	 * Laya.loader.load(res, new laya.utils.Handler(this, onLoadComplete));//加载资源。
	
	 * function onLoadComplete() {
	 *     var arr = [];//创建一个数组，用于存贮列表的数据信息。
	 *     for (var i = 0; i &lt; 20; i++) {
	 *         arr.push({label: "item" + i});
	 *     }
	
	 *     var list = new laya.ui.List();//创建一个 List 类的实例对象 list 。
	 *     list.itemRender = mypackage.listExample.Item;//设置 list 的单元格渲染器。
	 *     list.repeatX = 1;//设置 list 的水平方向单元格数量。
	 *     list.repeatY = 10;//设置 list 的垂直方向单元格数量。
	 *     list.vScrollBarSkin = "resource/ui/vscroll.png";//设置 list 的垂直方向滚动条皮肤。
	 *     list.array = arr;//设置 list 的列表数据源。
	 *     list.pos(100, 100);//设置 list 的位置。
	 *     list.selectEnable = true;//设置 list 可选。
	 *     list.selectHandler = new laya.utils.Handler(this, onSelect);//设置 list 改变选择项执行的处理器。
	 *     Laya.stage.addChild(list);//将 list 添加到显示列表。
	 * }
	
	 * function onSelect(index)
	 * {
	 *     console.log("当前选择的项目索引： index= ", index);
	 * }
	 *
	 * @example
	 * import List = laya.ui.List;
	 * import Handler = laya.utils.Handler;
	 * public class List_Example {
	 *     public List_Example() {
	 *         Laya.init(640, 800);//设置游戏画布宽高。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png"], Handler.create(this, this.onLoadComplete));
	 *     }
	 *     private onLoadComplete(): void {
	 *         var arr= [];//创建一个数组，用于存贮列表的数据信息。
	 *         for (var i: number = 0; i &lt; 20; i++)
	 *         {
	 *             arr.push({ label: "item" + i });
	 *         }
	 *         var list: List = new List();//创建一个 List 类的实例对象 list 。
	 *         list.itemRender = Item;//设置 list 的单元格渲染器。
	 *         list.repeatX = 1;//设置 list 的水平方向单元格数量。
	 *         list.repeatY = 10;//设置 list 的垂直方向单元格数量。
	 *         list.vScrollBarSkin = "resource/ui/vscroll.png";//设置 list 的垂直方向滚动条皮肤。
	 *         list.array = arr;//设置 list 的列表数据源。
	 *         list.pos(100, 100);//设置 list 的位置。
	 *         list.selectEnable = true;//设置 list 可选。
	 *         list.selectHandler = new Handler(this, this.onSelect);//设置 list 改变选择项执行的处理器。
	 *         Laya.stage.addChild(list);//将 list 添加到显示列表。
	 *     }
	 *     private onSelect(index: number): void {
	 *         console.log("当前选择的项目索引： index= ", index);
	 *     }
	 * }
	 * import Box = laya.ui.Box;
	 * import Label = laya.ui.Label;
	 * class Item extends Box {
	 *     constructor() {
	 *         this.graphics.drawRect(0, 0, 100, 20, null, "#ff0000");
	 *         var label: Label = new Label();
	 *         label.text = "100000";
	 *         label.name = "label";//设置 label 的name属性值。
	 *         label.size(100, 20);
	 *         this.addChild(label);
	 *     }
	 * }
	 */
	public class List extends Box implements IRender, IItem {
		
		/**改变 <code>List</code> 的选择项时执行的处理器，(默认返回参数： 项索引（index:int）)。*/
		public var selectHandler:Handler;
		/**单元格渲染处理器(默认返回参数cell:Box,index:int)。*/
		public var renderHandler:Handler;
		/**单元格鼠标事件处理器(默认返回参数e:Event,index:int)。*/
		public var mouseHandler:Handler;
		/**指定是否可以选择，若值为true则可以选择，否则不可以选择。 @default false*/
		public var selectEnable:Boolean = false;
		/**最大分页数。*/
		public var totalPage:int = 0;
		
		/**@private */
		protected var _content:Box;
		/**@private */
		protected var _scrollBar:ScrollBar;
		/**@private */
		protected var _itemRender:*;
		/**@private */
		protected var _repeatX:int = 0;
		/**@private */
		protected var _repeatY:int = 0;
		/**@private */
		protected var _repeatX2:int = 0;
		/**@private */
		protected var _repeatY2:int = 0;
		/**@private */
		protected var _spaceX:int = 0;
		/**@private */
		protected var _spaceY:int = 0;
		/**@private */
		protected var _cells:Vector.<Box> = new Vector.<Box>();
		/**@private */
		protected var _array:Array;
		/**@private */
		protected var _startIndex:int = 0;
		/**@private */
		protected var _selectedIndex:int = -1;
		/**@private */
		protected var _page:int = 0;
		/**@private */
		protected var _isVertical:Boolean = true;
		/**@private */
		protected var _cellSize:Number = 20;
		/**@private */
		protected var _cellOffset:Number = 0;
		/**@private */
		protected var _isMoved:Boolean;
		/**是否缓存内容，如果数据源较少，并且list内无动画，设置此属性为true能大大提高性能 */
		public var cacheContent:Boolean;
		/**@private */
		protected var _createdLine:int = 0;
		/**@private */
		protected var _cellChanged:Boolean;
		/**@private */
		protected var _offset:Point = new Point();
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			_content && _content.destroy(destroyChild);
			_scrollBar && _scrollBar.destroy(destroyChild);
			super.destroy(destroyChild);
			_content = null;
			_scrollBar = null;
			_itemRender = null;
			_cells = null;
			_array = null;
			selectHandler = renderHandler = mouseHandler = null;
		}
		
		/**@inheritDoc */
		override protected function createChildren():void {
			addChild(_content = new Box());
		}
		
		/**@inheritDoc */
		override public function set cacheAs(value:String):void {
			super.cacheAs = value;
			if (_scrollBar) {
				this._$P.cacheAs = null;
				if (value !== "none") _scrollBar.on(Event.START, this, onScrollStart);
				else _scrollBar.off(Event.START, this, onScrollStart);
			}
		}
		
		private function onScrollStart():void {
			this._$P.cacheAs || (this._$P.cacheAs = super.cacheAs);
			super.cacheAs = "none";
			_scrollBar.once(Event.END, this, onScrollEnd);
		}
		
		private function onScrollEnd():void {
			super.cacheAs = this._$P.cacheAs;
		}
		
		/**
		 * 获取对 <code>List</code> 组件所包含的内容容器 <code>Box</code> 组件的引用。
		 */
		public function get content():Box {
			return _content;
		}
		
		/**
		 * 垂直方向滚动条皮肤。
		 */
		public function get vScrollBarSkin():String {
			return _scrollBar ? _scrollBar.skin : null;
		}
		
		public function set vScrollBarSkin(value:String):void {
			_removePreScrollBar();
			var scrollBar:VScrollBar = new VScrollBar();
			scrollBar.name = "scrollBar";
			scrollBar.right = 0;
			if (value && value != " ")
				scrollBar.skin = value;
			this.scrollBar = scrollBar;
			addChild(scrollBar);
			_setCellChanged();
		}
		
		private function _removePreScrollBar():void {
			var preNode:Node = removeChildByName("scrollBar");
			if (preNode) preNode.destroy(true);
		}
		
		/**
		 * 水平方向滚动条皮肤。
		 */
		public function get hScrollBarSkin():String {
			return _scrollBar ? _scrollBar.skin : null;
		}
		
		public function set hScrollBarSkin(value:String):void {
			_removePreScrollBar();
			var scrollBar:HScrollBar = new HScrollBar();
			scrollBar.name = "scrollBar";
			scrollBar.bottom = 0;
			if (value && value != " ")
				scrollBar.skin = value;
			this.scrollBar = scrollBar;
			addChild(scrollBar);
			_setCellChanged();
		}
		
		/**
		 * 获取对 <code>List</code> 组件所包含的滚动条 <code>ScrollBar</code> 组件的引用。
		 */
		public function get scrollBar():ScrollBar {
			return _scrollBar;
		}
		
		public function set scrollBar(value:ScrollBar):void {
			if (_scrollBar != value) {
				_scrollBar = value;
				if (value) {
					_isVertical = _scrollBar.isVertical;
					addChild(_scrollBar);
					_scrollBar.on(Event.CHANGE, this, onScrollBarChange);
				}
			}
		}
		
		/**
		 * 单元格渲染器。
		 * <p><b>取值：</b>
		 * <ol>
		 * <li>单元格类对象。</li>
		 * <li> UI 的 JSON 描述。</li>
		 * </ol></p>
		 */
		public function get itemRender():* {
			return _itemRender;
		}
		
		public function set itemRender(value:*):void {
			if (_itemRender != value) {
				_itemRender = value;
				//销毁老单元格
				for (var i:int = _cells.length - 1; i > -1; i--) {
					_cells[i].destroy();
				}
				_cells.length = 0;
				_setCellChanged();
			}
		}
		
		/**@inheritDoc */
		override public function set width(value:Number):void {
			if (value != _width) {
				super.width = value;
				_setCellChanged();
			}
		}
		
		/**@inheritDoc */
		override public function set height(value:Number):void {
			if (value != _height) {
				super.height = value;
				_setCellChanged();
			}
		}
		
		/**
		 * 水平方向显示的单元格数量。
		 */
		public function get repeatX():int {
			return _repeatX > 0 ? _repeatX : _repeatX2 > 0 ? _repeatX2 : 1;
		}
		
		public function set repeatX(value:int):void {
			_repeatX = value;
			_setCellChanged();
		}
		
		/**
		 * 垂直方向显示的单元格数量。
		 */
		public function get repeatY():int {
			return _repeatY > 0 ? _repeatY : _repeatY2 > 0 ? _repeatY2 : 1;
		}
		
		public function set repeatY(value:int):void {
			_repeatY = value;
			_setCellChanged();
		}
		
		/**
		 * 水平方向显示的单元格之间的间距（以像素为单位）。
		 */
		public function get spaceX():int {
			return _spaceX;
		}
		
		public function set spaceX(value:int):void {
			_spaceX = value;
			_setCellChanged();
		}
		
		/**
		 * 垂直方向显示的单元格之间的间距（以像素为单位）。
		 */
		public function get spaceY():int {
			return _spaceY;
		}
		
		public function set spaceY(value:int):void {
			_spaceY = value;
			_setCellChanged();
		}
		
		/**
		 * @private
		 * 更改单元格的信息。
		 * @internal 在此销毁、创建单元格，并设置单元格的位置等属性。相当于此列表内容发送改变时调用此函数。
		 */
		protected function changeCells():void {
			_cellChanged = false;
			if (_itemRender) {
				//获取滚动条
				scrollBar = getChildByName("scrollBar") as ScrollBar;
				
				//自适应宽高				
				var cell:Box = _getOneCell();
				
				var cellWidth:Number = (cell.width + _spaceX) || 1;
				var cellHeight:Number = (cell.height + _spaceY) || 1;
				if (_width > 0) _repeatX2 = _isVertical ? Math.round(_width / cellWidth) : Math.ceil(_width / cellWidth);
				if (_height > 0) _repeatY2 = _isVertical ? Math.ceil(_height / cellHeight) : Math.round(_height / cellHeight);
				
				var listWidth:Number = _width ? _width : (cellWidth * repeatX - _spaceX);
				var listHeight:Number = _height ? _height : (cellHeight * repeatY - _spaceY);
				_cellSize = _isVertical ? cellHeight : cellWidth;
				_cellOffset = _isVertical ? (cellHeight * Math.max(_repeatY2, _repeatY) - listHeight - _spaceY) : (cellWidth * Math.max(_repeatX2, _repeatX) - listWidth - _spaceX);
				
				if (_isVertical && _scrollBar) _scrollBar.height = listHeight;
				else if (!_isVertical && _scrollBar) _scrollBar.width = listWidth;
				setContentSize(listWidth, listHeight);
				
				//创建新单元格				
				var numX:int = _isVertical ? repeatX : repeatY;
				var numY:int = (_isVertical ? repeatY : repeatX) + (_scrollBar ? 1 : 0);
				_createItems(0, numX, numY);
				_createdLine = numY;
				
				if (_array) {
					array = _array;
					runCallLater(renderItems);
				}
			}
		}
		
		private function _getOneCell():Box {
			if (_cells.length === 0) {
				var item:Box = createItem();
				_offset.setTo(item.x, item.y);
				if (cacheContent) return item;
				_cells.push(item);
			}
			return _cells[0];
		}
		
		private function _createItems(startY:int, numX:int, numY:int):void {
			var box:Box = _content;
			var cell:Box = _getOneCell();
			var cellWidth:Number = cell.width + _spaceX;
			var cellHeight:Number = cell.height + _spaceY;
			
			if (cacheContent) {
				var cacheBox:Box = new Box();
				cacheBox.cacheAsBitmap = true;
				cacheBox.pos((_isVertical ? 0 : startY) * cellWidth, (_isVertical ? startY : 0) * cellHeight);
				_content.addChild(cacheBox);
				_content.optimizeScrollRect = true;
				box = cacheBox;
			} else {
				var arr:Array = [];
				for (var i:int = _cells.length - 1; i > -1; i--) {
					var item:Box = _cells[i];
					item.removeSelf();
					arr.push(item);
				}
				_cells.length = 0;
			}
			
			for (var k:int = startY; k < numY; k++) {
				for (var l:int = 0; l < numX; l++) {
					if (arr && arr.length) {
						cell = arr.pop();
					} else {
						cell = createItem();
					}
					cell.x = (_isVertical ? l : k) * cellWidth - box.x;
					cell.y = (_isVertical ? k : l) * cellHeight - box.y;
					cell.name = "item" + (k * numX + l);
					box.addChild(cell);
					addCell(cell);
				}
			}
		}
		
		protected function createItem():Box {
			var arr:Array = [];
			if (_itemRender is Function) {
				var box:View = new _itemRender();
			} else {
				box = View.createComp(_itemRender, null, null, arr)
			}
			if (arr.length == 0 && box._watchMap) {
				var watchMap:Object = box._watchMap;
				for (var name:String in watchMap) {
					var a:Array = watchMap[name];
					for (var i:int = 0; i < a.length; i++) {
						var watcher:* = a[i];
						arr.push(watcher.comp, watcher.prop, watcher.value)
					}
				}
			}
			if (arr.length) box["_$bindData"] = arr;
			return box;
		}
		
		/**
		 * @private
		 * 添加单元格。
		 * @param cell 需要添加的单元格对象。
		 */
		protected function addCell(cell:Box):void {
			cell.on(Event.CLICK, this, onCellMouse);
			cell.on(Event.RIGHT_CLICK, this, onCellMouse);
			cell.on(Event.MOUSE_OVER, this, onCellMouse);
			cell.on(Event.MOUSE_OUT, this, onCellMouse);
			cell.on(Event.MOUSE_DOWN, this, onCellMouse);
			cell.on(Event.MOUSE_UP, this, onCellMouse);
			_cells.push(cell);
		}
		
		/**
		 * 初始化单元格信息。
		 */
		public function initItems():void {
			if (!_itemRender && getChildByName("item0") != null) {
				repeatX = 1;
				var count:int;
				count = 0;
				for (var i:int = 0; i < 10000; i++) {
					var cell:Box = getChildByName("item" + i) as Box;
					if (cell) {
						addCell(cell);
						count++;
						continue;
					}
					break;
				}
				repeatY = count;
			}
		}
		
		/**
		 * 设置可视区域大小。
		 * <p>以（0，0，width参数，height参数）组成的矩形区域为可视区域。</p>
		 * @param width 可视区域宽度。
		 * @param height 可视区域高度。
		 */
		public function setContentSize(width:Number, height:Number):void {
			_content.width = width;
			_content.height = height;
			if (_scrollBar || _offset.x != 0 || _offset.y != 0) {
				_content.scrollRect || (_content.scrollRect = new Rectangle());
				_content.scrollRect.setTo( -_offset.x, -_offset.y, width, height);
				_content.scrollRect = _content.scrollRect;
			}
			event(Event.RESIZE);
		}
		
		/**
		 * @private
		 * 单元格的鼠标事件侦听处理函数。
		 */
		protected function onCellMouse(e:Event):void {
			if (e.type === Event.MOUSE_DOWN) _isMoved = false;
			var cell:Box = e.currentTarget as Box;
			var index:int = _startIndex + _cells.indexOf(cell);
			if (index < 0) return;
			if (e.type === Event.CLICK || e.type === Event.RIGHT_CLICK) {
				if (selectEnable && !_isMoved) selectedIndex = index;
				else changeCellState(cell, true, 0);
			} else if ((e.type === Event.MOUSE_OVER || e.type === Event.MOUSE_OUT) && _selectedIndex !== index) {
				changeCellState(cell, e.type === Event.MOUSE_OVER, 0);
			}
			mouseHandler && mouseHandler.runWith([e, index]);
		}
		
		/**
		 * @private
		 * 改变单元格的可视状态。
		 * @param cell 单元格对象。
		 * @param visable 是否显示。
		 * @param index 单元格的属性 <code>index</code> 值。
		 */
		protected function changeCellState(cell:Box, visable:Boolean, index:int):void {
			var selectBox:Clip = cell.getChildByName("selectBox") as Clip;
			if (selectBox) {
				selectEnable = true;
				selectBox.visible = visable;
				selectBox.index = index;
			}
		}
		
		/** @inheritDoc */
		override protected function changeSize():void {
			super.changeSize();
			setContentSize(this.width, this.height);
			if (_scrollBar) callLater(onScrollBarChange);
		}
		
		/**
		 * @private
		 * 滚动条的 <code>Event.CHANGE</code> 事件侦听处理函数。
		 */
		protected function onScrollBarChange(e:Event = null):void {
			runCallLater(changeCells);
			var scrollValue:Number = _scrollBar.value;
			var lineX:int = (_isVertical ? this.repeatX : this.repeatY);
			var lineY:int = (_isVertical ? this.repeatY : this.repeatX);
			var scrollLine:int = Math.floor(scrollValue / _cellSize);
			
			if (!cacheContent) {
				var index:int = scrollLine * lineX;
				var num:int = 0;
				if (index > _startIndex) {
					num = index - _startIndex;
					var down:Boolean = true;
					var toIndex:int = _startIndex + lineX * (lineY + 1);
					_isMoved = true;
				} else if (index < _startIndex) {
					num = _startIndex - index;
					down = false;
					toIndex = _startIndex - 1;
					_isMoved = true;
				}
				
				for (var i:int = 0; i < num; i++) {
					if (down) {
						var cell:Box = _cells.shift();
						_cells[_cells.length] = cell;
						var cellIndex:int = toIndex + i;
					} else {
						cell = _cells.pop();
						_cells.unshift(cell);
						cellIndex = toIndex - i;
					}
					var pos:Number = Math.floor(cellIndex / lineX) * _cellSize;
					_isVertical ? cell.y = pos : cell.x = pos;
					renderItem(cell, cellIndex);
				}
				_startIndex = index;
				changeSelectStatus();
			} else {
				num = (lineY + 1);
				if (_createdLine - scrollLine < num) {
					_createItems(_createdLine, lineX, _createdLine + num);
					renderItems(_createdLine * lineX, 0);
					_createdLine += num;
				}
			}
			
			var r:Rectangle = _content.scrollRect;
			if (_isVertical) {
				r.y = scrollValue - _offset.y;
				r.x = -_offset.x;
			} else {
				r.y = -_offset.y;
				r.x = scrollValue - _offset.x;
			}
			_content.scrollRect = r;
		}
		
		private function posCell(cell:Box, cellIndex:int):void {
			if (!_scrollBar) return;
			var lineX:int = (_isVertical ? this.repeatX : this.repeatY);
			var lineY:int = (_isVertical ? this.repeatY : this.repeatX);
			var pos:Number = Math.floor(cellIndex / lineX) * _cellSize;
			_isVertical ? cell.y = pos : cell.x = pos;
		}
		
		/**
		 * 表示当前选择的项索引。selectedIndex值更改会引起list重新渲染
		 */
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void {
			if (_selectedIndex != value) {
				_selectedIndex = value;
				changeSelectStatus();
				event(Event.CHANGE);
				selectHandler && selectHandler.runWith(value);
				//选择发生变化，自动渲染一次
				startIndex = _startIndex;
			}
		}
		
		/**
		 * @private
		 * 改变单元格的选择状态。
		 */
		protected function changeSelectStatus():void {
			for (var i:int = 0, n:int = _cells.length; i < n; i++) {
				changeCellState(_cells[i], _selectedIndex === _startIndex + i, 1);
			}
		}
		
		/**
		 * 当前选中的单元格数据源。
		 */
		public function get selectedItem():Object {
			return _selectedIndex != -1 ? _array[_selectedIndex] : null;
		}
		
		public function set selectedItem(value:Object):void {
			selectedIndex = _array.indexOf(value);
		}
		
		/**
		 * 获取或设置当前选择的单元格对象。
		 */
		public function get selection():Box {
			return getCell(_selectedIndex);
		}
		
		public function set selection(value:Box):void {
			selectedIndex = _startIndex + _cells.indexOf(value);
		}
		
		/**
		 * 当前显示的单元格列表的开始索引。
		 */
		public function get startIndex():int {
			return _startIndex;
		}
		
		public function set startIndex(value:int):void {
			_startIndex = value > 0 ? value : 0;
			callLater(renderItems);
		}
		
		/**
		 * @private
		 * 渲染单元格列表。
		 */
		protected function renderItems(from:int = 0, to:int = 0):void {
			for (var i:int = from, n:int = to || _cells.length; i < n; i++) {
				renderItem(_cells[i], _startIndex + i);
			}
			changeSelectStatus();
		}
		
		/**
		 * 渲染一个单元格。
		 * @param cell 需要渲染的单元格对象。
		 * @param index 单元格索引。
		 */
		protected function renderItem(cell:*, index:int):void {
			if (_array && index >= 0 && index < _array.length) {
				cell.visible = true;
				
				if (cell._$bindData) {
					cell._dataSource = _array[index];
					_bindData(cell, _array[index]);
				} else cell.dataSource = _array[index];
				
				if (!cacheContent) {
					//TODO:
					posCell(cell, index);
				}
				if (hasListener(Event.RENDER)) event(Event.RENDER, [cell, index]);
				if (renderHandler) renderHandler.runWith([cell, index]);
			} else {
				cell.visible = false;
				cell.dataSource = null;
			}
		}
		
		private function _bindData(cell:*, data:Object):void {
			var arr:Array = cell._$bindData;
			for (var i:int = 0, n:int = arr.length; i < n; i++) {
				var ele:* = arr[i++];
				var prop:String = arr[i++];
				var value:String = arr[i];
				var fun:Function = UIUtils.getBindFun(value);
				ele[prop] = fun.call(this, data);
			}
		}
		
		/**
		 * 列表数据源。
		 */
		public function get array():Array {
			return _array;
		}
		
		public function set array(value:Array):void {
			runCallLater(changeCells);
			_array = value || [];
			
			var length:int = _array.length;
			totalPage = Math.ceil(length / (repeatX * repeatY));
			//重设selectedIndex
			_selectedIndex = _selectedIndex < length ? _selectedIndex : length - 1;
			//重设startIndex
			startIndex = _startIndex;
			//重设滚动条
			if (_scrollBar) {
				_scrollBar.stopScroll();
				//自动隐藏滚动条
				var numX:int = _isVertical ? repeatX : repeatY;
				var numY:int = _isVertical ? repeatY : repeatX;
				var lineCount:int = Math.ceil(length / numX);
				var total:Number = _cellOffset > 0 ? totalPage + 1 : totalPage;
				if (total > 1) {
					_scrollBar.scrollSize = _cellSize;
					_scrollBar.thumbPercent = numY / lineCount;
					_scrollBar.setScroll(0, (lineCount - numY) * _cellSize + _cellOffset, _scrollBar.value);
					_scrollBar.target = _content;
				} else {
					_scrollBar.setScroll(0, 0, 0);
					_scrollBar.target = _content;
				}
			}
		}
		
		/**
		 * 列表的当前页码。
		 */
		public function get page():int {
			return _page;
		}
		
		public function set page(value:int):void {
			_page = value
			if (_array) {
				_page = value > 0 ? value : 0;
				_page = _page < totalPage ? _page : totalPage - 1;
				startIndex = _page * repeatX * repeatY;
			}
		}
		
		/**
		 * 列表的数据总个数。
		 */
		public function get length():int {
			return _array ? _array.length : 0;
		}
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			if (value is int || value is String) selectedIndex = parseInt(value);
			else if (value is Array) array = value as Array
			else super.dataSource = value;
		}
		
		/**
		 * 单元格集合。
		 */
		public function get cells():Vector.<Box> {
			runCallLater(changeCells);
			return _cells;
		}
		
		/**
		 * 刷新列表数据源。
		 */
		public function refresh():void {
			array = _array;
			//startIndex = _startIndex;
		}
		
		/**
		 * 获取单元格数据源。
		 * @param index 单元格索引。
		 */
		public function getItem(index:int):Object {
			if (index > -1 && index < _array.length) {
				return _array[index];
			}
			return null;
		}
		
		/**
		 * 修改单元格数据源。
		 * @param index 单元格索引。
		 * @param source 单元格数据源。
		 */
		public function changeItem(index:int, source:Object):void {
			if (index > -1 && index < _array.length) {
				_array[index] = source;
				//如果是可视范围，则重新渲染
				if (index >= _startIndex && index < _startIndex + _cells.length) {
					renderItem(getCell(index), index);
				}
			}
		}
		
		/**
		 * 设置单元格数据源。
		 * @param index 单元格索引。
		 * @param source 单元格数据源。
		 */
		public function setItem(index:int, source:Object):void {
			changeItem(index, source);
		}
		
		/**
		 * 添加单元格数据源。
		 * @param souce 数据源。
		 */
		public function addItem(souce:Object):void {
			_array.push(souce);
			array = _array;
		}
		
		/**
		 * 添加单元格数据源到对应的数据索引处。
		 * @param souce 单元格数据源。
		 * @param index 索引。
		 */
		public function addItemAt(souce:Object, index:int):void {
			_array.splice(index, 0, souce);
			array = _array;
		}
		
		/**
		 * 通过数据源索引删除单元格数据源。
		 * @param index 需要删除的数据源索引值。
		 */
		public function deleteItem(index:int):void {
			_array.splice(index, 1);
			array = _array;
		}
		
		/**
		 * 通过可视单元格索引，获取单元格。
		 * @param index 可视单元格索引。
		 * @return 单元格对象。
		 */
		public function getCell(index:int):Box {
			runCallLater(changeCells);
			if (index > -1 && _cells) {
				return _cells[(index - _startIndex) % _cells.length];
			}
			return null;
		}
		
		/**
		 * <p>滚动列表，以设定的数据索引对应的单元格为当前可视列表的第一项。</p>
		 * @param index 单元格在数据列表中的索引。
		 */
		public function scrollTo(index:int):void {
			if (_scrollBar) {
				var numX:int = _isVertical ? repeatX : repeatY;
				_scrollBar.value = Math.floor(index / numX) * _cellSize;
			} else {
				startIndex = index;
			}
		}
		
		/**
		 * <p>缓动滚动列表，以设定的数据索引对应的单元格为当前可视列表的第一项。</p>
		 * @param index 单元格在数据列表中的索引。
		 * @param time	缓动时间。
		 * @param complete	缓动结束回掉
		 */
		public function tweenTo(index:int, time:int = 200, complete:Handler = null):void {
			if (_scrollBar) {
				var numX:int = _isVertical ? repeatX : repeatY;
				Tween.to(_scrollBar, {value: Math.floor(index / numX) * _cellSize}, time, null, complete, 0, true);
			} else {
				startIndex = index;
				if (complete) complete.run();
			}
		}
		
		/**@private */
		protected function _setCellChanged():void {
			if (!_cellChanged) {
				_cellChanged = true;
				callLater(changeCells);
			}
		}
		
		override protected function commitMeasure():void {
			runCallLater(changeCells);
		}
	}
}