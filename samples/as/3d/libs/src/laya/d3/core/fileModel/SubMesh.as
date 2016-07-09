package laya.d3.core.fileModel {
	import laya.d3.core.material.Material;
	import laya.d3.core.render.IRender;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.graphics.VertexPositionNormalColorSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalColorTextureTangent;
	import laya.d3.graphics.VertexPositionNormalTextureSkinTangent;
	import laya.d3.graphics.VertexPositionNormalTextureTangent;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.tempelet.MeshTemplet;
	import laya.d3.resource.tempelet.SubMeshTemplet;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.ValusArray;
	import laya.webgl.utils.VertexBuffer2D;
	
	/**
	 * <code>SubMesh</code> 类用于创建子网格。
	 */
	public class SubMesh implements IRender {
		/** @private 子网格数据模板。*/
		private var _templet:SubMeshTemplet;
		/** @private 烘焙后的顶点数据。*/
		private var _bakedVertexes:Float32Array;
		/** @private 烘焙后的索引数据。*/
		private var _bakedIndices:*;
		/** @private 是否烘焙*/
		private var _isVertexbaked:Boolean;
		
		/** @private */
		public var _indexOfHost:int = 0;
		
		public var mesh:Mesh;
		
		/**
		 * 获取子网格数据模板。
		 * @return  子网格数据模板。
		 */
		public function get templet():SubMeshTemplet {
			return _templet;
		}
		
		/**
		 * 获取在宿主中的序列。
		 * @return	序列。
		 */
		public function get indexOfHost():int {
			return _indexOfHost;
		}
		
		public function get VertexBufferCount():int {
			return 1;
		}
		
		public function getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _templet.getVB();
			else
				return null;
		}
		
		public function getIndexBuffer():IndexBuffer3D {
			return _templet.getIB();
		}
		
		public function getBakedVertexs(index:int = 0):Float32Array {
			if (index === 0) {
				if (_bakedVertexes)
					return _bakedVertexes;
				
				const byteSizeInFloat:int = 4;
				var vb:VertexBuffer3D = _templet.getVB();
				_bakedVertexes = vb.getFloat32Array();
				var vertexDeclaration:VertexDeclaration = vb.vertexDeclaration;
				var positionOffset:int = vertexDeclaration.shaderAttribute[VertexElementUsage.POSITION0][4] / byteSizeInFloat;
				var normalOffset:int = vertexDeclaration.shaderAttribute[VertexElementUsage.NORMAL0][4] / byteSizeInFloat;
				var worldMat:Matrix4x4 = mesh.transform.worldMatrix;
				for (var i:int = 0; i < _bakedVertexes.length; i += vertexDeclaration.vertexStride / byteSizeInFloat) {
					var posOffset:int = i + positionOffset;
					var norOffset:int = i + normalOffset;
					Utils3D.transformVector3ArrayToVector3ArrayCoordinate(_bakedVertexes, posOffset, worldMat, _bakedVertexes, posOffset);
					Utils3D.transformVector3ArrayToVector3ArrayCoordinate(_bakedVertexes, normalOffset, worldMat, _bakedVertexes, normalOffset);
				}
				_isVertexbaked = true;
				return _bakedVertexes;
			} else
				return null;
		}
		
		public function getBakedIndices():* {
			if (_bakedIndices)
				return _bakedIndices;
			
			return _bakedIndices = _templet.getIB().getUint16Array();
		}
		
		/**
		 * 创建一个 <code>SubMesh</code> 实例。
		 */
		public function SubMesh(templet:SubMeshTemplet) {
			_templet = templet;
		}
		
		/**
		 * @private
		 */
		private function _getShader(state:RenderState, vertexBuffer:VertexBuffer3D, material:Material):Shader {
			if (!material)
				return null;
			var def:int = 0;
			var shaderAttribute:* = vertexBuffer.vertexDeclaration.shaderAttribute;
			(shaderAttribute.UV) && (def |= material.shaderDef);
			(shaderAttribute.COLOR) && (def |= ShaderDefines3D.COLOR);
			(state.scene.enableFog) && (def |= ShaderDefines3D.FOG);
			def > 0 && state.shaderDefs.addInt(def);
			var shader:Shader = material.getShader(state);
			return shader;
		}
		
		/**
		 * @private
		 * 渲染。
		 * @param	state 渲染状态。
		 */
		public function _render(state:RenderState):Boolean {
			var tem:SubMeshTemplet = _templet;
			var meshTem:MeshTemplet = _templet._meshTemplet;
			var vb:VertexBuffer3D = tem.getVB();
			var ib:IndexBuffer3D = tem.getIB();
			var material:Material = tem.getMaterial((state.owner as Mesh).materials || meshTem.materials);
			
			if (material.normalTexture && !vb.vertexDeclaration.shaderAttribute[VertexElementUsage.TANGENT0]) {
				//是否放到事件触发。
				var vertexDatas:Float32Array = vb.getFloat32Array();
				var newVertexDatas:Float32Array = Utils3D.GenerateTangent(vertexDatas, vb.vertexDeclaration.vertexStride / 4, vb.vertexDeclaration.shaderAttribute[VertexElementUsage.POSITION0][4] / 4, vb.vertexDeclaration.shaderAttribute[VertexElementUsage.TEXTURECOORDINATE0][4] / 4, ib.getUint16Array());
				var vertexDeclaration:VertexDeclaration = Utils3D.getVertexTangentDeclaration(vb.vertexDeclaration.getVertexElements());
				
				var newVB:VertexBuffer3D = VertexBuffer3D.create(vertexDeclaration, WebGLContext.STATIC_DRAW);
				newVB.setData(newVertexDatas);
				tem.getVB().dispose();
				tem.setVB(newVB);
				
				templet._bufferUsage[VertexElementUsage.TANGENT0] = newVB;
			}
			
			if (ib === null) return false;
			vb ? vb.bind_upload(ib) : meshTem.vb.bind_upload(ib);//TODO:合并问题。
			
			if (material) {
				var shader:Shader = _getShader(state, vb, material);
				
				var presz:int = state.shaderValue.length;
				state.shaderValue.pushArray(vb.vertexDeclaration.shaderValues);
				
				var mesh:Mesh = state.owner as Mesh;
				var worldMat:Matrix4x4 = mesh.transform.getWorldMatrix(-2);
				var worldTransformModifyID:Number = state.renderObj.tag.worldTransformModifyID;
				
				if ((state.owner as Mesh).isStatic && _isVertexbaked === true) {
					state.shaderValue.pushValue(Buffer.MATRIX1, Matrix4x4.DEFAULT.elements, worldTransformModifyID);//Stat.loopCount + state.ower._ID有BUG,例：6+6=7+5,用worldTransformModifyID代替
					state.shaderValue.pushValue(Buffer.MVPMATRIX, state.projectionViewMatrix.elements, state.camera.transform._worldTransformModifyID + worldTransformModifyID + state.camera._projectionMatrixModifyID);
				} else {
					state.shaderValue.pushValue(Buffer.MATRIX1, worldMat.elements, worldTransformModifyID);//Stat.loopCount + state.ower._ID有BUG,例：6+6=7+5,用worldTransformModifyID代替
					Matrix4x4.multiply(state.projectionViewMatrix, worldMat, state.owner.wvpMatrix);
					state.shaderValue.pushValue(Buffer.MVPMATRIX, mesh.wvpMatrix.elements, state.camera.transform._worldTransformModifyID + worldTransformModifyID + state.camera._projectionMatrixModifyID);
				}
				
				if (!material.upload(state, tem._finalBufferUsageDic, shader)) {
					state.shaderValue.length = presz;
					return false;
				}
				state.shaderValue.length = presz;
			}
			
			state.context.drawElements(WebGLContext.TRIANGLES, tem._elementCount, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.drawCall++;
			Stat.trianglesFaces += tem._elementCount / 3;
			return true;
		}
	
	}

}