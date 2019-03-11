package laya.d3.core.render {
	import laya.d3.core.BufferState;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.MeshRenderer;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.graphics.MeshRenderDynamicBatchManager;
	import laya.d3.graphics.MeshRenderStaticBatchManager;
	import laya.d3.graphics.SubMeshDynamicBatch;
	import laya.d3.graphics.SubMeshStaticBatch;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	
	/**
	 * @private
	 */
	public class SubMeshRenderElement extends RenderElement {
		/** @private */
		private var _dynamicWorldPositionNormalNeedUpdate:Boolean;
		
		/** @private */
		public var _dynamicBatch:Boolean;
		/** @private */
		public var _dynamicMultiSubMesh:Boolean;
		/** @private */
		public var _dynamicVertexCount:int;
		/** @private */
		public var _dynamicWorldPositions:Float32Array;
		/** @private */
		public var _dynamicWorldNormals:Float32Array;
		
		/** @private */
		public var skinnedDatas:Vector.<Float32Array>;
		/** @private */
		public var staticBatchIndexStart:int;
		/** @private */
		public var staticBatchIndexEnd:int;
		/** @private */
		public var staticBatchElementList:Vector.<SubMeshRenderElement>;
		/** @private */
		public var dynamicBatchElementList:Vector.<SubMeshRenderElement>;
		/** @private */
		public var dynamicVertexDeclaration:VertexDeclaration;
		
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
						_dynamicBatch = true;
						_dynamicWorldPositions = new Float32Array(length);
						_dynamicWorldNormals = new Float32Array(length);
						_dynamicVertexCount = dynBatVerCount;
						_dynamicMultiSubMesh = multiSubMesh;
					} else {
						_dynamicBatch = false;
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
				var staLightIndex:int = render.lightmapIndex + 1;
				var staLightMapMarks:Vector.<Vector.<Vector.<Array>>> = (staManager._opaqueBatchMarks[staLightIndex]) || (staManager._opaqueBatchMarks[staLightIndex] = new Vector.<Vector.<Vector.<Array>>>());
				var staReceiveShadowMarks:Vector.<Vector.<Array>> = (staLightMapMarks[render.receiveShadow ? 0 : 1]) || (staLightMapMarks[render.receiveShadow ? 0 : 1] = new Vector.<Vector.<Array>>());
				var staMaterialMarks:Vector.<Array> = (staReceiveShadowMarks[material.id]) || (staReceiveShadowMarks[material.id] = new Vector.<Array>());
				var staBatchMarks:Array = (staMaterialMarks[subMeshStaticBatch._batchID]) || (staMaterialMarks[subMeshStaticBatch._batchID] = new Array(3));
				if (staManager._updateCountMark === staBatchMarks[0]) {
					var staBatchIndex:int = staBatchMarks[1];
					if (staBatchMarks[2]) {
						elements[staBatchIndex].staticBatchElementList.push(this);
					} else {
						var staOriElement:SubMeshRenderElement = elements[staBatchIndex];
						var staOriRender:BaseRender = staOriElement.render;
						var staBatchElement:SubMeshRenderElement = staManager._getBatchRenderElementFromPool() as SubMeshRenderElement;
						staBatchElement.setGeometry(subMeshStaticBatch);
						staBatchElement.material = staOriElement.material;
						var staRootOwner:Sprite3D = subMeshStaticBatch.batchOwner._owner;
						var staBatchTransform:Transform3D = staRootOwner ? staRootOwner._transform : null;
						staBatchElement.setTransform(staBatchTransform);
						//staBatchElement.render = staOriRender;
						var staBatchRender:BaseRender = subMeshStaticBatch.batchOwner._getBatchRender(context, staOriRender.lightmapIndex, staOriRender.receiveShadow);//transfrom和MeshRender在一次渲染内不能穿插组合,例如多SubMesh模型中部分SubMesh合并
						staBatchRender._setBelongScene(context.scene);//内部需要关联场景光照贴图
						staBatchRender._distanceForSort = staOriRender._distanceForSort;
						staBatchElement.render = staBatchRender;
						var staBatchList:Vector.<SubMeshRenderElement> = staBatchElement.staticBatchElementList;
						staBatchList.length = 0;
						staBatchList.push(staOriElement as SubMeshRenderElement);
						staBatchList.push(this);
						elements[staBatchIndex] = staBatchElement;
						staBatchMarks[2] = true;
					}
				} else {
					staBatchMarks[0] = staManager._updateCountMark;
					staBatchMarks[1] = elements.length;
					staBatchMarks[2] = false;//是否已有大于两个的元素可合并
					elements.push(this);
				}
			} else {
				if (_dynamicBatch) {
					var verDec:VertexDeclaration = (_geometry as SubMesh)._vertexBuffer.vertexDeclaration;
					var dynManager:MeshRenderDynamicBatchManager = MeshRenderDynamicBatchManager.instance;
					var dynLightIndex:int = render.lightmapIndex + 1;
					var dynLightMapMarks:Vector.<Vector.<Vector.<Array>>> = (dynManager._opaqueBatchMarks[dynLightIndex]) || (dynManager._opaqueBatchMarks[dynLightIndex] = new Vector.<Vector.<Vector.<Array>>>());
					var dynReceiveShadowMarks:Vector.<Vector.<Array>> = (dynLightMapMarks[render.receiveShadow ? 0 : 1]) || (dynLightMapMarks[render.receiveShadow ? 0 : 1] = new Vector.<Vector.<Array>>());
					var dynMaterialMarks:Vector.<Array> = (dynReceiveShadowMarks[material.id]) || (dynReceiveShadowMarks[material.id] = new Vector.<Array>());
					var dynBatchMarks:Array = (dynMaterialMarks[verDec.id]) || (dynMaterialMarks[verDec.id] = new Array(3));
					if (dynManager._updateCountMark === dynBatchMarks[0]) {
						var dynBatchIndex:int = dynBatchMarks[1];
						if (dynBatchMarks[2]) {
							elements[dynBatchIndex].dynamicBatchElementList.push(this);
						} else {
							var dynOriElement:SubMeshRenderElement = elements[dynBatchIndex];
							var dynOriRender:BaseRender = dynOriElement.render;
							var dynBatchElement:SubMeshRenderElement = dynManager._getBatchRenderElementFromPool() as SubMeshRenderElement;//TODO:是否动态和静态方法可合并
							dynBatchElement.setGeometry(SubMeshDynamicBatch.instance);
							dynBatchElement.material = dynOriElement.material;
							dynBatchElement.setTransform(null);
							//dynBatchElement.render = dynOriRender;
							var dynBatchRender:MeshRenderer = dynManager._getBatchRender(dynOriRender.lightmapIndex, dynOriRender.receiveShadow);//transfrom和MeshRender在一次渲染内不能穿插组合,例如多SubMesh模型中部分SubMesh合并
							dynBatchRender._setBelongScene(context.scene);//内部需要关联场景光照贴图
							dynBatchRender._distanceForSort = dynOriRender._distanceForSort;
							dynBatchElement.render = dynBatchRender;
							dynBatchElement.dynamicVertexDeclaration = verDec;
							var dynBatchList:Vector.<SubMeshRenderElement> = dynBatchElement.dynamicBatchElementList;
							dynBatchList.length = 0;
							dynBatchList.push(dynOriElement as SubMeshRenderElement);
							dynBatchList.push(this);
							elements[dynBatchIndex] = dynBatchElement;
							dynBatchMarks[2] = true;
						}
					} else {
						dynBatchMarks[0] = dynManager._updateCountMark;
						dynBatchMarks[1] = elements.length;
						dynBatchMarks[2] = false;//是否已有大于两个的元素可合并
						elements.push(this);
					}
				} else {
					elements.push(this);
				}
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
							staBatchElement.setGeometry(subMeshStaticBatch);
							staBatchElement.material = staLastElement.material;
							var staRootOwner:Sprite3D = subMeshStaticBatch.batchOwner._owner;
							var staBatchTransform:Transform3D = staRootOwner ? staRootOwner._transform : null;
							staBatchElement.setTransform(staBatchTransform);
							//staBatchElement.render = staLastRender;
							var staBatchRender:BaseRender = subMeshStaticBatch.batchOwner._getBatchRender(context, staLastRender.lightmapIndex, staLastRender.receiveShadow);//transfrom和MeshRender在一次渲染内不能穿插组合,例如多SubMesh模型中部分SubMesh合并
							staBatchRender._setBelongScene(context.scene);//内部需要关联场景光照贴图
							staBatchRender._distanceForSort = staLastRender._distanceForSort;
							staBatchElement.render = staBatchRender;
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
			} else {
				if (_dynamicBatch) {
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
								(elements[elements.length - 1] as SubMeshRenderElement).dynamicBatchElementList.push((this));
							} else {
								var dynBatchElement:SubMeshRenderElement = dynManager._getBatchRenderElementFromPool() as SubMeshRenderElement;
								dynBatchElement.setGeometry(SubMeshDynamicBatch.instance);
								dynBatchElement.material = dynLastElement.material;
								dynBatchElement.setTransform(null);
								//dynBatchElement.render = dynLastRender;
								var dynBatchRender:MeshRenderer = dynManager._getBatchRender(dynLastRender.lightmapIndex, dynLastRender.receiveShadow);//transfrom和MeshRender在一次渲染内不能穿插组合,例如多SubMesh模型中部分SubMesh合并
								dynBatchRender._setBelongScene(context.scene);//内部需要关联场景光照贴图
								dynBatchRender._distanceForSort = dynLastRender._distanceForSort;
								dynBatchElement.render = dynBatchRender;
								dynBatchElement.dynamicVertexDeclaration = verDec;
								var dynBatchList:Vector.<SubMeshRenderElement> = dynBatchElement.dynamicBatchElementList;
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
			skinnedDatas = null;
			staticBatch = null;
			staticBatchElementList = null;
			dynamicBatchElementList = null;
			dynamicVertexDeclaration = null;
		}
	}

}