package laya.d3.graphics {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.scene.BaseScene;
	
	/**
	 * @private
	 * <code>StaticBatchManager</code> 类用于管理静态批处理。
	 */
	public class StaticBatchManager {
		private static function _sortPrepareStaticBatch(a:RenderElement, b:RenderElement):* {
			var id:int = a._mainSortID - b._mainSortID;
			return (id === 0) ? (a.renderObj.triangleCount - b.renderObj.triangleCount) : id;//TODO:是否可以去掉
		}
		
		private var _staticBatches:*;
		private var _prepareStaticBatchCombineElements:Array;
		
		public function StaticBatchManager() {
			_staticBatches = {};
			_prepareStaticBatchCombineElements = [];
		}
		
		/**完成合并*/
		private function _finshCombine():void {
			for (var key:String in _staticBatches)
				_staticBatches[key]._finshCombine();
		}
		
		public function getStaticBatch(rootSprite:Sprite3D, _vertexDeclaration:VertexDeclaration, material:BaseMaterial, number:int):StaticBatch {
			var staticBatch:StaticBatch;
			var key:String = rootSprite.id.toString() + material.id.toString() + _vertexDeclaration.id.toString() + number;
			
			if (!_staticBatches[key]) {
				_staticBatches[key] = staticBatch = new StaticBatch(rootSprite, _vertexDeclaration, material);
			} else {
				staticBatch = _staticBatches[key];
			}
			
			return staticBatch;
		}
		
		/** @private 通常应在所有getStaticBatchQneue函数相关操作结束后执行*/
		public function _garbageCollection():void {
			for (var key:String in _staticBatches)
				if (_staticBatches[key].combineRenderElementsCount === 0)//没有子物体的时候删除
					delete _staticBatches[key];
		}
		
		/** @private */
		public function _addPrepareRenderElement(renderElement:RenderElement):void {
			_prepareStaticBatchCombineElements.push(renderElement);
		}
		
		/** @private */
		public function _finishCombineStaticBatch(rootSprite:Sprite3D):void {
			_prepareStaticBatchCombineElements.sort(_sortPrepareStaticBatch);
			
			var lastMaterial:BaseMaterial;
			var lastVertexDeclaration:VertexDeclaration;
			var lastCanMerage:Boolean=false;
			var curStaticBatch:StaticBatch;
			
			var renderElement:RenderElement;
			var lastRenderObj:RenderElement;
			var vb:VertexBuffer3D;
			var oldStaticBatch:StaticBatch;
			
			var batchNumber:int = 0;
			for (var i:int = 0, n:int = _prepareStaticBatchCombineElements.length; i < n; i++) {
				renderElement = _prepareStaticBatchCombineElements[i];
				vb = renderElement.renderObj._getVertexBuffer(0);
				if ((lastVertexDeclaration === vb.vertexDeclaration) && (lastMaterial === renderElement._material)) {
					if (!lastCanMerage) {
						lastRenderObj = _prepareStaticBatchCombineElements[i - 1];
						var lastRenderElement:IRenderable = lastRenderObj.renderObj;
						var curRenderElement:IRenderable = renderElement.renderObj;
						if (((lastRenderElement._getVertexBuffer().vertexCount + curRenderElement._getVertexBuffer().vertexCount) > StaticBatch.maxVertexCount)) {
							lastCanMerage = false;
						} else {
							curStaticBatch = getStaticBatch(rootSprite, lastVertexDeclaration, lastMaterial, batchNumber);//TODO:不以材质区分？
							
							oldStaticBatch = lastRenderObj._staticBatch;
							(oldStaticBatch) && (oldStaticBatch !== curStaticBatch) && (oldStaticBatch._deleteCombineRenderObj(lastRenderObj));
							curStaticBatch._addCombineRenderObj(lastRenderObj);
							
							oldStaticBatch = renderElement._staticBatch;
							(oldStaticBatch) && (oldStaticBatch !== curStaticBatch) && (oldStaticBatch._deleteCombineRenderObj(renderElement));
							curStaticBatch._addCombineRenderObj(renderElement);
							lastCanMerage = true;
						}
					} else {
						if (!curStaticBatch._addCombineRenderObjTest(renderElement)) {
							lastCanMerage = false;
							batchNumber++;//修改编号，区分批处理。
						} else {
							oldStaticBatch = renderElement._staticBatch;
							(oldStaticBatch) && (oldStaticBatch !== curStaticBatch) && (oldStaticBatch._deleteCombineRenderObj(renderElement));
							curStaticBatch._addCombineRenderObj(renderElement)
						}
					}
				} else {
					lastCanMerage = false;
					batchNumber = 0;
				}
				lastMaterial = renderElement._material;
				lastVertexDeclaration = vb.vertexDeclaration;
			}
			_garbageCollection();
			_finshCombine();
			_prepareStaticBatchCombineElements.length = 0;
		}
		
		public function _clearRenderElements():void {
			for (var key:String in _staticBatches)
				_staticBatches[key]._clearRenderElements();
		}
		
		public function _addToRenderQueue(scene:BaseScene):void {
			for (var key:String in _staticBatches)
				_staticBatches[key]._addToRenderQueue(scene);
		}
		
		public function dispose():void {
			_staticBatches = null;
		}
	
	}

}