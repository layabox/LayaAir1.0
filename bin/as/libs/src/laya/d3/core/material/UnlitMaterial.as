package laya.d3.core.material {
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderData;
	import laya.d3.shader.ShaderDefines;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * <code>UnlitMaterial</code> 类用于实现不受光照影响的材质。
	 */
	public class UnlitMaterial extends BaseMaterial {
		
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 0;
		/**渲染状态_阿尔法测试。*/
		public static const RENDERMODE_CUTOUT:int = 1;
		/**渲染状态__透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 2;
		/**渲染状态__加色法混合。*/
		public static const RENDERMODE_ADDTIVE:int = 3;
		
		public static var SHADERDEFINE_ALBEDOTEXTURE:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		public static var SHADERDEFINE_ENABLEVERTEXCOLOR:int;
		
		public static const ALBEDOTEXTURE:int = Shader3D.propertyNameToID("u_AlbedoTexture");
		public static const ALBEDOCOLOR:int = Shader3D.propertyNameToID("u_AlbedoColor");
		public static const TILINGOFFSET:int = Shader3D.propertyNameToID("u_TilingOffset");
		public static const CULL:int = Shader3D.propertyNameToID("s_Cull");
		public static const BLEND:int = Shader3D.propertyNameToID("s_Blend");
		public static const BLEND_SRC:int = Shader3D.propertyNameToID("s_BlendSrc");
		public static const BLEND_DST:int = Shader3D.propertyNameToID("s_BlendDst");
		public static const DEPTH_TEST:int = Shader3D.propertyNameToID("s_DepthTest");
		public static const DEPTH_WRITE:int = Shader3D.propertyNameToID("s_DepthWrite");
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:UnlitMaterial = new UnlitMaterial();
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_ALBEDOTEXTURE = shaderDefines.registerDefine("ALBEDOTEXTURE");
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
			SHADERDEFINE_ENABLEVERTEXCOLOR = shaderDefines.registerDefine("ENABLEVERTEXCOLOR");
		}
		
		/**@private */
		private var _albedoColor:Vector4 = new Vector4(1.0, 1.0, 1.0, 1.0);
		/**@private */
		private var _albedoIntensity:Number = 1.0;
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
				_shaderValues.setVector(ALBEDOCOLOR, finalAlbedo);
			}
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
			_shaderValues.setVector(ALBEDOCOLOR, finalAlbedo);
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
				_defineDatas.add(UnlitMaterial.SHADERDEFINE_ALBEDOTEXTURE);
			else
				_defineDatas.remove(UnlitMaterial.SHADERDEFINE_ALBEDOTEXTURE);
			_shaderValues.setTexture(ALBEDOTEXTURE, value);
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
					_defineDatas.add(UnlitMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_defineDatas.remove(UnlitMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_defineDatas.remove(UnlitMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_shaderValues.setVector(TILINGOFFSET, value);
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
				_defineDatas.add(UnlitMaterial.SHADERDEFINE_ENABLEVERTEXCOLOR);
			else
				_defineDatas.remove(UnlitMaterial.SHADERDEFINE_ENABLEVERTEXCOLOR);
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
				throw new Error("UnlitMaterial : renderMode value error.");
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
		
		public function UnlitMaterial() {
			super();
			setShaderName("Unlit");
			_shaderValues.setVector(ALBEDOCOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
			renderMode = RENDERMODE_OPAQUE;
		}
	}
}