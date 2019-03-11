package laya.d3.physics.shape {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.utils.Utils3D;
	
	/**
	 * <code>MeshColliderShape</code> 类用于创建网格碰撞器。
	 */
	public class MeshColliderShape extends ColliderShape {
		/**@private */
		private var _mesh:Mesh = null;
		/**@private */
		private var _convex:Boolean = false;
		
		///**@private */
		//public var localOffset:Vector3 = new Vector3(0, 0, 0);
		///**@private */
		//public var localRotation:Quaternion = new Quaternion(0, 0, 0, 1);
		///**@private */
		//public var simpleWrap:Boolean = true;
		///**@private */
		//public var scaling:Vector3 = new Vector3(1, 1, 1);
		///**@private */
		//public var depth:int = 10;
		///**@private */
		//public var posSampling:int = 10;
		///**@private */
		//public var angleSampling:int = 10;
		///**@private */
		//public var posRefine:int = 5;
		///**@private */
		//public var angleRefine:int = 5;
		///**@private */
		//public var alpha:Number = 0.01;
		///**@private */
		//public var threshold:Number = 0.01;
		
		/**
		 * 获取网格。
		 * @return 网格。
		 */
		public function get mesh():Mesh {
			return _mesh;
		}
		
		/**
		 * 设置网格。
		 * @param 网格。
		 */
		public function set mesh(value:Mesh):void {
			if (_mesh !== value) {
				var physics3D:* = Laya3D._physics3D;
				if (_mesh) {
					physics3D.destroy(_nativeShape);
				}
				if (value) {
					_nativeShape = new physics3D.btGImpactMeshShape(value._getPhysicMesh());
					_nativeShape.updateBound();
				}
				_mesh = value;
			}
		}
		
		/**
		 * 获取是否使用凸多边形。
		 * @return 是否使用凸多边形。
		 */
		public function get convex():Boolean {
			return _convex;
		}
		
		/**
		 * 设置是否使用凸多边形。
		 * @param value 是否使用凸多边形。
		 */
		public function set convex(value:Boolean):void {
			_convex = value;
		}
		
		/**
		 * 创建一个新的 <code>MeshColliderShape</code> 实例。
		 */
		public function MeshColliderShape() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _setScale(value:Vector3):void {
			if (_compoundParent) {//TODO:待查,这里有问题
				updateLocalTransformations();//TODO:
			} else {
				var valueE:Float32Array = value.elements;
				_nativeScale.setValue(valueE[0], valueE[1], valueE[2]);
				_nativeShape.setLocalScaling(_nativeScale);
				_nativeShape.updateBound();//更新缩放后需要更新包围体,有性能损耗
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			var destMeshCollider:MeshColliderShape = destObject as MeshColliderShape;
			destMeshCollider.convex = _convex;
			destMeshCollider.mesh = _mesh;
			super.cloneTo(destObject);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var dest:MeshColliderShape = new MeshColliderShape();
			cloneTo(dest);
			return dest;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			if (_nativeShape) {
				var physics3D:* = Laya3D._physics3D;
				physics3D.destroy(_nativeShape);
				_nativeShape = null;
			}
		}
	
	}

}