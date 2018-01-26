package laya.d3.graphics {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.SubMeshRenderElement;
	
	/**
	 * @private
	 * <code>MeshSprite3DStaticBatchManager</code> 类用于网格精灵静态批处理管理。
	 */
	public class MeshSprite3DStaticBatchManager extends StaticBatchManager {
		/**
		 * @private
		 */
		public static function _sortPrepareStaticBatch(a:SubMeshRenderElement, b:SubMeshRenderElement):* {
			var aRender:BaseRender = a._render, bRender:BaseRender = b._render;
			var lightMapIndexOffset:int = aRender.lightmapIndex - bRender.lightmapIndex;
			if (lightMapIndexOffset === 0) {
				var receiveShadowValue:int = __JS__("aRender.receiveShadow - bRender.receiveShadow");
				if (receiveShadowValue === 0) {
					var mainID:int = a._mainSortID - b._mainSortID;
					if (mainID === 0) {
						return a.renderObj.triangleCount - b.renderObj.triangleCount;
					} else {
						return mainID;
					}
				} else {
					return receiveShadowValue;
				}
			} else {
				return lightMapIndexOffset;
			}
		
		}
		
		//private var _batchOwnerIndices:Vector.<Vector.<int>>;//TODO:
		///**@private */
		//private var _batchOwners:Vector.<MeshSprite3D>;//TODO:
		/**i
		 * 创建一个 <code>MeshSprite3DStaticBatchManager</code> 实例。
		 */
		public function MeshSprite3DStaticBatchManager() {
			//_batchOwnerIndices = new Vector.<Vector.<int>>();
			//_batchOwners = new Vector.<MeshSprite3D>();
		
		}
		
		/**
		 * @private
		 */
		private function _getStaticBatch(rootOwner:Sprite3D, vertexDeclaration:VertexDeclaration, material:BaseMaterial, number:int):SubMeshStaticBatch {
			var staticBatch:SubMeshStaticBatch;
			
			var key:String;
			if (rootOwner)
				key = rootOwner.id.toString() + material.id.toString() + vertexDeclaration.id.toString() + number.toString();//TODO:效率问题
			else
				key = material.id.toString() + vertexDeclaration.id.toString() + number.toString();//TODO:效率问题
			
			if (!_staticBatches[key])//TODO:是否需要判断
				_staticBatches[key] = staticBatch = new SubMeshStaticBatch(key, this, rootOwner, vertexDeclaration, material);
			else
				staticBatch = _staticBatches[key];
			
			return staticBatch;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _initStaticBatchs(rootOwner:Sprite3D):void {//TODO:多次调用合并重新分配问题以及_rootSprite3Ds删除问题。
			_initBatchRenderElements.sort(_sortPrepareStaticBatch);

			var lastMaterial:BaseMaterial;
			var lastVertexDeclaration:VertexDeclaration;
			var lastCanMerage:Boolean = false;
			var curStaticBatch:SubMeshStaticBatch;
		
			var batchNumber:int = 0;
			for (var i:int = 0, n:int = _initBatchRenderElements.length; i < n; i++) {
				var renderElement:RenderElement = _initBatchRenderElements[i];
				var vb:VertexBuffer3D = renderElement.renderObj._getVertexBuffer(0);
				var originalOwner:RenderableSprite3D = renderElement._sprite3D;
				if ((lastVertexDeclaration === vb.vertexDeclaration) && (lastMaterial === renderElement._material)) {
					var oldStaticBatch:SubMeshStaticBatch;
					if (!lastCanMerage) {
						var lastRenderObj:RenderElement = _initBatchRenderElements[i - 1];
						var lastRenderElement:IRenderable = lastRenderObj.renderObj;
						var curRenderElement:IRenderable = renderElement.renderObj;
						if (((lastRenderElement._getVertexBuffer().vertexCount + curRenderElement._getVertexBuffer().vertexCount) > StaticBatch.maxBatchVertexCount)) {
							lastCanMerage = false;
						} else {
							curStaticBatch = _getStaticBatch(rootOwner, lastVertexDeclaration, lastMaterial, batchNumber);//TODO:不以材质区分,材质为动态？
							
							oldStaticBatch = lastRenderObj._staticBatch as SubMeshStaticBatch;
							if (oldStaticBatch !== curStaticBatch) {
								(oldStaticBatch) && (oldStaticBatch._deleteCombineBatchRenderObj(lastRenderObj));
								curStaticBatch._addCombineBatchRenderObj(lastRenderObj);
							}
							
							oldStaticBatch = renderElement._staticBatch as SubMeshStaticBatch;
							if (oldStaticBatch !== curStaticBatch) {
								(oldStaticBatch) && (oldStaticBatch._deleteCombineBatchRenderObj(renderElement));
								curStaticBatch._addCombineBatchRenderObj(renderElement);
							}
							
							lastCanMerage = true;
						}
					} else {
						if (!curStaticBatch._addCombineBatchRenderObjTest(renderElement)) {
							lastCanMerage = false;
							batchNumber++;//修改编号，区分批处理。
						} else {
							oldStaticBatch = renderElement._staticBatch as SubMeshStaticBatch;
							if (oldStaticBatch !== curStaticBatch) {
								(oldStaticBatch) && (oldStaticBatch._deleteCombineBatchRenderObj(renderElement));
								curStaticBatch._addCombineBatchRenderObj(renderElement)
							}
						}
					}
				} else {
					lastCanMerage = false;
					batchNumber = 0;
				}
				lastMaterial = renderElement._material;
				lastVertexDeclaration = vb.vertexDeclaration;
			}
		}
	}
}