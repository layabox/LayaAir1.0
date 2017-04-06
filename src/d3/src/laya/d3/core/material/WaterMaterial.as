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
		public static const SKYTEXTURE:int = 11;
		public static const WAVEINFO:int = 12;
		public static const WAVEMAINDIR:int = 13;
		
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