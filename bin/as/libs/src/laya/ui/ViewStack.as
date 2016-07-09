/**
 * Morn UI Version 3.0 http://www.mornui.com/
 * Feedback yung http://weibo.com/newyung
 */
package laya.ui {
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.ui.Box;
	import laya.utils.Handler;
	
	/**
	 * <code>ViewStack</code> 类用于视图堆栈类，用于视图的显示等设置处理。
	 */
	public class ViewStack extends Box implements IItem {
		/**@private */
		protected var _items:Array;
		/**@private */
		protected var _setIndexHandler:Handler = Handler.create(this, setIndex, null, false);
		/**@private */
		protected var _selectedIndex:int;
		
		/**
		 * 批量设置视图对象。
		 * @param views 视图对象数组。
		 */
		public function setItems(views:Array):void {
			removeChildren();
			var index:int = 0;
			for (var i:int = 0, n:int = views.length; i < n; i++) {
				var item:Node = views[i];
				if (item) {
					item.name = "item" + index;
					addChild(item);
					index++;
				}
			}
			initItems();
		}
		
		/**
		 * 添加视图。
		 * @internal 添加视图对象，并设置此视图对象的<code>name</code> 属性。
		 * @param view 需要添加的视图对象。
		 */
		public function addItem(view:Node):void {
			view.name = "item" + _items.length;
			addChild(view);
			initItems();
		}
		
		/**
		 * 初始化视图对象集合。
		 */
		public function initItems():void {
			_items = [];
			for (var i:int = 0; i < 10000; i++) {
				var item:Sprite = getChildByName("item" + i) as Sprite;
				if (item == null) {
					break;
				}
				_items.push(item);
				item.visible = (i == _selectedIndex);
			}
		}
		
		/**
		 * 表示当前视图索引。
		 */
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void {
			if (_selectedIndex != value) {
				setSelect(_selectedIndex, false);
				_selectedIndex = value;
				setSelect(_selectedIndex, true);
			}
		}
		
		/**
		 * @private
		 * 通过对象的索引设置项对象的 <code>selected</code> 属性值。
		 * @param index 需要设置的对象的索引。
		 * @param selected 表示对象的选中状态。
		 */
		protected function setSelect(index:int, selected:Boolean):void {
			if (_items && index > -1 && index < _items.length) {
				_items[index].visible = selected;
			}
		}
		
		/**
		 * 获取或设置当前选择的项对象。
		 */
		public function get selection():Node {
			return _selectedIndex > -1 && _selectedIndex < _items.length ? _items[_selectedIndex] : null;
		}
		
		public function set selection(value:Node):void {
			selectedIndex = _items.indexOf(value);
		}
		
		/**
		 *  索引设置处理器。
		 * <p>默认回调参数：index:int</p>
		 */
		public function get setIndexHandler():Handler {
			return _setIndexHandler;
		}
		
		public function set setIndexHandler(value:Handler):void {
			_setIndexHandler = value;
		}
		
		/**
		 * @private
		 * 设置属性<code>selectedIndex</code>的值。
		 * @param index 选中项索引值。
		 */
		protected function setIndex(index:int):void {
			selectedIndex = index;
		}
		
		/**
		 * 视图集合数组。
		 */
		public function get items():Array {
			return _items;
		}
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			if (value is int || value is String) {
				selectedIndex = parseInt(value);
			} else {
				for (var prop:String in _dataSource) {
					if (hasOwnProperty(prop)) {
						this[prop] = _dataSource[prop];
					}
				}
			}
		}
	}
}