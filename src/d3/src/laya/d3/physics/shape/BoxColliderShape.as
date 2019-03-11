package laya.d3.physics.shape {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>BoxColliderShape</code> 类用于创建盒子形状碰撞器。
	 */
	public class BoxColliderShape extends ColliderShape {
		/** @private */
		private static var _nativeSize:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		
		/**@private */
		private var _sizeX:Number;
		/**@private */
		private var _sizeY:Number;
		/**@private */
		private var _sizeZ:Number;
		
		/**
		 * 获取X轴尺寸。
		 */
		public function get sizeX():Number {
			return _sizeX;
		}
		
		/**
		 * 获取Y轴尺寸。
		 */
		public function get sizeY():Number {
			return _sizeY;
		}
		
		/**
		 * 获取Z轴尺寸。
		 */
		public function get sizeZ():Number {
			return _sizeZ;
		}
		
		/**
		 * 创建一个新的 <code>BoxColliderShape</code> 实例。
		 * @param sizeX 盒子X轴尺寸。
		 * @param sizeY 盒子Y轴尺寸。
		 * @param sizeZ 盒子Z轴尺寸。
		 */
		public function BoxColliderShape(sizeX:Number = 1.0, sizeY:Number = 1.0, sizeZ:Number = 1.0) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_sizeX = sizeX;
			_sizeY = sizeY;
			_sizeZ = sizeZ;
			_type = ColliderShape.SHAPETYPES_BOX;
			
			_nativeSize.setValue(sizeX / 2, sizeY / 2, sizeZ / 2);
			_nativeShape = new Laya3D._physics3D.btBoxShape(_nativeSize);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var dest:BoxColliderShape = new BoxColliderShape(_sizeX, _sizeY, _sizeZ);
			cloneTo(dest);
			return dest;
		}
	}

}