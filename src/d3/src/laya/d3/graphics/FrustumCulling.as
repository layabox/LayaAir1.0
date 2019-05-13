package laya.d3.graphics {
	import laya.d3.component.SimpleSingletonList;
	import laya.d3.component.SingletonList;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.pixelLine.PixelLineSprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.BoundsOctree;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Color;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.renders.Render;
	import laya.layagl.LayaGL;
	import laya.resource.ISingletonElement;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * <code>FrustumCulling</code> 类用于裁剪。
	 */
	public class FrustumCulling {
		/**@private */
		private static var _tempColor0:Color = new Color();
		/**@private	[NATIVE]*/
		public static var _cullingBufferLength:int;
		/**@private	[NATIVE]*/
		public static var _cullingBuffer:Float32Array;
		
		/**
		 * @private
		 */
		public static function __init__():void {
			if (Render.supportWebGLPlusCulling) {//[NATIVE]
				_cullingBufferLength = 0;
				_cullingBuffer = new Float32Array(4096);
			}
		}
		
		/**
		 * @private
		 */
		private static function _drawTraversalCullingBound(renderList:SingletonList, debugTool:PixelLineSprite3D):void {
			var validCount:int = renderList.length;
			var renders:Vector.<ISingletonElement> = renderList.elements;
			for (var i:int = 0, n:int = renderList.length; i < n; i++) {
				var color:Color = _tempColor0;
				color.r = 0;
				color.g = 1;
				color.b = 0;
				color.a = 1;
				Utils3D._drawBound(debugTool, (renders[i] as BaseRender).boundingBox, color);
			}
		}
		
		/**
		 * @private
		 */
		private static function _traversalCulling(camera:Camera, scene:Scene3D, context:RenderContext3D, renderList:SingletonList):void {
			var validCount:int = renderList.length;
			var renders:Vector.<ISingletonElement> = renderList.elements;
			var boundFrustum:BoundFrustum = camera.boundFrustum;
			var camPos:Vector3 = camera._transform.position;
			for (var i:int = 0; i < validCount; i++) {
				var render:BaseRender = renders[i] as BaseRender;
				if (camera._isLayerVisible(render._owner._layer) && render._enable) {
					Stat.frustumCulling++;
					if (!camera.useOcclusionCulling||render._needRender(boundFrustum)) {
						render._visible = true;
						render._distanceForSort = Vector3.distance(render.boundingSphere.center, camPos);//TODO:合并计算浪费,或者合并后取平均值
						var elements:Vector.<RenderElement> = render._renderElements;
						for (var j:int = 0, m:int = elements.length; j < m; j++) {
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
				} else {
					render._visible = false;
				}
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
			
			var octree:BoundsOctree = scene._octree;
			if (octree) {
				octree.updateMotionObjects();
				octree.shrinkRootIfPossible();
				octree.getCollidingWithFrustum(context);
			} else {
				_traversalCulling(camera, scene, context, renderList);
			}
			
			if (Laya3D._config.debugFrustumCulling) {
				var debugTool:PixelLineSprite3D = scene._debugTool;
				debugTool.clear();
				if (octree) {
					octree.drawAllBounds(debugTool);
					octree.drawAllObjects(debugTool);
				} else {
					_drawTraversalCullingBound(renderList, debugTool);
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
			
			var camPos:Vector3 = context.camera._transform.position;
			for (i = 0; i < validCount; i++) {
				var render:BaseRender = renders[i] as BaseRender;
				if (camera._isLayerVisible(render._owner._layer) && render._enable && scene._cullingBufferResult[i]) {//TODO:需要剥离部分函数
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