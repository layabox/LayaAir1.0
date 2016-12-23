package laya.d3.shader {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.scene.BaseScene;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.webgl.shader.Shader;
	
	public class ShaderCompile3D {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const IFDEF_NO:int = 0;
		public static const IFDEF_YES:int = 1;
		public static const IFDEF_ELSE:int = 2;
		private static var DEFINEREG:RegExp = new RegExp("defined(?=\\((.*?)\\))", "g");
		private static var INCLUDE:RegExp = new RegExp("\\w+", "g");
		
		private var _VS:ShaderScriptBlock;
		private var _PS:ShaderScriptBlock;
		private var _VSTXT:String;
		private var _PSTXT:String;
		private var _attributeMap:Object;
		private var _renderElementUniformMap:Object;
		private var _materialUniformMap:Object;
		private var _spriteUniformMap:Object;
		private var _cameraUniformMap:Object;
		private var _sceneUniformMap:Object;
		
		public var _conchShader:*;//NATIVE		
		
		public function ShaderCompile3D(name:Number, vs:String, ps:String, attributeMap:Object, uniformMap:Object, includeFiles:*) {
			_renderElementUniformMap = {};
			_materialUniformMap = {};
			_spriteUniformMap = {};
			_cameraUniformMap = {};
			_sceneUniformMap = {};
			
			//先要去掉注释,还没有完成			
			_VSTXT = vs;
			_PSTXT = ps;
			function split(str:String):Array//这里要修改
			{
				//replace(/(^\s*)|(\s*$)/g,"").split(/\s+/)
				var words:Array = str.split(' ');
				var out:Array = [];
				for (var i:int = 0; i < words.length; i++)
					words[i].length > 0 && out.push(words[i]);
				return out;
			}
			
			function c(script:String):ShaderScriptBlock {
				var before:String = script;
				script = script.replace(DEFINEREG, "");
				var i:int, n:int, ofs:int, words:Array, condition:Function;
				
				var top:ShaderScriptBlock = new ShaderScriptBlock(IFDEF_NO, null, null, null);
				var parent:ShaderScriptBlock = top;
				
				var lines:Array = script.split('\n');
				for (i = 0, n = lines.length; i < n; i++) {
					var line:String = lines[i];
					if (line.indexOf("#ifdef") >= 0)//这里有问题,主要是空格
					{
						words = split(line);
						parent = new ShaderScriptBlock(IFDEF_YES, words[1], "", parent);
						continue;
					}
					if (line.indexOf("#if") >= 0)//这里有问题,主要是空格
					{
						words = split(line);
						parent = new ShaderScriptBlock(IFDEF_YES, words[1], "", parent);
						continue;
					}
					if (line.indexOf("#else") >= 0) {
						condition = parent.condition;
						parent = new ShaderScriptBlock(IFDEF_ELSE, null, "", parent.parent);
						parent.condition = condition;
						continue;
					}
					if (line.indexOf("#endif") >= 0) {
						parent = parent.parent;
						continue;
					}
					
					if (line.indexOf("#include") >= 0)//这里有问题,主要是空格
					{
						words = split(line);
						var fname:String = words[1];
						var chr:String = fname.charAt(0);
						if (chr === '"' || chr === "'") {
							fname = fname.substr(1, fname.length - 2);
							ofs = fname.lastIndexOf(chr);
							if (ofs > 0) fname = fname.substr(0, ofs);
						}
						ofs = words[0].indexOf('?');
						var str:String = ofs > 0 ? words[0].substr(ofs + 1) : words[0];
						new ShaderScriptBlock(IFDEF_YES, str, includeFiles[fname], parent);
						if (Render.isConchNode)//NATIVE
						{
							
							var tmp:Array = str.match(INCLUDE);
							var sz:int = tmp.length;
							if (sz == 1) {
								str = str.replace(tmp[0], "defined(" + tmp[0] + ")");
							} else if (sz > 1) {
								var tobj:Object = {};
								for (var j:int = 0; j < sz; j++) {
									var _name:String = tmp[j];
									if (!tobj[_name]) {
										str = str.replace(_name, "defined(" + _name + ")");
										tobj[_name] = true;
									}
								}
							}
							
							var result:String = "#if " + str;
							
							result += ("\n" + includeFiles[fname] + "\n");
							result += "#endif";
							before = before.replace(line, result);
						}
						continue;
					}
					if (parent.childs.length > 0 && parent.childs[parent.childs.length - 1].type === IFDEF_NO) {
						parent.childs[parent.childs.length - 1].text += "\n" + line;
					} else new ShaderScriptBlock(IFDEF_NO, null, line, parent);
				}
				Render.isConchNode && (top["sd"] = before);//NATIVE
				return top;
			}
			_VS = c(vs);
			_PS = c(ps);
			_attributeMap = attributeMap;
			var renderElementUnifCount:int = 0, materialUnifCount:int = 0, spriteUnifCount:int = 0;
			var key:String;
			for (key in uniformMap) {
				var uniformParam:Array = uniformMap[key];
				switch (uniformParam[1]) {
				case Shader3D.PERIOD_RENDERELEMENT: 
					_renderElementUniformMap[key] = uniformParam[0];
					break;
				case Shader3D.PERIOD_MATERIAL: 
					_materialUniformMap[key] = uniformParam[0];
					break;
				case Shader3D.PERIOD_SPRITE: 
					_spriteUniformMap[key] = uniformParam[0];
					break;
				case Shader3D.PERIOD_CAMERA: 
					_cameraUniformMap[key] = uniformParam[0];
					break;
				case Shader3D.PERIOD_SCENE: 
					_sceneUniformMap[key] = uniformParam[0];
					break;
				default: 
					throw new Error("ShaderCompile3D: period is unkonw.");
					
				}
			}
			
			if (Render.isConchNode) {//NATIVE
				_conchShader = __JS__("new ConchShader()");
				_conchShader.setSrc(_VS["sd"], _PS["sd"]);
				delete _VS["sd"];
				delete _PS["sd"];
				
				var conchAttrElements:Array = [];
				for (key in _attributeMap) {
					conchAttrElements.push({name: key, elementUsage: _attributeMap[key]});
				}
				_conchShader.setAttrDeclare(conchAttrElements);
				
				var conchUniformElements:Array = [];
				for (key in uniformMap) {
					var tempArray:Array = uniformMap[key];
					conchUniformElements.push({name: key, elementUsage: tempArray[0], periodType: tempArray[1]});
				}
				_conchShader.setUniformDeclare(conchUniformElements);
			}
		}
		
		public function createShader(define:*, shaderName:*):Shader3D {
			var defMap:* = {};
			var defineStr:String = "";
			if (define) {
				for (var i:String in define) {
					defineStr += "#define " + i + "\n";
					defMap[i] = true;
				}
			}
			
			//trace("createShader:" + defineStr);
			var vs:Array = _VS.toscript(defMap, []);
			var ps:Array = _PS.toscript(defMap, []);
			return Shader3D.create(defineStr + vs.join('\n'), defineStr + ps.join('\n'), shaderName, _attributeMap, _sceneUniformMap, _cameraUniformMap, _spriteUniformMap, _materialUniformMap, _renderElementUniformMap);
		}
	}

}
import laya.utils.Browser;
import laya.utils.RunDriver;
import laya.webgl.utils.ShaderCompile;

