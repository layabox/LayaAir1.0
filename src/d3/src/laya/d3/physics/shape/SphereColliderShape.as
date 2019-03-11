package laya.d3.physics.shape {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>SphereColliderShape</code> 类用于创建球形碰撞器。
	 */
	public class SphereColliderShape extends ColliderShape {
		/**@private */
		private var _radius:Number;
		
		/**
		 * 获取半径。
		 */
		public function get radius():Number {
			return _radius;
		}
		
		/**
		 * 创建一个新的 <code>SphereColliderShape</code> 实例。
		 * @param radius 半径。
		 */
		public function SphereColliderShape(radius:Number = 0.5) {//TODO:球形旋转无效，需要优化
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_radius = radius;
			_type = ColliderShape.SHAPETYPES_SPHERE;
			
			_nativeShape = new Laya3D._physics3D.btSphereShape(radius);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var dest:SphereColliderShape = new SphereColliderShape(_radius);
			cloneTo(dest);
			return dest;
		}
	
	}

}