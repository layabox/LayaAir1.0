package laya.d3.physics.shape {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.physics.PhysicsComponent;
	
	/**
	 * <code>CompoundColliderShape</code> 类用于创建盒子形状碰撞器。
	 */
	public class CompoundColliderShape extends ColliderShape {
		/**@private */
		private static var _nativeVector3One:* = new Laya3D._physics3D.btVector3(1, 1, 1);
		/**@private */
		private static var _nativeTransform:* = new Laya3D._physics3D.btTransform();
		/**@private */
		private static var _nativeOffset:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		/**@private */
		private static var _nativRotation:* = new Laya3D._physics3D.btQuaternion(0, 0, 0, 1);
		
		/**@private */
		private var _childColliderShapes:Vector.<ColliderShape> = new Vector.<ColliderShape>();
		
		/**
		 * 创建一个新的 <code>CompoundColliderShape</code> 实例。
		 */
		public function CompoundColliderShape() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_type = ColliderShape.SHAPETYPES_COMPOUND;
			_nativeShape = new Laya3D._physics3D.btCompoundShape();
		}
		
		/**
		 * @private
		 */
		private function _clearChildShape(shape:ColliderShape):void {
			shape._attatched = false;
			shape._compoundParent = null;
			shape._indexInCompound = -1;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _addReference():void {
			//TODO:
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _removeReference():void {
			//TODO:
		}
		
		/**
		 * @private
		 */
		public function _updateChildTransform(shape:ColliderShape):void {
			var offset:Vector3 = shape.localOffset;
			var rotation:Quaternion = shape.localRotation;
			var nativeOffset:* = _nativeVector30;
			var nativeQuaternion:* = _nativQuaternion0;
			var nativeTransform:* = _nativeTransform0;
			nativeOffset.setValue( -offset.x, offset.y, offset.z);
			nativeQuaternion.setValue(-rotation.x, rotation.y, rotation.z, -rotation.w);
			nativeTransform.setOrigin(nativeOffset);
			nativeTransform.setRotation(nativeQuaternion);
			_nativeShape.updateChildTransform(shape._indexInCompound, nativeTransform, true);
		}
		
		/**
		 * 添加子碰撞器形状。
		 * @param	shape 子碰撞器形状。
		 */
		public function addChildShape(shape:ColliderShape):void {
			if (shape._attatched)
				throw "CompoundColliderShape: this shape has attatched to other entity.";
			
			shape._attatched = true;
			shape._compoundParent = this;
			shape._indexInCompound = _childColliderShapes.length;
			_childColliderShapes.push(shape);
			var offset:Vector3 = shape.localOffset;
			var rotation:Quaternion = shape.localRotation;
			_nativeOffset.setValue(-offset.x, offset.y, offset.z);
			_nativRotation.setValue(-rotation.x, rotation.y, rotation.z, -rotation.w);
			_nativeTransform.setOrigin(_nativeOffset);
			_nativeTransform.setRotation(_nativRotation);
			
			var nativeScale:* = _nativeShape.getLocalScaling();
			_nativeShape.setLocalScaling(_nativeVector3One);
			_nativeShape.addChildShape(_nativeTransform, shape._nativeShape);
			_nativeShape.setLocalScaling(nativeScale);
			
			(_attatchedCollisionObject) && (_attatchedCollisionObject.colliderShape = this);//修改子Shape需要重新赋值父Shape以及将物理精灵重新加入物理世界等操作
		}
		
		/**
		 * 移除子碰撞器形状。
		 * @param	shape 子碰撞器形状。
		 */
		public function removeChildShape(shape:ColliderShape):void {
			if (shape._compoundParent === this) {
				var index:int = shape._indexInCompound;
				_clearChildShape(shape);
				var endShape:ColliderShape = _childColliderShapes[_childColliderShapes.length - 1];
				endShape._indexInCompound = index;
				_childColliderShapes[index] = endShape;
				_childColliderShapes.pop();
				_nativeShape.removeChildShapeByIndex(index);
			}
		}
		
		/**
		 * 清空子碰撞器形状。
		 */
		public function clearChildShape():void {
			for (var i:int = 0, n:int = _childColliderShapes.length; i < n; i++) {
				_clearChildShape(_childColliderShapes[i]);
				_nativeShape.removeChildShapeByIndex(0);
			}
			_childColliderShapes.length = 0;
		}
		
		/**
		 * 获取子形状数量。
		 * @return
		 */
		public function getChildShapeCount():int {
			return _childColliderShapes.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			var destCompoundColliderShape:CompoundColliderShape = destObject as CompoundColliderShape;
			destCompoundColliderShape.clearChildShape();
			for (var i:int = 0, n:int = _childColliderShapes.length; i < n; i++)
				destCompoundColliderShape.addChildShape(_childColliderShapes[i].clone());
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():* {
			var dest:CompoundColliderShape = new CompoundColliderShape();
			cloneTo(dest);
			return dest;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			super.destroy();
			for (var i:int = 0, n:int = _childColliderShapes.length; i < n; i++) {
				var childShape:ColliderShape = _childColliderShapes[i];
				if (childShape._referenceCount === 0)
					childShape.destroy();
			}
		}
	
	}

}