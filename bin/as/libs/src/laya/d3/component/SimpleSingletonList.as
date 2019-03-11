package laya.d3.component {
	import laya.components.Component;
	import laya.resource.ISingletonElement;
	
	/**
	 * <code>SimpleSingletonList</code> 类用于实现单例队列。
	 */
	public class SimpleSingletonList extends SingletonList {
		/**
		 * 创建一个新的 <code>SimpleSingletonList</code> 实例。
		 */
		public function SimpleSingletonList() {
		}
		
		/**
		 * @private
		 */
		public function add(element:ISingletonElement):void {
			var index:int = element._getIndexInList();
			if (index !== -1)
				throw "SimpleSingletonList:"+element+" has  in  SingletonList.";
			_add(element);
			element._setIndexInList(length++);
		}
		
		/**
		 * @private
		 */
		public function remove(element:ISingletonElement):void {
			var index:int = element._getIndexInList();
			length--;
			if (index !== length) {
				var end:* = elements[length];
				elements[index] = end;
				end._setIndexInList(index);
			}
			element._setIndexInList(-1);
		}
	
	}

}