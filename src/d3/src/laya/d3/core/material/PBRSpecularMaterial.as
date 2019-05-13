package laya.d3.core.material {
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderData;
	import laya.d3.shader.ShaderDefines;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * <code>PBRSpecularMaterial</code> 类用于实现PBR(Specular)材质。
	 */
	public class PBRSpecularMaterial extends BaseMaterial {
		
		/**光滑度数据源_高光贴图的Alpha通道。*/
		public static const SmoothnessSource_SpecularTexture_Alpha:int = 0;
		/**光滑度数据源_反射率贴图的Alpha通道。*/
		public static const SmoothnessSource_AlbedoTexture_Alpha:int = 1;
		
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 0;
		/**渲染状态_透明测试。*/
		public static const RENDERMODE_CUTOUT:int = 1;
		/**渲染状态_透明混合_游戏中经常使用的透明。*/
		public static const RENDERMODE_FADE:int = 2;
		/**渲染状态_透明混合_物理上看似合理的透明。*/
		public static const RENDERMODE_TRANSPARENT:int = 3;
		
		public static var SHADERDEFINE_ALBEDOTEXTURE:int;
		public static var SHADERDEFINE_NORMALTEXTURE:int;
		public static var SHADERDEFINE_SMOOTHNESSSOURCE_ALBEDOTEXTURE_ALPHA:int;
		public static var SHADERDEFINE_SPECULARTEXTURE:int;
		public static var SHADERDEFINE_OCCLUSIONTEXTURE:int;
		public static var SHADERDEFINE_PARALLAXTEXTURE:int;
		public static var SHADERDEFINE_EMISSION:int;
		public static var SHADERDEFINE_EMISSIONTEXTURE:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		public static var SHADERDEFINE_ALPHAPREMULTIPLY:int;
		
		public static const ALBEDOTEXTURE:int = Shader3D.propertyNameToID("u_AlbedoTexture");
		public static const SPECULARTEXTURE:int = Shader3D.propertyNameToID("u_SpecularTexture");
		public static const NORMALTEXTURE:int = Shader3D.propertyNameToID("u_NormalTexture");
		public static const PARALLAXTEXTURE:int = Shader3D.propertyNameToID("u_ParallaxTexture");
		public static const OCCLUSIONTEXTURE:int = Shader3D.propertyNameToID("u_OcclusionTexture");
		public static const EMISSIONTEXTURE:int = Shader3D.propertyNameToID("u_EmissionTexture");
		
		public static const ALBEDOCOLOR:int = Shader3D.propertyNameToID("u_AlbedoColor");
		public static const SPECULARCOLOR:int = Shader3D.propertyNameToID("u_SpecularColor");
		public static const EMISSIONCOLOR:int = Shader3D.propertyNameToID("u_EmissionColor");
		
		public static const SMOOTHNESS:int = Shader3D.propertyNameToID("u_smoothness");
		public static const SMOOTHNESSSCALE:int = Shader3D.propertyNameToID("u_smoothnessScale");
		public static const SMOOTHNESSSOURCE:int = -1;//TODO:
		public static const OCCLUSIONSTRENGTH:int = Shader3D.propertyNameToID("u_occlusionStrength");
		public static const NORMALSCALE:int = Shader3D.propertyNameToID("u_normalScale");
		public static const PARALLAXSCALE:int = Shader3D.propertyNameToID("u_parallaxScale");
		public static const ENABLEEMISSION:int = -1;//TODO:
		public static const ENABLEREFLECT:int = -1;//TODO:
		public static const TILINGOFFSET:int = Shader3D.propertyNameToID("u_TilingOffset");
		
		public static const CULL:int = Shader3D.propertyNameToID("s_Cull");
		public static const BLEND:int = Shader3D.propertyNameToID("s_Blend");
		public static const BLEND_SRC:int = Shader3D.propertyNameToID("s_BlendSrc");
		public static const BLEND_DST:int = Shader3D.propertyNameToID("s_BlendDst");
		public static const DEPTH_TEST:int = Shader3D.propertyNameToID("s_DepthTest");
		public static const DEPTH_WRITE:int = Shader3D.propertyNameToID("s_DepthWrite");
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:PBRSpecularMaterial = new PBRSpecularMaterial();
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_ALBEDOTEXTURE = shaderDefines.registerDefine("ALBEDOTEXTURE");
			SHADERDEFINE_SPECULARTEXTURE = shaderDefines.registerDefine("SPECULARTEXTURE");
			SHADERDEFINE_SMOOTHNESSSOURCE_ALBEDOTEXTURE_ALPHA = shaderDefines.registerDefine("SMOOTHNESSSOURCE_ALBEDOTEXTURE_ALPHA");
			SHADERDEFINE_NORMALTEXTURE = shaderDefines.registerDefine("NORMALTEXTURE");
			SHADERDEFINE_PARALLAXTEXTURE = shaderDefines.registerDefine("PARALLAXTEXTURE");
			SHADERDEFINE_OCCLUSIONTEXTURE = shaderDefines.registerDefine("OCCLUSIONTEXTURE");
			SHADERDEFINE_EMISSION = shaderDefines.registerDefine("EMISSION");
			SHADERDEFINE_EMISSIONTEXTURE = shaderDefines.registerDefine("EMISSIONTEXTURE");
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
			SHADERDEFINE_ALPHAPREMULTIPLY = shaderDefines.registerDefine("ALPHAPREMULTIPLY");
		}
		
		/**@private */
		private var _albedoColor:Vector4;
		/**@private */
		private var _specularColor:Vector4;
		/**@private */
		private var _emissionColor:Vector4;
		
		/**
		 * @private
		 */
		public function get _ColorR():Number {
			return _albedoColor.x;
		}
		
		/**
		 * @private
		 */
		public function set _ColorR(value:Number):void {
			_albedoColor.x = value;
			albedoColor = _albedoColor;
		}
		
		/**
		 * @private
		 */
		public function get _ColorG():Number {
			return _albedoColor.y;
		}
		
		/**
		 * @private
		 */
		public function set _ColorG(value:Number):void {
			_albedoColor.y = value;
			albedoColor = _albedoColor;
		}
		
		/**
		 * @private
		 */
		public function get _ColorB():Number {
			return _albedoColor.z;
		}
		
		/**
		 * @private
		 */
		public function set _ColorB(value:Number):void {
			_albedoColor.z = value;
			albedoColor = _albedoColor;
		}
		
		/**
		 * @private
		 */
		public function get _ColorA():Number {
			return _albedoColor.w;
		}
		
		/**
		 * @private
		 */
		public function set _ColorA(value:Number):void {
			_albedoColor.w = value;
			albedoColor = _albedoColor;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorR():Number {
			return _specularColor.x;
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorR(value:Number):void {
			_specularColor.x = value;
			specularColor = _specularColor;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorG():Number {
			return _specularColor.y;
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorG(value:Number):void {
			_specularColor.y = value;
			specularColor = _specularColor;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorB():Number {
			return _specularColor.z;
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorB(value:Number):void {
			_specularColor.z = value;
			specularColor = _specularColor;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorA():Number {
			return _specularColor.w;
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorA(value:Number):void {
			_specularColor.w = value;
			specularColor = _specularColor;
		}
		
		/**
		 * @private
		 */
		public function get _Glossiness():Number {
			return _shaderValues.getNumber(SMOOTHNESS);
		}
		
		/**
		 * @private
		 */
		public function set _Glossiness(value:Number):void {
			_shaderValues.setNumber(SMOOTHNESS, value);
		}
		
		/**
		 * @private
		 */
		public function get _GlossMapScale():Number {
			return _shaderValues.getNumber(SMOOTHNESSSCALE);
		}
		
		/**
		 * @private
		 */
		public function set _GlossMapScale(value:Number):void {
			_shaderValues.setNumber(SMOOTHNESSSCALE, value);
		}
		
		/**
		 * @private
		 */
		public function get _BumpScale():Number {
			return _shaderValues.getNumber(NORMALSCALE);
		}
		
		/**
		 * @private
		 */
		public function set _BumpScale(value:Number):void {
			_shaderValues.setNumber(NORMALSCALE, value);
		}
		
		/**@private */
		public function get _Parallax():Number {
			return _shaderValues.getNumber(PARALLAXSCALE);
		}
		
		/**
		 * @private
		 */
		public function set _Parallax(value:Number):void {
			_shaderValues.setNumber(PARALLAXSCALE, value);
		}
		
		/**@private */
		public function get _OcclusionStrength():Number {
			return _shaderValues.getNumber(OCCLUSIONSTRENGTH);
		}
		
		/**
		 * @private
		 */
		public function set _OcclusionStrength(value:Number):void {
			_shaderValues.setNumber(OCCLUSIONSTRENGTH, value);
		}
		
		/**
		 * @private
		 */
		public function get _EmissionColorR():Number {
			return _emissionColor.x;
		}
		
		/**
		 * @private
		 */
		public function set _EmissionColorR(value:Number):void {
			_emissionColor.x = value;
			emissionColor = _emissionColor;
		}
		
		/**
		 * @private
		 */
		public function get _EmissionColorG():Number {
			return _emissionColor.y;
		}
		
		/**
		 * @private
		 */
		public function set _EmissionColorG(value:Number):void {
			_emissionColor.y = value;
			emissionColor = _emissionColor;
		}
		
		/**
		 * @private
		 */
		public function get _EmissionColorB():Number {
			return _emissionColor.z;
		}
		
		/**
		 * @private
		 */
		public function set _EmissionColorB(value:Number):void {
			_emissionColor.z = value;
			emissionColor = _emissionColor;
		}
		
		/**
		 * @private
		 */
		public function get _EmissionColorA():Number {
			return _emissionColor.w;
		}
		
		/**
		 * @private
		 */
		public function set _EmissionColorA(value:Number):void {
			_emissionColor.w = value;
			emissionColor = _emissionColor;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STX():Number {
			return _shaderValues.getVector(TILINGOFFSET).x;
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STX(x:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.x = x;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STY():Number {
			return _shaderValues.getVector(TILINGOFFSET).y;
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STY(y:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.y = y;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STZ():Number {
			return _shaderValues.getVector(TILINGOFFSET).z;
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STZ(z:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.z = z;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STW():Number {
			return _shaderValues.getVector(TILINGOFFSET).w;
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STW(w:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.w = w;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _Cutoff():Number {
			return alphaTestValue;
		}
		
		/**
		 * @private
		 */
		public function set _Cutoff(value:Number):void {
			alphaTestValue = value;
		}
		
		/**
		 * 获取反射率颜色R分量。
		 * @return 反射率颜色R分量。
		 */
		public function get albedoColorR():Number {
			return _ColorR;
		}
		
		/**
		 * 设置反射率颜色R分量。
		 * @param value 反射率颜色R分量。
		 */
		public function set albedoColorR(value:Number):void {
			_ColorR = value;
		}
		
		/**
		 * 获取反射率颜色G分量。
		 * @return 反射率颜色G分量。
		 */
		public function get albedoColorG():Number {
			return _ColorG;
		}
		
		/**
		 * 设置反射率颜色G分量。
		 * @param value 反射率颜色G分量。
		 */
		public function set albedoColorG(value:Number):void {
			_ColorG = value;
		}
		
		/**
		 * 获取反射率颜色B分量。
		 * @return 反射率颜色B分量。
		 */
		public function get albedoColorB():Number {
			return _ColorB;
		}
		
		/**
		 * 设置反射率颜色B分量。
		 * @param value 反射率颜色B分量。
		 */
		public function set albedoColorB(value:Number):void {
			_ColorB = value;
		}
		
		/**
		 * 获取反射率颜色A分量。
		 * @return 反射率颜色A分量。
		 */
		public function get albedoColorA():Number {
			return _ColorA;
		}
		
		/**
		 * 设置反射率颜色A分量。
		 * @param value 反射率颜色A分量。
		 */
		public function set albedoColorA(value:Number):void {
			_ColorA = value;
		}
		
		/**
		 * 获取反射率颜色。
		 * @return 反射率颜色。
		 */
		public function get albedoColor():Vector4 {
			return _albedoColor;
		}
		
		/**
		 * 设置反射率颜色。
		 * @param value 反射率颜色。
		 */
		public function set albedoColor(value:Vector4):void {
			_albedoColor = value;
			_shaderValues.setVector(ALBEDOCOLOR, value);
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get albedoTexture():BaseTexture {
			return _shaderValues.getTexture(ALBEDOTEXTURE);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set albedoTexture(value:BaseTexture):void {
			if (value) {
				_defineDatas.add(PBRSpecularMaterial.SHADERDEFINE_ALBEDOTEXTURE);
			} else {
				_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_ALBEDOTEXTURE);
			}
			_shaderValues.setTexture(ALBEDOTEXTURE, value);
		}
		
		/**
		 * 获取法线贴图。
		 * @return 法线贴图。
		 */
		public function get normalTexture():BaseTexture {
			return _shaderValues.getTexture(NORMALTEXTURE);
		}
		
		/**
		 * 设置法线贴图。
		 * @param value 法线贴图。
		 */
		public function set normalTexture(value:BaseTexture):void {
			if (value) {
				_defineDatas.add(PBRSpecularMaterial.SHADERDEFINE_NORMALTEXTURE);
			} else {
				_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_NORMALTEXTURE);
			}
			_shaderValues.setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取法线贴图缩放系数。
		 * @return 法线贴图缩放系数。
		 */
		public function get normalTextureScale():Number {
			return _BumpScale;
		}
		
		/**
		 * 设置法线贴图缩放系数。
		 * @param value 法线贴图缩放系数。
		 */
		public function set normalTextureScale(value:Number):void {
			_BumpScale = value;
		}
		
		/**
		 * 获取视差贴图。
		 * @return 视察贴图。
		 */
		public function get parallaxTexture():BaseTexture {
			return _shaderValues.getTexture(PARALLAXTEXTURE);
		}
		
		/**
		 * 设置视差贴图。
		 * @param value 视察贴图。
		 */
		public function set parallaxTexture(value:BaseTexture):void {
			if (value) {
				_defineDatas.add(PBRSpecularMaterial.SHADERDEFINE_PARALLAXTEXTURE);
			} else {
				_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_PARALLAXTEXTURE);
			}
			_shaderValues.setTexture(PARALLAXTEXTURE, value);
		}
		
		/**
		 * 获取视差贴图缩放系数。
		 * @return 视差缩放系数。
		 */
		public function get parallaxTextureScale():Number {
			return _Parallax;
		}
		
		/**
		 * 设置视差贴图缩放系数。
		 * @param value 视差缩放系数。
		 */
		public function set parallaxTextureScale(value:Number):void {
			_Parallax = Math.max(0.005, Math.min(0.08, value));
		}
		
		/**
		 * 获取遮挡贴图。
		 * @return 遮挡贴图。
		 */
		public function get occlusionTexture():BaseTexture {
			return _shaderValues.getTexture(OCCLUSIONTEXTURE);
		}
		
		/**
		 * 设置遮挡贴图。
		 * @param value 遮挡贴图。
		 */
		public function set occlusionTexture(value:BaseTexture):void {
			if (value) {
				_defineDatas.add(PBRSpecularMaterial.SHADERDEFINE_OCCLUSIONTEXTURE);
			} else {
				_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_OCCLUSIONTEXTURE);
			}
			_shaderValues.setTexture(OCCLUSIONTEXTURE, value);
		}
		
		/**
		 * 获取遮挡贴图强度。
		 * @return 遮挡贴图强度,范围为0到1。
		 */
		public function get occlusionTextureStrength():Number {
			return _OcclusionStrength;
		}
		
		/**
		 * 设置遮挡贴图强度。
		 * @param value 遮挡贴图强度,范围为0到1。
		 */
		public function set occlusionTextureStrength(value:Number):void {
			_OcclusionStrength = Math.max(0.0, Math.min(1.0, value));
		}
		
		/**
		 * 获取高光贴图。
		 * @return 高光贴图。
		 */
		public function get specularTexture():BaseTexture {
			return _shaderValues.getTexture(SPECULARTEXTURE);
		}
		
		/**
		 * 设置高光贴图。
		 * @param value 高光贴图。
		 */
		public function set specularTexture(value:BaseTexture):void {
			if (value) {
				_defineDatas.add(PBRSpecularMaterial.SHADERDEFINE_SPECULARTEXTURE);
			} else {
				_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_SPECULARTEXTURE);
			}
			_shaderValues.setTexture(SPECULARTEXTURE, value);
		}
		
		/**
		 * 获取高光颜色R分量。
		 * @return 高光颜色R分量。
		 */
		public function get specularColorR():Number {
			return _SpecColorR;
		}
		
		/**
		 * 设置高光颜色R分量。
		 * @param value 高光颜色R分量。
		 */
		public function set specularColorR(value:Number):void {
			_SpecColorR = value;
		}
		
		/**
		 * 获取高光颜色G分量。
		 * @return 高光颜色G分量。
		 */
		public function get specularColorG():Number {
			return _SpecColorG;
		}
		
		/**
		 * 设置高光颜色G分量。
		 * @param value 高光颜色G分量。
		 */
		public function set specularColorG(value:Number):void {
			_SpecColorG = value;
		}
		
		/**
		 * 获取高光颜色B分量。
		 * @return 高光颜色B分量。
		 */
		public function get specularColorB():Number {
			return _SpecColorB;
		}
		
		/**
		 * 设置高光颜色B分量。
		 * @param value 高光颜色B分量。
		 */
		public function set specularColorB(value:Number):void {
			_SpecColorB = value;
		}
		
		/**
		 * 获取高光颜色A分量。
		 * @return 高光颜色A分量。
		 */
		public function get specularColorA():Number {
			return _SpecColorA;
		}
		
		/**
		 * 设置高光颜色A分量。
		 * @param value 高光颜色A分量。
		 */
		public function set specularColorA(value:Number):void {
			_SpecColorA = value;
		}
		
		/**
		 * 获取高光颜色。
		 * @return 高光颜色。
		 */
		public function get specularColor():Vector4 {
			return _shaderValues.getVector(SPECULARCOLOR) as Vector4;
		}
		
		/**
		 * 设置高光颜色。
		 * @param value 高光颜色。
		 */
		public function set specularColor(value:Vector4):void {
			_shaderValues.setVector(SPECULARCOLOR, value);
		}
		
		/**
		 * 获取光滑度。
		 * @return 光滑度,范围为0到1。
		 */
		public function get smoothness():Number {
			return _Glossiness;
		}
		
		/**
		 * 设置光滑度。
		 * @param value 光滑度,范围为0到1。
		 */
		public function set smoothness(value:Number):void {
			_Glossiness = Math.max(0.0, Math.min(1.0, value));
		}
		
		/**
		 * 获取光滑度缩放系数。
		 * @return 光滑度缩放系数,范围为0到1。
		 */
		public function get smoothnessTextureScale():Number {
			return _GlossMapScale;
		}
		
		/**
		 * 设置光滑度缩放系数。
		 * @param value 光滑度缩放系数,范围为0到1。
		 */
		public function set smoothnessTextureScale(value:Number):void {
			_GlossMapScale = Math.max(0.0, Math.min(1.0, value));
		}
		
		/**
		 * 获取光滑度数据源
		 * @return 光滑滑度数据源,0或1。
		 */
		public function get smoothnessSource():int {
			return _shaderValues.getInt(SMOOTHNESSSOURCE);
		}
		
		/**
		 * 设置光滑度数据源。
		 * @param value 光滑滑度数据源,0或1。
		 */
		public function set smoothnessSource(value:int):void {
			if (value) {
				_defineDatas.add(PBRSpecularMaterial.SHADERDEFINE_SMOOTHNESSSOURCE_ALBEDOTEXTURE_ALPHA);
				_shaderValues.setInt(SMOOTHNESSSOURCE, 1);
			} else {
				_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_SMOOTHNESSSOURCE_ALBEDOTEXTURE_ALPHA);
				_shaderValues.setInt(SMOOTHNESSSOURCE, 0);
			}
		}
		
		/**
		 * 获取是否激活放射属性。
		 * @return 是否激活放射属性。
		 */
		public function get enableEmission():Boolean {
			return _shaderValues.getBool(ENABLEEMISSION);
		}
		
		/**
		 * 设置是否激活放射属性。
		 * @param value 是否激活放射属性
		 */
		public function set enableEmission(value:Boolean):void {
			if (value)
				_defineDatas.add(PBRSpecularMaterial.SHADERDEFINE_EMISSION);
			else {
				_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_EMISSION);
			}
			_shaderValues.setBool(ENABLEEMISSION, value);
		}
		
		/**
		 * 获取放射颜色。
		 * @return 放射颜色。
		 */
		public function get emissionColor():Vector4 {
			return _shaderValues.getVector(EMISSIONCOLOR) as Vector4;
		}
		
		/**
		 * 设置放射颜色。
		 * @param value 放射颜色。
		 */
		public function set emissionColor(value:Vector4):void {
			_shaderValues.setVector(EMISSIONCOLOR, value);
		}
		
		/**
		 * 获取放射贴图。
		 * @return 放射贴图。
		 */
		public function get emissionTexture():BaseTexture {
			return _shaderValues.getTexture(EMISSIONTEXTURE);
		}
		
		/**
		 * 设置放射贴图。
		 * @param value 放射贴图。
		 */
		public function set emissionTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(PBRSpecularMaterial.SHADERDEFINE_EMISSIONTEXTURE);
			else
				_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_EMISSIONTEXTURE);
			_shaderValues.setTexture(EMISSIONTEXTURE, value);
		}
		
		/**
		 * 获取是否开启反射。
		 * @return 是否开启反射。
		 */
		public function get enableReflection():Boolean {
			return _shaderValues.getBool(ENABLEREFLECT);
		}
		
		/**
		 * 设置是否开启反射。
		 * @param value 是否开启反射。
		 */
		public function set enableReflection(value:Boolean):void {
			_shaderValues.setBool(ENABLEREFLECT, true);
			if (value)
				_disablePublicDefineDatas.remove(Scene3D.SHADERDEFINE_REFLECTMAP);
			else
				_disablePublicDefineDatas.add(Scene3D.SHADERDEFINE_REFLECTMAP);
		}
		
		/**
		 * 获取纹理平铺和偏移X分量。
		 * @return 纹理平铺和偏移X分量。
		 */
		public function get tilingOffsetX():Number {
			return _MainTex_STX;
		}
		
		/**
		 * 获取纹理平铺和偏移X分量。
		 * @param x 纹理平铺和偏移X分量。
		 */
		public function set tilingOffsetX(x:Number):void {
			_MainTex_STX = x;
		}
		
		/**
		 * 获取纹理平铺和偏移Y分量。
		 * @return 纹理平铺和偏移Y分量。
		 */
		public function get tilingOffsetY():Number {
			return _MainTex_STY;
		}
		
		/**
		 * 获取纹理平铺和偏移Y分量。
		 * @param y 纹理平铺和偏移Y分量。
		 */
		public function set tilingOffsetY(y:Number):void {
			_MainTex_STY = y;
		}
		
		/**
		 * 获取纹理平铺和偏移Z分量。
		 * @return 纹理平铺和偏移Z分量。
		 */
		public function get tilingOffsetZ():Number {
			return _MainTex_STZ;
		}
		
		/**
		 * 获取纹理平铺和偏移Z分量。
		 * @param z 纹理平铺和偏移Z分量。
		 */
		public function set tilingOffsetZ(z:Number):void {
			_MainTex_STZ = z;
		}
		
		/**
		 * 获取纹理平铺和偏移W分量。
		 * @return 纹理平铺和偏移W分量。
		 */
		public function get tilingOffsetW():Number {
			return _MainTex_STW;
		}
		
		/**
		 * 获取纹理平铺和偏移W分量。
		 * @param w 纹理平铺和偏移W分量。
		 */
		public function set tilingOffsetW(w:Number):void {
			_MainTex_STW = w;
		}
		
		/**
		 * 获取纹理平铺和偏移。
		 * @return 纹理平铺和偏移。
		 */
		public function get tilingOffset():Vector4 {
			return _shaderValues.getVector(TILINGOFFSET) as Vector4;
		}
		
		/**
		 * 获取纹理平铺和偏移。
		 * @param value 纹理平铺和偏移。
		 */
		public function set tilingOffset(value:Vector4):void {
			if (value) {
				if (value.x != 1 || value.y != 1 || value.z != 0 || value.w != 0)
					_defineDatas.add(PBRSpecularMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_defineDatas.remove(PBRSpecularMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_shaderValues.setVector(TILINGOFFSET, value);
		}
		
		/**
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			switch (value) {
			case RENDERMODE_OPAQUE: 
				alphaTest = false;
				renderQueue = BaseMaterial.RENDERQUEUE_OPAQUE;
				depthWrite = true;
				cull = RenderState.CULL_BACK;
				blend = RenderState.BLEND_DISABLE;
				depthTest = RenderState.DEPTHTEST_LESS;
				_defineDatas.remove(SHADERDEFINE_ALPHAPREMULTIPLY);
				break;
			case RENDERMODE_CUTOUT: 
				renderQueue = BaseMaterial.RENDERQUEUE_ALPHATEST;
				alphaTest = true;
				depthWrite = true;
				cull = RenderState.CULL_BACK;
				blend = RenderState.BLEND_DISABLE;
				depthTest = RenderState.DEPTHTEST_LESS;
				_defineDatas.remove(SHADERDEFINE_ALPHAPREMULTIPLY);
				break;
			case RENDERMODE_FADE: 
				renderQueue = BaseMaterial.RENDERQUEUE_TRANSPARENT;
				alphaTest = false;
				depthWrite = false;
				cull = RenderState.CULL_BACK;
				blend = RenderState.BLEND_ENABLE_ALL;
				blendSrc = RenderState.BLENDPARAM_SRC_ALPHA;
				blendDst	= RenderState.BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				depthTest = RenderState.DEPTHTEST_LESS;
				_defineDatas.remove(SHADERDEFINE_ALPHAPREMULTIPLY);
				break;
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = BaseMaterial.RENDERQUEUE_TRANSPARENT;
				alphaTest = false;
				depthWrite = false;
				cull = RenderState.CULL_BACK;
				blend = RenderState.BLEND_ENABLE_ALL;
				blendSrc = RenderState.BLENDPARAM_ONE;
				blendDst = RenderState.BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				depthTest = RenderState.DEPTHTEST_LESS;
				_defineDatas.add(SHADERDEFINE_ALPHAPREMULTIPLY);
				break;
			default: 
				throw new Error("PBRSpecularMaterial : renderMode value error.");
			}
		}
		
		/**
		 * 设置是否写入深度。
		 * @param value 是否写入深度。
		 */
		public function set depthWrite(value:Boolean):void {
			_shaderValues.setBool(DEPTH_WRITE, value);
		}
		
		/**
		 * 获取是否写入深度。
		 * @return 是否写入深度。
		 */
		public function get depthWrite():Boolean {
			return _shaderValues.getBool(DEPTH_WRITE);
		}
		
		/**
		 * 设置剔除方式。
		 * @param value 剔除方式。
		 */
		public function set cull(value:int):void {
			_shaderValues.setInt(CULL, value);
		}
		
		/**
		 * 获取剔除方式。
		 * @return 剔除方式。
		 */
		public function get cull():int {
			return _shaderValues.getInt(CULL);
		}
		
		/**
		 * 设置混合方式。
		 * @param value 混合方式。
		 */
		public function set blend(value:int):void {
			_shaderValues.setInt(BLEND, value);
		}
		
		/**
		 * 获取混合方式。
		 * @return 混合方式。
		 */
		public function get blend():int {
			return _shaderValues.getInt(BLEND);
		}
		
		/**
		 * 设置混合源。
		 * @param value 混合源
		 */
		public function set blendSrc(value:int):void {
			_shaderValues.setInt(BLEND_SRC, value);
		}
		
		/**
		 * 获取混合源。
		 * @return 混合源。
		 */
		public function get blendSrc():int {
			return _shaderValues.getInt(BLEND_SRC);
		}
		
		/**
		 * 设置混合目标。
		 * @param value 混合目标
		 */
		public function set blendDst(value:int):void {
			_shaderValues.setInt(BLEND_DST, value);
		}
		
		/**
		 * 获取混合目标。
		 * @return 混合目标。
		 */
		public function get blendDst():int {
			return _shaderValues.getInt(BLEND_DST);
		}
		
		/**
		 * 设置深度测试方式。
		 * @param value 深度测试方式
		 */
		public function set depthTest(value:int):void {
			_shaderValues.setInt(DEPTH_TEST, value);
		}
		
		/**
		 * 获取深度测试方式。
		 * @return 深度测试方式。
		 */
		public function get depthTest():int {
			return _shaderValues.getInt(DEPTH_TEST);
		}
		
		/**
		 * 创建一个 <code>PBRSpecularMaterial</code> 实例。
		 */
		public function PBRSpecularMaterial() {
			super();
			setShaderName("PBRSpecular");
			_albedoColor = new Vector4(1.0, 1.0, 1.0, 1.0);
			_shaderValues.setVector(ALBEDOCOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
			_emissionColor = new Vector4(0.0, 0.0, 0.0, 0.0);
			_shaderValues.setVector(EMISSIONCOLOR, new Vector4(0.0, 0.0, 0.0, 0.0));
			_specularColor = new Vector4(0.2, 0.2, 0.2, 0.2);
			_shaderValues.setVector(SPECULARCOLOR, new Vector4(0.2, 0.2, 0.2, 0.2));
			_shaderValues.setNumber(SMOOTHNESS, 0.5);
			_shaderValues.setNumber(SMOOTHNESSSCALE, 1.0);
			_shaderValues.setNumber(SMOOTHNESSSOURCE, 0);
			_shaderValues.setNumber(OCCLUSIONSTRENGTH, 1.0);
			_shaderValues.setNumber(NORMALSCALE, 1.0);
			_shaderValues.setNumber(PARALLAXSCALE, 0.001);
			_shaderValues.setBool(ENABLEEMISSION, false);
			_shaderValues.setNumber(ALPHATESTVALUE, 0.5);
			renderMode = RENDERMODE_OPAQUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destMaterial:PBRSpecularMaterial = destObject as PBRSpecularMaterial;
			_albedoColor.cloneTo(destMaterial._albedoColor);
			_specularColor.cloneTo(destMaterial._specularColor);
			_emissionColor.cloneTo(destMaterial._emissionColor);
		}
	}

}