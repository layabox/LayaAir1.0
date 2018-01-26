package laya.d3.resource.models {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.TextureCube;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>Sky</code> 类用于创建天空盒。
	 */
	public class SkyBox extends Sky {
		/** @private */
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		/** @private */
		private static var _tempMatrix4x41:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private static var _nameNumber:int = 1;
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration(12, [new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0)]);
		
		/** @private */
		private var _numberVertices:int;
		/** @private */
		private var _numberIndices:int;
		
		/** @private 天空立方体纹理。 */
		private var _textureCube:TextureCube;
		
		/**
		 * 获取天空立方体纹理。
		 * @return 天空立方体纹理。
		 */
		public function get textureCube():TextureCube {
			return _textureCube;
		}
		
		/**
		 * 设置天空立方体纹理。
		 * @param value 天空立方体纹理。
		 */
		public function set textureCube(value:TextureCube):void {
			if (_textureCube !== value) {
				(_textureCube) && (_textureCube._removeReference());//TODO:销毁问题
				_textureCube = value;
				(value) && (value._addReference());
			}
		}
		
		/**
		 * 创建一个 <code>SkyBox</code> 实例。
		 */
		public function SkyBox() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_nameNumber++;
			loadShaderParams();
			createResource();
			alphaBlending = 1;
			colorIntensity = 1;
		
		}
		
		/**
		 * @private
		 */
		protected function _getShader(state:RenderState):Shader3D {
			var shaderDefineValue:int = state.scene._shaderDefineValue;
			_shader = _shaderCompile.withCompile(shaderDefineValue, 0, 0);
			return _shader;
		}
		
		/**
		 * @private
		 */
		protected function createResource():void {
			//TODO:通过索引改为顶点复用
			//改成静态
			
			//(this._released) || (dispose());//如果已存在，则释放资源
			_numberVertices = 36;
			_numberIndices = 36;
			var indices:Uint16Array = new Uint16Array(_numberIndices);
			var vertexFloatStride:int = _vertexDeclaration.vertexStride / 4;
			var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride);
			
			// Because the box is centered at the origin, we need to divide by two to find the + and - offsets
			var width:Number = 1.0;
			var height:Number = 1.0;
			var depth:Number = 1.0;
			
			var halfWidth:Number = width / 2.0;
			var halfHeight:Number = height / 2.0;
			var halfDepth:Number = depth / 2.0;
			
			var topLeftFront:Vector3 = new Vector3(-halfWidth, halfHeight, halfDepth);
			var bottomLeftFront:Vector3 = new Vector3(-halfWidth, -halfHeight, halfDepth);
			var topRightFront:Vector3 = new Vector3(halfWidth, halfHeight, halfDepth);
			var bottomRightFront:Vector3 = new Vector3(halfWidth, -halfHeight, halfDepth);
			var topLeftBack:Vector3 = new Vector3(-halfWidth, halfHeight, -halfDepth);
			var topRightBack:Vector3 = new Vector3(halfWidth, halfHeight, -halfDepth);
			var bottomLeftBack:Vector3 = new Vector3(-halfWidth, -halfHeight, -halfDepth);
			var bottomRightBack:Vector3 = new Vector3(halfWidth, -halfHeight, -halfDepth);
			
			var vertexCount:int = 0;
			// Front face.
			vertexCount = _addVertex(vertices, vertexCount, topLeftFront);
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftFront);
			vertexCount = _addVertex(vertices, vertexCount, topRightFront);
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftFront);
			vertexCount = _addVertex(vertices, vertexCount, bottomRightFront);
			vertexCount = _addVertex(vertices, vertexCount, topRightFront);
			
			// Back face.
			vertexCount = _addVertex(vertices, vertexCount, topLeftBack);
			vertexCount = _addVertex(vertices, vertexCount, topRightBack);
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftBack);
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftBack);
			vertexCount = _addVertex(vertices, vertexCount, topRightBack);
			vertexCount = _addVertex(vertices, vertexCount, bottomRightBack);
			
			// Top face.
			vertexCount = _addVertex(vertices, vertexCount, topLeftFront);
			vertexCount = _addVertex(vertices, vertexCount, topRightBack);
			vertexCount = _addVertex(vertices, vertexCount, topLeftBack);
			vertexCount = _addVertex(vertices, vertexCount, topLeftFront);
			vertexCount = _addVertex(vertices, vertexCount, topRightFront);
			vertexCount = _addVertex(vertices, vertexCount, topRightBack);
			
			// Bottom face. 
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftFront);
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftBack);
			vertexCount = _addVertex(vertices, vertexCount, bottomRightBack);
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftFront);
			vertexCount = _addVertex(vertices, vertexCount, bottomRightBack);
			vertexCount = _addVertex(vertices, vertexCount, bottomRightFront);
			
			// Left face.
			vertexCount = _addVertex(vertices, vertexCount, topLeftFront);
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftBack);
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftFront);
			vertexCount = _addVertex(vertices, vertexCount, topLeftBack);
			vertexCount = _addVertex(vertices, vertexCount, bottomLeftBack);
			vertexCount = _addVertex(vertices, vertexCount, topLeftFront);
			
			// Right face. 
			vertexCount = _addVertex(vertices, vertexCount, topRightFront);
			vertexCount = _addVertex(vertices, vertexCount, bottomRightFront);
			vertexCount = _addVertex(vertices, vertexCount, bottomRightBack);
			vertexCount = _addVertex(vertices, vertexCount, topRightBack);
			vertexCount = _addVertex(vertices, vertexCount, topRightFront);
			vertexCount = _addVertex(vertices, vertexCount, bottomRightBack);
			
			for (var i:int = 0; i < 36; i++)
				indices[i] = i;
			
			_vertexBuffer = new VertexBuffer3D(_vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
		}
		
		/**
		 * @private
		 */
		private function _addVertex(vertices:Float32Array, index:int, position:Vector3):int {
			var posE:Float32Array = position.elements;
			vertices[index + 0] = posE[0];
			vertices[index + 1] = posE[1];
			vertices[index + 2] = posE[2];
			return index + 3;
		}
		
		/**
		 * @private
		 */
		protected function loadShaderParams():void {
			_sharderNameID = Shader3D.nameKey.getID("SkyBox");
			_shaderCompile = ShaderCompile3D._preCompileShader[_sharderNameID];
		}
		
		override public function _render(state:RenderState):void {
			if (_textureCube && _textureCube.loaded) {
				_vertexBuffer._bind();
				_indexBuffer._bind();
				_shader = _getShader(state);
				_shader.bind();
				
				state.camera.transform.worldMatrix.cloneTo(_tempMatrix4x40);//视图矩阵逆矩阵的转置矩阵，移除平移和缩放。//TODO:可优化
				_tempMatrix4x40.transpose();
				Matrix4x4.multiply(state._projectionMatrix, _tempMatrix4x40, _tempMatrix4x41);
				state.camera._shaderValues.setValue(BaseCamera.VPMATRIX_NO_TRANSLATE, _tempMatrix4x41.elements);
				_shader.uploadCameraUniforms(state.camera._shaderValues.data);
				
				_shaderValue.setValue(INTENSITY, _colorIntensity);
				_shaderValue.setValue(ALPHABLENDING, _alphaBlending);
				_shaderValue.setValue(DIFFUSETEXTURE, textureCube);
				
				_shader.uploadAttributes(_vertexDeclaration.shaderValues.data, null);
				_shader.uploadMaterialUniforms(_shaderValue.data);
				
				WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, 36, WebGLContext.UNSIGNED_SHORT, 0);
				Stat.trianglesFaces += 12;
				Stat.drawCall++;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			super.destroy();
			(_textureCube) && (_textureCube._removeReference(), _textureCube = null);
		}
	
	}

}