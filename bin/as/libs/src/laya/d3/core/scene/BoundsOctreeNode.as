package laya.d3.core.scene {
	import laya.d3.core.Camera;
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.CollisionUtils;
	import laya.d3.math.Color;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Ray;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.utils.Stat;
	
	/**
	 * <code>BoundsOctreeNode</code> 类用于创建八叉树节点。
	 */
	public class BoundsOctreeNode {
		/**@private */
		private static var _tempVector30:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector31:Vector3 = new Vector3();
		/**@private */
		private static var _tempColor0:Color = new Color();
		/**@private */
		private static var _tempBoundBox:BoundBox = new BoundBox(new Vector3(), new Vector3());
		
		/**@private */
		private static const _NUM_OBJECTS_ALLOWED:int = 8;
		
		/**
		 * @private
		 */
		private static function _encapsulates(outerBound:BoundBox, innerBound:BoundBox):Boolean {
			return CollisionUtils.boxContainsBox(outerBound, innerBound) == ContainmentType.Contains;
		}
		
		/**@private */
		public var _octree:BoundsOctree;
		/**@private */
		public var _parent:BoundsOctreeNode;
		/**@private AABB包围盒*/
		private var _bounds:BoundBox = new BoundBox(new Vector3(), new Vector3());
		/**@private */
		private var _objects:Vector.<IOctreeObject> = new Vector.<IOctreeObject>();
		
		/**@private */
		public var _children:Vector.<BoundsOctreeNode>;
		/**@private [Debug]*/
		public var _isContaion:Boolean = false;
		
		/**@private	[只读]*/
		public var center:Vector3 = new Vector3();
		/**@private	[只读]*/
		public var baseLength:Number = 0.0;
		
		/**
		 * 创建一个 <code>BoundsOctreeNode</code> 实例。
		 * @param octree  所属八叉树。
		 * @param parent  父节点。
		 * @param baseLength  节点基本长度。
		 * @param center  节点的中心位置。
		 */
		public function BoundsOctreeNode(octree:BoundsOctree, parent:BoundsOctreeNode, baseLength:Number, center:Vector3) {
			_setValues(octree, parent, baseLength, center);
		}
		
		/**
		 * @private
		 */
		private function _setValues(octree:BoundsOctree, parent:BoundsOctreeNode, baseLength:Number, center:Vector3):void {
			_octree = octree;
			_parent = parent;
			this.baseLength = baseLength;
			center.cloneTo(this.center);//避免引用错乱
			var min:Vector3 = _bounds.min;
			var max:Vector3 = _bounds.max;
			var halfSize:Number = (octree._looseness * baseLength) / 2;
			min.setValue(center.x - halfSize, center.y - halfSize, center.z - halfSize);
			max.setValue(center.x + halfSize, center.y + halfSize, center.z + halfSize);
		}
		
		/**
		 * @private
		 */
		private function _getChildBound(index:int):BoundBox {
			if (_children != null && _children[index]) {
				return _children[index]._bounds;
			} else {
				var quarter:Number = baseLength / 4;
				var halfChildSize:Number = ((baseLength / 2) * _octree._looseness) / 2;
				var bounds:BoundBox = _tempBoundBox;
				var min:Vector3 = bounds.min;
				var max:Vector3 = bounds.max;
				switch (index) {
				case 0: 
					min.x = center.x - quarter - halfChildSize;
					min.y = center.y + quarter - halfChildSize;
					min.z = center.z - quarter - halfChildSize;
					max.x = center.x - quarter + halfChildSize;
					max.y = center.y + quarter + halfChildSize;
					max.z = center.z - quarter + halfChildSize;
					break;
				case 1: 
					min.x = center.x + quarter - halfChildSize;
					min.y = center.y + quarter - halfChildSize;
					min.z = center.z - quarter - halfChildSize;
					max.x = center.x + quarter + halfChildSize;
					max.y = center.y + quarter + halfChildSize;
					max.z = center.z - quarter + halfChildSize;
					break;
				case 2: 
					min.x = center.x - quarter - halfChildSize;
					min.y = center.y + quarter - halfChildSize;
					min.z = center.z + quarter - halfChildSize;
					max.x = center.x - quarter + halfChildSize;
					max.y = center.y + quarter + halfChildSize;
					max.z = center.z + quarter + halfChildSize;
					break;
				case 3: 
					min.x = center.x + quarter - halfChildSize;
					min.y = center.y + quarter - halfChildSize;
					min.z = center.z + quarter - halfChildSize;
					max.x = center.x + quarter + halfChildSize;
					max.y = center.y + quarter + halfChildSize;
					max.z = center.z + quarter + halfChildSize;
					break;
				case 4: 
					min.x = center.x - quarter - halfChildSize;
					min.y = center.y - quarter - halfChildSize;
					min.z = center.z - quarter - halfChildSize;
					max.x = center.x - quarter + halfChildSize;
					max.y = center.y - quarter + halfChildSize;
					max.z = center.z - quarter + halfChildSize;
					break;
				case 5: 
					min.x = center.x + quarter - halfChildSize;
					min.y = center.y - quarter - halfChildSize;
					min.z = center.z - quarter - halfChildSize;
					max.x = center.x + quarter + halfChildSize;
					max.y = center.y - quarter + halfChildSize;
					max.z = center.z - quarter + halfChildSize;
					break;
				case 6: 
					min.x = center.x - quarter - halfChildSize;
					min.y = center.y - quarter - halfChildSize;
					min.z = center.z + quarter - halfChildSize;
					max.x = center.x - quarter + halfChildSize;
					max.y = center.y - quarter + halfChildSize;
					max.z = center.z + quarter + halfChildSize;
					break;
				case 7: 
					min.x = center.x + quarter - halfChildSize;
					min.y = center.y - quarter - halfChildSize;
					min.z = center.z + quarter - halfChildSize;
					max.x = center.x + quarter + halfChildSize;
					max.y = center.y - quarter + halfChildSize;
					max.z = center.z + quarter + halfChildSize;
					break;
				default: 
				}
				return bounds;
			}
		}
		
		/**
		 * @private
		 */
		private function _getChildCenter(index:int):Vector3 {
			if (_children != null) {
				return _children[index].center;
			} else {
				var quarter:Number = baseLength / 4;
				var childCenter:Vector3 = _tempVector30;
				switch (index) {
				case 0: 
					childCenter.x = center.x - quarter;
					childCenter.y = center.y + quarter;
					childCenter.z = center.z - quarter;
					break;
				case 1: 
					childCenter.x = center.x + quarter;
					childCenter.y = center.y + quarter;
					childCenter.z = center.z - quarter;
					break;
				case 2: 
					childCenter.x = center.x - quarter;
					childCenter.y = center.y + quarter;
					childCenter.z = center.z + quarter;
					break;
				case 3: 
					childCenter.x = center.x + quarter;
					childCenter.y = center.y + quarter;
					childCenter.z = center.z + quarter;
					break;
				case 4: 
					childCenter.x = center.x - quarter;
					childCenter.y = center.y - quarter;
					childCenter.z = center.z - quarter;
					break;
				case 5: 
					childCenter.x = center.x + quarter;
					childCenter.y = center.y - quarter;
					childCenter.z = center.z - quarter;
					break;
				case 6: 
					childCenter.x = center.x - quarter;
					childCenter.y = center.y - quarter;
					childCenter.z = center.z + quarter;
					break;
				case 7: 
					childCenter.x = center.x + quarter;
					childCenter.y = center.y - quarter;
					childCenter.z = center.z + quarter;
					break;
				default: 
				}
				return childCenter;
			}
		}
		
		/**
		 * @private
		 */
		private function _getChild(index:int):BoundsOctreeNode {
			var quarter:Number = baseLength / 4;
			_children || (_children = new Vector.<BoundsOctreeNode>(8));
			switch (index) {
			case 0: 
				return _children[0] || (_children[0] = new BoundsOctreeNode(_octree, this, baseLength / 2, new Vector3(center.x + -quarter, center.y + quarter, center.z - quarter)));
			case 1: 
				return _children[1] || (_children[1] = new BoundsOctreeNode(_octree, this, baseLength / 2, new Vector3(center.x + quarter, center.y + quarter, center.z - quarter)));
			case 2: 
				return _children[2] || (_children[2] = new BoundsOctreeNode(_octree, this, baseLength / 2, new Vector3(center.x - quarter, center.y + quarter, center.z + quarter)));
			case 3: 
				return _children[3] || (_children[3] = new BoundsOctreeNode(_octree, this, baseLength / 2, new Vector3(center.x + quarter, center.y + quarter, center.z + quarter)));
			case 4: 
				return _children[4] || (_children[4] = new BoundsOctreeNode(_octree, this, baseLength / 2, new Vector3(center.x - quarter, center.y - quarter, center.z - quarter)));
			case 5: 
				return _children[5] || (_children[5] = new BoundsOctreeNode(_octree, this, baseLength / 2, new Vector3(center.x + quarter, center.y - quarter, center.z - quarter)));
			case 6: 
				return _children[6] || (_children[6] = new BoundsOctreeNode(_octree, this, baseLength / 2, new Vector3(center.x - quarter, center.y - quarter, center.z + quarter)));
			case 7: 
				return _children[7] || (_children[7] = new BoundsOctreeNode(_octree, this, baseLength / 2, new Vector3(center.x + quarter, center.y - quarter, center.z + quarter)));
			default: 
				throw "BoundsOctreeNode: unknown index.";
			}
		}
		
		/**
		 * @private
		 * 是否合并判断(如果该节点和子节点包含的物体小于_NUM_OBJECTS_ALLOWED则应将子节点合并到该节点)
		 */
		private function _shouldMerge():Boolean {//无子节点不能调用该函数
			var objectCount:int = _objects.length;
			for (var i:int = 0; i < 8; i++) {
				var child:BoundsOctreeNode = _children[i];
				if (child) {
					if (child._children != null) //有孙子节点不合并
						return false;
					objectCount += child._objects.length;
				}
			}
			return objectCount <= _NUM_OBJECTS_ALLOWED;
		}
		
		/**
		 * @private
		 */
		private function _mergeChildren():void {
			for (var i:int = 0; i < 8; i++) {
				var child:BoundsOctreeNode = _children[i];
				if (child) {
					child._parent = null;
					var childObjects:Vector.<IOctreeObject> = child._objects;
					for (var j:int = childObjects.length - 1; j >= 0; j--) {
						var childObject:IOctreeObject = childObjects[j];
						_objects.push(childObject);
						childObject._setOctreeNode(this);
					}
				}
			}
			
			_children = null;
		}
		
		/**
		 * @private
		 */
		private function _merge():void {
			if (_children === null) {
				var parent:BoundsOctreeNode = _parent;
				if (parent && parent._shouldMerge()) {
					parent._mergeChildren();
					parent._merge();
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _checkAddNode(object:IOctreeObject):BoundsOctreeNode {
			//始终将物体放入可能的最深层子节点，如果有子节点可以跳过检查
			if (_children == null) {
				//如果该节点当前为末级节点,包含物体小于_NUM_OBJECTS_ALLOWED数量或不能再创建子节点,则存入该节点
				if (_objects.length < _NUM_OBJECTS_ALLOWED || (baseLength / 2) < _octree._minSize) {
					return this;
				}
				
				for (var i:int = _objects.length - 1; i >= 0; i--) {//已有新子节点,检查已经存在的物体是否更适合子节点
					var existObject:IOctreeObject = _objects[i];
					var fitChildIndex:int = _bestFitChild(existObject.boundingSphere.center);
					if (_encapsulates(_getChildBound(fitChildIndex), existObject.boundingBox)) {
						_objects.splice(_objects.indexOf(existObject), 1);//当前节点移除
						_getChild(fitChildIndex)._add(existObject);//加入更深层节点
					}
				}
			}
			
			var newFitChildIndex:int = _bestFitChild(object.boundingSphere.center);
			if (_encapsulates(_getChildBound(newFitChildIndex), object.boundingBox))
				return _getChild(newFitChildIndex)._checkAddNode(object);
			else
				return this;
		}
		
		/**
		 * @private
		 */
		private function _add(object:IOctreeObject):void {
			var addNode:BoundsOctreeNode = _checkAddNode(object);
			addNode._objects.push(object);
			object._setOctreeNode(addNode);
		}
		
		/**
		 * @private
		 */
		private function _remove(object:IOctreeObject):void {
			var index:int = _objects.indexOf(object);
			_objects.splice(index, 1);
			object._setOctreeNode(null);
			_merge();
		}
		
		/**
		 * @private
		 */
		private function _addUp(object:IOctreeObject):Boolean {
			if ((CollisionUtils.boxContainsBox(_bounds, object.boundingBox) === ContainmentType.Contains)) {
				_add(object);
				return true;
			} else {
				if (_parent)
					return _parent._addUp(object);
				else
					return false;
			}
		}
		
		/**
		 * @private
		 */
		private function _getCollidingWithFrustum(context:RenderContext3D, frustum:BoundFrustum, testVisible:Boolean, camPos:Vector3):void {
			//if (_children === null && _objects.length == 0) {//无用末级节不需要检查，调试用
				//debugger;
				//return;
			//}
			
			if (testVisible) {
				var type:int = frustum.containsBoundBox(_bounds);
				Stat.octreeNodeCulling++;
				if (type === ContainmentType.Disjoint)
					return;
				testVisible = (type === ContainmentType.Intersects);
			}
			_isContaion = !testVisible;//[Debug] 用于调试信息,末级无用子节点不渲染、脱节节点看不见,所以无需更新变量
			
			//检查节点中的对象
			var camera:Camera = context.camera as Camera;
			var scene:Scene3D = context.scene;
			for (var i:int = 0, n:int = _objects.length; i < n; i++) {
				var render:BaseRender = _objects[i] as BaseRender;
				if (camera._isLayerVisible(render._owner.layer) && render._enable) {
					if (testVisible) {
						Stat.frustumCulling++;
						if (!render._needRender(frustum))
							continue;
					}
					
					render._distanceForSort = Vector3.distance(render.boundingSphere.center, camPos);//TODO:合并计算浪费,或者合并后取平均值
					var elements:Vector.<RenderElement> = render._renderElements;
					for (var j:int = 0, m:int = elements.length; j < m; j++) {
						var element:RenderElement = elements[j];
						var renderQueue:RenderQueue = scene._getRenderQueue(element.material.renderQueue);
						if (renderQueue.isTransparent)
							element.addToTransparentRenderQueue(context, renderQueue);
						else
							element.addToOpaqueRenderQueue(context, renderQueue);
					}
				}
			}
			
			//检查子节点
			if (_children != null) {
				for (i = 0; i < 8; i++) {
					var child:BoundsOctreeNode = _children[i];
					child && child._getCollidingWithFrustum(context, frustum, testVisible, camPos);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _getCollidingWithBoundBox(checkBound:BoundBox, testVisible:Boolean, result:Array):void {
			//if (_children === null && _objects.length == 0){//无用末级节不需要检查，调试用
			//debugger;
			//return;
			//}
			
			//检查checkBound是否部分在_bounds中
			if (testVisible) {
				var type:int = CollisionUtils.boxContainsBox(_bounds, checkBound);
				if (type === ContainmentType.Disjoint)
					return;
				testVisible = (type === ContainmentType.Intersects);
			}
			
			//检查节点中的对象
			if (testVisible) {
				for (var i:int = 0, n:int = _objects.length; i < n; i++) {
					var object:IOctreeObject = _objects[i];
					if (CollisionUtils.intersectsBoxAndBox(object.boundingBox, checkBound)) {
						result.push(object);
					}
				}
			}
			
			//检查子节点
			if (_children != null) {
				for (i = 0; i < 8; i++) {
					var child:BoundsOctreeNode = _children[i];
					child._getCollidingWithBoundBox(checkBound, testVisible, result);
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _bestFitChild(boundCenter:Vector3):int {
			return (boundCenter.x <= center.x ? 0 : 1) + (boundCenter.y >= center.y ? 0 : 4) + (boundCenter.z <= center.z ? 0 : 2);
		}
		
		/**
		 * @private
		 * @return 是否需要扩充根节点
		 */
		public function _update(object:IOctreeObject):Boolean {
			if (CollisionUtils.boxContainsBox(_bounds, object.boundingBox) === ContainmentType.Contains) {//addDown
				var addNode:BoundsOctreeNode = _checkAddNode(object);
				if (addNode !== object._getOctreeNode()) {
					addNode._objects.push(object);
					object._setOctreeNode(addNode);
					var index:int = _objects.indexOf(object);
					_objects.splice(index, 1);
					_merge();
				}
				return true;
			} else {//addUp
				if (_parent) {
					var sucess:Boolean = _parent._addUp(object);
					if (sucess) {//移除成功后才缩减节点,并且在最后移除否则可能造成节点层断裂
						index = _objects.indexOf(object);
						_objects.splice(index, 1);
						_merge();
					}
					return sucess;
				} else {
					return false;
				}
			}
		}
		
		/**
		 * 添加指定物体。
		 * @param	object 指定物体。
		 */
		public function add(object:IOctreeObject):Boolean {
			if (!_encapsulates(_bounds, object.boundingBox)) //如果不包含,直接return false
				return false;
			_add(object);
			return true;
		}
		
		/**
		 * 移除指定物体。
		 * @param	obejct 指定物体。
		 * @return 是否成功。
		 */
		public function remove(object:IOctreeObject):Boolean {
			if (object._getOctreeNode() !== this)
				return false;
			_remove(object);
			return true;
		}
		
		/**
		 * 更新制定物体，
		 * @param	obejct 指定物体。
		 * @return 是否成功。
		 */
		public function update(object:IOctreeObject):Boolean {
			if (object._getOctreeNode() !== this)
				return false;
			return _update(object);
		}
		
		/**
		 * 	收缩八叉树节点。
		 *	-所有物体都在根节点的八分之一区域
		 * 	-该节点无子节点或有子节点但1/8的子节点不包含物体
		 *	@param minLength 最小尺寸。
		 * 	@return 新的根节点。
		 */
		public function shrinkIfPossible(minLength:int):BoundsOctreeNode {
			if (baseLength < minLength * 2)//该节点尺寸大于等于minLength*2才收缩
				return this;
			
			//检查根节点的物体
			var bestFit:int = -1;
			for (var i:int = 0, n:int = _objects.length; i < n; i++) {
				var object:IOctreeObject = _objects[i];
				var newBestFit:int = _bestFitChild(object.boundingSphere.center);
				if (i == 0 || newBestFit == bestFit) {//判断所有的物理是否在同一个子节点中
					var childBounds:BoundBox = _getChildBound(newBestFit);
					if (_encapsulates(childBounds, object.boundingBox))
						(i == 0) && (bestFit = newBestFit);
					else //不能缩减,适合位置的子节点不能全包
						return this;
				} else {//不在同一个子节点不能缩减
					return this;
				}
			}
			
			// 检查子节点的物体是否在同一缩减区域
			if (_children != null) {
				var childHadContent:Boolean = false;
				for (i = 0, n = _children.length; i < n; i++) {
					var child:BoundsOctreeNode = _children[i];
					if (child && child.hasAnyObjects()) {
						if (childHadContent)
							return this; // 大于等于两个子节点有物体,不能缩减
						
						if (bestFit >= 0 && bestFit != i)
							return this; //包含物体的子节点并非最佳索引,不能缩减
						childHadContent = true;
						bestFit = i;
					}
				}
			} else {
				if (bestFit != -1) {//无子节点,直接缩减本节点
					var childCenter:Vector3 = _getChildCenter(bestFit);
					_setValues(_octree, null, baseLength / 2, childCenter);
				}
				return this;
			}
			
			if (bestFit != -1) {
				var newRoot:BoundsOctreeNode = _children[bestFit];//用合适的子节点作为新的根节点,bestFit!=-1,_children[bestFit]一定有值
				newRoot._parent = null;//根节点需要置空父节点
				return newRoot;
			} else {// 整个节点包括子节点没有物体
				return this;
			}
		}
		
		/**
		 * 检查该节点和其子节点是否包含任意物体。
		 * @return 是否包含任意物体。
		 */
		public function hasAnyObjects():Boolean {
			if (_objects.length > 0)
				return true;
			
			if (_children != null) {
				for (var i:int = 0; i < 8; i++) {
					var child:BoundsOctreeNode = _children[i];
					if (child && child.hasAnyObjects())
						return true;
				}
			}
			return false;
		}
		
		/**
		 * 获取与指定包围盒相交的物体列表。
		 * @param checkBound AABB包围盒。
		 * @param result 相交物体列表
		 */
		public function getCollidingWithBoundBox(checkBound:BoundBox, result:Array):void {
			_getCollidingWithBoundBox(checkBound, true, result);
		}
		
		/**
		 *	获取与指定射线相交的的物理列表。
		 * 	@param	ray 射线。
		 * 	@param	result 相交物体列表。
		 * 	@param	maxDistance 射线的最大距离。
		 */
		public function getCollidingWithRay(ray:Ray, result:Array, maxDistance:Number = Number.MAX_VALUE):void {
			var distance:Number = CollisionUtils.intersectsRayAndBoxRD(ray, _bounds);
			if (distance == -1 || distance > maxDistance)
				return;
			
			//检查节点中的对象
			for (var i:int = 0, n:int = _objects.length; i < n; i++) {
				var object:IOctreeObject = _objects[i];
				distance = CollisionUtils.intersectsRayAndBoxRD(ray, object.boundingBox);
				if (distance !== -1 && distance <= maxDistance)
					result.push(object);
			}
			
			//检查子节点
			if (_children != null) {
				for (i = 0; i < 8; i++) {
					var child:BoundsOctreeNode = _children[i];
					child.getCollidingWithRay(ray, result, maxDistance);
				}
			}
		}
		
		/**
		 *	获取与指定视锥相交的的物理列表。
		 * 	@param	ray 射线。.
		 * 	@param	result 相交物体列表。
		 */
		public function getCollidingWithFrustum(context:RenderContext3D):void {
			var cameraPos:Vector3 = context.camera.transform.position;
			var boundFrustum:BoundFrustum = (context.camera as Camera).boundFrustum;
			_getCollidingWithFrustum(context, boundFrustum, true, cameraPos);
		}
		
		/**
		 * 获取是否与指定包围盒相交。
		 * @param checkBound AABB包围盒。
		 * @return 是否相交。
		 */
		public function isCollidingWithBoundBox(checkBound:BoundBox):Boolean {
			//检查checkBound是否部分在_bounds中
			if (!(CollisionUtils.intersectsBoxAndBox(_bounds, checkBound)))
				return false;
			
			//检查节点中的对象
			for (var i:int = 0, n:int = _objects.length; i < n; i++) {
				var object:IOctreeObject = _objects[i];
				if (CollisionUtils.intersectsBoxAndBox(object.boundingBox, checkBound))
					return true;
			}
			
			//检查子节点
			if (_children != null) {
				for (i = 0; i < 8; i++) {
					var child:BoundsOctreeNode = _children[i];
					if (child.isCollidingWithBoundBox(checkBound))
						return true;
				}
			}
			return false;
		}
		
		/**
		 *	获取是否与指定射线相交。
		 * 	@param	ray 射线。
		 * 	@param	maxDistance 射线的最大距离。
		 *  @return 是否相交。
		 */
		public function isCollidingWithRay(ray:Ray, maxDistance:Number = Number.MAX_VALUE):Boolean {
			var distance:Number = CollisionUtils.intersectsRayAndBoxRD(ray, _bounds);
			if (distance == -1 || distance > maxDistance)
				return false;
			
			//检查节点中的对象
			for (var i:int = 0, n:int = _objects.length; i < n; i++) {
				var object:IOctreeObject = _objects[i];
				distance = CollisionUtils.intersectsRayAndBoxRD(ray, object.boundingBox);
				if (distance !== -1 && distance <= maxDistance)
					return true;
			}
			
			//检查子节点
			if (_children != null) {
				for (i = 0; i < 8; i++) {
					var child:BoundsOctreeNode = _children[i];
					if (child.isCollidingWithRay(ray, maxDistance))
						return true;
				}
			}
			return false;
		}
		
		/**
		 * 获取包围盒。
		 */
		public function getBound():BoundBox {
			return _bounds;
		}
		
		/**
		 * @private
		 * [Debug]
		 */
		public function drawAllBounds(debugLine:PixelLineSprite3D, currentDepth:int, maxDepth:int):void {
			if (_children === null && _objects.length == 0)//无用末级节不需要渲染
				return;
			
			currentDepth++;
			var color:Color = _tempColor0;
			if (_isContaion) {
				color.r = 0.0;
				color.g = 0.0;
				color.b = 1.0;
			} else {
				var tint:Number = maxDepth ? currentDepth / maxDepth : 0;
				color.r = 1.0 - tint;
				color.g = tint;
				color.b = 0.0;
			}
			color.a = 0.3;
			Utils3D._drawBound(debugLine, _bounds, color);
			if (_children != null) {
				for (var i:int = 0; i < 8; i++) {
					var child:BoundsOctreeNode = _children[i];
					child && child.drawAllBounds(debugLine, currentDepth, maxDepth);
				}
			}
		}
		
		/**
		 * @private
		 * [Debug]
		 */
		public function drawAllObjects(debugLine:PixelLineSprite3D, currentDepth:int, maxDepth:int):void {
			currentDepth++;
			
			var color:Color = _tempColor0;
			if (_isContaion) {
				color.r = 0.0;
				color.g = 0.0;
				color.b = 1.0;
			} else {
				var tint:Number = maxDepth ? currentDepth / maxDepth : 0;
				color.r = 1.0 - tint;
				color.g = tint;
				color.b = 0.0;
			}
			color.a = 1.0;
			
			for (var i:int = 0, n:int = _objects.length; i < n; i++)
				Utils3D._drawBound(debugLine, _objects[i].boundingBox, color);
			
			if (_children != null) {
				for (i = 0; i < 8; i++) {
					var child:BoundsOctreeNode = _children[i];
					child && child.drawAllObjects(debugLine, currentDepth, maxDepth);
				}
			}
		}
	
	}

}