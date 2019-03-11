package laya.d3.graphics {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.core.scene.Scene3D;
	
	/**
	 * <code>StaticBatchManager</code> 类用于静态批处理管理的父类。
	 */
	public class StaticBatchManager {
		/** @private [只读]*/
		public static var _managers:Vector.<StaticBatchManager> = new Vector.<StaticBatchManager>();
		
		/**
		 * @private
		 */
		public static function _registerManager(manager:StaticBatchManager):void {
			_managers.push(manager);
		}
		
		/**
		 * @private
		 */
		private static function _addToStaticBatchQueue(sprite3D:Sprite3D):void {
			if (sprite3D is RenderableSprite3D && sprite3D.isStatic)
				(sprite3D as RenderableSprite3D)._addToInitStaticBatchManager();
			for (var i:int = 0, n:int = sprite3D.numChildren; i < n; i++)
				_addToStaticBatchQueue(sprite3D._children[i] as Sprite3D);
		}
		
		/**
		 * 静态批处理合并，合并后子节点修改Transform属性无效，根节点staticBatchRoot可为null,如果根节点不为null，根节点可移动。
		 * 如果renderableSprite3Ds为null，合并staticBatchRoot以及其所有子节点为静态批处理，staticBatchRoot作为静态根节点。
		 * 如果renderableSprite3Ds不为null,合并renderableSprite3Ds为静态批处理，staticBatchRoot作为静态根节点。
		 * @param staticBatchRoot 静态批处理根节点。
		 * @param renderableSprite3Ds 静态批处理子节点队列。
		 */
		public static function combine(staticBatchRoot:Sprite3D, renderableSprite3Ds:Vector.<RenderableSprite3D> = null):void {
			var i:int, n:int;
			if (renderableSprite3Ds) {
				for (i = 0, n = renderableSprite3Ds.length; i < n; i++) {
					var renderableSprite3D:RenderableSprite3D = renderableSprite3Ds[i];
					(renderableSprite3D.isStatic) && (renderableSprite3D._addToInitStaticBatchManager());
				}
			} else {
				if (staticBatchRoot)
					_addToStaticBatchQueue(staticBatchRoot);
			}
			for (i = 0, n = _managers.length; i < n; i++) {
				var manager:StaticBatchManager = _managers[i];
				manager._initStaticBatchs(staticBatchRoot);
			}
		}
		
		/** @private */
		protected var _batchRenderElementPool:Vector.<SubMeshRenderElement>;
		/** @private */
		protected var _batchRenderElementPoolIndex:int;
		/** @private */
		protected var _initBatchSprites:Vector.<RenderableSprite3D>;
		/** @private */
		protected var _staticBatches:Object;
		
		/**
		 * 创建一个 <code>StaticBatchManager</code> 实例。
		 */
		public function StaticBatchManager() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_initBatchSprites = new Vector.<RenderableSprite3D>();
			_staticBatches = {};
			_batchRenderElementPoolIndex = 0;
			_batchRenderElementPool = new Vector.<SubMeshRenderElement>();
		}
		
		/**
		 * @private
		 */
		private function _partition(items:Vector.<RenderableSprite3D>, left:int, right:int):int {
			var pivot:RenderableSprite3D = items[Math.floor((right + left) / 2)];
			while (left <= right) {
				while (_compare(items[left], pivot) < 0)
					left++;
				while (_compare(items[right], pivot) > 0)
					right--;
				if (left < right) {
					var temp:* = items[left];
					items[left] = items[right];
					items[right] = temp;
					left++;
					right--;
				} else if (left === right) {
					left++;
					break;
				}
			}
			return left;
		}
		
		/**
		 * @private
		 */
		protected function _quickSort(items:Vector.<RenderableSprite3D>, left:int, right:int):void {
			if (items.length > 1) {
				var index:int = _partition(items, left, right);
				var leftIndex:int = index - 1;
				if (left < leftIndex)
					_quickSort(items, left, leftIndex);
				
				if (index < right)
					_quickSort(items, index, right);
			}
		}
		
		/**
		 * @private
		 */
		protected function _compare(left:RenderableSprite3D, right:RenderableSprite3D):int {
			throw "StaticBatch:must override this function.";
		}
		
		/**
		 * @private
		 */
		protected function _initStaticBatchs(rootSprite:Sprite3D):void {
			throw "StaticBatch:must override this function.";
		}
		
		/**
		 * @private
		 */
		public function _getBatchRenderElementFromPool():RenderElement {
			throw "StaticBatch:must override this function.";
		}
		
		/**
		 * @private
		 */
		public function _addBatchSprite(renderableSprite3D:RenderableSprite3D):void {
			_initBatchSprites.push(renderableSprite3D);
		}
		
		/**
		 * @private
		 */
		public function _clear():void {
			_batchRenderElementPoolIndex = 0;
		}
		
		/**
		 * @private
		 */
		public function _garbageCollection():void {
			throw "StaticBatchManager: must override it.";
		}
		
		/**
		 * @private
		 */
		public function dispose():void {
			_staticBatches = null;
		}
	
	}

}