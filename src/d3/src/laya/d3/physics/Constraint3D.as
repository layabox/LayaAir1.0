package laya.d3.physics {
	import laya.d3.physics.PhysicsSimulation;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Constraint3D {
		/**@private */
		public var _nativeConstraint:*;
		/**@private */
		public var _simulation:PhysicsSimulation;
		
		/**获取刚体A。[只读]*/
		public var rigidbodyA:Rigidbody3D;
		/**获取刚体A。[只读]*/
		public var rigidbodyB:Rigidbody3D;
		
		public function Constraint3D() {
		
		}
	
	}

}