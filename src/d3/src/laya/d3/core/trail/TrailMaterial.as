package laya.d3.core.trail {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.RenderState;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderDefines;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * <code>TrailMaterial</code> 类用于实现拖尾材质。
	 */
	public class TrailMaterial extends BaseMaterial {
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_ALPHABLENDED:int = 0;
		/**渲染状态_加色法混合。*/
		public static const RENDERMODE_ADDTIVE:int = 1;
		
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:TrailMaterial = new TrailMaterial();
		
		public static var SHADERDEFINE_MAINTEXTURE:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		public static var SHADERDEFINE_ADDTIVEFOG:int;
		
		public static const MAINTEXTURE:int = Shader3D.propertyNameToID("u_MainTexture");
		public static const TINTCOLOR:int =Shader3D.propertyNameToID("u_MainColor");
		public static const TILINGOFFSET:int =Shader3D.propertyNameToID("u_TilingOffset");
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_MAINTEXTURE = shaderDefines.registerDefine("MAINTEXTURE");
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
			SHADERDEFINE_ADDTIVEFOG = shaderDefines.registerDefine("ADDTIVEFOG");
		}
		
		/**@private */
		private var _color:Vector4;
		
		/**
		 * @private
		 */
		public function get _TintColorR():Number {
			return _color.x;
		}
		
		/**
		 * @private
		 */
		public function set _TintColorR(value:Number):void {
			_color.x = value;
			color = _color;
		}
		
		/**
		 * @private
		 */
		public function get _TintColorG():Number {
			return _color.y;
		}
		
		/**
		 * @private
		 */
		public function set _TintColorG(value:Number):void {
			_color.y = value;
			color = _color;
		}
		
		/**
		 * @private
		 */
		public function get _TintColorB():Number {
			return _color.z;
		}
		
		/**
		 * @private
		 */
		public function set _TintColorB(value:Number):void {
			_color.z = value;
			color = _color;
		}
		
		/**@private */
		public function get _TintColorA():Number {
			return _color.w;
		}
		
		/**
		 * @private
		 */
		public function set _TintColorA(value:Number):void {
			_color.w = value;
			color = _color;
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
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			var renderState:RenderState = getRenderState();
			switch (value) {
				case RENDERMODE_ADDTIVE: 
					renderQueue = BaseMaterial.RENDERQUEUE_TRANSPARENT;
					alphaTest = false;
					renderState.depthWrite = false;
					renderState.cull = RenderState.CULL_NONE;
					renderState.blend = RenderState.BLEND_ENABLE_ALL;
					renderState.srcBlend = RenderState.BLENDPARAM_SRC_ALPHA;
					renderState.dstBlend = RenderState.BLENDPARAM_ONE;
					renderState.depthTest = RenderState.DEPTHTEST_LESS;
					_defineDatas.add(SHADERDEFINE_ADDTIVEFOG);
					break;
				case RENDERMODE_ALPHABLENDED: 
					renderQueue = BaseMaterial.RENDERQUEUE_TRANSPARENT;
					alphaTest = false;
					renderState.depthWrite = false;
					renderState.cull = RenderState.CULL_NONE;
					renderState.blend = RenderState.BLEND_ENABLE_ALL;
					renderState.srcBlend = RenderState.BLENDPARAM_SRC_ALPHA;
					renderState.dstBlend = RenderState.BLENDPARAM_ONE_MINUS_SRC_ALPHA;
					renderState.depthTest = RenderState.DEPTHTEST_LESS;
					_defineDatas.remove(SHADERDEFINE_ADDTIVEFOG);
					break;
				default: 
					throw new Error("TrailMaterial : renderMode value error.");
			}
		}
		
		/**
		 * 获取颜色R分量。
		 * @return 颜色R分量。
		 */
		public function get colorR():Number {
			return _TintColorR;
		}
		
		/**
		 * 设置颜色R分量。
		 * @param value 颜色R分量。
		 */
		public function set colorR(value:Number):void {
			_TintColorR = value;
		}
		
		/**
		 * 获取颜色G分量。
		 * @return 颜色G分量。
		 */
		public function get colorG():Number {
			return _TintColorG;
		}
		
		/**
		 * 设置颜色G分量。
		 * @param value 颜色G分量。
		 */
		public function set colorG(value:Number):void {
			_TintColorG = value;
		}
		
		/**
		 * 获取颜色B分量。
		 * @return 颜色B分量。
		 */
		public function get colorB():Number {
			return _TintColorB;
		}
		
		/**
		 * 设置颜色B分量。
		 * @param value 颜色B分量。
		 */
		public function set colorB(value:Number):void {
			_TintColorB = value;
		}
		
		/**
		 * 获取颜色Z分量。
		 * @return 颜色Z分量。
		 */
		public function get colorA():Number {
			return _TintColorA;
		}
		
		/**
		 * 设置颜色alpha分量。
		 * @param value 颜色alpha分量。
		 */
		public function set colorA(value:Number):void {
			_TintColorA = value;
		}
		
		/**
		 * 获取颜色。
		 * @return 颜色。
		 */
		public function get color():Vector4 {
			return _shaderValues.getVector(TINTCOLOR) as Vector4;
		}
		
		/**
		 * 设置颜色。
		 * @param value 颜色。
		 */
		public function set color(value:Vector4):void {
			_shaderValues.setVector(TINTCOLOR, value);
		}
		
		/**
		 * 获取贴图。
		 * @return 贴图。
		 */
		public function get texture():BaseTexture {
			return _shaderValues.getTexture(MAINTEXTURE);
		}
		
		/**
		 * 设置贴图。
		 * @param value 贴图。
		 */
		public function set texture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(TrailMaterial.SHADERDEFINE_MAINTEXTURE);
			else
				_defineDatas.remove(TrailMaterial.SHADERDEFINE_MAINTEXTURE);
			_shaderValues.setTexture(MAINTEXTURE, value);
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
		 * 设置纹理平铺和偏移。
		 * @param value 纹理平铺和偏移。
		 */
		public function set tilingOffset(value:Vector4):void {
			if (value) {
				if (value.x != 1 || value.y != 1 || value.z != 0 || value.w != 0)
					_defineDatas.add(TrailMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_defineDatas.remove(TrailMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_defineDatas.remove(TrailMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_shaderValues.setVector(TILINGOFFSET, value);
		}
		
		public function TrailMaterial() {
			super();
			setShaderName("Trail");
			_color = new Vector4(1.0, 1.0, 1.0, 1.0);
			_shaderValues.setVector(TINTCOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
			renderMode = RENDERMODE_ALPHABLENDED;
		}
	}
}