package laya.d3.core.scene {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.Layer;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.DynamicBatch;
	import laya.d3.graphics.DynamicBatchManager;
	import laya.d3.graphics.RenderObject;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Collision;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.RenderTexture;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	public class OctreeNode {
		static private const CHILD_NUM:int = 8;
		private var _scene:BaseScene = null;
		private var _parent:OctreeNode = null;
		private var _children:Vector.<OctreeNode> = new Vector.<OctreeNode>(CHILD_NUM);
		private var _objects:Vector.<RenderObject> = new Vector.<RenderObject>();
		public var _boundingBox:BoundBox = null;
		private var _currentDepth:int = 0;
		private static var s_octreeSplit:Array = [new Vector3(0.250, 0.250, 0.250), new Vector3(0.750, 0.250, 0.250), new Vector3(0.250, 0.750, 0.250), new Vector3(0.750, 0.750, 0.250), new Vector3(0.250, 0.250, 0.750), new Vector3(0.750, 0.250, 0.750), new Vector3(0.250, 0.750, 0.750), new Vector3(0.750, 0.750, 0.750)];
		
		private static var tempVector1:Vector3 = new Vector3();
		private static var tempVector2:Vector3 = new Vector3();
		private static var tempSize:Vector3 = new Vector3();
		private static var tempCenter:Vector3 = new Vector3();
		
		public function OctreeNode(scene:BaseScene, currentDepth:int) {
			_scene = scene;
			_currentDepth = currentDepth;
		}
		
		public function addChild(index:int):OctreeNode {
			var child:OctreeNode = _children[index];
			if (child == null) {
				child = new OctreeNode(_scene, _currentDepth + 1);
				_children[index] = child;
				child._parent = this;
				
				Vector3.subtract(_boundingBox.max, _boundingBox.min, tempSize);
				Vector3.multiply(tempSize, s_octreeSplit[index], tempCenter);
				Vector3.add(_boundingBox.min, tempCenter, tempCenter);
				//size * 0.25
				Vector3.scale(tempSize, 0.25, tempSize);
				//计算最小点和最大点
				var min:Vector3 = new Vector3();
				var max:Vector3 = new Vector3();
				Vector3.subtract(tempCenter, tempSize, min);
				Vector3.add(tempCenter, tempSize, max);
				//构造包围盒
				child._boundingBox = new BoundBox(min, max);
			}
			return child;
		}
		
		public function addObject(object:RenderObject):void {
			object._treeNode = this;
			_objects.push(object);
		}
		
		public function removeObject(object:RenderObject):Boolean {
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
		
		public function clearObject():void {
			_objects.length = 0;
		}
		
		public function addNodeUp(object:RenderObject, depth:int):void {
			if (_parent && (Collision.boxContainsBox(_boundingBox, object._render.boundingBox) !== ContainmentType.Contains))
				_parent.addNodeUp(object, depth - 1);
			else
				addNodeDown(object, depth);
		}
		
		public function addNodeDown(object:RenderObject, depth:int):void {
			if (depth < _scene.octreeLevel) {
				var box:BoundBox = object._render.boundingBox;
				var center:Vector3 = tempVector1;
				Vector3.add(box.min, box.max, center);
				Vector3.scale(center, 0.5, center);
				
				var nIndex:int = inChildIndex(center);
				var child:OctreeNode = addChild(nIndex);
				if (Collision.boxContainsBox(child._boundingBox, box) === ContainmentType.Contains) {
					child.addNodeDown(object, depth + 1);
					return;
				}
			}
			addObject(object);
		}
		
		public function inChildIndex(v:Vector3):int {
			var center:Vector3 = tempVector2;
			Vector3.add(_boundingBox.min, _boundingBox.max, center);
			Vector3.scale(center, 0.5, center);
			
			var c:Vector3 = center;
			var z:int = v.z < c.z ? 0 : 1;
			var y:int = v.y < c.y ? 0 : 1;
			var x:int = v.x < c.x ? 0 : 1;
			return z * 4 + y * 2 + x;
		}
		
		public function updateObject(object:RenderObject):void {
			//TODO 优化，效率不高
			if (Collision.boxContainsBox(_boundingBox, object._render.boundingBox) === ContainmentType.Contains) {
				removeObject(object);
				object._treeNode = null;
				addNodeDown(object, _currentDepth);
			} else if (_parent) {
				removeObject(object);
				object._treeNode = null;
				_parent.addNodeUp(object, _currentDepth - 1);
			}
		}
		
		public function cullingObjects(boundFrustum:BoundFrustum, bTestVisible:Boolean, flags:int, scene:BaseScene,camera:BaseCamera, view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			var iNum:int,jNum:int;
			var dynamicBatchManager:DynamicBatchManager = scene._dynamicBatchManager;
			
			
			var cameraPosition:Vector3 = camera.transform.position;
			for (var i:int = 0, n:int = _objects.length; i < n; ++i) {
				var renderObject:RenderObject = _objects[i];
				//if ((pObject->m_nFlag & nFlags) == 0) continue;//TODO:阴影等
				if (Layer.isVisible(renderObject._layerMask) && renderObject._ownerEnable && renderObject._enable) {
					if (bTestVisible)
						if (boundFrustum.containsBoundBox(renderObject._render.boundingBox) === ContainmentType.Disjoint)
							continue;
					
					renderObject._owner._prepareShaderValuetoRender(view, projection, projectionView);//TODO:静态合并或者动态合并造成浪费,多摄像机也会部分浪费
					renderObject._distanceForSort = Vector3.distance(renderObject._render.boundingSphere.center, cameraPosition) + renderObject._render.sortingFudge;
					var renderElements:Vector.<RenderElement> = renderObject._renderElements;
					for (j = 0, jNum = renderElements.length; j < jNum; j++) {
						var renderElement:RenderElement = renderElements[j];
						var staticBatch:StaticBatch = renderElement._staticBatch;//TODO:换vertexBuffer后应该取消合并,修改顶点数据后，从动态列表移除，暂时忽略，不允许直接修改Buffer。
						if (staticBatch && /*(staticBatch._vertexDeclaration===renderElement.element.getVertexBuffer().vertexDeclaration)&&*/ (staticBatch._material === renderElement._material)) {
							staticBatch._addRenderElement(renderElement);
						} else {
							var renderObj:IRenderable = renderElement.renderObj;
							if ((renderObj.triangleCount < DynamicBatch.maxCombineTriangleCount) && (renderObj._vertexBufferCount === 1) && (renderObj._getIndexBuffer()) && (renderElement._material.renderQueue < 2) && renderElement._canDynamicBatch && (!renderObject._owner.isStatic))//TODO:是否可兼容无IB渲染,例如闪光//TODO:临时取消透明队列动态合并//TODO:加色法可以合并//TODO:静态物体如果没合并走动态合并现在会出BUG,lightmapUV问题。
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
								scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
				
			}
			for (var j:int = 0; j < CHILD_NUM; ++j) {
				var pChild:OctreeNode = _children[j];
				if (pChild == null) continue;
				var bTestChild:Boolean = bTestVisible;
				if (bTestVisible) {
					var nType:int = boundFrustum.containsBoundBox(pChild._boundingBox);
					
					if (nType === ContainmentType.Disjoint)
						continue;
					
					bTestChild = (nType === ContainmentType.Intersects);
				}
				pChild.cullingObjects(boundFrustum, bTestChild, flags,scene,camera,view,projection,projectionView);
			}
		}
		
		public function renderBoudingBox(currentCamera:BaseCamera):void {
			_renderBoudingBox(currentCamera);
			for (var i:int = 0; i < CHILD_NUM; ++i) {
				var pChild:OctreeNode = _children[i];
				if (pChild) {
					pChild.renderBoudingBox(currentCamera);
				}
			}
		}
		
		public function buildAllChild(depth:int):void {
			if (depth < _scene.octreeLevel) {
				for (var i:int = 0; i < CHILD_NUM; i++) {
					var child:OctreeNode = addChild(i);
					child.buildAllChild(depth + 1);
				}
			}
		}
		
		private function _renderBoudingBox(currentCamera:BaseCamera):void {
		
		}
	}
}