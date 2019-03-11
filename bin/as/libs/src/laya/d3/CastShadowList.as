package laya.d3 {
	import laya.d3.component.SimpleSingletonList;
	import laya.d3.component.SingletonList;
	import laya.d3.core.render.BaseRender;
	import laya.resource.ISingletonElement;
	
	/**
	 * <code>CastShadowList</code> 类用于实现产生阴影者队列。
	 */
	public class CastShadowList extends SingletonList {
		
		/**
		 * 创建一个新的 <code>CastShadowList</code> 实例。
		 */
		public function CastShadowList() {
		}
		
		/**
		 * @private
		 */
		public function add(element:BaseRender):void {
			var index:int = element._indexInCastShadowList;
			if (index !== -1)
				throw "CastShadowList:element has  in  CastShadowList.";
			_add(element);
			element._indexInCastShadowList = length++;
		}
		
		/**
		 * @private
		 */
		public function remove(element:BaseRender):void {
			var index:int = element._indexInCastShadowList;
			length--;
			if (index !== length) {
				var end:* = elements[length];
				elements[index] = end;
				end._indexInCastShadowList = index;
			}
			element._indexInCastShadowList = -1;
		}
	
	}

}