package laya.d3.graphics {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Layer;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.ContainmentType;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FrustumCulling {
		
		public function FrustumCulling() {
		}
		
		public static function RenderObjectCulling(boundFrustum:BoundFrustum, scene:BaseScene):void {
			var i:int, iNum:int, j:int, jNum:int;
			var frustumCullingObject:RenderCullingObject;
			var renderElement:RenderElement;
			var curRenderQueue:RenderQueue;
			var queues:Vector.<RenderQueue> = scene._quenes;
			var frustumCullingObjects:Vector.<RenderCullingObject> = scene._frustumCullingObjects;
			if (scene._frustumCullingObjectsNeedClear) {
				for (i = 0, iNum = queues.length; i < iNum; i++)
					(queues[i]) && (queues[i]._clearRenderElements());
				for (i = 0, iNum = frustumCullingObjects.length; i < iNum; i++) {
					frustumCullingObject = frustumCullingObjects[i];
					if (Layer.isVisible(frustumCullingObject._layerMask) && frustumCullingObject._ownerEnable && frustumCullingObject._enable && (boundFrustum.ContainsBoundSphere(frustumCullingObject._boundingSphere) !== ContainmentType.Disjoint)) {
						for (j = 0, jNum = frustumCullingObject._renderElements.length; j < jNum; j++) {
							renderElement = frustumCullingObject._renderElements[j];
							curRenderQueue = scene.getRenderQueue(renderElement.material.renderQueue);
							curRenderQueue._addRenderElement(renderElement);
						}
					}
				}
				scene._frustumCullingObjectsNeedClear = false;
			} else {
				for (i = 0, iNum = frustumCullingObjects.length; i < iNum; i++) {
					frustumCullingObject = frustumCullingObjects[i];
					var lastRenderQuque:RenderQueue;
					if (Layer.isVisible(frustumCullingObject._layerMask) && frustumCullingObject._ownerEnable && frustumCullingObject._enable && (boundFrustum.ContainsBoundSphere(frustumCullingObject._boundingSphere) !== ContainmentType.Disjoint)) {
						for (j = 0, jNum = frustumCullingObject._renderElements.length; j < jNum; j++) {
							renderElement = frustumCullingObject._renderElements[j];
							curRenderQueue = scene.getRenderQueue(renderElement.material.renderQueue);
							lastRenderQuque = renderElement.ownerRenderQneue;
							if (curRenderQueue !== lastRenderQuque) {
								(lastRenderQuque) && (lastRenderQuque._deleteRenderElement(renderElement));
								curRenderQueue._addRenderElement(renderElement);
							}
						}
					} else {
						for (j = 0, jNum = frustumCullingObject._renderElements.length; j < jNum; j++) {
							renderElement = frustumCullingObject._renderElements[j];
							lastRenderQuque = renderElement.ownerRenderQneue;
							(lastRenderQuque) && (lastRenderQuque._deleteRenderElement(renderElement));
						}
					}
				}
				
			}
		}
	
	}

}