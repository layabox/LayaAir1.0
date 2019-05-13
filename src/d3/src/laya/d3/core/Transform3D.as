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
		public static const TRANSFORM_LOCALQUATERNION:int = 0x01;
		/**@private */
		public static const TRANSFORM_LOCALEULER:int = 0x02;
		/**@private */
		public static const TRANSFORM_LOCALMATRIX:int = 0x04;
		/**@private */
		public static const TRANSFORM_WORLDPOSITION:int = 0x08;
		/**@private */
		public static const TRANSFORM_WORLDQUATERNION:int = 0x10;
		/**@private */
		public static const TRANSFORM_WORLDSCALE:int = 0x20;
		/**@private */
		public static const TRANSFORM_WORLDMATRIX:int = 0x40;
		/**@private */
		public static const TRANSFORM_WORLDEULER:int = 0x80;
		
		/**@private */
		private static const _angleToRandin:Number = 180 / Math.PI;
		
		/** @private */
		private var _owner:Sprite3D;
		/** @private */
		private var _localPosition:Vector3 = new Vector3(0, 0, 0);
		/** @private */
		private var _localRotation:Quaternion = new Quaternion(0, 0, 0, 1);
		/** @private */
		private var _localScale:Vector3 = new Vector3(1, 1, 1);
		/**@private */
		private var _localRotationEuler:Vector3 = new Vector3(0, 0, 0);
		/** @private */
		private var _localMatrix:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private var _position:Vector3 = new Vector3(0, 0, 0);
		/** @private */
		private var _rotation:Quaternion = new Quaternion(0, 0, 0, 1);
		/** @private */
		private var _scale:Vector3 = new Vector3(1, 1, 1);
		/**@private */
		private var _rotationEuler:Vector3 = new Vector3(0, 0, 0);
		/** @private */
		private var _worldMatrix:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private var _children:Vector.<Transform3D>;
		
		/** @private */
		public var _parent:Transform3D;
		/**@private */
		public var _dummy:AnimationTransform3D;
		/**@private */
		public var _transformFlag:int = 0;
		
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
			return _getTransformFlag(TRANSFORM_WORLDMATRIX);
		}
		
		/**
		 * 获取局部位置X轴分量。
		 * @return	局部位置X轴分量。
		 */
		public function get localPositionX():Number {
			return _localPosition.x;
		}
		
		/**
		 * 设置局部位置X轴分量。
		 * @param x	局部位置X轴分量。
		 */
		public function set localPositionX(x:Number):void {
			_localPosition.x = x;
			localPosition = _localPosition;
		}
		
		/**
		 * 获取局部位置Y轴分量。
		 * @return	局部位置Y轴分量。
		 */
		public function get localPositionY():Number {
			return _localPosition.y;
		}
		
		/**
		 * 设置局部位置Y轴分量。
		 * @param y	局部位置Y轴分量。
		 */
		public function set localPositionY(y:Number):void {
			_localPosition.y = y;
			localPosition = _localPosition;
		}
		
		/**
		 * 获取局部位置Z轴分量。
		 * @return	局部位置Z轴分量。
		 */
		public function get localPositionZ():Number {
			return _localPosition.z;
		}
		
		/**
		 * 设置局部位置Z轴分量。
		 * @param z	局部位置Z轴分量。
		 */
		public function set localPositionZ(z:Number):void {
			_localPosition.z = z;
			localPosition = _localPosition;
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
			if (_localPosition !== value)
				value.cloneTo(_localPosition);
			
			_setTransformFlag(TRANSFORM_LOCALMATRIX, true);
			_onWorldPositionTransform();
		}
		
		/**
		 * 获取局部旋转四元数X分量。
		 * @return	局部旋转四元数X分量。
		 */
		public function get localRotationX():Number {
			return localRotation.x;
		}
		
		/**
		 * 设置局部旋转四元数X分量。
		 * @param x	局部旋转四元数X分量。
		 */
		public function set localRotationX(x:Number):void {
			_localRotation.x = x;
			localRotation = _localRotation;
		}
		
		/**
		 * 获取局部旋转四元数Y分量。
		 * @return	局部旋转四元数Y分量。
		 */
		public function get localRotationY():Number {
			return localRotation.y;
		}
		
		/**
		 * 设置局部旋转四元数Y分量。
		 * @param y	局部旋转四元数Y分量。
		 */
		public function set localRotationY(y:Number):void {
			_localRotation.y = y;
			localRotation = _localRotation;
		}
		
		/**
		 * 获取局部旋转四元数Z分量。
		 * @return	局部旋转四元数Z分量。
		 */
		public function get localRotationZ():Number {
			return localRotation.z;
		}
		
		/**
		 * 设置局部旋转四元数Z分量。
		 * @param z	局部旋转四元数Z分量。
		 */
		public function set localRotationZ(z:Number):void {
			_localRotation.z = z;
			localRotation = _localRotation;
		}
		
		/**
		 * 获取局部旋转四元数W分量。
		 * @return	局部旋转四元数W分量。
		 */
		public function get localRotationW():Number {
			return localRotation.w;
		}
		
		/**
		 * 设置局部旋转四元数W分量。
		 * @param w	局部旋转四元数W分量。
		 */
		public function set localRotationW(w:Number):void {
			_localRotation.w = w;
			localRotation = _localRotation;
		}
		
		/**
		 * 获取局部旋转。
		 * @return	局部旋转。
		 */
		public function get localRotation():Quaternion {
			if (_getTransformFlag(TRANSFORM_LOCALQUATERNION)) {
				var eulerE:Vector3 = _localRotationEuler;
				Quaternion.createFromYawPitchRoll(eulerE.y / _angleToRandin, eulerE.x / _angleToRandin, eulerE.z / _angleToRandin, _localRotation);
				_setTransformFlag(TRANSFORM_LOCALQUATERNION, false);
			}
			return _localRotation;
		}
		
		/**
		 * 设置局部旋转。
		 * @param value	局部旋转。
		 */
		public function set localRotation(value:Quaternion):void {
			if (_localRotation !== value)
				value.cloneTo(_localRotation);
			_localRotation.normalize(_localRotation);
			_setTransformFlag(TRANSFORM_LOCALEULER | TRANSFORM_LOCALMATRIX, true);
			_setTransformFlag(TRANSFORM_LOCALQUATERNION, false);
			_onWorldRotationTransform();
		}
		
		/**
		 * 获取局部缩放X。
		 * @return	局部缩放X。
		 */
		public function get localScaleX():Number {
			return _localScale.x;
		}
		
		/**
		 * 设置局部缩放X。
		 * @param	value 局部缩放X。
		 */
		public function set localScaleX(value:Number):void {
			_localScale.x = value;
			localScale = _localScale;
		}
		
		/**
		 * 获取局部缩放Y。
		 * @return	局部缩放Y。
		 */
		public function get localScaleY():Number {
			return _localScale.y;
		}
		
		/**
		 * 设置局部缩放Y。
		 * @param	value 局部缩放Y。
		 */
		public function set localScaleY(value:Number):void {
			_localScale.y = value;
			localScale = _localScale;
		}
		
		/**
		 * 获取局部缩放Z。
		 * @return	局部缩放Z。
		 */
		public function get localScaleZ():Number {
			return _localScale.z;
		}
		
		/**
		 * 设置局部缩放Z。
		 * @param	value 局部缩放Z。
		 */
		public function set localScaleZ(value:Number):void {
			_localScale.z = value;
			localScale = _localScale;
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
			if (_localScale !== value)
				value.cloneTo(_localScale);
			_setTransformFlag(TRANSFORM_LOCALMATRIX, true);
			_onWorldScaleTransform();
		}
		
		/**
		 * 获取局部空间的X轴欧拉角。
		 * @return	局部空间的X轴欧拉角。
		 */
		public function get localRotationEulerX():Number {
			return localRotationEuler.x;
		}
		
		/**
		 * 设置局部空间的X轴欧拉角。
		 * @param	value 局部空间的X轴欧拉角。
		 */
		public function set localRotationEulerX(value:Number):void {
			_localRotationEuler.x = value;
			localRotationEuler = _localRotationEuler;
		}
		
		/**
		 * 获取局部空间的Y轴欧拉角。
		 * @return	局部空间的Y轴欧拉角。
		 */
		public function get localRotationEulerY():Number {
			return localRotationEuler.y;
		}
		
		/**
		 * 设置局部空间的Y轴欧拉角。
		 * @param	value 局部空间的Y轴欧拉角。
		 */
		public function set localRotationEulerY(value:Number):void {
			_localRotationEuler.y = value;
			localRotationEuler = _localRotationEuler;
		}
		
		/**
		 * 获取局部空间的Z轴欧拉角。
		 * @return	局部空间的Z轴欧拉角。
		 */
		public function get localRotationEulerZ():Number {
			return localRotationEuler.z;
		}
		
		/**
		 * 设置局部空间的Z轴欧拉角。
		 * @param	value 局部空间的Z轴欧拉角。
		 */
		public function set localRotationEulerZ(value:Number):void {
			_localRotationEuler.z = value;
			localRotationEuler = _localRotationEuler;
		}
		
		/**
		 * 获取局部空间欧拉角。
		 * @return	欧拉角的旋转值。
		 */
		public function get localRotationEuler():Vector3 {
			if (_getTransformFlag(TRANSFORM_LOCALEULER)) {
				_localRotation.getYawPitchRoll(_tempVector30);
				var euler:Vector3 = _tempVector30;
				var localRotationEuler:Vector3 = _localRotationEuler;
				localRotationEuler.x = euler.y * _angleToRandin;
				localRotationEuler.y = euler.x * _angleToRandin;
				localRotationEuler.z = euler.z * _angleToRandin;
				_setTransformFlag(TRANSFORM_LOCALEULER, false);
			}
			return _localRotationEuler;
		}
		
		/**
		 * 设置局部空间的欧拉角。
		 * @param	value 欧拉角的旋转值。
		 */
		public function set localRotationEuler(value:Vector3):void {
			if (_localRotationEuler !== value)
				value.cloneTo(_localRotationEuler);
			_setTransformFlag(TRANSFORM_LOCALEULER, false);
			_setTransformFlag(TRANSFORM_LOCALQUATERNION | TRANSFORM_LOCALMATRIX, true);
			_onWorldRotationTransform();
		}
		
		/**
		 * 获取局部矩阵。
		 * @return	局部矩阵。
		 */
		public function get localMatrix():Matrix4x4 {
			if (_getTransformFlag(TRANSFORM_LOCALMATRIX)) {
				_updateLocalMatrix();
				_setTransformFlag(TRANSFORM_LOCALMATRIX, false);
			}
			
			return _localMatrix;
		}
		
		/**
		 * 设置局部矩阵。
		 * @param value	局部矩阵。
		 */
		public function set localMatrix(value:Matrix4x4):void {
			if (_localMatrix !== value)
				value.cloneTo(_localMatrix);
			_localMatrix.decomposeTransRotScale(_localPosition, _localRotation, _localScale);
			_setTransformFlag(TRANSFORM_LOCALMATRIX, false);
			_onWorldTransform();
		}
		
		/**
		 * 获取世界位置。
		 * @return	世界位置。
		 */
		public function get position():Vector3 {
			if (_getTransformFlag(TRANSFORM_WORLDPOSITION)) {
				if (_parent != null) {
					var parentPosition:Vector3 = _parent.position;//放到下面会影响_tempVector30计算，造成混乱
					Vector3.multiply(_localPosition, _parent.scale, _tempVector30);
					Vector3.transformQuat(_tempVector30, _parent.rotation, _tempVector30);
					Vector3.add(parentPosition, _tempVector30, _position);
				} else {
					_localPosition.cloneTo(_position);
				}
				_setTransformFlag(TRANSFORM_WORLDPOSITION, false);
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
				var parentScale:Vector3 = _parent.scale;
				var psX:Number = parentScale.x, psY:Number = parentScale.y, psZ:Number = parentScale.z;
				if (psX !== 1.0 || psY !== 1.0 || psZ !== 1.0) {
					var invertScale:Vector3 = _tempVector30;
					invertScale.x = 1.0 / psX;
					invertScale.y = 1.0 / psY;
					invertScale.z = 1.0 / psZ;
					Vector3.multiply(_localPosition, invertScale, _localPosition);
				}
				var parentRotation:Quaternion = _parent.rotation;
				parentRotation.invert(_tempQuaternion0);
				Vector3.transformQuat(_localPosition, _tempQuaternion0, _localPosition);
			} else {
				value.cloneTo(_localPosition);
			}
			localPosition = _localPosition;
			if (_position !== value)
				value.cloneTo(_position);
			_setTransformFlag(TRANSFORM_WORLDPOSITION, false);
		}
		
		/**
		 * 获取世界旋转。
		 * @return	世界旋转。
		 */
		public function get rotation():Quaternion {
			if (_getTransformFlag(TRANSFORM_WORLDQUATERNION)) {
				if (_parent != null)
					Quaternion.multiply(_parent.rotation, localRotation, _rotation);//使用localRotation不使用_localRotation,内部需要计算
				else
					localRotation.cloneTo(_rotation);
				_setTransformFlag(TRANSFORM_WORLDQUATERNION, false);
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
				Quaternion.multiply(_tempQuaternion0, value, _localRotation);
			} else {
				value.cloneTo(_localRotation);
			}
			localRotation = _localRotation;
			if (value !== _rotation)
				value.cloneTo(_rotation);
			
			_setTransformFlag(TRANSFORM_WORLDQUATERNION, false);
		}
		
		/**
		 * 获取世界缩放。
		 * @return	世界缩放。
		 */
		public function get scale():Vector3 {
			if (!_getTransformFlag(TRANSFORM_WORLDSCALE))
				return _scale;
			if (_parent !== null)
				Vector3.multiply(_parent.scale, _localScale, _scale);
			else
				_localScale.cloneTo(_scale);
			
			_setTransformFlag(TRANSFORM_WORLDSCALE, false);
			return _scale;
		}
		
		/**
		 * 设置世界缩放。
		 * @param value	世界缩放。
		 */
		public function set scale(value:Vector3):void {
			if (_parent !== null) {
				var parScale:Vector3 = _parent.scale;
				var invParScale:Vector3 = _tempVector30;
				invParScale.x = 1.0 / parScale.x;
				invParScale.y = 1.0 / parScale.y;
				invParScale.z = 1.0 / parScale.z;
				Vector3.multiply(value, _tempVector30, _localScale);
			} else {
				value.cloneTo(_localScale);
			}
			localScale = _localScale;
			if (_scale !== value)
				value.cloneTo(_scale);
			_setTransformFlag(TRANSFORM_WORLDSCALE, false);
		}
		
		/**
		 * 获取世界空间的旋转角度。
		 * @return	欧拉角的旋转值，顺序为x、y、z。
		 */
		public function get rotationEuler():Vector3 {
			if (_getTransformFlag(TRANSFORM_WORLDEULER)) {
				rotation.getYawPitchRoll(_tempVector30);//使用rotation属性,可能需要更新
				var eulerE:Vector3 = _tempVector30;
				var rotationEulerE:Vector3 = _rotationEuler;
				rotationEulerE.x = eulerE.y * _angleToRandin;
				rotationEulerE.y = eulerE.x * _angleToRandin;
				rotationEulerE.z = eulerE.z * _angleToRandin;
				_setTransformFlag(TRANSFORM_WORLDEULER, false);
			}
			return _rotationEuler;
		}
		
		/**
		 * 设置世界空间的旋转角度。
		 * @param	欧拉角的旋转值，顺序为x、y、z。
		 */
		public function set rotationEuler(value:Vector3):void {
			Quaternion.createFromYawPitchRoll(value.y / _angleToRandin, value.x / _angleToRandin, value.z / _angleToRandin, _rotation);
			rotation = _rotation;
			if (_rotationEuler !== value)
				value.cloneTo(_rotationEuler);
			
			_setTransformFlag(TRANSFORM_WORLDEULER, false);
		}
		
		/**
		 * 获取世界矩阵。
		 * @return	世界矩阵。
		 */
		public function get worldMatrix():Matrix4x4 {
			if (_getTransformFlag(TRANSFORM_WORLDMATRIX)) {
				if (_parent != null)
					Matrix4x4.multiply(_parent.worldMatrix, localMatrix, _worldMatrix);
				else
					localMatrix.cloneTo(_worldMatrix);
				
				_setTransformFlag(TRANSFORM_WORLDMATRIX, false);
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
			if (_worldMatrix !== value)
				value.cloneTo(_worldMatrix);
			
			_setTransformFlag(TRANSFORM_WORLDMATRIX, false);
		}
		
		/**
		 * 创建一个 <code>Transform3D</code> 实例。
		 * @param owner 所属精灵。
		 */
		public function Transform3D(owner:Sprite3D) {
			_owner = owner;
			_children = new Vector.<Transform3D>();
			_setTransformFlag(TRANSFORM_LOCALQUATERNION | TRANSFORM_LOCALEULER | TRANSFORM_LOCALMATRIX, false);
			_setTransformFlag(TRANSFORM_WORLDPOSITION | TRANSFORM_WORLDQUATERNION | TRANSFORM_WORLDEULER | TRANSFORM_WORLDSCALE | TRANSFORM_WORLDMATRIX, true);
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
		public function _setParent(value:Transform3D):void {
			if (_parent !== value) {
				if (_parent) {
					var parentChilds:Vector.<Transform3D> = _parent._children;
					var index:int = parentChilds.indexOf(this);
					parentChilds.splice(index, 1);
				}
				if (value) {
					value._children.push(this);
					(value) && (_onWorldTransform());
				}
				_parent = value;
			}
		}
		
		/**
		 * @private
		 */
		private function _updateLocalMatrix():void {
			Matrix4x4.createAffineTransformation(_localPosition, localRotation, _localScale, _localMatrix);
		}
		
		/**
		 * @private
		 */
		private function _onWorldPositionRotationTransform():void {
			if (!_getTransformFlag(TRANSFORM_WORLDMATRIX) || !_getTransformFlag(TRANSFORM_WORLDPOSITION) || !_getTransformFlag(TRANSFORM_WORLDQUATERNION) || !_getTransformFlag(TRANSFORM_WORLDEULER)) {
				_setTransformFlag(TRANSFORM_WORLDMATRIX | TRANSFORM_WORLDPOSITION | TRANSFORM_WORLDQUATERNION | TRANSFORM_WORLDEULER, true);
				event(Event.TRANSFORM_CHANGED, _transformFlag);
				for (var i:int = 0, n:int = _children.length; i < n; i++)
					_children[i]._onWorldPositionRotationTransform();
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldPositionScaleTransform():void {
			if (!_getTransformFlag(TRANSFORM_WORLDMATRIX) || !_getTransformFlag(TRANSFORM_WORLDPOSITION) || !_getTransformFlag(TRANSFORM_WORLDSCALE)) {
				_setTransformFlag(TRANSFORM_WORLDMATRIX | TRANSFORM_WORLDPOSITION | TRANSFORM_WORLDSCALE, true);
				event(Event.TRANSFORM_CHANGED, _transformFlag);
				for (var i:int = 0, n:int = _children.length; i < n; i++)
					_children[i]._onWorldPositionScaleTransform();
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldPositionTransform():void {
			if (!_getTransformFlag(TRANSFORM_WORLDMATRIX) || !_getTransformFlag(TRANSFORM_WORLDPOSITION)) {
				_setTransformFlag(TRANSFORM_WORLDMATRIX | TRANSFORM_WORLDPOSITION, true);
				event(Event.TRANSFORM_CHANGED, _transformFlag);
				for (var i:int = 0, n:int = _children.length; i < n; i++)
					_children[i]._onWorldPositionTransform();
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldRotationTransform():void {
			if (!_getTransformFlag(TRANSFORM_WORLDMATRIX) || !_getTransformFlag(TRANSFORM_WORLDQUATERNION) || !_getTransformFlag(TRANSFORM_WORLDEULER)) {
				_setTransformFlag(TRANSFORM_WORLDMATRIX | TRANSFORM_WORLDQUATERNION | TRANSFORM_WORLDEULER, true);
				event(Event.TRANSFORM_CHANGED, _transformFlag);
				for (var i:int = 0, n:int = _children.length; i < n; i++)
					_children[i]._onWorldPositionRotationTransform();//父节点旋转发生变化，子节点的世界位置和旋转都需要更新
			}
		}
		
		/**
		 * @private
		 */
		private function _onWorldScaleTransform():void {
			if (!_getTransformFlag(TRANSFORM_WORLDMATRIX) || !_getTransformFlag(TRANSFORM_WORLDSCALE)) {
				_setTransformFlag(TRANSFORM_WORLDMATRIX | TRANSFORM_WORLDSCALE, true);
				event(Event.TRANSFORM_CHANGED, _transformFlag);
				for (var i:int = 0, n:int = _children.length; i < n; i++)
					_children[i]._onWorldPositionScaleTransform();//父节点缩放发生变化，子节点的世界位置和缩放都需要更新
			}
		}
		
		/**
		 * @private
		 */
		public function _onWorldTransform():void {
			if (!_getTransformFlag(TRANSFORM_WORLDMATRIX) || !_getTransformFlag(TRANSFORM_WORLDPOSITION) || !_getTransformFlag(TRANSFORM_WORLDQUATERNION) || !_getTransformFlag(TRANSFORM_WORLDEULER) || !_getTransformFlag(TRANSFORM_WORLDSCALE)) {
				_setTransformFlag(TRANSFORM_WORLDMATRIX | TRANSFORM_WORLDPOSITION | TRANSFORM_WORLDQUATERNION | TRANSFORM_WORLDEULER | TRANSFORM_WORLDSCALE, true);
				event(Event.TRANSFORM_CHANGED, _transformFlag);
				for (var i:int = 0, n:int = _children.length; i < n; i++)
					_children[i]._onWorldTransform();
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
		 * 获取向前方向。
		 * @param 前方向。
		 */
		public function getForward(forward:Vector3):void {
			var worldMatElem:Float32Array = worldMatrix.elements;
			forward.x = -worldMatElem[8];
			forward.y = -worldMatElem[9];
			forward.z = -worldMatElem[10];
		}
		
		/**
		 * 获取向上方向。
		 * @param 上方向。
		 */
		public function getUp(up:Vector3):void {
			var worldMatElem:Float32Array = worldMatrix.elements;
			up.x = worldMatElem[4];
			up.y = worldMatElem[5];
			up.z = worldMatElem[6];
		}
		
		/**
		 * 获取向右方向。
		 * @param 右方向。
		 */
		public function getRight(right:Vector3):void {
			var worldMatElem:Float32Array = worldMatrix.elements;
			right.x = worldMatElem[0];
			right.y = worldMatElem[1];
			right.z = worldMatElem[2];
		}
		
		/**
		 * 观察目标位置。
		 * @param	target 观察目标。
		 * @param	up 向上向量。
		 * @param	isLocal 是否局部空间。
		 */
		public function lookAt(target:Vector3, up:Vector3, isLocal:Boolean = false):void {
			var eye:Vector3;
			if (isLocal) {
				eye = _localPosition;
				if (Math.abs(eye.x - target.x) < MathUtils3D.zeroTolerance && Math.abs(eye.y - target.y) < MathUtils3D.zeroTolerance && Math.abs(eye.z - target.z) < MathUtils3D.zeroTolerance)
					return;
				
				Quaternion.lookAt(_localPosition, target, up, _localRotation);
				_localRotation.invert(_localRotation);
				localRotation = _localRotation;
			} else {
				var worldPosition:Vector3 = position;
				eye = worldPosition;
				if (Math.abs(eye.x - target.x) < MathUtils3D.zeroTolerance && Math.abs(eye.y - target.y) < MathUtils3D.zeroTolerance && Math.abs(eye.z - target.z) < MathUtils3D.zeroTolerance)
					return;
				
				Quaternion.lookAt(worldPosition, target, up, _rotation);
				_rotation.invert(_rotation);
				rotation = _rotation;
			}
		}
	
	}

}