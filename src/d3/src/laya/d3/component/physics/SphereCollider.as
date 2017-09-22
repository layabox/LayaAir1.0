package laya.d3.component.physics {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	import laya.d3.utils.RaycastHit;
	import laya.events.Event;
	
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
		 * 获取包围球。
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
				var transform:Transform3D = _owner.transform;
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
		private function _onGeometryFilterLoaded():void {
			(destroyed) || (_initBoundSphere());
		}
		
		/**
		 * @private
		 */
		private function _onWorldMatrixChanged():void {
			_needUpdate = true;
		}
		
		/**
		 * @private
		 */
		private function _initBoundSphere():void {
			(owner as RenderableSprite3D)._geometryFilter._originalBoundingSphere.cloneTo(_originalBoundSphere);
			owner.transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatrixChanged);
			_needUpdate = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _initialize(owner:Sprite3D):void {
			super._initialize(owner);
			if (owner is RenderableSprite3D) {
				var renderableOwner:RenderableSprite3D = owner as RenderableSprite3D;
				_originalBoundSphere = new BoundSphere(new Vector3(0, 0, 0), 0);
				_transformBoundSphere = new BoundSphere(new Vector3(0, 0, 0), 0);
				if (renderableOwner._geometryFilter._isAsyncLoaded) {
					_initBoundSphere();
				} else {
					renderableOwner._geometryFilter.once(Event.LOADED, this, _onGeometryFilterLoaded);
				}
			} else {
				_originalBoundSphere = new BoundSphere(new Vector3(0, 0, 0), 0.5);
				_transformBoundSphere = new BoundSphere(new Vector3(0, 0, 0), 0.5);
				owner.transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatrixChanged);
				_needUpdate = true;
			}
		}
		
		/**
		 * 在场景中投下可与球体碰撞器碰撞的一条光线,获取发生碰撞的球体碰撞器信息。
		 * @param  ray        射线
		 * @param  outHitInfo 与该射线发生碰撞球体碰撞器的碰撞信息
		 * @param  distance   射线长度,默认为最大值 
		 */
		override public function raycast(ray:Ray, hitInfo:RaycastHit, maxDistance:Number = Number.MAX_VALUE):Boolean {
			_updateCollider();
			
			var distance:Number = _transformBoundSphere.intersectsRayPoint(ray, hitInfo.position);
			
			if (distance !== -1 && distance <= maxDistance) {
				
				hitInfo.distance = distance;
				hitInfo.sprite3D = _owner;
				return true;
			} else {
				
				hitInfo.distance = -1;
				hitInfo.sprite3D = null;
				return false;
			}
		}
	}
}
