package laya.d3.core.material {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.net.Loader;
	import laya.utils.Browser;
	import laya.webgl.WebGLContext;
	import laya.events.Event;
	
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
		
		public static var SHADERDEFINE_SHOW_NORMAL:int = 0;
		public static var SHADERDEFINE_CUBE_ENV:int = 0;
		public static var SHADERDEFINE_HDR_ENV:int = 0;
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
		
		/**@private 渲染模式。*/
		private var _renderMode:int;
		
		private var _startTm:Number = 0;
		
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
		
		public function  set underWaterTexture(value:BaseTexture):void {
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
			_setTexture(FOAMTEXTURE,v);
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
		
		public function get detailTexture():BaseTexture{
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
		
		public function  set currentTm(v:Number):void {
			_setNumber(CURTM, v-_startTm);
		}
		
		public function get waveInfo():Float32Array{
			return _getBuffer(WAVEINFO);
		}
		
		public function  set waveInfo(v:Float32Array):void{
			_setBuffer(WAVEINFO, v);
		}
		public function get waveInfoD():Float32Array{
			return _getBuffer(WAVEINFOD);
		}
		
		public function  set waveInfoD(v:Float32Array):void{
			_setBuffer(WAVEINFOD, v);
		}
		
		public function set waveMainDir(deg:Number):void{
			_setNumber(WAVEMAINDIR,deg*Math.PI/180);
		}
		
		public function get waveMainDir():Number {
			return _getNumber(WAVEMAINDIR);	
		}
		
		public function get geoWaveUVScale():Number {
			return _getNumber(GEOWAVE_UV_SCALE);
		}
		
		public function  set geoWaveUVScale(v:Number):void {
			_setNumber(GEOWAVE_UV_SCALE,v);
		}
		
		public function set scrsize(v:Float32Array):void {
			_setBuffer(SCRSIZE, v);
		}
		
		public function get seaColor():Float32Array{
			return _getBuffer(SEA_COLOR);
		}
		
		public function set seaColor(v:Float32Array):void {
			_setBuffer(SEA_COLOR, v);
		}
		
		public function WaterMaterial() {
			super();
			_startTm = Laya.timer.currTimer;
			setShaderName("Water");
		}
		
		/**
		 * 禁用雾化。
		 */
		public function disableFog():void {
			_addDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_FOG);
		}
		
		/**
		 * 获取渲染状态。
		 * @return 渲染状态。
		 */
		public function get renderMode():int {
			return _renderMode;
		}
		
		public function set renderMode(value:int):void {
			_renderMode = value;
			switch (value) {
			case RENDERMODE_OPAQUE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_CUTOUT: 
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				_renderQueue = RenderQueue.OPAQUE;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			default: 
				throw new Error("PBRMaterial:renderMode value error.");
			}
		}
		
		/**
		 * @private
		 */
		override public function _setMaterialShaderParams(state:RenderState):void {
		}
		
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			super.onAsynLoaded(url, data, params);
		}
	}
}