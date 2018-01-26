package laya.webgl.utils {
	import laya.utils.Browser;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	
	/**
	 * @private
	 * <code>ShaderCompile</code> 类用于实现Shader编译。
	 */
	public class ShaderCompile {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const IFDEF_NO:int = 0;
		public static const IFDEF_YES:int = 1;
		public static const IFDEF_ELSE:int = 2;
		public static const IFDEF_PARENT:int = 3;
		
		public static var _removeAnnotation:RegExp=/*[STATIC SAFE]*/new RegExp("(/\\*([^*]|[\\r\\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/)|(//.*)", "g");
		public static var _reg:RegExp =/*[STATIC SAFE]*/new RegExp("(\".*\")|('.*')|([#\\w\\*-\\.+/()=<>{}\\\\]+)|([,;:\\\\])", "g");
		public static var _splitToWordExps:RegExp =/*[STATIC SAFE]*/new RegExp("[(\".*\")]+|[('.*')]+|([ \\t=\\+\\-*/&%!<>!%\(\),;])", "g");
		
		public static var includes:* = {};
		public static var shaderParamsMap:Object = {"float": WebGLContext.FLOAT, "int": WebGLContext.INT, "bool": WebGLContext.BOOL, "vec2": WebGLContext.FLOAT_VEC2, "vec3": WebGLContext.FLOAT_VEC3, "vec4": WebGLContext.FLOAT_VEC4, "ivec2": WebGLContext.INT_VEC2, "ivec3": WebGLContext.INT_VEC3, "ivec4": WebGLContext.INT_VEC4, "bvec2": WebGLContext.BOOL_VEC2, "bvec3": WebGLContext.BOOL_VEC3, "bvec4": WebGLContext.BOOL_VEC4, "mat2": WebGLContext.FLOAT_MAT2, "mat3": WebGLContext.FLOAT_MAT3, "mat4": WebGLContext.FLOAT_MAT4, "sampler2D": WebGLContext.SAMPLER_2D, "samplerCube": WebGLContext.SAMPLER_CUBE};
		
		private var _nameMap:*;
		protected var _VS:ShaderNode;
		protected var _PS:ShaderNode;
		
		private static function _parseOne(attributes:Array, uniforms:Array, words:Array, i:int, word:String, b:Boolean):int {
			var one:* = {type: shaderParamsMap[words[i + 1]], name: words[i + 2], size: isNaN(parseInt(words[i + 3])) ? 1 : parseInt(words[i + 3])};
			if (b) {
				if (word == "attribute") {
					attributes.push(one);
				} else {
					uniforms.push(one);
				}
			}
			if (words[i + 3] == ':') {
				one.type = words[i + 4];
				i += 2;
			}
			i += 2;
			return i;
		}
		
		public static function addInclude(fileName:String, txt:String):void {
			if (!txt || txt.length === 0)
				throw new Error("add shader include file err:" + fileName);
			if (includes[fileName])
				throw new Error("add shader include file err, has add:" + fileName);
			includes[fileName] = new InlcudeFile(txt);
		}
		
		public static function preGetParams(vs:String, ps:String):Object {
			var text:Array = [vs, ps];
			var result:Object = {};
			var attributes:Array = [];
			var uniforms:Array = [];
			var definesInfo:Object = {};
			var definesName:Array = [];
			
			result.attributes = attributes;
			result.uniforms = uniforms;
			result.defines = definesInfo;
			
			var i:int, n:int, one:*;
			for (var s:int = 0; s < 2; s++) {
				text[s] = text[s].replace(_removeAnnotation, "");
				
				var words:Array = text[s].match(_reg);
				var tempelse:String;
				for (i = 0, n = words.length; i < n; i++) {
					var word:String = words[i];
					if (word != "attribute" && word != "uniform") {
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
											i = _parseOne(attributes, uniforms, words, i, word, !definesName[tempelse]);
										}
									}
									continue;
								}
								i = _parseOne(attributes, uniforms, words, i, word, definesName[tempelse]);
							}
						}
						continue;
					}
					i = _parseOne(attributes, uniforms, words, i, word, true);
				}
			}
			return result;
		}
		
		public static function splitToWords(str:String, block:ShaderNode):Array//这里要修改
		{
			var out:Array = [];
			/*
			var words:Array = str.split(_splitToWordExps);
			trace(str);
			trace(words);
			*/
			var c:String;
			var ofs:int = -1;
			var word:String;
			for (var i:int = 0, n:int = str.length; i < n; i++) {
				c = str.charAt(i);
				if (" \t=+-*/&%!<>()'\",;".indexOf(c) >= 0) {
					if (ofs >= 0 && (i - ofs) > 1) {
						word = str.substr(ofs, i - ofs);
						out.push(word);
					}
					if (c == '"' || c == "'") {
						var ofs2:int = str.indexOf(c, i + 1);
						if (ofs2 < 0) {
							throw "Sharder err:" + str;
						}
						out.push(str.substr(i + 1, ofs2 - i - 1));
						i = ofs2;
						ofs = -1;
						continue;
					}
					if (c == '(' && block && out.length > 0) {
						word = out[out.length - 1] + ";";
						if ("vec4;main;".indexOf(word) < 0)
							block.useFuns += word;
					}
					ofs = -1;
					continue;
				}
				if (ofs < 0) ofs = i;
			}
			if (ofs < n && (n - ofs) > 1) {
				word = str.substr(ofs, n - ofs);
				out.push(word);
			}
			return out;
		}
		
		public function ShaderCompile(name:Number, vs:String, ps:String, nameMap:*,defs:Object=null) {
			function _compile(script:String):ShaderNode {
				var includefiles:Array = [];
				var top:ShaderNode = new ShaderNode(includefiles);
				_compileToTree(top, script.split('\n'), 0, includefiles,defs);
				return top;
			}			
			
			//先要去掉注释,还没有完成
			var startTime:Number = Browser.now();
			_VS = _compile(vs);
			_PS = _compile(ps);
			_nameMap = nameMap;
			if ((Browser.now() - startTime) > 2)
				trace("ShaderCompile use time:" + (Browser.now() - startTime) + "  size:" + vs.length + "/" + ps.length);
		}
		
		private static var _splitToWordExps3:RegExp =new RegExp("[ \\t=\\+\\-*/&%!<>!%\(\),;\\|]", "g");
		private function _compileToTree(parent:ShaderNode, lines:Array, start:int, includefiles:Array,defs:Object):void {
			var node:ShaderNode, preNode:ShaderNode;
			var text:String, name:String, fname:String;
			var ofs:int, words:Array, noUseNode:ShaderNode;
			var i:int, n:int, j:int;
			for (i = start; i < lines.length; i++) {
				text = lines[i];
				if (text.length < 1) continue;
				ofs = text.indexOf("//");
				if (ofs === 0) continue;
				if (ofs >= 0) text = text.substr(0, ofs);
				
				node = noUseNode || new ShaderNode(includefiles);
				noUseNode = null;
				node.text = text;
				node.noCompile = true;
				
				if ((ofs = text.indexOf("#")) >= 0) {
					name = "#";
					for (j = ofs + 1, n = text.length; j < n; j++) {
						var c:String = text.charAt(j);
						if (c === ' ' || c === '\t' || c === '?') break;
						name += c;
					}
					node.name = name;
					switch (name) {
					case "#ifdef":
					case "#ifndef":
						node.src = text;
						node.noCompile = text.match(/[!&|()=<>]/) != null;
						if (!node.noCompile) {							
							words = text.replace(/^\s*/,'').split(/\s+/);
							node.setCondition(words[1], name === "#ifdef" ? IFDEF_YES : IFDEF_ELSE);
							node.text = "//"+node.text;
						} else {
							trace("function():Boolean{return " + text.substr(ofs + node.name.length) + "}");
						}
						node.setParent(parent);
						parent = node;
						if (defs){
							words = text.substr(j).split(_splitToWordExps3);
							for (j = 0; j < words.length; j++){
								text = words[j];
								text.length && (defs[ text ] = true);
							}
						}
						continue;
					case "#if": 
						node.src = text;
						node.noCompile = true;
						node.setParent(parent);
						parent = node;
						if (defs){
							words = text.substr(j).split(_splitToWordExps3);
							for (j = 0; j < words.length; j++){
								text = words[j];
								text.length && text!="defined" && (defs[ text ] = true);
							}
						}
						continue;
					case "#else": 
						node.src = text;
						parent = parent.parent;
						preNode = parent.childs[parent.childs.length - 1];
						node.noCompile = preNode.noCompile
						if (!(node.noCompile)) {
							node.condition = preNode.condition;
							node.conditionType = preNode.conditionType == IFDEF_YES ? IFDEF_ELSE : IFDEF_YES;
							node.text = "//"+node.text+" "+preNode.text+" "+node.conditionType;
						}
						node.setParent(parent);
						parent = node;
						continue;
					case "#endif":
						parent = parent.parent;
						preNode = parent.childs[parent.childs.length - 1];
						node.noCompile = preNode.noCompile;
						if (!(node.noCompile)) {
							node.text = "//"+node.text;
						}
						node.setParent(parent);
						continue;
					case "#include"://这里有问题,主要是空格
						words = splitToWords(text, null);
						var inlcudeFile:InlcudeFile = includes[words[1]];
						if (!inlcudeFile) {
							throw "ShaderCompile error no this include file:" + words[1];
							return;
						}
						if ((ofs = words[0].indexOf("?")) < 0) {
							node.setParent(parent);
							text = inlcudeFile.getWith(words[2] == 'with' ? words[3] : null);
							_compileToTree(node, text.split('\n'), 0, includefiles,defs);
							node.text = "";
							continue;
						}
						node.setCondition(words[0].substr(ofs + 1), IFDEF_YES);
						node.text = inlcudeFile.getWith(words[2] == 'with' ? words[3] : null);
						break;
					case "#import":
						words = splitToWords(text, null);
						fname = words[1];
						includefiles.push({node: node, file: includes[fname], ofs: node.text.length});
						continue;
					}
				} else {
					preNode = parent.childs[parent.childs.length - 1];
					if (preNode && !preNode.name) {
						includefiles.length > 0 && splitToWords(text, preNode);
						noUseNode = node;
						preNode.text += "\n" + text;
						continue;
					}
					includefiles.length > 0 && splitToWords(text, node);
				}
				node.setParent(parent);
			}
		}
		
		public function createShader(define:*, shaderName:*, createShader:Function):Shader {
			var defMap:* = {};
			var defineStr:String = "";
			if (define) {
				for (var i:String in define) {
					defineStr += "#define " + i + "\n";
					defMap[i] = true;
				}
			}
			var vs:Array = _VS.toscript(defMap, []);
			var ps:Array = _PS.toscript(defMap, []);
			return (createShader as Function || Shader.create as Function)(defineStr + vs.join('\n'), defineStr + ps.join('\n'), shaderName, _nameMap);
		}
	
	}
}
import laya.webgl.utils.ShaderCompile;

