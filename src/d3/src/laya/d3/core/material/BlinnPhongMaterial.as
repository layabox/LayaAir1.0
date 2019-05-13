package laya.d3.core.material {
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderData;
	import laya.d3.shader.ShaderDefines;
	import laya.webgl.resource.BaseTexture;
	
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
		/**渲染状态_阿尔法测试。*/
		public static const RENDERMODE_CUTOUT:int = 1;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 2;
		
		public static var SHADERDEFINE_DIFFUSEMAP:int;
		public static var SHADERDEFINE_NORMALMAP:int;
		public static var SHADERDEFINE_SPECULARMAP:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		public static var SHADERDEFINE_ENABLEVERTEXCOLOR:int;
		
		public static const ALBEDOTEXTURE:int = Shader3D.propertyNameToID("u_DiffuseTexture");
		public static const NORMALTEXTURE:int = Shader3D.propertyNameToID("u_NormalTexture");
		public static const SPECULARTEXTURE:int = Shader3D.propertyNameToID("u_SpecularTexture");
		public static const ALBEDOCOLOR:int = Shader3D.propertyNameToID("u_DiffuseColor");
		public static const MATERIALSPECULAR:int = Shader3D.propertyNameToID("u_MaterialSpecular");
		public static const SHININESS:int = Shader3D.propertyNameToID("u_Shininess");
		public static const TILINGOFFSET:int = Shader3D.propertyNameToID("u_TilingOffset");
		public static const CULL:int = Shader3D.propertyNameToID("s_Cull");
		public static const BLEND:int = Shader3D.propertyNameToID("s_Blend");
		public static const BLEND_SRC:int = Shader3D.propertyNameToID("s_BlendSrc");
		public static const BLEND_DST:int = Shader3D.propertyNameToID("s_BlendDst");
		public static const DEPTH_TEST:int = Shader3D.propertyNameToID("s_DepthTest");
		public static const DEPTH_WRITE:int = Shader3D.propertyNameToID("s_DepthWrite");
		
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
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
			SHADERDEFINE_ENABLEVERTEXCOLOR = shaderDefines.registerDefine("ENABLEVERTEXCOLOR");
		}
		
		/**@private */
		private var _albedoColor:Vector4;
		/**@private */
		private var _albedoIntensity:Number;
		/**@private */
		private var _enableLighting:Boolean;
		/**@private */
		private var _enableVertexColor:Boolean = false;
		
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
		
		/**@private */
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
			return _shaderValues.getVector(MATERIALSPECULAR).x;
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorR(value:Number):void {
			_shaderValues.getVector(MATERIALSPECULAR).x = value;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorG():Number {
			return _shaderValues.getVector(MATERIALSPECULAR).y;
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorG(value:Number):void {
			_shaderValues.getVector(MATERIALSPECULAR).y = value;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorB():Number {
			return _shaderValues.getVector(MATERIALSPECULAR).z;
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorB(value:Number):void {
			_shaderValues.getVector(MATERIALSPECULAR).z = value;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorA():Number {
			return _shaderValues.getVector(MATERIALSPECULAR).w;
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorA(value:Number):void {
			_shaderValues.getVector(MATERIALSPECULAR).w = value;
		}
		
		/**
		 * @private
		 */
		public function get _AlbedoIntensity():Number {
			return _albedoIntensity;
		}
		
		/**
		 * @private
		 */
		public function set _AlbedoIntensity(value:Number):void {
			if (_albedoIntensity !== value) {
				var finalAlbedo:Vector4 = _shaderValues.getVector(ALBEDOCOLOR) as Vector4;
				Vector4.scale(_albedoColor, value, finalAlbedo);
				_albedoIntensity = value;
				_shaderValues.setVector(ALBEDOCOLOR, finalAlbedo);//修改值后必须调用此接口,否则NATIVE不生效
			}
		}
		
		/**
		 * @private
		 */
		public function get _Shininess():Number {
			return _shaderValues.getNumber(SHININESS);
		}
		
		/**
		 * @private
		 */
		public function set _Shininess(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_shaderValues.setNumber(SHININESS, value);
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
				break;
			case RENDERMODE_CUTOUT: 
				renderQueue = BaseMaterial.RENDERQUEUE_ALPHATEST;
				alphaTest = true;
				depthWrite = true;
				cull = RenderState.CULL_BACK;
				blend = RenderState.BLEND_DISABLE;
				depthTest = RenderState.DEPTHTEST_LESS;
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = BaseMaterial.RENDERQUEUE_TRANSPARENT;
				alphaTest = false;
				depthWrite = false;
				cull = RenderState.CULL_BACK;
				blend = RenderState.BLEND_ENABLE_ALL;
				blendSrc = RenderState.BLENDPARAM_SRC_ALPHA;
				blendDst = RenderState.BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				depthTest = RenderState.DEPTHTEST_LESS;
				break;
			default: 
				throw new Error("Material:renderMode value error.");
			}
		}
		
		/**
		 * 获取是否支持顶点色。
		 * @return  是否支持顶点色。
		 */
		public function get enableVertexColor():Boolean {
			return _enableVertexColor;
		}
		
		/**
		 * 设置是否支持顶点色。
		 * @param value  是否支持顶点色。
		 */
		public function set enableVertexColor(value:Boolean):void {
			_enableVertexColor = value;
			if (value)
				_defineDatas.add(BlinnPhongMaterial.SHADERDEFINE_ENABLEVERTEXCOLOR);
			else
				_defineDatas.remove(BlinnPhongMaterial.SHADERDEFINE_ENABLEVERTEXCOLOR);
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
					_defineDatas.add(BlinnPhongMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_defineDatas.remove(BlinnPhongMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_defineDatas.remove(BlinnPhongMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_shaderValues.setVector(TILINGOFFSET, value);
		}
		
		/**
		 * 获取反照率颜色R分量。
		 * @return 反照率颜色R分量。
		 */
		public function get albedoColorR():Number {
			return _ColorR;
		}
		
		/**
		 * 设置反照率颜色R分量。
		 * @param value 反照率颜色R分量。
		 */
		public function set albedoColorR(value:Number):void {
			_ColorR = value;
		}
		
		/**
		 * 获取反照率颜色G分量。
		 * @return 反照率颜色G分量。
		 */
		public function get albedoColorG():Number {
			return _ColorG;
		}
		
		/**
		 * 设置反照率颜色G分量。
		 * @param value 反照率颜色G分量。
		 */
		public function set albedoColorG(value:Number):void {
			_ColorG = value;
		}
		
		/**
		 * 获取反照率颜色B分量。
		 * @return 反照率颜色B分量。
		 */
		public function get albedoColorB():Number {
			return _ColorB;
		}
		
		/**
		 * 设置反照率颜色B分量。
		 * @param value 反照率颜色B分量。
		 */
		public function set albedoColorB(value:Number):void {
			_ColorB = value;
		}
		
		/**
		 * 获取反照率颜色Z分量。
		 * @return 反照率颜色Z分量。
		 */
		public function get albedoColorA():Number {
			return _ColorA;
		}
		
		/**
		 * 设置反照率颜色alpha分量。
		 * @param value 反照率颜色alpha分量。
		 */
		public function set albedoColorA(value:Number):void {
			_ColorA = value;
		}
		
		/**
		 * 获取反照率颜色。
		 * @return 反照率颜色。
		 */
		public function get albedoColor():Vector4 {
			return _albedoColor;
		}
		
		/**
		 * 设置反照率颜色。
		 * @param value 反照率颜色。
		 */
		public function set albedoColor(value:Vector4):void {
			var finalAlbedo:Vector4 = _shaderValues.getVector(ALBEDOCOLOR) as Vector4;
			Vector4.scale(value, _albedoIntensity, finalAlbedo);
			_albedoColor = value;
			_shaderValues.setVector(ALBEDOCOLOR, finalAlbedo);//修改值后必须调用此接口,否则NATIVE不生效
		}
		
		/**
		 * 获取反照率强度。
		 * @return 反照率强度。
		 */
		public function get albedoIntensity():Number {
			return _albedoIntensity;
		}
		
		/**
		 * 设置反照率强度。
		 * @param value 反照率强度。
		 */
		public function set albedoIntensity(value:Number):void {
			_AlbedoIntensity = value;
		}
		
		/**
		 * 获取高光颜色R轴分量。
		 * @return 高光颜色R轴分量。
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
			return _shaderValues.getVector(MATERIALSPECULAR) as Vector4;
		}
		
		/**
		 * 设置高光颜色。
		 * @param value 高光颜色。
		 */
		public function set specularColor(value:Vector4):void {
			_shaderValues.setVector(MATERIALSPECULAR, value);
		}
		
		/**
		 * 获取高光强度,范围为0到1。
		 * @return 高光强度。
		 */
		public function get shininess():Number {
			return _Shininess;
		}
		
		/**
		 * 设置高光强度,范围为0到1。
		 * @param value 高光强度。
		 */
		public function set shininess(value:Number):void {
			_Shininess = value;
		}
		
		/**
		 * 获取反照率贴图。
		 * @return 反照率贴图。
		 */
		public function get albedoTexture():BaseTexture {
			return _shaderValues.getTexture(ALBEDOTEXTURE);
		}
		
		/**
		 * 设置反照率贴图。
		 * @param value 反照率贴图。
		 */
		public function set albedoTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(BlinnPhongMaterial.SHADERDEFINE_DIFFUSEMAP);
			else
				_defineDatas.remove(BlinnPhongMaterial.SHADERDEFINE_DIFFUSEMAP);
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
			if (value)
				_defineDatas.add(BlinnPhongMaterial.SHADERDEFINE_NORMALMAP);
			else
				_defineDatas.remove(BlinnPhongMaterial.SHADERDEFINE_NORMALMAP);
			_shaderValues.setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取高光贴图。
		 * @return 高光贴图。
		 */
		public function get specularTexture():BaseTexture {
			return _shaderValues.getTexture(SPECULARTEXTURE);
		}
		
		/**
		 * 设置高光贴图，高光强度则从该贴图RGB值中获取,如果该值为空则从漫反射贴图的Alpha通道获取。
		 * @param value  高光贴图。
		 */
		public function set specularTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(BlinnPhongMaterial.SHADERDEFINE_SPECULARMAP);
			else
				_defineDatas.remove(BlinnPhongMaterial.SHADERDEFINE_SPECULARMAP);
			
			_shaderValues.setTexture(SPECULARTEXTURE, value);
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
					_disablePublicDefineDatas.remove(Scene3D.SHADERDEFINE_POINTLIGHT | Scene3D.SHADERDEFINE_SPOTLIGHT | Scene3D.SHADERDEFINE_DIRECTIONLIGHT);
				else
					_disablePublicDefineDatas.add(Scene3D.SHADERDEFINE_POINTLIGHT | Scene3D.SHADERDEFINE_SPOTLIGHT | Scene3D.SHADERDEFINE_DIRECTIONLIGHT);
				_enableLighting = value;
			}
		}
		
		/**
		 * 禁用雾化。
		 */
		public function disableFog():void {
			_disablePublicDefineDatas.add(Scene3D.SHADERDEFINE_FOG);
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
		 * 创建一个 <code>BlinnPhongMaterial</code> 实例。
		 */
		public function BlinnPhongMaterial() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			setShaderName("BLINNPHONG");
			_albedoIntensity = 1.0;
			_albedoColor = new Vector4(1.0, 1.0, 1.0, 1.0);
			var sv:ShaderData = _shaderValues;
			sv.setVector(ALBEDOCOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
			sv.setVector(MATERIALSPECULAR, new Vector4(1.0, 1.0, 1.0, 1.0));
			sv.setNumber(SHININESS, 0.078125);
			sv.setNumber(ALPHATESTVALUE, 0.5);
			sv.setVector(TILINGOFFSET, new Vector4(1.0, 1.0, 0.0, 0.0));
			_enableLighting = true;
			renderMode = RENDERMODE_OPAQUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destMaterial:BlinnPhongMaterial = destObject as BlinnPhongMaterial;
			destMaterial._enableLighting = _enableLighting;
			destMaterial._albedoIntensity = _albedoIntensity;
			destMaterial._enableVertexColor = _enableVertexColor;
			_albedoColor.cloneTo(destMaterial._albedoColor);
		}
	}

}