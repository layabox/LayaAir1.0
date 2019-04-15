package laya.d3.physics {
	import laya.components.Component;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.math.Vector3;
	import laya.d3.physics.PhysicsTriggerComponent;
	import laya.d3.physics.shape.ColliderShape;
	import laya.d3.utils.Physics3DUtils;
	import laya.d3.utils.Utils3D;
	
	/**
	 * <code>Rigidbody3D</code> 类用于创建刚体碰撞器。
	 */
	public class Rigidbody3D extends PhysicsTriggerComponent {
		/*
		 * 刚体类型_静态。
		 * 设定为永远不会移动刚体,引擎也不会自动更新。
		 * 如果你打算移动物理,建议使用TYPE_KINEMATIC。
		 */
		public static const TYPE_STATIC:int = 0;
		/*
		 * 刚体类型_动态。
		 * 可以通过forces和impulsesy移动刚体,并且不需要修改移动转换。
		 */
		public static const TYPE_DYNAMIC:int = 1;
		/*
		 * 刚体类型_运动。
		 * 可以移动刚体,物理引擎会自动处理动态交互。
		 * 注意：和静态或其他类型刚体不会产生动态交互。
		 */
		public static const TYPE_KINEMATIC:int = 2;
		
		/** @private */
		public static const _BT_DISABLE_WORLD_GRAVITY:int = 1;
		/** @private */
		public static const _BT_ENABLE_GYROPSCOPIC_FORCE:int = 2;
		
		/** @private */
		private static var _nativeTempVector30:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		/** @private */
		private static var _nativeTempVector31:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		private static var _nativeVector3Zero:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		private static var _nativeInertia:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		private static var _nativeImpulse:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		private static var _nativeImpulseOffset:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		private static var _nativeGravity:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		
		/** @private */
		private var _nativeMotionState:*;
		/** @private */
		private var _isKinematic:Boolean = false;
		/** @private */
		private var _mass:Number = 1.0;
		/** @private */
		private var _gravity:Vector3 = new Vector3(0, -10, 0);
		/** @private */
		private var _angularDamping:Number = 0.0;
		/** @private */
		private var _linearDamping:Number = 0.0;
		/** @private */
		private var _overrideGravity:Boolean = false;
		/** @private */
		private var _totalTorque:Vector3 = new Vector3(0, 0, 0);
		
		//private var _linkedConstraints:Array;//TODO:
		
		/** @private */
		private var _linearVelocity:Vector3 = new Vector3();
		/** @private */
		private var _angularVelocity:Vector3 = new Vector3();
		/** @private */
		private var _linearFactor:Vector3 = new Vector3(1, 1, 1);
		/** @private */
		private var _angularFactor:Vector3 = new Vector3(1, 1, 1);
		/** @private */
		private var _detectCollisions:Boolean = true;
		
		/**
		 * 获取质量。
		 * @return 质量。
		 */
		public function get mass():Number {
			return _mass;
		}
		
		/**
		 * 设置质量。
		 * @param value 质量。
		 */
		public function set mass(value:Number):void {
			value = Math.max(value, 1e-07);//质量最小为1e-07
			_mass = value;
			(_isKinematic) || (_updateMass(value));
		}
		
		/**
		 * 获取是否为运动物体，如果为true仅可通过transform属性移动物体,而非其他力相关属性。
		 * @return 是否为运动物体。
		 */
		public function get isKinematic():Boolean {
			return _isKinematic;
		}
		
		/**
		 * 设置是否为运动物体，如果为true仅可通过transform属性移动物体,而非其他力相关属性。
		 * @param value 是否为运动物体。
		 */
		public function set isKinematic(value:Boolean):void {
			_isKinematic = value;
			
			var canInSimulation:Boolean = !!(_simulation && _enabled && _colliderShape);
			canInSimulation && _removeFromSimulation();
			var natColObj:* = _nativeColliderObject;
			var flags:int = natColObj.getCollisionFlags();
			if (value) {
				flags = flags | COLLISIONFLAGS_KINEMATIC_OBJECT;
				natColObj.setCollisionFlags(flags);//加入场景前必须配置flag,加入后无效
				_nativeColliderObject.forceActivationState(ACTIVATIONSTATE_DISABLE_DEACTIVATION);//触发器开启主动检测,并防止睡眠
				_enableProcessCollisions = false;
				_updateMass(0);//必须设置Mass为0来保证InverMass为0
			} else {
				if ((flags & COLLISIONFLAGS_KINEMATIC_OBJECT) > 0)
					flags = flags ^ COLLISIONFLAGS_KINEMATIC_OBJECT;
				natColObj.setCollisionFlags(flags);//加入场景前必须配置flag,加入后无效
				_nativeColliderObject.setActivationState(ACTIVATIONSTATE_ACTIVE_TAG);
				_enableProcessCollisions = true;
				_updateMass(_mass);
			}
			
			var nativeZero:* = _nativeVector3Zero;
			natColObj.setInterpolationLinearVelocity(nativeZero);
			natColObj.setLinearVelocity(nativeZero);
			natColObj.setInterpolationAngularVelocity(nativeZero);
			natColObj.setAngularVelocity(nativeZero);
			
			canInSimulation && _addToSimulation();
		}
		
		/**
		 * 获取刚体的线阻力。
		 * @return 线阻力。
		 */
		public function get linearDamping():Number {
			return _linearDamping;
		}
		
		/**
		 * 设置刚体的线阻力。
		 * @param value  线阻力。
		 */
		public function set linearDamping(value:Number):void {
			_linearDamping = value;
			if (_nativeColliderObject)
				_nativeColliderObject.setDamping(value, _angularDamping);
		}
		
		/**
		 * 获取刚体的角阻力。
		 * @return 角阻力。
		 */
		public function get angularDamping():Number {
			return _angularDamping;
		}
		
		/**
		 * 设置刚体的角阻力。
		 * @param value  角阻力。
		 */
		public function set angularDamping(value:Number):void {
			_angularDamping = value;
			if (_nativeColliderObject)
				_nativeColliderObject.setDamping(_linearDamping, value);
		}
		
		/**
		 * 获取是否重载重力。
		 * @return 是否重载重力。
		 */
		public function get overrideGravity():Boolean {
			return _overrideGravity;
		}
		
		/**
		 * 设置是否重载重力。
		 * @param value 是否重载重力。
		 */
		public function set overrideGravity(value:Boolean):void {
			_overrideGravity = value;
			if (_nativeColliderObject) {
				var flag:int = _nativeColliderObject.getFlags();
				if (value) {
					if ((flag & _BT_DISABLE_WORLD_GRAVITY) === 0)
						_nativeColliderObject.setFlags(flag | _BT_DISABLE_WORLD_GRAVITY);
				} else {
					if ((flag & _BT_DISABLE_WORLD_GRAVITY) > 0)
						_nativeColliderObject.setFlags(flag ^ _BT_DISABLE_WORLD_GRAVITY);
				}
			}
		}
		
		/**
		 * 获取重力。
		 * @return 重力。
		 */
		public function get gravity():Vector3 {
			return _gravity;
		}
		
		/**
		 * 设置重力。
		 * @param value 重力。
		 */
		public function set gravity(value:Vector3):void {
			_gravity = value;
			_nativeGravity.setValue(-value.x, value.y, value.z);
			_nativeColliderObject.setGravity(_nativeGravity);
		}
		
		/**
		 * 获取总力。
		 */
		public function get totalForce():Vector3 {
			if (_nativeColliderObject)
				return _nativeColliderObject.getTotalForce();
			return null;
		}
		
		/**
		 * 获取性因子。
		 */
		public function get linearFactor():Vector3 {
			if (_nativeColliderObject)
				return _linearFactor;
			return null;
		}
		
		/**
		 * 设置性因子。
		 */
		public function set linearFactor(value:Vector3):void {
			_linearFactor = value;
			if (_nativeColliderObject) {
				var nativeValue:* = _nativeTempVector30;
				Utils3D._convertToBulletVec3(value, nativeValue, false);
				_nativeColliderObject.setLinearFactor(nativeValue);
			}
		}
		
		/**
		 * 获取线速度
		 * @return 线速度
		 */
		public function get linearVelocity():Vector3 {
			if (_nativeColliderObject)
				Utils3D._convertToLayaVec3(_nativeColliderObject.getLinearVelocity(), _linearVelocity, true);
			return _linearVelocity;
		}
		
		/**
		 * 设置线速度。
		 * @param 线速度。
		 */
		public function set linearVelocity(value:Vector3):void {
			_linearVelocity = value;
			if (_nativeColliderObject) {
				var nativeValue:* = _nativeTempVector30;
				Utils3D._convertToBulletVec3(value, nativeValue, true);
				(isSleeping) && (wakeUp());//可能会因睡眠导致设置线速度无效
				_nativeColliderObject.setLinearVelocity(nativeValue);
			}
		}
		
		/**
		 * 获取角因子。
		 */
		public function get angularFactor():Vector3 {
			if (_nativeColliderObject)
				return _angularFactor;
			return null;
		}
		
		/**
		 * 设置角因子。
		 */
		public function set angularFactor(value:Vector3):void {
			_angularFactor = value;
			if (_nativeColliderObject) {
				var nativeValue:* = _nativeTempVector30;
				Utils3D._convertToBulletVec3(value, nativeValue, false);
				_nativeColliderObject.setAngularFactor(nativeValue);
			}
		}
		
		/**
		 * 获取角速度。
		 * @return 角速度。
		 */
		public function get angularVelocity():Vector3 {
			if (_nativeColliderObject)
				Utils3D._convertToLayaVec3(_nativeColliderObject.getAngularVelocity(), _angularVelocity, true);
			return _angularVelocity;
		}
		
		/**
		 * 设置角速度。
		 * @param 角速度
		 */
		public function set angularVelocity(value:Vector3):void {
			_angularVelocity = value;
			if (_nativeColliderObject) {
				var nativeValue:* = _nativeTempVector30;
				Utils3D._convertToBulletVec3(value, nativeValue, true);
				(isSleeping) && (wakeUp());//可能会因睡眠导致设置角速度无效
				_nativeColliderObject.setAngularVelocity(nativeValue);
			}
		}
		
		/**
		 * 获取刚体所有扭力。
		 */
		public function get totalTorque():Vector3 {
			if (_nativeColliderObject) {
				var nativeTotalTorque:* = _nativeColliderObject.getTotalTorque();
				var totalTorque:Vector3 = _totalTorque;
				totalTorque.x = -nativeTotalTorque.x;
				totalTorque.y = nativeTotalTorque.y;
				totalTorque.z = nativeTotalTorque.z;
			}
			return null;
		}
		
		/**
		 * 获取是否进行碰撞检测。
		 * @return 是否进行碰撞检测。
		 */
		public function get detectCollisions():Boolean {
			return _detectCollisions;
		}
		
		/**
		 * 设置是否进行碰撞检测。
		 * @param value 是否进行碰撞检测。
		 */
		public function set detectCollisions(value:Boolean):void {
			if (_detectCollisions !== value) {
				_detectCollisions = value;
				
				if (_colliderShape && _enabled && _simulation) {
					_simulation._removeRigidBody(this);
					_simulation._addRigidBody(this, _collisionGroup, value ? _canCollideWith : 0);
						//_nativeColliderObject.getBroadphaseHandle().set_m_collisionFilterMask(value ? _canCollideWith : 0);//有延迟问题
				}
			}
		}
		
		/**
		 * 获取是否处于睡眠状态。
		 * @return 是否处于睡眠状态。
		 */
		public function get isSleeping():Boolean {
			if (_nativeColliderObject)
				return _nativeColliderObject.getActivationState() === PhysicsComponent.ACTIVATIONSTATE_ISLAND_SLEEPING;
			return false;
		}
		
		/**
		 * 获取刚体睡眠的线速度阈值。
		 * @return 刚体睡眠的线速度阈值。
		 */
		public function get sleepLinearVelocity():Number {
			return _nativeColliderObject.getLinearSleepingThreshold();
		}
		
		/**
		 * 设置刚体睡眠的线速度阈值。
		 * @param value 刚体睡眠的线速度阈值。
		 */
		public function set sleepLinearVelocity(value:Number):void {
			_nativeColliderObject.setSleepingThresholds(value,_nativeColliderObject.getAngularSleepingThreshold());
		}
		
		/**
		 * 获取刚体睡眠的角速度阈值。
		 * @return 刚体睡眠的角速度阈值。
		 */
		public function get sleepAngularVelocity():Number {
			return _nativeColliderObject.getAngularSleepingThreshold();
		}
		
		/**
		 * 设置刚体睡眠的角速度阈值。
		 * @param value 刚体睡眠的角速度阈值。
		 */
		public function set sleepAngularVelocity(value:Number):void {
			_nativeColliderObject.setSleepingThresholds(_nativeColliderObject.getLinearSleepingThreshold(),value);
		}

		
		/**
		 * 创建一个 <code>RigidBody</code> 实例。
		 * @param collisionGroup 所属碰撞组。
		 * @param canCollideWith 可产生碰撞的碰撞组。
		 */
		public function Rigidbody3D(collisionGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_DEFAULTFILTER, canCollideWith:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			//LinkedConstraints = new List<Constraint>();
			super(collisionGroup, canCollideWith);
		}
		
		/**
		 * @private
		 */
		private function _updateMass(mass:Number):void {
			if (_nativeColliderObject && _colliderShape) {
				_colliderShape._nativeShape.calculateLocalInertia(mass, _nativeInertia);
				_nativeColliderObject.setMassProps(mass, _nativeInertia);
				_nativeColliderObject.updateInertiaTensor(); //this was the major headache when I had to debug Slider and Hinge constraint
			}
		}
		
		/**
		 * @private
		 * Dynamic刚体,初始化时调用一次。
		 * Kinematic刚体,每次物理tick时调用(如果未进入睡眠状态),让物理引擎知道刚体位置。
		 */
		private function _delegateMotionStateGetWorldTransform(worldTransPointer:int):void {
			//已调整机制,引擎会统一处理通过Transform修改坐标更新包围盒队列
			
			//var rigidBody:Rigidbody3D = __JS__("this._rigidbody");
			//if (!rigidBody._colliderShape)//Dynamic刚体初始化时没有colliderShape需要跳过
				//return;
			//
			//rigidBody._simulation._updatedRigidbodies++;
			//var physics3D:* = Laya3D._physics3D;
			//var worldTrans:* = physics3D.wrapPointer(worldTransPointer, physics3D.btTransform);
			//rigidBody._innerDerivePhysicsTransformation(worldTrans, true);
		}
		
		/**
		 * @private
		 * Dynamic刚体,物理引擎每帧调用一次,用于更新渲染矩阵。
		 */
		private function _delegateMotionStateSetWorldTransform(worldTransPointer:int):void {
			var rigidBody:Rigidbody3D = __JS__("this._rigidbody");
			rigidBody._simulation._updatedRigidbodies++;
			var physics3D:* = Laya3D._physics3D;
			var worldTrans:* = physics3D.wrapPointer(worldTransPointer, physics3D.btTransform);
			rigidBody._updateTransformComponent(worldTrans);
		}
		
		/**
		 *  @private
		 * Dynamic刚体,初始化时调用一次。
		 * Kinematic刚体,每次物理tick时调用(如果未进入睡眠状态),让物理引擎知道刚体位置。
		 * 该函数只有在runtime下调用
		 */
		private function _delegateMotionStateGetWorldTransformNative(ridgidBody3D:Rigidbody3D, worldTransPointer:int):void {
			//已调整机制,引擎会统一处理通过Transform修改坐标更新包围盒队列
			
			//var rigidBody:Rigidbody3D = ridgidBody3D;
			//if (!rigidBody._colliderShape)//Dynamic刚体初始化时没有colliderShape需要跳过
				//return;
			//
			//rigidBody._simulation._updatedRigidbodies++;
			//var physics3D:* = Laya3D._physics3D;
			//var worldTrans:* = physics3D.wrapPointer(worldTransPointer, physics3D.btTransform);
			//rigidBody._innerDerivePhysicsTransformation(worldTrans, true);
		}
		
		/**
		 * @private
		 * Dynamic刚体,物理引擎每帧调用一次,用于更新渲染矩阵。
		 * 该函数只有在runtime下调用
		 */
		private function _delegateMotionStateSetWorldTransformNative(rigidBody3D:Rigidbody3D, worldTransPointer:int):void {
			var rigidBody:Rigidbody3D = rigidBody3D;
			rigidBody._simulation._updatedRigidbodies++;
			var physics3D:* = Laya3D._physics3D;
			var worldTrans:* = physics3D.wrapPointer(worldTransPointer, physics3D.btTransform);
			rigidBody._updateTransformComponent(worldTrans);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onScaleChange(scale:Vector3):void {
			super._onScaleChange(scale);
			_updateMass(_isKinematic ? 0 : _mass);//修改缩放需要更新惯性
		}
		
		/**
		 * @private
		 */
		public function _delegateMotionStateClear():void {
			__JS__("this._rigidbody=null");
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onAdded():void {
			var physics3D:* = Laya3D._physics3D;
			var motionState:* = new physics3D.LayaMotionState();
			var isConchApp:Boolean = __JS__("(window.conch != null)");
			if (isConchApp && physics3D.LayaMotionState.prototype.setRigidbody) {
				motionState.setRigidbody(this);
				motionState.setNativeGetWorldTransform(this._delegateMotionStateGetWorldTransformNative);
				motionState.setNativeSetWorldTransform(this._delegateMotionStateSetWorldTransformNative);
			} else {
				motionState.getWorldTransform = _delegateMotionStateGetWorldTransform;
				motionState.setWorldTransform = _delegateMotionStateSetWorldTransform;
			}
			
			motionState.clear = _delegateMotionStateClear;
			motionState._rigidbody = this;
			_nativeMotionState = motionState;
			var constructInfo:* = new physics3D.btRigidBodyConstructionInfo(0.0, motionState, null, _nativeVector3Zero);
			var btRigid:* = new physics3D.btRigidBody(constructInfo);
			btRigid.setUserIndex(id);
			_nativeColliderObject = btRigid;
			super._onAdded();
			mass = _mass;
			linearFactor = _linearFactor;
			angularFactor = _angularFactor;
			linearDamping = _linearDamping;
			angularDamping = _angularDamping;
			overrideGravity = _overrideGravity;
			gravity = _gravity;
			isKinematic = _isKinematic;
			physics3D.destroy(constructInfo);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onShapeChange(colShape:ColliderShape):void {
			super._onShapeChange(colShape);
			//TODO:此时已经加入场景,只影响mass为0,函数内部设置的flas是否为static无效			
			if (_isKinematic) {
				_updateMass(0);
			} else {
				_nativeColliderObject.setCenterOfMassTransform(_nativeColliderObject.getWorldTransform());//修改Shape会影响坐标,需要更新插值坐标,否则物理引擎motionState.setWorldTrans数据为旧数据
				_updateMass(_mass);
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
			(data.mass != null) && (mass = data.mass);
			(data.isKinematic != null) && (isKinematic = data.isKinematic);
			(data.linearDamping != null) && (linearDamping = data.linearDamping);
			(data.angularDamping != null) && (angularDamping = data.angularDamping);
			(data.overrideGravity != null) && (overrideGravity = data.overrideGravity);
			
			if (data.gravity) {
				gravity.fromArray(data.gravity);
				gravity = gravity;
			}
			super._parse(data);
			_parseShape(data.shapes);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDestroy():void {
			var physics3D:* = Laya3D._physics3D;
			_nativeMotionState.clear();
			physics3D.destroy(_nativeMotionState);
			
			////Remove constraints safely
			//var toremove = new FastList<Constraint>();
			//foreach (var c in LinkedConstraints)
			//{
			//toremove.Add(c);
			//}
			
			//foreach (var disposable in toremove)
			//{
			//disposable.Dispose();
			//}
			
			//LinkedConstraints.Clear();
			////~Remove constraints
			
			super._onDestroy();
			_nativeMotionState = null;
			_gravity = null;
			_totalTorque = null;
			_linearVelocity = null;
			_angularVelocity = null;
			_linearFactor = null;
			_angularFactor = null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _addToSimulation():void {
			_simulation._addRigidBody(this, _collisionGroup, _detectCollisions ? _canCollideWith : 0);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _removeFromSimulation():void {
			_simulation._removeRigidBody(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _cloneTo(dest:Component):void {
			super._cloneTo(dest);
			var destRigidbody3D:Rigidbody3D = dest as Rigidbody3D;
			destRigidbody3D.isKinematic = _isKinematic;
			destRigidbody3D.mass = _mass;
			destRigidbody3D.gravity = _gravity;
			destRigidbody3D.angularDamping = _angularDamping;
			destRigidbody3D.linearDamping = _linearDamping;
			destRigidbody3D.overrideGravity = _overrideGravity;
			//destRigidbody3D.totalTorque = _totalTorque;
			destRigidbody3D.linearVelocity = _linearVelocity;
			destRigidbody3D.angularVelocity = _angularVelocity;
			destRigidbody3D.linearFactor = _linearFactor;
			destRigidbody3D.angularFactor = _angularFactor;
			destRigidbody3D.detectCollisions = _detectCollisions;
		}
		
		/**
		 * 应用作用力。
		 * @param	force 作用力。
		 * @param	localOffset 偏移,如果为null则为中心点
		 */
		public function applyForce(force:Vector3, localOffset:Vector3 = null):void {
			if (_nativeColliderObject == null)
				throw "Attempted to call a Physics function that is avaliable only when the Entity has been already added to the Scene.";
			var nativeForce:* = _nativeTempVector30;
			nativeForce.setValue(-force.x, force.y, force.z);
			if (localOffset) {
				var nativeOffset:* = _nativeTempVector31;
				nativeOffset.setValue(-localOffset.x, localOffset.y, localOffset.z);
				_nativeColliderObject.applyForce(nativeForce, nativeOffset);
			} else {
				_nativeColliderObject.applyCentralForce(nativeForce);
			}
		}
		
		/**
		 * 应用扭转力。
		 * @param	torque 扭转力。
		 */
		public function applyTorque(torque:Vector3):void {
			if (_nativeColliderObject == null)
				throw "Attempted to call a Physics function that is avaliable only when the Entity has been already added to the Scene.";
			
			var nativeTorque:* = _nativeTempVector30;
			nativeTorque.setValue(-torque.x, torque.y, torque.z);
			_nativeColliderObject.applyTorque(nativeTorque);
		}
		
		/**
		 * 应用冲量。
		 * @param	impulse 冲量。
		 * @param   localOffset 偏移,如果为null则为中心点。
		 */
		public function applyImpulse(impulse:Vector3, localOffset:Vector3 = null):void {
			if (_nativeColliderObject == null)
				throw "Attempted to call a Physics function that is avaliable only when the Entity has been already added to the Scene.";
			_nativeImpulse.setValue(-impulse.x, impulse.y, impulse.z);
			if (localOffset) {
				_nativeImpulseOffset.setValue(-localOffset.x, localOffset.y, localOffset.z);
				_nativeColliderObject.applyImpulse(_nativeImpulse, _nativeImpulseOffset);
			} else {
				_nativeColliderObject.applyCentralImpulse(_nativeImpulse);
			}
		}
		
		/**
		 * 应用扭转冲量。
		 * @param	torqueImpulse
		 */
		public function applyTorqueImpulse(torqueImpulse:Vector3):void {
			if (_nativeColliderObject == null)
				throw "Attempted to call a Physics function that is avaliable only when the Entity has been already added to the Scene.";
			var nativeTorqueImpulse:* = _nativeTempVector30;
			nativeTorqueImpulse.setValue(-torqueImpulse.x, torqueImpulse.y, torqueImpulse.z);
			_nativeColliderObject.applyTorqueImpulse(nativeTorqueImpulse);
		}
		
		/**
		 * 唤醒刚体。
		 */
		public function wakeUp():void{
			_nativeColliderObject && (_nativeColliderObject.activate(false));
		}
		
		/**
		 *清除应用到刚体上的所有力。
		 */
		public function clearForces():void {
			var rigidBody:* = _nativeColliderObject;
			if (rigidBody == null)
				throw "Attempted to call a Physics function that is avaliable only when the Entity has been already added to the Scene.";
			
			rigidBody.clearForces();
			var nativeZero:* = _nativeVector3Zero;
			rigidBody.setInterpolationAngularVelocity(nativeZero);
			rigidBody.setLinearVelocity(nativeZero);
			rigidBody.setInterpolationAngularVelocity(nativeZero);
			rigidBody.setAngularVelocity(nativeZero);
		}
	
	}

}