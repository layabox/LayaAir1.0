package laya.d3.core.scene {
	import laya.d3.core.Camera;
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.CollisionUtils;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	
	/**
	 * 类用于八叉树节点。
	 */
	public class OctreeNode {
		/**@private */
		private static var _tempVector0:Vector3 = new Vector3();
		/**@private */
		private static var _tempSize:Vector3 = new Vector3();
		/**@private */
		private static var _tempCenter:Vector3 = new Vector3();
		
		/**@private */
		private static var _octreeSplit:Array = [new Vector3(0.250, 0.250, 0.250), new Vector3(0.750, 0.250, 0.250), new Vector3(0.250, 0.750, 0.250), new Vector3(0.750, 0.750, 0.250), new Vector3(0.250, 0.250, 0.750), new Vector3(0.750, 0.250, 0.750), new Vector3(0.250, 0.750, 0.750), new Vector3(0.750, 0.750, 0.750)];
		
		/**@private */
		private static const CHILDNUM:int = 8;
		
		/**是否开启四/八叉树调试模式。 */
		public static var debugMode:Boolean = false;
		/**@private */
		private static var relax:Number = 1.15;
		
		/**@private */
		private var _exactBox:BoundBox = null;
		/**@private */
		private var _relaxBox:BoundBox = null;
		/**@private */
		private var _boundingSphere:BoundSphere = new BoundSphere(new Vector3(), 0);
		/**@private */
		private var _corners:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		/**@private */
		private var _boundingBoxCenter:Vector3 = new Vector3();
		/**@private */
		private var _scene:Scene3D = null;
		/**@private */
		private var _parent:OctreeNode = null;
		/**@private */
		public var _children:Vector.<OctreeNode> = new Vector.<OctreeNode>(CHILDNUM);
		/**@private */
		private var _objects:Vector.<BaseRender> = new Vector.<BaseRender>();
		/**@private */
		private var _depth:int = 0;
		
		/**
		 * @private
		 */
		public function get exactBox():BoundBox {
			return _exactBox;
		}
		
		/**
		 * @private
		 */
		public function set exactBox(value:BoundBox):void {
			_exactBox = value;
			Vector3.add(value.min, value.max, _boundingBoxCenter);
			Vector3.scale(_boundingBoxCenter, 0.5, _boundingBoxCenter);
		}
		
		/**
		 * @private
		 */
		public function set relaxBox(value:BoundBox):void {
			_relaxBox = value;
			value.getCorners(_corners);
			BoundSphere.createfromPoints(_corners, _boundingSphere);
		}
		
		/**
		 * @private
		 */
		public function get relaxBox():BoundBox {
			return _relaxBox;
		}
		
		/**
		 * @private
		 */
		public function OctreeNode(scene:Scene3D, depth:int) {
			_scene = scene;
			_depth = depth;
		}
		
		/**
		 * @private
		 */
		public function initRoot(center:Vector3, treeSize:Vector3):void {
			var min:Vector3 = new Vector3();
			var max:Vector3 = new Vector3();
			Vector3.scale(treeSize, -0.5, min);
			Vector3.scale(treeSize, 0.5, max);
			Vector3.add(min, center, min);
			Vector3.add(max, center, max);
			exactBox = new BoundBox(min, max);
			relaxBox = new BoundBox(min, max);
		}
		
		/**
		 * @private
		 */
		public function addTreeNode(render:BaseRender):void {
			if (CollisionUtils.boxContainsBox(_relaxBox, render.boundingBox) === ContainmentType.Contains)
				addNodeDown(render, 0);
			else
				addObject(render);
		}
		
		/**
		 * @private
		 */
		public function addChild(index:int):OctreeNode {
			var child:OctreeNode = _children[index];
			if (child == null) {
				child = new OctreeNode(_scene, _depth + 1);
				_children[index] = child;
				child._parent = this;
				
				Vector3.subtract(_exactBox.max, _exactBox.min, _tempSize);
				Vector3.multiply(_tempSize, _octreeSplit[index], _tempCenter);
				Vector3.add(_exactBox.min, _tempCenter, _tempCenter);
				//size * 0.25
				Vector3.scale(_tempSize, 0.25, _tempSize);
				//计算最小点和最大点
				var min:Vector3 = new Vector3();
				var max:Vector3 = new Vector3();
				Vector3.subtract(_tempCenter, _tempSize, min);
				Vector3.add(_tempCenter, _tempSize, max);
				//构造包围盒
				child.exactBox = new BoundBox(min, max);
				
				//relax包围盒
				Vector3.scale(_tempSize, relax, _tempSize);
				var relaxMin:Vector3 = new Vector3();
				var relaxMax:Vector3 = new Vector3();
				Vector3.subtract(_tempCenter, _tempSize, relaxMin);
				Vector3.add(_tempCenter, _tempSize, relaxMax);
				child.relaxBox = new BoundBox(relaxMin, relaxMax);
			}
			return child;
		}
		
		/**
		 * @private
		 */
		public function addObject(object:BaseRender):void {
			object._treeNode = this;
			_objects.push(object);
		}
		
		/**
		 * @private
		 */
		public function removeObject(object:BaseRender):Boolean {
			if (object._treeNode != this) {
				trace("OctreeNode::removeObject error");
				return false;
			}
			var index:int = _objects.indexOf(object);
			if (index !== -1) {
				_objects.splice(index, 1);
				return true;
			}
			return false;
		}
		
		/**
		 * @private
		 */
		public function clearObject():void {
			_objects.length = 0;
		}
		
		/**
		 * @private
		 */
		public function addNodeUp(render:BaseRender, depth:int):void {
			if (_parent && (CollisionUtils.boxContainsBox(_exactBox, render.boundingBox) !== ContainmentType.Contains)) {
				_parent.addNodeUp(render, depth - 1);
			} else
				addNodeDown(render, depth);
		}
		
		/**
		 * @private
		 */
		public function addNodeDown(render:BaseRender, depth:int):void {
			if (depth < _scene.treeLevel) {
				var childIndex:int = inChildIndex(render.boundingBoxCenter);
				var child:OctreeNode = addChild(childIndex);
				
				if (CollisionUtils.boxContainsBox(child._relaxBox, render.boundingBox) === ContainmentType.Contains) {
					child.addNodeDown(render, ++depth);
				} else
					addObject(render);
			} else {
				addObject(render);
			}
		}
		
		/**
		 * @private
		 */
		public function inChildIndex(objectCenter:Vector3):int {
			var z:int = objectCenter.z < _boundingBoxCenter.z ? 0 : 1;
			var y:int = objectCenter.y < _boundingBoxCenter.y ? 0 : 1;
			var x:int = objectCenter.x < _boundingBoxCenter.x ? 0 : 1;
			return z * 4 + y * 2 + x;
		}
		
			/**
			 * @private
		 */
		public function updateObject(render:BaseRender):void {
			//TODO 优化，效率不高
			if (CollisionUtils.boxContainsBox(_relaxBox, render.boundingBox) === ContainmentType.Contains) {
				removeObject(render);
				render._treeNode = null;
				addNodeDown(render, _depth);
			} else if (_parent) {
				removeObject(render);
				render._treeNode = null;
				_parent.addNodeUp(render, _depth - 1);
			}
		}
		
		/**
		 * @private
		 */
		public function cullingObjects(context:RenderContext3D, boundFrustum:BoundFrustum, camera:Camera, cameraPos:Vector3, testVisible:Boolean):void {
			var i:int, j:int, n:int, m:int;
			for (i = 0, n = _objects.length; i < n; i++) {
				var render:BaseRender = _objects[i];
				if (_scene.isLayerVisible(render._owner.layer, camera) && render._enable) {
					if (testVisible) {
						//Stat.treeSpriteCollision += 1;
						if (boundFrustum.containsBoundBox(render.boundingBox) === ContainmentType.Disjoint)
							continue;
					}
					render._distanceForSort = Vector3.distance(render.boundingSphere.center, cameraPos);//TODO:合并计算浪费,或者合并后取平均值
					
					var elements:Vector.<RenderElement> = render._renderElements;
					for (j = 0, m = elements.length; j < m; j++) {
						var element:RenderElement = elements[j];
						var renderQueue:RenderQueue = _scene._getRenderQueue(element.material.renderQueue);
						if (renderQueue.isTransparent)
							element.addToTransparentRenderQueue(context, renderQueue);
						else
							element.addToOpaqueRenderQueue(context, renderQueue);
					}
				}
				
			}
			for (i = 0; i < CHILDNUM; i++) {
				var child:OctreeNode = _children[i];
				var testVisibleChild:Boolean = testVisible;
				if (testVisible) {
					var type:int = boundFrustum.containsBoundBox(child._relaxBox);
					//Stat.treeNodeCollision += 1;
					if (type === ContainmentType.Disjoint)
						continue;
					testVisibleChild = (type === ContainmentType.Intersects);
				}
				child.cullingObjects(context, boundFrustum, camera, cameraPos, testVisibleChild);
			}
		}
		
		/**
		 * @private
		 */
		public function buildAllChild(depth:int):void {
			if (depth < _scene.treeLevel) {
				for (var i:int = 0; i < CHILDNUM; i++) {
					var child:OctreeNode = addChild(i);
					child.buildAllChild(depth + 1);
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _renderBoudingBox(line:PixelLineSprite3D):void {
			//var boundBox:BoundBox = _relaxBox;
			//var corners:Vector.<Vector3> = _tempBoundBoxCorners;
			//boundBox.getCorners(corners);
			//linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 1.0, 0.0, 0.0, 1.0, corners[1].x, corners[1].y, corners[1].z, 1.0, 0.0, 0.0, 1.0);
			//linePhasor.line(corners[2].x, corners[2].y, corners[2].z, 1.0, 0.0, 0.0, 1.0, corners[3].x, corners[3].y, corners[3].z, 1.0, 0.0, 0.0, 1.0);
			//linePhasor.line(corners[4].x, corners[4].y, corners[4].z, 1.0, 0.0, 0.0, 1.0, corners[5].x, corners[5].y, corners[5].z, 1.0, 0.0, 0.0, 1.0);
			//linePhasor.line(corners[6].x, corners[6].y, corners[6].z, 1.0, 0.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 1.0, 0.0, 0.0, 1.0);
			//
			//linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 1.0, 0.0, 0.0, 1.0, corners[3].x, corners[3].y, corners[3].z, 1.0, 0.0, 0.0, 1.0);
			//linePhasor.line(corners[1].x, corners[1].y, corners[1].z, 1.0, 0.0, 0.0, 1.0, corners[2].x, corners[2].y, corners[2].z, 1.0, 0.0, 0.0, 1.0);
			//linePhasor.line(corners[2].x, corners[2].y, corners[2].z, 1.0, 0.0, 0.0, 1.0, corners[6].x, corners[6].y, corners[6].z, 1.0, 0.0, 0.0, 1.0);
			//linePhasor.line(corners[3].x, corners[3].y, corners[3].z, 1.0, 0.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 1.0, 0.0, 0.0, 1.0);
			//
			//linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 1.0, 0.0, 0.0, 1.0, corners[4].x, corners[4].y, corners[4].z, 1.0, 0.0, 0.0, 1.0);
			//linePhasor.line(corners[1].x, corners[1].y, corners[1].z, 1.0, 0.0, 0.0, 1.0, corners[5].x, corners[5].y, corners[5].z, 1.0, 0.0, 0.0, 1.0);
			//linePhasor.line(corners[4].x, corners[4].y, corners[4].z, 1.0, 0.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 1.0, 0.0, 0.0, 1.0);
			//linePhasor.line(corners[5].x, corners[5].y, corners[5].z, 1.0, 0.0, 0.0, 1.0, corners[6].x, corners[6].y, corners[6].z, 1.0, 0.0, 0.0, 1.0);
		}
	}
}