package laya.d3.animation {
	import laya.d3.core.Transform3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Native.ConchQuaternion;
	import laya.d3.math.Native.ConchVector3;
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
			if (Render.supportWebGLPlusAnimation) {//[NATIVE]
				/*
				_localPosition = new Vector3(0,0,0);
				_localPosition.forNativeElement(localPosition);
				_localRotation = new Quaternion(0,0,0,1);
				_localRotation.forNativeElement(localRotation);
				_localScale = new Vector3(0,0,0);
				_localScale.forNativeElement(localScale);
				_worldMatrix = worldMatrix;
				*/
				__JS__("this._localPosition = new ConchVector3(0,0,0,localPosition)");
				__JS__("this._localRotation = new ConchQuaternion(0,0,0,1,localRotation)");
				__JS__("this._localScale = new ConchVector3(0,0,0,localScale)");
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
				var euler:Vector3 = _localRotationEuler;
				Quaternion.createFromYawPitchRoll(euler.y / _angleToRandin, euler.x / _angleToRandin, euler.z / _angleToRandin, _localRotation);
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
				var euler:Vector3 = _tempVector3;
				var localRotationEuler:Vector3 = _localRotationEuler;
				localRotationEuler.x = euler.y * _angleToRandin;
				localRotationEuler.y = euler.x * _angleToRandin;
				localRotationEuler.z = euler.z * _angleToRandin;
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
			if (!Render.supportWebGLPlusAnimation && _worldUpdate) {
				if (_parent != null) {
					Utils3D.matrix4x4MultiplyFFF(_parent.getWorldMatrix(), _getlocalMatrix(), _worldMatrix);
				} else {
					var e:Float32Array = _worldMatrix;//根节点的世界矩阵始终为单位矩阵。需使用Animator中的矩阵,否则移动Animator精灵无效
					e[1] = e[2] = e[3] = e[4] = e[6] = e[7] = e[8] = e[9] = e[11] = e[12] = e[13] = e[14] = 0;
					e[0] = e[5] = e[10] = e[15] = 1;
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