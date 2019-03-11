package laya.d3.physics.shape {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>StaticPlaneColliderShape</code> 类用于创建静态平面碰撞器。
	 */
	public class StaticPlaneColliderShape extends ColliderShape {
		/** @private */
		private static var _nativeNormal:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		
		/**@private */
		public var _offset:Number;
		/**@private */
		public var _normal:Vector3;
		
		/**
		 * 创建一个新的 <code>StaticPlaneColliderShape</code> 实例。
		 */
		public function StaticPlaneColliderShape(normal:Vector3, offset:Number) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_normal = normal;
			_offset = offset;
			_type = ColliderShape.SHAPETYPES_STATICPLANE;
			
			_nativeNormal.setValue(-normal.x, normal.y, normal.z);
			_nativeShape = new Laya3D._physics3D.btStaticPlaneShape(_nativeNormal, offset);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var dest:StaticPlaneColliderShape = new StaticPlaneColliderShape(_normal,_offset);
			cloneTo(dest);
			return dest;
		}
	
	}

}