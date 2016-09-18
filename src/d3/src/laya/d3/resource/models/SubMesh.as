package laya.d3.resource.models {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.resource.IDispose;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * @private
	 * <code>SubMesh</code> 类用于创建子网格数据模板。
	 */
	public class SubMesh implements IRenderable, IDispose {
		/** @private */
		protected var _ib:IndexBuffer3D;
		/** @private */
		protected var _materialIndex:int = -1;
		/** @private */
		public var _numberIndices:int = 0;
		/** @private */
		protected var _vb:VertexBuffer3D;
		
		/** @private */
		public var _mesh:Mesh;
		/** @private */
		public var _boneIndex:Uint8Array;
		/** @private */
		public var _bufferUsage:* = {};
		/** @private */
		public var _finalBufferUsageDic:*;
		/** @private */
		public var _indexOfHost:int = 0;
		
		/**获取顶点索引，UV动画使用。*/
		public var verticesIndices:Uint32Array;
		
		/**
		 * 获取材质
		 * @return	材质ID。
		 */
		public function get material():int {
			return _materialIndex;
		}
		
		/**
		 * 设置材质
		 * @param	value  材质ID。
		 */
		public function set material(value:int):void {
			_materialIndex = value;
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
		
		public function get triangleCount():int {
			return _ib.indexCount/3;
		}
		
		public function getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vb;
			else
				return null;
		}
		
		public function getIndexBuffer():IndexBuffer3D {
			return _ib;
		}
		
		/**
		 * 创建一个 <code>SubMesh</code> 实例。
		 * @param	mesh  网格数据模板。
		 */
		public function SubMesh(mesh:Mesh) {
			_mesh = mesh;
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
			var mesh:Mesh = _mesh, vb:VertexBuffer3D = _vb, ib:IndexBuffer3D = _ib;
			var material:Material = getMaterial((state.owner as MeshSprite3D).meshRender.sharedMaterials);
			if (material.normalTexture && !vb.vertexDeclaration.shaderAttribute[VertexElementUsage.TANGENT0]) {
				//是否放到事件触发。
				var vertexDatas:Float32Array = vb.getData();
				var newVertexDatas:Float32Array = Utils3D.generateTangent(vertexDatas, vb.vertexDeclaration.vertexStride / 4, vb.vertexDeclaration.shaderAttribute[VertexElementUsage.POSITION0][4] / 4, vb.vertexDeclaration.shaderAttribute[VertexElementUsage.TEXTURECOORDINATE0][4] / 4, ib.getData());
				var vertexDeclaration:VertexDeclaration = Utils3D.getVertexTangentDeclaration(vb.vertexDeclaration.getVertexElements());
				
				var newVB:VertexBuffer3D = VertexBuffer3D.create(vertexDeclaration, WebGLContext.STATIC_DRAW);
				newVB.setData(newVertexDatas);
				vb.dispose();
				vb = _vb = newVB;
				
				_bufferUsage[VertexElementUsage.TANGENT0] = newVB;
			}
			
			if (ib === null) return false;
			vb._bind();
			ib._bind();
			if (material) {
				var shader:Shader = _getShader(state, vb, material);
				
				var presz:int = state.shaderValue.length;
				state.shaderValue.pushArray(vb.vertexDeclaration.shaderValues);
				
				var meshSprite:MeshSprite3D = state.owner as MeshSprite3D;
				var worldMat:Matrix4x4 = meshSprite.transform.worldMatrix;
				
				//if ((state.owner as Mesh).isStatic && _isVertexbaked === true) {
				//state.shaderValue.pushValue(Buffer.MATRIX1, Matrix4x4.DEFAULT.elements, worldTransformModifyID);//Stat.loopCount + state.ower._ID有BUG,例：6+6=7+5,用worldTransformModifyID代替
				//state.shaderValue.pushValue(Buffer.MVPMATRIX, state.projectionViewMatrix.elements, state.camera.transform._worldTransformModifyID + worldTransformModifyID + state.camera._projectionMatrixModifyID);
				//} else {
				state.shaderValue.pushValue(Buffer2D.MATRIX1, worldMat.elements, /*worldTransformModifyID,从结构上应该在Mesh中更新*/-1);//Stat.loopCount + state.ower._ID有BUG,例：6+6=7+5,用worldTransformModifyID代替
				Matrix4x4.multiply(state.projectionViewMatrix, worldMat, state.owner.wvpMatrix);
				
				state.shaderValue.pushValue(Buffer2D.MVPMATRIX, meshSprite.wvpMatrix.elements, /*state.camera.transform._worldTransformModifyID + worldTransformModifyID + state.camera._projectionMatrixModifyID,从结构上应该在Mesh中更新*/-1);
				//}
				
				if (!material.upload(state, _finalBufferUsageDic, shader)) {
					state.shaderValue.length = presz;
					return false;
				}
				state.shaderValue.length = presz;
			}
			
			state.context.drawElements(WebGLContext.TRIANGLES, _numberIndices, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.drawCall++;
			Stat.trianglesFaces += _numberIndices / 3;
			return true;
		}
		
		/**
		 * @private
		 */
		public function _setBoneDic(boneDic:Uint8Array):void {
			_boneIndex = boneDic;
			_mesh.disableUseFullBone();
		}
		
		/**
		 * 获取材质。
		 * @param 材质队列。
		 * @return  材质。
		 */
		public function getMaterial(materials:Vector.<Material>):Material {
			return _materialIndex >= 0 ? materials[_materialIndex] : null;
		}
		
		/**
		 * 设置索引缓冲。
		 * @param value 索引缓冲。
		 * @param elementCount 索引的个数。
		 */
		public function setIB(value:IndexBuffer3D, elementCount:int):void {
			_ib = value;
			_numberIndices = elementCount;
		}
		
		/**
		 * 获取索引缓冲。
		 * @return  索引缓冲。
		 */
		public function getIB():IndexBuffer3D {
			return _ib;
		}
		
		/**
		 * 设置顶点缓冲。
		 * @param vb 顶点缓冲。
		 */
		public function setVB(vb:VertexBuffer3D):void {
			_vb = vb;
		}
		
		/**
		 * 获取顶点缓冲。
		 * @return  顶点缓冲。
		 */
		public function getVB():VertexBuffer3D {
			return _vb;
		}
		
		
		/**
		 * <p>彻底清理资源。</p>
		 * <p><b>注意：</b>会强制解锁清理。</p>
		 */
		public function dispose():void {
			_mesh = null;
			_boneIndex = null;
			_ib.dispose();
			_vb.dispose();
		}
	
	}
}