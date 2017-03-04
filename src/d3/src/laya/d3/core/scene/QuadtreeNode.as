package laya.d3.core.scene {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Layer;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.graphics.DynamicBatch;
	import laya.d3.graphics.DynamicBatchManager;
	import laya.d3.graphics.RenderObject;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Collision;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.utils.Stat;
	
	public class QuadtreeNode implements ITreeNode{
		private static var relax:Number = 1.15;
		private static var tempVector0:Vector3 = new Vector3();
		private static var tempSize:Vector3 = new Vector3();
		private static var tempCenter:Vector3 = new Vector3();
		
		private static const CHILDNUM:int = 4;
		private static var _quadTreeSplit:Array = [new Vector3(0.250, 0.50, 0.250), new Vector3(0.750, 0.50, 0.250), new Vector3(0.250, 0.50, 0.750), new Vector3(0.750, 0.50, 0.750)];
		
		private var _exactBox:BoundBox = null;
		private var _relaxBox:BoundBox = null;
		
		private var _exactInfiniteBox:BoundBox = null;
		private var _relaxInfiniteBox:BoundBox = null;
		
		private var _boundingSphere:BoundSphere = new BoundSphere(new Vector3(), 0);
		private var _corners:Vector.<Vector3> = new Vector.<Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		private var _boundingBoxCenter:Vector3 = new Vector3();
		private var _scene:BaseScene = null;
		private var _parent:QuadtreeNode = null;
		public var _children:Vector.<QuadtreeNode> = new Vector.<QuadtreeNode>(CHILDNUM);
		private var _objects:Vector.<RenderObject> = new Vector.<RenderObject>();
		private var _currentDepth:int = 0;
		private var _tempBoundBoxCorners:Vector.<Vector3> = new Vector.<Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		public function init(center:Vector3, treeSize:Vector3):void {
			var min:Vector3 = new Vector3();
			var max:Vector3 = new Vector3();
			Vector3.scale(treeSize, -0.5, min);
			Vector3.scale(treeSize, 0.5, max);
			Vector3.add( min, center, min );
			Vector3.add( max, center, max );
			exactBox = new BoundBox(min, max);
			relaxBox = new BoundBox(min, max);	
			
			
			_exactInfiniteBox = new BoundBox(new Vector3(), new Vector3());
			_relaxInfiniteBox = new BoundBox(new Vector3(), new Vector3());	
			
			_exactInfiniteBox.min.elements[0] = _exactBox.min.elements[0];
			_exactInfiniteBox.min.elements[1] = Number.NEGATIVE_INFINITY;
			_exactInfiniteBox.min.elements[2] = _exactBox.min.elements[2];
			
			_exactInfiniteBox.max.elements[0] = _exactBox.max.elements[0];
			_exactInfiniteBox.max.elements[1] = Number.POSITIVE_INFINITY;
			_exactInfiniteBox.max.elements[2] = _exactBox.max.elements[2];
			
			
			_relaxInfiniteBox.min.elements[0] = _relaxBox.min.elements[0];
			_relaxInfiniteBox.min.elements[1] = Number.NEGATIVE_INFINITY;
			_relaxInfiniteBox.min.elements[2] = _relaxBox.min.elements[2];
			
			_relaxInfiniteBox.max.elements[0] = _relaxBox.max.elements[0];
			_relaxInfiniteBox.max.elements[1] = Number.POSITIVE_INFINITY;
			_relaxInfiniteBox.max.elements[2] = _relaxBox.max.elements[2];
			
		}
		
		public function addTreeNode(renderObj:RenderObject):void {
			if (Collision.boxContainsBox(_exactInfiniteBox, renderObj._render.boundingBox) === ContainmentType.Contains)
				addNodeDown(renderObj, 0);
			else
				addObject(renderObj);
		}
		
		public function QuadtreeNode(scene:BaseScene, currentDepth:int) {
			_scene = scene;
			_currentDepth = currentDepth;
		}
		
		public function get exactBox():BoundBox {
			return _exactBox;
		}
		
		public function set exactBox(value:BoundBox):void {
			_exactBox = value;
			Vector3.add(value.min, value.max, _boundingBoxCenter);
			Vector3.scale(_boundingBoxCenter, 0.5, _boundingBoxCenter);
		}
		
		public function set relaxBox(value:BoundBox):void {
			_relaxBox = value;
			value.getCorners(_corners);
			BoundSphere.createfromPoints(_corners, _boundingSphere);
		}
		
		public function get relaxBox():BoundBox {
			return _relaxBox;
		}
		
		public function get exactInfiniteBox():BoundBox {
			return _exactInfiniteBox;
		}
		
		public function set exactInfiniteBox(value:BoundBox):void {
			_exactInfiniteBox = value;
		}
		
		public function get relaxInfiniteBox():BoundBox {
			return _relaxInfiniteBox;
		}
		
		public function set relaxInfiniteBox(value:BoundBox):void {
			_relaxInfiniteBox = value;
		}
		
		public function addChild(index:int):QuadtreeNode {
			var child:QuadtreeNode = _children[index];
			if (child == null) {
				child = new QuadtreeNode(_scene, _currentDepth + 1);
				_children[index] = child;
				child._parent = this;
				
				Vector3.subtract(_exactBox.max, _exactBox.min, tempSize);
				Vector3.multiply(tempSize, _quadTreeSplit[index], tempCenter);
				Vector3.add(_exactBox.min, tempCenter, tempCenter);
	
				tempSize.elements[0] *= 0.25;
				tempSize.elements[1] *= 0.5;
				tempSize.elements[2] *= 0.25;
				//计算最小点和最大点
				var min:Vector3 = new Vector3();
				var max:Vector3 = new Vector3();
				Vector3.subtract(tempCenter, tempSize, min);
				Vector3.add(tempCenter, tempSize, max);
				//构造包围盒
				child.exactBox = new BoundBox(min, max);
				
				//relax包围盒
				Vector3.scale(tempSize, relax, tempSize);
				var relaxMin:Vector3 = new Vector3();
				var relaxMax:Vector3 = new Vector3();
				Vector3.subtract(tempCenter, tempSize, relaxMin);
				Vector3.add(tempCenter, tempSize, relaxMax);
				child.relaxBox = new BoundBox(relaxMin, relaxMax);
				
			
				child.exactInfiniteBox = new BoundBox(new Vector3(), new Vector3());
				child.relaxInfiniteBox = new BoundBox(new Vector3(), new Vector3());	
			
				child.exactInfiniteBox.min.elements[0] = _exactBox.min.elements[0];
				child.exactInfiniteBox.min.elements[1] = Number.NEGATIVE_INFINITY;
				child.exactInfiniteBox.min.elements[2] = _exactBox.min.elements[2];
				
				child.exactInfiniteBox.max.elements[0] = _exactBox.max.elements[0];
				child.exactInfiniteBox.max.elements[1] = Number.POSITIVE_INFINITY;
				child.exactInfiniteBox.max.elements[2] = _exactBox.max.elements[2];
				
				
				child.relaxInfiniteBox.min.elements[0] = _relaxBox.min.elements[0];
				child.relaxInfiniteBox.min.elements[1] = Number.NEGATIVE_INFINITY;
				child.relaxInfiniteBox.min.elements[2] = _relaxBox.min.elements[2];
				
				child.relaxInfiniteBox.max.elements[0] = _relaxBox.max.elements[0];
				child.relaxInfiniteBox.max.elements[1] = Number.POSITIVE_INFINITY;
				child.relaxInfiniteBox.max.elements[2] = _relaxBox.max.elements[2];
			}
			return child;
		}
		
		public function addObject(object:RenderObject):void {
			object._treeNode = this;
			_objects.push(object);
		}
		
		public function removeObject(object:RenderObject):Boolean {
			if (object._treeNode != this) {
				trace("QuadtreeNode::removeObject error");
				return false;
			}
			var index:int = _objects.indexOf(object);
			if (index !== -1) {
				_objects.splice(index, 1);
				return true;
			}
			return false;
		}
		
		public function clearObject():void {
			_objects.length = 0;
		}
		
		public function addNodeUp(object:RenderObject, depth:int):void {
			if (_parent && (Collision.boxContainsBox(_exactInfiniteBox, object._render.boundingBox) !== ContainmentType.Contains)) {
				_parent.addNodeUp(object, depth - 1);
			} else
				addNodeDown(object, depth);
		}
		
		public function addNodeDown(object:RenderObject, depth:int):void {
			if (depth < _scene.treeLevel) {
				var render:BaseRender = object._render;
				var childIndex:int = inChildIndex(render.boundingBoxCenter);
				var child:QuadtreeNode = addChild(childIndex);
				
				if (Collision.boxContainsBox(child.relaxInfiniteBox, render.boundingBox) === ContainmentType.Contains) {
					child.addNodeDown(object, ++depth);
				} else
					addObject(object);
			} else {
				addObject(object);
			}
		}
		
		public function inChildIndex(objectCenter:Vector3):int {
			var z:int = objectCenter.z < _boundingBoxCenter.z ? 0 : 1;
			var x:int = objectCenter.x < _boundingBoxCenter.x ? 0 : 1;
			return z * 2 + x;
		}
		
		public function updateObject(object:RenderObject):void {
			//TODO 优化，效率不高
			if (Collision.boxContainsBox(_relaxInfiniteBox, object._render.boundingBox) === ContainmentType.Contains) {
				removeObject(object);
				object._treeNode = null;
				addNodeDown(object, _currentDepth);
			} else if (_parent) {
				removeObject(object);
				object._treeNode = null;
				_parent.addNodeUp(object, _currentDepth - 1);
			}
		}
		
		public function cullingObjects(boundFrustum:BoundFrustum, testVisible:Boolean, flags:int, cameraPosition:Vector3, projectionView:Matrix4x4):void {
			var i:int, j:int, n:int, m:int;
			var dynamicBatchManager:DynamicBatchManager = _scene._dynamicBatchManager;
			for (i = 0, n = _objects.length; i < n; i++) {
				var renderObject:RenderObject = _objects[i];
				//if ((pObject->m_nFlag & nFlags) == 0) continue;//TODO:阴影等
				if (Layer.isVisible(renderObject._layerMask) && renderObject._ownerEnable && renderObject._enable) {
					var render:BaseRender = renderObject._render;
					if (testVisible) {
						Stat.treeSpriteCollision += 1;
						if (boundFrustum.containsBoundSphere(render.boundingSphere) === ContainmentType.Disjoint)
							continue;
					}
					
					renderObject._owner._prepareShaderValuetoRender(projectionView);//TODO:静态合并或者动态合并造成浪费,多摄像机也会部分浪费
					renderObject._distanceForSort = Vector3.distance(render.boundingSphere.center, cameraPosition) + render.sortingFudge;
					var renderElements:Vector.<RenderElement> = renderObject._renderElements;
					for (j = 0, m = renderElements.length; j < m; j++) {
						var renderElement:RenderElement = renderElements[j];
						var staticBatch:StaticBatch = renderElement._staticBatch;//TODO:换vertexBuffer后应该取消合并,修改顶点数据后，从动态列表移除，暂时忽略，不允许直接修改Buffer。
						if (staticBatch && /*(staticBatch._vertexDeclaration===renderElement.element.getVertexBuffer().vertexDeclaration)&&*/ (staticBatch._material === renderElement._material)) {
							staticBatch._addRenderElement(renderElement);
						} else {
							var renderObj:IRenderable = renderElement.renderObj;
							if ((renderObj.triangleCount < DynamicBatch.maxCombineTriangleCount) && (renderObj._vertexBufferCount === 1) && (renderObj._getIndexBuffer()) && (renderElement._material.renderQueue < 2) && renderElement._canDynamicBatch && (!renderObject._owner.isStatic))//TODO:是否可兼容无IB渲染,例如闪光//TODO:临时取消透明队列动态合并//TODO:加色法可以合并//TODO:静态物体如果没合并走动态合并现在会出BUG,lightmapUV问题。
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
								_scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
				
			}
			for (i = 0; i < CHILDNUM; i++) {
				var child:QuadtreeNode = _children[i];
				if (child == null)
					continue;
				var testVisibleChild:Boolean = testVisible;
				if (testVisible) {
					//var type:int = boundFrustum.containsBoundSphere(child._boundingSphere);
					var type:int = boundFrustum.containsBoundBox(child._relaxBox);
					Stat.treeNodeCollision += 1;
					if (type === ContainmentType.Disjoint)
						continue;
					testVisibleChild = (type === ContainmentType.Intersects);
				}
				child.cullingObjects(boundFrustum, testVisibleChild, flags, cameraPosition, projectionView);
			}
		}
		
		public function renderBoudingBox(linePhasor:PhasorSpriter3D):void {
			_renderBoudingBox(linePhasor);
			for (var i:int = 0; i < CHILDNUM; ++i) {
				var pChild:QuadtreeNode = _children[i];
				if (pChild) {
					pChild.renderBoudingBox(linePhasor);
				}
			}
		}
		
		public function buildAllChild(depth:int):void {
			if (depth < _scene.treeLevel) {
				for (var i:int = 0; i < CHILDNUM; i++) {
					var child:QuadtreeNode = addChild(i);
					child.buildAllChild(depth + 1);
				}
			}
		}
		
		private function _renderBoudingBox(linePhasor:PhasorSpriter3D):void {
			var boundBox:BoundBox = _relaxBox;
			var corners:Vector.<Vector3> = _tempBoundBoxCorners;
			boundBox.getCorners(corners);
			linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 1.0, 0.0, 0.0, 1.0, corners[1].x, corners[1].y, corners[1].z, 1.0, 0.0, 0.0, 1.0);
			linePhasor.line(corners[2].x, corners[2].y, corners[2].z, 1.0, 0.0, 0.0, 1.0, corners[3].x, corners[3].y, corners[3].z, 1.0, 0.0, 0.0, 1.0);
			linePhasor.line(corners[4].x, corners[4].y, corners[4].z, 1.0, 0.0, 0.0, 1.0, corners[5].x, corners[5].y, corners[5].z, 1.0, 0.0, 0.0, 1.0);
			linePhasor.line(corners[6].x, corners[6].y, corners[6].z, 1.0, 0.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 1.0, 0.0, 0.0, 1.0);
			
			linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 1.0, 0.0, 0.0, 1.0, corners[3].x, corners[3].y, corners[3].z, 1.0, 0.0, 0.0, 1.0);
			linePhasor.line(corners[1].x, corners[1].y, corners[1].z, 1.0, 0.0, 0.0, 1.0, corners[2].x, corners[2].y, corners[2].z, 1.0, 0.0, 0.0, 1.0);
			linePhasor.line(corners[2].x, corners[2].y, corners[2].z, 1.0, 0.0, 0.0, 1.0, corners[6].x, corners[6].y, corners[6].z, 1.0, 0.0, 0.0, 1.0);
			linePhasor.line(corners[3].x, corners[3].y, corners[3].z, 1.0, 0.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 1.0, 0.0, 0.0, 1.0);
			
			linePhasor.line(corners[0].x, corners[0].y, corners[0].z, 1.0, 0.0, 0.0, 1.0, corners[4].x, corners[4].y, corners[4].z, 1.0, 0.0, 0.0, 1.0);
			linePhasor.line(corners[1].x, corners[1].y, corners[1].z, 1.0, 0.0, 0.0, 1.0, corners[5].x, corners[5].y, corners[5].z, 1.0, 0.0, 0.0, 1.0);
			linePhasor.line(corners[4].x, corners[4].y, corners[4].z, 1.0, 0.0, 0.0, 1.0, corners[7].x, corners[7].y, corners[7].z, 1.0, 0.0, 0.0, 1.0);
			linePhasor.line(corners[5].x, corners[5].y, corners[5].z, 1.0, 0.0, 0.0, 1.0, corners[6].x, corners[6].y, corners[6].z, 1.0, 0.0, 0.0, 1.0);
		}
	}
}