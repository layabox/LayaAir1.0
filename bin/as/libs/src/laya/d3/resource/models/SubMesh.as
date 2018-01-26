package laya.d3.resource.models {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.utils.Utils3D;
	import laya.resource.IDispose;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>SubMesh</code> 类用于创建子网格数据模板。
	 */
	public class SubMesh implements IRenderable, IDispose {
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
		private var _mesh:Mesh;
		
		/** @private */
		public var _boneIndicesList:Vector.<Uint8Array>;
		/** @private */
		public var _subIndexBufferStart:Vector.<int>;
		/** @private */
		public var _subIndexBufferCount:Vector.<int>;
		/** @private */
		public var _skinAnimationDatas:Vector.<Float32Array>;
		
		/** @private */
		public var _bufferUsage:*;
		/** @private */
		public var _indexInMesh:int;
		
		/** @private */
		public var _vertexBuffer:VertexBuffer3D;
		/** @private */
		public var _vertexStart:int;
		/** @private */
		public var _vertexCount:int;
		/** @private */
		public var _indexBuffer:IndexBuffer3D;
		/** @private */
		public var _indexStart:int;
		/** @private */
		public var _indexCount:int;
		/** @private */
		public var _indices:Uint16Array;
		
		/**
		 * @private
		 */
		public function get _vertexBufferCount():int {
			return 1;
		}
		
		/**
		 * @private
		 */
		public function get triangleCount():int {
			return _indexBuffer.indexCount / 3;
		}
		
		/**
		 * 创建一个 <code>SubMesh</code> 实例。
		 * @param	mesh  网格数据模板。
		 */
		public function SubMesh(mesh:Mesh) {
			_bufferUsage = {};
			_mesh = mesh;
			_boneIndicesList = new Vector.<Uint8Array>();
			_subIndexBufferStart = new Vector.<int>();
			_subIndexBufferCount = new Vector.<int>();
		}
		
		/**
		 * @private
		 */
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer;
			else
				return null;
		}
		
		/**
		 * @private
		 */
		public function _getIndexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
		/**
		 * @private
		 */
		public function _getStaticBatchBakedVertexs(batchOwnerTransform:Transform3D, owner:MeshSprite3D):Float32Array {
			const byteSizeInFloat:int = 4;
			var vertexBuffer:VertexBuffer3D = _vertexBuffer;
			var vertexDeclaration:VertexDeclaration = vertexBuffer.vertexDeclaration;
			var positionOffset:int = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.POSITION0).offset / byteSizeInFloat;
			var normalOffset:int = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.NORMAL0).offset / byteSizeInFloat;
			var lightmapScaleOffset:Vector4 = owner.meshRender.lightmapScaleOffset;//TODO:用lightMapIndex判断更为合理
			
			var i:int, n:int, bakedVertexes:Float32Array, bakedVertexFloatCount:int, lightingMapTexcoordOffset:int, uv1Element:VertexElement;
			var uv0Offset:int, oriVertexFloatCount:int;
			if (lightmapScaleOffset) {
				uv1Element = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.TEXTURECOORDINATE1);
				if (uv1Element) {
					bakedVertexFloatCount = vertexDeclaration.vertexStride / byteSizeInFloat;
					if (_vertexCount > 0)
						bakedVertexes = vertexBuffer.getData().slice(_vertexStart * bakedVertexFloatCount, (_vertexStart + _vertexCount) * bakedVertexFloatCount) as Float32Array;//TODO:_vertexStart、_vertexCount是否正确
					else//兼容性代码
						bakedVertexes = vertexBuffer.getData().slice() as Float32Array;
					lightingMapTexcoordOffset = uv1Element.offset / byteSizeInFloat;
				} else {
					oriVertexFloatCount = vertexDeclaration.vertexStride / byteSizeInFloat;
					bakedVertexFloatCount = oriVertexFloatCount + 2;
					if (_vertexCount)
						bakedVertexes = new Float32Array(_vertexCount * (vertexBuffer.vertexDeclaration.vertexStride / byteSizeInFloat + 2));
					else//兼容性代码
						bakedVertexes = new Float32Array(vertexBuffer.vertexCount * (vertexBuffer.vertexDeclaration.vertexStride / byteSizeInFloat + 2));
					uv0Offset = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.TEXTURECOORDINATE0).offset / byteSizeInFloat;
					lightingMapTexcoordOffset = uv0Offset + 2;
					
					//var oriVertexes:Float32Array;
					//if (_vertexCount > 0)//todo:
					//oriVertexes = vertexBuffer.getData().slice(_vertexStart * oriVertexFloatCount, (_vertexStart + _vertexCount) * oriVertexFloatCount) as Float32Array
					//else//兼容性代码
					var oriVertexes:Float32Array = vertexBuffer.getData();
					for (i = 0, n = oriVertexes.length / oriVertexFloatCount; i < n; i++) {
						var oriVertexOffset:int;
						if (_vertexCount > 0)
							oriVertexOffset = (_vertexStart + i) * oriVertexFloatCount;
						else//兼容性代码
							oriVertexOffset = i * oriVertexFloatCount;
						var bakedVertexOffset:int = i * bakedVertexFloatCount;
						var j:int;
						for (j = 0; j < lightingMapTexcoordOffset; j++)
							bakedVertexes[bakedVertexOffset + j] = oriVertexes[oriVertexOffset + j];
						for (j = lightingMapTexcoordOffset; j < oriVertexFloatCount; j++)
							bakedVertexes[bakedVertexOffset + j + 2] = oriVertexes[oriVertexOffset + j];
						
					}
				}
			} else {
				bakedVertexFloatCount = vertexDeclaration.vertexStride / byteSizeInFloat;
				if (_vertexCount)
					bakedVertexes = vertexBuffer.getData().slice(_vertexStart * bakedVertexFloatCount, (_vertexStart + _vertexCount) * bakedVertexFloatCount) as Float32Array;
				else//兼容性代码
					bakedVertexes = vertexBuffer.getData().slice() as Float32Array;
			}
			
			if (batchOwnerTransform) {
				var rootMat:Matrix4x4 = batchOwnerTransform.worldMatrix;
				var rootInvertMat:Matrix4x4 = _tempMatrix4x40;
				rootMat.invert(rootInvertMat);
				var result:Matrix4x4 = _tempMatrix4x41;
				var transform:Matrix4x4 = owner.transform.worldMatrix;
				Matrix4x4.multiply(rootInvertMat, transform, result);
			} else {
				result = owner.transform.worldMatrix;
					//trace(owner.transform.worldMatrix.elements);
			}
			
			var rotation:Quaternion = _tempQuaternion0;
			result.decomposeTransRotScale(_tempVector30, rotation, _tempVector31);//可不计算position和scale
			
			for (i = 0, n = bakedVertexes.length / bakedVertexFloatCount; i < n; i++) {
				var posOffset:int = i * bakedVertexFloatCount + positionOffset;
				var norOffset:int = i * bakedVertexFloatCount + normalOffset;
				
				Utils3D.transformVector3ArrayToVector3ArrayCoordinate(bakedVertexes, posOffset, result, bakedVertexes, posOffset);
				Utils3D.transformVector3ArrayByQuat(bakedVertexes, norOffset, rotation, bakedVertexes, norOffset);
				
				if (lightmapScaleOffset) {//TODO:待修改。
					var lightingMapTexOffset:int = i * bakedVertexFloatCount + lightingMapTexcoordOffset;
					if (uv1Element) {
						Utils3D.transformLightingMapTexcoordByUV1Array(bakedVertexes, lightingMapTexOffset, lightmapScaleOffset, bakedVertexes, lightingMapTexOffset);
					} else {
						var tex0Offset:int = i * oriVertexFloatCount + uv0Offset;
						Utils3D.transformLightingMapTexcoordByUV0Array(oriVertexes, tex0Offset, lightmapScaleOffset, bakedVertexes, lightingMapTexOffset);
					}
				}
			}
			return bakedVertexes;
		}
		
		/**
		 * @private
		 */
		public function _getVertexBuffers():Vector.<VertexBuffer3D>{
			return null;
		}
		
		/**
		 * @private
		 */
		public function _beforeRender(state:RenderState):Boolean {
			_vertexBuffer._bind();
			_indexBuffer._bind();
			return true;
		}
		
		/**
		 * @private
		 * 渲染。
		 * @param	state 渲染状态。
		 */
		public function _render(state:RenderState):void {
			var skinAnimationDatas:Vector.<Float32Array>;
			var indexCount:int = 0;
			var renderElement:SubMeshRenderElement = state.renderElement as SubMeshRenderElement;
			if (_indexCount > 1) {
				var boneIndicesListCount:int = _boneIndicesList.length;
				if (boneIndicesListCount > 1) {
					for (var i:int = 0; i < boneIndicesListCount; i++) {
						skinAnimationDatas = renderElement._skinAnimationDatas || _skinAnimationDatas;//逻辑或后为兼容代码
						if (skinAnimationDatas) {
							renderElement._shaderValue.setValue(SkinnedMeshSprite3D.BONES, skinAnimationDatas[i]);
							state._shader.uploadRenderElementUniforms(renderElement._shaderValue.data);//TODO:如果未来有其它RenderElementUniforms是否会重复上传
						}
						WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, _subIndexBufferCount[i], WebGLContext.UNSIGNED_SHORT, _subIndexBufferStart[i] * 2);
					}
					Stat.drawCall += boneIndicesListCount;
				} else {
					skinAnimationDatas = renderElement._skinAnimationDatas || _skinAnimationDatas;//逻辑或后为兼容代码
					if (skinAnimationDatas) {
						renderElement._shaderValue.setValue(SkinnedMeshSprite3D.BONES, skinAnimationDatas[0]);
						state._shader.uploadRenderElementUniforms(renderElement._shaderValue.data);
					}
					WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, _indexCount, WebGLContext.UNSIGNED_SHORT, _indexStart * 2);
					Stat.drawCall++;
				}
				indexCount = _indexCount;
			} else {//TODO:兼容旧格式
				indexCount = _indexBuffer.indexCount;
				skinAnimationDatas = renderElement._skinAnimationDatas || _skinAnimationDatas;//逻辑或后为兼容代码
				if (skinAnimationDatas) {
					renderElement._shaderValue.setValue(SkinnedMeshSprite3D.BONES, skinAnimationDatas[0]);
					state._shader.uploadRenderElementUniforms(renderElement._shaderValue.data);
				}
				WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, 0);
				Stat.drawCall++;
			}
			Stat.trianglesFaces += indexCount / 3;
		}
		
		/**
		 * @private
		 */
		public function getIndices():Uint16Array {
			if (_indexCount > 0)
				return _indices;
			else//兼容性代码
				return _indexBuffer.getData();
		}
		
		/**
		 * <p>彻底清理资源。</p>
		 * <p><b>注意：</b>会强制解锁清理。</p>
		 */
		public function dispose():void {
			_indexBuffer.destroy();
			_vertexBuffer.destroy();
			_mesh = null;
			_boneIndicesList = null;
			_subIndexBufferStart = null;
			_subIndexBufferCount = null;
			_skinAnimationDatas = null;
			_bufferUsage = null;
			_vertexBuffer = null;
			_indexBuffer = null;
		}
		
		/**NATIVE*/
		public function _renderRuntime(conchGraphics3D:*, renderElement:RenderElement, state:RenderState):void {
			var material:BaseMaterial = renderElement._material, owner:Sprite3D = renderElement._sprite3D;
			//TODO NATIVE scene的shaderValue
			/*
			   var datas:Array=state.scene._shaderValues.data;
			   var len:int = datas.length;
			   for (var i:int = 0; i < len; i ++) {
			   var data:*= datas[i];
			   //(data)&&(renderElement._conchSubmesh.setShaderValue(i, data));
			   }
			 */
			conchGraphics3D.drawSubmesh(renderElement._conchSubmesh, 0, WebGLContext.TRIANGLES, 0, _indexBuffer.indexCount);
		}
	
	}
}