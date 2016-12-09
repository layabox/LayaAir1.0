package laya.d3.resource.models {
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
	import laya.d3.shader.ShaderDefines3D;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.ValusArray;
	
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
		protected var _shaderValue:ValusArray = new ValusArray();
		/** @private */
		protected var _sharderNameID:int;
		/** @private */
		protected var _shader:Shader;
		
		/** @private */
		protected var _numberVertices:int;
		/** @private */
		protected var _numberIndices:int;
		/** @private */
		private var _vertexBuffer:VertexBuffer3D;
		/** @private */
		private var _indexBuffer:IndexBuffer3D;
		
		/**  @private 透明混合度。 */
		private var _alphaBlending:Number = 1.0;//TODO:可能移除
		
		/** @private 颜色强度。 */
		private var _colorIntensity:Number = 1.0;
		
		/** @private 天空立方体纹理。 */
		private var _textureCube:TextureCube;
		
		/**
		 * 获取透明混合度。
		 * @return 透明混合度。
		 */
		public function get alphaBlending():Number {
			return _alphaBlending;
		}
		
		/**
		 * 设置透明混合度。
		 * @param value 透明混合度。
		 */
		public function set alphaBlending(value:Number):void {
			_alphaBlending = value;
			if (_alphaBlending < 0)
				_alphaBlending = 0;
			if (_alphaBlending > 1)
				_alphaBlending = 1;
		}
		
		/**
		 * 获取颜色强度。
		 * @return 颜色强度。
		 */
		public function get colorIntensity():Number {
			return _colorIntensity;
		}
		
		/**
		 * 设置颜色强度。
		 * @param value 颜色强度。
		 */
		public function set colorIntensity(value:Number):void {
			_colorIntensity = value;
			if (_colorIntensity < 0)
				_colorIntensity = 0;
		}
		
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
			_textureCube = value;
		}
		
		/**
		 * 创建一个 <code>SkyBox</code> 实例。
		 */
		public function SkyBox() {
			super();
			name = "Skybox-" + _nameNumber;
			_nameNumber++;
			loadShaderParams();
			recreateResource();
		}
		
		/**
		 * @private
		 */
		protected function _getShader(state:RenderState):Shader {
			var shaderDefs:ShaderDefines3D = state.shaderDefines;
			var preDef:int = shaderDefs._value;
			var nameID:Number = shaderDefs._value + _sharderNameID * Shader.SHADERNAME2ID;
			_shader = Shader.withCompile(_sharderNameID, state.shaderDefines.toNameDic(), nameID, null);
			shaderDefs._value = preDef;
			return _shader;
		}
		
		/**
		 * @private
		 */
		override protected function recreateResource():void {//TODO:通过索引改为顶点复用
			//(this._released) || (dispose());//如果已存在，则释放资源
			startCreate();
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
			memorySize = (_vertexBuffer.byteLength + _indexBuffer.byteLength) * 2;//修改占用内存,upload()到GPU后CPU中和GPU中各占一份内存
			completeCreate();
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
			_sharderNameID = Shader.nameKey.get("SkyBox");
			_shaderValue.pushValue(Sky.DIFFUSETEXTURE, null);
		}
		
		override public function _render(state:RenderState):void {
			if (_textureCube && _textureCube.loaded) {
				//设备丢失时,貌似WebGL不会丢失.............................................................
				//  todo  setData  here!
				//...................................................................................
				
				_vertexBuffer._bind();
				_indexBuffer._bind();
				_shader = _getShader(state);
				var presz:int = _shaderValue.length;
				_shaderValue.pushArray(state.shaderValue);
				_shaderValue.pushArray(_vertexBuffer.vertexDeclaration.shaderValues);
				
				state.camera.transform.worldMatrix.cloneTo(_tempMatrix4x40);//视图矩阵逆矩阵的转置矩阵，移除平移和缩放。
				_tempMatrix4x40.transpose();
				Matrix4x4.multiply(state.projectionMatrix, _tempMatrix4x40, _tempMatrix4x41);
				
				_shaderValue.pushValue(Sky.MVPMATRIX, _tempMatrix4x41.elements);
				_shaderValue.pushValue(Sky.INTENSITY, _colorIntensity);
				_shaderValue.pushValue(Sky.ALPHABLENDING, alphaBlending);
				
				_shaderValue.data[1] = textureCube.source;
				
				_shader.uploadArray(_shaderValue.data, _shaderValue.length, null);
				_shaderValue.length = presz;
				
				WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, 36, WebGLContext.UNSIGNED_SHORT, 0);
				Stat.trianglesFaces += 12;
				Stat.drawCall++;
			}
		}
	
	}

}