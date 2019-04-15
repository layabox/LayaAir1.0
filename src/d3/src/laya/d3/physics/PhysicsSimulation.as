package laya.d3.physics {
	import laya.d3.component.Script3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	import laya.d3.physics.Collision;
	import laya.d3.physics.CollisionTool;
	import laya.d3.physics.Constraint3D;
	import laya.d3.physics.ContactPoint;
	import laya.d3.physics.HitResult;
	import laya.d3.physics.PhysicsCollider;
	import laya.d3.physics.PhysicsComponent;
	import laya.d3.physics.PhysicsSettings;
	import laya.d3.physics.PhysicsTriggerComponent;
	import laya.d3.physics.Rigidbody3D;
	import laya.d3.physics.shape.ColliderShape;
	import laya.d3.utils.Physics3DUtils;
	import laya.events.Event;
	import laya.utils.Stat;
	
	/**
	 * <code>Simulation</code> 类用于创建物理模拟器。
	 */
	public class PhysicsSimulation {
		/** @private */
		public static const PHYSICSENGINEFLAGS_NONE:int = 0x0;
		/** @private */
		public static const PHYSICSENGINEFLAGS_COLLISIONSONLY:int = 0x1;
		/** @private */
		public static const PHYSICSENGINEFLAGS_SOFTBODYSUPPORT:int = 0x2;
		/** @private */
		public static const PHYSICSENGINEFLAGS_MULTITHREADED:int = 0x4;
		/** @private */
		public static const PHYSICSENGINEFLAGS_USEHARDWAREWHENPOSSIBLE:int = 0x8;
		
		/** @private */
		public static const SOLVERMODE_RANDMIZE_ORDER:int = 1;
		/** @private */
		public static const SOLVERMODE_FRICTION_SEPARATE:int = 2;
		/** @private */
		public static const SOLVERMODE_USE_WARMSTARTING:int = 4;
		/** @private */
		public static const SOLVERMODE_USE_2_FRICTION_DIRECTIONS:int = 16;
		/** @private */
		public static const SOLVERMODE_ENABLE_FRICTION_DIRECTION_CACHING:int = 32;
		/** @private */
		public static const SOLVERMODE_DISABLE_VELOCITY_DEPENDENT_FRICTION_DIRECTION:int = 64;
		/** @private */
		public static const SOLVERMODE_CACHE_FRIENDLY:int = 128;
		/** @private */
		public static const SOLVERMODE_SIMD:int = 256;
		/** @private */
		public static const SOLVERMODE_INTERLEAVE_CONTACT_AND_FRICTION_CONSTRAINTS:int = 512;
		/** @private */
		public static const SOLVERMODE_ALLOW_ZERO_LENGTH_FRICTION_DIRECTIONS:int = 1024;
		
		/** @private */
		private static var _nativeTempVector30:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		/** @private */
		private static var _nativeTempVector31:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		/** @private */
		private static var _nativeTempQuaternion0:* = new Laya3D._physics3D.btQuaternion(0, 0, 0, 1);
		/** @private */
		private static var _nativeTempQuaternion1:* = new Laya3D._physics3D.btQuaternion(0, 0, 0, 1);
		/** @private */
		private static var _nativeTempTransform0:* = new Laya3D._physics3D.btTransform();
		/** @private */
		private static var _nativeTempTransform1:* = new Laya3D._physics3D.btTransform();
		/**@private */
		private static var _tempVector30:Vector3 = new Vector3();
		
		/*是否禁用所有模拟器。*/
		public static var disableSimulation:Boolean = false;
		
		/**
		 * 创建限制刚体运动的约束条件。
		 */
		public static function createConstraint():void {//TODO: 两种重载函数
			//TODO:
		}
		
		/**@private	*/
		private var _nativeDiscreteDynamicsWorld:*;
		/**@private	*/
		private var _nativeCollisionWorld:*;
		/**@private	*/
		private var _nativeDispatcher:*;
		/**@private	*/
		private var _nativeCollisionConfiguration:*;
		/**@private	*/
		private var _nativeBroadphase:*;
		/**@private	*/
		private var _nativeSolverInfo:*;
		/**@private	*/
		private var _nativeDispatchInfo:*;
		/**@private	*/
		private var _gravity:Vector3 = new Vector3(0, -10, 0);
		
		/** @private */
		private var _nativeVector3Zero:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		/** @private */
		private var _nativeDefaultQuaternion:* = new Laya3D._physics3D.btQuaternion(0, 0, 0, -1);
		/**@private */
		private var _nativeClosestRayResultCallback:*;
		/**@private */
		private var _nativeAllHitsRayResultCallback:*;
		/**@private */
		private var _nativeClosestConvexResultCallback:*;
		/**@private */
		private var _nativeAllConvexResultCallback:*;
		
		/**@private	*/
		private var _collisionsUtils:CollisionTool = new CollisionTool();
		/**@private	*/
		private var _previousFrameCollisions:Vector.<Collision> = new Vector.<Collision>();
		/**@private	*/
		private var _currentFrameCollisions:Vector.<Collision> = new Vector.<Collision>();
		
		/**@private	*/
		public var _physicsUpdateList:PhysicsUpdateList = new PhysicsUpdateList();
		/**@private	*/
		public var _characters:Vector.<CharacterController> = new Vector.<CharacterController>();
		/**@private	*/
		public var _updatedRigidbodies:int = 0;
		
		/**物理引擎在一帧中用于补偿减速的最大次数：模拟器每帧允许的最大模拟次数，如果引擎运行缓慢,可能需要增加该次数，否则模拟器会丢失“时间",引擎间隔时间小于maxSubSteps*fixedTimeStep非常重要。*/
		public var maxSubSteps:int = 1;
		/**物理模拟器帧的间隔时间:通过减少fixedTimeStep可增加模拟精度，默认是1.0 / 60.0。*/
		public var fixedTimeStep:Number = 1.0 / 60.0;
		
		/**
		 * 获取是否进行连续碰撞检测。
		 * @return  是否进行连续碰撞检测。
		 */
		public function get continuousCollisionDetection():Boolean {
			return _nativeDispatchInfo.get_m_useContinuous();
		}
		
		/**
		 * 设置是否进行连续碰撞检测。
		 * @param value 是否进行连续碰撞检测。
		 */
		public function set continuousCollisionDetection(value:Boolean):void {
			_nativeDispatchInfo.set_m_useContinuous(value);
		}
		
		/**
		 * 获取重力。
		 */
		public function get gravity():Vector3 {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Simulation:Cannot perform this action when the physics engine is set to CollisionsOnly";
			return _gravity;
		}
		
		/**
		 * 设置重力。
		 */
		public function set gravity(value:Vector3):void {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Simulation:Cannot perform this action when the physics engine is set to CollisionsOnly";
			
			_gravity = value;
			var nativeGravity:* = _nativeTempVector30;
			nativeGravity.setValue(-value.x, value.y, value.z);//TODO:是否先get省一个变量
			_nativeDiscreteDynamicsWorld.setGravity(nativeGravity);
		}
		
		/**
		 * @private
		 */
		public function get speculativeContactRestitution():Boolean {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Simulation:Cannot Cannot perform this action when the physics engine is set to CollisionsOnly";
			return _nativeDiscreteDynamicsWorld.getApplySpeculativeContactRestitution();
		}
		
		/**
		 * @private
		 */
		public function set speculativeContactRestitution(value:Boolean):void {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Simulation:Cannot Cannot perform this action when the physics engine is set to CollisionsOnly";
			_nativeDiscreteDynamicsWorld.setApplySpeculativeContactRestitution(value);
		}
		
		/**
		 * @private
		 * 创建一个 <code>Simulation</code> 实例。
		 */
		public function PhysicsSimulation(configuration:PhysicsSettings, flags:int = 0) {
			maxSubSteps = configuration.maxSubSteps;
			fixedTimeStep = configuration.fixedTimeStep;
			
			var physics3D:* = Laya3D._physics3D;
			_nativeCollisionConfiguration = new physics3D.btDefaultCollisionConfiguration();
			_nativeDispatcher = new physics3D.btCollisionDispatcher(_nativeCollisionConfiguration);
			_nativeBroadphase = new physics3D.btDbvtBroadphase();
			_nativeBroadphase.getOverlappingPairCache().setInternalGhostPairCallback(new physics3D.btGhostPairCallback());//this allows characters to have proper physics behavior
			
			var conFlags:int = configuration.flags;
			if (conFlags & PHYSICSENGINEFLAGS_COLLISIONSONLY) {
				_nativeCollisionWorld = new physics3D.btCollisionWorld(_nativeDispatcher, _nativeBroadphase, _nativeCollisionConfiguration);
			} else if (conFlags & PHYSICSENGINEFLAGS_SOFTBODYSUPPORT) {
				throw "PhysicsSimulation:SoftBody processing is not yet available";
			} else {
				var solver:* = new physics3D.btSequentialImpulseConstraintSolver();
				_nativeDiscreteDynamicsWorld = new physics3D.btDiscreteDynamicsWorld(_nativeDispatcher, _nativeBroadphase, solver, _nativeCollisionConfiguration);
				_nativeCollisionWorld = _nativeDiscreteDynamicsWorld;
			}
			
			if (_nativeDiscreteDynamicsWorld) {
				_nativeSolverInfo = _nativeDiscreteDynamicsWorld.getSolverInfo(); //we are required to keep this reference, or the GC will mess up
				_nativeDispatchInfo = _nativeDiscreteDynamicsWorld.getDispatchInfo();
			}
			
			_nativeClosestRayResultCallback = new physics3D.ClosestRayResultCallback(_nativeVector3Zero, _nativeVector3Zero);
			_nativeAllHitsRayResultCallback = new physics3D.AllHitsRayResultCallback(_nativeVector3Zero, _nativeVector3Zero);
			_nativeClosestConvexResultCallback = new physics3D.ClosestConvexResultCallback(_nativeVector3Zero, _nativeVector3Zero);
			_nativeAllConvexResultCallback = new physics3D.AllConvexResultCallback(_nativeVector3Zero, _nativeVector3Zero);//是否TODO:优化C++
			
			physics3D._btGImpactCollisionAlgorithm_RegisterAlgorithm(_nativeDispatcher.a);//注册算法
		}
		
		/**
		 * @private
		 */
		public function _simulate(deltaTime:Number):void {
			_updatedRigidbodies = 0;
			
			if (_nativeDiscreteDynamicsWorld)
				_nativeDiscreteDynamicsWorld.stepSimulation(deltaTime, maxSubSteps, fixedTimeStep);
			else
				_nativeCollisionWorld.PerformDiscreteCollisionDetection();
		
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			var physics3D:* = Laya3D._physics3D;
			if (_nativeDiscreteDynamicsWorld) {
				physics3D.destroy(_nativeDiscreteDynamicsWorld);
				_nativeDiscreteDynamicsWorld = null;
			} else {
				physics3D.destroy(_nativeCollisionWorld);
				_nativeCollisionWorld = null;
			}
			
			physics3D.destroy(_nativeBroadphase);
			_nativeBroadphase = null;
			physics3D.destroy(_nativeDispatcher);
			_nativeDispatcher = null;
			physics3D.destroy(_nativeCollisionConfiguration);
			_nativeCollisionConfiguration = null;
		}
		
		/**
		 * @private
		 */
		public function _addPhysicsCollider(component:PhysicsCollider, group:int, mask:int):void {
			_nativeCollisionWorld.addCollisionObject(component._nativeColliderObject, group, mask);
		}
		
		/**
		 * @private
		 */
		public function _removePhysicsCollider(component:PhysicsCollider):void {
			_nativeCollisionWorld.removeCollisionObject(component._nativeColliderObject);
		}
		
		/**
		 * @private
		 */
		public function _addRigidBody(rigidBody:Rigidbody3D, group:int, mask:int):void {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Simulation:Cannot perform this action when the physics engine is set to CollisionsOnly";
			_nativeCollisionWorld.addRigidBody(rigidBody._nativeColliderObject, group, mask);
		}
		
		/**
		 * @private
		 */
		public function _removeRigidBody(rigidBody:Rigidbody3D):void {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Simulation:Cannot perform this action when the physics engine is set to CollisionsOnly";
			_nativeCollisionWorld.removeRigidBody(rigidBody._nativeColliderObject);
		}
		
		/**
		 * @private
		 */
		public function _addCharacter(character:CharacterController, group:int, mask:int):void {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Simulation:Cannot perform this action when the physics engine is set to CollisionsOnly";
			_nativeCollisionWorld.addCollisionObject(character._nativeColliderObject, group, mask);
			_nativeCollisionWorld.addAction(character._nativeKinematicCharacter);
		}
		
		/**
		 * @private
		 */
		public function _removeCharacter(character:CharacterController):void {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Simulation:Cannot perform this action when the physics engine is set to CollisionsOnly";
			_nativeCollisionWorld.removeCollisionObject(character._nativeColliderObject);
			_nativeCollisionWorld.removeAction(character._nativeKinematicCharacter);
		}
		
		/**
		 * 射线检测第一个碰撞物体。
		 * @param	from 起始位置。
		 * @param	to 结束位置。
		 * @param	out 碰撞结果。
		 * @param   collisonGroup 射线所属碰撞组。
		 * @param   collisionMask 与射线可产生碰撞的组。
		 * @return 	是否成功。
		 */
		public function raycastFromTo(from:Vector3, to:Vector3, out:HitResult = null, collisonGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER, collisionMask:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER):Boolean {
			var rayResultCall:* = _nativeClosestRayResultCallback;
			var rayFrom:* = _nativeTempVector30;
			var rayTo:* = _nativeTempVector31;
			rayFrom.setValue(-from.x, from.y, from.z);
			rayTo.setValue(-to.x, to.y, to.z);
			rayResultCall.set_m_rayFromWorld(rayFrom);
			rayResultCall.set_m_rayToWorld(rayTo);
			rayResultCall.set_m_collisionFilterGroup(collisonGroup);
			rayResultCall.set_m_collisionFilterMask(collisionMask);
			
			rayResultCall.set_m_collisionObject(null);//还原默认值
			rayResultCall.set_m_closestHitFraction(1);//还原默认值
			_nativeCollisionWorld.rayTest(rayFrom, rayTo, rayResultCall);//TODO:out为空可优化,bullet内
			if (rayResultCall.hasHit()) {
				if (out) {
					out.succeeded = true;
					out.collider = PhysicsComponent._physicObjectsMap[rayResultCall.get_m_collisionObject().getUserIndex()];
					out.hitFraction = rayResultCall.get_m_closestHitFraction();
					var nativePoint:* = rayResultCall.get_m_hitPointWorld();
					var point:Vector3 = out.point;
					point.x = -nativePoint.x();
					point.y = nativePoint.y();
					point.z = nativePoint.z();
					var nativeNormal:* = rayResultCall.get_m_hitNormalWorld();
					var normal:Vector3 = out.normal;
					normal.x = -nativeNormal.x();
					normal.y = nativeNormal.y();
					normal.z = nativeNormal.z();
				}
				return true;
			} else {
				if (out)
					out.succeeded = false;
				return false;
			}
		}
		
		/**
		 * 射线检测所有碰撞的物体。
		 * @param	from 起始位置。
		 * @param	to 结束位置。
		 * @param	out 碰撞结果[数组元素会被回收]。
		 * @param   collisonGroup 射线所属碰撞组。
		 * @param   collisionMask 与射线可产生碰撞的组。
		 * @return 	是否成功。
		 */
		public function raycastAllFromTo(from:Vector3, to:Vector3, out:Vector.<HitResult>, collisonGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER, collisionMask:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER):Boolean {
			var rayResultCall:* = _nativeAllHitsRayResultCallback;
			var rayFrom:* = _nativeTempVector30;
			var rayTo:* = _nativeTempVector31;
			
			out.length = 0;
			rayFrom.setValue(-from.x, from.y, from.z);
			rayTo.setValue(-to.x, to.y, to.z);
			rayResultCall.set_m_rayFromWorld(rayFrom);
			rayResultCall.set_m_rayToWorld(rayTo);
			rayResultCall.set_m_collisionFilterGroup(collisonGroup);
			rayResultCall.set_m_collisionFilterMask(collisionMask);
			
			//rayResultCall.set_m_collisionObject(null);//还原默认值
			//rayResultCall.set_m_closestHitFraction(1);//还原默认值
			var collisionObjects:* = rayResultCall.get_m_collisionObjects();
			var nativePoints:* = rayResultCall.get_m_hitPointWorld();
			var nativeNormals:* = rayResultCall.get_m_hitNormalWorld();
			var nativeFractions:* = rayResultCall.get_m_hitFractions();
			collisionObjects.clear();//清空检测队列
			nativePoints.clear();
			nativeNormals.clear();
			nativeFractions.clear();
			_nativeCollisionWorld.rayTest(rayFrom, rayTo, rayResultCall);
			var count:int = collisionObjects.size();
			if (count > 0) {
				
				_collisionsUtils.recoverAllHitResultsPool();
				for (var i:int = 0; i < count; i++) {
					var hitResult:HitResult = _collisionsUtils.getHitResult();
					out.push(hitResult);
					hitResult.succeeded = true;
					hitResult.collider = PhysicsComponent._physicObjectsMap[collisionObjects.at(i).getUserIndex()];
					hitResult.hitFraction = nativeFractions.at(i);
					var nativePoint:* = nativePoints.at(i);//取出后需要立即赋值,防止取出法线时被覆盖
					var pointE:Vector3 = hitResult.point;
					pointE.x = -nativePoint.x();
					pointE.y = nativePoint.y();
					pointE.z = nativePoint.z();
					var nativeNormal:* = nativeNormals.at(i);
					var normalE:Vector3 = hitResult.normal;
					normalE.x = -nativeNormal.x();
					normalE.y = nativeNormal.y();
					normalE.z = nativeNormal.z();
				}
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 *  射线检测第一个碰撞物体。
		 * @param  	ray        射线
		 * @param  	outHitInfo 与该射线发生碰撞的第一个碰撞器的碰撞信息
		 * @param  	distance   射线长度,默认为最大值
		 * @param   collisonGroup 射线所属碰撞组。
		 * @param   collisionMask 与射线可产生碰撞的组。
		 * @return 	是否检测成功。
		 */
		public function rayCast(ray:Ray, outHitResult:HitResult = null, distance:Number = 2147483647/*Int.MAX_VALUE*/, collisonGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER, collisionMask:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER):Boolean {
			var from:Vector3 = ray.origin;
			var to:Vector3 = _tempVector30;
			Vector3.normalize(ray.direction, to);
			Vector3.scale(to, distance, to);
			Vector3.add(from, to, to);
			return raycastFromTo(from, to, outHitResult, collisonGroup, collisionMask);
		}
		
		/**
		 * 射线检测所有碰撞的物体。
		 * @param  	ray        射线
		 * @param  	out 碰撞结果[数组元素会被回收]。
		 * @param  	distance   射线长度,默认为最大值
		 * @param   collisonGroup 射线所属碰撞组。
		 * @param   collisionMask 与射线可产生碰撞的组。
		 * @return 	是否检测成功。
		 */
		public function rayCastAll(ray:Ray, out:Vector.<HitResult>, distance:Number = 2147483647/*Int.MAX_VALUE*/, collisonGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER, collisionMask:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER):Boolean {
			var from:Vector3 = ray.origin;
			var to:Vector3 = _tempVector30;
			Vector3.normalize(ray.direction, to);
			Vector3.scale(to, distance, to);
			Vector3.add(from, to, to);
			return raycastAllFromTo(from, to, out, collisonGroup, collisionMask);
		}
		
		/**
		 * 形状检测第一个碰撞的物体。
		 * @param   shape 形状。
		 * @param	fromPosition 世界空间起始位置。
		 * @param	toPosition 世界空间结束位置。
		 * @param	out 碰撞结果。
		 * @param	fromRotation 起始旋转。
		 * @param	toRotation 结束旋转。
		 * @param   collisonGroup 射线所属碰撞组。
		 * @param   collisionMask 与射线可产生碰撞的组。
		 * @return 	是否成功。
		 */
		public function shapeCast(shape:ColliderShape, fromPosition:Vector3, toPosition:Vector3, out:HitResult = null, fromRotation:Quaternion = null, toRotation:Quaternion = null, collisonGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER, collisionMask:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER, allowedCcdPenetration:Number = 0.0):Boolean {
			var convexResultCall:* = _nativeClosestConvexResultCallback;
			var convexPosFrom:* = _nativeTempVector30;
			var convexPosTo:* = _nativeTempVector31;
			var convexRotFrom:* = _nativeTempQuaternion0;
			var convexRotTo:* = _nativeTempQuaternion1;
			var convexTransform:* = _nativeTempTransform0;
			var convexTransTo:* = _nativeTempTransform1;
			
			var sweepShape:* = shape._nativeShape;
			
			convexPosFrom.setValue(-fromPosition.x, fromPosition.y, fromPosition.z);
			convexPosTo.setValue(-toPosition.x, toPosition.y, toPosition.z);
			//convexResultCall.set_m_convexFromWorld(convexPosFrom);
			//convexResultCall.set_m_convexToWorld(convexPosTo);
			convexResultCall.set_m_collisionFilterGroup(collisonGroup);
			convexResultCall.set_m_collisionFilterMask(collisionMask);
			
			convexTransform.setOrigin(convexPosFrom);
			convexTransTo.setOrigin(convexPosTo);
			
			if (fromRotation) {
				convexRotFrom.setValue(-fromRotation.x, fromRotation.y, fromRotation.z, -fromRotation.w);
				convexTransform.setRotation(convexRotFrom);
			} else {
				convexTransform.setRotation(_nativeDefaultQuaternion);
			}
			if (toRotation) {
				convexRotTo.setValue(-toRotation.x, toRotation.y, toRotation.z, -toRotation.w);
				convexTransTo.setRotation(convexRotTo);
			} else {
				convexTransTo.setRotation(_nativeDefaultQuaternion);
			}
			
			convexResultCall.set_m_hitCollisionObject(null);//还原默认值
			convexResultCall.set_m_closestHitFraction(1);//还原默认值
			_nativeCollisionWorld.convexSweepTest(sweepShape, convexTransform, convexTransTo, convexResultCall, allowedCcdPenetration);
			if (convexResultCall.hasHit()) {
				if (out) {
					out.succeeded = true;
					out.collider = PhysicsComponent._physicObjectsMap[convexResultCall.get_m_hitCollisionObject().getUserIndex()];
					out.hitFraction = convexResultCall.get_m_closestHitFraction();
					var nativePoint:* = convexResultCall.get_m_hitPointWorld();
					var nativeNormal:* = convexResultCall.get_m_hitNormalWorld();
					var point:Vector3 = out.point;
					var normal:Vector3 = out.normal;
					point.x = -nativePoint.x();
					point.y = nativePoint.y();
					point.z = nativePoint.z();
					normal.x = -nativeNormal.x();
					normal.y = nativeNormal.y();
					normal.z = nativeNormal.z();
				}
				return true;
			} else {
				if (out)
					out.succeeded = false;
				return false;
			}
		}
		
		/**
		 * 形状检测所有碰撞的物体。
		 * @param   shape 形状。
		 * @param	fromPosition 世界空间起始位置。
		 * @param	toPosition 世界空间结束位置。
		 * @param	out 碰撞结果[数组元素会被回收]。
		 * @param	fromRotation 起始旋转。
		 * @param	toRotation 结束旋转。
		 * @param   collisonGroup 射线所属碰撞组。
		 * @param   collisionMask 与射线可产生碰撞的组。
		 * @return 	是否成功。
		 */
		public function shapeCastAll(shape:ColliderShape, fromPosition:Vector3, toPosition:Vector3, out:Vector.<HitResult>, fromRotation:Quaternion = null, toRotation:Quaternion = null, collisonGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER, collisionMask:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER, allowedCcdPenetration:Number = 0.0):Boolean {
			var convexResultCall:* = _nativeAllConvexResultCallback;
			var convexPosFrom:* = _nativeTempVector30;
			var convexPosTo:* = _nativeTempVector31;
			var convexRotFrom:* = _nativeTempQuaternion0;
			var convexRotTo:* = _nativeTempQuaternion1;
			var convexTransform:* = _nativeTempTransform0;
			var convexTransTo:* = _nativeTempTransform1;
			
			var sweepShape:* = shape._nativeShape;
			
			out.length = 0;
			convexPosFrom.setValue(-fromPosition.x, fromPosition.y, fromPosition.z);
			convexPosTo.setValue(-toPosition.x, toPosition.y, toPosition.z);
			
			//convexResultCall.set_m_convexFromWorld(convexPosFrom);
			//convexResultCall.set_m_convexToWorld(convexPosTo);
			
			convexResultCall.set_m_collisionFilterGroup(collisonGroup);
			convexResultCall.set_m_collisionFilterMask(collisionMask);
			
			convexTransform.setOrigin(convexPosFrom);
			convexTransTo.setOrigin(convexPosTo);
			if (fromRotation) {
				convexRotFrom.setValue(-fromRotation.x, fromRotation.y, fromRotation.z, -fromRotation.w);
				convexTransform.setRotation(convexRotFrom);
			} else {
				convexTransform.setRotation(_nativeDefaultQuaternion);
			}
			if (toRotation) {
				convexRotTo.setValue(-toRotation.x, toRotation.y, toRotation.z, -toRotation.w);
				convexTransTo.setRotation(convexRotTo);
			} else {
				convexTransTo.setRotation(_nativeDefaultQuaternion);
			}
			
			var collisionObjects:* = convexResultCall.get_m_collisionObjects();
			collisionObjects.clear();//清空检测队列
			_nativeCollisionWorld.convexSweepTest(sweepShape, convexTransform, convexTransTo, convexResultCall, allowedCcdPenetration);
			var count:int = collisionObjects.size();
			if (count > 0) {
				var nativePoints:* = convexResultCall.get_m_hitPointWorld();
				var nativeNormals:* = convexResultCall.get_m_hitNormalWorld();
				var nativeFractions:* = convexResultCall.get_m_hitFractions();
				for (var i:int = 0; i < count; i++) {
					var hitResult:HitResult = _collisionsUtils.getHitResult();
					out.push(hitResult);
					hitResult.succeeded = true;
					hitResult.collider = PhysicsComponent._physicObjectsMap[collisionObjects.at(i).getUserIndex()];
					hitResult.hitFraction = nativeFractions.at(i);
					var nativePoint:* = nativePoints.at(i);
					var point:Vector3 = hitResult.point;
					point.x = -nativePoint.x();
					point.y = nativePoint.y();
					point.z = nativePoint.z();
					var nativeNormal:* = nativeNormals.at(i);
					var normal:Vector3 = hitResult.normal;
					normal.x = -nativeNormal.x();
					normal.y = nativeNormal.y();
					normal.z = nativeNormal.z();
				}
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * 添加刚体运动的约束条件。
		 * @param constraint 约束。
		 * @param disableCollisionsBetweenLinkedBodies 是否禁用
		 */
		public function addConstraint(constraint:Constraint3D, disableCollisionsBetweenLinkedBodies:Boolean = false):void {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Cannot perform this action when the physics engine is set to CollisionsOnly";
			_nativeDiscreteDynamicsWorld.addConstraint(constraint._nativeConstraint, disableCollisionsBetweenLinkedBodies);
			constraint._simulation = this;
		}
		
		/**
		 * 移除刚体运动的约束条件。
		 */
		public function removeConstraint(constraint:Constraint3D):void {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Cannot perform this action when the physics engine is set to CollisionsOnly";
			_nativeDiscreteDynamicsWorld.removeConstraint(constraint._nativeConstraint);
		}
		
		/**
		 * @private
		 */
		public function _updatePhysicsTransformFromRender():void {
			var elements:* = _physicsUpdateList.elements;
			for (var i:int = 0, n:int = _physicsUpdateList.length; i < n; i++) {
				var physicCollider:PhysicsComponent = elements[i];
				physicCollider._derivePhysicsTransformation(false);
				physicCollider._inPhysicUpdateListIndex = -1;//置空索引
			}
			_physicsUpdateList.length = 0;//清空物理更新队列
		}
		
		/**
		 * @private
		 */
		public function _updateCharacters():void {
			for (var i:int = 0, n:int = _characters.length; i < n; i++) {
				var character:PhysicsComponent = _characters[i];
				character._updateTransformComponent(character._nativeColliderObject.getWorldTransform());
			}
		}
		
		/**
		 * @private
		 */
		public function _updateCollisions():void {
			_collisionsUtils.recoverAllContactPointsPool();
			var previous:Vector.<Collision> = _currentFrameCollisions;
			_currentFrameCollisions = _previousFrameCollisions;
			_currentFrameCollisions.length = 0;
			_previousFrameCollisions = previous;
			var loopCount:int = Stat.loopCount;
			var numManifolds:int = _nativeDispatcher.getNumManifolds();
			for (var i:int = 0; i < numManifolds; i++) {
				var contactManifold:* = _nativeDispatcher.getManifoldByIndexInternal(i);//1.可能同时返回A和B、B和A 2.可能同时返回A和B多次(可能和CCD有关)
				var componentA:PhysicsTriggerComponent = PhysicsComponent._physicObjectsMap[contactManifold.getBody0().getUserIndex()];
				var componentB:PhysicsTriggerComponent = PhysicsComponent._physicObjectsMap[contactManifold.getBody1().getUserIndex()];
				var collision:Collision = null;
				var isFirstCollision:Boolean;//可能同时返回A和B多次,需要过滤
				var contacts:Vector.<ContactPoint> = null;
				var isTrigger:Boolean = componentA.isTrigger || componentB.isTrigger;
				if (isTrigger && ((componentA.owner as Sprite3D)._needProcessTriggers || (componentB.owner as Sprite3D)._needProcessTriggers)) {
					var numContacts:int = contactManifold.getNumContacts();
					for (var j:int = 0; j < numContacts; j++) {
						var pt:* = contactManifold.getContactPoint(j);
						var distance:Number = pt.getDistance();
						if (distance <= 0) {
							collision = _collisionsUtils.getCollision(componentA, componentB);
							contacts = collision.contacts;
							isFirstCollision = collision._updateFrame !== loopCount;
							if (isFirstCollision) {
								collision._isTrigger = true;
								contacts.length = 0;
							}
							break;
						}
					}
				} else if ((componentA.owner as Sprite3D)._needProcessCollisions || (componentB.owner as Sprite3D)._needProcessCollisions) {
					if (componentA._enableProcessCollisions || componentB._enableProcessCollisions) {//例：运动刚体需跳过
						numContacts = contactManifold.getNumContacts();
						for (j = 0; j < numContacts; j++) {
							pt = contactManifold.getContactPoint(j);
							distance = pt.getDistance();
							if (distance <= 0) {
								var contactPoint:ContactPoint = _collisionsUtils.getContactPoints();
								contactPoint.colliderA = componentA;
								contactPoint.colliderB = componentB;
								contactPoint.distance = distance;
								var nativeNormal:* = pt.get_m_normalWorldOnB();
								var normal:Vector3 = contactPoint.normal;
								normal.x = -nativeNormal.x();
								normal.y = nativeNormal.y();
								normal.z = nativeNormal.z();
								var nativePostionA:* = pt.get_m_positionWorldOnA();
								var positionOnA:Vector3 = contactPoint.positionOnA;
								positionOnA.x = -nativePostionA.x();
								positionOnA.y = nativePostionA.y();
								positionOnA.z = nativePostionA.z();
								var nativePostionB:* = pt.get_m_positionWorldOnB();
								var positionOnB:Vector3 = contactPoint.positionOnB;
								positionOnB.x = -nativePostionB.x();
								positionOnB.y = nativePostionB.y();
								positionOnB.z = nativePostionB.z();
								
								if (!collision) {
									collision = _collisionsUtils.getCollision(componentA, componentB);
									contacts = collision.contacts;
									isFirstCollision = collision._updateFrame !== loopCount;
									if (isFirstCollision) {
										collision._isTrigger = false;
										contacts.length = 0;
									}
								}
								contacts.push(contactPoint);
							}
						}
					}
				}
				if (collision && isFirstCollision) {
					_currentFrameCollisions.push(collision);
					collision._setUpdateFrame(loopCount);
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _eventScripts():void {
			var loopCount:int = Stat.loopCount;
			for (var i:int = 0, n:int = _currentFrameCollisions.length; i < n; i++) {
				var curFrameCol:Collision = _currentFrameCollisions[i];
				var colliderA:PhysicsComponent = curFrameCol._colliderA;
				var colliderB:PhysicsComponent = curFrameCol._colliderB;
				if (colliderA.destroyed || colliderB.destroyed)//前一个循环可能会销毁后面循环的同一物理组件
					continue;
				if (loopCount - curFrameCol._lastUpdateFrame === 1) {
					var ownerA:Sprite3D = colliderA.owner as Sprite3D;
					var scriptsA:Vector.<Script3D> = ownerA._scripts;
					if (scriptsA) {
						if (curFrameCol._isTrigger) {
							if (ownerA._needProcessTriggers) {
								for (var j:int = 0, m:int = scriptsA.length; j < m; j++)
									scriptsA[j].onTriggerStay(colliderB);
							}
						} else {
							if (ownerA._needProcessCollisions) {
								for (j = 0, m = scriptsA.length; j < m; j++) {
									curFrameCol.other = colliderB;
									scriptsA[j].onCollisionStay(curFrameCol);
								}
							}
						}
					}
					var ownerB:Sprite3D = colliderB.owner as Sprite3D;
					var scriptsB:Vector.<Script3D> = ownerB._scripts;
					if (scriptsB) {
						if (curFrameCol._isTrigger) {
							if (ownerB._needProcessTriggers) {
								for (j = 0, m = scriptsB.length; j < m; j++)
									scriptsB[j].onTriggerStay(colliderA);
							}
						} else {
							if (ownerB._needProcessCollisions) {
								for (j = 0, m = scriptsB.length; j < m; j++) {
									curFrameCol.other = colliderA;
									scriptsB[j].onCollisionStay(curFrameCol);
								}
							}
						}
					}
				} else {
					ownerA = colliderA.owner as Sprite3D;
					scriptsA = ownerA._scripts;
					if (scriptsA) {
						if (curFrameCol._isTrigger) {
							if (ownerA._needProcessTriggers) {
								for (j = 0, m = scriptsA.length; j < m; j++)
									scriptsA[j].onTriggerEnter(colliderB);
							}
						} else {
							if (ownerA._needProcessCollisions) {
								for (j = 0, m = scriptsA.length; j < m; j++) {
									curFrameCol.other = colliderB;
									scriptsA[j].onCollisionEnter(curFrameCol);
								}
							}
						}
					}
					ownerB = colliderB.owner as Sprite3D;
					scriptsB = ownerB._scripts;
					if (scriptsB) {
						if (curFrameCol._isTrigger) {
							if (ownerB._needProcessTriggers) {
								for (j = 0, m = scriptsB.length; j < m; j++)
									scriptsB[j].onTriggerEnter(colliderA);
							}
						} else {
							if (ownerB._needProcessCollisions) {
								for (j = 0, m = scriptsB.length; j < m; j++) {
									curFrameCol.other = colliderA;
									scriptsB[j].onCollisionEnter(curFrameCol);
								}
							}
							
						}
					}
				}
			}
			
			for (i = 0, n = _previousFrameCollisions.length; i < n; i++) {
				var preFrameCol:Collision = _previousFrameCollisions[i];
				var preColliderA:PhysicsComponent = preFrameCol._colliderA;
				var preColliderB:PhysicsComponent = preFrameCol._colliderB;
				if (preColliderA.destroyed || preColliderB.destroyed)
					continue;
				if (loopCount - preFrameCol._updateFrame === 1) {
					_collisionsUtils.recoverCollision(preFrameCol);//回收collision对象
					ownerA = preColliderA.owner as Sprite3D;
					scriptsA = ownerA._scripts;
					if (scriptsA) {
						if (preFrameCol._isTrigger) {
							if (ownerA._needProcessTriggers) {
								for (j = 0, m = scriptsA.length; j < m; j++)
									scriptsA[j].onTriggerExit(preColliderB);
							}
						} else {
							if (ownerA._needProcessCollisions) {
								for (j = 0, m = scriptsA.length; j < m; j++) {
									preFrameCol.other = preColliderB;
									scriptsA[j].onCollisionExit(preFrameCol);
								}
							}
						}
					}
					ownerB = preColliderB.owner as Sprite3D;
					scriptsB = ownerB._scripts;
					if (scriptsB) {
						if (preFrameCol._isTrigger) {
							if (ownerB._needProcessTriggers) {
								for (j = 0, m = scriptsB.length; j < m; j++)
									scriptsB[j].onTriggerExit(preColliderA);
							}
						} else {
							if (ownerB._needProcessCollisions) {
								for (j = 0, m = scriptsB.length; j < m; j++) {
									preFrameCol.other = preColliderA;
									scriptsB[j].onCollisionExit(preFrameCol);
								}
							}
						}
					}
				}
			}
		}
		
		/**
		 * 清除力。
		 */
		public function clearForces():void {
			if (!_nativeDiscreteDynamicsWorld)
				throw "Cannot perform this action when the physics engine is set to CollisionsOnly";
			_nativeDiscreteDynamicsWorld.clearForces();
		}
	
	}

}