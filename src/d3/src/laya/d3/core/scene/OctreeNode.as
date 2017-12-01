package laya.d3.core.scene {
	import laya.d3.core.Layer;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.graphics.DynamicBatch;
	import laya.d3.graphics.DynamicBatchManager;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Collision;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.utils.Stat;
	
	public class OctreeNode implements ITreeNode {
		/**是否开启四/八叉树调试模式。 */
		public static var debugMode:Boolean = false;
		
		private static var relax:Number = 1.15;
		private static var tempVector0:Vector3 = new Vector3();
		private static var tempSize:Vector3 = new Vector3();
		private static var tempCenter:Vector3 = new Vector3();
		
		private static const CHILDNUM:int = 8;
		private static var _octreeSplit:Array = [new Vector3(0.250, 0.250, 0.250), new Vector3(0.750, 0.250, 0.250), new Vector3(0.250, 0.750, 0.250), new Vector3(0.750, 0.750, 0.250), new Vector3(0.250, 0.250, 0.750), new Vector3(0.750, 0.250, 0.750), new Vector3(0.250, 0.750, 0.750), new Vector3(0.750, 0.750, 0.750)];
		
		private var _exactBox:BoundBox = null;
		private var _relaxBox:BoundBox = null;
		
		private var _boundingSphere:BoundSphere = new BoundSphere(new Vector3(), 0);
		private var _corners:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		private var _boundingBoxCenter:Vector3 = new Vector3();
		private var _scene:Scene = null;
		private var _parent:OctreeNode = null;
		public var _children:Vector.<OctreeNode> = new Vector.<OctreeNode>(CHILDNUM);
		private var _objects:Vector.<BaseRender> = new Vector.<BaseRender>();
		private var _currentDepth:int = 0;
		private var _tempBoundBoxCorners:Vector.<Vector3> = new <Vector3>[new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()];
		
		public function init(center:Vector3, treeSize:Vector3):void {
			var min:Vector3 = new Vector3();
			var max:Vector3 = new Vector3();
			Vector3.scale(treeSize, -0.5, min);
			Vector3.scale(treeSize, 0.5, max);
			Vector3.add(min, center, min);
			Vector3.add(max, center, max);
			exactBox = new BoundBox(min, max);
			relaxBox = new BoundBox(min, max);
		}
		
		public function addTreeNode(render:BaseRender):void {
			if (Collision.boxContainsBox(_relaxBox, render.boundingBox) === ContainmentType.Contains)
				addNodeDown(render, 0);
			else
				addObject(render);
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
		
		public function OctreeNode(scene:Scene, currentDepth:int) {
			_scene = scene;
			_currentDepth = currentDepth;
		}
		
		public function addChild(index:int):OctreeNode {
			var child:OctreeNode = _children[index];
			if (child == null) {
				child = new OctreeNode(_scene, _currentDepth + 1);
				_children[index] = child;
				child._parent = this;
				
				Vector3.subtract(_exactBox.max, _exactBox.min, tempSize);
				Vector3.multiply(tempSize, _octreeSplit[index], tempCenter);
				Vector3.add(_exactBox.min, tempCenter, tempCenter);
				//size * 0.25
				Vector3.scale(tempSize, 0.25, tempSize);
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
			}
			return child;
		}
		
		public function addObject(object:BaseRender):void {
			object._treeNode = this;
			_objects.push(object);
		}
		
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
		
		public function clearObject():void {
			_objects.length = 0;
		}
		
		public function addNodeUp(render:BaseRender, depth:int):void {
			if (_parent && (Collision.boxContainsBox(_exactBox, render.boundingBox) !== ContainmentType.Contains)) {
				_parent.addNodeUp(render, depth - 1);
			} else
				addNodeDown(render, depth);
		}
		
		public function addNodeDown(render:BaseRender, depth:int):void {
			if (depth < _scene.treeLevel) {
				var childIndex:int = inChildIndex(render.boundingBoxCenter);
				var child:OctreeNode = addChild(childIndex);
				
				if (Collision.boxContainsBox(child._relaxBox, render.boundingBox) === ContainmentType.Contains) {
					child.addNodeDown(render, ++depth);
				} else
					addObject(render);
			} else {
				addObject(render);
			}
		}
		
		public function inChildIndex(objectCenter:Vector3):int {
			var z:int = objectCenter.z < _boundingBoxCenter.z ? 0 : 1;
			var y:int = objectCenter.y < _boundingBoxCenter.y ? 0 : 1;
			var x:int = objectCenter.x < _boundingBoxCenter.x ? 0 : 1;
			return z * 4 + y * 2 + x;
		}
		
		public function updateObject(render:BaseRender):void {
			//TODO 优化，效率不高
			if (Collision.boxContainsBox(_relaxBox, render.boundingBox) === ContainmentType.Contains) {
				removeObject(render);
				render._treeNode = null;
				addNodeDown(render, _currentDepth);
			} else if (_parent) {
				removeObject(render);
				render._treeNode = null;
				_parent.addNodeUp(render, _currentDepth - 1);
			}
		}
		
		public function cullingObjects(boundFrustum:BoundFrustum, testVisible:Boolean, flags:int, cameraPosition:Vector3, projectionView:Matrix4x4):void {
			var i:int, j:int, n:int, m:int;
			var dynamicBatchManager:DynamicBatchManager = _scene._dynamicBatchManager;
			for (i = 0, n = _objects.length; i < n; i++) {
				var render:BaseRender = _objects[i];
				//if ((pObject->m_nFlag & nFlags) == 0) continue;//TODO:阴影等
				if (Layer.isVisible(render._owner.layer.mask) && render.enable) {
					if (testVisible) {
						Stat.treeSpriteCollision += 1;
						if (boundFrustum.containsBoundSphere(render.boundingSphere) === ContainmentType.Disjoint)
							continue;
					}
					
					render._renderUpdate(projectionView);//TODO:静态合并或者动态合并造成浪费,多摄像机也会部分浪费
					render._distanceForSort = Vector3.distance(render.boundingSphere.center, cameraPosition) + render.sortingFudge;
					var renderElements:Vector.<RenderElement> = render._renderElements;
					for (j = 0, m = renderElements.length; j < m; j++) {
						var renderElement:RenderElement = renderElements[j];
						var staticBatch:StaticBatch = renderElement._staticBatch;//TODO:换vertexBuffer后应该取消合并,修改顶点数据后，从动态列表移除，暂时忽略，不允许直接修改Buffer。
						if (staticBatch && /*(staticBatch._vertexDeclaration===renderElement.element.getVertexBuffer().vertexDeclaration)&&*/ (staticBatch._material === renderElement._material)) {
							staticBatch._addBatchRenderElement(renderElement);
						} else {
							var renderObj:IRenderable = renderElement.renderObj;
							if ((renderObj.triangleCount < DynamicBatch.maxCombineTriangleCount) && (renderObj._vertexBufferCount === 1) && (renderObj._getIndexBuffer()) && (renderElement._material.renderQueue < 2) && renderElement._canDynamicBatch && (!render._owner.isStatic))//TODO:是否可兼容无IB渲染,例如闪光//TODO:临时取消透明队列动态合并//TODO:加色法可以合并//TODO:静态物体如果没合并走动态合并现在会出BUG,lightmapUV问题。
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
								_scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
				
			}
			for (i = 0; i < CHILDNUM; i++) {
				var child:OctreeNode = _children[i];
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
		
		/**
		 * @private
		 */
		public function cullingShadowObjects(lightBoundFrustum:Vector.<BoundFrustum>, splitShadowQueues:Vector.<RenderQueue>, testVisible:Boolean, flags:int, scene:Scene):void {//TODO:SM
			//TODO:动态合并和静态合并
			var i:int, j:int, n:int, m:int;
			var dynamicBatchManager:DynamicBatchManager = _scene._dynamicBatchManager;
			for (i = 0, n = _objects.length; i < n; i++) {
				var baseRender:BaseRender = _objects[i];
				if (baseRender.castShadow && Layer.isVisible(baseRender._owner.layer.mask) && baseRender.enable) {
					if (testVisible && lightBoundFrustum[0].containsBoundSphere(baseRender.boundingSphere) === ContainmentType.Disjoint)
						continue;
					
					//TODO:计算距离排序
					for (var k:int = 1, kNum:int = lightBoundFrustum.length; k < kNum; k++) {
						var shadowQueue:RenderQueue = splitShadowQueues[k - 1];
						if (lightBoundFrustum[k].containsBoundSphere(baseRender.boundingSphere) !== ContainmentType.Disjoint) {
							var renderElements:Vector.<RenderElement> = baseRender._renderElements;
							for (j = 0, m = renderElements.length; j < m; j++)
								shadowQueue._addRenderElement(renderElements[j]);
						}
					}
				}
			}
			for (i = 0; i < CHILDNUM; i++) {
				var child:OctreeNode = _children[i];
				if (child == null)
					continue;
				var testVisibleChild:Boolean = testVisible;
				if (testVisible) {
					var type:int = lightBoundFrustum[0].containsBoundBox(child._relaxBox);
					if (type === ContainmentType.Disjoint)
						continue;
					testVisibleChild = (type === ContainmentType.Intersects);
				}
				child.cullingShadowObjects(lightBoundFrustum, splitShadowQueues, testVisibleChild, flags, scene);
			}
		}
		
		/**
		 * @private
		 */
		public function cullingShadowObjectsOnePSSM(lightBoundFrustum:BoundFrustum, splitShadowQueues:Vector.<RenderQueue>, lightViewProjectMatrix:Matrix4x4, testVisible:Boolean, flags:int, scene:Scene):void {//TODO:SM
			//TODO:动态合并和静态合并
			var shadowQueue:RenderQueue = splitShadowQueues[0];
			var i:int, j:int, n:int, m:int;
			//var cameraPosition:Vector3 = camera.transform.position;
			for (i = 0, n = _objects.length; i < n; i++) {
				var baseRender:BaseRender = _objects[i];
				if (baseRender.castShadow && Layer.isVisible(baseRender._owner.layer.mask) && baseRender.enable) {
					if (testVisible && lightBoundFrustum.containsBoundSphere(baseRender.boundingSphere) === ContainmentType.Disjoint)
						continue;
					baseRender._renderUpdate(lightViewProjectMatrix);
					//TODO:计算距离排序
					var renderElements:Vector.<RenderElement> = baseRender._renderElements;
					for (j = 0, m = renderElements.length; j < m; j++)
						shadowQueue._addRenderElement(renderElements[j]);
				}
			}
			for (i = 0; i < CHILDNUM; i++) {
				var child:OctreeNode = _children[i];
				if (child == null)
					continue;
				var testVisibleChild:Boolean = testVisible;
				if (testVisible) {
					var type:int = lightBoundFrustum.containsBoundBox(child._relaxBox);
					if (type === ContainmentType.Disjoint)
						continue;
					testVisibleChild = (type === ContainmentType.Intersects);
				}
				child.cullingShadowObjectsOnePSSM(lightBoundFrustum, splitShadowQueues, lightViewProjectMatrix, testVisibleChild, flags, scene);
			}
		}
		
		public function renderBoudingBox(linePhasor:PhasorSpriter3D):void {
			_renderBoudingBox(linePhasor);
			for (var i:int = 0; i < CHILDNUM; ++i) {
				var pChild:OctreeNode = _children[i];
				if (pChild) {
					pChild.renderBoudingBox(linePhasor);
				}
			}
		}
		
		public function buildAllChild(depth:int):void {
			if (depth < _scene.treeLevel) {
				for (var i:int = 0; i < CHILDNUM; i++) {
					var child:OctreeNode = addChild(i);
					child.buildAllChild(depth + 1);
				}
			}
		}
		
		private function _renderBoudingBox(linePhasor:PhasorSpriter3D):void {
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