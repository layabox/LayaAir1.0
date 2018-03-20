package laya.ui {
	
	/**
	 * <code>HBox</code> 是一个水平布局容器类。
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
		
		/** @inheritDoc	*/
		override protected function sortItem(items:Array):void {
			if (items) items.sort(function(a:*, b:*):Number { return a.x - b.x;});
		}
		
		override public function set height(value:Number):void 
		{
			if (_height != value) {
				super.height = value;
				callLater(changeItems);
			}
		}
		
		/** @inheritDoc	*/
		override protected function changeItems():void {
			_itemChanged = false;
			var items:Array = [];
			var maxHeight:Number = 0;
			for (var i:int = 0, n:int = numChildren; i < n; i++) {
				var item:Component = getChildAt(i) as Component;
				if (item&&item.layoutEnabled) {
					items.push(item);
					maxHeight = _height?_height:Math.max(maxHeight, item.height * item.scaleY);
				}
			}
			sortItem(items);
			var left:Number = 0;
			for (i = 0, n = items.length; i < n; i++) {
				item = items[i];
				item.x = left;
				left += item.width * item.scaleX + _space;
				if (_align == TOP) {
					item.y = 0;
				} else if (_align == MIDDLE) {
					item.y = (maxHeight - item.height * item.scaleY) * 0.5;
				} else if (_align == BOTTOM) {
					item.y = maxHeight - item.height * item.scaleY;
				}
			}
			changeSize();
		}
	}
}