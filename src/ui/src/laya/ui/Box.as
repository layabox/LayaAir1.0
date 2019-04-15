package laya.ui {
	import laya.events.Event;
	
	/**
	 * <code>Box</code> 类是一个控件容器类。
	 */
	public class Box extends UIComponent implements IBox {
		private var _bgColor:String;
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			for (var name:String in value) {
				var comp:UIComponent = getChildByName(name) as UIComponent;
				if (comp) comp.dataSource = value[name];
				else if (hasOwnProperty(name) && !(this[name] is Function)) this[name] = value[name];
			}
		}
		
		/**背景颜色*/
		public function get bgColor():String {
			return _bgColor;
		}
		
		public function set bgColor(value:String):void {
			_bgColor = value;
			if (value) {
				_onResize(null);
				on(Event.RESIZE, this, _onResize);
			} else {
				this.graphics.clear();
				off(Event.RESIZE, this, _onResize);
			}
		}
		
		private function _onResize(e:Event):void {
			this.graphics.clear();
			this.graphics.drawRect(0, 0, this.width, this.height, _bgColor);
		}
	}
}