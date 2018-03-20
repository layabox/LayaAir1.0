package laya.d3.core.material {
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines;
	import laya.utils.Browser;
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author WuTaiLang
	 */
	public class PBRStandardMaterial extends BaseMaterial {
		public static const SmoothnessSource_MetallicGlossTexture_Alpha:int = 0;
		public static const SmoothnessSource_DiffuseTexture_Alpha:int = 1;
		
		public static var SHADERDEFINE_DIFFUSETEXTURE:int;
		public static var SHADERDEFINE_NORMALTEXTURE:int;
		public static var SHADERDEFINE_SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA:int;
		public static var SHADERDEFINE_METALLICGLOSSTEXTURE:int;
		public static var SHADERDEFINE_OCCLUSIONTEXTURE:int;
		public static var SHADERDEFINE_PARALLAXTEXTURE:int;
		public static var SHADERDEFINE_EMISSION:int;
		public static var SHADERDEFINE_EMISSIONTEXTURE:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		
		public static const DIFFUSETEXTURE:int = 1;
		public static const METALLICGLOSSTEXTURE:int = 2;
		public static const NORMALTEXTURE:int = 3;
		public static const PARALLAXTEXTURE:int = 4;
		public static const OCCLUSIONTEXTURE:int = 5;
		public static const EMISSIONTEXTURE:int = 6;
		
		public static const DIFFUSECOLOR:int = 7;
		public static const EMISSIONCOLOR:int = 8;
		
		public static const METALLIC:int = 9;
		public static const SMOOTHNESS:int = 10;
		public static const SMOOTHNESSSCALE:int = 11;
		public static const SMOOTHNESSSOURCE:int = 12;
		public static const OCCLUSIONSTRENGTH:int = 13;
		public static const NORMALSCALE:int = 14;
		public static const PARALLAXSCALE:int = 15;
		public static const ENABLEEMISSION:int = 16;
		public static const TILINGOFFSET:int = 17;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_DIFFUSETEXTURE = shaderDefines.registerDefine("DIFFUSETEXTURE");
			SHADERDEFINE_METALLICGLOSSTEXTURE = shaderDefines.registerDefine("METALLICGLOSSTEXTURE");
			SHADERDEFINE_SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA = shaderDefines.registerDefine("SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA");
			SHADERDEFINE_NORMALTEXTURE = shaderDefines.registerDefine("NORMALTEXTURE");
			SHADERDEFINE_PARALLAXTEXTURE = shaderDefines.registerDefine("PARALLAXTEXTURE");
			SHADERDEFINE_OCCLUSIONTEXTURE = shaderDefines.registerDefine("OCCLUSIONTEXTURE");
			SHADERDEFINE_EMISSION = shaderDefines.registerDefine("EMISSION");
			SHADERDEFINE_EMISSIONTEXTURE = shaderDefines.registerDefine("EMISSIONTEXTURE");
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
		}
		
		/**
		 * 获取漫反射颜色。
		 * @return 漫反射颜色。
		 */
		public function get albedoColor():Vector4 {
			return _getColor(DIFFUSECOLOR);
		}
		
		/**
		 * 设置漫反射颜色。
		 * @param value 漫反射颜色。
		 */
		public function set albedoColor(value:Vector4):void {
			_setColor(DIFFUSECOLOR, value);
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get albedoTexture():BaseTexture {
			return _getTexture(DIFFUSETEXTURE);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set albedoTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(PBRStandardMaterial.SHADERDEFINE_DIFFUSETEXTURE);
			else
				_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_DIFFUSETEXTURE);
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
			if (value)
				_addShaderDefine(PBRStandardMaterial.SHADERDEFINE_NORMALTEXTURE);
			else
				_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_NORMALTEXTURE);
			_setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取法线贴图缩放系数。
		 * @return 法线贴图缩放系数。
		 */
		public function get normalTextureScale():Number {
			return _getNumber(NORMALSCALE);
		}
		
		/**
		 * 设置法线贴图缩放系数。
		 * @param value 法线贴图缩放系数。
		 */
		public function set normalTextureScale(value:Number):void {
			_setNumber(NORMALSCALE, value);
		}
		
		/**
		 * 获取视差贴图。
		 * @return 视察贴图。
		 */
		public function get parallaxTexture():BaseTexture {
			return _getTexture(PARALLAXTEXTURE);
		}
		
		/**
		 * 设置视差贴图。
		 * @param value 视察贴图。
		 */
		public function set parallaxTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(PBRStandardMaterial.SHADERDEFINE_PARALLAXTEXTURE);
			else
				_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_PARALLAXTEXTURE);
			_setTexture(PARALLAXTEXTURE, value);
		}
		
		/**
		 * 获取视差贴图缩放系数。
		 * @return 视差缩放系数。
		 */
		public function get parallaxTextureScale():Number {
			return _getNumber(PARALLAXSCALE);
		}
		
		/**
		 * 设置视差贴图缩放系数。
		 * @param value 视差缩放系数。
		 */
		public function set parallaxTextureScale(value:Number):void {
			value = Math.max(0.005, Math.min(0.08, value));
			_setNumber(PARALLAXSCALE, value);
		}
		
		/**
		 * 获取遮挡贴图。
		 * @return 遮挡贴图。
		 */
		public function get occlusionTexture():BaseTexture {
			return _getTexture(OCCLUSIONTEXTURE);
		}
		
		/**
		 * 设置遮挡贴图。
		 * @param value 遮挡贴图。
		 */
		public function set occlusionTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(PBRStandardMaterial.SHADERDEFINE_OCCLUSIONTEXTURE);
			else
				_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_OCCLUSIONTEXTURE);
			_setTexture(OCCLUSIONTEXTURE, value);
		}
		
		/**
		 * 获取遮挡贴图强度。
		 * @return 遮挡贴图强度,范围为0到1。
		 */
		public function get occlusionTextureStrength():Number {
			return _getNumber(OCCLUSIONSTRENGTH);
		}
		
		/**
		 * 设置遮挡贴图强度。
		 * @param value 遮挡贴图强度,范围为0到1。
		 */
		public function set occlusionTextureStrength(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_setNumber(OCCLUSIONSTRENGTH, value);
		}
		
		///**
		//* 获取反射贴图。
		//* @return 反射贴图。
		//*/
		//public function get reflectTexture():BaseTexture {
		//return _getTexture(REFLECTTEXTURE);
		//}
		//
		///**
		//* 设置反射贴图。
		//* @param value 反射贴图。
		//*/
		//public function set reflectTexture(value:BaseTexture):void {
		//_setTexture(REFLECTTEXTURE, value);
		//}
		
		/**
		 * 获取金属光滑度贴图。
		 * @return 金属光滑度贴图。
		 */
		public function get metallicGlossTexture():BaseTexture {
			return _getTexture(METALLICGLOSSTEXTURE);
		}
		
		/**
		 * 设置金属光滑度贴图。
		 * @param value 金属光滑度贴图。
		 */
		public function set metallicGlossTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(PBRStandardMaterial.SHADERDEFINE_METALLICGLOSSTEXTURE);
			else
				_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_METALLICGLOSSTEXTURE);
			_setTexture(METALLICGLOSSTEXTURE, value);
		}
		
		/**
		 * 获取金属度。
		 * @return 金属度,范围为0到1。
		 */
		public function get metallic():Number {
			return _getNumber(METALLIC);
		}
		
		/**
		 * 设置金属度。
		 * @param value 金属度,范围为0到1。
		 */
		public function set metallic(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_setNumber(METALLIC, value);
		}
		
		/**
		 * 获取光滑度。
		 * @return 光滑度,范围为0到1。
		 */
		public function get smoothness():Number {
			return _getNumber(SMOOTHNESS);
		}
		
		/**
		 * 设置光滑度。
		 * @param value 光滑度,范围为0到1。
		 */
		public function set smoothness(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_setNumber(SMOOTHNESS, value);
		}
		
		/**
		 * 获取光滑度缩放系数。
		 * @return 光滑度缩放系数,范围为0到1。
		 */
		public function get smoothnessTextureScale():Number {
			return _getNumber(SMOOTHNESSSCALE);
		}
		
		/**
		 * 设置光滑度缩放系数。
		 * @param value 光滑度缩放系数,范围为0到1。
		 */
		public function set smoothnessTextureScale(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_setNumber(SMOOTHNESSSCALE, value);
		}
		
		/**
		 * 获取光滑度数据源
		 * @return 光滑滑度数据源,0或1。
		 */
		public function get smoothnessSource():int {
			return _getNumber(SMOOTHNESSSOURCE);
		}
		
		/**
		 * 设置光滑度数据源。
		 * @param value 光滑滑度数据源,0或1。
		 */
		public function set smoothnessSource(value:int):void {
			if (value == 1)
				_addShaderDefine(PBRStandardMaterial.SHADERDEFINE_SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA);
			else {
				_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA);
				value = 0;
			}
			_setNumber(SMOOTHNESSSOURCE, value);
		}
		
		/**
		 * 获取是否激活放射属性。
		 * @return 是否激活放射属性。
		 */
		public function get enableEmission():Boolean {
			return _getBool(ENABLEEMISSION);
		}
		
		/**
		 * 设置是否激活放射属性。
		 * @param value 是否激活放射属性
		 */
		public function set enableEmission(value:Boolean):void {
			if (value)
				_addShaderDefine(PBRStandardMaterial.SHADERDEFINE_EMISSION);
			else {
				_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_EMISSION);
			}
			_setBool(ENABLEEMISSION, value);
		}
		
		/**
		 * 获取放射颜色。
		 * @return 放射颜色。
		 */
		public function get emissionColor():Vector4 {
			return _getColor(EMISSIONCOLOR);
		}
		
		/**
		 * 设置放射颜色。
		 * @param value 放射颜色。
		 */
		public function set emissionColor(value:Vector4):void {
			_setColor(EMISSIONCOLOR, value);
		}
		
		/**
		 * 获取放射贴图。
		 * @return 放射贴图。
		 */
		public function get emissionTexture():BaseTexture {
			return _getTexture(EMISSIONTEXTURE);
		}
		
		/**
		 * 设置放射贴图。
		 * @param value 放射贴图。
		 */
		public function set emissionTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(PBRStandardMaterial.SHADERDEFINE_EMISSIONTEXTURE);
			else
				_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_EMISSIONTEXTURE);
			_setTexture(EMISSIONTEXTURE, value);
		}
		
		/**
		 * 获取纹理平铺和偏移。
		 * @return 纹理平铺和偏移。
		 */
		public function get tilingOffset():Vector4 {
			return _getColor(TILINGOFFSET);
		}
		
		/**
		 * 设置纹理平铺和偏移。
		 * @param value 纹理平铺和偏移。
		 */
		public function set tilingOffset(value:Vector4):void {
			if (value) {
				var valueE:Float32Array = value.elements;
				if (valueE[0] != 1 || valueE[1] != 1 || valueE[2] != 0 || valueE[3] != 0)
					_addShaderDefine(PBRStandardMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_removeShaderDefine(PBRStandardMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_setColor(TILINGOFFSET, value);
		}
		
		public function PBRStandardMaterial() {
			super();
			setShaderName("PBRStandard");
			_setColor(DIFFUSECOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
			_setColor(EMISSIONCOLOR, new Vector4(0.0, 0.0, 0.0, 0.0));
			_setNumber(METALLIC, 0.0);
			_setNumber(SMOOTHNESS, 0.5);
			_setNumber(SMOOTHNESSSCALE, 1.0);
			_setNumber(SMOOTHNESSSOURCE, 0);
			_setNumber(OCCLUSIONSTRENGTH, 1.0);
			_setNumber(NORMALSCALE, 1.0);
			_setNumber(PARALLAXSCALE, 0.001);
			_setBool(ENABLEEMISSION, false);
			_setNumber(ALPHATESTVALUE, 0.5);
		}
	
	}

}