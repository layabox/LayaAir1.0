package laya.ui {
	import laya.events.Event;
	import laya.utils.Handler;
	
	/**
	 * 实例的 <code>selectedIndex</code> 属性发生变化时调度。
	 * @eventType laya.events.Event
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * <code>Tree</code> 控件使用户可以查看排列为可扩展树的层次结构数据。
	 *
	 * @example 以下示例代码，创建了一个 <code>Tree</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.ui.Tree;
	 *		import laya.utils.Browser;
	 *		import laya.utils.Handler;
	
	 *		public class Tree_Example
	 *		{
	
	 *			public function Tree_Example()
	 *			{
	 *				Laya.init(640, 800);
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png", "resource/ui/clip_selectBox.png", "resource/ui/clip_tree_folder.png", "resource/ui/clip_tree_arrow.png"], Handler.create(this, onLoadComplete));
	 *			}
	
	 *			private function onLoadComplete():void
	 *			{
	 *				var xmlString:String;//创建一个xml字符串，用于存储树结构数据。
	 *				xmlString = "&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
	 *				var domParser:* = new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
	 *				var xml:* = domParser.parseFromString(xmlString, "text/xml");//解析xml字符。
	
	 *				var tree:Tree = new Tree();//创建一个 Tree 类的实例对象 tree 。
	 *				tree.scrollBarSkin = "resource/ui/vscroll.png";//设置 tree 的皮肤。
	 *				tree.itemRender = Item;//设置 tree 的项渲染器。
	 *				tree.xml = xml;//设置 tree 的树结构数据。
	 *				tree.x = 100;//设置 tree 对象的属性 x 的值，用于控制 tree 对象的显示位置。
	 *				tree.y = 100;//设置 tree 对象的属性 y 的值，用于控制 tree 对象的显示位置。
	 *				tree.width = 200;//设置 tree 的宽度。
	 *				tree.height = 100;//设置 tree 的高度。
	 *				Laya.stage.addChild(tree);//将 tree 添加到显示列表。
	 *			}
	 *		}
	 *	}
	
	 * import laya.ui.Box;
	 * import laya.ui.Clip;
	 * import laya.ui.Label;
	 *	class Item extends Box
	 *	{
	 *		public function Item()
	 *		{
	 *			this.name = "render";
	 *			this.right = 0;
	 *			this.left = 0;
	
	 *			var selectBox:Clip = new Clip("resource/ui/clip_selectBox.png", 1, 2);
	 *			selectBox.name = "selectBox";
	 *			selectBox.height = 24;
	 *			selectBox.x = 13;
	 *			selectBox.y = 0;
	 *			selectBox.left = 12;
	 *			addChild(selectBox);
	
	 *			var folder:Clip = new Clip("resource/ui/clip_tree_folder.png", 1, 3);
	 *			folder.name = "folder";
	 *			folder.x = 14;
	 *			folder.y = 4;
	 *			addChild(folder);
	
	 *			var label:Label = new Label("treeItem");
	 *			label.name = "label";
	 *			label.color = "#ffff00";
	 *			label.width = 150;
	 *			label.height = 22;
	 *			label.x = 33;
	 *			label.y = 1;
	 *			label.left = 33;
	 *			label.right = 0;
	 *			addChild(label);
	
	 *			var arrow:Clip = new Clip("resource/ui/clip_tree_arrow.png", 1, 2);
	 *			arrow.name = "arrow";
	 *			arrow.x = 0;
	 *			arrow.y = 5;
	 *			addChild(arrow);
	 *		}
	 *	 }
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高、渲染模式
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
	 * var res = ["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png", "resource/ui/clip_selectBox.png", "resource/ui/clip_tree_folder.png", "resource/ui/clip_tree_arrow.png"];
	 * Laya.loader.load(res, new laya.utils.Handler(this, onLoadComplete));
	 * function onLoadComplete() {
	 *     var xmlString;//创建一个xml字符串，用于存储树结构数据。
	 *     xmlString = "&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
	 *     var domParser = new laya.utils.Browser.window.DOMParser();//创建一个DOMParser实例domParser。
	 *     var xml = domParser.parseFromString(xmlString, "text/xml");//解析xml字符。
	
	 *     var tree = new laya.ui.Tree();//创建一个 Tree 类的实例对象 tree 。
	 *     tree.scrollBarSkin = "resource/ui/vscroll.png";//设置 tree 的皮肤。
	 *     tree.itemRender = mypackage.treeExample.Item;//设置 tree 的项渲染器。
	 *     tree.xml = xml;//设置 tree 的树结构数据。
	 *     tree.x = 100;//设置 tree 对象的属性 x 的值，用于控制 tree 对象的显示位置。
	 *     tree.y = 100;//设置 tree 对象的属性 y 的值，用于控制 tree 对象的显示位置。
	 *     tree.width = 200;//设置 tree 的宽度。
	 *     tree.height = 100;//设置 tree 的高度。
	 *     Laya.stage.addChild(tree);//将 tree 添加到显示列表。
	 * }
	 * (function (_super) {
	 *     function Item() {
	 *         Item.__super.call(this);//初始化父类。
	 *         this.right = 0;
	 *         this.left = 0;
	
	 *         var selectBox = new laya.ui.Clip("resource/ui/clip_selectBox.png", 1, 2);
	 *         selectBox.name = "selectBox";//设置 selectBox 的name 为“selectBox”时，将被识别为树结构的项的背景。2帧：悬停时背景、选中时背景。
	 *         selectBox.height = 24;
	 *         selectBox.x = 13;
	 *         selectBox.y = 0;
	 *         selectBox.left = 12;
	 *         this.addChild(selectBox);//需要使用this.访问父类的属性或方法。
	
	 *         var folder = new laya.ui.Clip("resource/ui/clip_tree_folder.png", 1, 3);
	 *         folder.name = "folder";//设置 folder 的name 为“folder”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
	 *         folder.x = 14;
	 *         folder.y = 4;
	 *         this.addChild(folder);
	
	 *         var label = new laya.ui.Label("treeItem");
	 *         label.name = "label";//设置 label 的name 为“label”时，此值将用于树结构数据赋值。
	 *         label.color = "#ffff00";
	 *         label.width = 150;
	 *         label.height = 22;
	 *         label.x = 33;
	 *         label.y = 1;
	 *         label.left = 33;
	 *         label.right = 0;
	 *         this.addChild(label);
	
	 *         var arrow = new laya.ui.Clip("resource/ui/clip_tree_arrow.png", 1, 2);
	 *         arrow.name = "arrow";//设置 arrow 的name 为“arrow”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
	 *         arrow.x = 0;
	 *         arrow.y = 5;
	 *         this.addChild(arrow);
	 *     };
	 *     Laya.class(Item,"mypackage.treeExample.Item",_super);//注册类 Item 。
	 * })(laya.ui.Box);
	 * </listing>
	 * <listing version="3.0">
	 * import Tree = laya.ui.Tree;
	 * import Browser = laya.utils.Browser;
	 * import Handler = laya.utils.Handler;
	 * class Tree_Example {
	
	 *     constructor() {
	 *         Laya.init(640, 800);
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load(["resource/ui/vscroll.png", "resource/ui/vscroll$bar.png", "resource/ui/vscroll$down.png", "resource/ui/vscroll$up.png", "resource/ui/vscroll$up.png", "resource/ui/clip_selectBox.png", "resource/ui/clip_tree_folder * . * png", "resource/ui/clip_tree_arrow.png"], Handler.create(this, this.onLoadComplete));
	 *     }
	 *     private onLoadComplete(): void {
	 *         var xmlString: String;//创建一个xml字符串，用于存储树结构数据。
	 *         xmlString = "&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc  * label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
	 *         var domParser: any = new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
	 *         var xml: any = domParser.parseFromString(xmlString, "text/xml");//解析xml字符。
	
	 *         var tree: Tree = new Tree();//创建一个 Tree 类的实例对象 tree 。
	 *         tree.scrollBarSkin = "resource/ui/vscroll.png";//设置 tree 的皮肤。
	 *         tree.itemRender = Item;//设置 tree 的项渲染器。
	 *         tree.xml = xml;//设置 tree 的树结构数据。
	 *         tree.x = 100;//设置 tree 对象的属性 x 的值，用于控制 tree 对象的显示位置。
	 *         tree.y = 100;//设置 tree 对象的属性 y 的值，用于控制 tree 对象的显示位置。
	 *         tree.width = 200;//设置 tree 的宽度。
	 *         tree.height = 100;//设置 tree 的高度。
	 *         Laya.stage.addChild(tree);//将 tree 添加到显示列表。
	 *     }
	 * }
	 * import Box = laya.ui.Box;
	 * import Clip = laya.ui.Clip;
	 * import Label = laya.ui.Label;
	 * class Item extends Box {
	 *     constructor() {
	 *         super();
	 *         this.name = "render";
	 *         this.right = 0;
	 *         this.left = 0;
	 *         var selectBox: Clip = new Clip("resource/ui/clip_selectBox.png", 1, 2);
	 *         selectBox.name = "selectBox";
	 *         selectBox.height = 24;
	 *         selectBox.x = 13;
	 *         selectBox.y = 0;
	 *         selectBox.left = 12;
	 *         this.addChild(selectBox);
	
	 *         var folder: Clip = new Clip("resource/ui/clip_tree_folder.png", 1, 3);
	 *         folder.name = "folder";
	 *         folder.x = 14;
	 *         folder.y = 4;
	 *         this.addChild(folder);
	
	 *         var label: Label = new Label("treeItem");
	 *         label.name = "label";
	 *         label.color = "#ffff00";
	 *         label.width = 150;
	 *         label.height = 22;
	 *         label.x = 33;
	 *         label.y = 1;
	 *         label.left = 33;
	 *         label.right = 0;
	 *         this.addChild(label);
	
	 *         var arrow: Clip = new Clip("resource/ui/clip_tree_arrow.png", 1, 2);
	 *         arrow.name = "arrow";
	 *         arrow.x = 0;
	 *         arrow.y = 5;
	 *         this.addChild(arrow);
	 *     }
	 * }
	 * </listing>
	 */
	public class Tree extends Box implements IRender {
		/**@private */
		protected var _list:List;
		/**@private */
		protected var _source:Array;
		/**@private */
		protected var _renderHandler:Handler;
		/**@private */
		protected var _spaceLeft:Number = 10;
		/**@private */
		protected var _spaceBottom:Number = 0;
		/**@private */
		protected var _keepStatus:Boolean = true;
		
		/**
		 * 创建一个新的 <code>Tree</code> 类实例。
		 * <p>在 <code>Tree</code> 构造函数中设置属性width、height的值都为200。</p>
		 */
		public function Tree() {
			width = height = 200;
		}
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_list && _list.destroy(destroyChild);
			_list = null;
			_source = null;
			_renderHandler = null;
		}
		
		/**@inheritDoc */
		override protected function createChildren():void {
			addChild(_list = new List());
			_list.renderHandler = Handler.create(this, renderItem, null, false);
			_list.repeatX = 1;
			_list.on(Event.CHANGE, this, onListChange);
		}
		
		/**
		 * @private
		 * 此对象包含的<code>List</code>实例的<code>Event.CHANGE</code>事件侦听处理函数。
		 */
		protected function onListChange(e:Event=null):void {
			event(Event.CHANGE);
		}
		
		/**
		 * 数据源发生变化后，是否保持之前打开状态，默认为true。
		 * <p><b>取值：</b>
		 * <li>true：保持之前打开状态。</li>
		 * <li>false：不保持之前打开状态。</li>
		 * </p>
		 */
		public function get keepStatus():Boolean {
			return _keepStatus;
		}
		
		public function set keepStatus(value:Boolean):void {
			_keepStatus = value;
		}
		
		/**
		 * 列表数据源，只包含当前可视节点数据。
		 */
		public function get array():Array {
			return _list.array;
		}
		
		public function set array(value:Array):void {
			if (_keepStatus && _list.array && value) {
				parseOpenStatus(_list.array, value);
			}
			_source = value;
			_list.array = getArray();
		}
		
		/**
		 * 数据源，全部节点数据。
		 */
		public function get source():Array {
			return _source;
		}
		
		/**
		 * 此对象包含的<code>List</code>实例对象。
		 */
		public function get list():List {
			return _list;
		}
		
		/**
		 * 此对象包含的<code>List</code>实例的单元格渲染器。
		 * <p><b>取值：</b>
		 * <ol>
		 * <li>单元格类对象。</li>
		 * <li> UI 的 JSON 描述。</li>
		 * </ol></p>
		 */
		public function get itemRender():* {
			return _list.itemRender;
		}
		
		public function set itemRender(value:*):void {
			_list.itemRender = value;
		}
		
		/**
		 * 滚动条皮肤。
		 */
		public function get scrollBarSkin():String {
			return _list.vScrollBarSkin;
		}
		
		public function set scrollBarSkin(value:String):void {
			_list.vScrollBarSkin = value;
		}
		
		/**滚动条*/
		public function get scrollBar():ScrollBar {
			return _list.scrollBar;
		}
		
		/**
		 * 单元格鼠标事件处理器。
		 * <p>默认返回参数（e:Event,index:int）。</p>
		 */
		public function get mouseHandler():Handler {
			return _list.mouseHandler;
		}
		
		public function set mouseHandler(value:Handler):void {
			_list.mouseHandler = value;
		}
		
		/**
		 * <code>Tree</code> 实例的渲染处理器。
		 */
		public function get renderHandler():Handler {
			return _renderHandler;
		}
		
		public function set renderHandler(value:Handler):void {
			_renderHandler = value;
		}
		
		/**
		 * 左侧缩进距离（以像素为单位）。
		 */
		public function get spaceLeft():Number {
			return _spaceLeft;
		}
		
		public function set spaceLeft(value:Number):void {
			_spaceLeft = value;
		}
		
		/**
		 * 每一项之间的间隔距离（以像素为单位）。
		 */
		public function get spaceBottom():Number {
			return _list.spaceY;
		}
		
		public function set spaceBottom(value:Number):void {
			_list.spaceY = value;
		}
		
		/**
		 * 表示当前选择的项索引。
		 */
		public function get selectedIndex():int {
			return _list.selectedIndex;
		}
		
		public function set selectedIndex(value:int):void {
			_list.selectedIndex = value;
		}
		
		/**
		 * 当前选中的项对象的数据源。
		 */
		public function get selectedItem():Object {
			return _list.selectedItem;
		}
		
		public function set selectedItem(value:Object):void {
			_list.selectedItem = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void {
			super.width = value;
			_list.width = value;
		}
		
		/**@inheritDoc */
		override public function set height(value:Number):void {
			super.height = value;
			_list.height = value;
		}
		
		/**
		 * @private
		 * 获取数据源集合。
		 */
		protected function getArray():Array {
			var arr:Array = [];
			for each (var item:Object in _source) {
				if (getParentOpenStatus(item)) {
					item.x = _spaceLeft * getDepth(item);
					arr.push(item);
				}
			}
			return arr;
		}
		
		/**
		 * @private
		 * 获取项对象的深度。
		 */
		protected function getDepth(item:Object, num:int = 0):int {
			if (item.nodeParent == null) return num;
			else return getDepth(item.nodeParent, num + 1);
		}
		
		/**
		 * @private
		 * 获取项对象的上一级的打开状态。
		 */
		protected function getParentOpenStatus(item:Object):Boolean {
			var parent:Object = item.nodeParent;
			if (parent == null) {
				return true;
			} else {
				if (parent.isOpen) {
					if (parent.nodeParent != null) return getParentOpenStatus(parent);
					else return true;
				} else {
					return false;
				}
			}
		}
		
		/**
		 * @private
		 * 渲染一个项对象。
		 * @param cell 一个项对象。
		 * @param index 项的索引。
		 */
		protected function renderItem(cell:Box, index:int):void {
			var item:Object = cell.dataSource;
			if (item) {
				cell.left = item.x;
				var arrow:Clip = cell.getChildByName("arrow") as Clip;
				if (arrow) {
					if (item.hasChild) {
						arrow.visible = true;
						arrow.index = item.isOpen ? 1 : 0;
						arrow.tag = index;
						arrow.off(Event.CLICK, this, onArrowClick);
						arrow.on(Event.CLICK, this, onArrowClick);
					} else {
						arrow.visible = false;
					}
				}
				var folder:Clip = cell.getChildByName("folder") as Clip;
				if (folder) {
					if (folder.clipY == 2) {
						folder.index = item.isDirectory ? 0 : 1;
					} else {
						folder.index = item.isDirectory ? item.isOpen ? 1 : 0 : 2;
					}
				}
				_renderHandler && _renderHandler.runWith([cell, index]);
			}
		}
		
		/**
		 * @private
		 */
		private function onArrowClick(e:Event):void {
			var arrow:Clip = e.currentTarget as Clip;
			var index:int = arrow.tag;
			_list.array[index].isOpen = !_list.array[index].isOpen;
			_list.array = getArray();
		}
		
		/**
		 * 设置指定项索引的项对象的打开状态。
		 * @param index 项索引。
		 * @param isOpen 是否处于打开状态。
		 */
		public function setItemState(index:int, isOpen:Boolean):void {
			if (!_list.array[index]) return;
			_list.array[index].isOpen = isOpen;
			_list.array = getArray();
		}
		
		/**
		 * 刷新项列表。
		 */
		public function fresh():void {
			_list.array = getArray();
			repaint();
		}
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			//if (value is XmlDom) xml = value as XmlDom;
			super.dataSource = value;
		}
		
		/**
		 *  xml结构的数据源。
		 */
		public function set xml(value:XmlDom):void {
			var arr:Array = [];
			parseXml(value.childNodes[0], arr, null, true);
			
			array = arr;
		}
		
		/**
		 * @private
		 * 解析并处理XML类型的数据源。
		 */
		protected function parseXml(xml:XmlDom, source:Array, nodeParent:Object, isRoot:Boolean):void {
			var obj:Object;
			var list:Array = xml.childNodes;
			var childCount:int = list.length;
			if (!isRoot) {
				obj = {};
				var list2:Object = xml.attributes;
				for each (var attrs:XmlDom in list2) {
					var prop:String = attrs.nodeName;
					var value:String = attrs.nodeValue;
					obj[prop] = value == "true" ? true : value == "false" ? false : value;
				}
				obj.nodeParent = nodeParent;
				if (childCount > 0) obj.isDirectory = true;
				obj.hasChild = childCount > 0;
				source.push(obj);
			}
			for (var i:int = 0; i < childCount; i++) {
				var node:XmlDom = list[i];
				parseXml(node, source, obj, false);
			}
		}
		
		/**
		 * @private
		 * 处理数据项的打开状态。
		 */
		protected function parseOpenStatus(oldSource:Array, newSource:Array):void {
			for (var i:int = 0, n:int = newSource.length; i < n; i++) {
				var newItem:Object = newSource[i];
				if (newItem.isDirectory) {
					for (var j:int = 0, m:int = oldSource.length; j < m; j++) {
						var oldItem:Object = oldSource[j];
						if (oldItem.isDirectory && isSameParent(oldItem, newItem) && newItem.label == oldItem.label) {
							newItem.isOpen = oldItem.isOpen;
							break;
						}
					}
				}
			}
		}
		
		/**
		 * @private
		 * 判断两个项对象在树结构中的父节点是否相同。
		 * @param item1 项对象。
		 * @param item2 项对象。
		 * @return 如果父节点相同值为true，否则值为false。
		 */
		protected function isSameParent(item1:Object, item2:Object):Boolean {
			if (item1.nodeParent == null && item2.nodeParent == null) return true;
			else if (item1.nodeParent == null || item2.nodeParent == null) return false
			else {
				if (item1.nodeParent.label == item2.nodeParent.label) return isSameParent(item1.nodeParent, item2.nodeParent);
				else return false;
			}
		}
		
		/**
		 * 表示选择的树节点项的<code>path</code>属性值。
		 */
		public function get selectedPath():String {
			if (_list.selectedItem) {
				return _list.selectedItem.path;
			}
			return null;
		}
		
		/**
		 * 更新项列表，显示指定键名的数据项。
		 * @param	key 键名。
		 */
		public function filter(key:String):void {
			if (Boolean(key)) {
				var result:Array = [];
				getFilterSource(_source, result, key);
				_list.array = result;
			} else {
				_list.array = getArray();
			}
		}
		
		/**
		 * @private
		 * 获取数据源中指定键名的值。
		 */
		private function getFilterSource(array:Array, result:Array, key:String):void {
			key = key.toLocaleLowerCase();
			for each (var item:Object in array) {
				if (!item.isDirectory && String(item.label).toLowerCase().indexOf(key) > -1) {
					item.x = 0;
					result.push(item);
				}
				if (item.child && item.child.length > 0) {
					getFilterSource(item.child, result, key);
				}
			}
		}
	}
}