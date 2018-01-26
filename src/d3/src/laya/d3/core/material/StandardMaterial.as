package laya.d3.core.material {
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines;
	import laya.net.Loader;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StandardMaterial extends BaseMaterial {
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 1;
		/**渲染状态_不透明_双面。*/
		public static const RENDERMODE_OPAQUEDOUBLEFACE:int = 2;
		/**渲染状态_透明测试。*/
		public static const RENDERMODE_CUTOUT:int = 3;
		/**渲染状态_透明测试_双面。*/
		public static const RENDERMODE_CUTOUTDOUBLEFACE:int = 4;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 13;
		/**渲染状态_透明混合_双面。*/
		public static const RENDERMODE_TRANSPARENTDOUBLEFACE:int = 14;
		/**渲染状态_加色法混合。*/
		public static const RENDERMODE_ADDTIVE:int = 15;
		/**渲染状态_加色法混合_双面。*/
		public static const RENDERMODE_ADDTIVEDOUBLEFACE:int = 16;
		/**渲染状态_只读深度_透明混合。*/
		public static const RENDERMODE_DEPTHREAD_TRANSPARENT:int = 5;
		/**渲染状态_只读深度_透明混合_双面。*/
		public static const RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE:int = 6;
		/**渲染状态_只读深度_加色法混合。*/
		public static const RENDERMODE_DEPTHREAD_ADDTIVE:int = 7;
		/**渲染状态_只读深度_加色法混合_双面。*/
		public static const RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE:int = 8;
		/**渲染状态_无深度_透明混合。*/
		public static const RENDERMODE_NONDEPTH_TRANSPARENT:int = 9;
		/**渲染状态_无深度_透明混合_双面。*/
		public static const RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE:int = 10;
		/**渲染状态_无深度_加色法混合。*/
		public static const RENDERMODE_NONDEPTH_ADDTIVE:int = 11;
		/**渲染状态_无深度_加色法混合_双面。*/
		public static const RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE:int = 12;
		
		public static var SHADERDEFINE_DIFFUSEMAP:int;
		public static var SHADERDEFINE_NORMALMAP:int;
		public static var SHADERDEFINE_SPECULARMAP:int;
		public static var SHADERDEFINE_EMISSIVEMAP:int;
		public static var SHADERDEFINE_AMBIENTMAP:int;
		public static var SHADERDEFINE_REFLECTMAP:int;
		public static var SHADERDEFINE_UVTRANSFORM:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		public static var SHADERDEFINE_ADDTIVEFOG:int;
		
		public static const DIFFUSETEXTURE:int = 1;
		public static const NORMALTEXTURE:int = 2;
		public static const SPECULARTEXTURE:int = 3;
		public static const EMISSIVETEXTURE:int = 4;
		public static const AMBIENTTEXTURE:int = 5;
		public static const REFLECTTEXTURE:int = 6;
		public static const ALBEDO:int = 7;
		public static const UVANIAGE:int = 8;
		public static const MATERIALAMBIENT:int = 9;
		public static const MATERIALDIFFUSE:int = 10;
		public static const MATERIALSPECULAR:int = 11;
		public static const MATERIALREFLECT:int = 12;
		public static const UVMATRIX:int = 13;
		public static const UVAGE:int = 14;
		public static const TILINGOFFSET:int = 15;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:StandardMaterial = new StandardMaterial();
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_DIFFUSEMAP = shaderDefines.registerDefine("DIFFUSEMAP");
			SHADERDEFINE_NORMALMAP = shaderDefines.registerDefine("NORMALMAP");
			SHADERDEFINE_SPECULARMAP = shaderDefines.registerDefine("SPECULARMAP");
			SHADERDEFINE_EMISSIVEMAP = shaderDefines.registerDefine("EMISSIVEMAP");
			SHADERDEFINE_AMBIENTMAP = shaderDefines.registerDefine("AMBIENTMAP");
			SHADERDEFINE_REFLECTMAP = shaderDefines.registerDefine("REFLECTMAP");
			SHADERDEFINE_UVTRANSFORM = shaderDefines.registerDefine("UVTRANSFORM");
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
			SHADERDEFINE_ADDTIVEFOG = shaderDefines.registerDefine("ADDTIVEFOG");
		}
		
		/**
		 * 加载标准材质。
		 * @param url 标准材质地址。
		 */
		public static function load(url:String):StandardMaterial {
			return Laya.loader.create(url, null, null, StandardMaterial);
		}
		
		/** @private */
		protected var _transformUV:TransformUV = null;
		
		/**
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			switch (value) {
			case RENDERMODE_OPAQUE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				alphaTest = false;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				alphaTest = false;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_CUTOUT: 
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				renderQueue = RenderQueue.OPAQUE;
				alphaTest = true;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_CUTOUTDOUBLEFACE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				alphaTest = true;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_TRANSPARENTDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				_addShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_ADDTIVEDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				_addShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				_addShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				_addShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = DEPTHTEST_LESS;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = DEPTHTEST_LESS;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = DEPTHTEST_LESS;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				_addShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = DEPTHTEST_LESS;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				_addShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			default: 
				throw new Error("Material:renderMode value error.");
			}
			
			_conchMaterial && _conchMaterial.setRenderMode(value);//NATIVE
		}
		
		/**
		 * 获取纹理平铺和偏移。
		 * @return 纹理平铺和偏移。
		 */
		public function get tilingOffset():Vector4 {
			return _getColor(TILINGOFFSET);
		}
		
		/**
		 * 获取纹理平铺和偏移。
		 * @param value 纹理平铺和偏移。
		 */
		public function set tilingOffset(value:Vector4):void {
			if (value) {
				var valueE:Float32Array = value.elements;
				if (valueE[0] != 1 || valueE[1] != 1 || valueE[2] != 0 || valueE[3] != 0)
					_addShaderDefine(StandardMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_removeShaderDefine(StandardMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_setColor(TILINGOFFSET, value);
		}
		
		public function get ambientColor():Vector3 {
			return _getColor(MATERIALAMBIENT);
		}
		
		/**
		 * 设置环境光颜色。
		 * @param value 环境光颜色。
		 */
		public function set ambientColor(value:Vector3):void {
			_setColor(MATERIALAMBIENT, value);
		}
		
		public function get diffuseColor():Vector3 {
			return _getColor(MATERIALDIFFUSE);
		}
		
		/**
		 * 设置漫反射光颜色。
		 * @param value 漫反射光颜色。
		 */
		public function set diffuseColor(value:Vector3):void {
			_setColor(MATERIALDIFFUSE, value);
		}
		
		public function get specularColor():Vector4 {
			return _getColor(MATERIALSPECULAR);
		}
		
		/**
		 * 设置高光颜色。
		 * @param value 高光颜色。
		 */
		public function set specularColor(value:Vector4):void {
			_setColor(MATERIALSPECULAR, value);
		}
		
		public function get reflectColor():Vector3 {
			return _getColor(MATERIALREFLECT);
		}
		
		/**
		 * 设置反射颜色。
		 * @param value 反射颜色。
		 */
		public function set reflectColor(value:Vector3):void {
			_setColor(MATERIALREFLECT, value);
		}
		
		public function get albedoColor():Vector4 {
			return _getColor(ALBEDO);
		}
		
		/**
		 * 设置反射率。
		 * @param value 反射率。
		 */
		public function set albedoColor(value:Vector4):void {
			_setColor(ALBEDO, value);
		}
		
		public function get albedo():Vector4 {//兼容
			return _getColor(ALBEDO);
		}
		
		/**
		 * 设置反射率。
		 * @param value 反射率。
		 */
		public function set albedo(value:Vector4):void {//兼容
			_setColor(ALBEDO, value);
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _getTexture(DIFFUSETEXTURE);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set diffuseTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(StandardMaterial.SHADERDEFINE_DIFFUSEMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_DIFFUSEMAP);
			}
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		/**
		 * 获取法线贴图。
		 * @return 法线贴图。
		 */
		public function get normalTexture():BaseTexture {
			return _getTexture(NORMALTEXTURE);
		}
		
		/**
		 * 设置法线贴图。
		 * @param value 法线贴图。
		 */
		public function set normalTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(StandardMaterial.SHADERDEFINE_NORMALMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_NORMALMAP);
			}
			_setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取高光贴图。
		 * @return 高光贴图。
		 */
		public function get specularTexture():BaseTexture {
			return _getTexture(SPECULARTEXTURE);
		}
		
		/**
		 * 设置高光贴图。
		 * @param value  高光贴图。
		 */
		public function set specularTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(StandardMaterial.SHADERDEFINE_SPECULARMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_SPECULARMAP);
			}
			
			_setTexture(SPECULARTEXTURE, value);
		}
		
		/**
		 * 获取放射贴图。
		 * @return 放射贴图。
		 */
		public function get emissiveTexture():BaseTexture {
			return _getTexture(EMISSIVETEXTURE);
		}
		
		/**
		 * 设置放射贴图。
		 * @param value 放射贴图。
		 */
		public function set emissiveTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(StandardMaterial.SHADERDEFINE_EMISSIVEMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_EMISSIVEMAP);
			}
			_setTexture(EMISSIVETEXTURE, value);
		}
		
		/**
		 * 获取环境贴图。
		 * @return 环境贴图。
		 */
		public function get ambientTexture():BaseTexture {
			return _getTexture(AMBIENTTEXTURE);
		}
		
		/**
		 * 设置环境贴图。
		 * @param  value 环境贴图。
		 */
		public function set ambientTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(StandardMaterial.SHADERDEFINE_AMBIENTMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_AMBIENTMAP);
			}
			_setTexture(AMBIENTTEXTURE, value);
		}
		
		/**
		 * 获取反射贴图。
		 * @return 反射贴图。
		 */
		public function get reflectTexture():BaseTexture {
			return _getTexture(REFLECTTEXTURE);
		}
		
		/**
		 * 设置反射贴图。
		 * @param value 反射贴图。
		 */
		public function set reflectTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(StandardMaterial.SHADERDEFINE_REFLECTMAP);
			} else {
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_REFLECTMAP);
			}
			_setTexture(REFLECTTEXTURE, value);
		}
		
		/**
		 * 获取UV变换。
		 * @return  UV变换。
		 */
		public function get transformUV():TransformUV {
			return _transformUV;
		}
		
		/**
		 * 设置UV变换。
		 * @param value UV变换。
		 */
		public function set transformUV(value:TransformUV):void {
			_transformUV = value;
			_setMatrix4x4(UVMATRIX, value.matrix);
			if (value)
				_addShaderDefine(StandardMaterial.SHADERDEFINE_UVTRANSFORM);
			else
				_removeShaderDefine(StandardMaterial.SHADERDEFINE_UVTRANSFORM);
			if (_conchMaterial) {//NATIVE//TODO:可取消
				_conchMaterial.setShaderValue(UVMATRIX, value.matrix.elements, 0);
			}
		}
		
		public function StandardMaterial() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			setShaderName("SIMPLE");
			_setColor(MATERIALAMBIENT, new Vector3(0.6, 0.6, 0.6));
			_setColor(MATERIALDIFFUSE, new Vector3(1.0, 1.0, 1.0));
			_setColor(MATERIALSPECULAR, new Vector4(1.0, 1.0, 1.0, 8.0));
			_setColor(MATERIALREFLECT, new Vector3(1.0, 1.0, 1.0));
			_setColor(ALBEDO, new Vector4(1.0, 1.0, 1.0, 1.0));
			_setNumber(ALPHATESTVALUE, 0.5);
			_setColor(TILINGOFFSET, new Vector4(1.0, 1.0, 0.0, 0.0));
			renderMode = RENDERMODE_OPAQUE;
		}
		
		/**
		 * @private
		 */
		public static function _parseStandardMaterial(textureMap:Object, material:StandardMaterial, json:Object):void {//兼容性函数
			var customProps:Object = json.customProps;
			var ambientColorValue:Array = customProps.ambientColor;
			material.ambientColor = new Vector3(ambientColorValue[0], ambientColorValue[1], ambientColorValue[2]);
			var diffuseColorValue:Array = customProps.diffuseColor;
			material.diffuseColor = new Vector3(diffuseColorValue[0], diffuseColorValue[1], diffuseColorValue[2]);
			var specularColorValue:Array = customProps.specularColor;
			material.specularColor = new Vector4(specularColorValue[0], specularColorValue[1], specularColorValue[2], specularColorValue[3]);
			var reflectColorValue:Array = customProps.reflectColor;
			material.reflectColor = new Vector3(reflectColorValue[0], reflectColorValue[1], reflectColorValue[2]);
			var albedoColorValue:Array = customProps.albedoColor;
			(albedoColorValue) && (material.albedo = new Vector4(albedoColorValue[0], albedoColorValue[1], albedoColorValue[2], albedoColorValue[3]));
			
			var diffuseTexture:String = customProps.diffuseTexture.texture2D;
			(diffuseTexture) && (material.diffuseTexture = Loader.getRes(textureMap[diffuseTexture]));
			
			var normalTexture:String = customProps.normalTexture.texture2D;
			(normalTexture) && (material.normalTexture = Loader.getRes(textureMap[normalTexture]));
			
			var specularTexture:String = customProps.specularTexture.texture2D;
			(specularTexture) && (material.specularTexture = Loader.getRes(textureMap[specularTexture]));
			
			var emissiveTexture:String = customProps.emissiveTexture.texture2D;
			(emissiveTexture) && (material.emissiveTexture = Loader.getRes(textureMap[emissiveTexture]));
			
			var ambientTexture:String = customProps.ambientTexture.texture2D;
			(ambientTexture) && (material.ambientTexture = Loader.getRes(textureMap[ambientTexture]));
			
			var reflectTexture:String = customProps.reflectTexture.texture2D;
			(reflectTexture) && (material.reflectTexture = Loader.getRes(textureMap[reflectTexture]));
		}
		
		/**
		 * 禁用灯光。
		 */
		public function disableLight():void {
			_addDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT | ShaderCompile3D.SHADERDEFINE_SPOTLIGHT | ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
		}
		
		/**
		 * 禁用雾化。
		 */
		public function disableFog():void {
			_addDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_FOG);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var jsonData:Object = data[0];
			if (jsonData.version) {
				super.onAsynLoaded(url, data, params);
			} else {//兼容性代码
				var textureMap:Object = data[1];
				var props:Object = jsonData.props;
				for (var prop:String in props)
					this[prop] = props[prop];
				_parseStandardMaterial(textureMap, this, jsonData);
				
				_endLoaded();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var dest:StandardMaterial = destObject as StandardMaterial;
			(_transformUV) && (dest._transformUV = _transformUV.clone());
		}
	}

}