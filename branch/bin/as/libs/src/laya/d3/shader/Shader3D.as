package laya.d3.shader {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.utils.Stat;
	import laya.utils.StringKey;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.utils.ShaderCompile;
	
	public class Shader3D extends BaseShader {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**shader变量提交周期，逐渲染单元。*/
		public static const PERIOD_RENDERELEMENT:int = 0;
		/**shader变量提交周期，逐材质。*/
		public static const PERIOD_MATERIAL:int = 1;
		/**shader变量提交周期，逐精灵和相机，注：因为精灵包含MVP矩阵，为复合属性，所以摄像机发生变化时也应提交。*/
		public static const PERIOD_SPRITE:int = 2;
		/**shader变量提交周期，逐相机。*/
		public static const PERIOD_CAMERA:int = 3;
		/**shader变量提交周期，逐场景。*/
		public static const PERIOD_SCENE:int = 4;
		
		private static var _TEXTURES:Array = /*[STATIC SAFE]*/ [WebGLContext.TEXTURE0, WebGLContext.TEXTURE1, WebGLContext.TEXTURE2, WebGLContext.TEXTURE3, WebGLContext.TEXTURE4, WebGLContext.TEXTURE5, WebGLContext.TEXTURE6,, WebGLContext.TEXTURE7, WebGLContext.TEXTURE8];
		public static var _includeFiles:* = {}; //shader里面inlcude的小文件
		private static var _count:int = 0;
		
		protected static var shaderParamsMap:Object = {"float": WebGLContext.FLOAT, "int": WebGLContext.INT, "bool": WebGLContext.BOOL, "vec2": WebGLContext.FLOAT_VEC2, "vec3": WebGLContext.FLOAT_VEC3, "vec4": WebGLContext.FLOAT_VEC4, "ivec2": WebGLContext.INT_VEC2, "ivec3": WebGLContext.INT_VEC3, "ivec4": WebGLContext.INT_VEC4, "bvec2": WebGLContext.BOOL_VEC2, "bvec3": WebGLContext.BOOL_VEC3, "bvec4": WebGLContext.BOOL_VEC4, "mat2": WebGLContext.FLOAT_MAT2, "mat3": WebGLContext.FLOAT_MAT3, "mat4": WebGLContext.FLOAT_MAT4, "sampler2D": WebGLContext.SAMPLER_2D, "samplerCube": WebGLContext.SAMPLER_CUBE};
	
		public static var nameKey:StringKey = new StringKey();
		
		public static function create(vs:String, ps:String, attributeMap:Object , sceneUniformMap:Object, cameraUniformMap:Object, spriteUniformMap:Object, materialUniformMap:Object, renderElementUniformMap:Object):Shader3D {
			return new Shader3D(vs, ps,attributeMap, sceneUniformMap,cameraUniformMap,spriteUniformMap,materialUniformMap,renderElementUniformMap);
		}
		
		public static function addInclude(fileName:String, txt:String):void {
			if (!txt || txt.length === 0)
				throw new Error("add shader include file err:" + fileName);
			if (_includeFiles[fileName])
				throw new Error("add shader include file err, has add:" + fileName);
			_includeFiles[fileName] = txt;
		}
	
		
		
		private var customCompile:Boolean = false;
		
		private var _attributeMap:Object; 
		private var _sceneUniformMap:Object;
		private var _cameraUniformMap:Object;
		private var _spriteUniformMap:Object;
		private var _materialUniformMap:Object;
		private var _renderElementUniformMap:Object;
		
		private var _vs:String
		private var _ps:String;
		private var _curActTexIndex:int = 0;
		private var _reCompile:Boolean;
		
		public var _vshader:*;
		public var _pshader:*
		public var _program:* = null;
		public var _attributeParams:Array = null;
		public var _uniformParams:Array = null;
		
		public var _attributeParamsMap:Array = [];
		public var _sceneUniformParamsMap:Array = [];
		public var _cameraUniformParamsMap:Array = [];
		public var _spriteUniformParamsMap:Array = [];
		public var _materialUniformParamsMap:Array = [];
		public var _renderElementUniformParamsMap:Array = [];
		
		public var _id:int;
		/**@private */
		public  var _uploadLoopCount:int;
		/**@private */
		public  var _uploadRenderElement:RenderElement;//TODO:是否会被篡改
		/**@private */
		public  var _uploadMaterial:BaseMaterial;
		/**@private */
		public  var _uploadSprite3D:Sprite3D;
		/**@private */
		public  var _uploadCamera:BaseCamera;
		/**@private */
		public  var _uploadScene:BaseScene;
		/**@private */
		public  var _uploadVertexBuffer:VertexBuffer3D;
		
		/**
		 * 根据vs和ps信息生成shader对象
		 * @param	vs
		 * @param	ps
		 * @param	name:
		 * @param	nameMap 帮助里要详细解释为什么需要nameMap
		 */
		public function Shader3D(vs:String, ps:String, attributeMap:Object, sceneUniformMap:Object, cameraUniformMap:Object, spriteUniformMap:Object,materialUniformMap:Object,renderElementUniformMap:Object) {
			if ((!vs) || (!ps)) throw "Shader Error";
			if (Render.isConchApp || Render.isFlash) {
				customCompile = true;
			}
			_id = ++_count;
			_vs = vs;
			_ps = ps;
			_attributeMap = attributeMap;
			_sceneUniformMap = sceneUniformMap;
			_cameraUniformMap = cameraUniformMap;
			_spriteUniformMap = spriteUniformMap;
			_materialUniformMap = materialUniformMap;
			_renderElementUniformMap = renderElementUniformMap;
			recreateResource();
		}
		
		override protected function recreateResource():void {
			startCreate();
			_compile();
			completeCreate();
			memorySize = 0;//忽略尺寸尺寸
		}
		
		override protected function detoryResource():void {
			WebGL.mainContext.deleteShader(_vshader);
			WebGL.mainContext.deleteShader(_pshader);
			WebGL.mainContext.deleteProgram(_program);
			_vshader = _pshader = _program = null;
			_attributeParams = null;
			_uniformParams = null;
			memorySize = 0;
			_curActTexIndex = 0;
		}
		
		private function _compile():void {
			if (!_vs || !_ps || _attributeParams|| _uniformParams)
				return;
			
			_reCompile = true;
			_attributeParams = [];
			_uniformParams = [];
			
			var text:Array = [_vs, _ps];
			var result:Object;
			if (customCompile)
				result = _preGetParams(_vs, _ps);
			var gl:WebGLContext = WebGL.mainContext;
			_program = gl.createProgram();
			_vshader = _createShader(gl, text[0], WebGLContext.VERTEX_SHADER);
			_pshader = _createShader(gl, text[1], WebGLContext.FRAGMENT_SHADER);
			
			gl.attachShader(_program, _vshader);
			gl.attachShader(_program, _pshader);
			gl.linkProgram(_program);
			if (!customCompile && !gl.getProgramParameter(_program, WebGLContext.LINK_STATUS)) {
				throw gl.getProgramInfoLog(_program);
			}
			
			var one:*, i:int, j:int, n:int, location:*;
			var attribNum:int = customCompile ? result.attributes.length : gl.getProgramParameter(_program, WebGLContext.ACTIVE_ATTRIBUTES); //得到attribute的个数
			
			for (i = 0; i < attribNum; i++) {
				var attrib:* = customCompile ? result.attributes[i] : gl.getActiveAttrib(_program, i); //attrib对象，{name,size,type}
				location = gl.getAttribLocation(_program, attrib.name); //用名字来得到location	
				one = {vartype: "attribute", ivartype: 0, attrib: attrib, location: location, name: attrib.name, type: attrib.type, isArray: false, isSame: false, preValue: null, indexOfParams: 0};
				_attributeParams.push(one);
			}
			var nUniformNum:int = customCompile ? result.uniforms.length : gl.getProgramParameter(_program, WebGLContext.ACTIVE_UNIFORMS); //个数
			
			for (i = 0; i < nUniformNum; i++) {
				var uniform:* = customCompile ? result.uniforms[i] : gl.getActiveUniform(_program, i);//得到uniform对象，包括名字等信息 {name,type,size}
				location = gl.getUniformLocation(_program, uniform.name); //用名字来得到location
				one = {vartype: "uniform", ivartype: 1, attrib: attrib, location: location, name: uniform.name, type: uniform.type, isArray: false, isSame: false, preValue: null, indexOfParams: 0};
				if (one.name.indexOf('[0]') > 0) {
					one.name = one.name.substr(0, one.name.length - 3);
					one.isArray = true;
					one.location = gl.getUniformLocation(_program, one.name);
				}
				_uniformParams.push(one);
				
			}
			
			for (i = 0, n = _attributeParams.length; i < n; i++) {
				one = _attributeParams[i];
				one.indexOfParams = i;
				one.index = 1;
				one.value = [one.location, null];
				one.codename = one.name;
				one.name = (_attributeMap[one.codename] != null) ? _attributeMap[one.codename] : one.codename;
				_attributeParamsMap.push(one.name);
				_attributeParamsMap.push(one);
				
				one._this = this;
				one.uploadedValue = [];
				one.fun = _attribute;
			}
			
			
			for (i = 0, n = _uniformParams.length; i < n; i++) {
				one = _uniformParams[i];
				one.indexOfParams = i;
				one.index = 1;
				one.value = [one.location, null];
				one.codename = one.name;
				
				if (_sceneUniformMap[one.codename] != null)
				{
					one.name = _sceneUniformMap[one.codename];
					_sceneUniformParamsMap.push(one.name);
				   _sceneUniformParamsMap.push(one);
				}
				else if  (_cameraUniformMap[one.codename] != null)
				{
					one.name = _cameraUniformMap[one.codename];
					_cameraUniformParamsMap.push(one.name);
				   _cameraUniformParamsMap.push(one);
				}
				else if  (_spriteUniformMap[one.codename] != null)
				{
					one.name = _spriteUniformMap[one.codename];
					_spriteUniformParamsMap.push(one.name);
				   _spriteUniformParamsMap.push(one);
				}
				else if  (_materialUniformMap[one.codename] != null)
				{
					one.name = _materialUniformMap[one.codename];
					_materialUniformParamsMap.push(one.name);
				   _materialUniformParamsMap.push(one);
				}
				else if  (_renderElementUniformMap[one.codename] != null)
				{
					one.name = _renderElementUniformMap[one.codename];
					_renderElementUniformParamsMap.push(one.name);
				   _renderElementUniformParamsMap.push(one);
				}
				else
				{
					trace("Shader:can't find uinform name:"+ one.codename+"in shader file.");
				}
				
				one._this = this;
				one.uploadedValue = [];
				
				switch (one.type) {
				case WebGLContext.INT: 
					one.fun = one.isArray ? this._uniform1iv : this._uniform1i;
					break;
				case WebGLContext.FLOAT: 
					one.fun = one.isArray ? this._uniform1fv : this._uniform1f;
					break;
				case WebGLContext.FLOAT_VEC2: 
					one.fun =one.isArray ? this._uniform_vec2v:this._uniform_vec2;
					break;
				case WebGLContext.FLOAT_VEC3: 
					one.fun =one.isArray ?  this._uniform_vec3v:this._uniform_vec3;
					break;
				case WebGLContext.FLOAT_VEC4: 
					one.fun =one.isArray ?  this._uniform_vec4v:this._uniform_vec4;
					break;
				case WebGLContext.SAMPLER_2D: 
					one.fun = this._uniform_sampler2D;
					break;
				case WebGLContext.SAMPLER_CUBE: 
					one.fun = this._uniform_samplerCube;
					break;
				case WebGLContext.FLOAT_MAT4: 
					one.fun = this._uniformMatrix4fv;
					break;
				case WebGLContext.BOOL: 
					one.fun = this._uniform1i;
					break;
				case WebGLContext.FLOAT_MAT2: 
				case WebGLContext.FLOAT_MAT3: 
					throw new Error("compile shader err!");
					break;
				default: 
					throw new Error("compile shader err!");
					break;
				}
			}
		}
		
		private static function _createShader(gl:WebGLContext, str:String, type:*):* {
			var shader:* = gl.createShader(type);
			gl.shaderSource(shader, str);
			gl.compileShader(shader);
			/*[IF-FLASH]*/
			return shader;
			if (!gl.getShaderParameter(shader, WebGLContext.COMPILE_STATUS)) {
				throw gl.getShaderInfoLog(shader);
			}
			return shader;
		}
		
		private function _attribute(one:*, value:*):int {
			var gl:WebGLContext = WebGL.mainContext;
			gl.enableVertexAttribArray(one.location);
			gl.vertexAttribPointer(one.location, value[0], value[1], value[2], value[3], value[4]);
			return 2;
		}
		
		private function _uniform1f(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value) {
				WebGL.mainContext.uniform1f(one.location, uploadedValue[0] = value);
				return 1;
			}
			return 0;
		}
		
		private function _uniform1fv(one:*, value:*):int {
			if (value.length < 4) {
				var uploadedValue:Array = one.uploadedValue;
				if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2] || uploadedValue[3] !== value[3]) {
					WebGL.mainContext.uniform1fv(one.location, value);
					uploadedValue[0] = value[0];
					uploadedValue[1] = value[1];
					uploadedValue[2] = value[2];
					uploadedValue[3] = value[3];
					return 1;
				}
				return 0;
			} else {
				WebGL.mainContext.uniform1fv(one.location, value);
				return 1;
			}
		}
		
		private function _uniform_vec2(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1]) {
				WebGL.mainContext.uniform2f(one.location, uploadedValue[0] = value[0], uploadedValue[1] = value[1]);
				return 1;
			}
			return 0;
		}
		
		private function _uniform_vec2v(one:*, value:*):int {
			if (value.length < 2) {
				var uploadedValue:Array = one.uploadedValue;
				if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2] || uploadedValue[3] !== value[3]) {
					WebGL.mainContext.uniform2fv(one.location, value);
					uploadedValue[0] = value[0];
					uploadedValue[1] = value[1];
					uploadedValue[2] = value[2];
					uploadedValue[3] = value[3];
					return 1;
				}
				return 0;
			} else {
				WebGL.mainContext.uniform2fv(one.location, value);
				return 1;
			}
		}
		
		private function _uniform_vec3(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2]) {
				WebGL.mainContext.uniform3f(one.location, uploadedValue[0] = value[0], uploadedValue[1] = value[1], uploadedValue[2] = value[2]);
				return 1;
			}
			return 0;
		}
		
		private function _uniform_vec3v(one:*, value:*):int {
			WebGL.mainContext.uniform3fv(one.location, value);
			return 1;
		}
		
		private function _uniform_vec4(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2] || uploadedValue[3] !== value[3]) {
				WebGL.mainContext.uniform4f(one.location, uploadedValue[0] = value[0], uploadedValue[1] = value[1], uploadedValue[2] = value[2], uploadedValue[3] = value[3]);
				return 1;
			}
			return 0;
		}
		
		private function _uniform_vec4v(one:*, value:*):int {
			WebGL.mainContext.uniform4fv(one.location, value);
			return 1;
		}
		
		private function _uniformMatrix2fv(one:*, value:*):int {
			WebGL.mainContext.uniformMatrix2fv(one.location, false, value);
			return 1;
		}
		
		private function _uniformMatrix3fv(one:*, value:*):int {
			WebGL.mainContext.uniformMatrix3fv(one.location, false, value);
			return 1;
		}
		
		private function _uniformMatrix4fv(one:*, value:*):int {
			WebGL.mainContext.uniformMatrix4fv(one.location, false, value);
			return 1;
		}
		
		private function _uniform1i(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value) {
				WebGL.mainContext.uniform1i(one.location, uploadedValue[0] = value);
				return 1;
			}
			return 0;
		}
		
		private function _uniform1iv(one:*, value:*):int {
			WebGL.mainContext.uniform1iv(one.location, value);
			return 1;
		}
		
		private function _uniform_ivec2(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1]) {
				WebGL.mainContext.uniform2i(one.location, uploadedValue[0] = value[0], uploadedValue[1] = value[1]);
				return 1;
			}
			return 0;
		}
		
		private function _uniform_ivec2v(one:*, value:*):int {
			WebGL.mainContext.uniform2iv(one.location, value);
			return 1;
		}
		
		private function _uniform_vec3i(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2]) {
				WebGL.mainContext.uniform3i(one.location, uploadedValue[0] = value[0], uploadedValue[1] = value[1], uploadedValue[2] = value[2]);
				return 1;
			}
			return 0;
		}
		
		private function _uniform_vec3vi(one:*, value:*):int {
			WebGL.mainContext.uniform3iv(one.location, value);
			return 1;
		}
		
		private function _uniform_vec4i(one:*, value:*):int {
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] !== value[0] || uploadedValue[1] !== value[1] || uploadedValue[2] !== value[2] || uploadedValue[3] !== value[3]) {
				WebGL.mainContext.uniform4i(one.location, uploadedValue[0] = value[0], uploadedValue[1] = value[1], uploadedValue[2] = value[2], uploadedValue[3] = value[3]);
				return 1;
			}
			return 0;
		}
		
		private function _uniform_vec4vi(one:*, value:*):int {
			WebGL.mainContext.uniform4iv(one.location, value);
			return 1;
		}
		
		private function _uniform_sampler2D(one:*, value:*):int {//TODO:TEXTURTE ARRAY
			var gl:WebGLContext = WebGL.mainContext;
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] == null) {
				uploadedValue[0] = _curActTexIndex;
				gl.uniform1i(one.location, _curActTexIndex);
				gl.activeTexture(_TEXTURES[_curActTexIndex]);
				WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, value);
				_curActTexIndex++;
				return 1;
			} else {
				gl.activeTexture(_TEXTURES[uploadedValue[0]]);
				WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, value);
				return 0;
			}
		}
		
		private function _uniform_samplerCube(one:*, value:*):int {//TODO:TEXTURTECUBE ARRAY
			var gl:WebGLContext = WebGL.mainContext;
			var uploadedValue:Array = one.uploadedValue;
			if (uploadedValue[0] == null) {
				uploadedValue[0] = _curActTexIndex;
				gl.uniform1i(one.location, _curActTexIndex);
				gl.activeTexture(_TEXTURES[_curActTexIndex]);
				WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_CUBE_MAP, value);
				_curActTexIndex++;
				return 1;
			} else {
				gl.activeTexture(_TEXTURES[uploadedValue[0]]);
				WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_CUBE_MAP, value);
				return 0;
			}
		}
		
		private function _noSetValue(one:*):void {
			trace("no....:" + one.name);
			//throw new Error("upload shader err,must set value:"+one.name);
		}
		
		public function uploadTexture2D(value:*):void {
			Stat.shaderCall++;
			var gl:WebGLContext = WebGL.mainContext;
			gl.activeTexture(WebGLContext.TEXTURE0);
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, value);
		}
		
		
		public function bind():Boolean{
			BaseShader.activeShader = this;
			BaseShader.bindShader = this;
			activeResource();
			return WebGLContext.UseProgram(_program);
		}
		
		
		/**
		 * 按数组的定义提交
		 * @param	shaderValue 数组格式[name,value,...]
		 */
		public function uploadAttributes(attributeShaderValue:Array, _bufferUsage:*):void {
			var value:*;
			var one:*, shaderCall:int = 0;
			for (var i:int =0,n:int=_attributeParamsMap.length; i < n; i += 2) {
				one = _attributeParamsMap[i+1];
				value = attributeShaderValue[_attributeParamsMap[i]];
				if (value != null) {
					_bufferUsage && _bufferUsage[one.name] && _bufferUsage[one.name].bind();
					shaderCall += one.fun.call(this, one, value);
				}
			}
			Stat.shaderCall += shaderCall;
		}
		
		
		
		/**
		 * 按数组的定义提交
		 * @param	shaderValue 数组格式[name,value,...]
		 */
		public function uploadSceneUniforms(shaderValue:Array):void {
			var value:*;
			var one:*, shaderCall:int = 0;
			for (var i:int =0,n:int=_sceneUniformParamsMap.length; i < n; i += 2) {
				one = _sceneUniformParamsMap[i+1];
				value = shaderValue[_sceneUniformParamsMap[i]];
				if (value != null)
					shaderCall += one.fun.call(this, one, value);
			}
			Stat.shaderCall += shaderCall;
		}
		
		/**
		 * 按数组的定义提交
		 * @param	shaderValue 数组格式[name,value,...]
		 */
		public function uploadCameraUniforms(shaderValue:Array):void {
			var value:*;
			var one:*, shaderCall:int = 0;
			for (var i:int =0,n:int=_cameraUniformParamsMap.length; i < n; i += 2) {
				one = _cameraUniformParamsMap[i+1];
				value = shaderValue[_cameraUniformParamsMap[i]];
				if (value != null)
					shaderCall += one.fun.call(this, one, value);
			}
			Stat.shaderCall += shaderCall;
		}
		
		/**
		 * 按数组的定义提交
		 * @param	shaderValue 数组格式[name,value,...]
		 */
		public function uploadSpriteUniforms(shaderValue:Array):void {
			var value:*;
			var one:*, shaderCall:int = 0;
		    for (var i:int =0,n:int=_spriteUniformParamsMap.length; i < n; i += 2) {
				one = _spriteUniformParamsMap[i+1];
				value = shaderValue[_spriteUniformParamsMap[i]];
				if (value != null)
					shaderCall += one.fun.call(this, one, value);
			}
			Stat.shaderCall += shaderCall;
		}
		
		/**
		 * 按数组的定义提交
		 * @param	shaderValue 数组格式[name,value,...]
		 */
		public function uploadMaterialUniforms(shaderValue:Array):void {
			var value:*;
			var one:*, shaderCall:int = 0;
			for (var i:int =0,n:int=_materialUniformParamsMap.length; i < n; i += 2) {
				one = _materialUniformParamsMap[i+1];
				value = shaderValue[_materialUniformParamsMap[i]];
				if (value != null)
					shaderCall += one.fun.call(this, one, value);
			}
			Stat.shaderCall += shaderCall;
		}
		
		/**
		 * 按数组的定义提交
		 * @param	shaderValue 数组格式[name,value,...]
		 */
		public function uploadRenderElementUniforms(shaderValue:Array):void {
			var value:*;
			var one:*, shaderCall:int = 0;
			for (var i:int =0,n:int=_renderElementUniformParamsMap.length; i < n; i += 2) {
				one = _renderElementUniformParamsMap[i+1];
				value = shaderValue[_renderElementUniformParamsMap[i]];
				if (value != null)
					shaderCall += one.fun.call(this, one, value);
			}
			Stat.shaderCall += shaderCall;
		}

		
		
		protected function _preGetParams(vs:String, ps:String):Object {
			var text:Array = [vs, ps];
			var result:Object = {};
			var attributes:Array = [];
			var uniforms:Array = [];
			var definesInfo:Object = {};
			var definesName:Array = [];
			result.attributes = attributes;
			result.uniforms = uniforms;
			result.defines = definesInfo;
			var removeAnnotation:RegExp = new RegExp("(/\\*([^*]|[\\r\\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/)|(//.*)", "g");
			var reg:RegExp = new RegExp("(\".*\")|('.*')|([#\\w\\*-\\.+/()=<>{}\\\\]+)|([,;:\\\\])", "g");
			
			var i:int, n:int, one:*;
			for (var s:int = 0; s < 2; s++) {
				text[s] = text[s].replace(removeAnnotation, "");
				
				var words:Array = text[s].match(reg);
				var tempelse:String;
				for (i = 0, n = words.length; i < n; i++) {
					var word:String = words[i];
					if (word != "attribute" && word != "uniform") {
						//str += word;
						if (word == "#define") {
							word = words[++i];
							definesName[word] = 1;
							continue;
						} else if (word == "#ifdef") {
							tempelse = words[++i]
							var def:Array = definesInfo[tempelse] = definesInfo[tempelse] || [];
							for (i++; i < n; i++) {
								word = words[i];
								if (word != "attribute" && word != "uniform") {
									if (word == "#else") {
										for (i++; i < n; i++) {
											word = words[i];
											if (word != "attribute" && word != "uniform") {
												if (word == "#endif") {
													break;
												}
												continue;
											}
											i = parseOne(attributes, uniforms, words, i, word, !definesName[tempelse]);
										}
									}
									continue;
								}
								i = parseOne(attributes, uniforms, words, i, word, definesName[tempelse]);
							}
						}
						//if (word != ";") str += " ";
						continue;
					}
					i = parseOne(attributes, uniforms, words, i, word, true);
				}
					//text[s] = str;
			}
			return result;
		}
		
		private function parseOne(attributes:Array, uniforms:Array, words:Array, i:int, word:String, b:Boolean):int {
			var one:* = {type: shaderParamsMap[words[i + 1]], name: words[i + 2], size: isNaN(parseInt(words[i + 3])) ? 1 : parseInt(words[i + 3])};
			if (b) {
				if (word == "attribute") {
					attributes.push(one);
				} else {
					uniforms.push(one);
				}
			}
			//str += one.vartype + " " + one.type + " " + one.name + " ";
			if (words[i + 3] == ':') {
				one.type = words[i + 4];
				i += 2;
			}
			i += 2;
			return i;
		}
		
		override public function dispose():void {
			resourceManager.removeResource(this);
			super.dispose();
		}
	
	}
}