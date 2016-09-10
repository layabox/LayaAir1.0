package laya.d3.core {
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Stat;
	
	/**
	 * <code>Transform3D</code> 类用于实现3D变换。
	 */
	public class Transform3D extends EventDispatcher {
		/** @private */
		protected var _tempMatrix0:Matrix4x4 = new Matrix4x4();
		/** @private */
		protected var _tempQuaternion0:Quaternion = new Quaternion();
		/** @private */
		protected var _tempVector30:Vector3 = new Vector3();
		
		/** @private */
		protected var _localPosition:Vector3 = new Vector3();
		/** @private */
		protected var _localRotation:Quaternion = new Quaternion(0, 0, 0, 1);
		/** @private */
		protected var _localScale:Vector3 = new Vector3(1, 1, 1);
		/** @private */
		protected var _localMatrix:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		protected var _position:Vector3 = new Vector3();
		/** @private */
		protected var _rotation:Quaternion = new Quaternion(0, 0, 0, 1);
		/** @private */
		protected var _scale:Vector3 = new Vector3(1, 1, 1);
		/** @private */
		protected var _worldMatrix:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		protected var _owner:Sprite3D;
		
		/** @private */
		protected var _forward:Vector3 = new Vector3();
		/** @private */
		protected var _up:Vector3 = new Vector3();
		/** @private */
		protected var _right:Vector3 = new Vector3();
		
		/** @private */
		protected var _preWorldTransformModifyID:Number = -1;
		
		/** @private */
		protected var _localUpdate:Boolean = false;
		/** @private */
		protected var _worldUpdate:Boolean = true;
		/** @private */
		protected var _parent:Transform3D;
		
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
			_localMatrix.decompose(_localPosition, _localRotation, _localScale);
			_onWorldTransform();
		}
		
		/**
		 * 获取世界矩阵。
		 * @return	世界矩阵。
		 */
		public function get worldMatrix():Matrix4x4 {
			if (!_worldUpdate)
				return _worldMatrix;
			
			if (_parent != null)
				Matrix4x4.multiply(_parent.worldMatrix, localMatrix, _worldMatrix);
			else
				localMatrix.cloneTo(_worldMatrix);
			
			_worldUpdate = false;
			return _worldMatrix;
		}
		
		/**
		 * 设置世界矩阵。
		 * @param	value 世界矩阵。
		 */
		public function set worldMatrix(value:Matrix4x4):void {
			if (_parent === null)
				localMatrix = value;
			else {
				_parent.worldMatrix.invert(_localMatrix);
				Matrix4x4.multiply(_localMatrix, value, _localMatrix);
				localMatrix = _localMatrix;
			}
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
			_onLocalTransform();
			_onWorldTransform();
		}
		
		/**
		 * 获取局部旋转。
		 * @return	局部旋转。
		 */
		public function get localRotation():Quaternion {
			return _localRotation;
		}
		
		/**
		 * 设置局部旋转。
		 * @param value	局部旋转。
		 */
		public function set localRotation(value:Quaternion):void {
			_localRotation = value;
			_localRotation.normalize(_localRotation);
			_onLocalTransform();
			_onWorldTransform();
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
			_onLocalTransform();
			_onWorldTransform();
		}
		
		/**
		 * 设置局部空间的旋转角度。
		 * @param	value 欧拉角的旋转值，顺序为x、y、z。
		 */
		public function set localRotationEuler(value:Vector3):void {
			Quaternion.createFromYawPitchRoll(value.y, value.x, value.z, _localRotation);
			_onLocalTransform();
			_onWorldTransform();
		}
		
		/**
		 * 获取世界位置。
		 * @return	世界位置。
		 */
		public function get position():Vector3 {
			if (_parent !== null) {
				var worldMatElem:Float32Array = worldMatrix.elements;
				_position.elements[0] = worldMatElem[12];
				_position.elements[1] = worldMatElem[13];
				_position.elements[2] = worldMatElem[14];
			} else {
				_localPosition.cloneTo(_position);
			}
			return _position;
		}
		
		/**
		 * 设置世界位置。
		 * @param	value 世界位置。
		 */
		public function set position(value:Vector3):void {
			if (_parent !== null) {
				_parent.worldMatrix.invert(_tempMatrix0);
				Vector3.transformCoordinate(value, _tempMatrix0, _localPosition);
				localPosition = _localPosition;
			} else {
				value.cloneTo(_localPosition);
				localPosition = _localPosition;
			}
		}
		
		/**
		 * 获取世界旋转。
		 * @return	世界旋转。
		 */
		public function get rotation():Quaternion {
			if (_parent !== null) {
				worldMatrix.decompose(_position, _rotation, _scale);//可不计算_position和_scale
			} else {
				_localRotation.cloneTo(_rotation);
			}
			return _rotation;
		}
		
		/**
		 * 设置世界旋转。
		 * @param value	世界旋转。
		 */
		public function set rotation(value:Quaternion):void {
			if (_parent !== null) {
				_parent.rotation.invert(_tempQuaternion0);
				Quaternion.multiply(value, _tempQuaternion0, _localRotation);
				localRotation = _localRotation;
			} else {
				value.cloneTo(_localRotation);
				localRotation = _localRotation;
			}
		}
		
		/**
		 * 获取世界缩放。
		 * @return	世界缩放。
		 */
		public function get scale():Vector3 {
			if (_parent !== null) {
				Vector3.multiply(_parent.scale, _localScale, _scale);
			} else {
				_localScale.cloneTo(_scale);
			}
			return _scale;
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
		 * 设置父3D变换。
		 * @param	value 父3D变换。
		 */
		public function set parent(value:Transform3D):void {
			_parent = value;
			_onWorldTransform();
		}
		
		/**
		 * 创建一个 <code>Transform3D</code> 实例。
		 * @param owner 所属精灵。
		 */
		public function Transform3D(owner:Sprite3D) {
			_owner = owner;
		}
		
		/**
		 * @private
		 */
		protected function _updateLocalMatrix():void {
			Matrix4x4.createAffineTransformation(_localPosition, _localRotation, _localScale, _localMatrix);
		}
		
		/**
		 * @private
		 */
		protected function _onLocalTransform():void {
			_localUpdate = true;
		}
		
		/**
		 * @private
		 */
		protected function _onWorldTransform():void {
			if (!_worldUpdate) {
				_worldUpdate = true;
				event(Event.WORLDMATRIX_NEEDCHANGE);
				for (var i:int = 0, n:int = _owner._childs.length; i < n; i++)
					(_owner._childs[i] as Sprite3D).transform._onWorldTransform();
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
			if (!isRadian) {
				Vector3.scale(rotation, Math.PI / 180, _tempVector30);
				rot = _tempVector30;
			} else {
				rot = rotation;
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
	}

}