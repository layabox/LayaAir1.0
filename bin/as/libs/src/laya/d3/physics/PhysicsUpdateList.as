package laya.d3.physics {
	import laya.d3.component.SimpleSingletonList;
	import laya.d3.component.SingletonList;
	import laya.d3.core.render.BaseRender;
	import laya.resource.ISingletonElement;
	
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
	
	}

}