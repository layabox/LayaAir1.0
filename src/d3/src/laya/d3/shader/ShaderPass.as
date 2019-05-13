package laya.d3.shader {
	import laya.d3.core.material.RenderState;
	import laya.webgl.WebGL;
	import laya.webgl.utils.InlcudeFile;
	import laya.webgl.utils.ShaderCompile;
	import laya.webgl.utils.ShaderNode;
	
	/**
	 * <code>ShaderPass</code> 类用于实现ShaderPass。
	 */
	public class ShaderPass extends ShaderCompile {
		/**@private */
		private var _owner:SubShader;
		/**@private */
		public var _stateMap:Object;
		/**@private */
		private var _cacheSharders:Array;
		/**@private */
		private var _publicValidDefine:int;
		/**@private */
		private var _spriteValidDefine:int;
		/**@private */
		private var _materialValidDefine:int;
		/**@private */
		private var _validDefineMap:Object;
		/**@private */
		private var _renderState:RenderState = new RenderState();
		
		/**
		 * 获取渲染状态。
		 * @return 渲染状态。
		 */
		public function get renderState():RenderState {
			return _renderState;
		}
		
		public function ShaderPass(owner:SubShader, vs:String, ps:String,stateMap:Object) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_owner = owner;
			_cacheSharders = [];
			_publicValidDefine = 0;
			_spriteValidDefine = 0;
			_materialValidDefine = 0;
			_validDefineMap = {};
			super(vs, ps, null, _validDefineMap);
			var publicDefineMap:Object = _owner._publicDefinesMap;
			var spriteDefineMap:Object = _owner._spriteDefinesMap;
			var materialDefineMap:Object = _owner._materialDefinesMap;
			for (var k:String in _validDefineMap) {
				if (publicDefineMap[k] != null)
					_publicValidDefine |= publicDefineMap[k];
				else if (spriteDefineMap[k] != null)
					_spriteValidDefine |= spriteDefineMap[k];
				else if (materialDefineMap[k] != null)
					_materialValidDefine |= materialDefineMap[k];
			}
			_stateMap = stateMap;
		}
		
		/**
		 * @private
		 */
		private function _definesToNameDic(value:int, int2Name:Array):Object {
			var o:Object = {};
			var d:int = 1;
			for (var i:int = 0; i < 32; i++) {
				d = 1 << i;
				if (d > value) break;
				if (value & d) {
					var name:String = int2Name[d];
					o[name] = "";
				}
			}
			return o;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _compileToTree(parent:ShaderNode, lines:Array, start:int, includefiles:Array, defs:Object):void {
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
						node.setParent(parent);
						parent = node;
						if (defs) {
							words = text.substr(j).split(ShaderCompile._splitToWordExps3);
							for (j = 0; j < words.length; j++) {
								text = words[j];
								text.length && (defs[text] = true);
							}
						}
						continue;
					case "#if": 
					case "#elif": 
						node.setParent(parent);
						parent = node;
						if (defs) {
							words = text.substr(j).split(ShaderCompile._splitToWordExps3);
							for (j = 0; j < words.length; j++) {
								text = words[j];
								text.length && text != "defined" && (defs[text] = true);
							}
						}
						continue;
					case "#else": 
						parent = parent.parent;
						preNode = parent.childs[parent.childs.length - 1];
						node.setParent(parent);
						parent = node;
						continue;
					case "#endif": 
						parent = parent.parent;
						preNode = parent.childs[parent.childs.length - 1];
						node.setParent(parent);
						continue;
					case "#include"://这里有问题,主要是空格
						words = splitToWords(text, null);
						var inlcudeFile:InlcudeFile = includes[words[1]];
						if (!inlcudeFile) {
							throw "ShaderCompile error no this include file:" + words[1];
						}
						if ((ofs = words[0].indexOf("?")) < 0) {
							node.setParent(parent);
							text = inlcudeFile.getWith(words[2] == 'with' ? words[3] : null);
							_compileToTree(node, text.split('\n'), 0, includefiles, defs);
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
		
		/**
		 * @private
		 */
		public function withCompile(publicDefine:int, spriteDefine:int, materialDefine:int):ShaderInstance {
			publicDefine &= _publicValidDefine;
			spriteDefine &= _spriteValidDefine;
			materialDefine &= _materialValidDefine;
			var shader:ShaderInstance;
			var spriteDefShaders:Array, materialDefShaders:Array;
			
			spriteDefShaders = _cacheSharders[publicDefine];
			if (spriteDefShaders) {
				materialDefShaders = spriteDefShaders[spriteDefine];
				if (materialDefShaders) {
					shader = materialDefShaders[materialDefine];
					if (shader)
						return shader;
				} else {
					materialDefShaders = spriteDefShaders[spriteDefine] = [];
				}
			} else {
				spriteDefShaders = _cacheSharders[publicDefine] = [];
				materialDefShaders = spriteDefShaders[spriteDefine] = [];
			}
			
			var publicDefGroup:Object = _definesToNameDic(publicDefine, _owner._publicDefines);
			var spriteDefGroup:Object = _definesToNameDic(spriteDefine, _owner._spriteDefines);
			var materialDefGroup:Object = _definesToNameDic(materialDefine, _owner._materialDefines);
			var key:String;
			if (Shader3D.debugMode) {
				var publicDefGroupStr:String = "";
				for (key in publicDefGroup)
					publicDefGroupStr += key + " ";
				
				var spriteDefGroupStr:String = "";
				for (key in spriteDefGroup)
					spriteDefGroupStr += key + " ";
				
				var materialDefGroupStr:String = "";
				for (key in materialDefGroup)
					materialDefGroupStr += key + " ";
				
				if (!WebGL.shaderHighPrecision)
					publicDefine += Shader3D.SHADERDEFINE_HIGHPRECISION;//输出宏定义要保持设备无关性
				
				console.log("%cShader3DDebugMode---(Name:" + _owner._owner._name + " PassIndex:" + _owner._passes.indexOf(this) + " PublicDefine:" + publicDefine + " SpriteDefine:" + spriteDefine + " MaterialDefine:" + materialDefine + " PublicDefineGroup:" + publicDefGroupStr + " SpriteDefineGroup:" + spriteDefGroupStr + "MaterialDefineGroup: " + materialDefGroupStr + ")---ShaderCompile3DDebugMode", "color:green");
			}
			
			var defMap:* = {};
			var defineStr:String = "";
			if (publicDefGroup) {
				for (key in publicDefGroup) {
					defineStr += "#define " + key + "\n";
					defMap[key] = true;
				}
			}
			
			if (spriteDefGroup) {
				for (key in spriteDefGroup) {
					defineStr += "#define " + key + "\n";
					defMap[key] = true;
				}
			}
			
			if (materialDefGroup) {
				for (key in materialDefGroup) {
					defineStr += "#define " + key + "\n";
					defMap[key] = true;
				}
			}
			
			var vs:Array = _VS.toscript(defMap, []);
			var vsVersion:String = '';
			if (vs[0].indexOf('#version') == 0) {
				vsVersion = vs[0] + '\n';
				vs.shift();
			}
			
			var ps:Array = _PS.toscript(defMap, []);
			var psVersion:String = '';
			if (ps[0].indexOf('#version') == 0) {
				psVersion = ps[0] + '\n';
				ps.shift();
			}
			shader = new ShaderInstance(vsVersion + defineStr + vs.join('\n'), psVersion + defineStr + ps.join('\n'), _owner._attributeMap, _owner._uniformMap,this);
			
			materialDefShaders[materialDefine] = shader;
			return shader;
		}
	
	}

}