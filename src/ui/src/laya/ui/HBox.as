package laya.ui {
	
	/**
	 * <code>VBox</code> 是一个垂直布局容器类。
	 */
	public class HBox extends LayoutBox {
		/**
		 * 无对齐。
		 */
		public static const NONE:String = "none";
		/**
		 * 居顶部对齐。
		 */
		public static const TOP:String = "top";
		/**
		 * 居中对齐。
		 */
		public static const MIDDLE:String = "middle";
		/**
		 * 居底部对齐。
		 */
		public static const BOTTOM:String = "bottom";
		
		/**
		 * 创建一个新的 <code>HBox</code> 类实例。
		 */
		public function HBox() {
		}
		
		/** @inheritDoc	*/
		override protected function sortItem(items:Array):void {
			if (items) items.sort(function(a:*, b:*):Number { return a.x > b.x ? 1 : -1
			});
		}
		
		/** @inheritDoc	*/
		override protected function changeItems():void {
			_itemChanged = false;
			var items:Array = [];
			var maxHeight:Number = 0;
			for (var i:int = 0, n:int = numChildren; i < n; i++) {
				var item:Component = getChildAt(i) as Component;
				if (item) {
					items.push(item);
					maxHeight = Math.max(maxHeight, item.displayHeight);
				}
			}
			
			//items.sortOn(["x"], Array.NUMERIC);
			sortItem(items);
			var left:Number = 0;
			for each (item in items) {
				item.x = left;
				left += item.displayWidth + _space;
				if (_align == TOP) {
					item.y = 0;
				} else if (_align == MIDDLE) {
					item.y = (maxHeight - item.displayHeight) * 0.5;
				} else if (_align == BOTTOM) {
					item.y = maxHeight - item.displayHeight;
				}
			}
			changeSize();
		}
	}
}