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
			
		override public function set width(value:Number):void 
		{
			if (_width != value) {
				super.width = value;
				callLater(changeItems);
			}
		}
		/** @inheritDoc	*/
		override protected function changeItems():void {
			_itemChanged = false;
			var items:Array = [];
			var maxWidth:Number = 0;
			
			for (var i:int = 0, n:int = numChildren; i < n; i++) {
				var item:Component = getChildAt(i) as Component;
				if (item&&item.layoutEnabled) {
					items.push(item);
					maxWidth = _width?_width:Math.max(maxWidth, item.width * item.scaleX);
				}
			}
			
			sortItem(items);
			var top:Number = 0;
			for (i = 0, n = items.length; i < n; i++) {
				item = items[i];
				item.y = top;
				top += item.height * item.scaleY + _space;
				if (_align == LEFT) {
					item.x = 0;
				} else if (_align == CENTER) {
					item.x = (maxWidth - item.width * item.scaleX) * 0.5;
				} else if (_align == RIGHT) {
					item.x = maxWidth - item.width * item.scaleX;
				}
			}
			changeSize();
		}
	}
}