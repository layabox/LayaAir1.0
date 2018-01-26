package laya.d3.core.material {
	import laya.d3.core.render.RenderQueue;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines;
	
	public class WaterMaterial extends BaseMaterial {
		public static const DIFFUSETEXTURE:int = 1;
		public static const NORMALTEXTURE:int = 2;
		public static const UNDERWATERTEXTURE:int = 3;
		public static const VERTEXDISPTEXTURE:int = 4;
		public static const UVANIAGE:int = 5;
		public static const UVMATRIX:int = 6;
		public static const UVAGE:int = 7;
		public static const CURTM:int = 8;
		public static const DETAILTEXTURE:int = 9;
		public static const DEEPCOLORTEXTURE:int = 10;
		public static const SKYTEXTURE:int = 11;
		public static const WAVEINFO:int = 12;
		public static const WAVEINFOD:int = 13;
		public static const WAVEMAINDIR:int = 14;
		public static const SCRSIZE:int = 15;
		public static const WATERINFO:int = 16;
		public static const FOAMTEXTURE:int = 17;
		public static const GEOWAVE_UV_SCALE:int = 18;
		public static const SEA_COLOR:int = 19;
		public static const WAVEINFODEEPSCALE:int = 20;
		
		public static var SHADERDEFINE_SHOW_NORMAL:int = 0;
		public static var SHADERDEFINE_CUBE_ENV:int = 0;
		public static var SHADERDEFINE_HDR_ENV:int = 0;
		public static var SHADERDEFINE_USE_FOAM:int = 0;
		public static var SHADERDEFINE_USE_REFRACT_TEX:int = 0;
		/**
		 * 如果定义了这个宏，就不再使用深度纹理，可以提高速度，但是建模麻烦一些。
		 */
		public static var SHADERDEFINE_USEVERTEXHEIGHT:int = 0;
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
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:WaterMaterial = new WaterMaterial();
		
		private var _useVertexDeep:Boolean = false;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_CUBE_ENV = shaderDefines.registerDefine("CUBE_ENV");
			SHADERDEFINE_HDR_ENV = shaderDefines.registerDefine("HDR_ENV");
			SHADERDEFINE_SHOW_NORMAL = shaderDefines.registerDefine("SHOW_NORMAL");
			SHADERDEFINE_USEVERTEXHEIGHT = shaderDefines.registerDefine("USE_VERTEX_DEEPINFO");
			SHADERDEFINE_USE_FOAM = shaderDefines.registerDefine("USE_FOAM");
			SHADERDEFINE_USE_REFRACT_TEX = shaderDefines.registerDefine("USE_REFR_TEX");
		}
		
		/**
		 * 加载标准材质。
		 * @param url 标准材质地址。
		 */
		public static function load(url:String):WaterMaterial {
			return Laya.loader.create(url, null, null, WaterMaterial);
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
			_setTexture(NORMALTEXTURE, value);
		}
		
		public function set underWaterTexture(value:BaseTexture):void {
			_setTexture(UNDERWATERTEXTURE, value);
		}
		
		public function get underWaterTexture():BaseTexture {
			return _getTexture(UNDERWATERTEXTURE);
		}
		
		public function get skyTexture():BaseTexture {
			return _getTexture(SKYTEXTURE);
		}
		
		public function set skyTexture(v:BaseTexture):void {
			_setTexture(SKYTEXTURE, v);
		}
		
		public function get waterInfoTexture():BaseTexture {
			return _getTexture(WATERINFO);
		}
		
		public function set waterInfoTexture(v:BaseTexture):void {
			_setTexture(WATERINFO, v);
		}
		
		public function get foamTexture():BaseTexture {
			return _getTexture(FOAMTEXTURE);
		}
		
		public function set foamTexture(v:BaseTexture):void {
			_setTexture(FOAMTEXTURE, v);
		}
		
		/**
		 * 对定点进行变换的纹理。现在不用
		 */
		public function set vertexDispTexture(value:BaseTexture):void {
			_setTexture(VERTEXDISPTEXTURE, value);
		}
		
		public function get vertexDispTexture():BaseTexture {
			return _getTexture(VERTEXDISPTEXTURE);
		}
		
		public function set detailTexture(value:BaseTexture):void {
			_setTexture(DETAILTEXTURE, value);
		}
		
		public function get detailTexture():BaseTexture {
			return _getTexture(DETAILTEXTURE);
		}
		
		public function get deepColorTexture():BaseTexture {
			return _getTexture(DEEPCOLORTEXTURE);
		}
		
		public function set deepColorTexture(v:BaseTexture):void {
			_setTexture(DEEPCOLORTEXTURE, v);
		}
		
		public function get currentTm():Number {
			return _getNumber(CURTM);
		}
		
		public function set currentTm(v:Number):void {
			_setNumber(CURTM, v);
		}
		
		public function get waveInfo():Float32Array {
			return _getBuffer(WAVEINFO);
		}
		
		public function set waveInfo(v:Float32Array):void {
			_setBuffer(WAVEINFO, v);
		}
		
		public function get waveInfoD():Float32Array {
			return _getBuffer(WAVEINFOD);
		}
		
		public function set waveInfoD(v:Float32Array):void {
			_setBuffer(WAVEINFOD, v);
		}
		
		public function set waveMainDir(deg:Number):void {
			_setNumber(WAVEMAINDIR, deg * Math.PI / 180);
		}
		
		public function get waveMainDir():Number {
			return _getNumber(WAVEMAINDIR);
		}
		
		public function set deepScale(v:Number):void {
			_setNumber(WAVEINFODEEPSCALE, v);
		}
		
		public function get deepScale():Number {
			return _getNumber(WAVEINFODEEPSCALE);
		}
		
		public function get geoWaveUVScale():Number {
			return _getNumber(GEOWAVE_UV_SCALE);
		}
		
		public function set geoWaveUVScale(v:Number):void {
			_setNumber(GEOWAVE_UV_SCALE, v);
		}
		
		public function set scrsize(v:Float32Array):void {
			_setBuffer(SCRSIZE, v);
		}
		
		public function get seaColor():Float32Array {
			return _getBuffer(SEA_COLOR);
		}
		
		public function set seaColor(v:Float32Array):void {
			_setBuffer(SEA_COLOR, v);
		}
		
		public function set useVertexDeep(v:Boolean):void {
			_useVertexDeep = v;
			if (v)
				_addShaderDefine(SHADERDEFINE_USEVERTEXHEIGHT);
			else {
				_removeShaderDefine(SHADERDEFINE_USEVERTEXHEIGHT);
			}
		}
		
		public function get useVertexDeep():Boolean {
			return _useVertexDeep;
		}
		
		public function get windDir():Number {
			return 0;
		}
		
		public function set windDir(d:Number):void {
		
		}
		
		public function get windSpeed():Number {
			return 0;
		}
		
		public function set windSpeed(s:Number):void {
		
		}
		
		public function set useFoam(v:Boolean):void {
			if (v) {
				_addShaderDefine(SHADERDEFINE_USE_FOAM);
			} else {
				_removeShaderDefine(SHADERDEFINE_USE_FOAM);
			}
		}
		
		public function set useRefractTexture(v:Boolean):void {
			if (v) {
				_addShaderDefine(SHADERDEFINE_USE_REFRACT_TEX);
			} else {
				_removeShaderDefine(SHADERDEFINE_USE_REFRACT_TEX);
			}
		}
		
		public function WaterMaterial() {
			super();
			//_startTm = Laya.timer.currTimer;
			setShaderName("Water");
		}
		
		/**
		 * 禁用雾化。
		 */
		public function disableFog():void {
			_addDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_FOG);
		}
		
		public function set renderMode(value:int):void {
			switch (value) {
			case RENDERMODE_OPAQUE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				alphaTest = false;
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				alphaTest = false;
				break;
			case RENDERMODE_CUTOUT: 
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				renderQueue = RenderQueue.OPAQUE;
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				break;
			default: 
				throw new Error("PBRMaterial:renderMode value error.");
			}
		}
		
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			super.onAsynLoaded(url, data, params);
		}
	}
}