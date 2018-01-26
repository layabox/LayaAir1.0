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
	import laya.d3.resource.DataTexture2D;
	import laya.d3.resource.Texture2D;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>Sky</code> 类用于创建天空盒。
	 */
	public class SkyDome extends Sky {
		/** @private */
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		/** @private */
		private static var _tempMatrix4x41:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private static var _nameNumber:int = 1;
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration(20, [new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0), new VertexElement(12, VertexElementFormat.Vector2, VertexElementUsage.TEXTURECOORDINATE0)]);
		
		/** @private */
		private var _numberVertices:int;
		/** @private */
		private var _numberIndices:int;
		
		/** @private 天空立方体纹理。 */
		private var _texture:Texture2D;
		
		private var _stacks:int = 16;
		
		private var _slices:int = 16;
		
		private var _radius:Number = 1;
		
		/**
		 * 获取天空立方体纹理。
		 * @return 天空立方体纹理。
		 */
		public function get texture():Texture2D {
			return _texture;
		}
		
		/**
		 * 设置天空纹理。
		 * @param value 天空纹理。
		 */
		public function set texture(value:Texture2D):void {
			if (_texture !== value) {
				(_texture) && (_texture._removeReference());//TODO:销毁问题
				_texture = value;
				(value) && (value._addReference());
			}
		}
		
		/**
		 * 创建一个 <code>SkyBox</code> 实例。
		 */
		public function SkyDome() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_nameNumber++;
			loadShaderParams();
			recreateResource();
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
		 protected function recreateResource():void {//TODO:通过索引改为顶点复用
			//(this._released) || (dispose());//如果已存在，则释放资源
			
			_numberVertices = (_stacks + 1) * (_slices + 1);
			_numberIndices = (3 * _stacks * (_slices + 1)) * 2;
			
			var indices:Uint16Array = new Uint16Array(_numberIndices);
			var vertexFloatStride:int = _vertexDeclaration.vertexStride / 4;
			var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride);
			
			var stackAngle:Number = Math.PI / _stacks;
			var sliceAngle:Number = (Math.PI * 2.0) / _slices;
			
			// Generate the group of Stacks for the sphere  
			var vertexIndex:int = 0;
			var vertexCount:int = 0;
			var indexCount:int = 0;
			
			for (var stack:int = 0; stack < (_stacks + 1); stack++) {
				var r:Number = Math.sin(stack * stackAngle);
				var y:Number = Math.cos(stack * stackAngle);
				
				// Generate the group of segments for the current Stack  
				for (var slice:int = 0; slice < (_slices + 1); slice++) {
					var x:Number = r * Math.sin(slice * sliceAngle);
					var z:Number = r * Math.cos(slice * sliceAngle);
					vertices[vertexCount + 0] = x * _radius;
					vertices[vertexCount + 1] = y * _radius;
					vertices[vertexCount + 2] = z * _radius;
					
					vertices[vertexCount + 3] = -(slice / _slices) + 0.75;//gzk 改成我喜欢的坐标系 原来是 slice/_slices
					vertices[vertexCount + 4] = stack / _stacks;
					vertexCount += vertexFloatStride;
					if (stack != (_stacks - 1)) {
						// First Face
						indices[indexCount++] = vertexIndex + 1;
						indices[indexCount++] = vertexIndex;
						indices[indexCount++] = vertexIndex + (_slices + 1);
						
						// Second 
						indices[indexCount++] = vertexIndex + (_slices + 1);
						indices[indexCount++] = vertexIndex;
						indices[indexCount++] = vertexIndex + (_slices);
						vertexIndex++;
					}
				}
			}
			_vertexBuffer = new VertexBuffer3D(_vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			if (_conchSky) {//NATIVE
				_conchSky.setVBIB(_vertexDeclaration._conchVertexDeclaration, vertices, indices);
				_sharderNameID = Shader3D.nameKey.getID("SkyDome");
				var shaderCompile:ShaderCompile3D = ShaderCompile3D._preCompileShader[_sharderNameID];
				_conchSky.setShader(shaderCompile._conchShader);
			}
		}
		
		/**
		 * @private
		 */
		protected function loadShaderParams():void {
			_sharderNameID = Shader3D.nameKey.getID("SkyDome");
			_shaderCompile = ShaderCompile3D._preCompileShader[_sharderNameID];
		}
		
		override public function _render(state:RenderState):void {
			if (_texture && _texture.loaded) {
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
				_shaderValue.setValue(DIFFUSETEXTURE, texture);
				
				_shader.uploadAttributes(_vertexDeclaration.shaderValues.data, null);
				_shader.uploadMaterialUniforms(_shaderValue.data);
				WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, _indexBuffer.indexCount, WebGLContext.UNSIGNED_SHORT, 0);
				Stat.trianglesFaces += _numberIndices / 3;
				Stat.drawCall++;
			}
		}
		
		public function onEnvDescLoaded(envInfoFile:String):void {
			var envPath:String = '';
			var ppos:Number = Math.max(envInfoFile.lastIndexOf('/'), envInfoFile.lastIndexOf('\\'));
			if (ppos > 0) {
				envPath = envInfoFile.substr(0, ppos + 1);
			}
			
			var envinfoobj:* = Laya.loader.getRes(envInfoFile);
			if (envinfoobj.ev != undefined && __ownerCamera)//TODO 如果这时候__ownerCamera 还没设置怎么办
				__ownerCamera._shaderValues.setValue(BaseCamera.HDREXPOSURE, Math.pow(2, envinfoobj.ev));
			else
				__ownerCamera._shaderValues.setValue(BaseCamera.HDREXPOSURE, Math.pow(2, 0.0));
			
			texture = Texture2D.load(envPath + envinfoobj.skytex);//设置天空纹理。这里肯定是天空球
			environmentSpecular = DataTexture2D.load(envPath + envinfoobj.prefiltedEnv);
			var irrdMat:Float32Array = new Float32Array(envinfoobj.IrradianceMat);
			
			envDiffuseSHRed = irrdMat.slice(0, 16) as Float32Array;
			envDiffuseSHGreen = irrdMat.slice(16, 32) as Float32Array;
			envDiffuseSHBlue = irrdMat.slice(32, 48) as Float32Array;
		}
		
		public function loadEnvInfo(envInfo:String):void {
			Laya.loader.load(envInfo, Handler.create(this, onEnvDescLoaded, [envInfo]));
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			super.destroy();
			(_texture) && (_texture._removeReference(), _texture = null);
		}
	
	}

}