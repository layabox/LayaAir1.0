package laya.d3.shader {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.renders.Render;
	
	public class ShaderCompile3D {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**是否开启调试模式。 */
		public static var debugMode:Boolean = false;
		
		public static var SHADERDEFINE_FSHIGHPRECISION:int = 0x1;
		public static var SHADERDEFINE_VR:int = 0x2;
		public static var SHADERDEFINE_FOG:int = 0x4;
		public static var SHADERDEFINE_DIRECTIONLIGHT:int = 0x8;
		public static var SHADERDEFINE_POINTLIGHT:int = 0x10;
		public static var SHADERDEFINE_SPOTLIGHT:int = 0x20;
		public static var SHADERDEFINE_UV0:int = 0x40;
		public static var SHADERDEFINE_COLOR:int = 0x80;
		public static var SHADERDEFINE_UV1:int = 0x100;
		public static var SAHDERDEFINE_DEPTHFOG:int = 0x20000;
		
		private static var DEFINEREG:RegExp = new RegExp("defined(?=\\((.*?)\\))", "g");
		private static var INCLUDE:RegExp = new RegExp("\\w+", "g");
		private static var _globalInt2name:Array = [];
		public static var _preCompileShader:Object = {}; //存储预编译结果，可以通过名字获得内容,目前不支持#ifdef嵌套和条件
		public static const IFDEF_NO:int = 0;
		public static const IFDEF_YES:int = 1;
		public static const IFDEF_ELSE:int = 2;
		
		/**
		 * @private
		 */
		public static function __init__():void {
			_globalRegDefine("FSHIGHPRECISION", SHADERDEFINE_FSHIGHPRECISION);
			_globalRegDefine("VR", SHADERDEFINE_VR);
			_globalRegDefine("FOG", SHADERDEFINE_FOG);
			_globalRegDefine("DIRECTIONLIGHT", SHADERDEFINE_DIRECTIONLIGHT);
			_globalRegDefine("POINTLIGHT", SHADERDEFINE_POINTLIGHT);
			_globalRegDefine("SPOTLIGHT", SHADERDEFINE_SPOTLIGHT);
			_globalRegDefine("UV", SHADERDEFINE_UV0);
			_globalRegDefine("COLOR", SHADERDEFINE_COLOR);
			_globalRegDefine("UV1", SHADERDEFINE_UV1);
			//TODO:
			_globalRegDefine("CASTSHADOW", ParallelSplitShadowMap.SHADERDEFINE_CAST_SHADOW);
			_globalRegDefine("SHADOWMAP_PSSM1", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PSSM1);
			_globalRegDefine("SHADOWMAP_PSSM2", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PSSM2);
			_globalRegDefine("SHADOWMAP_PSSM3", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PSSM3);
			_globalRegDefine("SHADOWMAP_PCF_NO", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PCF_NO);
			_globalRegDefine("SHADOWMAP_PCF1", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PCF1);
			_globalRegDefine("SHADOWMAP_PCF2", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PCF2);
			_globalRegDefine("SHADOWMAP_PCF3", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PCF3);
			
			_globalRegDefine("DEPTHFOG", SAHDERDEFINE_DEPTHFOG);
		}
		
		/**
		 * @private
		 */
		private static function _globalRegDefine(name:String, value:int):void {
			_globalInt2name[value] = name;
		}
		
		/**
		 * 添加预编译shader文件，主要是处理宏定义
		 * @param	nameID,一般是特殊宏+shaderNameID*0.0002组成的一个浮点数当做唯一标识
		 * @param	vs
		 * @param	ps
		 */
		public static function add(nameID:int, vs:String, ps:String, attributeMap:Object, uniformMap:Object):ShaderCompile3D {
			return ShaderCompile3D._preCompileShader[nameID] = new ShaderCompile3D(nameID, vs, ps, attributeMap, uniformMap, Shader3D._includeFiles);
		}
		
		/**
		 * 获取ShaderCompile3D。
		 * @param	name
		 * @return ShaderCompile3D。
		 */
		public static function get(name:String):ShaderCompile3D {
			return ShaderCompile3D._preCompileShader[Shader3D.nameKey.getID(name)];
		}
		
		private var _name:Number;
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
		public var sharders:Array;
		
		private var _curMaterialDefinePower:int = 1;
		private var _curSpriteDefinePower:int = 3;
		public var _materialInt2name:Array = [];
		public var _spriteInt2name:Array = [];
		
		public var _conchShader:*;//NATIVE		
		
		public function ShaderCompile3D(name:Number, vs:String, ps:String, attributeMap:Object, uniformMap:Object, includeFiles:*) {
			_name = name;
			_renderElementUniformMap = {};
			_materialUniformMap = {};
			_spriteUniformMap = {};
			_cameraUniformMap = {};
			_sceneUniformMap = {};
			sharders = [];
			//先要去掉注释,还没有完成			
			_VSTXT = vs;
			_PSTXT = ps;
			
			_spriteInt2name[ParallelSplitShadowMap.SHADERDEFINE_RECEIVE_SHADOW] = "RECEIVESHADOW";
			_spriteInt2name[RenderableSprite3D.SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV] = "SCALEOFFSETLIGHTINGMAPUV";
			_spriteInt2name[RenderableSprite3D.SAHDERDEFINE_LIGHTMAP] = "LIGHTMAP";
			_spriteInt2name[SkinAnimations.SHADERDEFINE_BONE] = "BONE";
			
			_materialInt2name[BaseMaterial.SHADERDEFINE_ALPHATEST] = "ALPHATEST";
			
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
						var str:String = ofs > 0 ? words[0].substr(ofs + 1) : null;
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
		
		/**
		 * 根据宏动态生成shader文件，支持#include?COLOR_FILTER "parts/ColorFilter_ps_logic.glsl";条件嵌入文件
		 * @param	name
		 * @param	vs
		 * @param	ps
		 * @param	define 宏定义，格式:{name:value...}
		 * @return
		 */
		public function withCompile(nameID:int, publicDefine:int, spriteDefine:int, materialDefine:int):Shader3D {
			var shader:Shader3D;
			var publicDefShaders:Array = sharders[nameID],spriteDefShaders:Array,materialDefShaders:Array;
			if (publicDefShaders) {
				spriteDefShaders = publicDefShaders[publicDefine];
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
					spriteDefShaders = publicDefShaders[publicDefine] = [];
					materialDefShaders = spriteDefShaders[spriteDefine] = [];
				}
			} else {
				publicDefShaders = sharders[nameID] = [];
				spriteDefShaders = publicDefShaders[publicDefine] = [];
				materialDefShaders = spriteDefShaders[spriteDefine] = [];
			}
			
			var publicDefGroup:Object = definesToNameDic(publicDefine, _globalInt2name);
			var spriteDefGroup:Object = definesToNameDic(spriteDefine, _spriteInt2name);
			var materialDefGroup:Object = definesToNameDic(materialDefine, _materialInt2name);
			if (ShaderCompile3D.debugMode) {
				var publicDefGroupStr:String = "", key:String;
				for (key in publicDefGroup)
					publicDefGroupStr += key + " ";
				
				var spriteDefGroupStr:String = "";
				for (key in spriteDefGroup)
					spriteDefGroupStr += key + " ";
				
				var materialDefGroupStr:String = "";
				for (key in materialDefGroup)
					materialDefGroupStr += key + " ";
				
				trace("ShaderCompile3DDebugMode---(Name:" + Shader3D.nameKey.getName(nameID) + " PublicDefine:" + publicDefine + " SpriteDefine:" + spriteDefine + " MaterialDefine:" + materialDefine + " PublicDefineGroup:" + publicDefGroupStr + " SpriteDefineGroup:" + spriteDefGroupStr + "MaterialDefineGroup: " + materialDefGroupStr + ")---ShaderCompile3DDebugMode");
			}
			
			shader = createShader(publicDefGroup, spriteDefGroup, materialDefGroup);
			materialDefShaders[materialDefine] = shader;
			return shader;
		}
		
		public function createShader(publicDefine:Object, spriteDefine:Object, materialDefine:Object):Shader3D {
			var defMap:* = {};
			var defineStr:String = "", key:String;
			if (publicDefine) {
				for (key in publicDefine) {
					defineStr += "#define " + key + "\n";
					defMap[key] = true;
				}
			}
			
			if (spriteDefine) {
				for (key in spriteDefine) {
					defineStr += "#define " + key + "\n";
					defMap[key] = true;
				}
			}
			
			if (materialDefine) {
				for (key in materialDefine) {
					defineStr += "#define " + key + "\n";
					defMap[key] = true;
				}
			}
			
			var vs:Array = _VS.toscript(defMap, []);
			var ps:Array = _PS.toscript(defMap, []);
			
			return Shader3D.create(defineStr + vs.join('\n'), defineStr + ps.join('\n'), _attributeMap, _sceneUniformMap, _cameraUniformMap, _spriteUniformMap, _materialUniformMap, _renderElementUniformMap);
		}
		
		/**
		 * 通过宏定义预编译shader。
		 * @param	spriteIntToNameDic 精灵宏定义数组。
		 * @param	publicDefine 公共宏定义值。
		 * @param	spriteDefine 精灵宏定义值。
		 * @param	materialDefine 材质宏定义值。
		 */
		public function precompileShaderWithShaderDefine(publicDefine:int, spriteDefine:int, materialDefine:int):void {
			withCompile(_name, publicDefine, spriteDefine, materialDefine);
		}
		
		/**
		 * 注册材质宏定义。
		 * @param	name 宏定义名称。
		 * @return
		 */
		public function registerMaterialDefine(name:String):int {
			var value:int = Math.pow(2, _curMaterialDefinePower++);//TODO:超界处理	
			_materialInt2name[value] = name;
			
			if (Render.isConchNode) {//NATIVE
				__JS__("conch.regShaderDefine&&conch.regShaderDefine(name,value);")
			}
			return value;
		}
		
		/**
		 * 注册精灵宏定义。
		 * @param	name 宏定义名称。
		 * @return
		 */
		public function registerSpriteDefine(name:String):int {
			var value:int = Math.pow(2, _curSpriteDefinePower++);//TODO:超界处理	
			_spriteInt2name[value] = name;
			
			if (Render.isConchNode) {//NATIVE
				__JS__("conch.regShaderDefine&&conch.regShaderDefine(name,value);")
			}
			return value;
		}
		
		public function definesToNameDic(value:int, int2Name:Array):Object {
			var o:Object = {};
			var d:int = 1;
			for (var i:int = 0; i < 32; i++) {
				d = 1 << i;
				if (d > value) break;
				if (value & d) {
					var name:String = int2Name[d];
					name && (o[name] = "");
				}
			}
			return o;
		}
	
	}

}
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
		
		if (!condition) {
			if (this.type == ShaderCompile.IFDEF_YES) {
				this.type = ShaderCompile.IFDEF_NO;
			}
			return;
		}
		
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