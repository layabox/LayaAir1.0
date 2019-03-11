package laya.d3.animation {
	import laya.d3.core.Transform3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.renders.Render;
	
	/**
	 * <code>AnimationTransform3D</code> 类用于实现3D变换。
	 */
	public class AnimationTransform3D extends EventDispatcher {
		/**@private */
		private static var _tempVector3:Vector3 = new Vector3();
		/**@private */
		private static const _angleToRandin:Number = 180 / Math.PI;
		
		/** @private */
		private var _localMatrix:Float32Array;
		/** @private */
		private var _worldMatrix:Float32Array;
		/** @private */
		private var _localPosition:Vector3;
		/** @private */
		private var _localRotation:Quaternion;
		/** @private */
		private var _localScale:Vector3;
		/** @private */
		private var _localQuaternionUpdate:Boolean;
		/** @private */
		private var _locaEulerlUpdate:Boolean;
		/** @private */
		private var _localUpdate:Boolean;
		/** @private */
		private var _parent:AnimationTransform3D;
		/** @private */
		private var _children:Vector.<AnimationTransform3D>;
		
		/**@private */
		public var _localRotationEuler:Vector3;
		/**@private */
		public var _owner:AnimationNode;
		/** @private */
		public var _worldUpdate:Boolean;
		
		/**
		 * 创建一个 <code>Transform3D</code> 实例。
		 * @param owner 所属精灵。
		 */
		public function AnimationTransform3D(owner:AnimationNode, localPosition:Float32Array = null/*[NATIVE]*/, localRotation:Float32Array = null/*[NATIVE]*/, localScale:Float32Array = null/*[NATIVE]*/, worldMatrix:Float32Array = null/*[NATIVE]*/) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_owner = owner;
			_children = new Vector.<AnimationTransform3D>();
			
			_localMatrix = new Float32Array(16);
			if (Render.isConchApp) {//[NATIVE]
				_localPosition = new Vector3(0,0,0,localPosition);
				_localRotation = new Quaternion(0,0,0,1,localRotation);
				_localScale = new Vector3(0,0,0,localScale);
				_worldMatrix = worldMatrix;
			} else {
				_localPosition = new Vector3();
				_localRotation = new Quaternion();
				_localScale = new Vector3();
				_worldMatrix = new Float32Array(16);
			}
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
				Utils3D._createAffineTransformationArray(_localPosition.elements, _localRotation.elements, _localScale.elements, _localMatrix);
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
				for (var i:int = 0, n:int = _children.length; i < n; i++)
					_children[i]._onWorldTransform();
			}
		}
		
		/**
		 * @private
		 */
		public function get localPosition():Vector3 {
			return _localPosition;
		}
		
		/**
		 * @private
		 */
		public function set localPosition(value:Vector3):void {
			_localPosition = value;
			_localUpdate = true;
			_onWorldTransform();
		}
		
		/**
		 * @private
		 */
		public function get localRotation():Quaternion {
			if (_localQuaternionUpdate) {
				var eulerE:Float32Array = _localRotationEuler.elements;
				Quaternion.createFromYawPitchRoll(eulerE[1] / _angleToRandin, eulerE[0] / _angleToRandin, eulerE[2] / _angleToRandin, _localRotation);
				_localQuaternionUpdate = false;
			}
			return _localRotation;
		}
		
		/*
		 * @private
		 */
		public function set localRotation(value:Quaternion):void {
			_localRotation = value;
			//Utils3D.quaterionNormalize(_localRotation, _localRotation);
			_locaEulerlUpdate = true;
			_localQuaternionUpdate = false;
			_localUpdate = true;
			_onWorldTransform();
		}
		
		/**
		 * @private
		 */
		public function get localScale():Vector3 {
			return _localScale;
		}
		
		/**
		 * @private
		 */
		public function set localScale(value:Vector3):void {
			_localScale = value;
			_localUpdate = true;
			_onWorldTransform();
		}
		
		/**
		 * @private
		 */
		public function get localRotationEuler():Vector3 {
			if (_locaEulerlUpdate) {
				_localRotation.getYawPitchRoll(_tempVector3);
				var eulerE:Float32Array = _tempVector3.elements;
				var localRotationEulerE:Float32Array = _localRotationEuler.elements;
				localRotationEulerE[0] = eulerE[1] * _angleToRandin;
				localRotationEulerE[1] = eulerE[0] * _angleToRandin;
				localRotationEulerE[2] = eulerE[2] * _angleToRandin;
				_locaEulerlUpdate = false;
			}
			return _localRotationEuler;
		}
		
		/**
		 * @private
		 */
		public function set localRotationEuler(value:Vector3):void {
			_localRotationEuler = value;
			_locaEulerlUpdate = false;
			_localQuaternionUpdate = true;
			_localUpdate = true;
			_onWorldTransform();
		}
		
		/**
		 * 获取世界矩阵。
		 * @return	世界矩阵。
		 */
		public function getWorldMatrix():Float32Array {
			if (!Render.isConchApp && _worldUpdate) {
				if (_parent != null) {
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
					var parentChilds:Vector.<AnimationTransform3D> = _parent._children;
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
	}

}