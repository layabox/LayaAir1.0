package laya.d3.physics {
	import laya.d3.physics.PhysicsComponent;
	
	/**
	 * <code>CollisionMap</code> 类用于实现碰撞组合实例图。
	 */
	public class CollisionTool {
		/**@private	*/
		private var _hitResultsPoolIndex:int = 0;
		/**@private	*/
		private var _hitResultsPool:Vector.<HitResult> = new Vector.<HitResult>();
		/**@private	*/
		private var _contactPonintsPoolIndex:int = 0;
		/**@private	*/
		private var _contactPointsPool:Vector.<ContactPoint> = new Vector.<ContactPoint>();
		/**@private */
		private var _collisionsPool:Vector.<Collision> = new Vector.<Collision>();
		
		/**@private */
		private var _collisions:Object = {};
		
		/**
		 * 创建一个 <code>CollisionMap</code> 实例。
		 */
		public function CollisionTool() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * @private
		 */
		public function getHitResult():HitResult {
			var hitResult:HitResult = _hitResultsPool[_hitResultsPoolIndex++];
			if (!hitResult) {
				hitResult = new HitResult();
				_hitResultsPool.push(hitResult);
			}
			return hitResult;
		}
		
		/**
		 * @private
		 */
		public function recoverAllHitResultsPool():void {
			_hitResultsPoolIndex = 0;
		}
		
		/**
		 * @private
		 */
		public function getContactPoints():ContactPoint {
			var contactPoint:ContactPoint = _contactPointsPool[_contactPonintsPoolIndex++];
			if (!contactPoint) {
				contactPoint = new ContactPoint();
				_contactPointsPool.push(contactPoint);
			}
			return contactPoint;
		}
		
		/**
		 * @private
		 */
		public function recoverAllContactPointsPool():void {
			_contactPonintsPoolIndex = 0;
		}
		
		/**
		 * @private
		 */
		public function getCollision(physicComponentA:PhysicsComponent, physicComponentB:PhysicsComponent):Collision {
			var collision:Collision;
			var idA:int = physicComponentA.id;
			var idB:int = physicComponentB.id;
			var subCollisionFirst:Object = _collisions[idA];
			if (subCollisionFirst)
				collision = subCollisionFirst[idB];
			if (!collision) {
				if (!subCollisionFirst) {
					subCollisionFirst = {};
					_collisions[idA] = subCollisionFirst;
				}
				collision = _collisionsPool.length === 0 ? new Collision() : _collisionsPool.pop();
				collision._colliderA = physicComponentA;
				collision._colliderB = physicComponentB;
				subCollisionFirst[idB] = collision;
			}
			return collision;
		}
		
		/**
		 * @private
		 */
		public function recoverCollision(collision:Collision):void {
			var idA:int = collision._colliderA.id;
			var idB:int = collision._colliderB.id;
			_collisions[idA][idB] = null;
			_collisionsPool.push(collision);
		}
		
		/**
		 * @private
		 */
		public function garbageCollection():void {//TODO:哪里调用
			_hitResultsPoolIndex = 0;
			_hitResultsPool.length = 0;
			
			_contactPonintsPoolIndex = 0;
			_contactPointsPool.length = 0;
			
			_collisionsPool.length = 0;
			for (var subCollisionsKey:Object in _collisionsPool) {
				var subCollisions:Object = _collisionsPool[subCollisionsKey];
				var wholeDelete:Boolean = true;
				for (var collisionKey:String in subCollisions) {
					if (subCollisions[collisionKey])
						wholeDelete = false;
					else
						delete subCollisions[collisionKey];
				}
				if (wholeDelete)
					delete _collisionsPool[subCollisionsKey];
			}
		}
	}

}