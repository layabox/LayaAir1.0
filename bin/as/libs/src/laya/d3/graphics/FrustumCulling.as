package laya.d3.graphics {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Layer;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FrustumCulling {
		
		public function FrustumCulling() {
		}
		
		/**
		 * @private
		 */
		public static function renderShadowObjectCulling(scene:BaseScene, lightFrustum:Vector.<BoundFrustum>, shadowQueues:Vector.<RenderQueue>, lightViewProjectMatrix:Matrix4x4, nPSSMNum:int):void //TODO:SM
		{
			//TODO:动态合并静态合并。
			var i:int = 0, j:int = 0, n:int = 0, m:int = 0;
			for (i = 0, n = shadowQueues.length; i < n; i++) {
				var quene:RenderQueue = shadowQueues[i];
				(quene) && (quene._clearRenderElements());
			}
			var frustumCullingObjects:Vector.<RenderObject> = scene._frustumCullingObjects;
			var renderObject:RenderObject, baseRender:BaseRender, shadowQueue:RenderQueue, renderElements:Vector.<RenderElement>;
			if (nPSSMNum > 1) {
				for (i = 0, n = frustumCullingObjects.length; i < n; i++) {
					renderObject = frustumCullingObjects[i];
					baseRender = renderObject._render;
					if (baseRender.castShadow && Layer.isVisible(renderObject._layerMask) && renderObject._enable) {
						for (var k:int = 1, kNum:int = lightFrustum.length; k < kNum; k++) {
							shadowQueue = shadowQueues[k - 1];
							if (lightFrustum[k].containsBoundSphere(baseRender.boundingSphere) !== ContainmentType.Disjoint) {
								//TODO:距离排序
								renderElements = renderObject._renderElements;
								for (j = 0, m = renderElements.length; j < m; j++)
									shadowQueue._addRenderElement(renderElements[j]);
							}
						}
					}
				}
			} else {
				for (i = 0, n = frustumCullingObjects.length; i < n; i++) {
					renderObject = frustumCullingObjects[i];
					baseRender = renderObject._render;
					if (baseRender.castShadow && Layer.isVisible(renderObject._layerMask)  && renderObject._enable) {
						if (lightFrustum[0].containsBoundSphere(baseRender.boundingSphere) !== ContainmentType.Disjoint) {
							renderObject._owner._prepareShaderValuetoRender(lightViewProjectMatrix);
							//TODO:距离排序
							shadowQueue = shadowQueues[0];
							renderElements = renderObject._renderElements;
							for (j = 0, m = renderElements.length; j < m; j++)
								shadowQueue._addRenderElement(renderElements[j]);
						}
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		public static function renderShadowObjectCullingOctree(scene:BaseScene, lightFrustum:Vector.<BoundFrustum>, quenesResult:Vector.<RenderQueue>, lightViewProjectMatrix:Matrix4x4, nPSSMNum:int):void //TODO:SM
		{
			//TODO:静态合并动态合并
			for (var i:int = 0, n:int = quenesResult.length; i < n; i++) {
				var quene:RenderQueue = quenesResult[i];
				(quene) && (quene._clearRenderElements());
			}
			if (nPSSMNum > 1) {
				scene.treeRoot.cullingShadowObjects(lightFrustum, quenesResult, true, 0, scene);
			} else {
				scene.treeRoot.cullingShadowObjectsOnePSSM(lightFrustum[0], quenesResult, lightViewProjectMatrix, true, 0, scene);
			}
		}
		
		public static function renderObjectCulling(boundFrustum:BoundFrustum, scene:BaseScene, camera:BaseCamera, view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			var i:int, iNum:int, j:int, jNum:int;
			var queues:Vector.<RenderQueue> = scene._quenes;
			var staticBatchMananger:StaticBatchManager = scene._staticBatchManager;
			var dynamicBatchManager:DynamicBatchManager = scene._dynamicBatchManager;
			var frustumCullingObjects:Vector.<RenderObject> = scene._frustumCullingObjects;
			for (i = 0, iNum = queues.length; i < iNum; i++) {
				var queue:RenderQueue = queues[i];
				(queue) && (queue._clearRenderElements());
			}
			staticBatchMananger._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			
			var cameraPosition:Vector3 = camera.transform.position;
			for (i = 0, iNum = frustumCullingObjects.length; i < iNum; i++) {
				var renderObject:RenderObject = frustumCullingObjects[i];
				if (Layer.isVisible(renderObject._layerMask)  && renderObject._enable && (boundFrustum.containsBoundSphere(renderObject._render.boundingSphere) !== ContainmentType.Disjoint)) {
					renderObject._owner._prepareShaderValuetoRender(projectionView);//TODO:静态合并或者动态合并造成浪费,多摄像机也会部分浪费
					renderObject._distanceForSort = Vector3.distance(renderObject._render.boundingSphere.center, cameraPosition) + renderObject._render.sortingFudge;
					var renderElements:Vector.<RenderElement> = renderObject._renderElements;
					for (j = 0, jNum = renderElements.length; j < jNum; j++) {
						var renderElement:RenderElement = renderElements[j];
						var staticBatch:StaticBatch = renderElement._staticBatch;//TODO:换vertexBuffer后应该取消合并,修改顶点数据后，从动态列表移除，暂时忽略，不允许直接修改Buffer。
						if (staticBatch && /*(staticBatch._vertexDeclaration===renderElement.element.getVertexBuffer().vertexDeclaration)&&*/ (staticBatch._material === renderElement._material)) {
							staticBatch._addRenderElement(renderElement);
						} else {//TODO:暂时取消动态合并，sprite3D也需判断合并，例如阴影receiveShadow问题。
							var renderObj:IRenderable = renderElement.renderObj;
							if ((renderObj.triangleCount < DynamicBatch.maxCombineTriangleCount) && (renderObj._vertexBufferCount === 1) && (renderObj._getIndexBuffer()) && (renderElement._material.renderQueue < 2) && renderElement._canDynamicBatch && (!renderObject._owner.isStatic))//TODO:是否可兼容无IB渲染,例如闪光//TODO:临时取消透明队列动态合并//TODO:加色法可以合并//TODO:静态物体如果没合并走动态合并现在会出BUG,lightmapUV问题。
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
								scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
			}
			staticBatchMananger._addToRenderQueue(scene, view, projection, projectionView);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene, view, projection, projectionView);
		}
		
		public static function renderObjectCullingOctree(boundFrustum:BoundFrustum, scene:BaseScene, camera:BaseCamera, view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			var queues:Vector.<RenderQueue> = scene._quenes;
			var staticBatchMananger:StaticBatchManager = scene._staticBatchManager;
			var dynamicBatchManager:DynamicBatchManager = scene._dynamicBatchManager;
			for (var i:int = 0, n:int = queues.length; i < n; i++) {
				var queue:RenderQueue = queues[i];
				(queue) && (queue._clearRenderElements());
			}
			staticBatchMananger._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			
			scene._frustumCullingObjects.length = 0;
			scene.treeRoot.cullingObjects(boundFrustum, true, 0, camera.transform.position, projectionView);
			
			staticBatchMananger._addToRenderQueue(scene, view, projection, projectionView);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene, view, projection, projectionView);
		}
		
		public static function renderObjectCullingNoBoundFrustum(scene:BaseScene, camera:BaseCamera, view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			var i:int, iNum:int, j:int, jNum:int;
			var queues:Vector.<RenderQueue> = scene._quenes;
			var staticBatchMananger:StaticBatchManager = scene._staticBatchManager;
			var dynamicBatchManager:DynamicBatchManager = scene._dynamicBatchManager;
			var frustumCullingObjects:Vector.<RenderObject> = scene._frustumCullingObjects;
			for (i = 0, iNum = queues.length; i < iNum; i++) {
				var queue:RenderQueue = queues[i];
				(queue) && (queue._clearRenderElements());
			}
			staticBatchMananger._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			
			var cameraPosition:Vector3 = camera.transform.position;
			for (i = 0, iNum = frustumCullingObjects.length; i < iNum; i++) {
				var renderObject:RenderObject = frustumCullingObjects[i];
				if (Layer.isVisible(renderObject._layerMask) && renderObject._enable) {
					renderObject._owner._prepareShaderValuetoRender(projectionView);//TODO:静态合并或者动态合并造成浪费,多摄像机也会部分浪费
					renderObject._distanceForSort = Vector3.distance(renderObject._render.boundingSphere.center, cameraPosition) + renderObject._render.sortingFudge;
					var renderElements:Vector.<RenderElement> = renderObject._renderElements;
					for (j = 0, jNum = renderElements.length; j < jNum; j++) {
						var renderElement:RenderElement = renderElements[j];
						var staticBatch:StaticBatch = renderElement._staticBatch;//TODO:换vertexBuffer后应该取消合并,修改顶点数据后，从动态列表移除，暂时忽略，不允许直接修改Buffer。
						if (staticBatch && /*(staticBatch._vertexDeclaration===renderElement.element.getVertexBuffer().vertexDeclaration)&&*/ (staticBatch._material === renderElement._material)) {
							staticBatch._addRenderElement(renderElement);
						} else {//TODO:暂时取消动态合并，sprite3D也需判断合并
							var renderObj:IRenderable = renderElement.renderObj;
							if ((renderObj.triangleCount < DynamicBatch.maxCombineTriangleCount) && (renderObj._vertexBufferCount === 1) && (renderObj._getIndexBuffer()) && (renderElement._material.renderQueue < 2) && renderElement._canDynamicBatch && (!renderObject._owner.isStatic))//TODO:是否可兼容无IB渲染,例如闪光//TODO:临时取消透明队列动态合并//TODO:加色法可以合并//TODO:静态物体如果没合并走动态合并现在会出BUG,lightmapUV问题。
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
								scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
			}
			staticBatchMananger._addToRenderQueue(scene, view, projection, projectionView);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene, view, projection, projectionView);
		}
	
	}
}