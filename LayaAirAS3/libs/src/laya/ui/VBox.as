package laya.ui{
	
	/**VBox容器*/
	public class VBox extends LayoutBox {
		public static const NONE:String = "none";
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		public static const RIGHT:String = "right";
		
		public function VBox() {
		}
		
		override protected function changeItems():void {
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