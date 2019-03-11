package laya.d3.graphics {
	import laya.d3.component.SimpleSingletonList;
	import laya.d3.component.SingletonList;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.renders.Render;
	import laya.layagl.LayaGL;
	import laya.resource.ISingletonElement;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * <code>FrustumCulling</code> 类用于裁剪。
	 */
	public class FrustumCulling {
		/**@private	[NATIVE]*/
		public static var _cullingBufferLength:int;
		/**@private	[NATIVE]*/
		public static var _cullingBuffer:Float32Array;
		
		/**
		 * @private
		 */
		public static function __init__():void {
			if (Render.isConchApp) {//[NATIVE]
				_cullingBufferLength = 0;
				_cullingBuffer = new Float32Array(4096);
			}
		}
		
		/**
		 * @private
		 */
		public static function renderObjectCulling(camera:Camera, scene:Scene3D, context:RenderContext3D, renderList:SingletonList):void {
			var i:int, n:int, j:int, m:int;
			var opaqueQueue:RenderQueue = scene._opaqueQueue;
			var transparentQueue:RenderQueue = scene._transparentQueue;
			opaqueQueue.clear();
			transparentQueue.clear();
			
			var staticBatchManagers:Vector.<StaticBatchManager> = StaticBatchManager._managers;
			for (i = 0, n = staticBatchManagers.length; i < n; i++)
				staticBatchManagers[i]._clear();
			var dynamicBatchManagers:Vector.<DynamicBatchManager> = DynamicBatchManager._managers;
			for (i = 0, n = dynamicBatchManagers.length; i < n; i++)
				dynamicBatchManagers[i]._clear();
			
			var validCount:int = renderList.length;
			var renders:Vector.<ISingletonElement> = renderList.elements;
			var boundFrustum:BoundFrustum = camera.boundFrustum;
			Stat.spriteCount += validCount;
			var camPos:Vector3 = context.camera._transform.position;
			if (scene.treeRoot) {
				scene.treeRoot.cullingObjects(context, boundFrustum, camera, camPos, true);
			} else {
				for (i = 0; i < validCount; i++) {
					var render:BaseRender = renders[i] as BaseRender;
					if (scene.isLayerVisible(render._owner._layer, camera) && render._enable && render._needRender(boundFrustum)) {
						render._visible = true;
						render._distanceForSort = Vector3.distance(render.boundingSphere.center, camPos);//TODO:合并计算浪费,或者合并后取平均值
						var elements:Vector.<RenderElement> = render._renderElements;
						for (j = 0, m = elements.length; j < m; j++) {
							var element:RenderElement = elements[j];
							var renderQueue:RenderQueue = scene._getRenderQueue(element.material.renderQueue);
							if (renderQueue.isTransparent)
								element.addToTransparentRenderQueue(context, renderQueue);
							else
								element.addToOpaqueRenderQueue(context, renderQueue);
						}
					} else {
						render._visible = false;
					}
				}
			}
			
			var count:int = opaqueQueue.elements.length;
			(count > 0) && (opaqueQueue._quickSort(0, count - 1));
			count = transparentQueue.elements.length;
			(count > 0) && (transparentQueue._quickSort(0, count - 1));
		}
		
		///**
		//* @private
		//*/
		//public static function renderShadowObjectCullingOctree(scene:Scene, lightFrustum:Vector.<BoundFrustum>, quenesResult:Vector.<RenderQueue>, lightViewProjectMatrix:Matrix4x4, nPSSMNum:int):void //TODO:SM
		//{
		////TODO:静态合并动态合并
		//for (var i:int = 0, n:int = quenesResult.length; i < n; i++) {
		//var quene:RenderQueue = quenesResult[i];
		//(quene) && (quene.clear());
		//}
		//if (nPSSMNum > 1) {
		//scene.treeRoot.cullingShadowObjects(lightFrustum, quenesResult, true, 0, scene);
		//} else {
		//scene.treeRoot.cullingShadowObjectsOnePSSM(lightFrustum[0], quenesResult, lightViewProjectMatrix, true, 0, scene);
		//}
		//}
		
		/**
		 * @private [NATIVE]
		 */
		public static function renderObjectCullingNative(camera:Camera, scene:Scene3D, context:RenderContext3D, renderList:SimpleSingletonList):void {
			var i:int, n:int, j:int, m:int;
			var opaqueQueue:RenderQueue = scene._opaqueQueue;
			var transparentQueue:RenderQueue = scene._transparentQueue;
			opaqueQueue.clear();
			transparentQueue.clear();
			
			var staticBatchManagers:Vector.<StaticBatchManager> = StaticBatchManager._managers;
			for (i = 0, n = staticBatchManagers.length; i < n; i++)
				staticBatchManagers[i]._clear();
			var dynamicBatchManagers:Vector.<DynamicBatchManager> = DynamicBatchManager._managers;
			for (i = 0, n = dynamicBatchManagers.length; i < n; i++)
				dynamicBatchManagers[i]._clear();
			
			var validCount:int = renderList.length;
			var renders:Vector.<ISingletonElement> = renderList.elements;
			for (i = 0; i < validCount; i++) {
				(renders[i] as BaseRender).boundingSphere;
			}
			var boundFrustum:BoundFrustum = camera.boundFrustum;
			cullingNative(camera._boundFrustumBuffer, _cullingBuffer, scene._cullingBufferIndices, validCount, scene._cullingBufferResult);
			
			Stat.spriteCount += validCount;
			var camPos:Vector3 = context.camera._transform.position;
			for (i = 0; i < validCount; i++) {
				var render:BaseRender = renders[i] as BaseRender;
				if (scene.isLayerVisible(render._owner._layer, camera) && render._enable && scene._cullingBufferResult[i]) {//TODO:需要剥离部分函数
					render._visible = true;
					render._distanceForSort = Vector3.distance(render.boundingSphere.center, camPos);//TODO:合并计算浪费,或者合并后取平均值
					var elements:Vector.<RenderElement> = render._renderElements;
					for (j = 0, m = elements.length; j < m; j++) {
						var element:RenderElement = elements[j];
						var renderQueue:RenderQueue = scene._getRenderQueue(element.material.renderQueue);
						if (renderQueue.isTransparent)
							element.addToTransparentRenderQueue(context, renderQueue);
						else
							element.addToOpaqueRenderQueue(context, renderQueue);
					}
				} else {
					render._visible = false;
				}
			}
			
			var count:int = opaqueQueue.elements.length;
			(count > 0) && (opaqueQueue._quickSort(0, count - 1));
			count = transparentQueue.elements.length;
			(count > 0) && (transparentQueue._quickSort(0, count - 1));
		}
		
		/**
		 * @private [NATIVE]
		 */
		public static function cullingNative(boundFrustumBuffer:Float32Array, cullingBuffer:Float32Array, cullingBufferIndices:Int32Array, cullingCount:int, cullingBufferResult:Int32Array):int {
			return LayaGL.instance.culling(boundFrustumBuffer, cullingBuffer, cullingBufferIndices, cullingCount, cullingBufferResult);
		}
		
		/**
		 * 创建一个 <code>FrustumCulling</code> 实例。
		 */
		public function FrustumCulling() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
	
	}
}