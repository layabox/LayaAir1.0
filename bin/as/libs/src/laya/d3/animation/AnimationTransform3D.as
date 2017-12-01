package laya.d3.animation {
	import laya.d3.core.Transform3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	
	/**
	 * <code>Transform3D</code> 类用于实现3D变换。
	 */
	public class AnimationTransform3D extends EventDispatcher {
		/**@private */
		private static var _tempVector3:Vector3 = new Vector3();
		/**@private */
		private static const _angleToRandin:Number = 180 / Math.PI;
		/**@private */
		private static const _randinToAngle:Number = 180 * Math.PI;
		
		/** @private */
		private var _scale:Vector3 = new Vector3(1, 1, 1);
		/** @private */
		private var _localMatrix:Matrix4x4 = new Matrix4x4();
		/** @private */
		private var _worldMatrix:Matrix4x4;
		
		/** @private */
		private var _localQuaternionUpdate:Boolean = false;
		/** @private */
		private var _locaEulerlUpdate:Boolean = false;
		/** @private */
		private var _localUpdate:Boolean = false;
		/** @private */
		private var _parent:AnimationTransform3D;
		/** @private */
		private var _childs:Vector.<AnimationTransform3D>;
		/**@private */
		public var _owner:AnimationNode;
		/** @private */
		public var _worldUpdate:Boolean = true;
		/** @private */
		public var _scaleUpdate:Boolean = true;
		
		/** @private */
		public var _localPosition:Vector3 = new Vector3();
		/** @private */
		public var _localRotation:Quaternion = new Quaternion(0, 0, 0, 1);
		/** @private */
		public var _localScale:Vector3 = new Vector3(1, 1, 1);
		/**@private */
		public var _localRotationEuler:Vector3 = new Vector3();
		
		/**@private */
		public var _entity:Transform3D;
		
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
			if (_localQuaternionUpdate) {
				var eulerE:Float32Array = _localRotationEuler.elements;
				Quaternion.createFromYawPitchRoll(eulerE[1] / _angleToRandin, eulerE[0] / _angleToRandin, eulerE[2] / _angleToRandin, _localRotation);
				_localQuaternionUpdate = false;
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
			_onWorldScaleTransform();
		}
		
		/**
		 * 设置局部空间的旋转角度。
		 * @param	value 欧拉角的旋转值，顺序为x、y、z。
		 */
		public function set localRotationEuler(value:Vector3):void {
			var valueE:Float32Array = value.elements;
			_localRotationEuler = value;
			_locaEulerlUpdate = false;
			_localQuaternionUpdate = true;
			_onLocalTransform();
			_onWorldTransform();
		}
		
		/**
		 * 获取局部空间的旋转角度。
		 * @return	欧拉角的旋转值，顺序为x、y、z。
		 */
		public function get localRotationEuler():Vector3 {
			if (_locaEulerlUpdate) {
				_localRotation.getYawPitchRoll(_tempVector3);
				var eulerE:Float32Array = _tempVector3.elements;
				var localRotationEulerE:Float32Array = _localRotationEuler.elements;
				localRotationEulerE[0] = eulerE[1] / _randinToAngle;
				localRotationEulerE[1] = eulerE[0] / _randinToAngle;
				localRotationEulerE[2] = eulerE[2] / _randinToAngle;
				_locaEulerlUpdate = false;
			}
			return _localRotationEuler;
		}
		
		/**
		 * 获取父3D变换。
		 * @return 父3D变换。
		 */
		public function get parent():AnimationTransform3D {
			return _parent;
		}
		
		/**
		 * 设置父3D变换。
		 * @param	value 父3D变换。
		 */
		public function set parent(value:AnimationTransform3D):void {
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
		
		/**
		 * 创建一个 <code>Transform3D</code> 实例。
		 * @param owner 所属精灵。
		 */
		public function AnimationTransform3D(owner:AnimationNode) {
			_owner = owner;
			_childs = new Vector.<AnimationTransform3D>();
		}
		
		/**
		 * @private
		 */
		private function _updateLocalMatrix():void {
			Matrix4x4.createAffineTransformation(_localPosition, _localRotation, _localScale, _localMatrix);
		}
		
		/**
		 * @private
		 */
		private function _onLocalTransform():void {
			_localUpdate = true;
		}
		
		/**
		 * @private
		 */
		public function _onWorldTransform():void {
			if (!_worldUpdate) {
				_worldUpdate = true;
				event(Event.WORLDMATRIX_NEEDCHANGE);
				for (var i:int = 0, n:int = _childs.length; i < n; i++)
					_childs[i]._onWorldTransform();
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
					_childs[i]._onWorldScaleTransform();
			}
		}
		
		public function _setLocalPosition(value:Vector3):void {
			if (_parent) {
				_localPosition = value;
				_onLocalTransform();
				_onWorldTransform();
			} else {
				var entityTransform:Transform3D = _entity.owner._transform;
				var entityPosition:Vector3 = _entity.localPosition;
				value.cloneTo(entityPosition);
				entityTransform.localPosition = entityPosition;
			}
		}
		
		/**
		 * 设置局部旋转。
		 * @param value	局部旋转。
		 */
		public function _setLocalRotation(value:Quaternion):void {
			if (_parent) {
				_localRotation = value;
				_localRotation.normalize(_localRotation);
				_locaEulerlUpdate = true;
				_localQuaternionUpdate = false;
				_onLocalTransform();
				_onWorldTransform();
			} else {
				var entityTransform:Transform3D = _entity.owner._transform;
				var entityRotation:Quaternion = _entity.localRotation;
				value.cloneTo(entityRotation);
				entityTransform.localRotation = entityRotation;
			}
		}
		
		/**
		 * 设置局部缩放。
		 * @param	value 局部缩放。
		 */
		public function _setLocalScale(value:Vector3):void {
			if (_parent) {
				_localScale = value;
				_onLocalTransform();
				_onWorldTransform();
			} else {
				var entityTransform:Transform3D = _entity.owner._transform;
				var entityScale:Vector3 = _entity.localScale;
				value.cloneTo(entityScale);
				entityTransform.localScale = entityScale;
			}
		}
		
		/**
		 * 设置局部空间的旋转角度。
		 * @param	value 欧拉角的旋转值，顺序为x、y、z。
		 */
		public function _setLocalRotationEuler(value:Vector3):void {
			if (_parent) {
				var valueE:Float32Array = value.elements;
				Quaternion.createFromYawPitchRoll(valueE[1] / _angleToRandin, valueE[0] / _angleToRandin, valueE[2] / _angleToRandin, _localRotation);
				_localRotationEuler = value;
				_locaEulerlUpdate = false;
				_localQuaternionUpdate = false;
				_onLocalTransform();
				_onWorldTransform();
			} else {
				var entityTransform:Transform3D = _entity.owner._transform;
				var entityLocalRotationEuler:Vector3 = _entity.localRotationEuler;
				value.cloneTo(entityLocalRotationEuler);
				entityTransform.localRotationEuler = entityLocalRotationEuler;
			}
		}
		
		/**
		 * 获取世界矩阵。
		 * @return	世界矩阵。
		 */
		public function _getWorldMatrix():Matrix4x4 {
			if (_worldUpdate) {
				if (_parent._parent != null)
					Matrix4x4.multiply(_parent._getWorldMatrix(), localMatrix, _worldMatrix);
				else
					localMatrix.cloneTo(_worldMatrix);
				_worldUpdate = false;
			}
			return _worldMatrix;
		}
		
		/**
		 * @private
		 * 设置世界矩阵，并需要更新。
		 * @return	世界矩阵。
		 */
		public function _setWorldMatrixAndUpdate(matrix:Matrix4x4):void {
			_worldMatrix = matrix;
			if (_parent == null) {
				throw new Error("don't need to set worldMatrix to root Node.");
			} else {
				if (_parent._parent == null)
					localMatrix.cloneTo(_worldMatrix);
				else
					Matrix4x4.multiply(_parent._getWorldMatrix(), localMatrix, _worldMatrix);
			}
			_worldUpdate = false;
		}
		
		/**
		 * @private
		 * 设置世界矩阵，不需要更新，再次修改相关位置才会更新。
		 * @return	世界矩阵。
		 */
		public function _setWorldMatrixNoUpdate(matrix:Matrix4x4):void {
			_worldMatrix = matrix;
			_worldUpdate = false;
		}
		
		/**
		 * 获取世界缩放。
		 * @return	世界缩放。
		 */
		public function getScale():Vector3 {
			if (_scaleUpdate) {
				if (_parent !== null)
					Vector3.multiply(_parent.getScale(), _localScale, _scale);
				else
					_localScale.cloneTo(_scale);
				
				_scaleUpdate = false;
			}
			return _scale;
		}
	}

}