package laya.d3.core {
	import laya.d3.animation.AnimationTransform3D;
	import laya.d3.math.MathUtils3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	
	/**
	 * <code>Transform3D</code> 类用于实现3D变换。
	 */
	public class Transform3D extends EventDispatcher {
		/** @private */
		private static var _tempVector30:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector31:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector32:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector33:Vector3 = new Vector3();
		/** @private */
		private static var _tempQuaternion0:Quaternion = new Quaternion();
		/** @private */
		private static var _tempMatrix0:Matrix4x4 = new Matrix4x4();
		
		/**@private */
		private static const _angleToRandin:Number = 180 / Math.PI;
		
		/** @private */
		private var _owner:Sprite3D;
		/** @private */
		private var _localPosition:Vector3 = new Vector3();
		/** @private */
		private var _localRotation:Quaternion = new Quaternion(0, 0, 0, 1);
		/** @private */
		private var _localScale:Vector3 = new Vector3(1, 1, 1);
		/**@private */
		private var _localRotationEuler:Vector3 = new Vector3();
		/** @private */
		private var _localMatrix:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private var _position:Vector3 = new Vector3();
		/** @private */
		private var _rotation:Quaternion = new Quaternion(0, 0, 0, 1);
		/** @private */
		private var _scale:Vector3 = new Vector3(1, 1, 1);
		/** @private */
		private var _worldMatrix:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private var _forward:Vector3 = new Vector3();
		/** @private */
		private var _up:Vector3 = new Vector3();
		/** @private */
		private var _right:Vector3 = new Vector3();
		
		/** @private */
		private var _localQuaternionUpdate:Boolean = false;
		/** @private */
		private var _locaEulerlUpdate:Boolean = false;
		/** @private */
		private var _localUpdate:Boolean = false;
		/** @private */
		private var _worldUpdate:Boolean = true;
		/** @private */
		private var _positionUpdate:Boolean = true;
		/** @private */
		private var _rotationUpdate:Boolean = true;
		/** @private */
		private var _scaleUpdate:Boolean = true;
		/** @private */
		private var _parent:Transform3D;
		/** @private */
		private var _childs:Vector.<Transform3D>;
		/**@private */
		private var _dummy:AnimationTransform3D;
		
		/** 变换中心点,注意:该中心点不受变换的影响。*/
		public var pivot:Vector3;
		
		/**
		 * @private
		 */
		public function get _isFrontFaceInvert():Boolean {
			var scale:Vector3 = this.scale;
			var isInvert:Boolean = scale.x < 0;
			(scale.y < 0) && (isInvert = !isInvert);
			(scale.z < 0) && (isInvert = !isInvert);
			return isInvert;
		}
		
		/**
		 * 获取所属精灵。
		 */
		public function get owner():Sprite3D {
			return _owner;
		}
		
		/**
		 * 获取世界矩阵是否需要更新。
		 * @return	世界矩阵是否需要更新。
		 */
		public function get worldNeedUpdate():Boolean {
			return _worldUpdate;
		}
		
		/**
		 * 获取局部矩阵。
		 * @return	局部矩阵。
		 */
		public function get localMatrix():Matrix4x4 {
			if (_localUpdate) {
				_updateLocalMatrix();
				_localUpdate = false;
			}
			
			return _localMatrix;
		}
		
		/**
		 * 设置局部矩阵。
		 * @param value	局部矩阵。
		 */
		public function set localMatrix(value:Matrix4x4):void {
			_localMatrix = value;
			_localMatrix.decomposeTransRotScale(_localPosition, _localRotation, _localScale);
			_localUpdate = false;
			_onWorldTransform();
		}
		
		/**
		 * 获取世界矩阵。
		 * @return	世界矩阵。
		 */
		public function get worldMatrix():Matrix4x4 {
			if (_worldUpdate) {
				if (_parent != null)
					Matrix4x4.multiply(_parent.worldMatrix, localMatrix, _worldMatrix);
				else
					localMatrix.cloneTo(_worldMatrix);
				
				_worldUpdate = false;
			}
			return _worldMatrix;
		}
		
		/**
		 * 设置世界矩阵。
		 * @param	value 世界矩阵。
		 */
		public function set worldMatrix(value:Matrix4x4):void {
			if (_parent === null) {
				value.cloneTo(_localMatrix);
			} else {
				_parent.worldMatrix.invert(_localMatrix);
				Matrix4x4.multiply(_localMatrix, value, _localMatrix);
			}
			localMatrix = _localMatrix;
			_worldMatrix = value;
			
			_worldUpdate = false;
		}
		
		/**
		 * 获取局部位置。
		 * @return	局部位置。
		 */
		public function get localPosition():Vector3 {
			return _localPosition;
		}
		
		/**
		 * 设置局部位置。
		 * @param value	局部位置。
		 */
		public function set localPosition(value:Vector3):void {
			_localPosition = value;
			_localUpdate = true;
			_onWorldPositionTransform();
		}
		
		/**
		 * 获取局部旋转。
		 * @return	局部旋转。
		 */
		public function get localRotation():Quaternion {
			if (_localQuaternionUpdate) {
				var eulerE:Float32Array = _localRotationEuler.elements;
				Quaternion.createFromYawPitchRoll(eulerE[1] / _angleToRandin, eulerE[0] / _angleToRandin, eulerE[2] / _angleToRandin, _localRotation);
			}
			return _localRotation;
		}
		
		/**
		 * 设置局部旋转。
		 * @param value	局部旋转。
		 */
		public function set localRotation(value:Quaternion):void {
			_localRotation = value;
			_localRotation.normalize(_localRotation);
			_locaEulerlUpdate = true;
			_localQuaternionUpdate = false;
			_localUpdate = true;
			if (pivot && (pivot.x !== 0 || pivot.y !== 0 || pivot.z !== 0))
				_onWorldPositionRotationTransform();
			else
				_onWorldRotationTransform();
		}
		
		/**
		 * 获取局部缩放。
		 * @return	局部缩放。
		 */
		public function get localScale():Vector3 {
			return _localScale;
		}
		
		/**
		 * 设置局部缩放。
		 * @param	value 局部缩放。
		 */
		public function set localScale(value:Vector3):void {
			_localScale = value;
			_localUpdate = true;
			if (pivot && (pivot.x !== 0 || pivot.y !== 0 || pivot.z !== 0))
				_onWorldPositionScaleTransform();
			else
				_onWorldScaleTransform();
		}
		
		/**
		 * 设置局部空间的旋转角度。
		 * @param	value 欧拉角的旋转值，顺序为x、y、z。
		 */
		public function set localRotationEuler(value:Vector3):void {
			_localRotationEuler = value;
			_locaEulerlUpdate = false;
			_localQuaternionUpdate = true;
			_localUpdate = true;
			if (pivot && (pivot.x !== 0 || pivot.y !== 0 || pivot.z !== 0))
				_onWorldPositionRotationTransform();
			else
				_onWorldRotationTransform();
		}
		
		/**
		 * 获取局部空间的旋转角度。
		 * @return	欧拉角的旋转值，顺序为x、y、z。
		 */
		public function get localRotationEuler():Vector3 {
			if (_locaEulerlUpdate) {
				_localRotation.getYawPitchRoll(_tempVector30);
				var eulerE:Float32Array = _tempVector30.elements;
				var localRotationEulerE:Float32Array = _localRotationEuler.elements;
				localRotationEulerE[0] = eulerE[1] * _angleToRandin;
				localRotationEulerE[1] = eulerE[0] * _angleToRandin;
				localRotationEulerE[2] = eulerE[2] * _angleToRandin;
			}
			return _localRotationEuler;
		}
		
		/**
		 * 获取世界位置。
		 * @return	世界位置。
		 */
		public function get position():Vector3 {
			if (_positionUpdate) {
				if (_parent != null) {
					var parentPosition:Vector3 = _parent.position;//放到下面会影响_tempVector30计算，造成混乱
					Vector3.multiply(_localPosition, _parent.scale, _tempVector30);
					Vector3.transformQuat(_tempVector30, _parent.rotation, _tempVector30);
					Vector3.add(parentPosition, _tempVector30, _position);
				} else {
					_localPosition.cloneTo(_position);
				}
				
				_positionUpdate = false;
			}
			return _position;
		}
		
		/**
		 * 设置世界位置。
		 * @param	value 世界位置。
		 */
		public function set position(value:Vector3):void {
			if (_parent != null) {
				Vector3.subtract(value, _parent.position, _localPosition);
				var parentScaleE:Float32Array = _parent.scale.elements;
				var psX:Number = parentScaleE[0], psY:Number = parentScaleE[1], psZ:Number = parentScaleE[2];
				if (psX !== 1.0 || psY !== 1.0 || psZ !== 1.0) {
					var invertScale:Vector3 = _tempVector30;
					var invertScaleE:Float32Array = invertScale.elements;
					invertScaleE[0] = 1.0 / psX;
					invertScaleE[1] = 1.0 / psY;
					invertScaleE[2] = 1.0 / psZ;
					Vector3.multiply(_localPosition, invertScale, _localPosition);
				}
				var parentRotation:Quaternion = _parent.rotation;
				parentRotation.invert(_tempQuaternion0);
				Vector3.transformQuat(_localPosition, _tempQuaternion0, _localPosition);
			} else {
				value.cloneTo(_localPosition);
			}
			localPosition = _localPosition;
			_position = value;
			_positionUpdate = false;
		}
		
		/**
		 * 获取世界旋转。
		 * @return	世界旋转。
		 */
		public function get rotation():Quaternion {
			if (_rotationUpdate) {
				if (_parent != null)
					Quaternion.multiply(_parent.rotation, localRotation, _rotation);//使用localRotation不使用_localRotation,内部需要计算
				else
					localRotation.cloneTo(_rotation);//使用localRotation不使用_localRotation,内部需要计算
				
				_rotationUpdate = false;
			}
			return _rotation;
		}
		
		/**
		 * 设置世界旋转。
		 * @param value	世界旋转。
		 */
		public function set rotation(value:Quaternion):void {
			if (_parent != null) {
				_parent.rotation.invert(_tempQuaternion0);
				Quaternion.multiply(value, _tempQuaternion0, _localRotation);
			} else {
				value.cloneTo(_localRotation);
			}
			localRotation = _localRotation;
			_rotation = value;
			_rotationUpdate = false;
		}
		
		/**
		 * 获取世界缩放。
		 * @return	世界缩放。
		 */
		public function get scale():Vector3 {
			if (!_scaleUpdate)
				return _scale;
			if (_parent !== null)
				Vector3.multiply(_parent.scale, _localScale, _scale);
			else
				_localScale.cloneTo(_scale);
			
			_scaleUpdate = false;
			return _scale;
		}
		
		/**
		 * 设置世界缩放。
		 * @param value	世界缩放。
		 */
		public function set scale(value:Vector3):void {
			if (_parent !== null) {
				var pScaleE:Float32Array = _parent.scale.elements;
				var invPScaleE:Float32Array = _tempVector30.elements;
				invPScaleE[0] = 1.0 / pScaleE[0];
				invPScaleE[1] = 1.0 / pScaleE[1];
				invPScaleE[2] = 1.0 / pScaleE[2];
				Vector3.multiply(value, _tempVector30, _localScale);
			} else {
				value.cloneTo(_localScale);
			}
			localScale = _localScale;
			_scale = value;
			_scaleUpdate = false;
		}
		
		/**
		 * 设置局部空间的旋转角度。
		 * @param	欧拉角的旋转值，顺序为x、y、z。
		 */
		public function set rotationEuler(value:Vector3):void {
			Quaternion.createFromYawPitchRoll(value.y, value.x, value.z, _rotation);
			rotation = _rotation;
		}
		
		/**
		 * 获取向前方向。
		 * @return	向前方向。
		 */
		public function get forward():Vector3 {
			var worldMatElem:Float32Array = worldMatrix.elements;
			_forward.elements[0] = -worldMatElem[8];
			_forward.elements[1] = -worldMatElem[9];
			_forward.elements[2] = -worldMatElem[10];
			return _forward;
		}
		
		/**
		 * 获取向上方向。
		 * @return	向上方向。
		 */
		public function get up():Vector3 {
			var worldMatElem:Float32Array = worldMatrix.elements;
			_up.elements[0] = worldMatElem[4];
			_up.elements[1] = worldMatElem[5];
			_up.elements[2] = worldMatElem[6];
			return _up;
		}
		
		/**
		 * 获取向右方向。
		 * @return	向右方向。
		 */
		public function get right():Vector3 {
			var worldMatElem:Float32Array = worldMatrix.elements;
			_right.elements[0] = worldMatElem[0];
			_right.elements[1] = worldMatElem[1];
			_right.elements[2] = worldMatElem[2];
			return _right;
		}
		
		/**
		 * 获取父3D变换。
		 * @return 父3D变换。
		 */
		public function get parent():Transform3D {
			return _parent;
		}
		
		/**
		 * 设置父3D变换。
		 * @param	value 父3D变换。
		 */
		public function set parent(value:Transform3D):void {
			if (_parent !== value) {
				if (_parent) {
					var parentChilds:Vector.<Transform3D> = _parent._childs;
					var index:int = parentChilds.indexOf(this);
					parentChilds.splice(index, 1);
				}
				if (value) {
					value._childs.push(this);
					(value) && (_onWorldTransform());
				}
				_parent = value;
			}
		}
		
		/**
		 *设置关联虚拟变换。
		 * @param value 虚拟变换。
		 */
		public function set dummy(value:AnimationTransform3D):void {
			if (_dummy !== value) {
				(_dummy) && (_dummy._entity = null);
				(value) && (value._entity = this);
				_dummy = value;
			}
		}
		
		/**
		 *获取关联虚拟变换。
		 * @return 虚拟变换。
		 */
		public function get dummy():AnimationTransform3D {
			return _dummy;
		}
		
		/**
		 * 创建一个 <code>Transform3D</code> 实例。
		 * @param owner 所属精灵。
		 */
		public function Transform3D(owner:Sprite3D) {
			_owner = owner;
			_childs = new Vector.<Transform3D>();
		}
		
		/**
		 * @private
		 */
		private function _updateLocalMatrix():void {
			if (pivot && (pivot.x !== 0 || pivot.y !== 0 || pivot.z !== 0)) {
				var scalePivot:Vector3 = _tempVector30;
				Vector3.multiply(pivot, _localScale, scalePivot);
				var scaleOffsetPosition:Vector3 = _tempVector31;
				Vector3.subtract(scalePivot, pivot, scaleOffsetPosition);
				var rotationOffsetPosition:Vector3 = _tempVector32;
				var localRot:Quaternion = localRotation;
				Vector3.transformQuat(scalePivot, localRot, rotationOffsetPosition);
				Vector3.subtract(rotationOffsetPosition, scalePivot, rotationOffsetPosition);
				
				var resultLocalPosition:Vector3 = _tempVector33;
				Vector3.subtract(_localPosition, scaleOffsetPosition, resultLocalPosition);
				Vector3.subtract(resultLocalPosition, rotationOffsetPosition, resultLocalPosition);
				Matrix4x4.createAffineTransformation(resultLocalPosition, localRot, _localScale, _localMatrix);
			} else {
				Matrix4x4.createAffineTransformation(_localPosition, localRotation, _localScale, _localMatrix);
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldPositionRotationTransform():void {
			if (!_worldUpdate || !_positionUpdate || !_rotationUpdate) {
				_worldUpdate = _positionUpdate = _rotationUpdate = true;
				event(Event.WORLDMATRIX_NEEDCHANGE);
				for (var i:int = 0, n:int = _childs.length; i < n; i++)
					_childs[i]._onWorldPositionRotationTransform();
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldPositionScaleTransform():void {
			if (!_worldUpdate || !_positionUpdate || !_scaleUpdate) {
				_worldUpdate = _positionUpdate = _scaleUpdate = true;
				event(Event.WORLDMATRIX_NEEDCHANGE);
				for (var i:int = 0, n:int = _childs.length; i < n; i++)
					_childs[i]._onWorldPositionScaleTransform();
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldPositionTransform():void {
			if (!_worldUpdate || !_positionUpdate) {
				_worldUpdate = _positionUpdate = true;
				event(Event.WORLDMATRIX_NEEDCHANGE);
				for (var i:int = 0, n:int = _childs.length; i < n; i++)
					_childs[i]._onWorldPositionTransform();
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldRotationTransform():void {
			if (!_worldUpdate || !_rotationUpdate) {
				_worldUpdate = _rotationUpdate = true;
				event(Event.WORLDMATRIX_NEEDCHANGE);
				for (var i:int = 0, n:int = _childs.length; i < n; i++)
					_childs[i]._onWorldPositionRotationTransform();//父节点旋转发生变化，子节点的世界位置和旋转都需要更新
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldScaleTransform():void {
			if (!_worldUpdate || !_scaleUpdate) {
				_worldUpdate = _scaleUpdate = true;
				event(Event.WORLDMATRIX_NEEDCHANGE);
				for (var i:int = 0, n:int = _childs.length; i < n; i++)
					_childs[i]._onWorldPositionScaleTransform();//父节点缩放发生变化，子节点的世界位置和缩放都需要更新
			}
		}
		
		/**
		 * @private
		 */
		public function _onWorldTransform():void {
			if (!_worldUpdate || !_positionUpdate || !_rotationUpdate || !_scaleUpdate) {
				_worldUpdate = _positionUpdate = _rotationUpdate = _scaleUpdate = true;
				event(Event.WORLDMATRIX_NEEDCHANGE);
				for (var i:int = 0, n:int = _childs.length; i < n; i++)
					_childs[i]._onWorldTransform();
			}
		}
		
		/**
		 * 平移变换。
		 * @param 	translation 移动距离。
		 * @param 	isLocal 是否局部空间。
		 */
		public function translate(translation:Vector3, isLocal:Boolean = true):void {
			if (isLocal) {
				Matrix4x4.createFromQuaternion(localRotation, _tempMatrix0);
				Vector3.transformCoordinate(translation, _tempMatrix0, _tempVector30);
				Vector3.add(localPosition, _tempVector30, _localPosition);
				localPosition = _localPosition;
			} else {
				Vector3.add(position, translation, _position);
				position = _position;
			}
		}
		
		/**
		 * 旋转变换。
		 * @param 	rotations 旋转幅度。
		 * @param 	isLocal 是否局部空间。
		 * @param 	isRadian 是否弧度制。
		 */
		public function rotate(rotation:Vector3, isLocal:Boolean = true, isRadian:Boolean = true):void {
			var rot:Vector3;
			if (isRadian) {
				rot = rotation;
			} else {
				Vector3.scale(rotation, Math.PI / 180.0, _tempVector30);
				rot = _tempVector30;
			}
			
			Quaternion.createFromYawPitchRoll(rot.y, rot.x, rot.z, _tempQuaternion0);
			if (isLocal) {
				Quaternion.multiply(_localRotation, _tempQuaternion0, _localRotation);
				localRotation = _localRotation;
			} else {
				Quaternion.multiply(_tempQuaternion0, this.rotation, _rotation);
				this.rotation = _rotation;
			}
		}
		
		/**
		 * 观察目标位置。
		 * @param	target 观察目标。
		 * @param	up 向上向量。
		 * @param	isLocal 是否局部空间。
		 */
		public function lookAt(target:Vector3, up:Vector3, isLocal:Boolean = false):void {
			var targetE:Float32Array = target.elements;
			var eyeE:Float32Array;
			if (isLocal) {
				eyeE = _localPosition.elements;
				if (Math.abs(eyeE[0] - targetE[0]) < MathUtils3D.zeroTolerance && Math.abs(eyeE[1] - targetE[1]) < MathUtils3D.zeroTolerance && Math.abs(eyeE[2] - targetE[2]) < MathUtils3D.zeroTolerance)
					return;
				
				Quaternion.lookAt(_localPosition, target, up, _localRotation);
				_localRotation.invert(_localRotation);
				localRotation = _localRotation;
			} else {
				var worldPosition:Vector3 = position;
				eyeE = worldPosition.elements;
				if (Math.abs(eyeE[0] - targetE[0]) < MathUtils3D.zeroTolerance && Math.abs(eyeE[1] - targetE[1]) < MathUtils3D.zeroTolerance && Math.abs(eyeE[2] - targetE[2]) < MathUtils3D.zeroTolerance)
					return;
				
				Quaternion.lookAt(worldPosition, target, up, _rotation);
				_rotation.invert(_rotation);
				rotation = _rotation;
			}
		}
	
	}

}