package laya.d3.graphics {
	import laya.d3.core.Layer;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.ContainmentType;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FrustumCulling {
		
		public function FrustumCulling() {
		}
		
		public static function RenderObjectCulling(boundFrustum:BoundFrustum, scene:BaseScene):void {
			var i:int, iNum:int, j:int, jNum:int;
			var frustumCullingObject:RenderObject;
			var renderElement:RenderElement;
			var curRenderQueue:RenderQueue;
			var queues:Vector.<RenderQueue> = scene._quenes;
			var staticBatchMananger:StaticBatchManager = scene._staticBatchManager;
			var dynamicBatchManager:DynamicBatchManager = scene._dynamicBatchManager;
			var frustumCullingObjects:Vector.<RenderObject> = scene._frustumCullingObjects;
			for (i = 0, iNum = queues.length; i < iNum; i++)
				(queues[i]) && (queues[i]._clearRenderElements());
			staticBatchMananger._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			
			for (i = 0, iNum = frustumCullingObjects.length; i < iNum; i++) {
				frustumCullingObject = frustumCullingObjects[i];
				if (Layer.isVisible(frustumCullingObject._layerMask) && frustumCullingObject._ownerEnable && frustumCullingObject._enable && (boundFrustum.ContainsBoundSphere(frustumCullingObject._boundingSphere) !== ContainmentType.Disjoint)) {
					for (j = 0, jNum = frustumCullingObject._renderElements.length; j < jNum; j++) {
						renderElement = frustumCullingObject._renderElements[j];
						var staticBatch:StaticBatch = renderElement._staticBatch;//TODO:换vertexBuffer后应该取消合并,修改顶点数据后，从动态列表移除，暂时忽略，不允许直接修改Buffer。
						if (staticBatch && /*(staticBatch._vertexDeclaration===renderElement.element.getVertexBuffer().vertexDeclaration)&&*/ (staticBatch._material === renderElement._material)) {
							staticBatch._addRenderElement(renderElement);
						} else {
							var renderObj:IRenderable = renderElement.renderObj;
							if ((renderObj.triangleCount < DynamicBatch.maxCombineTriangleCount) && (renderObj._vertexBufferCount === 1)&& (renderObj._getIndexBuffer())&&(renderElement._material.renderQueue<3))//TODO:是否可兼容无IB渲染,例如闪光//TODO:临时取消透明队列动态合并//TODO:加色法可以合并
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
								scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
			}
			staticBatchMananger._addToRenderQueue(scene);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene);
		}
	
	}

}