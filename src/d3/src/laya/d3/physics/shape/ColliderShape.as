package laya.d3.physics.shape {
	import laya.d3.core.IClone;
	import laya.d3.physics.PhysicsComponent;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.net.Loader;
	
	/**
	 * <code>ColliderShape</code> 类用于创建形状碰撞器的父类，该类为抽象类。
	 */
	public class ColliderShape implements IClone {
		/** @private */
		public static const SHAPEORIENTATION_UPX:int = 0;
		/** @private */
		public static const SHAPEORIENTATION_UPY:int = 1;
		/** @private */
		public static const SHAPEORIENTATION_UPZ:int = 2;
		
		/** @private */
		public static const SHAPETYPES_BOX:int = 0;
		/** @private */
		public static const SHAPETYPES_SPHERE:int = 1;
		/** @private */
		public static const SHAPETYPES_CYLINDER:int = 2;
		/** @private */
		public static const SHAPETYPES_CAPSULE:int = 3;
		/** @private */
		public static const SHAPETYPES_CONVEXHULL:int = 4;
		/** @private */
		public static const SHAPETYPES_COMPOUND:int = 5;
		/** @private */
		public static const SHAPETYPES_STATICPLANE:int = 6;
		/** @private */
		public static const SHAPETYPES_CONE:int = 7;
		
		/** @private */
		public static const _tempVector30:Vector3 = new Vector3();
		/** @private */
		protected static var _nativeScale:* = new Laya3D._physics3D.btVector3(1, 1, 1);
		/**@private */
		protected static var _nativeVector30:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		/**@private */
		protected static var _nativQuaternion0:* = new Laya3D._physics3D.btQuaternion(0, 0, 0, 1);
		/**@private */
		protected static var _nativeTransform0:* = new Laya3D._physics3D.btTransform();
		
		/**
		 * @private
		 */
		public static function _creatShape(shapeData:Object):ColliderShape {
			var colliderShape:ColliderShape;
			switch (shapeData.type) {
			case "BoxColliderShape": 
				var sizeData:Array = shapeData.size;
				colliderShape = sizeData ? new BoxColliderShape(sizeData[0], sizeData[1], sizeData[2]) : new BoxColliderShape();
				break;
			case "SphereColliderShape": 
				colliderShape = new SphereColliderShape(shapeData.radius);
				break;
			case "CapsuleColliderShape": 
				colliderShape = new CapsuleColliderShape(shapeData.radius, shapeData.height, shapeData.orientation);
				break;
			case "MeshColliderShape": 
				var meshCollider:MeshColliderShape = new MeshColliderShape();
				shapeData.mesh && (meshCollider.mesh = Loader.getRes(shapeData.mesh));
				colliderShape = meshCollider;
				break;
			case "ConeColliderShape": 
				colliderShape = new ConeColliderShape(shapeData.radius, shapeData.height, shapeData.orientation);
				break;
			case "CylinderColliderShape": 
				colliderShape = new CylinderColliderShape(shapeData.radius, shapeData.height, shapeData.orientation);
				break;
			default: 
				throw "unknown shape type.";
			}
			
			if (shapeData.center) {
				var localOffset:Vector3 = colliderShape.localOffset;
				localOffset.fromArray(shapeData.center);
				colliderShape.localOffset = localOffset;
			}
			return colliderShape;
		}
		
		/**
		 * @private
		 */
		public static function _createAffineTransformation(trans:Float32Array, rot:Float32Array, outE:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var x:Number = rot[0], y:Number = rot[1], z:Number = rot[2], w:Number = rot[3], x2:Number = x + x, y2:Number = y + y, z2:Number = z + z;
			var xx:Number = x * x2, xy:Number = x * y2, xz:Number = x * z2, yy:Number = y * y2, yz:Number = y * z2, zz:Number = z * z2;
			var wx:Number = w * x2, wy:Number = w * y2, wz:Number = w * z2;
			
			outE[0] = (1 - (yy + zz));
			outE[1] = (xy + wz);
			outE[2] = (xz - wy);
			outE[3] = 0;
			outE[4] = (xy - wz);
			outE[5] = (1 - (xx + zz));
			outE[6] = (yz + wx);
			outE[7] = 0;
			outE[8] = (xz + wy);
			outE[9] = (yz - wx);
			outE[10] = (1 - (xx + yy));
			outE[11] = 0;
			outE[12] = trans[0];
			outE[13] = trans[1];
			outE[14] = trans[2];
			outE[15] = 1;
		}
		
		/**@private */
		protected var _scale:Vector3 = new Vector3(1, 1, 1);
		
		/**@private */
		public var _nativeShape:*;
		/**@private */
		public var _type:int;//TODO:可以删掉
		/**@private */
		public var _centerMatrix:Matrix4x4 = new Matrix4x4();
		
		/**@private */
		public var _attatched:Boolean = false;
		/**@private */
		public var _indexInCompound:int = -1;
		/**@private */
		public var _compoundParent:CompoundColliderShape = null;
		/**@private */
		public var _attatchedCollisionObject:PhysicsComponent = null;
		
		/**@private */
		public var _referenceCount:int = 0;
		
		/**@private */
		private var _localOffset:Vector3 = new Vector3(0, 0, 0);
		/**@private */
		private var _localRotation:Quaternion = new Quaternion(0, 0, 0, 1);
		
		public var needsCustomCollisionCallback:Boolean = false;//TODO:默认值,TODO:::::::::::::::::::::::::::::::
		
		/**
		 * 获取碰撞类型。
		 * @return 碰撞类型。
		 */
		public function get type():int {
			return _type;
		}
		
		/**
		 * 获取Shape的本地偏移。
		 * @return Shape的本地偏移。
		 */
		public function get localOffset():Vector3 {
			return _localOffset;
		}
		
		/**
		 * 设置Shape的本地偏移。
		 * @param Shape的本地偏移。
		 */
		public function set localOffset(value:Vector3):void {
			_localOffset = value;
			if (_compoundParent)
				_compoundParent._updateChildTransform(this);
		}
		
		/**
		 * 获取Shape的本地旋转。
		 * @return Shape的本地旋转。
		 */
		public function get localRotation():Quaternion {
			return _localRotation;
		}
		
		/**
		 * 设置Shape的本地旋转。
		 * @param Shape的本地旋转。
		 */
		public function set localRotation(value:Quaternion):void {
			_localRotation = value;
			if (_compoundParent)
				_compoundParent._updateChildTransform(this);
		}
		
		/**
		 * 创建一个新的 <code>ColliderShape</code> 实例。
		 */
		public function ColliderShape() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * @private
		 */
		public function _setScale(value:Vector3):void {
			if (_compoundParent) {//TODO:待查,这里有问题
				updateLocalTransformations();
			} else {
				var valueE:Float32Array = value.elements;
				_nativeScale.setValue(valueE[0], valueE[1], valueE[2]);
				_nativeShape.setLocalScaling(_nativeScale);
			}
		}
		
		/**
		 * @private
		 */
		public function _addReference():void {
			_referenceCount++;
		}
		
		/**
		 * @private
		 */
		public function _removeReference():void {
			_referenceCount--;
		}
		
		/**
		 * 更新本地偏移,如果修改LocalOffset或LocalRotation需要调用。
		 */
		public function updateLocalTransformations():void {//TODO:是否需要优化
			if (_compoundParent) {
				var offset:Vector3 = _tempVector30;
				Vector3.multiply(localOffset, _scale, offset);
				_createAffineTransformation(offset.elements, localRotation.elements, _centerMatrix.elements);
			} else {
				_createAffineTransformation(localOffset.elements, localRotation.elements, _centerMatrix.elements);
			}
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destColliderShape:ColliderShape = destObject as ColliderShape;
			_localOffset.cloneTo(destColliderShape.localOffset);
			_localRotation.cloneTo(destColliderShape.localRotation);
			destColliderShape.localOffset = destColliderShape.localOffset;
			destColliderShape.localRotation = destColliderShape.localRotation;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			return null;
		}
		
		/**
		 * @private
		 */
		public function destroy():void {
			if (_nativeShape) {
				Laya3D._physics3D.destroy(_nativeShape);
				_nativeShape = null;
			}
		}
	
	}

}