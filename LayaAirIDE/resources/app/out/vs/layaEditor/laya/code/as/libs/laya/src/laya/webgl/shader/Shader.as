package laya.webgl.shader {
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.utils.Browser;
	import laya.resource.Texture;
	import laya.utils.Stat;
	import laya.utils.StringKey;
	import laya.webgl.utils.Buffer;
	import laya.webgl.shader.d2.filters.ColorFilter;
	import laya.webgl.shader.d2.filters.GlowFilterShader;
	import laya.webgl.utils.GlUtils;
	import laya.webgl.utils.ShaderCompile;
	import laya.webgl.submit.Submit;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.system.System;
	
	/**
	 * ...
	 * @author laya
	 */
	public class Shader extends Resource {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _TEXTURES:Array = /*[STATIC SAFE]*/ [WebGLContext.TEXTURE0, WebGLContext.TEXTURE1, WebGLContext.TEXTURE2, WebGLContext.TEXTURE3, WebGLContext.TEXTURE4, WebGLContext.TEXTURE5, WebGLContext.TEXTURE6,, WebGLContext.TEXTURE7, WebGLContext.TEXTURE8];
		private static var _includeFiles:* = {}; //shader里面inlcude的小文件
		private static var _count:int = 0;
		private static var _preCompileShader:* = {}; //存储预编译结果，可以通过名字获得内容,目前不支持#ifdef嵌套和条件
		private static var _uploadArrayCount:int = 1;
		
		protected static var shaderParamsMap:Object = {"float": WebGLContext.FLOAT, "int": WebGLContext.INT, "bool": WebGLContext.BOOL, "vec2": WebGLContext.FLOAT_VEC2, "vec3": WebGLContext.FLOAT_VEC3, "vec4": WebGLContext.FLOAT_VEC4, "ivec2": WebGLContext.INT_VEC2, "ivec3": WebGLContext.INT_VEC3, "ivec4": WebGLContext.INT_VEC4, "bvec2": WebGLContext.BOOL_VEC2, "bvec3": WebGLContext.BOOL_VEC3, "bvec4": WebGLContext.BOOL_VEC4, "mat2": WebGLContext.FLOAT_MAT2, "mat3": WebGLContext.FLOAT_MAT3, "mat4": WebGLContext.FLOAT_MAT4, "sampler2D": WebGLContext.SAMPLER_2D, "samplerCube": WebGLContext.SAMPLER_CUBE};
		
		public static const SHADERNAME2ID:Number = 0.0002;
		
		public static var activeShader:Shader;
		
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
		public static function withCompile(nameID:int, mainID:int, define:*, shaderName:*, createShader:Function):Shader {
			if (shaderName && sharders[shaderName])
				return sharders[shaderName];
			var pre:ShaderCompile = _preCompileShader[SHADERNAME2ID * nameID + mainID];
			if (!pre)
				throw new Error("withCompile shader err!" + nameID + " " + mainID);
			return pre.createShader(define, shaderName, createShader);
		}
		
		public static function addInclude(fileName:String, txt:String):void {
			if (!txt || txt.length === 0)
				throw new Error("add shader include file err:" + fileName);
			if (_includeFiles[fileName])
				throw new Error("add shader include file err, has add:" + fileName);
			_includeFiles[fileName] = txt;
		}
		
		/**
		 * 预编译shader文件，主要是处理宏定义
		 * @param	nameID,一般是特殊宏+shaderNameID*0.0002组成的一个浮点数当做唯一标识
		 * @param	vs
		 * @param	ps
		 */
		public static function preCompile(nameID:int, mainID:int, vs:String, ps:String, nameMap:*):void {
			var id:Number = SHADERNAME2ID * nameID + mainID;
			_preCompileShader[id] = new ShaderCompile(id, vs, ps, nameMap, _includeFiles);
		}
		
		private var customCompile:Boolean = false;
		
		private var _nameMap:*; //shader参数别名，语义
		private var _vs:String
		private var _ps:String;
		private var _texIndex:int;
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
			if (System.isConchApp) {
				customCompile = true;
			}
			_id = ++_count;
			_vs = vs;
			_ps = ps;
			_nameMap = nameMap ? nameMap : {};
			
			saveName != null && (sharders[saveName] = this);
		}
		
		override protected function recreateResource():void {
			startCreate();
			compile();
			compoleteCreate();
			memorySize = 0;//忽略尺寸尺寸
		}
		
		override protected function detoryResource():void {
			WebGL.mainContext.deleteShader(_vshader);
			WebGL.mainContext.deleteShader(_pshader);
			WebGL.mainContext.deleteProgram(_program);
			_vshader = _pshader = _program = null;
			_params = null;
			_paramsMap = {};
			memorySize = 0;
		}
		
		private function compileParams():void {
			//TODO:待定,某些参数是否不用回复uniform.location
		}
		

		private function compile():void {
			
			if (!_vs || !_ps || _params)
				return;
			_reCompile = true;
			_params = [];
			
			var text:Array = [_vs, _ps];
			var result:Object;
			if (customCompile)
				result = preGetParams(_vs, _ps);
			var gl:WebGLContext = WebGL.mainContext;
			_program = gl.createProgram();
			_vshader = _createShader(gl, text[0], WebGLContext.VERTEX_SHADER);
			_pshader = _createShader(gl, text[1], WebGLContext.FRAGMENT_SHADER);
			gl.attachShader(_program, _vshader);
			gl.attachShader(_program, _pshader);
			gl.linkProgram(_program);
			if (!gl.getProgramParameter(_program, WebGLContext.LINK_STATUS)) {
				throw gl.getProgramInfoLog(_program);
			}
			
			var one:*, i:int, j:int, n:int, location:*;
			var attribNum:int;
			if (customCompile)
				attribNum = result.attributes.length;//得到attribute的个数
			else
				attribNum = gl.getProgramParameter(_program, WebGLContext.ACTIVE_ATTRIBUTES); //得到attribute的个数
			for (i = 0; i < attribNum; i++) {
				var attrib:*;
				if (customCompile)
					attrib = result.attributes[i];//attrib对象，{name,size,type}
				else
					attrib = gl.getActiveAttrib(_program, i); //attrib对象，{name,size,type}
				
				location = gl.getAttribLocation(_program, attrib.name); //用名字来得到location	
				one = {vartype: "attribute", ivartype: 0, attrib: attrib, location: location, name: attrib.name, type: attrib.type, isArray: false, isSame: false, preValue: null, indexOfParams: 0};
				_params.push(one);
			}
			var nUniformNum:int;
			if (customCompile)
				nUniformNum = result.uniforms.length;//个数
			else
				nUniformNum = gl.getProgramParameter(_program, WebGLContext.ACTIVE_UNIFORMS); //个数
			
			for (i = 0; i < nUniformNum; i++) {
				var uniform:*;
				if (customCompile)
					uniform = result.uniforms[i]; //得到uniform对象，包括名字等信息 {name,type,size}
				else
					uniform = gl.getActiveUniform(_program, i); //得到uniform对象，包括名字等信息 {name,type,size}
				location = gl.getUniformLocation(_program, uniform.name); //用名字来得到location
				one = {vartype: "uniform", ivartype: 1, attrib: attrib, location: location, name: uniform.name, type: uniform.type, isArray: false, isSame: false, preValue: null, indexOfParams: 0};
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
				one.saveValue = [];
				if (one.vartype === "attribute") {
					one.fun = _attribute;
					continue;
				}
				
				switch (one.type) {
				case WebGLContext.FLOAT: 
					one.fun = one.isArray ? this._uniform1fv : this._uniform1f;
					break;
				case WebGLContext.FLOAT_VEC2: 
					one.fun = this._uniform_vec2;
					break;
				case WebGLContext.FLOAT_VEC3: 
					one.fun = this._uniform_vec3;
					break;
				case WebGLContext.FLOAT_VEC4: 
					one.fun = this._uniform_vec4;
					break;
				case WebGLContext.SAMPLER_2D: 
					one.fun = this._uniform_sampler2D;
					break;
				case WebGLContext.FLOAT_MAT4: 
					one.fun = this._uniformMatrix4fv;
					break;
				case WebGLContext.BOOL: 
					one.fun = this._uniform1i;
					break;
				case WebGLContext.SAMPLER_CUBE: 
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
			if (!gl.getShaderParameter(shader, WebGLContext.COMPILE_STATUS)) {
				throw gl.getShaderInfoLog(shader);
			}
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
			gl.enableVertexAttribArray(one.location);
			gl.vertexAttribPointer(one.location, value[0], value[1], value[2], value[3], value[4] + this._offset);
			return 2;
		}
		
		private function _uniformMatrix4fv(one:*, value:*):int {
			WebGL.mainContext.uniformMatrix4fv(one.location, false, value);
			return 1;
		}
		
		private function _uniform1i(one:*, value:*):int {
			var saveValue:Array = one.saveValue;
			if (saveValue[0] !== value) {
				WebGL.mainContext.uniform1i(one.location, saveValue[0] = value);
				return 1;
			}
			return 0;
		}
		
		private function _uniform1f(one:*, value:*):int {
			var saveValue:Array = one.saveValue;
			if (saveValue[0] !== value) {
				WebGL.mainContext.uniform1f(one.location, saveValue[0] = value);
				return 1;
			}
			return 0;
		}
		
		private function _uniform1fv(one:*, value:*):int {
			var saveValue:Array = one.saveValue;
			if (saveValue[0] !== value) {
				WebGL.mainContext.uniform1fv(one.location, saveValue[0] = value);
				return 1;
			}
			return 0;
		}
		
		private function _uniform_vec2(one:*, value:*):int {
			var saveValue:Array = one.saveValue;
			if (saveValue[0] !== value[0] || saveValue[1] !== value[1]) {
				WebGL.mainContext.uniform2f(one.location, saveValue[0] = value[0], saveValue[1] = value[1]);
				return 1;
			}
			return 0;
		}
		
		private function _uniform_vec3(one:*, value:*):int {
			WebGL.mainContext.uniform3f(one.location, value[0], value[1], value[2]);
			return 1;
		}
		
		private function _uniform_vec4(one:*, value:*):int {
			WebGL.mainContext.uniform4f(one.location, value[0], value[1], value[2], value[3]);
			return 1;
		}
		
		private function _uniform_sampler2D(one:*, value:*):int {
			var gl:WebGLContext = WebGL.mainContext;
			gl.activeTexture(_TEXTURES[this._texIndex]);
			gl.bindTexture(WebGLContext.TEXTURE_2D, value);
			var saveValue:Array = one.saveValue;
			if (saveValue[0] !== _texIndex)
				gl.uniform1i(one.location, saveValue[0] = _texIndex);
			this._texIndex++;
			return 1;
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
		
		/**
		 * 提交shader到GPU
		 * @param	shaderValue
		 */
		public function upload(shaderValue:ShaderValue, params:Array = null):void {
			activeShader = this;
			activeResource();
			WebGLContext.UseProgram(_program);
			_texIndex = 0;

			if (_reCompile) {
				params = _params;
				_reCompile = false;
			} else {
				params = params || _params;
			}
			
			var one:*, value:*, n:int = params.length, shaderCall:int = 0;
			
			for (var i:int = 0; i < n; i++) {
				one = params[i];
				((value = shaderValue[one.name]) !== null) && (shaderCall += one.fun.call(this, one, value));
				
			}
			Stat.shaderCall += shaderCall;
		}
		
		/**
		 * 按数组的定义提交
		 * @param	shaderValue 数组格式[name,[value,id],...]
		 */
		public function uploadArray(shaderValue:Array, length:int, _bufferUsage:*):void {
			activeShader = this;
			activeResource();
			_texIndex = 0;
			var sameProgram:Boolean = !WebGLContext.UseProgram(_program);
			var params:* = _params, value:*;
			var one:*, shaderCall:int = 0, uploadArrayCount:int = _uploadArrayCount++;
			
			for (var i:int = length - 2; i >= 0; i -= 2) {
				one = _paramsMap[shaderValue[i]]
				if (!one || one._uploadArrayCount === uploadArrayCount)
					continue;
				
				one._uploadArrayCount = uploadArrayCount;
				
				var v:Array = shaderValue[i + 1];
				
				var uid:Number = v[1];
				if (sameProgram && one.ivartype === 1 && uid > 0 && uid === one.__uploadid)
					continue;
				
				value = v[0];
				if (value != null) {
					_bufferUsage && _bufferUsage[one.name] && _bufferUsage[one.name].bind();
					shaderCall += one.fun.call(this, one, value);
					one.__uploadid = uid;
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
		
		protected function preGetParams(vs:String, ps:String):Object {
			var text:Array = [vs, ps];
			var result:Object = {};
			var attributes:Array = [];
			var uniforms:Array = [];
			result.attributes = attributes;
			result.uniforms = uniforms;
			
			var removeAnnotation:RegExp = new RegExp("(/\\*([^*]|[\\r\\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/)|(//.*)", "g");
			var reg:RegExp = new RegExp("(\".*\")|('.*')|([\\w\\*-\\.+/()=<>{}\\\\]+)|([,;:\\\\])", "g");
			
			var i:int, n:int, one:*;
			for (var s:int = 0; s < 2; s++) {
				text[s] = text[s].replace(removeAnnotation, "");
				
				var words:Array = text[s].match(reg);
				var str:String = "";
				var ofs:int;
				for (i = 0, n = words.length; i < n; i++) {
					var word:String = words[i];
					if (word != "attribute" && word != "uniform") {
						str += word;
						if (word != ";") str += " ";
						continue;
					}
					one = {type: shaderParamsMap[words[i + 1]], name: words[i + 2], size: isNaN(parseInt(words[i + 3])) ? 1 : parseInt(words[i + 3])};
					if (word == "attribute") {
						attributes.push(one);
					} else {
						uniforms.push(one);
					}
					str += one.vartype + " " + one.type + " " + one.name + " ";
					if (words[i + 3] == ':') {
						one.type = words[i + 4];
						i += 2;
					}
					i += 2;
				}
				text[s] = str;
			}
			return result;
		}
		
		override public function dispose():void {
			resourceManager.removeResource(this);
			super.dispose();
		}
	
	}
}