class ShaderNode {
	private static var __id:int = 1;
	
	public var childs:Array = [];
	public var text:String = "";
	public var parent:ShaderNode;
	public var name:String;
	public var noCompile:Boolean;
	public var includefiles:Array;
	public var condition:*;
	public var conditionType:int;
	public var useFuns:String = "";
	public var z:int = 0;
	public var src:String;
	
	public function ShaderNode(includefiles:Array) {
		this.includefiles = includefiles;
	}
	
	public function setParent(parent:ShaderNode):void {
		parent.childs.push(this);
		this.z = parent.z + 1;
		this.parent = parent;
	}
	
	public function setCondition(condition:String, type:int):void {
		if (condition) {
			conditionType = type;
			condition = condition.replace(/(\s*$)/g, "");
			this.condition = function():Boolean {
				return this[condition];
			}
			this.condition.__condition = condition;
		}
	}
	
	public function toscript(def:*, out:Array):Array {
		return _toscript(def, out, ++__id);
	}
	
	private function _toscript(def:*, out:Array, id:int):Array {
		if (this.childs.length < 1 && !text) return out;
		var outIndex:int = out.length;
		if (condition) {
			var ifdef:Boolean = !!condition.call(def);
			conditionType === ShaderCompile.IFDEF_ELSE && (ifdef = !ifdef);
			if (!ifdef) return out;
		}
		
		text && out.push(text);
		this.childs.length > 0 && this.childs.forEach(function(o:ShaderNode, index:int, arr:Vector.<ShaderNode>):void {
			o._toscript(def, out, id);
		});
		
		if (includefiles.length > 0 && useFuns.length > 0) {
			var funsCode:String;
			for (var i:int = 0, n:int = includefiles.length; i < n; i++) {
				//如果已经加入了，就不要再加
				if (includefiles[i].curUseID == id) {
					continue;
				}
				funsCode = includefiles[i].file.getFunsScript(useFuns);
				if (funsCode.length > 0) {
					includefiles[i].curUseID = id;
					out[0] = funsCode + out[0];
				}
			}
		}
		
		return out;
	}
}