class ShaderScriptBlock {
	/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
	public var type:int;
	public var condition:Function;
	public var text:String;
	public var childs:Vector.<ShaderScriptBlock> = new Vector.<ShaderScriptBlock>;
	public var parent:ShaderScriptBlock;
	
	public function ShaderScriptBlock(type:int, condition:String, text:String, parent:ShaderScriptBlock) {
		this.type = type;
		this.text = text;
		this.parent = parent;
		parent && parent.childs.push(this);
		
		if (!condition) return;
		
		/*[IF-FLASH]*/
		this.condition = RunDriver.createShaderCondition(condition);
		/*[IF-FLASH]*/
		return;
		
		//把条件的变量名加上this.
		var newcondition:String = "";
		var preIsParam:Boolean = false, isParam:Boolean;
		for (var i:int = 0, n:int = condition.length; i < n; i++) {
			var c:String = condition.charAt(i);
			isParam = "!&|() \t".indexOf(c) < 0;//不是运算符
			if (preIsParam != isParam) {
				isParam && (newcondition += "this.");
				preIsParam = isParam;
			}
			newcondition += c;
		}
		this.condition = RunDriver.createShaderCondition(newcondition);
	}
	
	public function toscript(def:*, out:Array):Array {
		if (type === ShaderCompile.IFDEF_NO) {
			text && out.push(text);
		}
		
		if (this.childs.length < 1 && !text) return out;
		
		if (type !== ShaderCompile.IFDEF_NO) {
			var ifdef:Boolean = !!condition.call(def);
			type === ShaderCompile.IFDEF_ELSE && (ifdef = !ifdef);
			if (!ifdef) return out;
			text && out.push(text);
		}
		
		this.childs.length > 0 && this.childs.forEach(function(o:ShaderScriptBlock, index:int, arr:Vector.<ShaderScriptBlock>):void {
			o.toscript(def, out)
		});
		
		return out;
	}
}