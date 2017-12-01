package laya.d3.component.physics {
	import laya.d3.component.Component3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Collision;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.OrientedBoundBox;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.utils.RaycastHit;
	import laya.events.Event;
	import laya.d3.core.ComponentNode;
	
	/**
	 * <code>SphereCollider</code> 类用于创建球碰撞器。
	 */
	public class SphereCollider extends Collider {
		/** @private */
		private var _originalBoundSphere:BoundSphere;
		/** @private */
		private var _transformBoundSphere:BoundSphere;
		
		/**
		 * 获取中心点。
		 * @return 中心点。
		 */
		public function get center():Vector3 {
			return _originalBoundSphere.center;
		}
		
		/**
		 * 设置中心点。
		 * @param value 中心点。
		 */
		public function set center(value:Vector3):void {
			_originalBoundSphere.center = value;
		}
		
		/**
		 * 获取半径。
		 * @return 半径。
		 */
		public function get radius():Number {
			return _originalBoundSphere.radius;
		}
		
		/**
		 * 设置半径。
		 * @param value 半径。
		 */
		public function set radius(value:Number):void {
			_originalBoundSphere.radius = value;
		}
		
		/**
		 * 获取包围球,只读,不允许修改。
		 * @return 包围球。
		 */
		public function get boundSphere():BoundSphere {
			_updateCollider();
			return _transformBoundSphere;
		}
		
		/**
		 * 创建一个 <code>SphereCollider</code> 实例。
		 */
		public function SphereCollider() {
			_needUpdate = false;
		}
		
		/**
		 * @private
		 */
		private function _updateCollider():void {
			if (_needUpdate) {
				var maxScale:Number;
				var transform:Transform3D = (_owner as Sprite3D).transform;
				var scale:Vector3 = transform.scale;
				if (scale.x >= scale.y && scale.x >= scale.z)
					maxScale = scale.x;
				else
					maxScale = scale.y >= scale.z ? scale.y : scale.z;
				
				Vector3.transformCoordinate(_originalBoundSphere.center, transform.worldMatrix, _transformBoundSphere.center);
				_transformBoundSphere.radius = _originalBoundSphere.radius * maxScale;
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
			_originalBoundSphere = new BoundSphere(new Vector3(0, 0, 0), 0.5);
			_transformBoundSphere = new BoundSphere(new Vector3(0, 0, 0), 0.5);
			(owner as Sprite3D).transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatrixChanged);
			_needUpdate = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getType():int {
			return 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _collisonTo(other:Collider):Boolean {
			switch (other._getType()) {
			case 0://SphereCollider
				return Collision.sphereContainsSphere(this.boundSphere, (other as SphereCollider).boundSphere) !== ContainmentType.Disjoint;
				break;
			case 1: //BoxCollider
				return (other as BoxCollider).boundBox.containsSphere(this.boundSphere) !== ContainmentType.Disjoint;
				break;
			case 2: //MeshCollider
				var meshCollider:MeshCollider = other as MeshCollider;
				if (Collision.sphereContainsBox(this.boundSphere, meshCollider._boundBox) !== ContainmentType.Disjoint) {
					var positions:Vector.<Vector3> = meshCollider.mesh._positions;
					for (var i:int = 0, n:int = positions.length; i < n; i++) {
						if (Collision.sphereContainsPoint(this.boundSphere, positions[i]) === ContainmentType.Contains)
							return true
					}
					return false;
				} else {
					return false;
				}
				break;
			default: 
				throw new Error("SphereCollider:unknown collider type.");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _cloneTo(dest:Component3D):void {
			var destCollider:SphereCollider = dest as SphereCollider;
			destCollider.radius = radius;
			var destCenter:Vector3 = destCollider.center;
			center.cloneTo(destCenter);
			destCollider.center = destCenter;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function raycast(ray:Ray, hitInfo:RaycastHit, maxDistance:Number = 1.79e+308/*Number.MAX_VALUE*/):Boolean {
			_updateCollider();
			
			var distance:Number = _transformBoundSphere.intersectsRayPoint(ray, hitInfo.position);
			
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
	
	}
}
