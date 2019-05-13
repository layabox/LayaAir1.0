package laya.d3.physics {
	import laya.components.Component;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.physics.PhysicsSimulation;
	import laya.d3.physics.shape.ColliderShape;
	import laya.d3.physics.shape.CompoundColliderShape;
	import laya.d3.utils.Physics3DUtils;
	import laya.events.Event;
	
	/**
	 * <code>PhysicsComponent</code> 类用于创建物理组件的父类。
	 */
	public class PhysicsComponent extends Component {
		/** @private */
		public static const ACTIVATIONSTATE_ACTIVE_TAG:int = 1;
		/** @private */
		public static const ACTIVATIONSTATE_ISLAND_SLEEPING:int = 2;
		/** @private */
		public static const ACTIVATIONSTATE_WANTS_DEACTIVATION:int = 3;
		/** @private */
		public static const ACTIVATIONSTATE_DISABLE_DEACTIVATION:int = 4;
		/** @private */
		public static const ACTIVATIONSTATE_DISABLE_SIMULATION:int = 5;
		
		/** @private */
		public static const COLLISIONFLAGS_STATIC_OBJECT:int = 1;
		/** @private */
		public static const COLLISIONFLAGS_KINEMATIC_OBJECT:int = 2;
		/** @private */
		public static const COLLISIONFLAGS_NO_CONTACT_RESPONSE:int = 4;
		/** @private */
		public static const COLLISIONFLAGS_CUSTOM_MATERIAL_CALLBACK:int = 8;//this allows per-triangle material (friction/restitution)
		/** @private */
		public static const COLLISIONFLAGS_CHARACTER_OBJECT:int = 16;
		/** @private */
		public static const COLLISIONFLAGS_DISABLE_VISUALIZE_OBJECT:int = 32;//disable debug drawing
		/** @private */
		public static const COLLISIONFLAGS_DISABLE_SPU_COLLISION_PROCESSING:int = 64;//disable parallel/SPU processing
		
		/**@private */
		protected static var _tempVector30:Vector3 = new Vector3();
		/**@private */
		protected static var _tempQuaternion0:Quaternion = new Quaternion();
		/**@private */
		protected static var _tempQuaternion1:Quaternion = new Quaternion();
		/**@private */
		protected static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected static var _nativeVector30:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		/** @private */
		protected static var _nativeQuaternion0:* = new Laya3D._physics3D.btQuaternion(0, 0, 0, 1);
		
		/**@private */
		public static var _physicObjectsMap:Object = {};
		/** @private */
		public static var _addUpdateList:Boolean = true;
		
		/**
		 * @private
		 */
		private static function _createAffineTransformationArray(tranX:Number, tranY:Number, tranZ:Number, rotX:Number, rotY:Number, rotZ:Number, rotW:Number, scale:Float32Array, outE:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var x2:Number = rotX + rotX, y2:Number = rotY + rotY, z2:Number = rotZ + rotZ;
			var xx:Number = rotX * x2, xy:Number = rotX * y2, xz:Number = rotX * z2, yy:Number = rotY * y2, yz:Number = rotY * z2, zz:Number = rotZ * z2;
			var wx:Number = rotW * x2, wy:Number = rotW * y2, wz:Number = rotW * z2, sx:Number = scale[0], sy:Number = scale[1], sz:Number = scale[2];
			
			outE[0] = (1 - (yy + zz)) * sx;
			outE[1] = (xy + wz) * sx;
			outE[2] = (xz - wy) * sx;
			outE[3] = 0;
			outE[4] = (xy - wz) * sy;
			outE[5] = (1 - (xx + zz)) * sy;
			outE[6] = (yz + wx) * sy;
			outE[7] = 0;
			outE[8] = (xz + wy) * sz;
			outE[9] = (yz - wx) * sz;
			outE[10] = (1 - (xx + yy)) * sz;
			outE[11] = 0;
			outE[12] = tranX;
			outE[13] = tranY;
			outE[14] = tranZ;
			outE[15] = 1;
		}
		
		/**
		 * @private
		 */
		private static function physicVector3TransformQuat(source:Vector3, qx:Number, qy:Number, qz:Number, qw:Number, out:Vector3):void {
			var x:Number = source.x, y:Number = source.y, z:Number = source.z,
			
			ix:Number = qw * x + qy * z - qz * y, iy:Number = qw * y + qz * x - qx * z, iz:Number = qw * z + qx * y - qy * x, iw:Number = -qx * x - qy * y - qz * z;
			
			out.x = ix * qw + iw * -qx + iy * -qz - iz * -qy;
			out.y = iy * qw + iw * -qy + iz * -qx - ix * -qz;
			out.z = iz * qw + iw * -qz + ix * -qy - iy * -qx;
		}
		
		/**
		 * @private
		 */
		private static function physicQuaternionMultiply(lx:Number, ly:Number, lz:Number, lw:Number, right:Quaternion, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var rx:Number = right.x;
			var ry:Number = right.y;
			var rz:Number = right.z;
			var rw:Number = right.w;
			var a:Number = (ly * rz - lz * ry);
			var b:Number = (lz * rx - lx * rz);
			var c:Number = (lx * ry - ly * rx);
			var d:Number = (lx * rx + ly * ry + lz * rz);
			out.x = (lx * rw + rx * lw) + a;
			out.y = (ly * rw + ry * lw) + b;
			out.z = (lz * rw + rz * lw) + c;
			out.w = lw * rw - d;
		}
		
		/** @private */
		private var _restitution:Number = 0.0;
		/** @private */
		private var _friction:Number = 0.5;
		/** @private */
		private var _rollingFriction:Number = 0.0;
		/** @private */
		private var _ccdMotionThreshold:Number = 0.0;
		/** @private */
		private var _ccdSweptSphereRadius:Number = 0.0;
		
		/** @private */
		protected var _collisionGroup:int = Physics3DUtils.COLLISIONFILTERGROUP_DEFAULTFILTER;
		/** @private */
		protected var _canCollideWith:int = Physics3DUtils.COLLISIONFILTERGROUP_ALLFILTER;
		/** @private */
		protected var _colliderShape:ColliderShape = null;
		/** @private */
		protected var _transformFlag:int = 2147483647 /*int.MAX_VALUE*/;
		
		/** @private */
		public var _nativeColliderObject:*;//TODO:不用声明,TODO:删除相关判断
		/** @private */
		public var _simulation:PhysicsSimulation;
		/** @private */
		public var _enableProcessCollisions:Boolean = true;
		/** @private */
		public var _inPhysicUpdateListIndex:int = -1;
		
		/** 是否可以缩放Shape。 */
		public var canScaleShape:Boolean = true;
		
		/**
		 * 获取弹力。
		 * @return 弹力。
		 */
		public function get restitution():Number {
			return _restitution;
		}
		
		/**
		 * 设置弹力。
		 * @param 弹力。
		 */
		public function set restitution(value:Number):void {
			_restitution = value;
			_nativeColliderObject && _nativeColliderObject.setRestitution(value);
		}
		
		/**
		 * 获取摩擦力。
		 * @return 摩擦力。
		 */
		public function get friction():Number {
			return _friction;
		}
		
		/**
		 * 设置摩擦力。
		 * @param value 摩擦力。
		 */
		public function set friction(value:Number):void {
			_friction = value;
			_nativeColliderObject && _nativeColliderObject.setFriction(value);
		}
		
		/**
		 * 获取滚动摩擦力。
		 * @return 滚动摩擦力。
		 */
		public function get rollingFriction():Number {
			return _nativeColliderObject.getRollingFriction();
		}
		
		/**
		 * 设置滚动摩擦力。
		 * @param 滚动摩擦力。
		 */
		public function set rollingFriction(value:Number):void {
			_rollingFriction = value;
			_nativeColliderObject && _nativeColliderObject.setRollingFriction(value);
		}
		
		/**
		 *获取用于连续碰撞检测(CCD)的速度阈值,当物体移动速度小于该值时不进行CCD检测,防止快速移动物体(例如:子弹)错误的穿过其它物体,0表示禁止。
		 * @return 连续碰撞检测(CCD)的速度阈值。
		 */
		public function get ccdMotionThreshold():Number {
			return _ccdMotionThreshold;
		}
		
		/**
		 *设置用于连续碰撞检测(CCD)的速度阈值，当物体移动速度小于该值时不进行CCD检测,防止快速移动物体(例如:子弹)错误的穿过其它物体,0表示禁止。
		 * @param value 连续碰撞检测(CCD)的速度阈值。
		 */
		public function set ccdMotionThreshold(value:Number):void {
			_ccdMotionThreshold = value;
			_nativeColliderObject && _nativeColliderObject.setCcdMotionThreshold(value);
		}
		
		/**
		 *获取用于进入连续碰撞检测(CCD)范围的球半径。
		 * @return 球半径。
		 */
		public function get ccdSweptSphereRadius():Number {
			return _ccdSweptSphereRadius;
		}
		
		/**
		 *设置用于进入连续碰撞检测(CCD)范围的球半径。
		 * @param 球半径。
		 */
		public function set ccdSweptSphereRadius(value:Number):void {
			_ccdSweptSphereRadius = value;
			_nativeColliderObject && _nativeColliderObject.setCcdSweptSphereRadius(value);
		}
		
		/**
		 * 获取是否激活。
		 */
		public function get isActive():Boolean {
			return _nativeColliderObject ? _nativeColliderObject.isActive() : false;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set enabled(value:Boolean):void {
			if (_simulation && _colliderShape) {
				if (value) {
					_derivePhysicsTransformation(true);
					_addToSimulation();
				} else {
					_removeFromSimulation();
				}
			}
			super.enabled = value;
		}
		
		/**
		 * 获取碰撞形状。
		 */
		public function get colliderShape():ColliderShape {
			return _colliderShape;
		}
		
		/**
		 * 设置碰撞形状。
		 */
		public function set colliderShape(value:ColliderShape):void {
			var lastColliderShape:ColliderShape = _colliderShape;
			if (lastColliderShape) {
				lastColliderShape._attatched = false;
				lastColliderShape._attatchedCollisionObject = null;
			}
			
			_colliderShape = value;
			if (value) {
				if (value._attatched) {
					throw "PhysicsComponent: this shape has attatched to other entity.";
				} else {
					value._attatched = true;
					value._attatchedCollisionObject = this;
				}
				
				if (_nativeColliderObject) {
					_nativeColliderObject.setCollisionShape(value._nativeShape);
					var canInSimulation:Boolean = _simulation && _enabled;
					(canInSimulation && lastColliderShape) && (_removeFromSimulation());//修改shape必须把Collison从物理世界中移除再重新添加
					_onShapeChange(value);//修改shape会计算惯性
					if (canInSimulation) {
						_derivePhysicsTransformation(true);
						_addToSimulation();
					}
				}
			} else {
				if (_simulation && _enabled)
					lastColliderShape && _removeFromSimulation();
			}
		}
		
		/**
		 * 获取模拟器。
		 * @return 模拟器。
		 */
		public function get simulation():PhysicsSimulation {
			return _simulation;
		}
		
		/**
		 * 获取所属碰撞组。
		 * @return 所属碰撞组。
		 */
		public function get collisionGroup():int {
			return _collisionGroup;
		}
		
		/**
		 * 设置所属碰撞组。
		 * @param 所属碰撞组。
		 */
		public function set collisionGroup(value:int):void {
			if (_collisionGroup !== value) {
				_collisionGroup = value;
				if (_simulation && _colliderShape && _enabled) {
					_removeFromSimulation();
					_addToSimulation();
				}
			}
		}
		
		/**
		 * 获取可碰撞的碰撞组。
		 * @return 可碰撞组。
		 */
		public function get canCollideWith():int {
			return _canCollideWith;
		}
		
		/**
		 * 设置可碰撞的碰撞组。
		 * @param 可碰撞组。
		 */
		public function set canCollideWith(value:int):void {
			if (_canCollideWith !== value) {
				_canCollideWith = value;
				if (_simulation && _colliderShape && _enabled) {
					_removeFromSimulation();
					_addToSimulation();
				}
			}
		}
		
		/**
		 * 创建一个 <code>PhysicsComponent</code> 实例。
		 * @param collisionGroup 所属碰撞组。
		 * @param canCollideWith 可产生碰撞的碰撞组。
		 */
		public function PhysicsComponent(collisionGroup:int, canCollideWith:int) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_collisionGroup = collisionGroup;
			_canCollideWith = canCollideWith;
			_physicObjectsMap[id] = this;
		}
		
		/**
		 * @private
		 */
		public function _isValid():Boolean {
			return _simulation && _colliderShape && _enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			(data.collisionGroup != null) && (collisionGroup = data.collisionGroup);
			(data.canCollideWith != null) && (canCollideWith = data.canCollideWith);
			(data.ccdMotionThreshold != null) && (ccdMotionThreshold = data.ccdMotionThreshold);
			(data.ccdSweptSphereRadius != null) && (ccdSweptSphereRadius = data.ccdSweptSphereRadius);
		}
		
		/**
		 * @private
		 */
		protected function _parseShape(shapesData:Array):void {
			var shapeCount:int = shapesData.length;
			if (shapeCount === 1) {
				var shape:ColliderShape = ColliderShape._creatShape(shapesData[0]);
				colliderShape = shape;
			} else {
				var compoundShape:CompoundColliderShape = new CompoundColliderShape();
				for (var i:int = 0; i < shapeCount; i++) {
					shape = ColliderShape._creatShape(shapesData[i]);
					compoundShape.addChildShape(shape);
				}
				colliderShape = compoundShape;
			}
		}
		
		/**
		 * @private
		 */
		protected function _onScaleChange(scale:Vector3):void {
			_colliderShape._setScale(scale);
		}
		
		/**
		 * @private
		 */
		public function _setTransformFlag(type:int, value:Boolean):void {
			if (value)
				_transformFlag |= type;
			else
				_transformFlag &= ~type;
		}
		
		/**
		 * @private
		 */
		public function _getTransformFlag(type:int):Boolean {
			return (_transformFlag & type) != 0;
		}
		
		/**
		 * @private
		 */
		public function _addToSimulation():void {
		}
		
		/**
		 * @private
		 */
		public function _removeFromSimulation():void {
		
		}
		
		/**
		 * 	@private
		 */
		public function _derivePhysicsTransformation(force:Boolean):void {
			_innerDerivePhysicsTransformation(_nativeColliderObject.getWorldTransform(), force);
		}
		
		/**
		 * 	@private
		 *	通过渲染矩阵更新物理矩阵。
		 */
		public function _innerDerivePhysicsTransformation(physicTransformOut:*, force:Boolean):void {
			var transform:Transform3D = (owner as Sprite3D)._transform;
			var rotation:Quaternion = transform.rotation;
			if (force || _getTransformFlag(Transform3D.TRANSFORM_WORLDPOSITION)) {
				var shapeOffset:Vector3 = _colliderShape.localOffset;
				var position:Vector3 = transform.position;
				var nativePosition:* = _nativeVector30;
				if (shapeOffset.x !== 0 || shapeOffset.y !== 0 || shapeOffset.z !== 0) {
					var physicPosition:Vector3 = _tempVector30;
					physicVector3TransformQuat(shapeOffset, rotation.x, rotation.y, rotation.z, rotation.w, physicPosition);
					Vector3.add(position, physicPosition, physicPosition);
					nativePosition.setValue(-physicPosition.x, physicPosition.y, physicPosition.z);
				} else {
					nativePosition.setValue(-position.x, position.y, position.z);
				}
				physicTransformOut.setOrigin(nativePosition);
				_setTransformFlag(Transform3D.TRANSFORM_WORLDPOSITION, false);
			}
			
			if (force || _getTransformFlag(Transform3D.TRANSFORM_WORLDQUATERNION)) {
				var shapeRotation:Quaternion = _colliderShape.localRotation;
				var nativeRotation:* = _nativeQuaternion0;
				if (shapeRotation.x !== 0 || shapeRotation.y !== 0 || shapeRotation.z !== 0 || shapeRotation.w !== 1) {
					var physicRotation:Quaternion = _tempQuaternion0;
					physicQuaternionMultiply(rotation.x, rotation.y, rotation.z, rotation.w, shapeRotation, physicRotation);
					nativeRotation.setValue(-physicRotation.x, physicRotation.y, physicRotation.z, -physicRotation.w);
				} else {
					nativeRotation.setValue(-rotation.x, rotation.y, rotation.z, -rotation.w);
				}
				physicTransformOut.setRotation(nativeRotation);
				_setTransformFlag(Transform3D.TRANSFORM_WORLDQUATERNION, false);
			}
			
			if (force || _getTransformFlag(Transform3D.TRANSFORM_WORLDSCALE)) {
				_onScaleChange(transform.scale);
				_setTransformFlag(Transform3D.TRANSFORM_WORLDSCALE, false);
			}
		}
		
		/**
		 * @private
		 * 通过物理矩阵更新渲染矩阵。
		 */
		public function _updateTransformComponent(physicsTransform:*):void {
			var localOffset:Vector3 = _colliderShape.localOffset;
			var localRotation:Quaternion = _colliderShape.localRotation;
			
			var transform:Transform3D = (owner as Sprite3D)._transform;
			var position:Vector3 = transform.position;
			var rotation:Quaternion = transform.rotation;
			
			var nativePosition:* = physicsTransform.getOrigin();
			var nativeRotation:* = physicsTransform.getRotation();
			var nativeRotX:Number = -nativeRotation.x();
			var nativeRotY:Number = nativeRotation.y();
			var nativeRotZ:Number = nativeRotation.z();
			var nativeRotW:Number = -nativeRotation.w();
			
			if (localOffset.x !== 0 || localOffset.y !== 0 || localOffset.z !== 0) {
				var rotShapePosition:Vector3 = _tempVector30;
				physicVector3TransformQuat(localOffset, nativeRotX, nativeRotY, nativeRotZ, nativeRotW, rotShapePosition);
				position.x = -nativePosition.x() - rotShapePosition.x;
				position.y = nativePosition.y() - rotShapePosition.y;
				position.z = nativePosition.z() - rotShapePosition.z;
			} else {
				position.x = -nativePosition.x();
				position.y = nativePosition.y();
				position.z = nativePosition.z();
			}
			transform.position = position;
			
			if (localRotation.x !== 0 || localRotation.y !== 0 || localRotation.z !== 0 || localRotation.w !== 1) {
				var invertShapeRotaion:Quaternion = _tempQuaternion0;
				localRotation.invert(invertShapeRotaion);
				physicQuaternionMultiply(nativeRotX, nativeRotY, nativeRotZ, nativeRotW, invertShapeRotaion, rotation);
			} else {
				rotation.x = nativeRotX;
				rotation.y = nativeRotY;
				rotation.z = nativeRotZ;
				rotation.w = nativeRotW;
			}
			transform.rotation = rotation;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onEnable():void {
			_simulation = (owner._scene as Scene3D).physicsSimulation;
			_nativeColliderObject.setContactProcessingThreshold(1e30);
			if (_colliderShape && _enabled) {
				_derivePhysicsTransformation(true);
				_addToSimulation();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDisable():void {
			if (_colliderShape && _enabled){
				_removeFromSimulation();
				(_inPhysicUpdateListIndex !== -1) && (_simulation._physicsUpdateList.remove(this));//销毁前一定会调用 _onDisable()
			}
			_simulation = null;
		}
		
		/**
		 * @private
		 */
		public function _onShapeChange(colShape:ColliderShape):void {
			var btColObj:* = _nativeColliderObject;
			var flags:int = btColObj.getCollisionFlags();
			if (colShape.needsCustomCollisionCallback) {
				if ((flags & COLLISIONFLAGS_CUSTOM_MATERIAL_CALLBACK) === 0)
					btColObj.setCollisionFlags(flags | COLLISIONFLAGS_CUSTOM_MATERIAL_CALLBACK);
			} else {
				if ((flags & COLLISIONFLAGS_CUSTOM_MATERIAL_CALLBACK) > 0)
					btColObj.setCollisionFlags(flags ^ COLLISIONFLAGS_CUSTOM_MATERIAL_CALLBACK);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onAdded():void {
			enabled = _enabled;
			restitution = _restitution;
			friction = _friction;
			rollingFriction = _rollingFriction;
			ccdMotionThreshold = _ccdMotionThreshold;
			ccdSweptSphereRadius = _ccdSweptSphereRadius;
			(owner as Sprite3D).transform.on(Event.TRANSFORM_CHANGED, this, _onTransformChanged);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDestroy():void {
			var physics3D:* = Laya3D._physics3D;
			delete _physicObjectsMap[id];
			physics3D.destroy(_nativeColliderObject);
			_colliderShape.destroy();
			super._onDestroy();
			_nativeColliderObject = null;
			_colliderShape = null;
			_simulation = null;
			(owner as Sprite3D).transform.off(Event.TRANSFORM_CHANGED, this, _onTransformChanged);
		
		}
		
		/**
		 * @private
		 */
		public function _onTransformChanged(flag:int):void {
			if (_addUpdateList) {
				flag &= Transform3D.TRANSFORM_WORLDPOSITION | Transform3D.TRANSFORM_WORLDQUATERNION | Transform3D.TRANSFORM_WORLDSCALE;//过滤有用TRANSFORM标记
				if (flag) {
					_transformFlag |= flag;
					if (_isValid() && _inPhysicUpdateListIndex === -1)//_isValid()表示可使用
						_simulation._physicsUpdateList.add(this);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _cloneTo(dest:Component):void {
			var destPhysicsComponent:PhysicsComponent = dest as PhysicsComponent;
			destPhysicsComponent.restitution = _restitution;
			destPhysicsComponent.friction = _friction;
			destPhysicsComponent.rollingFriction = _rollingFriction;
			destPhysicsComponent.ccdMotionThreshold = _ccdMotionThreshold;
			destPhysicsComponent.ccdSweptSphereRadius = _ccdSweptSphereRadius;
			destPhysicsComponent.collisionGroup = _collisionGroup;
			destPhysicsComponent.canCollideWith = _canCollideWith;
			destPhysicsComponent.canScaleShape = canScaleShape;
			(_colliderShape) && (destPhysicsComponent.colliderShape = _colliderShape.clone());
		}
	}
}