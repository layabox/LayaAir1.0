package laya.d3.core.material {
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines;
	
	/**
	 * <code>BlinnPhongMaterial</code> 类用于实现Blinn-Phong材质。
	 */
	public class BlinnPhongMaterial extends BaseMaterial {
		/**高光强度数据源_漫反射贴图的Alpha通道。*/
		public static var SPECULARSOURCE_DIFFUSEMAPALPHA:int;
		/**高光强度数据源_高光贴图的RGB通道。*/
		public static var SPECULARSOURCE_SPECULARMAP:int;
		
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 0;
		/**渲染状态_透明测试。*/
		public static const RENDERMODE_CUTOUT:int = 1;
		/**渲染状态__透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 2;
		/**渲染状态__加色法混合。*/
		public static const RENDERMODE_ADDTIVE:int = 3;
		
		public static var SHADERDEFINE_DIFFUSEMAP:int;
		public static var SHADERDEFINE_NORMALMAP:int;
		public static var SHADERDEFINE_SPECULARMAP:int;
		public static var SHADERDEFINE_REFLECTMAP:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		public static var SHADERDEFINE_ADDTIVEFOG:int;
		
		public static const ALBEDOTEXTURE:int = 1;
		public static const NORMALTEXTURE:int = 2;
		public static const SPECULARTEXTURE:int = 3;
		public static const EMISSIVETEXTURE:int = 4;
		public static const REFLECTTEXTURE:int = 5;
		public static const ALBEDOCOLOR:int = 6;
		public static const MATERIALSPECULAR:int = 8;
		public static const SHININESS:int = 9;
		public static const MATERIALREFLECT:int = 10;
		public static const TILINGOFFSET:int = 11;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:BlinnPhongMaterial = new BlinnPhongMaterial();
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_DIFFUSEMAP = shaderDefines.registerDefine("DIFFUSEMAP");
			SHADERDEFINE_NORMALMAP = shaderDefines.registerDefine("NORMALMAP");
			SHADERDEFINE_SPECULARMAP = shaderDefines.registerDefine("SPECULARMAP");
			SHADERDEFINE_REFLECTMAP = shaderDefines.registerDefine("REFLECTMAP");
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
			SHADERDEFINE_ADDTIVEFOG = shaderDefines.registerDefine("ADDTIVEFOG");;
		}
		
		/**
		 * 加载标准材质。
		 * @param url 标准材质地址。
		 */
		public static function load(url:String):BlinnPhongMaterial {
			return Laya.loader.create(url, null, null, BlinnPhongMaterial);
		}
		
		/**@private */
		private var _albedoColor:Vector4;
		/**@private */
		private var _albedoIntensity:Number;
		/**@private */
		private var _enableLighting:Boolean;
		
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
				depthTest = DEPTHTEST_LESS;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_CUTOUT: 
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				renderQueue = RenderQueue.OPAQUE;
				alphaTest = true;
				depthTest = DEPTHTEST_LESS;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				depthTest = DEPTHTEST_LESS;
				_removeShaderDefine(SHADERDEFINE_ADDTIVEFOG);
				break;
			case RENDERMODE_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				depthTest = DEPTHTEST_LESS;
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
					_addShaderDefine(BlinnPhongMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_removeShaderDefine(BlinnPhongMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_removeShaderDefine(BlinnPhongMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_setColor(TILINGOFFSET, value);
		}
		
		/**
		 * 获取漫反射颜色。
		 * @return 漫反射颜色。
		 */
		public function get albedoColor():Vector4 {
			return _albedoColor;
		}
		
		/**
		 * 设置漫反射颜色。
		 * @param value 漫反射颜色。
		 */
		public function set albedoColor(value:Vector4):void {
			var finalAlbedo:Vector4 = _getColor(ALBEDOCOLOR);
			Vector4.scale(value, _albedoIntensity, finalAlbedo);
			_albedoColor = value;
		}
		
		/**
		 * 获取漫反射颜色。
		 * @return 漫反射颜色。
		 */
		public function get albedoIntensity():Number {
			return _albedoIntensity;
		}
		
		/**
		 * 设置漫反射颜色。
		 * @param value 漫反射颜色。
		 */
		public function set albedoIntensity(value:Number):void {
			if (_albedoIntensity !== value) {
				var finalAlbedo:Vector4 = _getColor(ALBEDOCOLOR);
				Vector4.scale(_albedoColor, value, finalAlbedo);
				_albedoIntensity = value;
			}
		}
		
		/**
		 * 获取高光颜色。
		 * @return 高光颜色。
		 */
		public function get specularColor():Vector3 {
			return _getColor(MATERIALSPECULAR);
		}
		
		/**
		 * 设置高光颜色。
		 * @param value 高光颜色。
		 */
		public function set specularColor(value:Vector3):void {
			_setColor(MATERIALSPECULAR, value);
		}
		
		/**
		 * 获取高光强度,范围为0到1。
		 * @return 高光强度。
		 */
		public function get shininess():Number {
			return _getNumber(SHININESS);
		}
		
		/**
		 * 设置高光强度,范围为0到1。
		 * @param value 高光强度。
		 */
		public function set shininess(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_setNumber(SHININESS, value);
		}
		
		/**
		 * 获取反射颜色。
		 * @return value 反射颜色。
		 */
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
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get albedoTexture():BaseTexture {
			return _getTexture(ALBEDOTEXTURE);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set albedoTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(BlinnPhongMaterial.SHADERDEFINE_DIFFUSEMAP);
			else
				_removeShaderDefine(BlinnPhongMaterial.SHADERDEFINE_DIFFUSEMAP);
			_setTexture(ALBEDOTEXTURE, value);
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
			if (value)
				_addShaderDefine(BlinnPhongMaterial.SHADERDEFINE_NORMALMAP);
			else
				_removeShaderDefine(BlinnPhongMaterial.SHADERDEFINE_NORMALMAP);
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
		 * 设置高光贴图，高光强度则从该贴图RGB值中获取,如果该值为空则从漫反射贴图的Alpha通道获取。
		 * @param value  高光贴图。
		 */
		public function set specularTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(BlinnPhongMaterial.SHADERDEFINE_SPECULARMAP);
			else
				_removeShaderDefine(BlinnPhongMaterial.SHADERDEFINE_SPECULARMAP);
			
			_setTexture(SPECULARTEXTURE, value);
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
			if (value)
				_addShaderDefine(BlinnPhongMaterial.SHADERDEFINE_REFLECTMAP);
			else
				_removeShaderDefine(BlinnPhongMaterial.SHADERDEFINE_REFLECTMAP);
			_setTexture(REFLECTTEXTURE, value);
		}
		
		/**
		 * 获取是否启用光照。
		 * @return 是否启用光照。
		 */
		public function get enableLighting():Boolean {
			return _enableLighting;
		}
		
		/**
		 * 设置是否启用光照。
		 * @param value 是否启用光照。
		 */
		public function set enableLighting(value:Boolean):void {
			if (_enableLighting !== value) {
				if (value)
					_removeDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT | ShaderCompile3D.SHADERDEFINE_SPOTLIGHT | ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
				else
					_addDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT | ShaderCompile3D.SHADERDEFINE_SPOTLIGHT | ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
				_enableLighting = value;
			}
		}
		
		public function BlinnPhongMaterial() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			
			setShaderName("BLINNPHONG");
			_albedoIntensity = 1.0;
			_albedoColor = new Vector4(1.0, 1.0, 1.0, 1.0);
			_setColor(ALBEDOCOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
			_setColor(MATERIALSPECULAR, new Vector3(1.0, 1.0, 1.0));
			_setNumber(SHININESS, 0.078125);
			_setColor(MATERIALREFLECT, new Vector3(1.0, 1.0, 1.0));
			_setNumber(ALPHATESTVALUE, 0.5);
			_setColor(TILINGOFFSET, new Vector4(1.0, 1.0, 0.0, 0.0));
			_enableLighting = true;
			renderMode = RENDERMODE_OPAQUE;
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
	}

}