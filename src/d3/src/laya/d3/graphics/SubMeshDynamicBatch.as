package laya.d3.graphics {
	import laya.d3.core.BufferState;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.SubMesh;
	import laya.layagl.LayaGL;
	import laya.resource.Resource;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 * <code>SubMeshDynamicBatch</code> 类用于网格动态合并。
	 */
	public class SubMeshDynamicBatch extends GeometryElement {
		/** @private
		 * //MI6 (微信) 大于12个顶点微小提升
		 * //MI6 (QQ浏览器8.2 X5内核038230GPU-UU) 大于12个顶点微小提升
		 * //MI6 (chrome63) 大于10个顶点微小提升
		 * //IPHONE7PLUS  IOS11 微信 大于12个顶点微小提升
		 * //IPHONE5s  IOS8 微信 大于12仍有较大提升
		 */
		public static const maxAllowVertexCount:int = 10;
		/** @private */
		public static const maxAllowAttribueCount:int = 900;//TODO:
		/** @private */
		public static const maxIndicesCount:int = 32000;
		
		/** @private */
		public static var instance:SubMeshDynamicBatch;
		
		/**@private */
		private var _vertices:Float32Array;
		/**@private */
		private var _indices:Int16Array;
		/**@private */
		private var _positionOffset:int;
		/**@private */
		private var _normalOffset:int;
		/**@private */
		private var _colorOffset:int;
		/**@private */
		private var _uv0Offset:int;
		/**@private */
		private var _uv1Offset:int;
		/**@private */
		private var _sTangentOffset:int;
		/**@private */
		public var _vertexBuffer:VertexBuffer3D;
		/**@private */
		public var _indexBuffer:IndexBuffer3D;
		/** @private */
		private var _bufferState:BufferState = new BufferState();
		
		/**
		 * 创建一个 <code>SubMeshDynamicBatch</code> 实例。
		 */
		public function SubMeshDynamicBatch() {
			var maxVerDec:VertexDeclaration = VertexMesh.getVertexDeclaration("POSITION,NORMAL,COLOR,UV,UV1,TANGENT");
			var maxByteCount:int = maxVerDec.vertexStride * maxIndicesCount;
			_vertices = new Float32Array(maxByteCount / 4);
			_vertexBuffer = new VertexBuffer3D(maxByteCount, WebGLContext.DYNAMIC_DRAW);
			_indices = new Int16Array(SubMeshDynamicBatch.maxIndicesCount);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _indices.length, WebGLContext.DYNAMIC_DRAW);
			
			var memorySize:int = _vertexBuffer._byteLength + _indexBuffer._byteLength;
			Resource._addMemory(memorySize,memorySize);
		}
		
		/**
		 * @private
		 */
		private function _getBatchVertices(vertexDeclaration:VertexDeclaration, batchVertices:Float32Array, batchOffset:int, transform:Transform3D, element:SubMeshRenderElement, subMesh:SubMesh):void {
			var vertexFloatCount:int = vertexDeclaration.vertexStride / 4;
			var oriVertexes:Float32Array = subMesh._vertexBuffer.getData() as Float32Array;
			var lightmapScaleOffset:Vector4 = element.render.lightmapScaleOffset;
			
			var multiSubMesh:Boolean = element._dynamicMultiSubMesh;
			var vertexCount:int = element._dynamicVertexCount;
			element._computeWorldPositionsAndNormals(_positionOffset, _normalOffset, multiSubMesh, vertexCount);
			var worldPositions:Float32Array = element._dynamicWorldPositions;
			var worldNormals:Float32Array = element._dynamicWorldNormals;
			var indices:Uint16Array = subMesh._indices;
			for (var i:int = 0; i < vertexCount; i++) {
				var index:int = multiSubMesh ? indices[i] : i;
				var oriOffset:int = index * vertexFloatCount;
				var bakeOffset:int = (i + batchOffset) * vertexFloatCount;
				
				var oriOff:int = i * 3;
				var bakOff:int = bakeOffset + _positionOffset;
				batchVertices[bakOff] = worldPositions[oriOff];
				batchVertices[bakOff + 1] = worldPositions[oriOff + 1];
				batchVertices[bakOff + 2] = worldPositions[oriOff + 2];
				
				if (_normalOffset !== -1) {
					bakOff = bakeOffset + _normalOffset;
					batchVertices[bakOff] = worldNormals[oriOff];
					batchVertices[bakOff + 1] = worldNormals[oriOff + 1];
					batchVertices[bakOff + 2] = worldNormals[oriOff + 2];
				}
				
				if (_colorOffset !== -1) {
					bakOff = bakeOffset + _colorOffset;
					oriOff = oriOffset + _colorOffset;
					batchVertices[bakOff] = oriVertexes[oriOff];
					batchVertices[bakOff + 1] = oriVertexes[oriOff + 1];
					batchVertices[bakOff + 2] = oriVertexes[oriOff + 2];
					batchVertices[bakOff + 3] = oriVertexes[oriOff + 3];
				}
				
				if (_uv0Offset !== -1) {
					bakOff = bakeOffset + _uv0Offset;
					oriOff = oriOffset + _uv0Offset;
					batchVertices[bakOff] = oriVertexes[oriOff];
					batchVertices[bakOff + 1] = oriVertexes[oriOff + 1];
				}
				
				//if (lightmapScaleOffset) {//TODO:动态合并光照贴图UV如何处理
				//if (_uv1Offset !== -1)
				//Utils3D.transformLightingMapTexcoordByUV1Array(oriVertexes, oriOffset + _uv1Offset, lightmapScaleOffset, batchVertices, bakeOffset + _uv1Offset);
				//else
				//Utils3D.transformLightingMapTexcoordByUV0Array(oriVertexes, oriOffset + _uv0Offset, lightmapScaleOffset, batchVertices, bakeOffset + _uv1Offset);
				//}
				
				if (_sTangentOffset !== -1) {
					bakOff = bakeOffset + _sTangentOffset;
					oriOff = oriOffset + _sTangentOffset;
					batchVertices[bakOff] = oriVertexes[oriOff];
					batchVertices[bakOff + 1] = oriVertexes[oriOff + 1];
					batchVertices[bakOff + 2] = oriVertexes[oriOff + 2];
					batchVertices[bakOff + 3] = oriVertexes[oriOff + 3];
					
					bakOff = bakeOffset + _sTangentOffset;
					oriOff = oriOffset + _sTangentOffset;
					batchVertices[bakOff] = oriVertexes[oriOff];
					batchVertices[bakOff + 1] = oriVertexes[oriOff + 1];
					batchVertices[bakOff + 2] = oriVertexes[oriOff + 2];
					batchVertices[bakOff + 3] = oriVertexes[oriOff + 3];
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _getBatchIndices(batchIndices:Int16Array, batchIndexCount:int, batchVertexCount:int, transform:Transform3D, subMesh:SubMesh, multiSubMesh:Boolean):void {
			var subIndices:Uint16Array = subMesh._indices;
			var k:int, m:int, batchOffset:int;
			var isInvert:Boolean = transform._isFrontFaceInvert;
			if (multiSubMesh) {
				if (isInvert) {
					for (k = 0, m = subIndices.length; k < m; k += 3) {
						batchOffset = batchIndexCount + k;
						var index:int = batchVertexCount + k;
						batchIndices[batchOffset] = index;
						batchIndices[batchOffset + 1] = index + 2;
						batchIndices[batchOffset + 2] = index + 1;
					}
				} else {
					for (k = m, m = subIndices.length; k < m; k += 3) {
						batchOffset = batchIndexCount + k;
						index = batchVertexCount + k;
						batchIndices[batchOffset] = index;
						batchIndices[batchOffset + 1] = index + 1;
						batchIndices[batchOffset + 2] = index + 2;
					}
				}
			} else {
				if (isInvert) {
					for (k = 0, m = subIndices.length; k < m; k += 3) {
						batchOffset = batchIndexCount + k;
						batchIndices[batchOffset] = batchVertexCount + subIndices[k];
						batchIndices[batchOffset + 1] = batchVertexCount + subIndices[k + 2];
						batchIndices[batchOffset + 2] = batchVertexCount + subIndices[k + 1];
					}
				} else {
					for (k = m, m = subIndices.length; k < m; k += 3) {
						batchOffset = batchIndexCount + k;
						batchIndices[batchOffset] = batchVertexCount + subIndices[k];
						batchIndices[batchOffset + 1] = batchVertexCount + subIndices[k + 1];
						batchIndices[batchOffset + 2] = batchVertexCount + subIndices[k + 2];
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _flush(vertexCount:int, indexCount:int):void {
			_vertexBuffer.setData(_vertices, 0, 0, vertexCount * (_vertexBuffer.vertexDeclaration.vertexStride / 4));
			_indexBuffer.setData(_indices, 0, 0, indexCount);
			LayaGL.instance.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, 0);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _prepareRender(state:RenderContext3D):Boolean {
			var element:SubMeshRenderElement = state.renderElement as SubMeshRenderElement;
			var vertexDeclaration:VertexDeclaration = element.vertexBatchVertexDeclaration;
			_bufferState=MeshRenderDynamicBatchManager.instance._getBufferState(vertexDeclaration);
			
			_positionOffset = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_POSITION0).offset / 4;
			var normalElement:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_NORMAL0);
			_normalOffset = normalElement ? normalElement.offset / 4 : -1;
			var colorElement:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_COLOR0);
			_colorOffset = colorElement ? colorElement.offset / 4 : -1;
			var uv0Element:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_TEXTURECOORDINATE0);
			_uv0Offset = uv0Element ? uv0Element.offset / 4 : -1;
			var uv1Element:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_TEXTURECOORDINATE1);
			_uv1Offset = uv1Element ? uv1Element.offset / 4 : -1;
			var tangentElement:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_TANGENT0);
			_sTangentOffset = tangentElement ? tangentElement.offset / 4 : -1;
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _render(context:RenderContext3D):void {
			_bufferState.bind();
			var element:SubMeshRenderElement = context.renderElement as SubMeshRenderElement;
			var vertexDeclaration:VertexDeclaration = element.vertexBatchVertexDeclaration;
			var batchElements:Vector.<SubMeshRenderElement> = element.vertexBatchElementList;
			
			var batchVertexCount:int = 0;
			var batchIndexCount:int = 0;
			var floatStride:int = vertexDeclaration.vertexStride / 4;
			var renderBatchCount:int = 0;
			var elementCount:int = batchElements.length;
			for (var i:int = 0; i < elementCount; i++) {
				var subElement:SubMeshRenderElement = batchElements[i] as SubMeshRenderElement;
				var subMesh:SubMesh = subElement._geometry as SubMesh;
				var indexCount:int = subMesh._indexCount;
				if (batchIndexCount + indexCount > SubMeshDynamicBatch.maxIndicesCount) {
					_flush(batchVertexCount, batchIndexCount);
					renderBatchCount++;
					Stat.trianglesFaces += batchIndexCount / 3;
					batchVertexCount = batchIndexCount = 0;
				}
				var transform:Transform3D = subElement._transform;
				_getBatchVertices(vertexDeclaration, _vertices, batchVertexCount, transform, /*(element.render as MeshRender)*/ subElement, subMesh);
				_getBatchIndices(_indices, batchIndexCount, batchVertexCount, transform, subMesh, subElement._dynamicMultiSubMesh);
				batchVertexCount += subElement._dynamicVertexCount;
				batchIndexCount += indexCount;
			}
			_flush(batchVertexCount, batchIndexCount);
			renderBatchCount++;
			Stat.renderBatches += renderBatchCount;
			Stat.savedRenderBatches += elementCount - renderBatchCount;
			Stat.trianglesFaces += batchIndexCount / 3;
		}
	
	}

}