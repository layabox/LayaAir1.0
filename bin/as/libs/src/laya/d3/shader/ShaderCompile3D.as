package laya.d3.shader {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.ShaderCompile;
	
	/**
	 * @private
	 * <code>ShaderCompile</code> 类用于创建Shader编译类型。
	 */
	public class ShaderCompile3D extends ShaderCompile {
		/**@private */
		public static var _preCompileShader:Object = {}; //存储预编译结果，可以通过名字获得内容,目前不支持#ifdef嵌套和条件
		/**@private */
		private static var _globalInt2name:Array = [];
		/**是否开启调试模式。 */
		public static var debugMode:Boolean = false;
		
		public static var SHADERDEFINE_HIGHPRECISION:int = 0x1;
		public static var SHADERDEFINE_FOG:int = 0x4;
		public static var SHADERDEFINE_DIRECTIONLIGHT:int = 0x8;
		public static var SHADERDEFINE_POINTLIGHT:int = 0x10;
		public static var SHADERDEFINE_SPOTLIGHT:int = 0x20;
		public static var SHADERDEFINE_UV0:int = 0x40;
		public static var SHADERDEFINE_COLOR:int = 0x80;
		public static var SHADERDEFINE_UV1:int = 0x100;
		public static var SAHDERDEFINE_DEPTHFOG:int = 0x20000;
		
		/**
		 * @private
		 */
		public static function _globalRegDefine(name:String, value:int):void {
			_globalInt2name[value] = name;
		}
		
		/**
		 * 添加预编译shader文件，主要是处理宏定义
		 * @param	nameID,一般是特殊宏+shaderNameID*0.0002组成的一个浮点数当做唯一标识
		 * @param	vs
		 * @param	ps
		 */
		public static function add(nameID:int, vs:String, ps:String, attributeMap:Object, uniformMap:Object):ShaderCompile3D {
			return ShaderCompile3D._preCompileShader[nameID] = new ShaderCompile3D(nameID, vs, ps, attributeMap, uniformMap, ShaderCompile.includes);
		}
		
		/**
		 * 获取ShaderCompile3D。
		 * @param	name
		 * @return ShaderCompile3D。
		 */
		public static function get(name:String):ShaderCompile3D {
			return ShaderCompile3D._preCompileShader[Shader3D.nameKey.getID(name)];
		}
		
		/**@private */
		private var _name:Number;
		/**@private */
		private var _attributeMap:Object;
		/**@private */
		private var _renderElementUniformMap:Object;
		/**@private */
		private var _materialUniformMap:Object;
		/**@private */
		private var _spriteUniformMap:Object;
		/**@private */
		private var _cameraUniformMap:Object;
		/**@private */
		private var _sceneUniformMap:Object;
		public var sharders:Array;
		
		/**@private */
		private var _spriteDefineCounter:int = 3;
		/**@private */
		private var _spriteInt2name:Array = [];
		/**@private */
		private var _spriteName2Int:Object = {};
		/**@private */
		private var _materialDefineCounter:int = 1;
		/**@private */
		public var _materialInt2name:Array = [];
		/**@private */
		public var _materialName2Int:Object = {};
		
		public var _conchShader:*;//NATIVE		
		
		/**
		 * @private
		 */
		public function ShaderCompile3D(name:Number, vs:String, ps:String, attributeMap:Object, uniformMap:Object, includeFiles:*) {
			_name = name;
			_renderElementUniformMap = {};
			_materialUniformMap = {};
			_spriteUniformMap = {};
			_cameraUniformMap = {};
			_sceneUniformMap = {};
			sharders = [];
			
			_spriteInt2name[ParallelSplitShadowMap.SHADERDEFINE_RECEIVE_SHADOW] = "RECEIVESHADOW";
			_spriteInt2name[RenderableSprite3D.SHADERDEFINE_SCALEOFFSETLIGHTINGMAPUV] = "SCALEOFFSETLIGHTINGMAPUV";
			_spriteInt2name[RenderableSprite3D.SAHDERDEFINE_LIGHTMAP] = "LIGHTMAP";
			_spriteInt2name[SkinnedMeshSprite3D.SHADERDEFINE_BONE] = "BONE";
			
			_materialInt2name[BaseMaterial.SHADERDEFINE_ALPHATEST] = "ALPHATEST";
			
			var defineMap:Object = {};
			super(name, vs, ps, null, defineMap);
			
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
					name && (o[name] = "");
				}
			}
			return o;
		}
		
		/**
		 * 根据宏动态生成shader文件，支持#include?COLOR_FILTER "parts/ColorFilter_ps_logic.glsl";条件嵌入文件
		 * @param	name
		 * @param	vs
		 * @param	ps
		 * @param	define 宏定义，格式:{name:value...}
		 * @return
		 */
		public function withCompile(publicDefine:int, spriteDefine:int, materialDefine:int):Shader3D {
			var shader:Shader3D;
			var spriteDefShaders:Array, materialDefShaders:Array;
			
			spriteDefShaders = sharders[publicDefine];
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
				spriteDefShaders = sharders[publicDefine] = [];
				materialDefShaders = spriteDefShaders[spriteDefine] = [];
			}
			
			var publicDefGroup:Object = _definesToNameDic(publicDefine, _globalInt2name);
			var spriteDefGroup:Object = _definesToNameDic(spriteDefine, _spriteInt2name);
			var materialDefGroup:Object = _definesToNameDic(materialDefine, _materialInt2name);
			var key:String;
			if (ShaderCompile3D.debugMode) {
				var publicDefGroupStr:String = "";
				for (key in publicDefGroup)
					publicDefGroupStr += key + " ";
				
				var spriteDefGroupStr:String = "";
				for (key in spriteDefGroup)
					spriteDefGroupStr += key + " ";
				
				var materialDefGroupStr:String = "";
				for (key in materialDefGroup)
					materialDefGroupStr += key + " ";
				
				trace("ShaderCompile3DDebugMode---(Name:" + Shader3D.nameKey.getName(_name) + " PublicDefine:" + publicDefine + " SpriteDefine:" + spriteDefine + " MaterialDefine:" + materialDefine + " PublicDefineGroup:" + publicDefGroupStr + " SpriteDefineGroup:" + spriteDefGroupStr + "MaterialDefineGroup: " + materialDefGroupStr + ")---ShaderCompile3DDebugMode");
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
			var ps:Array = _PS.toscript(defMap, []);
			
			shader = Shader3D.create(defineStr + vs.join('\n'), defineStr + ps.join('\n'), _attributeMap, _sceneUniformMap, _cameraUniformMap, _spriteUniformMap, _materialUniformMap, _renderElementUniformMap);
			
			materialDefShaders[materialDefine] = shader;
			return shader;
		}
		
		/**
		 * 通过宏定义预编译shader。
		 * @param	spriteIntToNameDic 精灵宏定义数组。
		 * @param	publicDefine 公共宏定义值。
		 * @param	spriteDefine 精灵宏定义值。
		 * @param	materialDefine 材质宏定义值。
		 */
		public function precompileShaderWithShaderDefine(publicDefine:int, spriteDefine:int, materialDefine:int):void {
			withCompile(publicDefine, spriteDefine, materialDefine);
		}
		
		/**
		 * 注册材质宏定义。
		 * @param	name 宏定义名称。
		 * @return
		 */
		public function addMaterialDefines(shaderdefines:ShaderDefines):void {
			var defines:Array = shaderdefines.defines;
			for (var k:String in defines) {
				var name:String = defines[k];
				var i:int = parseInt(k);
				_materialInt2name[i] = name;
				_materialName2Int[name] = i;
			}
		}
		
		/**
		 * 注册精灵宏定义。
		 * @param	name 宏定义名称。
		 * @return
		 */
		public function addSpriteDefines(shaderdefines:ShaderDefines):void {
			var defines:Array = shaderdefines.defines;
			for (var k:String in defines) {
				var name:String = defines[k];
				var i:int = parseInt(k);
				_spriteInt2name[i] = name;
				_spriteName2Int[name] = i;
			}
		}
		
		/**
		 * 通过名称获取宏定义值。
		 * @param	name 名称。
		 * @return 宏定义值。
		 */
		public function getMaterialDefineByName(name:String):int {
			return _materialName2Int[name];
		}
		
		//--------------------------------兼容接口------------------------------------------------
		/**
		 * 注册材质宏定义。
		 * @param	name 宏定义名称。
		 * @return
		 */
		public function registerMaterialDefine(name:String):int {
			var value:int = Math.pow(2, _materialDefineCounter++);//TODO:超界处理	
			_materialInt2name[value] = name;
			_materialName2Int[name] = value;
			return value;
		}
		
				/**
		 * 注册精灵宏定义。
		 * @param	name 宏定义名称。
		 * @return
		 */
		public function registerSpriteDefine(name:String):int {
			var value:int = Math.pow(2, _spriteDefineCounter++);//TODO:超界处理	
			_spriteInt2name[value] = name;
			_spriteName2Int[name] = value;
			return value;
		}
		//--------------------------------兼容接口------------------------------------------------
	
	}

}
