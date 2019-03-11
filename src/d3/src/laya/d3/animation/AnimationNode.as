package laya.d3.animation {
	import laya.d3.core.Avatar;
	import laya.d3.core.IClone;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>BoneNode</code> 类用于实现骨骼节点。
	 */
	public class AnimationNode implements IClone {
		/**@private */
		private var _children:Vector.<AnimationNode>;
		
		/**@private */
		public var _parent:AnimationNode;
		/**@private [只读]*/
		public var transform:AnimationTransform3D;
		
		/**节点名称。 */
		public var name:String;
		
		/**@private	[NATIVE]*/
		public var _worldMatrixIndex:int;
		
		/**
		 * 创建一个新的 <code>AnimationNode</code> 实例。
		 */
		public function AnimationNode(localPosition:Float32Array = null/*[NATIVE]*/, localRotation:Float32Array = null/*[NATIVE]*/, localScale:Float32Array = null/*[NATIVE]*/, worldMatrix:Float32Array = null/*[NATIVE]*/) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_children = new Vector.<AnimationNode>();
			transform = new AnimationTransform3D(this, localPosition, localRotation, localScale, worldMatrix);
		}
		
		/**
		 * 添加子节点。
		 * @param	child  子节点。
		 */
		public function addChild(child:AnimationNode):void {
			child._parent = this;
			child.transform.setParent(transform);
			_children.push(child);
		}
		
		/**
		 * 移除子节点。
		 * @param	child 子节点。
		 */
		public function removeChild(child:AnimationNode):void {
			var index:int = _children.indexOf(child);
			(index !== -1) && (_children.splice(index, 1));
		}
		
		/**
		 * 根据名字获取子节点。
		 * @param	name 名字。
		 */
		public function getChildByName(name:String):AnimationNode {
			for (var i:int = 0, n:int = _children.length; i < n; i++) {
				var child:AnimationNode = _children[i];
				if (child.name === name)
					return child;
			}
			return null;
		}
		
		/**
		 * 根据索引获取子节点。
		 * @param	index 索引。
		 */
		public function getChildByIndex(index:int):AnimationNode {
			return _children[index];
		}
		
		/**
		 * 获取子节点的个数。
		 */
		public function getChildCount():int {
			return _children.length;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destNode:AnimationNode = destObject as AnimationNode;
			destNode.name = name;
			for (var i:int = 0, n:int = _children.length; i < n; i++) {
				var child:AnimationNode = _children[i];
				var destChild:AnimationNode = child.clone();
				destNode.addChild(destChild);
				var transform:AnimationTransform3D = child.transform;
				var destTransform:AnimationTransform3D = destChild.transform;
				
				var destLocalPosition:Vector3 = destTransform.localPosition;
				var destLocalRotation:Quaternion = destTransform.localRotation;
				var destLocalScale:Vector3 = destTransform.localScale;
				
				transform.localPosition.cloneTo(destLocalPosition);
				transform.localRotation.cloneTo(destLocalRotation);
				transform.localScale.cloneTo(destLocalScale);
				
				destTransform.localPosition = destLocalPosition;//深拷贝
				destTransform.localRotation = destLocalRotation;//深拷贝
				destTransform.localScale = destLocalScale;//深拷贝
			}
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:AnimationNode = new AnimationNode();
			cloneTo(dest);
			return dest;
		}
		
		/**
		 * @private [NATIVE]
		 */
		public function _cloneNative(localPositions:Float32Array, localRotations:Float32Array, localScales:Float32Array, animationNodeWorldMatrixs:Float32Array, animationNodeParentIndices:Int16Array, parentIndex:int, avatar:Avatar):* {
			var curID:int = avatar._nativeCurCloneCount;
			animationNodeParentIndices[curID] = parentIndex;
			var localPosition:Float32Array = new Float32Array(localPositions.buffer, curID * 3 * 4, 3);
			var localRotation:Float32Array = new Float32Array(localRotations.buffer, curID * 4 * 4, 4);
			var localScale:Float32Array = new Float32Array(localScales.buffer, curID * 3 * 4, 3);
			var worldMatrix:Float32Array = new Float32Array(animationNodeWorldMatrixs.buffer, curID * 16 * 4, 16);
			var dest:AnimationNode = new AnimationNode(localPosition, localRotation, localScale, worldMatrix);
			dest._worldMatrixIndex = curID;
			_cloneToNative(dest, localPositions, localRotations, localScales, animationNodeWorldMatrixs, animationNodeParentIndices, curID, avatar);
			return dest;
		}
		
		/**
		 * @private [NATIVE]
		 */
		public function _cloneToNative(destObject:*, localPositions:Float32Array, localRotations:Float32Array, localScales:Float32Array, animationNodeWorldMatrixs:Float32Array, animationNodeParentIndices:Int16Array, parentIndex:int, avatar:Avatar):void {
			var destNode:AnimationNode = destObject as AnimationNode;
			destNode.name = name;
			for (var i:int = 0, n:int = _children.length; i < n; i++) {
				var child:AnimationNode = _children[i];
				avatar._nativeCurCloneCount++;
				var destChild:AnimationNode = child._cloneNative(localPositions, localRotations, localScales, animationNodeWorldMatrixs, animationNodeParentIndices, parentIndex, avatar);
				destNode.addChild(destChild);
				var transform:AnimationTransform3D = child.transform;
				var destTransform:AnimationTransform3D = destChild.transform;
				
				var destLocalPosition:Vector3 = destTransform.localPosition;
				var destLocalRotation:Quaternion = destTransform.localRotation;
				var destLocalScale:Vector3 = destTransform.localScale;
				
				transform.localPosition.cloneTo(destLocalPosition);
				transform.localRotation.cloneTo(destLocalRotation);
				transform.localScale.cloneTo(destLocalScale);
				
				destTransform.localPosition = destLocalPosition;//深拷贝
				destTransform.localRotation = destLocalRotation;//深拷贝
				destTransform.localScale = destLocalScale;//深拷贝
			}
		}
	
	}

}