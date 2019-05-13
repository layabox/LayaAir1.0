package laya.d3.graphics {
	import laya.d3.core.BufferState;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.MeshRenderer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3.utils.Utils3D;
	import laya.layagl.LayaGL;
	import laya.resource.IDispose;
	import laya.resource.Resource;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 * <code>SubMeshStaticBatch</code> 类用于网格静态合并。
	 */
	public class SubMeshStaticBatch extends GeometryElement implements IDispose {
		/** @private */
		private static var _tempVector30:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector31:Vector3 = new Vector3();
		/** @private */
		private static var _tempQuaternion0:Quaternion = new Quaternion();
		/** @private */
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		/** @private */
		private static var _tempMatrix4x41:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		public static const maxBatchVertexCount:int = 65535;
		
		/** @private */
		private static var _batchIDCounter:int = 0;
		
		/** @private */
		private var _currentBatchVertexCount:int;
		/** @private */
		private var _currentBatchIndexCount:int;
		/** @private */
		private var _vertexDeclaration:VertexDeclaration;
		/**@private */
		private var _vertexBuffer:VertexBuffer3D;
		/**@private */
		private var _indexBuffer:IndexBuffer3D;
		/** @private */
		private var _bufferState:BufferState = new BufferState();
		
		/** @private */
		public var _batchElements:Vector.<RenderableSprite3D>;
		
		/** @private */
		public var _batchID:int;
		
		/** @private [只读]*/
		public var batchOwner:Sprite3D;
		/** @private [只读]*/
		public var number:int;
		
		/**
		 * 创建一个 <code>SubMeshStaticBatch</code> 实例。
		 */
		public function SubMeshStaticBatch(batchOwner:Sprite3D, number:int, vertexDeclaration:VertexDeclaration) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_batchID = _batchIDCounter++;
			_batchElements = new Vector.<RenderableSprite3D>();
			_currentBatchVertexCount = 0;
			_currentBatchIndexCount = 0;
			_vertexDeclaration = vertexDeclaration;
			this.batchOwner = batchOwner;
			this.number = number;
		
		}
		
		/**
		 * @private
		 */
		private function _getStaticBatchBakedVertexs(batchVertices:Float32Array, batchOffset:int, batchOwnerTransform:Transform3D, transform:Transform3D, render:MeshRenderer, mesh:Mesh):int {
			var vertexBuffer:VertexBuffer3D = mesh._vertexBuffers[0];
			var vertexDeclaration:VertexDeclaration = vertexBuffer.vertexDeclaration;
			var positionOffset:int = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_POSITION0).offset / 4;
			var normalElement:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_NORMAL0);
			var normalOffset:int = normalElement ? normalElement.offset / 4 : -1;
			var colorElement:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_COLOR0);
			var colorOffset:int = colorElement ? colorElement.offset / 4 : -1;
			var uv0Element:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_TEXTURECOORDINATE0);
			var uv0Offset:int = uv0Element ? uv0Element.offset / 4 : -1;
			var uv1Element:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_TEXTURECOORDINATE1);
			var uv1Offset:int = uv1Element ? uv1Element.offset / 4 : -1;
			var tangentElement:VertexElement = vertexDeclaration.getVertexElementByUsage(VertexMesh.MESH_TANGENT0);
			var sTangentOffset:int = tangentElement ? tangentElement.offset / 4 : -1;
			var bakeVertexFloatCount:int = 18;
			var oriVertexFloatCount:int = vertexDeclaration.vertexStride / 4;
			var oriVertexes:Float32Array = vertexBuffer.getData() as Float32Array;
			
			var worldMat:Matrix4x4;
			if (batchOwnerTransform) {
				var rootMat:Matrix4x4 = batchOwnerTransform.worldMatrix;
				rootMat.invert(_tempMatrix4x40);
				worldMat = _tempMatrix4x41;
				Matrix4x4.multiply(_tempMatrix4x40, transform.worldMatrix, worldMat);
			} else {
				worldMat = transform.worldMatrix;
			}
			var rotation:Quaternion = _tempQuaternion0;
			worldMat.decomposeTransRotScale(_tempVector30, rotation, _tempVector31);//可不计算position和scale	
			var lightmapScaleOffset:Vector4 = render.lightmapScaleOffset;
			
			var vertexCount:int = mesh.vertexCount;
			
			for (var i:int = 0; i < vertexCount; i++) {
				var oriOffset:int = i * oriVertexFloatCount;
				var bakeOffset:int = (i + batchOffset) * bakeVertexFloatCount;
				Utils3D.transformVector3ArrayToVector3ArrayCoordinate(oriVertexes, oriOffset + positionOffset, worldMat, batchVertices, bakeOffset + 0);
				if (normalOffset !== -1)
					Utils3D.transformVector3ArrayByQuat(oriVertexes, oriOffset + normalOffset, rotation, batchVertices, bakeOffset + 3);
				
				var j:int, m:int;
				var bakOff:int = bakeOffset + 6;
				if (colorOffset !== -1) {
					var oriOff:int = oriOffset + colorOffset;
					for (j = 0, m = 4; j < m; j++)
						batchVertices[bakOff + j] = oriVertexes[oriOff + j];
				} else {
					for (j = 0, m = 4; j < m; j++)
						batchVertices[bakOff + j] = 1.0;
				}
				
				if (uv0Offset !== -1) {
					var absUv0Offset:int = oriOffset + uv0Offset;
					batchVertices[bakeOffset + 10] = oriVertexes[absUv0Offset];
					batchVertices[bakeOffset + 11] = oriVertexes[absUv0Offset + 1];
				}
				
				if (lightmapScaleOffset) {
					if (uv1Offset !== -1)
						Utils3D.transformLightingMapTexcoordArray(oriVertexes, oriOffset + uv1Offset, lightmapScaleOffset, batchVertices, bakeOffset + 12);
					else
						Utils3D.transformLightingMapTexcoordArray(oriVertexes, oriOffset + uv0Offset, lightmapScaleOffset, batchVertices, bakeOffset + 12);
				}
				
				if (sTangentOffset !== -1) {
					var absSTanegntOffset:int = oriOffset + sTangentOffset;
					batchVertices[bakeOffset + 14] = oriVertexes[absSTanegntOffset];
					batchVertices[bakeOffset + 15] = oriVertexes[absSTanegntOffset + 1];
					batchVertices[bakeOffset + 16] = oriVertexes[absSTanegntOffset + 2];
					batchVertices[bakeOffset + 17] = oriVertexes[absSTanegntOffset + 3];
				}
			}
			return vertexCount;
		}
		
		/**
		 * @private
		 */
		public function addTest(sprite:RenderableSprite3D):Boolean {
			var vertexCount:int;
			var subMeshVertexCount:int = ((sprite as MeshSprite3D).meshFilter.sharedMesh as Mesh).vertexCount;
			vertexCount = _currentBatchVertexCount + subMeshVertexCount;
			if (vertexCount > maxBatchVertexCount)
				return false;
			return true;
		}
		
		/**
		 * @private
		 */
		public function add(sprite:RenderableSprite3D):void {
			var oldStaticBatch:SubMeshStaticBatch = sprite._render._staticBatch as SubMeshStaticBatch;
			(oldStaticBatch) && (oldStaticBatch.remove(sprite));//重复合并需要从旧的staticBatch移除
			
			var mesh:Mesh = (sprite as MeshSprite3D).meshFilter.sharedMesh as Mesh;
			var subMeshVertexCount:int = mesh.vertexCount;
			_batchElements.push(sprite);
			
			var render:BaseRender = sprite._render;
			render._isPartOfStaticBatch = true;
			render._staticBatch = this;
			var renderElements:Vector.<RenderElement> = render._renderElements;
			for (var i:int = 0, n:int = renderElements.length; i < n; i++)
				renderElements[i].staticBatch = this;
			
			_currentBatchIndexCount += mesh._indexBuffer.indexCount;
			_currentBatchVertexCount += subMeshVertexCount;
		
		}
		
		/**
		 * @private
		 */
		public function remove(sprite:RenderableSprite3D):void {
			var mesh:Mesh = (sprite as MeshSprite3D).meshFilter.sharedMesh as Mesh;
			var index:int = _batchElements.indexOf(sprite);
			if (index !== -1) {
				_batchElements.splice(index, 1);
				
				var render:BaseRender = sprite._render;
				var renderElements:Vector.<RenderElement> = sprite._render._renderElements;
				for (var i:int = 0, n:int = renderElements.length; i < n; i++)
					renderElements[i].staticBatch = null;
				
				var meshVertexCount:int = mesh.vertexCount;
				_currentBatchIndexCount = _currentBatchIndexCount - mesh._indexBuffer.indexCount;
				_currentBatchVertexCount = _currentBatchVertexCount - meshVertexCount;
				sprite._render._isPartOfStaticBatch = false;
			}
		}
		
		/**
		 * @private
		 */
		public function finishInit():void {//TODO:看下优化
			if (_vertexBuffer) {
				_vertexBuffer.destroy();
				_indexBuffer.destroy();
			}
			var batchVertexCount:int = 0;
			var batchIndexCount:int = 0;
			
			var rootOwner:Sprite3D = batchOwner;
			var floatStride:int = _vertexDeclaration.vertexStride / 4;
			var vertexDatas:Float32Array = new Float32Array(floatStride * _currentBatchVertexCount);
			var indexDatas:Uint16Array = new Uint16Array(_currentBatchIndexCount);
			_vertexBuffer = new VertexBuffer3D(_vertexDeclaration.vertexStride * _currentBatchVertexCount, WebGLContext.STATIC_DRAW);
			_vertexBuffer.vertexDeclaration = _vertexDeclaration;
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _currentBatchIndexCount, WebGLContext.STATIC_DRAW);
			
			for (var i:int = 0, n:int = _batchElements.length; i < n; i++) {
				var sprite:MeshSprite3D = _batchElements[i] as MeshSprite3D;
				var mesh:Mesh = sprite.meshFilter.sharedMesh as Mesh;
				var meshVerCount:int = _getStaticBatchBakedVertexs(vertexDatas, batchVertexCount, rootOwner ? rootOwner._transform : null, sprite._transform, (sprite._render as MeshRenderer), mesh);
				var indices:Uint16Array = mesh._indexBuffer.getData();
				var indexOffset:int = batchVertexCount;
				var indexEnd:int = batchIndexCount + indices.length;//TODO:indexStartCount和Index
				var elements:Vector.<RenderElement> = sprite._render._renderElements;
				for (var j:int = 0, m:int = mesh.subMeshCount; j < m; j++) {
					var subMesh:SubMesh = mesh._subMeshes[j];
					var start:int = batchIndexCount + subMesh._indexStart;
					var element:SubMeshRenderElement = elements[j] as SubMeshRenderElement;
					element.staticBatchIndexStart = start;
					element.staticBatchIndexEnd = start + subMesh._indexCount;
				}
				
				indexDatas.set(indices, batchIndexCount);//TODO:换成函数和动态合并一样
				var k:int;
				var isInvert:Boolean = rootOwner ? (sprite._transform._isFrontFaceInvert !== rootOwner.transform._isFrontFaceInvert) : sprite._transform._isFrontFaceInvert;
				if (isInvert) {
					for (k = batchIndexCount; k < indexEnd; k += 3) {
						indexDatas[k] = indexOffset + indexDatas[k];
						var index1:int = indexDatas[k + 1];
						var index2:int = indexDatas[k + 2];
						indexDatas[k + 1] = indexOffset + index2;
						indexDatas[k + 2] = indexOffset + index1;
					}
				} else {
					for (k = batchIndexCount; k < indexEnd; k += 3) {
						indexDatas[k] = indexOffset + indexDatas[k];
						indexDatas[k + 1] = indexOffset + indexDatas[k + 1];
						indexDatas[k + 2] = indexOffset + indexDatas[k + 2];
					}
				}
				batchIndexCount += indices.length;
				batchVertexCount += meshVerCount;
			}
			_vertexBuffer.setData(vertexDatas);
			_indexBuffer.setData(indexDatas);
			var memorySize:int = _vertexBuffer._byteLength + _indexBuffer._byteLength;
			Resource._addGPUMemory(memorySize);
			
			_bufferState.bind();
			_bufferState.applyVertexBuffer(_vertexBuffer);
			_bufferState.applyIndexBuffer(_indexBuffer);
			_bufferState.unBind();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _render(state:RenderContext3D):void {
			_bufferState.bind();
			var element:RenderElement = state.renderElement;
			var batchElementList:Vector.<SubMeshRenderElement> = (element as SubMeshRenderElement).staticBatchElementList;
			/*合并drawcall版本:合并几率不大*/
			var from:int = 0;
			var end:int = 0;
			var count:int = batchElementList.length;
			for (var i:int = 1; i < count; i++) {
				var lastElement:SubMeshRenderElement = batchElementList[i - 1];
				if (lastElement.staticBatchIndexEnd === batchElementList[i].staticBatchIndexStart) {
					end++;
					continue;
				} else {
					var start:int = batchElementList[from].staticBatchIndexStart;
					var indexCount:int = batchElementList[end].staticBatchIndexEnd - start;
					LayaGL.instance.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, start * 2);
					from = ++end;
					Stat.trianglesFaces += indexCount / 3;
				}
			}
			start = batchElementList[from].staticBatchIndexStart;
			indexCount = batchElementList[end].staticBatchIndexEnd - start;
			LayaGL.instance.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, start * 2);
			Stat.renderBatches++;
			Stat.savedRenderBatches += count - 1;
			Stat.trianglesFaces += indexCount / 3;
		/*暴力循环版本:drawcall调用次数有浪费
		   //for (var i:int = 0, n:int = batchElementList.length; i < n; i++) {
		   //var element:SubMeshRenderElement = batchElementList[i];
		   //var start:int = element.staticBatchIndexStart;
		   //var indexCount:int = element.staticBatchIndexEnd - start;
		   //LayaGL.instance.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, start * 2);
		   //Stat.drawCall++;
		   //Stat.trianglesFaces += indexCount / 3;
		   //}
		 */
		}
		
		/**
		 * @private
		 */
		public function dispose():void {
			var memorySize:int = _vertexBuffer._byteLength + _indexBuffer._byteLength;
			Resource._addGPUMemory(-memorySize);
			_batchElements = null;
			batchOwner = null;
			_vertexDeclaration = null;
			_bufferState.destroy();
			_vertexBuffer.destroy();
			_indexBuffer.destroy();
			_vertexBuffer = null;
			_indexBuffer = null;
			_bufferState = null;
		}
	
	}

}