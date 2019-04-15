package laya.d3.core.scene {
	import laya.d3.component.SingletonList;
	
	/**
	 * <code>OctreeMotionList</code> 类用于实现物理更新队列。
	 */
	public class OctreeMotionList extends SingletonList {
		
		/**
		 * 创建一个新的 <code>OctreeMotionList</code> 实例。
		 */
		public function OctreeMotionList() {
		}
		
		/**
		 * @private
		 */
		public function add(element:IOctreeObject):void {
			var index:int = element._getIndexInMotionList();
			if (index !== -1)
				throw "OctreeMotionList:element has  in  PhysicsUpdateList.";
			_add(element);
			element._setIndexInMotionList(length++);
		}
		
		/**
		 * @private
		 */
		public function remove(element:IOctreeObject):void {
			var index:int = element._getIndexInMotionList();
			length--;
			if (index !== length) {
				var end:* = elements[length];
				elements[index] = end;
				end._inPhysicUpdateListIndex = index;
			}
			element._setIndexInMotionList(-1);
		}
	
	}

}