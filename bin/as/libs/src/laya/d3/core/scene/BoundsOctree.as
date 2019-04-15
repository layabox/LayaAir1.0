package laya.d3.core.scene {
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	import laya.resource.ISingletonElement;
	
	/**
	 * <code>BoundsOctree</code> 类用于创建八叉树。
	 */
	public class BoundsOctree {
		/**@private */
		private static var _tempVector30:Vector3 = new Vector3();
		
		/**@private */
		private var _initialSize:Number;
		/**@private */
		private var _rootNode:BoundsOctreeNode;
		/**@private */
		private var _motionObjects:OctreeMotionList = new OctreeMotionList();
		
		/**@private */
		public var _looseness:Number;
		/**@private */
		public var _minSize:Number;
		
		/**@private [只读]*/
		public var count:int = 0;
		
		/**
		 * 创建一个 <code>BoundsOctree</code> 实例。
		 * @param	initialWorldSize 八叉树尺寸
		 * @param	initialWorldPos 八叉树中心
		 * @param	minNodeSize  节点最小尺寸
		 * @param	loosenessVal 松散值
		 */
		public function BoundsOctree(initialWorldSize:Number, initialWorldPos:Vector3, minNodeSize:Number, looseness:Number) {
			if (minNodeSize > initialWorldSize) {
				console.warn("Minimum node size must be at least as big as the initial world size. Was: " + minNodeSize + " Adjusted to: " + initialWorldSize);
				minNodeSize = initialWorldSize;
			}
			_initialSize = initialWorldSize;
			_minSize = minNodeSize;
			_looseness = Math.min(Math.max(looseness, 1.0), 2.0);
			_rootNode = new BoundsOctreeNode(this, null, initialWorldSize, initialWorldPos);
		}
		
		/**
		 * @private
		 */
		private function _getMaxDepth(node:BoundsOctreeNode, depth:int):int {
			depth++;
			var children:Vector.<BoundsOctreeNode> = node._children;
			if (children != null) {
				var curDepth:int = depth;
				for (var i:int = 0, n:int = children.length; i < n; i++) {
					var child:BoundsOctreeNode = children[i];
					child && (depth = Math.max(_getMaxDepth(child, curDepth), depth));
				}
			}
			return depth;
		}
		
		/**
		 * @private
		 */
		public function _grow(growObjectCenter:Vector3):void {
			var xDirection:int = growObjectCenter.x >= 0 ? 1 : -1;
			var yDirection:int = growObjectCenter.y >= 0 ? 1 : -1;
			var zDirection:int = growObjectCenter.z >= 0 ? 1 : -1;
			var oldRoot:BoundsOctreeNode = _rootNode;
			var half:Number = _rootNode.baseLength / 2;
			var newLength:Number = _rootNode.baseLength * 2;
			var rootCenter:Vector3 = _rootNode.center;
			var newCenter:Vector3 = new Vector3(rootCenter.x + xDirection * half, rootCenter.y + yDirection * half, rootCenter.z + zDirection * half);
			
			//创建新的八叉树根节点
			_rootNode = new BoundsOctreeNode(this, null, newLength, newCenter);
			
			if (oldRoot.hasAnyObjects()) {
				var rootPos:int = _rootNode._bestFitChild(oldRoot.center);
				var children:Vector.<BoundsOctreeNode> = new Vector.<BoundsOctreeNode>(8);
				for (var i:int = 0; i < 8; i++) {
					if (i == rootPos) {
						oldRoot._parent = _rootNode;
						children[i] = oldRoot;
					}
				}
				// Attach the new children to the new root node
				_rootNode._children = children;
			}
		}
		
		/**
		 * 添加物体
		 * @param	object
		 */
		public function add(object:IOctreeObject):void {
			var count:int = 0;
			while (!_rootNode.add(object)) {
				var growCenter:Vector3 = _tempVector30;
				Vector3.subtract(object.boundingSphere.center, _rootNode.center, growCenter);
				_grow(growCenter);
				if (++count > 20) {
					throw "Aborted Add operation as it seemed to be going on forever (" + (count - 1) + ") attempts at growing the octree.";
				}
			}
			this.count++;
		}
		
		/**
		 * 移除物体
		 * @return 是否成功
		 */
		public function remove(object:IOctreeObject):Boolean {
			var removed:Boolean = object._getOctreeNode().remove(object);
			if (removed) {
				this.count--;
			}
			return removed;
		}
		
		/**
		 * 更新物体
		 */
		public function update(object:IOctreeObject):Boolean {
			var count:int = 0;
			var octreeNode:BoundsOctreeNode = object._getOctreeNode();
			if (octreeNode) {
				while (!octreeNode._update(object)) {
					_grow(object.boundingSphere.center);
					if (++count > 20) {
						throw "Aborted Add operation as it seemed to be going on forever (" + (count - 1) + ") attempts at growing the octree.";
					}
				}
				
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * 如果可能则收缩根节点。
		 */
		public function shrinkRootIfPossible():void {
			_rootNode = _rootNode.shrinkIfPossible(_initialSize);
		}
		
		/**
		 * 添加运动物体。
		 * @param 运动物体。
		 */
		public function addMotionObject(object:IOctreeObject):void {
			_motionObjects.add(object);
		}
		
		/**
		 * 移除运动物体。
		 * @param 运动物体。
		 */
		public function removeMotionObject(object:IOctreeObject):void {
			_motionObjects.remove(object);
		}
		
		/**
		 * 更新所有运动物体。
		 */
		public function updateMotionObjects():void {
			var elements:Vector.<ISingletonElement> = _motionObjects.elements;
			for (var i:int = 0, n:int = _motionObjects.length; i < n; i++) {
				var object:IOctreeObject = elements[i] as IOctreeObject;
				update(object);
				object._setIndexInMotionList(-1);
			}
			_motionObjects.length = 0;
		}
		
		/**
		 * 获取是否与指定包围盒相交。
		 * @param checkBound AABB包围盒。
		 * @return 是否相交。
		 */
		public function isCollidingWithBoundBox(checkBounds:BoundBox):Boolean {
			return _rootNode.isCollidingWithBoundBox(checkBounds);
		}
		
		/**
		 *	获取是否与指定射线相交。
		 * 	@param	ray 射线。
		 * 	@param	maxDistance 射线的最大距离。
		 *  @return 是否相交。
		 */
		public function isCollidingWithRay(ray:Ray, maxDistance:Number = Number.MAX_VALUE):Boolean {
			return _rootNode.isCollidingWithRay(ray, maxDistance);
		}
		
		/**
		 * 获取与指定包围盒相交的物体列表。
		 * @param checkBound AABB包围盒。
		 * @param result 相交物体列表
		 */
		public function getCollidingWithBoundBox(checkBound:BoundBox, result:Array):void {
			_rootNode.getCollidingWithBoundBox(checkBound, result);
		}
		
		/**
		 *	获取与指定射线相交的的物理列表。
		 * 	@param	ray 射线。
		 * 	@param	result 相交物体列表。
		 * 	@param	maxDistance 射线的最大距离。
		 */
		public function getCollidingWithRay(ray:Ray, result:Array, maxDistance:Number = Number.MAX_VALUE):void {
			_rootNode.getCollidingWithRay(ray, result, maxDistance);
		}
		
		/**
		 *	获取与指定视锥相交的的物理列表。
		 *  @param 渲染上下文。
		 */
		public function getCollidingWithFrustum(context:RenderContext3D):void {
			_rootNode.getCollidingWithFrustum(context);
		}
		
		/**
		 * 获取最大包围盒
		 * @return 最大包围盒
		 */
		public function getMaxBounds():BoundBox {
			return _rootNode.getBound();
		}
		
		/**
		 * @private
		 * [Debug]
		 */
		public function drawAllBounds(pixelLine:PixelLineSprite3D):void {
			var maxDepth:int = _getMaxDepth(_rootNode, -1);
			_rootNode.drawAllBounds(pixelLine, -1, maxDepth);
		}
		
		/**
		 * @private
		 * [Debug]
		 */
		public function drawAllObjects(pixelLine:PixelLineSprite3D):void {
			var maxDepth:int = _getMaxDepth(_rootNode, -1);
			_rootNode.drawAllObjects(pixelLine, -1, maxDepth);
		}
	
	}

}