package laya.d3.graphics {
	import laya.d3.core.Layer;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.ContainmentType;
	import laya.d3.math.Matrix4x4;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FrustumCulling {
		
		public function FrustumCulling() {
		}
		
		public static function RenderObjectCulling(boundFrustum:BoundFrustum, scene:BaseScene, view:Matrix4x4, projection:Matrix4x4,projectionView:Matrix4x4):void {
			var i:int, iNum:int, j:int, jNum:int;
			var queues:Vector.<RenderQueue> = scene._quenes;
			var staticBatchMananger:StaticBatchManager = scene._staticBatchManager;
			var dynamicBatchManager:DynamicBatchManager = scene._dynamicBatchManager;
			var frustumCullingObjects:Vector.<RenderObject> = scene._frustumCullingObjects;
			for (i = 0, iNum = queues.length; i < iNum; i++)
				(queues[i]) && (queues[i]._clearRenderElements());
			staticBatchMananger._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			
			for (i = 0, iNum = frustumCullingObjects.length; i < iNum; i++) {
				var renderObject:RenderObject = frustumCullingObjects[i];
				if (Layer.isVisible(renderObject._layerMask) && renderObject._ownerEnable && renderObject._enable && (boundFrustum.ContainsBoundSphere(renderObject._boundingSphere) !== ContainmentType.Disjoint)) {
					renderObject._owner._prepareShaderValuetoRender(view, projection,projectionView);//TODO:静态合并或者动态合并造成浪费,多摄像机也会部分浪费
					var renderElements:Vector.<RenderElement> = renderObject._renderElements;
					for (j = 0, jNum = renderElements.length; j < jNum; j++) {
						var renderElement:RenderElement = renderElements[j];
						var staticBatch:StaticBatch = renderElement._staticBatch;//TODO:换vertexBuffer后应该取消合并,修改顶点数据后，从动态列表移除，暂时忽略，不允许直接修改Buffer。
						if (staticBatch && /*(staticBatch._vertexDeclaration===renderElement.element.getVertexBuffer().vertexDeclaration)&&*/ (staticBatch._material === renderElement._material)) {
							staticBatch._addRenderElement(renderElement);
						} else {
							var renderObj:IRenderable = renderElement.renderObj;
							if ((renderObj.triangleCount < DynamicBatch.maxCombineTriangleCount) && (renderObj._vertexBufferCount === 1) && (renderObj._getIndexBuffer()) && (renderElement._material.renderQueue < 3) && renderElement._canDynamicBatch)//TODO:是否可兼容无IB渲染,例如闪光//TODO:临时取消透明队列动态合并//TODO:加色法可以合并
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
								scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
			}
			staticBatchMananger._addToRenderQueue(scene);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene,view,projection,projectionView);
		}
	
	}

}