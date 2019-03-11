package laya.d3.component {
	import laya.components.Component;
	import laya.resource.ISingletonElement;
	
	/**
	 * <code>SingletonList</code> 类用于实现单例队列。
	 */
	public class SingletonList {
		/**@private [只读]*/
		public var elements:Vector.<ISingletonElement> = new Vector.<ISingletonElement>();
		/** @private [只读]*/
		public var length:int = 0;
		
		/**
		 * 创建一个新的 <code>SingletonList</code> 实例。
		 */
		public function SingletonList() {
		}
		
		/**
		 * @private
		 */
		protected function _add(element:*):void {
			if (length === elements.length)
				elements.push(element);
			else
				elements[length] = element;
		}
	
	}

}