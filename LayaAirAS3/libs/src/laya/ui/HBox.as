package laya.ui{
	
	/**HBox容器*/
	public class HBox extends LayoutBox {
		public static const NONE:String = "none";
		public static const TOP:String = "top";
		public static const MIDDLE:String = "middle";
		public static const BOTTOM:String = "bottom";
		
		public function HBox() {
		}
		override protected function sortItem(items:Array):void 
		{
			if(items) items.sort(function(a:*, b:*):Number { return a.x > b.x ? 1 : -1});
		}
		override protected function changeItems():void {
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