class InlcudeFile {
	public var script:String;
	public var codes:* = {};
	public var funs:* = {};
	public var curUseID:int = -1;
	public var funnames:String = "";
	
	public function InlcudeFile(txt:String) {
		script = txt;
		var begin:int = 0, ofs:int, end:int;
		while (true) {
			begin = txt.indexOf("#begin", begin);
			if (begin < 0) break;
			
			end = begin + 5;
			while (true) {
				end = txt.indexOf("#end", end);
				if (end < 0) break;
				if (txt.charAt(end + 4) === 'i')
					end += 5;
				else break;
			}
			
			if (end < 0) {
				throw "add include err,no #end:" + txt;
				return;
			}
			
			ofs = txt.indexOf('\n', begin);
			
			var words:Array = ShaderCompile.splitToWords(txt.substr(begin, ofs - begin), null);
			if (words[1] == 'code') {
				codes[words[2]] = txt.substr(ofs + 1, end - ofs - 1);
			} else if (words[1] == 'function')//#begin function void test()
			{
				ofs = txt.indexOf("function", begin);
				ofs += "function".length;
				funs[words[3]] = txt.substr(ofs + 1, end - ofs - 1);
				funnames += words[3] + ";";
			}
			
			begin = end + 1;
		}
	}
	
	public function getWith(name:String = null):String {
		var r:String = name ? codes[name] : script;
		if (!r) {
			throw "get with error:" + name;
		}
		return r;
	}
	
	public function getFunsScript(funsdef:String):String {
		var r:String = "";
		for (var i:String in funs) {
			if (funsdef.indexOf(i + ";") >= 0) {
				r += funs[i];
			}
		}
		return r;
	}

}

