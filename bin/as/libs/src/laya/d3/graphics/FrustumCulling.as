package laya.d3.graphics {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Layer;
	import laya.d3.core.particleShuriKen.ShurikenParticleRender;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	
	/**
	 * @private
	 */
	public class FrustumCulling {
		
		public function FrustumCulling() {
		}
		
		/**
		 * @private
		 */
		public static function renderShadowObjectCulling(scene:Scene, lightFrustum:Vector.<BoundFrustum>, shadowQueues:Vector.<RenderQueue>, lightViewProjectMatrix:Matrix4x4, nPSSMNum:int):void //TODO:SM
		{
			//TODO:动态合并静态合并。
			var i:int = 0, j:int = 0, n:int = 0, m:int = 0;
			for (i = 0, n = shadowQueues.length; i < n; i++) {
				var quene:RenderQueue = shadowQueues[i];
				(quene) && (quene._clearRenderElements());
			}
			var frustumCullingObjects:Vector.<BaseRender> = scene._cullingRenders;
			var baseRender:BaseRender, shadowQueue:RenderQueue, renderElements:Vector.<RenderElement>;
			if (nPSSMNum > 1) {
				for (i = 0, n = scene._cullingRendersLength; i < n; i++) {
					baseRender = frustumCullingObjects[i];
					if (baseRender.castShadow && Layer.isVisible(baseRender._owner.layer.mask) && baseRender.enable) {
						for (var k:int = 1, kNum:int = lightFrustum.length; k < kNum; k++) {
							shadowQueue = shadowQueues[k - 1];
							if (lightFrustum[k].containsBoundSphere(baseRender.boundingSphere) !== ContainmentType.Disjoint) {
								//TODO:距离排序
								renderElements = baseRender._renderElements;
								for (j = 0, m = renderElements.length; j < m; j++)
									shadowQueue._addRenderElement(renderElements[j]);
							}
						}
					}
				}
			} else {
				for (i = 0, n = scene._cullingRendersLength; i < n; i++) {
					baseRender = frustumCullingObjects[i];
					if (baseRender.castShadow && Layer.isVisible(baseRender._owner.layer.mask) && baseRender.enable) {
						if (lightFrustum[0].containsBoundSphere(baseRender.boundingSphere) !== ContainmentType.Disjoint) {
							baseRender._renderUpdate(lightViewProjectMatrix);
							//TODO:距离排序
							shadowQueue = shadowQueues[0];
							renderElements = baseRender._renderElements;
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
		public static function renderShadowObjectCullingOctree(scene:Scene, lightFrustum:Vector.<BoundFrustum>, quenesResult:Vector.<RenderQueue>, lightViewProjectMatrix:Matrix4x4, nPSSMNum:int):void //TODO:SM
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
		
		/**
		 * @private
		 */
		public static function renderObjectCulling(boundFrustum:BoundFrustum, scene:Scene, camera:BaseCamera, view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			var i:int, n:int, j:int, m:int;
			var queues:Vector.<RenderQueue> = scene._quenes;
			var dynamicBatchManager:DynamicBatchManager = scene._dynamicBatchManager;
			var frustumCullingObjects:Vector.<BaseRender> = scene._cullingRenders;
			
			for (i = 0, n = queues.length; i < n; i++) {
				var queue:RenderQueue = queues[i];
				(queue) && (queue._clearRenderElements());
			}
			var staticBatchManagers:Vector.<StaticBatchManager> = StaticBatchManager._staticBatchManagers;
			for (i = 0, n = staticBatchManagers.length; i < n; i++)
				staticBatchManagers[i]._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			
			var cameraPosition:Vector3 = camera.transform.position;
			for (i = 0, n = scene._cullingRendersLength; i < n; i++) {
				var baseRender:BaseRender = frustumCullingObjects[i];
				if (Layer.isVisible(baseRender._owner.layer.mask) && baseRender.enable && (boundFrustum.containsBoundSphere(baseRender.boundingSphere) !== ContainmentType.Disjoint)) {
					if (baseRender._renderUpdate(projectionView))//TODO:静态合并或者动态合并造成浪费,多摄像机也会部分浪费
					{
						baseRender._distanceForSort = Vector3.distance(baseRender.boundingSphere.center, cameraPosition) + baseRender.sortingFudge;
						var renderElements:Vector.<RenderElement> = baseRender._renderElements;
						for (j = 0, m = renderElements.length; j < m; j++) {
							var renderElement:RenderElement = renderElements[j];
							var staticBatch:StaticBatch = renderElement._staticBatch;//TODO:换vertexBuffer后应该取消合并,修改顶点数据后，从动态列表移除，暂时忽略，不允许直接修改Buffer。
							if (staticBatch && /*(staticBatch._vertexDeclaration===renderElement.element.getVertexBuffer().vertexDeclaration)&&*/ (staticBatch._material === renderElement._material)) {
								staticBatch._addBatchRenderElement(renderElement);
							} else {//TODO:暂时取消动态合并，sprite3D也需判断合并，例如阴影receiveShadow问题。
								var renderObj:IRenderable = renderElement.renderObj;
								if ((renderObj.triangleCount < DynamicBatch.maxCombineTriangleCount) && (renderObj._vertexBufferCount === 1) && (renderObj._getIndexBuffer()) && (renderElement._material.renderQueue < 2) && renderElement._canDynamicBatch && (!baseRender._owner.isStatic))//TODO:是否可兼容无IB渲染,例如闪光//TODO:临时取消透明队列动态合并//TODO:加色法可以合并//TODO:静态物体如果没合并走动态合并现在会出BUG,lightmapUV问题。
									dynamicBatchManager._addPrepareRenderElement(renderElement);
								else
									scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
							}
						}
					}
				}
			}
			for (i = 0, n = staticBatchManagers.length; i < n; i++)
				staticBatchManagers[i]._addToRenderQueue(scene, view, projection, projectionView);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene, view, projection, projectionView);
		}
		
		/**
		 * @private
		 */
		public static function renderObjectCullingOctree(boundFrustum:BoundFrustum, scene:Scene, camera:BaseCamera, view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			var i:int, n:int;
			var queues:Vector.<RenderQueue> = scene._quenes;
			var dynamicBatchManager:DynamicBatchManager = scene._dynamicBatchManager;
			for (i = 0, n = queues.length; i < n; i++) {
				var queue:RenderQueue = queues[i];
				(queue) && (queue._clearRenderElements());
			}
			
			var staticBatchManagers:Vector.<StaticBatchManager> = StaticBatchManager._staticBatchManagers;
			for (i = 0, n = staticBatchManagers.length; i < n; i++)
				staticBatchManagers[i]._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			
			scene._cullingRenders.length = 0;//TODO:优化
			scene.treeRoot.cullingObjects(boundFrustum, true, 0, camera.transform.position, projectionView);
			
			for (i = 0, n = staticBatchManagers.length; i < n; i++)
				staticBatchManagers[i]._addToRenderQueue(scene, view, projection, projectionView);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene, view, projection, projectionView);
		}
		
		/**
		 * @private
		 */
		public static function renderObjectCullingNoBoundFrustum(scene:Scene, camera:BaseCamera, view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			var i:int, n:int, j:int, m:int;
			var queues:Vector.<RenderQueue> = scene._quenes;
			var dynamicBatchManager:DynamicBatchManager = scene._dynamicBatchManager;
			var frustumCullingObjects:Vector.<BaseRender> = scene._cullingRenders;
			for (i = 0, n = queues.length; i < n; i++) {
				var queue:RenderQueue = queues[i];
				(queue) && (queue._clearRenderElements());
			}
			var staticBatchManagers:Vector.<StaticBatchManager> = StaticBatchManager._staticBatchManagers;
			for (i = 0, n = staticBatchManagers.length; i < n; i++)
				staticBatchManagers[i]._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			
			var cameraPosition:Vector3 = camera.transform.position;
			for (i = 0, n = scene._cullingRendersLength; i < n; i++) {
				var baseRender:BaseRender = frustumCullingObjects[i];
				if (Layer.isVisible(baseRender._owner.layer.mask) && baseRender.enable) {
					baseRender._renderUpdate(projectionView);//TODO:静态合并或者动态合并造成浪费,多摄像机也会部分浪费
					baseRender._distanceForSort = Vector3.distance(baseRender.boundingSphere.center, cameraPosition) + baseRender.sortingFudge;
					var renderElements:Vector.<RenderElement> = baseRender._renderElements;
					for (j = 0, m = renderElements.length; j < m; j++) {
						var renderElement:RenderElement = renderElements[j];
						var staticBatch:StaticBatch = renderElement._staticBatch;//TODO:换vertexBuffer后应该取消合并,修改顶点数据后，从动态列表移除，暂时忽略，不允许直接修改Buffer。
						if (staticBatch && /*(staticBatch._vertexDeclaration===renderElement.element.getVertexBuffer().vertexDeclaration)&&*/ (staticBatch._material === renderElement._material)) {
							staticBatch._addBatchRenderElement(renderElement);
						} else {//TODO:暂时取消动态合并，sprite3D也需判断合并
							var renderObj:IRenderable = renderElement.renderObj;
							if ((renderObj.triangleCount < DynamicBatch.maxCombineTriangleCount) && (renderObj._vertexBufferCount === 1) && (renderObj._getIndexBuffer()) && (renderElement._material.renderQueue < 2) && renderElement._canDynamicBatch && (!baseRender._owner.isStatic))//TODO:是否可兼容无IB渲染,例如闪光//TODO:临时取消透明队列动态合并//TODO:加色法可以合并//TODO:静态物体如果没合并走动态合并现在会出BUG,lightmapUV问题。
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
								scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
			}
			for (i = 0, n = staticBatchManagers.length; i < n; i++)
				staticBatchManagers[i]._addToRenderQueue(scene, view, projection, projectionView);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene, view, projection, projectionView);
		}
	
	}
}