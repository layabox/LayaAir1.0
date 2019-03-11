package laya.d3.physics {
	import laya.d3.physics.PhysicsComponent;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>ContactPoint</code> 类用于创建物理碰撞信息。
	 */
	public class ContactPoint {
		/**@private */
		public var _idCounter:int = 0;
		
		/**@private */
		public var _id:int;
		
		/**碰撞器A。*/
		public var colliderA:PhysicsComponent = null;
		/**碰撞器B。*/
		public var colliderB:PhysicsComponent = null;
		/**距离。*/
		public var distance:Number = 0;
		/**法线。*/
		public var normal:Vector3 = new Vector3();
		/**碰撞器A的碰撞点。*/
		public var positionOnA:Vector3 = new Vector3();
		/**碰撞器B的碰撞点。*/
		public var positionOnB:Vector3 = new Vector3();
		
		/**
		 * 创建一个 <code>ContactPoint</code> 实例。
		 */
		public function ContactPoint() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_id = ++_idCounter;
		}
	
	}

}