package laya.d3.shader {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Transform3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.RenderState;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.layagl.CommandEncoder;
	import laya.layagl.LayaGL;
	import laya.layagl.LayaGLRunner;
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * @private
	 * <code>ShaderInstance</code> 类用于实现ShaderInstance。
	 */
	public class ShaderInstance extends Resource {
		/**@private */
		private var _attributeMap:Object;
		/**@private */
		private var _uniformMap:Object;
		/**@private */
		private var _shaderPass:ShaderPass;
		
		/**@private */
		private var _vs:String
		/**@private */
		private var _ps:String;
		/**@private */
		private var _curActTexIndex:int;
		
		/**@private */
		private var _vshader:*;
		/**@private */
		private var _pshader:*
		/**@private */
		private var _program:*;
		
		/**@private */
		public var _sceneUniformParamsMap:CommandEncoder;
		/**@private */
		public var _cameraUniformParamsMap:CommandEncoder;
		/**@private */
		public var _spriteUniformParamsMap:CommandEncoder;
		/**@private */
		public var _materialUniformParamsMap:CommandEncoder;
		/**@private */
		private var _customUniformParamsMap:Array;
		/**@private */
		private var _stateParamsMap:Array = [];
		
		/**@private */
		public var _uploadMark:int = -1;
		/**@private */
		public var _uploadMaterial:BaseMaterial;
		/**@private */
		public var _uploadRender:BaseRender;
		/** @private */
		public var _uploadRenderType:int = -1;
		/**@private */
		public var _uploadCamera:BaseCamera;
		/**@private */
		public var _uploadScene:Scene3D;
		
		/**
		 * 创建一个 <code>ShaderInstance</code> 实例。
		 */
		public function ShaderInstance(vs:String, ps:String, attributeMap:Object, uniformMap:Object, shaderPass:ShaderPass) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_vs = vs;
			_ps = ps;
			_attributeMap = attributeMap;
			_uniformMap = uniformMap;
			_shaderPass = shaderPass;
			_create();
			lock = true;
		}
		
		/**
		 *@private
		 */
		private function _create():void {
			var gl:WebGLContext = LayaGL.instance;
			_program = gl.createProgram();
			_vshader = _createShader(gl, _vs, WebGLContext.VERTEX_SHADER);
			_pshader = _createShader(gl, _ps, WebGLContext.FRAGMENT_SHADER);
			gl.attachShader(_program, _vshader);
			gl.attachShader(_program, _pshader);
			
			for (var k:String in _attributeMap)//根据声明调整location,便于VAO使用
				gl.bindAttribLocation(_program, _attributeMap[k], k);
			
			gl.linkProgram(_program);
			if (!Render.isConchApp && Shader3D.debugMode && !gl.getProgramParameter(_program, WebGLContext.LINK_STATUS))
				throw gl.getProgramInfoLog(_program);
			
			var sceneParms:Array = [];
			var cameraParms:Array = [];
			var spriteParms:Array = [];
			var materialParms:Array = [];
			var customParms:Array = [];
			_customUniformParamsMap = [];
			var nUniformNum:int = gl.getProgramParameter(_program, WebGLContext.ACTIVE_UNIFORMS);
			WebGLContext.useProgram(gl, _program);
			_curActTexIndex = 0;
			var one:ShaderVariable, i:int, n:int;
			for (i = 0; i < nUniformNum; i++) {
				var uniformData:* = gl.getActiveUniform(_program, i);
				var uniName:String = uniformData.name;
				one = new ShaderVariable();
				one.location = gl.getUniformLocation(_program, uniName);
				
				if (uniName.indexOf('[0]') > 0) {
					one.name = uniName = uniName.substr(0, uniName.length - 3);
					one.isArray = true;
				} else {
					one.name = uniName;
					one.isArray = false;
				}
				one.type = uniformData.type;
				_addShaderUnifiormFun(one);
				var uniformPeriod:Array = _uniformMap[uniName];
				if (uniformPeriod != null) {
					one.dataOffset = Shader3D.propertyNameToID(uniName);
					switch (uniformPeriod) {
					case Shader3D.PERIOD_CUSTOM: 
						customParms.push(one);
						break;
					case Shader3D.PERIOD_MATERIAL: 
						materialParms.push(one);
						break;
					case Shader3D.PERIOD_SPRITE: 
						spriteParms.push(one);
						break;
					case Shader3D.PERIOD_CAMERA: 
						cameraParms.push(one);
						break;
					case Shader3D.PERIOD_SCENE: 
						sceneParms.push(one);
						break;
					default: 
						throw new Error("Shader3D: period is unkonw.");
					}
				}
			}
			
			//Native版本分别存入funid、webglFunid,location、type、offset, +4是因为第一个存长度了 所以是*4*5+4
			_sceneUniformParamsMap = LayaGL.instance.createCommandEncoder(sceneParms.length * 4 * 5 + 4, 64, true);
			for (i = 0, n = sceneParms.length; i < n; i++)
				_sceneUniformParamsMap.addShaderUniform(sceneParms[i]);
			
			_cameraUniformParamsMap = LayaGL.instance.createCommandEncoder(cameraParms.length * 4 * 5 + 4, 64, true);
			for (i = 0, n = cameraParms.length; i < n; i++)
				_cameraUniformParamsMap.addShaderUniform(cameraParms[i]);
			
			_spriteUniformParamsMap = LayaGL.instance.createCommandEncoder(spriteParms.length * 4 * 5 + 4, 64, true);
			for (i = 0, n = spriteParms.length; i < n; i++)
				_spriteUniformParamsMap.addShaderUniform(spriteParms[i]);
			
			_materialUniformParamsMap = LayaGL.instance.createCommandEncoder(materialParms.length * 4 * 5 + 4, 64, true);
			for (i = 0, n = materialParms.length; i < n; i++)
				_materialUniformParamsMap.addShaderUniform(materialParms[i]);
			
			_customUniformParamsMap.length = customParms.length;
			for (i = 0, n = customParms.length; i < n; i++) {
				var custom:ShaderVariable = customParms[i];
				_customUniformParamsMap[custom.dataOffset] = custom;
			}
			
			var stateMap:Object = _shaderPass._stateMap;
			for (var s:String in stateMap)
				_stateParamsMap[stateMap[s]] = Shader3D.propertyNameToID(s);
		}
		
		/**
		 * @private
		 */
		private function _getRenderState(shaderDatas:Array, stateIndex:int):* {
			var stateID:* = _stateParamsMap[stateIndex];
			if (stateID == null)
				return null;
			else
				return shaderDatas[stateID];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _disposeResource():void {
			LayaGL.instance.deleteShader(_vshader);
			LayaGL.instance.deleteShader(_pshader);
			LayaGL.instance.deleteProgram(_program);
			_vshader = _pshader = _program = null;
			_setGPUMemory(0);
			_curActTexIndex = 0;
		}
		
		/**
		 * @private
		 */
		public function _addShaderUnifiormFun(one:ShaderVariable):void {
			var gl:WebGLContext = LayaGL.instance;
			one.caller = this;
			var isArray:Boolean = one.isArray;
			switch (one.type) {
			case WebGLContext.BOOL: 
				one.fun = this._uniform1i;
				one.uploadedValue = new Array(1);
				break;
			case WebGLContext.INT: 
				one.fun = isArray ? this._uniform1iv : this._uniform1i;//TODO:优化
				one.uploadedValue = new Array(1);
				break;
			case WebGLContext.FLOAT: 
				one.fun = isArray ? this._uniform1fv : this._uniform1f;
				one.uploadedValue = new Array(1);
				break;
			case WebGLContext.FLOAT_VEC2: 
				one.fun = isArray ? this._uniform_vec2v : this._uniform_vec2;
				one.uploadedValue = new Array(2);
				break;
			case WebGLContext.FLOAT_VEC3: 
				one.fun = isArray ? this._uniform_vec3v : this._uniform_vec3;
				one.uploadedValue = new Array(3);
				break;
			case WebGLContext.FLOAT_VEC4: 
				one.fun = isArray ? this._uniform_vec4v : this._uniform_vec4;
				one.uploadedValue = new Array(4);
				break;
			case WebGLContext.FLOAT_MAT2: 
				one.fun = this._uniformMatrix2fv;
				break;
			case WebGLContext.FLOAT_MAT3: 
				one.fun = this._uniformMatrix3fv;
				break;
			case WebGLContext.FLOAT_MAT4: 
				one.fun = isArray ? this._uniformMatrix4fv : this._uniformMatrix4f;
				break;
			case WebGLContext.SAMPLER_2D: 
				gl.uniform1i(one.location, _curActTexIndex);
				one.textureID = WebGLContext._glTextureIDs[_curActTexIndex++];
				one.fun = this._uniform_sampler2D;
				break;
			case 0x8b5f://sampler3D
				gl.uniform1i(one.location, _curActTexIndex);
				one.textureID = WebGLContext._glTextureIDs[_curActTexIndex++];
				one.fun = this._uniform_sampler3D;
				break;
			case WebGLContext.SAMPLER_CUBE: 
				gl.uniform1i(one.location, _curActTexIndex);
				one.textureID = WebGLContext._glTextureIDs[_curActTexIndex++];
				one.fun = this._uniform_samplerCube;
				break;
			default: 
				throw new Error("compile shader err!");
				break;
			}
		}
		
		/**
		 * @private
		 */
		private function _createShader(gl:WebGLContext, str:String, type:*):* {
			var shader:* = gl.createShader(type);
			gl.shaderSource(shader, str);
			gl.compileShader(shader);
			if (Shader3D.debugMode && !gl.getShaderParameter(shader, WebGLContext.COMPILE_STATUS))
				throw gl.getShaderInfoLog(shader);
			
			return shader;
		}
		
		/**
		 * @private
		 */
		public function _uniform1f(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value) {
				LayaGL.instance.uniform1f(one.location, uploadedValue[0] = value);
				return 1;
			}
			return 0;
		}
		
		/**
		 * @private
		 */
		public function _uniform1fv(one:*, value:*):int {
			if (value.length < 4) {
				var uploadedValue:Array = one.uploadedValue;
				if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2] || uploadedValue[3] !== value[3]) {
					LayaGL.instance.uniform1fv(one.location, value);
					uploadedValue[0] = value[0];
					uploadedValue[1] = value[1];
					uploadedValue[2] = value[2];
					uploadedValue[3] = value[3];
					return 1;
				}
				return 0;
			} else {
				LayaGL.instance.uniform1fv(one.location, value);
				return 1;
			}
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec2(one:*, v:Vector2):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== v.x || uploadedValue[1] !== v.y) {
				LayaGL.instance.uniform2f(one.location, uploadedValue[0] = v.x, uploadedValue[1] = v.y);
				return 1;
			}
			return 0;
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec2v(one:*, value:Float32Array):int {
			if (value.length < 2) {
				var uploadedValue:Array = one.uploadedValue;
				if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2] || uploadedValue[3] !== value[3]) {
					LayaGL.instance.uniform2fv(one.location, value);
					uploadedValue[0] = value[0];
					uploadedValue[1] = value[1];
					uploadedValue[2] = value[2];
					uploadedValue[3] = value[3];
					return 1;
				}
				return 0;
			} else {
				LayaGL.instance.uniform2fv(one.location, value);
				return 1;
			}
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec3(one:*, v:Vector3):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== v.x || uploadedValue[1] !== v.y || uploadedValue[2] !== v.z) {
				LayaGL.instance.uniform3f(one.location, uploadedValue[0] = v.x, uploadedValue[1] = v.y, uploadedValue[2] = v.z);
				return 1;
			}
			return 0;
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec3v(one:*, v:Float32Array):int {
			LayaGL.instance.uniform3fv(one.location, v);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec4(one:*, v:Vector4):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== v.x || uploadedValue[1] !== v.y || uploadedValue[2] !== v.z || uploadedValue[3] !== v.w) {
				LayaGL.instance.uniform4f(one.location, uploadedValue[0] = v.x, uploadedValue[1] = v.y, uploadedValue[2] = v.z, uploadedValue[3] = v.w);
				return 1;
			}
			return 0;
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec4v(one:*, v:Float32Array):int {
			LayaGL.instance.uniform4fv(one.location, v);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniformMatrix2fv(one:*, value:*):int {
			LayaGL.instance.uniformMatrix2fv(one.location, false, value);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniformMatrix3fv(one:*, value:*):int {
			LayaGL.instance.uniformMatrix3fv(one.location, false, value);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniformMatrix4f(one:*, m:Matrix4x4):int {
			var value:Float32Array = m.elements;
			LayaGL.instance.uniformMatrix4fv(one.location, false, value);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniformMatrix4fv(one:*, m:Float32Array):int {
			LayaGL.instance.uniformMatrix4fv(one.location, false, m);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniform1i(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value) {
				LayaGL.instance.uniform1i(one.location, uploadedValue[0] = value);
				return 1;
			}
			return 0;
		}
		
		/**
		 * @private
		 */
		public function _uniform1iv(one:*, value:*):int {
			LayaGL.instance.uniform1iv(one.location, value);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniform_ivec2(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1]) {
				LayaGL.instance.uniform2i(one.location, uploadedValue[0] = value[0], uploadedValue[1] = value[1]);
				return 1;
			}
			return 0;
		}
		
		/**
		 * @private
		 */
		public function _uniform_ivec2v(one:*, value:*):int {
			LayaGL.instance.uniform2iv(one.location, value);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec3i(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2]) {
				LayaGL.instance.uniform3i(one.location, uploadedValue[0] = value[0], uploadedValue[1] = value[1], uploadedValue[2] = value[2]);
				return 1;
			}
			return 0;
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec3vi(one:*, value:*):int {
			LayaGL.instance.uniform3iv(one.location, value);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec4i(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2] || uploadedValue[3] !== value[3]) {
				LayaGL.instance.uniform4i(one.location, uploadedValue[0] = value[0], uploadedValue[1] = value[1], uploadedValue[2] = value[2], uploadedValue[3] = value[3]);
				return 1;
			}
			return 0;
		}
		
		/**
		 * @private
		 */
		public function _uniform_vec4vi(one:*, value:*):int {
			LayaGL.instance.uniform4iv(one.location, value);
			return 1;
		}
		
		/**
		 * @private
		 */
		public function _uniform_sampler2D(one:*, texture:BaseTexture):int {//TODO:TEXTURTE ARRAY
			var value:* = texture._getSource() || texture.defaulteTexture._getSource();
			var gl:WebGLContext = LayaGL.instance;
			WebGLContext.activeTexture(gl, one.textureID);
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, value);
			return 0;
		}
		
		public function _uniform_sampler3D(one:*, texture:BaseTexture):int {//TODO:TEXTURTE ARRAY
			var value:* = texture._getSource() || texture.defaulteTexture._getSource();
			var gl:WebGLContext = LayaGL.instance;
			WebGLContext.activeTexture(gl, one.textureID);
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_3D, value);
			return 0;
		}
		
		/**
		 * @private
		 */
		public function _uniform_samplerCube(one:*, texture:BaseTexture):int {//TODO:TEXTURTECUBE ARRAY
			var value:* = texture._getSource() || texture.defaulteTexture._getSource();
			var gl:WebGLContext = LayaGL.instance;
			WebGLContext.activeTexture(gl, one.textureID);
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_CUBE_MAP, value);
			return 0;
		}
		
		/**
		 * @private
		 */
		public function bind():Boolean {
			return WebGLContext.useProgram(LayaGL.instance, _program);
		}
		
		/**
		 * @private
		 */
		public function uploadUniforms(shaderUniform:CommandEncoder, shaderDatas:ShaderData, uploadUnTexture:Boolean):void {
			Stat.shaderCall += LayaGLRunner.uploadShaderUniforms(LayaGL.instance, shaderUniform, shaderDatas, uploadUnTexture);
		}
		
		/**
		 * @private
		 */
		public function uploadRenderStateBlendDepth(shaderDatas:ShaderData):void {
			var gl:WebGLContext = LayaGL.instance;
			var renderState:RenderState = _shaderPass.renderState;
			var datas:Array = shaderDatas.getData();
			
			var depthWrite:* = _getRenderState(datas, Shader3D.RENDER_STATE_DEPTH_WRITE);
			var depthTest:* = _getRenderState(datas, Shader3D.RENDER_STATE_DEPTH_TEST);
			var blend:* = _getRenderState(datas, Shader3D.RENDER_STATE_BLEND);
			depthWrite == null && (depthWrite = renderState.depthWrite);
			depthTest == null && (depthTest = renderState.depthTest);
			blend == null && (blend = renderState.blend);
			
			WebGLContext.setDepthMask(gl, depthWrite);
			if (depthTest === RenderState.DEPTHTEST_OFF)
				WebGLContext.setDepthTest(gl, false);
			else {
				WebGLContext.setDepthTest(gl, true);
				WebGLContext.setDepthFunc(gl, depthTest);
			}
			
			switch (blend) {
			case RenderState.BLEND_DISABLE: 
				WebGLContext.setBlend(gl, false);
				break;
			case RenderState.BLEND_ENABLE_ALL: 
				WebGLContext.setBlend(gl, true);
				var srcBlend:* = _getRenderState(datas, Shader3D.RENDER_STATE_BLEND_SRC);
				srcBlend == null && (srcBlend = renderState.srcBlend);
				var dstBlend:* = _getRenderState(datas, Shader3D.RENDER_STATE_BLEND_DST);
				dstBlend == null && (dstBlend = renderState.dstBlend);
				WebGLContext.setBlendFunc(gl, srcBlend, dstBlend);
				break;
			case RenderState.BLEND_ENABLE_SEPERATE: 
				WebGLContext.setBlend(gl, true);
				var srcRGB:* = _getRenderState(datas, Shader3D.RENDER_STATE_BLEND_SRC_RGB);
				srcRGB == null && (srcRGB = renderState.srcBlendRGB);
				var dstRGB:* = _getRenderState(datas, Shader3D.RENDER_STATE_BLEND_DST_RGB);
				dstRGB == null && (dstRGB = renderState.dstBlendRGB);
				var srcAlpha:* = _getRenderState(datas, Shader3D.RENDER_STATE_BLEND_SRC_ALPHA);
				srcAlpha == null && (srcAlpha = renderState.srcBlendAlpha);
				var dstAlpha:* = _getRenderState(datas, Shader3D.RENDER_STATE_BLEND_DST_ALPHA);
				dstAlpha == null && (dstAlpha = renderState.dstBlendAlpha);
				WebGLContext.setBlendFuncSeperate(gl, srcRGB, dstRGB, srcAlpha, dstAlpha);
				break;
			}
		}
		
		/**
		 * @private
		 */
		public function uploadRenderStateFrontFace(shaderDatas:ShaderData, isTarget:Boolean, transform:Transform3D):void {
			var gl:WebGLContext = LayaGL.instance;
			var renderState:RenderState = _shaderPass.renderState;
			var datas:Array = shaderDatas.getData();
			
			var cull:* = _getRenderState(datas, Shader3D.RENDER_STATE_CULL);
			cull == null && (cull = renderState.cull);
			
			var forntFace:int;
			switch (cull) {
			case RenderState.CULL_NONE: 
				WebGLContext.setCullFace(gl, false);
				break;
			case RenderState.CULL_FRONT: 
				WebGLContext.setCullFace(gl, true);
				if (isTarget) {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CCW;
					else
						forntFace = WebGLContext.CW;
				} else {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CW;
					else
						forntFace = WebGLContext.CCW;
				}
				WebGLContext.setFrontFace(gl, forntFace);
				break;
			case RenderState.CULL_BACK: 
				WebGLContext.setCullFace(gl, true);
				if (isTarget) {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CW;
					else
						forntFace = WebGLContext.CCW;
				} else {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CCW;
					else
						forntFace = WebGLContext.CW;
				}
				WebGLContext.setFrontFace(gl, forntFace);
				break;
			}
		}
		
		/**
		 * @private
		 */
		public function uploadCustomUniform(index:int, data:*):void {
			Stat.shaderCall += LayaGLRunner.uploadCustomUniform(LayaGL.instance, _customUniformParamsMap, index, data);
		}
		
		/**
		 * @private
		 * [NATIVE]
		 */
		public function _uniformMatrix2fvForNative(one:*, value:*):int {
			LayaGL.instance.uniformMatrix2fvEx(one.location, false, value);
			return 1;
		}
		
		/**
		 * @private
		 * [NATIVE]
		 */
		public function _uniformMatrix3fvForNative(one:*, value:*):int {
			LayaGL.instance.uniformMatrix3fvEx(one.location, false, value);
			return 1;
		}
		
		/**
		 * @private
		 * [NATIVE]
		 */
		public function _uniformMatrix4fvForNative(one:*, m:Float32Array):int {
			LayaGL.instance.uniformMatrix4fvEx(one.location, false, m);
			return 1;
		}
	}
}