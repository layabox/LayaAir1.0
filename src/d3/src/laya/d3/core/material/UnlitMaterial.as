package laya.d3.core.material {
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
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
			return _albedoColor.elements[0];
		}
		
		/**
		 * @private
		 */
		public function set _ColorR(value:Number):void {
			_albedoColor.elements[0] = value;
			albedoColor = _albedoColor;
		}
		
		/**
		 * @private
		 */
		public function get _ColorG():Number {
			return _albedoColor.elements[1];
		}
		
		/**
		 * @private
		 */
		public function set _ColorG(value:Number):void {
			_albedoColor.elements[1] = value;
			albedoColor = _albedoColor;
		}
		
		/**
		 * @private
		 */
		public function get _ColorB():Number {
			return _albedoColor.elements[2];
		}
		
		/**
		 * @private
		 */
		public function set _ColorB(value:Number):void {
			_albedoColor.elements[2] = value;
			albedoColor = _albedoColor;
		}
		
		/**@private */
		public function get _ColorA():Number {
			return _albedoColor.elements[3];
		}
		
		/**
		 * @private
		 */
		public function set _ColorA(value:Number):void {
			_albedoColor.elements[3] = value;
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
			return _shaderValues.getVector(TILINGOFFSET).elements[0];
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STX(x:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.elements[0] = x;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STY():Number {
			return _shaderValues.getVector(TILINGOFFSET).elements[1];
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STY(y:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.elements[1] = y;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STZ():Number {
			return _shaderValues.getVector(TILINGOFFSET).elements[2];
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STZ(z:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.elements[2] = z;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STW():Number {
			return _shaderValues.getVector(TILINGOFFSET).elements[3];
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STW(w:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.elements[3] = w;
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
				var valueE:Float32Array = value.elements;
				if (valueE[0] != 1 || valueE[1] != 1 || valueE[2] != 0 || valueE[3] != 0)
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
			var renderState:RenderState = getRenderState();
			switch (value) {
			case RENDERMODE_OPAQUE: 
				alphaTest = false;
				renderQueue = BaseMaterial.RENDERQUEUE_OPAQUE;
				renderState.depthWrite = true;
				renderState.cull = RenderState.CULL_BACK;
				renderState.blend = RenderState.BLEND_DISABLE;
				renderState.depthTest = RenderState.DEPTHTEST_LESS;
				break;
			case RENDERMODE_CUTOUT: 
				renderQueue = BaseMaterial.RENDERQUEUE_ALPHATEST;
				alphaTest = true;
				renderState.depthWrite = true;
				renderState.cull = RenderState.CULL_BACK;
				renderState.blend = RenderState.BLEND_DISABLE;
				renderState.depthTest = RenderState.DEPTHTEST_LESS;
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = BaseMaterial.RENDERQUEUE_TRANSPARENT;
				alphaTest = false;
				renderState.depthWrite = false;
				renderState.cull = RenderState.CULL_BACK;
				renderState.blend = RenderState.BLEND_ENABLE_ALL;
				renderState.srcBlend = RenderState.BLENDPARAM_SRC_ALPHA;
				renderState.dstBlend = RenderState.BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				renderState.depthTest = RenderState.DEPTHTEST_LESS;
				break;
			default: 
				throw new Error("UnlitMaterial : renderMode value error.");
			}
		}
		
		public function UnlitMaterial() {
			super();
			setShaderName("Unlit");
			_shaderValues.setVector(ALBEDOCOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
		}
	}
}