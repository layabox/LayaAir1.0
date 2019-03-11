package laya.d3.physics.shape {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>ConeColliderShape</code> 类用于创建圆柱碰撞器。
	 */
	public class ConeColliderShape extends ColliderShape {
		/**@private */
		private var _orientation:int;
		/**@private */
		private var _radius:Number = 1;
		/**@private */
		private var _height:Number = 0.5;
		
		/**
		 * 获取半径。
		 */
		public function get radius():Number {
			return _radius;
		}
		
		/**
		 * 获取高度。
		 */
		public function get height():Number {
			return _height;
		}
		
		/**
		 * 获取方向。
		 */
		public function get orientation():int {
			return _orientation;
		}
		
		/**
		 * 创建一个新的 <code>ConeColliderShape</code> 实例。
		 * @param height 高。
		 * @param radius 半径。
		 */
		public function ConeColliderShape(radius:Number = 0.5, height:Number = 1.0, orientation:int = ColliderShape.SHAPEORIENTATION_UPY) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_radius = radius;
			_height = height;
			_orientation = orientation;
			_type = ColliderShape.SHAPETYPES_CYLINDER;
			switch (orientation) {
			case ColliderShape.SHAPEORIENTATION_UPX: 
				_nativeShape = new Laya3D._physics3D.btConeShapeX(radius, height);
				break;
			case ColliderShape.SHAPEORIENTATION_UPY: 
				_nativeShape = new Laya3D._physics3D.btConeShape(radius, height);
				break;
			case ColliderShape.SHAPEORIENTATION_UPZ: 
				_nativeShape = new Laya3D._physics3D.btConeShapeZ(radius, height);
				break;
			default: 
				throw "ConeColliderShape:unknown orientation.";
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var dest:ConeColliderShape = new ConeColliderShape(_radius, _height, _orientation);
			cloneTo(dest);
			return dest;
		}
	
	}

}