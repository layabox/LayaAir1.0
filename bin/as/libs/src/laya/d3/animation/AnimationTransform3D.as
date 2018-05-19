package laya.d3.animation {
	import laya.d3.core.Transform3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	
	/**
	 * <code>Transform3D</code> 类用于实现3D变换。
	 */
	public class AnimationTransform3D extends EventDispatcher {
		/**@private */
		private static var _tempVector3:Float32Array = new Float32Array(3);
		/**@private */
		private static const _angleToRandin:Number = 180 / Math.PI;
		
		/** @private */
		private var _localMatrix:Float32Array;
		/** @private */
		private var _worldMatrix:Float32Array;
		
		/** @private */
		private var _localPosition:Float32Array;
		/** @private */
		private var _localRotation:Float32Array;
		/** @private */
		private var _localScale:Float32Array;
		/** @private */
		private var _localQuaternionUpdate:Boolean;
		/** @private */
		private var _locaEulerlUpdate:Boolean;
		/** @private */
		private var _localUpdate:Boolean;
		/** @private */
		private var _parent:AnimationTransform3D;
		/** @private */
		private var _childs:Vector.<AnimationTransform3D>;
		
		/**@private */
		public var _localRotationEuler:Float32Array;
		/**@private */
		public var _owner:AnimationNode;
		/** @private */
		public var _worldUpdate:Boolean;
		
		/**@private */
		public var _entity:Transform3D;
		
		/**
		 * 创建一个 <code>Transform3D</code> 实例。
		 * @param owner 所属精灵。
		 */
		public function AnimationTransform3D(owner:AnimationNode) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_owner = owner;
			_childs = new Vector.<AnimationTransform3D>();
			_localMatrix = new Float32Array(16);
			_localQuaternionUpdate = false;
			_locaEulerlUpdate = false;
			_localUpdate = false;
			_worldUpdate = true;
		}
		
		/**
		 * @private
		 */
		private function _getlocalMatrix():Float32Array {
			if (_localUpdate) {
				Utils3D._createAffineTransformationArray(_localPosition, _localRotation, _localScale, _localMatrix);
				_localUpdate = false;
			}
			return _localMatrix;
		}
		
		/**
		 * @private
		 */
		private function _onWorldTransform():void {
			if (!_worldUpdate) {
				_worldUpdate = true;
				for (var i:int = 0, n:int = _childs.length; i < n; i++)
					_childs[i]._onWorldTransform();
			}
		}
		
		/**
		 * @private
		 */
		public function _setWorldMatrixAndUpdate(matrix:Float32Array):void {
			_worldMatrix = matrix;
			if (_parent == null) {
				throw new Error("don't need to set worldMatrix to root Node.");
			} else {
				if (_parent._parent == null) {
					var locMat:Float32Array = _getlocalMatrix();
					for (var i:int = 0; i < 16; ++i)
						_worldMatrix[i] = locMat[i];
				} else {
					Utils3D.matrix4x4MultiplyFFF(_parent.getWorldMatrix(), _getlocalMatrix(), _worldMatrix);
				}
			}
			_worldUpdate = false;
		}
		
		/**
		 * @private
		 */
		public function _setWorldMatrixNoUpdate(matrix:Float32Array):void {
			_worldMatrix = matrix;
		}
		
		/**
		 * @private
		 */
		public function _setWorldMatrixIgnoreUpdate(matrix:Float32Array):void {
			_worldMatrix = matrix;
			_worldUpdate = false;
		}
		
		/**
		 * 获取局部位置。
		 * @return	局部位置。
		 */
		public function getLocalPosition():Float32Array {
			return _localPosition;
		}
		
		/**
		 * 设置局部位置。
		 * @param value 局部位置。
		 */
		public function setLocalPosition(value:Float32Array):void {
			if (_parent) {
				_localPosition = value;
				_localUpdate = true;
				_onWorldTransform();
			} else {
				var entityTransform:Transform3D = _entity.owner._transform;
				var entityPosition:Vector3 = _entity.localPosition;
				var entityPositionE:Float32Array = entityPosition.elements;
				entityPositionE[0] = value[0];
				entityPositionE[1] = value[1];
				entityPositionE[2] = value[2];
				entityTransform.localPosition = entityPosition;
			}
		}
		
		/**
		 * 获取局部旋转。
		 * @return	局部旋转。
		 */
		public function getLocalRotation():Float32Array {
			if (_localQuaternionUpdate) {
				var eulerE:Float32Array = _localRotationEuler;
				Utils3D._quaternionCreateFromYawPitchRollArray(eulerE[1] / _angleToRandin, eulerE[0] / _angleToRandin, eulerE[2] / _angleToRandin, _localRotation);
				_localQuaternionUpdate = false;
			}
			return _localRotation;
		}
		
		/**
		 * 设置局部旋转。
		 * @param value	局部旋转。
		 */
		public function setLocalRotation(value:Float32Array):void {
			if (_parent) {
				_localRotation = value;
				Utils3D.quaterionNormalize(_localRotation, _localRotation);
				_locaEulerlUpdate = true;
				_localQuaternionUpdate = false;
				_localUpdate = true;
				_onWorldTransform();
			} else {
				var entityTransform:Transform3D = _entity.owner._transform;
				var entityRotation:Quaternion = _entity.localRotation;
				var entityRotationE:Float32Array = entityRotation.elements;
				entityRotationE[0] = value[0];
				entityRotationE[1] = value[1];
				entityRotationE[2] = value[2];
				entityRotationE[3] = value[3];
				entityTransform.localRotation = entityRotation;
			}
		}
		
		/**
		 * 获取局部缩放。
		 * @return	局部缩放。
		 */
		public function getLocalScale():Float32Array {
			return _localScale;
		}
		
		/**
		 * 设置局部缩放。
		 * @param	value 局部缩放。
		 */
		public function setLocalScale(value:Float32Array):void {
			if (_parent) {
				_localScale = value;
				_localUpdate = true;
				_onWorldTransform();
			} else {
				var entityTransform:Transform3D = _entity.owner._transform;
				var entityScale:Vector3 = _entity.localScale;
				var entityScaleE:Float32Array = entityScale.elements;
				entityScaleE[0] = value[0];
				entityScaleE[1] = value[1];
				entityScaleE[2] = value[2];
				entityTransform.localScale = entityScale;
			}
		}
		
		/**
		 * 获取局部空间的旋转角度。
		 * @return	欧拉角的旋转值，顺序为x、y、z。
		 */
		public function getLocalRotationEuler():Float32Array {
			if (_locaEulerlUpdate) {
				Utils3D.getYawPitchRoll(_localRotation, _tempVector3);
				var eulerE:Float32Array = _tempVector3;
				var localRotationEulerE:Float32Array = _localRotationEuler;
				localRotationEulerE[0] = eulerE[1] *_angleToRandin;
				localRotationEulerE[1] = eulerE[0] * _angleToRandin;
				localRotationEulerE[2] = eulerE[2] * _angleToRandin;
				_locaEulerlUpdate = false;
			}
			return _localRotationEuler;
		}
		
		/**
		 * 设置局部空间的旋转角度。
		 * @param	value 欧拉角的旋转值，顺序为x、y、z。
		 */
		public function setLocalRotationEuler(value:Float32Array):void {
			if (_parent) {
				Utils3D._quaternionCreateFromYawPitchRollArray(value[1] / _angleToRandin, value[0] / _angleToRandin, value[2] / _angleToRandin, _localRotation);
				_localRotationEuler = value;
				_locaEulerlUpdate = false;
				_localQuaternionUpdate = false;
				_localUpdate = true;
				_onWorldTransform();
			} else {
				var entityTransform:Transform3D = _entity.owner._transform;
				var entityLocalRotationEuler:Vector3 = _entity.localRotationEuler;
				var elements:Float32Array = entityLocalRotationEuler.elements;
				elements[0] = value[0];
				elements[1] = value[1];
				elements[2] = value[2];
				entityTransform.localRotationEuler = entityLocalRotationEuler;
			}
		}
		
		/**
		 * 获取世界矩阵。
		 * @return	世界矩阵。
		 */
		public function getWorldMatrix():Float32Array {
			if (_worldUpdate) {
				if (_parent._parent != null) {
					Utils3D.matrix4x4MultiplyFFF(_parent.getWorldMatrix(), _getlocalMatrix(), _worldMatrix);
				} else {
					var locMat:Float32Array = _getlocalMatrix();
					for (var i:int = 0; i < 16; ++i)
						_worldMatrix[i] = locMat[i];
				}
				_worldUpdate = false;
			}
			return _worldMatrix;
		}
		
		/**
		 * 设置父3D变换。
		 * @param	value 父3D变换。
		 */
		public function setParent(value:AnimationTransform3D):void {
			if (_parent !== value) {
				if (_parent) {
					var parentChilds:Vector.<AnimationTransform3D> = _parent._childs;
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
	}

}