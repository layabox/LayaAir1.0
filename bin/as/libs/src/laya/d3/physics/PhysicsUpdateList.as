package laya.d3.physics {
	import laya.d3.component.SingletonList;
	
	/**
	 * <code>PhysicsUpdateList</code> 类用于实现物理更新队列。
	 */
	public class PhysicsUpdateList extends SingletonList {
		
		/**
		 * 创建一个新的 <code>PhysicsUpdateList</code> 实例。
		 */
		public function PhysicsUpdateList() {
		}
		
		/**
		 * @private
		 */
		public function add(element:PhysicsComponent):void {
			var index:int = element._inPhysicUpdateListIndex;
			if (index !== -1)
				throw "PhysicsUpdateList:element has  in  PhysicsUpdateList.";
			_add(element);
			element._inPhysicUpdateListIndex = length++;
		}
		
		/**
		 * @private
		 */
		public function remove(element:PhysicsComponent):void {
			var index:int = element._inPhysicUpdateListIndex;
			length--;
			if (index !== length) {
				var end:* = elements[length];
				elements[index] = end;
				end._inPhysicUpdateListIndex = index;
			}
			element._inPhysicUpdateListIndex = -1;
		}
	
	}

}