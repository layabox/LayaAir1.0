package laya.ui {
	
	import laya.display.Node;
	import laya.events.Event;
	
	/**
	 * <code>LayoutBox</code> 是一个布局容器类。
	 */
	public class LayoutBox extends Box {
		/**@private */
		protected var _space:Number = 0;
		/**@private */
		protected var _align:String = "none";
		
		/**
		 * 创建一个新的 <code>LayoutBox</code> 类实例。
		 */
		public function LayoutBox() {
		}
		
		/** @inheritDoc	*/
		override public function addChild(child:Node):Node {
			child.on(Event.RESIZE, this, onResize);
			callLater(changeItems);
			return super.addChild(child);
		}
		
		private function onResize(e:Event):void {
			callLater(changeItems);
		}
		
		/** @inheritDoc	*/
		override public function addChildAt(child:Node, index:int):Node {
			child.on(Event.RESIZE, this, onResize);
			callLater(changeItems);
			return super.addChildAt(child, index);
		}
		
		/** @inheritDoc	*/
		override public function removeChild(child:Node):Node {
			child.off(Event.RESIZE, this, onResize);
			callLater(changeItems);
			return super.removeChild(child);
		}
		
		/** @inheritDoc	*/
		override public function removeChildAt(index:int):Node {
			getChildAt(index).off(Event.RESIZE, this, onResize);
			callLater(changeItems);
			return super.removeChildAt(index);
		}
		
		/** 刷新。*/
		public function refresh():void {
			callLater(changeItems);
		}
		
		/**
		 * 改变子对象的布局。
		 */
		protected function changeItems():void {
		}
		
		/** 子对象的间隔。*/
		public function get space():Number {
			return _space;
		}
		
		public function set space(value:Number):void {
			_space = value;
			callLater(changeItems);
		}
		
		/** 子对象对齐方式。*/
		public function get align():String {
			return _align;
		}
		
		public function set align(value:String):void {
			_align = value;
			callLater(changeItems);
		}
		
		/**
		 * 排序项目列表。可通过重写改变默认排序规则。
		 * @param items  项目列表。
		 */
		protected function sortItem(items:Array):void {
			if (items) items.sort(function(a:*, b:*):Number { return a.y > b.y ? 1 : -1
			});
		}
	}
}