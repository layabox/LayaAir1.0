package laya.d3.component.physics {
	import laya.d3.component.Component3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Collision;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.OrientedBoundBox;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.utils.RaycastHit;
	import laya.events.Event;
	import laya.d3.core.ComponentNode;
	
	/**
	 * <code>BoxCollider</code> 类用于创建盒子碰撞器。
	 */
	public class BoxCollider extends Collider {
		/** @private */
		private static var _deviationV3:Vector3 = new Vector3();
		/** @private */
		private static var _obbCenterV3:Vector3 = new Vector3();
		
		/** @private */
		private var _size:Vector3;
		/** @private */
		private var _transformOrientedBoundBox:OrientedBoundBox;
		
		/** 中心点 */
		public var center:Vector3;
		
		/**
		 * 获取盒子碰撞器长宽高的一半。
		 * @return 长宽高的一半。
		 */
		public function get size():Vector3 {
			return _size;
		}
		
		/**
		 * 设置盒子碰撞器长宽高的一半。
		 * @param 长宽高的一半。
		 */
		public function set size(value:Vector3):void {
			_size = value;
			_needUpdate = true;//需要重新计算OBB的extents
		}
		
		/**
		 * 获取包围盒子,只读,不允许修改。
		 * @return 包围球。
		 */
		public function get boundBox():OrientedBoundBox {
			_updateCollider();
			return _transformOrientedBoundBox;
		}
		
		/**
		 * 创建一个 <code>BoxCollider</code> 实例。
		 */
		public function BoxCollider() {
			_needUpdate = false;
		}
		
		/**
		 * @private
		 */
		private function _updateCollider():void {
			if (_needUpdate) {
				var obbMat:Matrix4x4 = _transformOrientedBoundBox.transformation;
				var transform:Transform3D = (_owner as Sprite3D).transform;
				var rotation:Quaternion = transform.rotation;
				var scale:Vector3 = transform.scale;
				
				var centerE:Float32Array = center.elements;
				if (centerE[0] === 0.0 && centerE[1] === 0.0 && centerE[2] === 0.0) {
					Matrix4x4.createAffineTransformation(transform.position, rotation, Vector3.ONE, obbMat);
				} else {
					Vector3.multiply(center, scale, _deviationV3);
					Vector3.transformQuat(_deviationV3, rotation, _deviationV3);
					Vector3.add(transform.position, _deviationV3, _deviationV3);
					Matrix4x4.createAffineTransformation(_deviationV3, rotation, Vector3.ONE, obbMat);
				}
				_transformOrientedBoundBox.transformation = obbMat;
				
				var extentsE:Float32Array = _transformOrientedBoundBox.extents.elements;
				var sizeE:Float32Array = _size.elements;
				var scaleE:Float32Array = scale.elements;
				extentsE[0] = sizeE[0] * 0.5 * scaleE[0];
				extentsE[1] = sizeE[1] * 0.5 * scaleE[1];
				extentsE[2] = sizeE[2] * 0.5 * scaleE[2];
				_needUpdate = false;
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldMatrixChanged():void {
			_needUpdate = true;
			for (var k:String in _runtimeCollisonMap) {
				_runtimeCollisonTestMap[k] = true;
				_runtimeCollisonMap[k]._runtimeCollisonTestMap[id] = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _initialize(owner:ComponentNode):void {
			super._initialize(owner);
			_transformOrientedBoundBox = new OrientedBoundBox(new Vector3(), new Matrix4x4());
			_size = new Vector3();
			center = new Vector3();
			(owner as Sprite3D).transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatrixChanged);
			_needUpdate = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getType():int {
			return 1;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _collisonTo(other:Collider):Boolean {
			switch (other._getType()) {
			case 0://SphereCollider
				return boundBox.containsSphere((other as SphereCollider).boundSphere) !== ContainmentType.Disjoint;
				break;
			case 1: //BoxCollider
				return boundBox.containsOrientedBoundBox((other as BoxCollider).boundBox) !== ContainmentType.Disjoint;
				break;
			case 2: //MeshCollider
				var meshCollider:MeshCollider = other as MeshCollider;
				if (boundBox.containsBoundBox(meshCollider._boundBox) !== ContainmentType.Disjoint) {
					var positions:Vector.<Vector3> = (other as MeshCollider).mesh._positions;
					for (var i:int = 0, n:int = positions.length; i < n; i++) {
						if (boundBox.containsPoint(positions[i]) === ContainmentType.Contains)
							return true
					}
					return false;
					
				} else {
					return false;
				}
				
				break;
			default: 
				throw new Error("BoxCollider:unknown collider type.");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _cloneTo(dest:Component3D):void {
			var destBoxCollider:BoxCollider = dest as BoxCollider;
			var destSize:Vector3 = destBoxCollider.size;
			size.cloneTo(destSize);
			destBoxCollider.size = destSize;
			center.cloneTo(destBoxCollider.center);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function raycast(ray:Ray, hitInfo:RaycastHit, maxDistance:Number = 1.79e+308/*Number.MAX_VALUE*/):Boolean {
			_updateCollider();
			var distance:Number = _transformOrientedBoundBox.intersectsRay(ray, hitInfo.position);
			if (distance !== -1 && distance <= maxDistance) {
				hitInfo.distance = distance;
				hitInfo.sprite3D = _owner as Sprite3D;
				return true;
			} else {
				
				hitInfo.distance = -1;
				hitInfo.sprite3D = null;
				return false;
			}
		}
		
		/**
		 * 从AABB碰撞盒设置center和Size。
		 * @param	boundBox 碰撞盒。
		 */
		public function setFromBoundBox(boundBox:BoundBox):void {
			OrientedBoundBox.createByBoundBox(boundBox, _transformOrientedBoundBox);
			var extents:Vector3 = _transformOrientedBoundBox.extents;
			_size = new Vector3(extents.x * 2, extents.y * 2, extents.z * 2);
			center = new Vector3();
			Vector3.add(boundBox.min, boundBox.max, center);
			Vector3.scale(center, 0.5, center);
			_needUpdate = true;
		}
	}
}
