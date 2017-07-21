package laya.d3.core.particleShuriKen {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.GradientAngularVelocity;
	import laya.d3.core.particleShuriKen.module.GradientColor;
	import laya.d3.core.particleShuriKen.module.GradientDataColor;
	import laya.d3.core.particleShuriKen.module.GradientSize;
	import laya.d3.core.particleShuriKen.module.GradientVelocity;
	import laya.d3.core.particleShuriKen.module.RotationOverLifetime;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.core.particleShuriKen.module.VelocityOverLifetime;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ValusArray;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShurikenParticleMaterial extends BaseMaterial {
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
		
		public static var SHADERDEFINE_DIFFUSEMAP:int;
		public static var SHADERDEFINE_TINTCOLOR:int;
		
		public static const DIFFUSETEXTURE:int = 1;
		public static const TINTCOLOR:int = 2;
		
		/** @private */
		private static const _diffuseTextureIndex:int = 0;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:ShurikenParticleMaterial = new ShurikenParticleMaterial();
		
		/**
		 * 加载手里剑粒子材质。
		 * @param url 手里剑粒子材质地址。
		 */
		public static function load(url:String):ShurikenParticleMaterial {
			return Laya.loader.create(url, null, null, ShurikenParticleMaterial);
		}
		
		/**
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			switch (value) {
			case RENDERMODE_OPAQUE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				renderQueue = RenderQueue.OPAQUE;
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
				renderQueue = RenderQueue.OPAQUE;
				alphaTest = true;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_CUTOUTDOUBLEFACE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				alphaTest = true;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_TRANSPARENTDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_ADDTIVEDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				alphaTest = false;
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
			default: 
				throw new Error("Material:renderMode value error.");
			}
			
			_conchMaterial && _conchMaterial.setRenderMode(value);//NATIVE
		}
		
		/**
		 * 获取颜色。
		 * @return  颜色。
		 */
		public function get tintColor():Vector4 {
			return _getColor(TINTCOLOR);
		}
		
		/**
		 * 设置颜色。
		 * @param value 颜色。
		 */
		public function set tintColor(value:Vector4):void {
			if (value)
				_addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_TINTCOLOR);
			else
				_removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_TINTCOLOR);
			
			_setColor(TINTCOLOR, value);
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _getTexture(_diffuseTextureIndex);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set diffuseTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_DIFFUSEMAP);
			else
				_removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_DIFFUSEMAP);
			
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		public function ShurikenParticleMaterial() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			setShaderName("PARTICLESHURIKEN");
			renderMode = RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE;
		}
		
		/**
		 * @private
		 */
		public static function _parseShurikenParticleMaterial(textureMap:Object, material:ShurikenParticleMaterial, json:Object):void {//兼容性函数
			var customProps:Object = json.customProps;
			var diffuseTexture:String = customProps.diffuseTexture.texture2D;
			(diffuseTexture) && (material.diffuseTexture = Loader.getRes(textureMap[diffuseTexture]));
			var tintColorValue:Array = customProps.tintColor;
			(tintColorValue) && (material.tintColor = new Vector4(tintColorValue[0], tintColorValue[1], tintColorValue[2], tintColorValue[3]));
		}
		
		/**
		 *@private
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var jsonData:Object = data[0];
			if (jsonData.version) {
				super.onAsynLoaded(url, data, params);
			} else {//兼容性代码
				var textureMap:Object = data[1];
				var props:Object = jsonData.props;
				for (var prop:String in props)
					this[prop] = props[prop];
				_parseShurikenParticleMaterial(textureMap, this, jsonData);
				
				_endLoaded();
			}
		}
	
	}

}