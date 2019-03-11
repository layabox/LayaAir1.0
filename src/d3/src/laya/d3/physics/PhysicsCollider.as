package laya.d3.physics {
	import laya.components.Component;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.physics.PhysicsTriggerComponent;
	import laya.d3.physics.PhysicsComponent;
	import laya.d3.physics.shape.ColliderShape;
	import laya.d3.utils.Physics3DUtils;
	import laya.events.Event;
	import laya.utils.Stat;
	
	/**
	 * <code>PhysicsCollider</code> 类用于创建物理碰撞器。
	 */
	public class PhysicsCollider extends PhysicsTriggerComponent {
		
		/**
		 * 创建一个 <code>PhysicsCollider</code> 实例。
		 * @param collisionGroup 所属碰撞组。
		 * @param canCollideWith 可产生碰撞的碰撞组。
		 */
		public function PhysicsCollider(collisionGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_DEFAULTFILTER, canCollideWith:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(collisionGroup, canCollideWith);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _addToSimulation():void {
			_simulation._addPhysicsCollider(this, _collisionGroup, _canCollideWith);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _removeFromSimulation():void {
			_simulation._removePhysicsCollider(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onTransformChanged(flag:int):void {//需要移除父类_addUpdateList保护,否则刚体带着碰撞器移动无效 TODO:是否本帧再更新一次队列
			flag &= Transform3D.TRANSFORM_WORLDPOSITION | Transform3D.TRANSFORM_WORLDQUATERNION | Transform3D.TRANSFORM_WORLDSCALE;//过滤有用TRANSFORM标记
			if (flag) {
				_transformFlag |= flag;
				if (_isValid() && _inPhysicUpdateListIndex === -1)//_isValid()表示可使用
					_simulation._physicsUpdateList.add(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			(data.friction != null) && (friction = data.friction);
			(data.rollingFriction != null) && (rollingFriction = data.rollingFriction);
			(data.restitution != null) && (restitution = data.restitution);
			(data.isTrigger != null) && (isTrigger = data.isTrigger);
			super._parse(data);
			_parseShape(data.shapes);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onAdded():void {
			var physics3D:* = Laya3D._physics3D;
			var btColObj:* = new physics3D.btCollisionObject();
			btColObj.setUserIndex(id);
			btColObj.forceActivationState(ACTIVATIONSTATE_DISABLE_SIMULATION);//prevent simulation
			
			var flags:int = btColObj.getCollisionFlags();
			if ((owner as Sprite3D).isStatic) {//TODO:
				if ((flags & COLLISIONFLAGS_KINEMATIC_OBJECT) > 0)
					flags = flags ^ COLLISIONFLAGS_KINEMATIC_OBJECT;
				flags = flags | COLLISIONFLAGS_STATIC_OBJECT;
			} else {
				if ((flags & COLLISIONFLAGS_STATIC_OBJECT) > 0)
					flags = flags ^ COLLISIONFLAGS_STATIC_OBJECT;
				flags = flags | COLLISIONFLAGS_KINEMATIC_OBJECT;
			}
			btColObj.setCollisionFlags(flags);
			_nativeColliderObject = btColObj;
			super._onAdded();
		}
	}

}