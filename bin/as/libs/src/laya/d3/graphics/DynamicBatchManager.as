package laya.d3.graphics {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.scene.BaseScene;
	
	/**
	 * @private
	 * <code>DynamicBatchManager</code> 类用于管理动态批处理。
	 */
	public class DynamicBatchManager {
		private static function _sortPrepareDynamicBatch(a:RenderElement, b:RenderElement):* {
			return a._mainSortID - b._mainSortID;
		}
		
		private var _dynamicBatches:*;
		private var _prepareDynamicBatchCombineElements:Array;
		
		public function DynamicBatchManager() {
			_dynamicBatches = {};
			_prepareDynamicBatchCombineElements = [];
		}
		
		public function getDynamicBatch(_vertexDeclaration:VertexDeclaration, number:int):DynamicBatch {
			var dynamicBatch:DynamicBatch;
			var key:String = _vertexDeclaration.id.toString() + number;
			if (!_dynamicBatches[key]) {
				_dynamicBatches[key] = dynamicBatch = new DynamicBatch(_vertexDeclaration);
			} else {
				dynamicBatch = _dynamicBatches[key];
			}
			return dynamicBatch;
		}
		
		/**需手动调用*/
		public function _garbageCollection():void {
			for (var key:String in _dynamicBatches)
				if (_dynamicBatches[key].combineRenderElementsCount === 0)
					delete _dynamicBatches[key];
		}
		
		public function _addPrepareRenderElement(renderElement:RenderElement):void {
			_prepareDynamicBatchCombineElements.push(renderElement);
		}
		
		/** @private */
		public function _finishCombineDynamicBatch(scene:BaseScene):void {
			_prepareDynamicBatchCombineElements.sort(_sortPrepareDynamicBatch);
			var lastMaterial:BaseMaterial;
			var lastVertexDeclaration:VertexDeclaration;
			var lastRenderElement:RenderElement;
			var lastBatchNumber:int = -1;
			var lastCanMerage:Boolean = true;
			
			var curMaterial:BaseMaterial;
			var curRenderElement:RenderElement;
			var curDynamicBatch:DynamicBatch;
			var curbatchNumber:int = 0;
			
			var laterAddMaterial:BaseMaterial;
			var laterAddRenderElement:RenderElement;
			var laterAddMatToElementOffset:int = -1;
			
			for (var i:int = 0, n:int = _prepareDynamicBatchCombineElements.length; i < n; i++) {
				curRenderElement = _prepareDynamicBatchCombineElements[i];
				
				var curDeclaration:VertexDeclaration = curRenderElement.renderObj._getVertexBuffer(0).vertexDeclaration;
				var declarationChanged:Boolean = (lastVertexDeclaration !== curDeclaration);
				declarationChanged && (curbatchNumber = 0, lastVertexDeclaration = curDeclaration);
				var batchNumbrChanged:Boolean = (curbatchNumber !== lastBatchNumber);
				batchNumbrChanged && (lastBatchNumber = curbatchNumber);
				if ((declarationChanged) || batchNumbrChanged) {
					curDynamicBatch = getDynamicBatch(curDeclaration, curbatchNumber);
					lastMaterial = null;//用于区别材质分割（包含不同材质和不同队列）
				}
				
				if (lastCanMerage) {
					if (curDynamicBatch._addCombineRenderObjTest(curRenderElement)) {
						curMaterial = curRenderElement._material;
						if (lastMaterial !== curMaterial) {
							if (laterAddMaterial) {
								scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
								laterAddMaterial = null;
								laterAddRenderElement = null;
								laterAddMatToElementOffset = -1;
							}
							laterAddMaterial = curMaterial;
							laterAddMatToElementOffset = curDynamicBatch.combineRenderElementsCount;
							laterAddRenderElement = curRenderElement;
							
							lastMaterial = curMaterial;
						} else {
							if (laterAddMaterial) {
								var lastRenderObj:IRenderable = laterAddRenderElement.renderObj;
								var curRenderObj:IRenderable = curRenderElement.renderObj;
								if (((lastRenderObj._getVertexBuffer().vertexCount + curRenderObj._getVertexBuffer().vertexCount) > DynamicBatch.maxVertexCount) || ((lastRenderObj._getIndexBuffer().indexCount + curRenderObj._getIndexBuffer().indexCount) > DynamicBatch.maxIndexCount)) {
									scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
									
									laterAddMaterial = curMaterial;
									laterAddMatToElementOffset = curDynamicBatch.combineRenderElementsCount;
									laterAddRenderElement = curRenderElement;
								} else {
									curDynamicBatch._addCombineMaterial(laterAddMaterial);
									curDynamicBatch._addMaterialToRenderElementOffset(laterAddMatToElementOffset);
									curDynamicBatch._addCombineRenderObj(laterAddRenderElement);
									laterAddMaterial = null;
									laterAddRenderElement = null;
									laterAddMatToElementOffset = -1;
									
									curDynamicBatch._addCombineRenderObj(curRenderElement);
								}
							} else {
								curDynamicBatch._addCombineRenderObj(curRenderElement);
							}
						}
						lastCanMerage = true;
					} else {
						if (laterAddMaterial) {
							scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
							laterAddMaterial = null;
							laterAddRenderElement = null;
							laterAddMatToElementOffset = -1;
						}
						
						curbatchNumber++;
						lastCanMerage = false;
					}
				} else {
					//新队列无需检测，一定可以加入前两个
					lastRenderElement = _prepareDynamicBatchCombineElements[i - 1];
					curDynamicBatch._addMaterialToRenderElementOffset(curDynamicBatch.combineRenderElementsCount);
					lastMaterial = lastRenderElement._material;
					curDynamicBatch._addCombineMaterial(lastMaterial);
					curDynamicBatch._addCombineRenderObj(lastRenderElement);
					lastCanMerage = true;
					
					curMaterial = curRenderElement._material;
					if (lastMaterial !== curMaterial) {
						laterAddMaterial = curMaterial;
						laterAddMatToElementOffset = curDynamicBatch.combineRenderElementsCount;
						laterAddRenderElement = curRenderElement;
					} else {
						curDynamicBatch._addCombineRenderObj(curRenderElement);
					}
					lastMaterial = curMaterial;
				}
			}
			
			if (laterAddMaterial) {
				scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
				laterAddMaterial = null;
				laterAddRenderElement = null;
				laterAddMatToElementOffset = -1;
			}
			_prepareDynamicBatchCombineElements.length = 0;
		}
		
		public function _clearRenderElements():void {
			for (var key:String in _dynamicBatches)
				_dynamicBatches[key]._clearRenderElements();
		}
		
		public function _addToRenderQueue(scene:BaseScene):void {
			for (var key:String in _dynamicBatches) {
				var dynamicBatch:DynamicBatch = _dynamicBatches[key];
				(dynamicBatch.combineRenderElementsCount > 0) && (dynamicBatch._addToRenderQueue(scene));
			}
		}
		
		public function dispose():void {
			_dynamicBatches = null;
		}
	
	}

}