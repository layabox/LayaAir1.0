package laya.webgl.shader {
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.utils.Stat;
	import laya.utils.StringKey;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.ShaderCompile;
	
	public class Shader extends BaseShader {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _TEXTURES:Array = /*[STATIC SAFE]*/ [WebGLContext.TEXTURE0, WebGLContext.TEXTURE1, WebGLContext.TEXTURE2, WebGLContext.TEXTURE3, WebGLContext.TEXTURE4, WebGLContext.TEXTURE5, WebGLContext.TEXTURE6,, WebGLContext.TEXTURE7, WebGLContext.TEXTURE8];
		private static var _count:int = 0;
		public static var _preCompileShader:* = {}; //存储预编译结果，可以通过名字获得内容,目前不支持#ifdef嵌套和条件
		
		public static const SHADERNAME2ID:Number = 0.0002;
		
		
		public static var nameKey:StringKey = new StringKey();
		
		public static var sharders:Array = /*[STATIC SAFE]*/ (sharders = [], sharders.length = 0x20, sharders);
		
		public static function getShader(name:*):Shader {
			return sharders[name];
		}
		
		public static function create(vs:String, ps:String, saveName:* = null, nameMap:* = null):Shader {
			return new Shader(vs, ps, saveName, nameMap);
		}
		
		/**
		 * 根据宏动态生成shader文件，支持#include?COLOR_FILTER "parts/ColorFilter_ps_logic.glsl";条件嵌入文件
		 * @param	name
		 * @param	vs
		 * @param	ps
		 * @param	define 宏定义，格式:{name:value...}
		 * @return
		 */
		public static function withCompile(nameID:int, define:*, shaderName:*, createShader:Function):Shader {
			if (shaderName && sharders[shaderName])
				return sharders[shaderName];
			
			var pre:ShaderCompile = _preCompileShader[SHADERNAME2ID * nameID];
			if (!pre)
				throw new Error("withCompile shader err!" + nameID);
			return pre.createShader(define, shaderName, createShader);
		}
		
		/**
		 * 根据宏动态生成shader文件，支持#include?COLOR_FILTER "parts/ColorFilter_ps_logic.glsl";条件嵌入文件
		 * @param	name
		 * @param	vs
		 * @param	ps
		 * @param	define 宏定义，格式:{name:value...}
		 * @return
		 */
		public static function withCompile2D(nameID:int, mainID:int, define:*, shaderName:*, createShader:Function):Shader {
			if (shaderName && sharders[shaderName])
				return sharders[shaderName];
			
			var pre:ShaderCompile = _preCompileShader[SHADERNAME2ID * nameID + mainID];
			if (!pre)
				throw new Error("withCompile shader err!" + nameID + " " + mainID);
			return pre.createShader(define, shaderName, createShader);
		}
		
		public static function addInclude(fileName:String, txt:String):void {
			ShaderCompile.addInclude(fileName, txt);
		}
		
		/**
		 * 预编译shader文件，主要是处理宏定义
		 * @param	nameID,一般是特殊宏+shaderNameID*0.0002组成的一个浮点数当做唯一标识
		 * @param	vs
		 * @param	ps
		 */
		public static function preCompile(nameID:int, vs:String, ps:String, nameMap:*):void {
			var id:Number = SHADERNAME2ID * nameID;
			_preCompileShader[id] = new ShaderCompile(id, vs, ps, nameMap);
		}
		
		/**
		 * 预编译shader文件，主要是处理宏定义
		 * @param	nameID,一般是特殊宏+shaderNameID*0.0002组成的一个浮点数当做唯一标识
		 * @param	vs
		 * @param	ps
		 */
		public static function preCompile2D(nameID:int, mainID:int, vs:String, ps:String, nameMap:*):void {
			var id:Number = SHADERNAME2ID * nameID + mainID;
			_preCompileShader[id] = new ShaderCompile(id, vs, ps, nameMap);
		}
		
		private var customCompile:Boolean = false;
		
		private var _nameMap:*; //shader参数别名，语义
		private var _vs:String
		private var _ps:String;
		private var _curActTexIndex:int = 0;
		private var _reCompile:Boolean;
		
		//存储一些私有变量
		public var tag:* = {};
		
		public var _vshader:*;
		public var _pshader:*
		public var _program:* = null;
		public var _params:Array = null;
		public var _paramsMap:* = {};
		public var _offset:int = 0;
		public var _id:int;
		
		/**
		 * 根据vs和ps信息生成shader对象
		 * @param	vs
		 * @param	ps
		 * @param	name:
		 * @param	nameMap 帮助里要详细解释为什么需要nameMap
		 */
		public function Shader(vs:String, ps:String, saveName:* = null, nameMap:* = null) {
			super();
			if ((!vs) || (!ps)) throw "Shader Error";
			
			if (Render.isConchApp || Render.isFlash) {
				customCompile = true;
			}
			_id = ++_count;
			_vs = vs;
			_ps = ps;
			_nameMap = nameMap ? nameMap : {};
			saveName != null && (sharders[saveName] = this);
		}
		
		override protected function recreateResource():void {
			_compile();
			completeCreate();
			memorySize = 0;//忽略尺寸尺寸
		}
		
		override protected function disposeResource():void {
			WebGL.mainContext.deleteShader(_vshader);
			WebGL.mainContext.deleteShader(_pshader);
			WebGL.mainContext.deleteProgram(_program);
			_vshader = _pshader = _program = null;
			_params = null;
			_paramsMap = {};
			memorySize = 0;
			_curActTexIndex = 0;
		}
		
		private function _compile():void {
			if (!_vs || !_ps || _params)
				return;
			
			_reCompile = true;
			_params = [];
			
			var text:Array = [_vs, _ps];
			var result:Object;
			if (customCompile)
				result =ShaderCompile.preGetParams(_vs, _ps);
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
			//trace(_vs);
			//trace(_ps);
			
			var one:*, i:int, j:int, n:int, location:*;
			var attribNum:int = customCompile ? result.attributes.length : gl.getProgramParameter(_program, WebGLContext.ACTIVE_ATTRIBUTES); //得到attribute的个数
			
			for (i = 0; i < attribNum; i++) {
				var attrib:* = customCompile ? result.attributes[i] : gl.getActiveAttrib(_program, i); //attrib对象，{name,size,type}
				location = gl.getAttribLocation(_program, attrib.name); //用名字来得到location	
				one = {vartype: "attribute", glfun:null, ivartype: 0, attrib: attrib, location: location, name: attrib.name, type: attrib.type, isArray: false, isSame: false, preValue: null, indexOfParams: 0};
				_params.push(one);
			}
			var nUniformNum:int = customCompile ? result.uniforms.length : gl.getProgramParameter(_program, WebGLContext.ACTIVE_UNIFORMS); //个数
			
			for (i = 0; i < nUniformNum; i++) {
				var uniform:* = customCompile ? result.uniforms[i] : gl.getActiveUniform(_program, i);//得到uniform对象，包括名字等信息 {name,type,size}
				location = gl.getUniformLocation(_program, uniform.name); //用名字来得到location
				one = {vartype: "uniform",glfun:null,ivartype: 1, attrib: attrib, location: location, name: uniform.name, type: uniform.type, isArray: false, isSame: false, preValue: null, indexOfParams: 0};
				if (one.name.indexOf('[0]') > 0) {
					one.name = one.name.substr(0, one.name.length - 3);
					one.isArray = true;
					one.location = gl.getUniformLocation(_program, one.name);
				}
				_params.push(one);				
			}
			
			for (i = 0, n = _params.length; i < n; i++) {
				one = _params[i];
				one.indexOfParams = i;
				one.index = 1;
				one.value = [one.location, null];
				one.codename = one.name;
				one.name = _nameMap[one.codename] ? _nameMap[one.codename] : one.codename;
				_paramsMap[one.name] = one;
				one._this = this;
				one.uploadedValue = [];
				if (one.vartype === "attribute") {
					one.fun = _attribute;
					continue;
				}
				
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
					one.glfun = gl.uniformMatrix4fv;
					one.fun=this._uniformMatrix4fv;
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
			return shader;
		}
		
		/**
		 * 根据变量名字获得
		 * @param	name
		 * @return
		 */
		public function getUniform(name:String):* {
			return _paramsMap[name];
		}
		
		private function _attribute(one:*, value:*):int {
			var gl:WebGLContext = WebGL.mainContext;
			var enableAtributes:Array = Buffer._enableAtributes;
			var location:int = one.location;
			(enableAtributes[location])||(gl.enableVertexAttribArray(location));
			gl.vertexAttribPointer(location, value[0], value[1], value[2], value[3], value[4] + this._offset);
			enableAtributes[location] = Buffer._bindVertexBuffer;
			return 1;
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
		
		public function uploadOne(name:String, value:*):void {
			activeResource();
			WebGLContext.UseProgram(_program);
			var one:* = _paramsMap[name];
			one.fun.call(this, one, value);
		}
		
		public function uploadTexture2D(value:*):void {
			Stat.shaderCall++;
			var gl:WebGLContext = WebGL.mainContext;
			gl.activeTexture(WebGLContext.TEXTURE0);
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, value);
		}
		
		/**
		 * 提交shader到GPU
		 * @param	shaderValue
		 */
		public function upload(shaderValue:ShaderValue, params:Array = null):void {
			activeShader = bindShader = this;
			
			_lastUseFrameCount===Stat.loopCount  || activeResource();
			WebGLContext.UseProgram(_program);
			
			if (_reCompile) {
				params = _params;
				_reCompile = false;
			} else {
				params = params || _params;
			}
			
			var gl:WebGLContext = WebGL.mainContext;
			
			var one:*, value:*, n:int = params.length, shaderCall:int = 0;
			
			for (var i:int = 0; i < n; i++) {
				one = params[i];
				if ((value = shaderValue[one.name]) !== null) 
				
					shaderCall+=one.fun.call(this, one, value);
					/*
					one.glfun?
						one.glfun.call(gl, one.location, false, value):
						one.fun.call(this, one, value);*/
			}
			
			Stat.shaderCall += shaderCall;
		}
		
		/**
		 * 按数组的定义提交
		 * @param	shaderValue 数组格式[name,value,...]
		 */
		public function uploadArray(shaderValue:Array, length:int, _bufferUsage:*):void {
			activeShader = this;
			bindShader = this;
			activeResource();
			WebGLContext.UseProgram(_program);
			var params:* = _params, value:*;
			var one:*, shaderCall:int = 0;
			for (var i:int = length - 2; i >= 0; i -= 2) {
				one = _paramsMap[shaderValue[i]];
				if (!one)
					continue;
				
				value = shaderValue[i + 1];
				if (value != null) {
					_bufferUsage && _bufferUsage[one.name] && _bufferUsage[one.name].bind();
					shaderCall += one.fun.call(this, one, value);
				}
			}
			Stat.shaderCall += shaderCall;
		}
		
		/**
		 * 得到编译后的变量及相关预定义
		 * @return
		 */
		public function getParams():Array {
			return _params;
		}		
	}
}