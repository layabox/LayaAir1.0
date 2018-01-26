package laya.d3.graphics {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Matrix4x4;
	
	/**
	 * @private
	 * <code>StaticBatchManager</code> 类用于静态批处理管理的父类。
	 */
	public class StaticBatchManager {
		/** @private */
		public static var _staticBatchManagers:Vector.<StaticBatchManager> = new Vector.<StaticBatchManager>();//TODO:释放问题
		
		/**
		 * @private
		 */
		private static function _addToStaticBatchQueue(sprite3D:Sprite3D):void {
			if (sprite3D is RenderableSprite3D)
				(sprite3D as RenderableSprite3D)._addToInitStaticBatchManager();
			for (var i:int = 0, n:int = sprite3D.numChildren; i < n; i++)
				_addToStaticBatchQueue(sprite3D._childs[i] as Sprite3D);
		}
		
		/**
		 * 静态批处理合并，合并后子节点修改Transform属性无效，根节点staticBatchRoot可为null,如果根节点不为null，根节点可移动。
		 * 如果renderableSprite3Ds为null，合并staticBatchRoot以及其所有子节点为静态批处理，staticBatchRoot作为静态根节点。
		 * 如果renderableSprite3Ds不为null,合并renderableSprite3Ds为静态批处理，staticBatchRoot作为静态根节点。
		 * @param staticBatchRoot 静态批处理根节点。
		 * @param renderableSprite3Ds 静态批处理子节点队列。
		 */
		public static function combine(staticBatchRoot:Sprite3D, renderableSprite3Ds:Vector.<RenderableSprite3D> = null):void {
			var i:int, n:int, staticBatchManager:StaticBatchManager;
			if (renderableSprite3Ds) {
				for (i = 0, n = renderableSprite3Ds.length; i < n; i++) {
					var renderableSprite3D:RenderableSprite3D = renderableSprite3Ds[i];
					renderableSprite3D._addToInitStaticBatchManager();
				}
			} else {
				if (staticBatchRoot)
					_addToStaticBatchQueue(staticBatchRoot);
			}
			for (i = 0, n = _staticBatchManagers.length; i < n; i++) {
				staticBatchManager = _staticBatchManagers[i];
				staticBatchManager._initStaticBatchs(staticBatchRoot);
				staticBatchManager._finishInit();
			}
		}
		
		/** @private */
		protected var _initBatchRenderElements:Vector.<RenderElement>;
		/** @private */
		protected var _staticBatches:*;
		
		/**
		 * 创建一个 <code>StaticBatchManager</code> 实例。
		 */
		public function StaticBatchManager() {
			_initBatchRenderElements = new Vector.<RenderElement>();
			_staticBatches = {};
		}
		
		/**
		 * @private
		 */
		protected function _finishInit():void {
			for (var key:String in _staticBatches)
				_staticBatches[key]._finishInit();
			_initBatchRenderElements.length = 0;
		}
		
		/**
		 * @private
		 */
		protected function _initStaticBatchs(rootSprite:Sprite3D):void {
			throw new Error("StaticBatchManager:must override this function.");
		}
		
		/**
		 * @private
		 */
		public function _addInitBatchSprite(renderableSprite3D:RenderableSprite3D):void {
			var renderElements:Vector.<RenderElement> = renderableSprite3D._render._renderElements;
			for (var i:int = 0, n:int = renderElements.length; i < n; i++)
				_initBatchRenderElements.push(renderElements[i]);
		}
		
		/**
		 * @private
		 */
		public function _clearRenderElements():void {
			for (var key:String in _staticBatches)
				_staticBatches[key]._clearRenderElements();
		}
		
		/**
		 * @private
		 */
		public function _garbageCollection(renderElement:RenderElement):void {
			var staticBatch:StaticBatch = renderElement._staticBatch;
			var initBatchRenderElements:Vector.<RenderElement> = staticBatch._initBatchRenderElements;
			var index:int = initBatchRenderElements.indexOf(renderElement);
			initBatchRenderElements.splice(index, 1);
			if (initBatchRenderElements.length === 0) {
				staticBatch.dispose();
				delete _staticBatches[staticBatch._key];
			}
		}
		
		/**
		 * @private
		 */
		public function _addToRenderQueue(scene:Scene, view:Matrix4x4, projection:Matrix4x4, projectionView:Matrix4x4):void {
			for (var key:String in _staticBatches) {
				var staticBatch:StaticBatch = _staticBatches[key];
				if (staticBatch._batchRenderElements.length > 0)
					staticBatch._updateToRenderQueue(scene, projectionView);
			}
		}
		
		public function dispose():void {
			_staticBatches = null;
		}
	
	}

}