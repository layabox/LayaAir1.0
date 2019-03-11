package laya.ui {
	
	/**
	 * <code>Box</code> 类是一个控件容器类。
	 */
	public class Box extends UIComponent implements IBox {
		
		/**@inheritDoc */
		override public function set dataSource(value:*):void {
			_dataSource = value;
			for (var name:String in value) {
				var comp:UIComponent = getChildByName(name) as UIComponent;
				if (comp) comp.dataSource = value[name];
				else if (hasOwnProperty(name) && !(this[name] is Function)) this[name] = value[name];
			}
		}	
	}
}