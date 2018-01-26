package laya.d3.graphics {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.SubMesh;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>SubMeshStaticBatch</code> 类用于网格静态合并。
	 */
	public class SubMeshStaticBatch extends StaticBatch {
		/**@private */
		private var _batchOwnerIndices:Vector.<Vector.<int>>;//TODO:是否静态
		/**@private */
		private var _batchOwners:Vector.<MeshSprite3D>;//TODO:是否静态
		
		/** @private */
		private var _needFinishCombine:Boolean;
		/** @private */
		private var _currentCombineVertexCount:int;
		/** @private */
		private var _currentCombineIndexCount:int;
		/** @private */
		public var _vertexDeclaration:VertexDeclaration;
		/** @private */
		private var _vertexBuffer:VertexBuffer3D;
		/** @private */
		private var _indexBuffer:IndexBuffer3D;
		
		/**
		 * 创建一个 <code>SubMeshStaticBatch</code> 实例。
		 */
		public function SubMeshStaticBatch(key:String, manager:StaticBatchManager, rootOwner:Sprite3D, vertexDeclaration:VertexDeclaration, material:BaseMaterial) {
			super(key, manager, rootOwner);
			_batchOwnerIndices = new Vector.<Vector.<int>>();
			_batchOwners = new Vector.<MeshSprite3D>();
			
			_needFinishCombine = false;
			_currentCombineVertexCount = 0;
			_currentCombineIndexCount = 0;
			
			_vertexDeclaration = vertexDeclaration;
			_material = material;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _compareBatchRenderElement(a:RenderElement, b:RenderElement):Boolean {
			return (a as SubMeshRenderElement)._batchIndexStart > (b as SubMeshRenderElement)._batchIndexStart;
		}
		
		/**
		 * @private
		 */
		public function _addCombineBatchRenderObjTest(renderElement:RenderElement):Boolean {
			var vertexCount:int;
			var subMeshVertexCount:int = (renderElement.renderObj as SubMesh)._vertexCount;
			if (subMeshVertexCount > 0)
				vertexCount = _currentCombineVertexCount + subMeshVertexCount;
			else//兼容性代码
				vertexCount = _currentCombineVertexCount + renderElement.renderObj._getVertexBuffer().vertexCount;
			if (vertexCount > maxBatchVertexCount)
				return false;
			return true;
		}
		
		/**
		 * @private
		 */
		public function _addCombineBatchRenderObj(renderElement:RenderElement):void {
			var subMesh:SubMesh = renderElement.renderObj as SubMesh;
			var subMeshVertexCount:int = subMesh._vertexCount;
			_initBatchRenderElements.push(renderElement);
			renderElement._staticBatch = this;
			if (subMeshVertexCount > 0) {
				_currentCombineIndexCount += subMesh._indexCount;
				_currentCombineVertexCount += subMeshVertexCount;
			} else {//兼容性代码
				_currentCombineIndexCount = _currentCombineIndexCount + subMesh._getIndexBuffer().indexCount;
				_currentCombineVertexCount = _currentCombineVertexCount + subMesh._getVertexBuffer().vertexCount;
			}
			_needFinishCombine = true;
		}
		
		/**
		 * @private
		 */
		public function _deleteCombineBatchRenderObj(renderElement:RenderElement):void {
			var subMesh:SubMesh = renderElement.renderObj as SubMesh;
			var index:int = _initBatchRenderElements.indexOf(renderElement);
			if (index !== -1) {
				_initBatchRenderElements.splice(index, 1);
				renderElement._staticBatch = null;
				var subMeshVertexCount:int = subMesh._vertexCount;
				if (subMeshVertexCount > 0) {
					_currentCombineIndexCount = _currentCombineIndexCount - subMesh._indexCount;
					_currentCombineVertexCount = _currentCombineVertexCount - subMeshVertexCount;
				} else {//兼容性代码
					_currentCombineIndexCount = _currentCombineIndexCount - subMesh._getIndexBuffer().indexCount;
					_currentCombineVertexCount = _currentCombineVertexCount - subMesh._getVertexBuffer().vertexCount;
				}
				_needFinishCombine = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _finishInit():void {
			if (_needFinishCombine) {//TODO:合并前应处理排序
				var curMerVerCount:int = 0;
				var curIndexCount:int = 0;
				//TODO:临时代码
				if (_initBatchRenderElements[0]._sprite3D._render.lightmapIndex >= 0) {
					_vertexDeclaration = _getVertexDecLightMap(_vertexDeclaration);//TODO:判断不优,修改后VB声明一致，是否可用静态合并，改良静态合并增加可能性
				} else {
					if (_material is StandardMaterial) {//兼容性代码
						if ((_material as StandardMaterial).ambientTexture)
							_vertexDeclaration = _getVertexDecLightMap(_vertexDeclaration);//TODO:判断不优,修改后VB声明一致，是否可用静态合并，改良静态合并增加可能性
					}
				}
				
				var vertexDatas:Float32Array = new Float32Array(_vertexDeclaration.vertexStride / 4 * _currentCombineVertexCount);
				var indexDatas:Uint16Array = new Uint16Array(_currentCombineIndexCount);
				
				if (_vertexBuffer) {
					_vertexBuffer.destroy();
					_indexBuffer.destroy();
				}
				_vertexBuffer = VertexBuffer3D.create(_vertexDeclaration, _currentCombineVertexCount, WebGLContext.STATIC_DRAW);
				_indexBuffer = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, _currentCombineIndexCount, WebGLContext.STATIC_DRAW);
				for (var i:int = 0, n:int = _initBatchRenderElements.length; i < n; i++) {
					var renderElement:SubMeshRenderElement = _initBatchRenderElements[i] as SubMeshRenderElement;
					var subMesh:SubMesh = renderElement.renderObj as SubMesh;
					var subVertexDatas:Float32Array = subMesh._getStaticBatchBakedVertexs(_rootOwner ? _rootOwner._transform : null, renderElement._sprite3D as MeshSprite3D);
					var subIndexDatas:Uint16Array = subMesh.getIndices();
					
					var isInvert:Boolean = renderElement._sprite3D.transform._isFrontFaceInvert;
					
					var indexOffset:int = curMerVerCount / (_vertexDeclaration.vertexStride / 4) - subMesh._vertexStart;
					var indexStart:int = curIndexCount;
					var indexEnd:int = indexStart + subIndexDatas.length;
					
					renderElement._batchIndexStart = indexStart;
					renderElement._batchIndexEnd = indexEnd;
					
					indexDatas.set(subIndexDatas, curIndexCount);
					
					var k:int;
					if (isInvert) {
						for (k = indexStart; k < indexEnd; k += 3) {
							indexDatas[k] = indexOffset + indexDatas[k];
							var index1:int = indexDatas[k + 1];
							var index2:int = indexDatas[k + 2];
							indexDatas[k + 1] = indexOffset + index2;
							indexDatas[k + 2] = indexOffset + index1;
						}
					} else {
						for (k = indexStart; k < indexEnd; k += 3) {
							indexDatas[k] = indexOffset + indexDatas[k];
							indexDatas[k + 1] = indexOffset + indexDatas[k + 1];
							indexDatas[k + 2] = indexOffset + indexDatas[k + 2];
						}
					}
					
					curIndexCount += subIndexDatas.length;
					
					vertexDatas.set(subVertexDatas, curMerVerCount);
					curMerVerCount += subVertexDatas.length;
				}
				
				_vertexBuffer.setData(vertexDatas);
				_indexBuffer.setData(indexDatas);
				_needFinishCombine = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _getCombineRenderElementFromPool():RenderElement {
			var renderElement:RenderElement = _combineRenderElementPool[_combineRenderElementPoolIndex++];
			return renderElement || (_combineRenderElementPool[_combineRenderElementPoolIndex - 1] = new SubMeshRenderElement());
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _getRenderElement(renderQueueElements:Array, scene:Scene, projectionView:Matrix4x4):void {
			var lastRenderElement:SubMeshRenderElement, renderElement:SubMeshRenderElement;
			var count:int = _batchRenderElements.length;
			var canMerge:Boolean = true;
			for (var i:int = 0; i < count; i++) {
				renderElement = _batchRenderElements[i] as SubMeshRenderElement;
				var render:BaseRender = renderElement._sprite3D._render;
				var lastRender:BaseRender;
				
				if (i !== 0) {
					lastRenderElement = _batchRenderElements[i - 1] as SubMeshRenderElement;
					lastRender = lastRenderElement._sprite3D._render;
					canMerge = (lastRender.lightmapIndex !== render.lightmapIndex || lastRender.receiveShadow !== render.receiveShadow || lastRenderElement._batchIndexEnd !== renderElement._batchIndexStart);
				}
				
				var merageElement:SubMeshRenderElement;
				if (canMerge) {
					merageElement = _getCombineRenderElementFromPool() as SubMeshRenderElement;
					merageElement.renderObj = this;
					merageElement._material = _material;
					merageElement._batchIndexStart = (renderElement as SubMeshRenderElement)._batchIndexStart;
					merageElement._batchIndexEnd = (renderElement as SubMeshRenderElement)._batchIndexEnd;
					
					//精灵对象池清理，移动到StaticBtachManager复用率更高。
					var lightMapIndex:int = render.lightmapIndex;
					var cacheLightMapIndex:int = lightMapIndex + 1;
					var lightMapBatchOwnerIndices:Vector.<int> = _batchOwnerIndices[cacheLightMapIndex];
					(lightMapBatchOwnerIndices) || (lightMapBatchOwnerIndices = _batchOwnerIndices[cacheLightMapIndex] = new Vector.<int>());
					var batchOwnerIndex:* = lightMapBatchOwnerIndices[renderElement._render.receiveShadow ? 1 : 0];
					var batchOwner:MeshSprite3D;
					if (batchOwnerIndex === undefined) {
						lightMapBatchOwnerIndices[render.receiveShadow ? 1 : 0] = _batchOwners.length;
						batchOwner = new MeshSprite3D(null, "StaticBatchMeshSprite3D");
						batchOwner._scene = scene;
						batchOwner._transform = _rootOwner ? _rootOwner._transform : null;
						batchOwner._render.lightmapIndex = lightMapIndex;
						batchOwner._render.receiveShadow = renderElement._render.receiveShadow;
						_batchOwners.push(batchOwner);
					} else {
						batchOwner = _batchOwners[batchOwnerIndex];
					}
					batchOwner._render._renderUpdate(projectionView);
					
					merageElement._sprite3D = batchOwner;
					renderQueueElements.push(merageElement);
				} else {
					merageElement._batchIndexEnd = (renderElement as SubMeshRenderElement)._batchIndexEnd;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _beforeRender(state:RenderState):Boolean {
			_vertexBuffer._bind();
			_indexBuffer._bind();
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _render(state:RenderState):void {
			var renderElement:SubMeshRenderElement = state.renderElement as SubMeshRenderElement;
			var batchIndexStart:int = renderElement._batchIndexStart;
			var indexCount:int = renderElement._batchIndexEnd - batchIndexStart;
			WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, batchIndexStart * 2);
			Stat.drawCall++;
			
			Stat.trianglesFaces += indexCount / 3;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void {
			_batchOwnerIndices = null;
			_batchOwners = null;
			_vertexDeclaration = null;
			_vertexBuffer.destroy();
			_indexBuffer.destroy();
		}
		
		//..................临时.................................
		override public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			return _vertexBuffer;
		}
		//..................临时.................................
	
	}

}