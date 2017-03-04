package laya.d3.core.material {
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.tempelet.ParticleTemplet3D;
	import laya.events.Event;
	import laya.particle.ParticleSetting;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ParticleMaterial extends BaseMaterial {
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 1;
		/**渲染状态_不透明_双面。*/
		public static const RENDERMODE_OPAQUEDOUBLEFACE:int = 2;
		///**渲染状态_透明测试。*/
		//public static const RENDERMODE_CUTOUT:int = 3;
		///**渲染状态_透明测试_双面。*/
		//public static const RENDERMODE_CUTOUTDOUBLEFACE:int = 4;
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
		
		public static var SHADERDEFINE_PARTICLE3D:int;
		
		public static const VIEWPORTSCALE:int = 0;//TODO:
		public static const CURRENTTIME:int = 1;
		public static const DURATION:int = 2;
		public static const GRAVITY:int = 3;
		public static const ENDVELOCITY:int = 4;
		public static const DIFFUSETEXTURE:int = 5;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:ParticleMaterial = new ParticleMaterial();
		
		/**
		 * 加载粒子材质。
		 * @param url 粒子材质地址。
		 */
		public static function load(url:String):ParticleMaterial {
			return Laya.loader.create(url, null, null, ParticleMaterial);
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
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				_renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			//case RENDERMODE_CUTOUT: 
				//depthWrite = true;
				//cull = CULL_BACK;
				//blend = BLEND_DISABLE;
				//_renderQueue = RenderQueue.OPAQUE;
				////_addShaderDefine(ShaderDefines3D.ALPHATEST);
				//event(Event.RENDERQUEUE_CHANGED, this);
				//break;
			//case RENDERMODE_CUTOUTDOUBLEFACE: 
				//_renderQueue = RenderQueue.OPAQUE;
				//depthWrite = true;
				//cull = CULL_NONE;
				//blend = BLEND_DISABLE;
				////_addShaderDefine(ShaderDefines3D.ALPHATEST);
				//event(Event.RENDERQUEUE_CHANGED, this);
				//break;
			case RENDERMODE_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENT: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: 
				_renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
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
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		public function ParticleMaterial() {
			super();
			_addShaderDefine(ParticleMaterial.SHADERDEFINE_PARTICLE3D);
			setShaderName("PARTICLE");
			renderMode = RENDERMODE_OPAQUE;
		}
		
		override public function _setMaterialShaderParams(state:RenderState):void {
			var particle:Particle3D = state.owner as Particle3D;
			var templet:ParticleTemplet3D = particle.templet;
			var setting:ParticleSetting = templet.settings;
			
			_setNumber(DURATION, setting.duration);
			_setBuffer(GRAVITY, setting.gravity);
			_setNumber(ENDVELOCITY, setting.endVelocity);
			
			//设置视口尺寸，被用于转换粒子尺寸到屏幕空间的尺寸
			var aspectRadio:Number = state.viewport.width / state.viewport.height;
			var viewportScale:Vector2 = new Vector2(0.5 / aspectRadio, -0.5);
			_setVector2(VIEWPORTSCALE, viewportScale);
			
			//设置粒子的时间参数，可通过此参数停止粒子动画
			_setNumber(CURRENTTIME, templet._currentTime);
		}
		
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var dest:ParticleMaterial = destObject as ParticleMaterial;
			dest._renderMode = _renderMode;
		}
	
	}

}