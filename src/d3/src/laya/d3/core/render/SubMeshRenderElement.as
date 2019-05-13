package laya.d3.core.render {
	import laya.d3.core.GeometryElement;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.graphics.MeshRenderDynamicBatchManager;
	import laya.d3.graphics.MeshRenderStaticBatchManager;
	import laya.d3.graphics.SubMeshDynamicBatch;
	import laya.d3.graphics.SubMeshInstanceBatch;
	import laya.d3.graphics.SubMeshStaticBatch;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 */
	public class SubMeshRenderElement extends RenderElement {
		/** @private */
		private static var _maxInstanceCount:int = 1024;
		/** @private */
		private static var _instanceMatrixData:Float32Array = new Float32Array(_maxInstanceCount * 16);
		/** @private */
		private static var _instanceMatrixBuffer:VertexBuffer3D = new VertexBuffer3D(_instanceMatrixData.length * 4, WebGLContext.DYNAMIC_DRAW);
		
		/** @private */
		private var _dynamicWorldPositionNormalNeedUpdate:Boolean;
		
		/** @private */
		public var _dynamicVertexBatch:Boolean;
		/** @private */
		public var _dynamicMultiSubMesh:Boolean;
		/** @private */
		public var _dynamicVertexCount:int;
		/** @private */
		public var _dynamicWorldPositions:Float32Array;
		/** @private */
		public var _dynamicWorldNormals:Float32Array;
		
		/** @private */
		public var staticBatchIndexStart:int;
		/** @private */
		public var staticBatchIndexEnd:int;
		/** @private */
		public var staticBatchElementList:Vector.<SubMeshRenderElement>;
		
		/** @private */
		public var instanceSubMesh:SubMesh;
		/** @private */
		public var instanceBatchElementList:Vector.<SubMeshRenderElement>;
		
		/** @private */
		public var vertexBatchElementList:Vector.<SubMeshRenderElement>;
		/** @private */
		public var vertexBatchVertexDeclaration:VertexDeclaration;
		
		
		/**
		 * 创建一个 <code>SubMeshRenderElement</code> 实例。
		 */
		public function SubMeshRenderElement() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_dynamicWorldPositionNormalNeedUpdate = true;
		}
		
		/**
		 * @private
		 */
		private function _onWorldMatrixChanged():void {
			_dynamicWorldPositionNormalNeedUpdate = true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function _computeWorldPositionsAndNormals(positionOffset:int, normalOffset:int, multiSubMesh:Boolean, vertexCount:int):void {
			if (_dynamicWorldPositionNormalNeedUpdate) {
				var subMesh:SubMesh = _geometry as SubMesh;
				var vertexBuffer:VertexBuffer3D = subMesh._vertexBuffer;
				var vertexFloatCount:int = vertexBuffer.vertexDeclaration.vertexStride / 4;
				var oriVertexes:Float32Array = vertexBuffer.getData() as Float32Array;
				var worldMat:Matrix4x4 = _transform.worldMatrix;
				var rotation:Quaternion = _transform.rotation;//TODO:是否换成矩阵
				var indices:Uint16Array = subMesh._indices;
				
				for (var i:int = 0; i < vertexCount; i++) {
					var index:int = multiSubMesh ? indices[i] : i;
					var oriOffset:int = index * vertexFloatCount;
					var bakeOffset:int = i * 3;
					Utils3D.transformVector3ArrayToVector3ArrayCoordinate(oriVertexes, oriOffset + positionOffset, worldMat, _dynamicWorldPositions, bakeOffset);
					(normalOffset !== -1) && (Utils3D.transformVector3ArrayByQuat(oriVertexes, oriOffset + normalOffset, rotation, _dynamicWorldNormals, bakeOffset));
				}
				
				_dynamicWorldPositionNormalNeedUpdate = false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setTransform(transform:Transform3D):void {
			if (_transform !== transform) {
				(_transform) && (_transform.off(Event.TRANSFORM_CHANGED, this, _onWorldMatrixChanged));
				(transform) && (transform.on(Event.TRANSFORM_CHANGED, this, _onWorldMatrixChanged));
				_dynamicWorldPositionNormalNeedUpdate = true;
				_transform = transform;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setGeometry(geometry:GeometryElement):void {
			if (_geometry !== geometry) {
				var subMesh:SubMesh = geometry as SubMesh;
				var mesh:Mesh = subMesh._mesh;
				if (mesh) {//TODO:可能是StaticSubMesh
					var multiSubMesh:Boolean = mesh._subMeshCount > 1;
					var dynBatVerCount:int = multiSubMesh ? subMesh._indexCount : mesh._vertexCount;
					if (dynBatVerCount <= SubMeshDynamicBatch.maxAllowVertexCount) {
						var length:int = dynBatVerCount * 3;
						_dynamicVertexBatch = true;
						_dynamicWorldPositions = new Float32Array(length);
						_dynamicWorldNormals = new Float32Array(length);
						_dynamicVertexCount = dynBatVerCount;
						_dynamicMultiSubMesh = multiSubMesh;
					} else {
						_dynamicVertexBatch = false;
					}
				}
				_geometry = geometry;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addToOpaqueRenderQueue(context:RenderContext3D, queue:RenderQueue):void {
			var subMeshStaticBatch:SubMeshStaticBatch = staticBatch as SubMeshStaticBatch;
			var elements:Array = queue.elements;
			if (subMeshStaticBatch) {
				var staManager:MeshRenderStaticBatchManager = MeshRenderStaticBatchManager.instance;
				var staBatchMarks:BatchMark = staManager.getBatchOpaquaMark(render.lightmapIndex + 1, render.receiveShadow, material.id, subMeshStaticBatch._batchID);
				if (staManager._updateCountMark === staBatchMarks.updateMark) {
					var staBatchIndex:int = staBatchMarks.indexInList;
					if (staBatchMarks.batched) {
						elements[staBatchIndex].staticBatchElementList.push(this);
					} else {
						var staOriElement:SubMeshRenderElement = elements[staBatchIndex];
						var staOriRender:BaseRender = staOriElement.render;
						var staBatchElement:SubMeshRenderElement = staManager._getBatchRenderElementFromPool() as SubMeshRenderElement;
						staBatchElement.renderType = RenderElement.RENDERTYPE_STATICBATCH;
						staBatchElement.setGeometry(subMeshStaticBatch);
						staBatchElement.material = staOriElement.material;
						var staRootOwner:Sprite3D = subMeshStaticBatch.batchOwner;
						var staBatchTransform:Transform3D = staRootOwner ? staRootOwner._transform : null;
						staBatchElement.setTransform(staBatchTransform);
						staBatchElement.render = staOriRender;
						var staBatchList:Vector.<SubMeshRenderElement> = staBatchElement.staticBatchElementList;
						staBatchList.length = 0;
						staBatchList.push(staOriElement as SubMeshRenderElement);
						staBatchList.push(this);
						elements[staBatchIndex] = staBatchElement;
						staBatchMarks.batched = true;
					}
				} else {
					staBatchMarks.updateMark = staManager._updateCountMark;
					staBatchMarks.indexInList = elements.length;
					staBatchMarks.batched = false;//是否已有大于两个的元素可合并
					elements.push(this);
				}
			} else if (material._shader._enableInstancing && WebGLContext._angleInstancedArrays) {//需要支持Instance渲染才可用
				var subMesh:SubMesh = _geometry as SubMesh;
				var insManager:MeshRenderDynamicBatchManager = MeshRenderDynamicBatchManager.instance;
				var insBatchMarks:BatchMark = insManager.getInstanceBatchOpaquaMark(render.lightmapIndex + 1, render.receiveShadow, material.id, subMesh._id);
				if (insManager._updateCountMark === insBatchMarks.updateMark) {
					var insBatchIndex:int = insBatchMarks.indexInList;
					if (insBatchMarks.batched) {
						var instanceBatchElementList:Vector.<SubMeshRenderElement> = elements[insBatchIndex].instanceBatchElementList;
						if (instanceBatchElementList.length === SubMeshInstanceBatch.instance.maxInstanceCount) {
							insBatchMarks.updateMark = insManager._updateCountMark;
							insBatchMarks.indexInList = elements.length;
							insBatchMarks.batched = false;//是否已有大于两个的元素可合并
							elements.push(this);
						} else {
							instanceBatchElementList.push(this);
						}
					} else {
						var insOriElement:SubMeshRenderElement = elements[insBatchIndex];
						var insOriRender:BaseRender = insOriElement.render;
						var insBatchElement:SubMeshRenderElement = insManager._getBatchRenderElementFromPool() as SubMeshRenderElement;//TODO:是否动态和静态方法可合并
						insBatchElement.renderType = RenderElement.RENDERTYPE_INSTANCEBATCH;
						insBatchElement.setGeometry(SubMeshInstanceBatch.instance);
						insBatchElement.material = insOriElement.material;
						insBatchElement.setTransform(null);
						insBatchElement.render = insOriRender;
						insBatchElement.instanceSubMesh = subMesh;
						var insBatchList:Vector.<SubMeshRenderElement> = insBatchElement.instanceBatchElementList;
						insBatchList.length = 0;
						insBatchList.push(insOriElement as SubMeshRenderElement);
						insBatchList.push(this);
						elements[insBatchIndex] = insBatchElement;
						insBatchMarks.batched = true;
					}
				} else {
					insBatchMarks.updateMark = insManager._updateCountMark;
					insBatchMarks.indexInList = elements.length;
					insBatchMarks.batched = false;//是否已有大于两个的元素可合并
					elements.push(this);
				}
			} else if (_dynamicVertexBatch) {
				var verDec:VertexDeclaration = (_geometry as SubMesh)._vertexBuffer.vertexDeclaration;
				var dynManager:MeshRenderDynamicBatchManager = MeshRenderDynamicBatchManager.instance;
				var dynBatchMarks:BatchMark = dynManager.getVertexBatchOpaquaMark(render.lightmapIndex + 1, render.receiveShadow, material.id, verDec.id);
				if (dynManager._updateCountMark === dynBatchMarks.updateMark) {
					var dynBatchIndex:int = dynBatchMarks.indexInList;
					if (dynBatchMarks.batched) {
						elements[dynBatchIndex].vertexBatchElementList.push(this);
					} else {
						var dynOriElement:SubMeshRenderElement = elements[dynBatchIndex];
						var dynOriRender:BaseRender = dynOriElement.render;
						var dynBatchElement:SubMeshRenderElement = dynManager._getBatchRenderElementFromPool() as SubMeshRenderElement;//TODO:是否动态和静态方法可合并
						dynBatchElement.renderType = RenderElement.RENDERTYPE_VERTEXBATCH;
						dynBatchElement.setGeometry(SubMeshDynamicBatch.instance);
						dynBatchElement.material = dynOriElement.material;
						dynBatchElement.setTransform(null);
						dynBatchElement.render = dynOriRender;
						dynBatchElement.vertexBatchVertexDeclaration = verDec;
						var dynBatchList:Vector.<SubMeshRenderElement> = dynBatchElement.vertexBatchElementList;
						dynBatchList.length = 0;
						dynBatchList.push(dynOriElement as SubMeshRenderElement);
						dynBatchList.push(this);
						elements[dynBatchIndex] = dynBatchElement;
						dynBatchMarks.batched = true;
					}
				} else {
					dynBatchMarks.updateMark = dynManager._updateCountMark;
					dynBatchMarks.indexInList = elements.length;
					dynBatchMarks.batched = false;//是否已有大于两个的元素可合并
					elements.push(this);
				}
			} else {
				elements.push(this);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addToTransparentRenderQueue(context:RenderContext3D, queue:RenderQueue):void {
			var subMeshStaticBatch:SubMeshStaticBatch = staticBatch as SubMeshStaticBatch;
			var elements:Array = queue.elements;
			if (subMeshStaticBatch) {
				var staManager:MeshRenderStaticBatchManager = MeshRenderStaticBatchManager.instance;
				var staLastElement:RenderElement = queue.lastTransparentRenderElement;
				if (staLastElement) {
					var staLastRender:BaseRender = staLastElement.render;
					if (staLastElement._geometry._getType() !== _geometry._getType() || staLastElement.staticBatch !== subMeshStaticBatch || staLastElement.material !== material || staLastRender.receiveShadow !== render.receiveShadow || staLastRender.lightmapIndex !== render.lightmapIndex) {
						elements.push(this);
						queue.lastTransparentBatched = false;
					} else {
						if (queue.lastTransparentBatched) {
							(elements[elements.length - 1] as SubMeshRenderElement).staticBatchElementList.push((this));
						} else {
							var staBatchElement:SubMeshRenderElement = staManager._getBatchRenderElementFromPool() as SubMeshRenderElement;
							staBatchElement.renderType = RenderElement.RENDERTYPE_STATICBATCH;
							staBatchElement.setGeometry(subMeshStaticBatch);
							staBatchElement.material = staLastElement.material;
							var staRootOwner:Sprite3D = subMeshStaticBatch.batchOwner;
							var staBatchTransform:Transform3D = staRootOwner ? staRootOwner._transform : null;
							staBatchElement.setTransform(staBatchTransform);
							staBatchElement.render = render;
							var staBatchList:Vector.<SubMeshRenderElement> = staBatchElement.staticBatchElementList;
							staBatchList.length = 0;
							staBatchList.push(staLastElement as SubMeshRenderElement);
							staBatchList.push(this);
							elements[elements.length - 1] = staBatchElement;
						}
						queue.lastTransparentBatched = true;
					}
				} else {
					elements.push(this);
					queue.lastTransparentBatched = false;
				}
			} else if (material._shader._enableInstancing && WebGLContext._angleInstancedArrays) {//需要支持Instance渲染才可用
				var subMesh:SubMesh = _geometry as SubMesh;
				var insManager:MeshRenderDynamicBatchManager = MeshRenderDynamicBatchManager.instance;
				var insLastElement:RenderElement = queue.lastTransparentRenderElement;
				if (insLastElement) {
					var insLastRender:BaseRender = insLastElement.render;
					if (insLastElement._geometry._getType() !== _geometry._getType() || (insLastElement._geometry as SubMesh)!== subMesh || insLastElement.material !== material || insLastRender.receiveShadow !== render.receiveShadow || insLastRender.lightmapIndex !== render.lightmapIndex) {
						elements.push(this);
						queue.lastTransparentBatched = false;
					} else {
						if (queue.lastTransparentBatched) {
							(elements[elements.length - 1] as SubMeshRenderElement).instanceBatchElementList.push((this));
						} else {
							var insBatchElement:SubMeshRenderElement = insManager._getBatchRenderElementFromPool() as SubMeshRenderElement;
							insBatchElement.renderType = RenderElement.RENDERTYPE_INSTANCEBATCH;
							insBatchElement.setGeometry(SubMeshInstanceBatch.instance);
							insBatchElement.material = insLastElement.material;
							insBatchElement.setTransform(null);
							insBatchElement.render = render;
							insBatchElement.instanceSubMesh = subMesh;
							var insBatchList:Vector.<SubMeshRenderElement> = insBatchElement.instanceBatchElementList;
							insBatchList.length = 0;
							insBatchList.push(insLastElement as SubMeshRenderElement);
							insBatchList.push(this);
							elements[elements.length - 1] = insBatchElement;
						}
						queue.lastTransparentBatched = true;
					}
				} else {
					elements.push(this);
					queue.lastTransparentBatched = false;
				}
				
			} else if (_dynamicVertexBatch) {
				var verDec:VertexDeclaration = (_geometry as SubMesh)._vertexBuffer.vertexDeclaration;
				var dynManager:MeshRenderDynamicBatchManager = MeshRenderDynamicBatchManager.instance;
				var dynLastElement:RenderElement = queue.lastTransparentRenderElement;
				if (dynLastElement) {
					var dynLastRender:BaseRender = dynLastElement.render;
					if (dynLastElement._geometry._getType() !== _geometry._getType() || (dynLastElement._geometry as SubMesh)._vertexBuffer._vertexDeclaration !== verDec || dynLastElement.material !== material || dynLastRender.receiveShadow !== render.receiveShadow || dynLastRender.lightmapIndex !== render.lightmapIndex) {
						elements.push(this);
						queue.lastTransparentBatched = false;
					} else {
						if (queue.lastTransparentBatched) {
							(elements[elements.length - 1] as SubMeshRenderElement).vertexBatchElementList.push((this));
						} else {
							var dynBatchElement:SubMeshRenderElement = dynManager._getBatchRenderElementFromPool() as SubMeshRenderElement;
							dynBatchElement.renderType = RenderElement.RENDERTYPE_VERTEXBATCH;
							dynBatchElement.setGeometry(SubMeshDynamicBatch.instance);
							dynBatchElement.material = dynLastElement.material;
							dynBatchElement.setTransform(null);
							dynBatchElement.render = render;
							dynBatchElement.vertexBatchVertexDeclaration = verDec;
							var dynBatchList:Vector.<SubMeshRenderElement> = dynBatchElement.vertexBatchElementList;
							dynBatchList.length = 0;
							dynBatchList.push(dynLastElement as SubMeshRenderElement);
							dynBatchList.push(this);
							elements[elements.length - 1] = dynBatchElement;
						}
						queue.lastTransparentBatched = true;
					}
				} else {
					elements.push(this);
					queue.lastTransparentBatched = false;
				}
			} else {
				elements.push(this);
			}
			queue.lastTransparentRenderElement = this;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			super.destroy();
			_dynamicWorldPositions = null;
			_dynamicWorldNormals = null;
			staticBatch = null;
			staticBatchElementList = null;
			vertexBatchElementList = null;
			vertexBatchVertexDeclaration = null;
		}
	}

}