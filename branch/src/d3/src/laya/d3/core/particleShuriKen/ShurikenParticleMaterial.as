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
		
		public static var SHADERDEFINE_DIFFUSEMAP:int;
		public static var SHADERDEFINE_SPHERHBILLBOARD:int;
		public static var SHADERDEFINE_STRETCHEDBILLBOARD:int;
		public static var SHADERDEFINE_HORIZONTALBILLBOARD:int;
		public static var SHADERDEFINE_VERTICALBILLBOARD:int;
		public static var SHADERDEFINE_RANDOMCOLOROVERLIFETIME:int;
		public static var SHADERDEFINE_COLOROVERLIFETIME:int;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT:int;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMECURVE:int;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT:int;
		public static var SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE:int;
		public static var SHADERDEFINE_TEXTURESHEETANIMATIONCURVE:int;
		public static var SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIME:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMECURVE:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS:int;
		public static var SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES:int;
		public static var SHADERDEFINE_SIZEOVERLIFETIMECURVE:int;
		public static var SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE:int;
		public static var SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES:int;
		public static var SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE:int;
		
		public static const THREEDSTARTROTATION:int = 0;
		public static const SCALINGMODE:int = 1;
		public static const CURRENTTIME:int = 2;
		public static const GRAVITY:int = 3;
		public static const DIFFUSETEXTURE:int = 4;
		public static const STRETCHEDBILLBOARDLENGTHSCALE:int = 5;
		public static const STRETCHEDBILLBOARDSPEEDSCALE:int = 6;
		public static const SIMULATIONSPACE:int = 7;
		public static const TINTCOLOR:int = 8;
		
		/** @private */
		private static var _tempGravity:Vector3 = new Vector3();
		
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
				//_addShaderDefine(ShaderDefines3D.ALPHATEST);
				//event(Event.RENDERQUEUE_CHANGED, this);
				break;
				//case RENDERMODE_CUTOUTDOUBLEFACE: 
				//_renderQueue = RenderQueue.OPAQUE;
				//depthWrite = true;
				//cull = CULL_NONE;
				//blend = BLEND_DISABLE;
				//_addShaderDefine(ShaderDefines3D.ALPHATEST);
				event(Event.RENDERQUEUE_CHANGED, this);
				break;
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
			super();
			setShaderName("PARTICLESHURIKEN");
			_setColor(TINTCOLOR, new Vector4(0.5, 0.5, 0.5, 0.5));
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
		 * @inheritDoc
		 */
		override public function _setMaterialShaderParams(state:RenderState):void {
			var particle:ShuriKenParticle3D = state.owner as ShuriKenParticle3D;
			var particleSystem:ShurikenParticleSystem = particle.particleSystem;
			var particleRender:ShurikenParticleRender = particle.particleRender;
			var transform:Transform3D = particle.transform;
			
			var finalGravityE:Float32Array = _tempGravity.elements;
			var gravityE:Float32Array = particleSystem.gravity.elements;
			var gravityModifier:Number = particleSystem.gravityModifier;
			finalGravityE[0] = gravityE[0] * gravityModifier;
			finalGravityE[1] = gravityE[1] * gravityModifier;
			finalGravityE[2] = gravityE[2] * gravityModifier;
			
			_setBuffer(GRAVITY, finalGravityE);
			
			_setInt(SIMULATIONSPACE, particleSystem.simulationSpace);
			
			_setBool(THREEDSTARTROTATION, particleSystem.threeDStartRotation);
			_setInt(SCALINGMODE, particleSystem.scaleMode);
			
			_setInt(STRETCHEDBILLBOARDLENGTHSCALE, particleRender.stretchedBillboardLengthScale);
			_setInt(STRETCHEDBILLBOARDSPEEDSCALE, particleRender.stretchedBillboardSpeedScale);
			
			//设置粒子的时间参数，可通过此参数停止粒子动画
			_setNumber(CURRENTTIME, particleSystem.currentTime);
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
				
				//_loaded = true;
				event(Event.LOADED, this);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var dest:ShurikenParticleMaterial = destObject as ShurikenParticleMaterial;
			dest._renderMode = _renderMode;
		}
	
	}

}