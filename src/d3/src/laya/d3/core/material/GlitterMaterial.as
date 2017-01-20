package laya.d3.core.material {
	import laya.d3.core.glitter.Glitter;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.tempelet.GlitterTemplet;
	import laya.d3.shader.ShaderDefines3D;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GlitterMaterial extends BaseMaterial {
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
		/**渲染状态_透明混合_双面。*/
		public static const RENDERMODE_TRANSPARENTDOUBLEFACE:int = 14;
		/**渲染状态_加色法混合。*/
		public static const RENDERMODE_ADDTIVE:int = 15;
		/**渲染状态_加色法混合_双面。*/
		public static const RENDERMODE_ADDTIVEDOUBLEFACE:int = 16;
		/**渲染状态_只读深度_透明混合。*/
		public static const RENDERMODE_DEPTHREAD_TRANSPARENT:int = 5;
		/**渲染状态_只读深度_透明混合_双面。*/
		public static const RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE:int = 6;
		/**渲染状态_只读深度_加色法混合。*/
		public static const RENDERMODE_DEPTHREAD_ADDTIVE:int = 7;
		/**渲染状态_只读深度_加色法混合_双面。*/
		public static const RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE:int = 8;
		/**渲染状态_无深度_透明混合。*/
		public static const RENDERMODE_NONDEPTH_TRANSPARENT:int = 9;
		/**渲染状态_无深度_透明混合_双面。*/
		public static const RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE:int = 10;
		/**渲染状态_无深度_加色法混合。*/
		public static const RENDERMODE_NONDEPTH_ADDTIVE:int = 11;
		/**渲染状态_无深度_加色法混合_双面。*/
		public static const RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE:int = 12;
		
		public static const DIFFUSETEXTURE:int = 0;
		public static const ALBEDO:int = 1;
		public static const CURRENTTIME:int = 2;
		public static const UNICOLOR:int = 3;
		public static const DURATION:int = 4;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:GlitterMaterial = new GlitterMaterial();
		
		/**
		 * 加载闪光材质。
		 * @param url 闪光材质地址。
		 */
		public static function load(url:String):GlitterMaterial {
			return Laya.loader.create(url, null, null, GlitterMaterial);
		}
		
		/**@private 渲染模式。*/
		private var _renderMode:int;
		
		/**
		 * 获取渲染状态。
		 * @return 渲染状态。
		 */
		public function get renderMode():int {
			return _renderMode;
		}
		
		/**
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			_renderMode = value;
			switch (value) {
			case RENDERMODE_OPAQUE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_CUTOUT: 
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				_renderQueue = RenderQueue.OPAQUE;
				_addShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_CUTOUTDOUBLEFACE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				_addShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			default: 
				throw new Error("Material:renderMode value error.");
			}
			
			_conchMaterial && _conchMaterial.setRenderMode(value);//NATIVE
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
			if (value) {
				_addShaderDefine(ShaderDefines3D.DIFFUSEMAP);
			} else {
				_removeShaderDefine(ShaderDefines3D.DIFFUSEMAP);
			}
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		override public function setShaderName(name:String):void {
			super.setShaderName(name);
		}
		
		public function GlitterMaterial() {
			super();
			setShaderName("GLITTER");
			renderMode = RENDERMODE_OPAQUE;
		}
		
		override public function _setMaterialShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
			var glitter:Glitter = state.owner as Glitter;
			var templet:GlitterTemplet = glitter.templet;
			
			_setColor(UNICOLOR, templet.color);
			_setNumber(DURATION, templet.lifeTime);
			_setColor(ALBEDO, templet._albedo);
			_setNumber(CURRENTTIME, templet._currentTime);//设置粒子的时间参数，可通过此参数停止粒子动画
		}
		
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var dest:GlitterMaterial = destObject as GlitterMaterial;
			dest._renderMode = _renderMode;
		}
	
	}

}