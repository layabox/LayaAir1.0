package laya.ui {
	
	/**
	 * <code>VBox</code> 是一个垂直布局容器类。
	 */
	public class VBox extends LayoutBox {
		/**
		 * 无对齐。
		 */
		public static const NONE:String = "none";
		/**
		 * 左对齐。
		 */
		public static const LEFT:String = "left";
		/**
		 * 居中对齐。
		 */
		public static const CENTER:String = "center";
		/**
		 * 右对齐。
		 */
		public static const RIGHT:String = "right";
		
		/**
		 * 创建一个新的 <code>VBox</code> 类实例。
		 */
		public function VBox() {
		}
		
		/** @inheritDoc	*/
		override protected function changeItems():void {
			_itemChanged = false;
			var items:Array = [];
			var maxWidth:Number = 0;
			for (var i:int = 0, n:int = numChildren; i < n; i++) {
				var item:Component = getChildAt(i) as Component;
				if (item) {
					items.push(item);
					maxWidth = Math.max(maxWidth, item.displayWidth);
				}
			}
			
			sortItem(items);//	items.sortOn(["y"], Array.NUMERIC);
			var top:Number = 0;
			for each (item in items) {
				item.y = top;
				top += item.displayHeight + _space;
				if (_align == LEFT) {
					item.x = 0;
				} else if (_align == CENTER) {
					item.x = (maxWidth - item.displayWidth) * 0.5;
				} else if (_align == RIGHT) {
					item.x = maxWidth - item.displayWidth;
				}
			}
			changeSize();
		}
	}
}