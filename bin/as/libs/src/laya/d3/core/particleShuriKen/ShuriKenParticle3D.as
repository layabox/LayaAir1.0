package laya.d3.core.particleShuriKen {
	import laya.d3.core.ComponentNode;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.particleShuriKen.module.Burst;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.Emission;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.GradientAngularVelocity;
	import laya.d3.core.particleShuriKen.module.GradientColor;
	import laya.d3.core.particleShuriKen.module.GradientDataColor;
	import laya.d3.core.particleShuriKen.module.GradientDataInt;
	import laya.d3.core.particleShuriKen.module.GradientDataNumber;
	import laya.d3.core.particleShuriKen.module.GradientSize;
	import laya.d3.core.particleShuriKen.module.GradientVelocity;
	import laya.d3.core.particleShuriKen.module.RotationOverLifetime;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.StartFrame;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.core.particleShuriKen.module.VelocityOverLifetime;
	import laya.d3.core.particleShuriKen.module.shape.BaseShape;
	import laya.d3.core.particleShuriKen.module.shape.BoxShape;
	import laya.d3.core.particleShuriKen.module.shape.CircleShape;
	import laya.d3.core.particleShuriKen.module.shape.ConeShape;
	import laya.d3.core.particleShuriKen.module.shape.HemisphereShape;
	import laya.d3.core.particleShuriKen.module.shape.SphereShape;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.Texture2D;
	import laya.d3.shader.ShaderDefines;
	import laya.events.Event;
	import laya.net.Loader;
	
	/**
	 * <code>ShuriKenParticle3D</code> 3D粒子。
	 */
	public class ShuriKenParticle3D extends RenderableSprite3D {
		public static var SHADERDEFINE_RENDERMODE_BILLBOARD:int;
		public static var SHADERDEFINE_RENDERMODE_STRETCHEDBILLBOARD:int;
		public static var SHADERDEFINE_RENDERMODE_HORIZONTALBILLBOARD:int;
		public static var SHADERDEFINE_RENDERMODE_VERTICALBILLBOARD:int;
		
		public static var SHADERDEFINE_COLOROVERLIFETIME:int;
		public static var SHADERDEFINE_RANDOMCOLOROVERLIFETIME:int;
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
		public static var SHADERDEFINE_RENDERMODE_MESH:int;
		public static var SHADERDEFINE_SHAPE:int;
		
		public static const WORLDPOSITION:int = 0;
		public static const WORLDROTATION:int = 1;
		public static const POSITIONSCALE:int = 4;//TODO:是否可以从2开始
		public static const SIZESCALE:int = 5;
		public static const SCALINGMODE:int = 6;
		public static const GRAVITY:int = 7;
		public static const THREEDSTARTROTATION:int = 8;
		public static const STRETCHEDBILLBOARDLENGTHSCALE:int = 9;
		public static const STRETCHEDBILLBOARDSPEEDSCALE:int = 10;
		public static const SIMULATIONSPACE:int = 11;
		public static const CURRENTTIME:int = 12;
		
		//VelocityOverLifetime
		public static const VOLVELOCITYCONST:int = 13;
		public static const VOLVELOCITYGRADIENTX:int = 14;
		public static const VOLVELOCITYGRADIENTY:int = 15;
		public static const VOLVELOCITYGRADIENTZ:int = 16;
		public static const VOLVELOCITYCONSTMAX:int = 17;
		public static const VOLVELOCITYGRADIENTXMAX:int = 18;
		public static const VOLVELOCITYGRADIENTYMAX:int = 19;
		public static const VOLVELOCITYGRADIENTZMAX:int = 20;
		public static const VOLSPACETYPE:int = 21;
		
		//ColorOverLifetime
		public static const COLOROVERLIFEGRADIENTALPHAS:int = 22;
		public static const COLOROVERLIFEGRADIENTCOLORS:int = 23;
		public static const MAXCOLOROVERLIFEGRADIENTALPHAS:int = 24;
		public static const MAXCOLOROVERLIFEGRADIENTCOLORS:int = 25;
		
		//SizeOverLifetime
		public static const SOLSIZEGRADIENT:int = 26;
		public static const SOLSIZEGRADIENTX:int = 27;
		public static const SOLSIZEGRADIENTY:int = 28;
		public static const SOLSizeGradientZ:int = 29;
		public static const SOLSizeGradientMax:int = 30;
		public static const SOLSIZEGRADIENTXMAX:int = 31;
		public static const SOLSIZEGRADIENTYMAX:int = 32;
		public static const SOLSizeGradientZMAX:int = 33;
		
		//RotationOverLifetime
		public static const ROLANGULARVELOCITYCONST:int = 34;
		public static const ROLANGULARVELOCITYCONSTSEPRARATE:int = 35;
		public static const ROLANGULARVELOCITYGRADIENT:int = 36;
		public static const ROLANGULARVELOCITYGRADIENTX:int = 37;
		public static const ROLANGULARVELOCITYGRADIENTY:int = 38;
		public static const ROLANGULARVELOCITYGRADIENTZ:int = 39;
		public static const ROLANGULARVELOCITYGRADIENTW:int = 40;
		public static const ROLANGULARVELOCITYCONSTMAX:int = 41;
		public static const ROLANGULARVELOCITYCONSTMAXSEPRARATE:int = 42;
		public static const ROLANGULARVELOCITYGRADIENTMAX:int = 43;
		public static const ROLANGULARVELOCITYGRADIENTXMAX:int = 44;
		public static const ROLANGULARVELOCITYGRADIENTYMAX:int = 45;
		public static const ROLANGULARVELOCITYGRADIENTZMAX:int = 46;
		public static const ROLANGULARVELOCITYGRADIENTWMAX:int = 47;
		
		//TextureSheetAnimation
		public static const TEXTURESHEETANIMATIONCYCLES:int = 48;
		public static const TEXTURESHEETANIMATIONSUBUVLENGTH:int = 49;
		public static const TEXTURESHEETANIMATIONGRADIENTUVS:int = 50;
		public static const TEXTURESHEETANIMATIONGRADIENTMAXUVS:int = 51;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(RenderableSprite3D.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_RENDERMODE_BILLBOARD = shaderDefines.registerDefine("SPHERHBILLBOARD");
			SHADERDEFINE_RENDERMODE_STRETCHEDBILLBOARD = shaderDefines.registerDefine("STRETCHEDBILLBOARD");
			SHADERDEFINE_RENDERMODE_HORIZONTALBILLBOARD = shaderDefines.registerDefine("HORIZONTALBILLBOARD");
			SHADERDEFINE_RENDERMODE_VERTICALBILLBOARD = shaderDefines.registerDefine("VERTICALBILLBOARD");
			
			SHADERDEFINE_COLOROVERLIFETIME = shaderDefines.registerDefine("COLOROVERLIFETIME");
			SHADERDEFINE_RANDOMCOLOROVERLIFETIME = shaderDefines.registerDefine("RANDOMCOLOROVERLIFETIME");
			SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT = shaderDefines.registerDefine("VELOCITYOVERLIFETIMECONSTANT");
			SHADERDEFINE_VELOCITYOVERLIFETIMECURVE = shaderDefines.registerDefine("VELOCITYOVERLIFETIMECURVE");
			SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT = shaderDefines.registerDefine("VELOCITYOVERLIFETIMERANDOMCONSTANT");
			SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE = shaderDefines.registerDefine("VELOCITYOVERLIFETIMERANDOMCURVE");
			SHADERDEFINE_TEXTURESHEETANIMATIONCURVE = shaderDefines.registerDefine("TEXTURESHEETANIMATIONCURVE");
			SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE = shaderDefines.registerDefine("TEXTURESHEETANIMATIONRANDOMCURVE");
			SHADERDEFINE_ROTATIONOVERLIFETIME = shaderDefines.registerDefine("ROTATIONOVERLIFETIME");
			SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE = shaderDefines.registerDefine("ROTATIONOVERLIFETIMESEPERATE");
			SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT = shaderDefines.registerDefine("ROTATIONOVERLIFETIMECONSTANT");
			SHADERDEFINE_ROTATIONOVERLIFETIMECURVE = shaderDefines.registerDefine("ROTATIONOVERLIFETIMECURVE");
			SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS = shaderDefines.registerDefine("ROTATIONOVERLIFETIMERANDOMCURVES");
			SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES = shaderDefines.registerDefine("ROTATIONOVERLIFETIMERANDOMCURVES");
			SHADERDEFINE_SIZEOVERLIFETIMECURVE = shaderDefines.registerDefine("SIZEOVERLIFETIMECURVE");
			SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE = shaderDefines.registerDefine("SIZEOVERLIFETIMECURVESEPERATE");
			SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES = shaderDefines.registerDefine("SIZEOVERLIFETIMERANDOMCURVES");
			SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE = shaderDefines.registerDefine("SIZEOVERLIFETIMERANDOMCURVESSEPERATE");
			SHADERDEFINE_RENDERMODE_MESH = shaderDefines.registerDefine("RENDERMODE_MESH");
			SHADERDEFINE_SHAPE = shaderDefines.registerDefine("SHAPE");
		}
		
		/**
		 * 加载网格模板。
		 * @param url 模板地址。
		 */
		public static function load(url:String):ShuriKenParticle3D {
			return Laya.loader.create(url, null, null, ShuriKenParticle3D);
		}
		
		/**
		 * 获取粒子系统。
		 * @return  粒子系统。
		 */
		public function get particleSystem():ShurikenParticleSystem {
			return _geometryFilter as ShurikenParticleSystem;
		}
		
		/**
		 * 获取粒子渲染器。
		 * @return  粒子渲染器。
		 */
		public function get particleRender():ShurikenParticleRender {
			return _render as ShurikenParticleRender;
		}
		
		/**
		 * 创建一个 <code>Particle3D</code> 实例。
		 * @param settings value 粒子配置。
		 */
		public function ShuriKenParticle3D(material:ShurikenParticleMaterial = null) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_render = new ShurikenParticleRender(this);
			_render.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			_geometryFilter = new ShurikenParticleSystem(this);
			_createRenderElement(0);
			
			(material) && (_render.sharedMaterial = material);
		}
		
		/**
		 * @private
		 */
		private static function _initStartLife(gradientData:Object):GradientDataNumber {
			var gradient:GradientDataNumber = new GradientDataNumber();
			var startLifetimesData:Array = gradientData.startLifetimes;
			for (var i:int = 0, n:int = startLifetimesData.length; i < n; i++) {
				var valueData:Object = startLifetimesData[i];
				gradient.add(valueData.key, valueData.value);
			}
			return gradient;
		}
		
		/**
		 * @private
		 */
		private function _initParticleVelocity(gradientData:Object):GradientDataNumber {
			var gradient:GradientDataNumber = new GradientDataNumber();
			var velocitysData:Array = gradientData.velocitys;
			for (var i:int = 0, n:int = velocitysData.length; i < n; i++) {
				var valueData:Object = velocitysData[i];
				gradient.add(valueData.key, valueData.value);
			}
			return gradient;
		}
		
		/**
		 * @private
		 */
		private function _initParticleColor(gradientColorData:Object):GradientDataColor {
			var gradientColor:GradientDataColor = new GradientDataColor();
			var alphasData:Array = gradientColorData.alphas;
			var i:int, n:int;
			for (i = 0, n = alphasData.length; i < n; i++) {
				var alphaData:Object = alphasData[i];
				gradientColor.addAlpha(alphaData.key, alphaData.value);
			}
			var rgbsData:Array = gradientColorData.rgbs;
			for (i = 0, n = rgbsData.length; i < n; i++) {
				var rgbData:Object = rgbsData[i];
				var rgbValue:Array = rgbData.value;
				gradientColor.addRGB(rgbData.key, new Vector3(rgbValue[0], rgbValue[1], rgbValue[2]));
			}
			return gradientColor;
		}
		
		/**
		 * @private
		 */
		private function _initParticleSize(gradientSizeData:Object):GradientDataNumber {
			var gradientSize:GradientDataNumber = new GradientDataNumber();
			var sizesData:Array = gradientSizeData.sizes;
			for (var i:int = 0, n:int = sizesData.length; i < n; i++) {
				var valueData:Object = sizesData[i];
				gradientSize.add(valueData.key, valueData.value);
			}
			return gradientSize;
		}
		
		/**
		 * @private
		 */
		private function _initParticleRotation(gradientData:Object):GradientDataNumber {
			var gradient:GradientDataNumber = new GradientDataNumber();
			var angularVelocitysData:Array = gradientData.angularVelocitys;
			for (var i:int = 0, n:int = angularVelocitysData.length; i < n; i++) {
				var valueData:Object = angularVelocitysData[i];
				gradient.add(valueData.key, valueData.value / 180.0 * Math.PI);
			}
			return gradient;
		}
		
		/**
		 * @private
		 */
		private function _initParticleFrame(overTimeFramesData:Object):GradientDataInt {
			var overTimeFrame:GradientDataInt = new GradientDataInt();
			var framesData:Array = overTimeFramesData.frames;
			for (var i:int = 0, n:int = framesData.length; i < n; i++) {
				var frameData:Object = framesData[i];
				overTimeFrame.add(frameData.key, frameData.value);
			}
			return overTimeFrame;
		}
		
		/**
		 * @private
		 */
		private function _createRenderElement(index:int):void {
			var elements:Vector.<RenderElement> = _render._renderElements;
			
			var element:RenderElement = elements[index] = new RenderElement();
			element._render = _render;
			var material:BaseMaterial = _render.sharedMaterials[index];
			(material) || (material = ShurikenParticleMaterial.defaultMaterial);//确保有材质,由默认材质代替。
			var renderable:IRenderable = _geometryFilter as ShurikenParticleSystem;
			element._mainSortID = 0;
			element._sprite3D = this;
			element.renderObj = renderable;
			element._material = material;
		}
		
		/** @private */
		private function _onMaterialChanged(_particleRender:ShurikenParticleRender, index:int, material:BaseMaterial):void {
			var elements:Vector.<RenderElement> = _particleRender._renderElements;
			if (index < elements.length) {
				var element:RenderElement = elements[index];
				element._material = material || ShurikenParticleMaterial.defaultMaterial;
			}
		}
		
		/** @private */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_render);
		}
		
		/** @private */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_render);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _parseCustomProps(rootNode:ComponentNode, innerResouMap:Object, customProps:Object, nodeData:Object):void {
			const anglelToRad:Number = Math.PI / 180.0;
			var i:int, n:int;
			
			//Render
			var particleRender:ShurikenParticleRender = this.particleRender;
			var material:ShurikenParticleMaterial;
			
			var materialData:Object = customProps.material;
			if (materialData) {
				material = Loader.getRes(innerResouMap[materialData.path]);
			} else {//TODO:兼容性代码
				var materialPath:String = customProps.materialPath;
				if (materialPath) {//TODO:兼容性代码
					material = Loader.getRes(innerResouMap[materialPath]);
				} else {//TODO:兼容性代码
					material = new ShurikenParticleMaterial();
					material.diffuseTexture = innerResouMap ? Loader.getRes(innerResouMap[customProps.texturePath]) : Texture2D.load(customProps.texturePath);
				}
			}
			
			particleRender.sharedMaterial = material;
			var meshPath:String = customProps.meshPath;
			(meshPath) && (particleRender.mesh = Loader.getRes(innerResouMap[meshPath]));
			
			particleRender.renderMode = customProps.renderMode;
			particleRender.stretchedBillboardCameraSpeedScale = customProps.stretchedBillboardCameraSpeedScale;
			particleRender.stretchedBillboardSpeedScale = customProps.stretchedBillboardSpeedScale;
			particleRender.stretchedBillboardLengthScale = customProps.stretchedBillboardLengthScale;
			particleRender.sortingFudge = customProps.sortingFudge ? customProps.sortingFudge : 0.0;
			
			//particleSystem
			var particleSystem:ShurikenParticleSystem = this.particleSystem;
			particleSystem.isPerformanceMode = customProps.isPerformanceMode;
			
			particleSystem.duration = customProps.duration;
			particleSystem.looping = customProps.looping;
			particleSystem.prewarm = customProps.prewarm;
			
			particleSystem.startDelayType = customProps.startDelayType;
			particleSystem.startDelay = customProps.startDelay;
			particleSystem.startDelayMin = customProps.startDelayMin;
			particleSystem.startDelayMax = customProps.startDelayMax;
			
			particleSystem.startLifetimeType = customProps.startLifetimeType;
			particleSystem.startLifetimeConstant = customProps.startLifetimeConstant;
			particleSystem.startLifeTimeGradient = _initStartLife(customProps.startLifetimeGradient);
			particleSystem.startLifetimeConstantMin = customProps.startLifetimeConstantMin;
			particleSystem.startLifetimeConstantMax = customProps.startLifetimeConstantMax;
			particleSystem.startLifeTimeGradientMin = _initStartLife(customProps.startLifetimeGradientMin);
			particleSystem.startLifeTimeGradientMax = _initStartLife(customProps.startLifetimeGradientMax);
			
			particleSystem.startSpeedType = customProps.startSpeedType;
			particleSystem.startSpeedConstant = customProps.startSpeedConstant;
			particleSystem.startSpeedConstantMin = customProps.startSpeedConstantMin;
			particleSystem.startSpeedConstantMax = customProps.startSpeedConstantMax;
			
			particleSystem.threeDStartSize = customProps.threeDStartSize;
			particleSystem.startSizeType = customProps.startSizeType;
			particleSystem.startSizeConstant = customProps.startSizeConstant;
			var startSizeConstantSeparateArray:Array = customProps.startSizeConstantSeparate;
			var startSizeConstantSeparateElement:Float32Array = particleSystem.startSizeConstantSeparate.elements;
			startSizeConstantSeparateElement[0] = startSizeConstantSeparateArray[0];
			startSizeConstantSeparateElement[1] = startSizeConstantSeparateArray[1];
			startSizeConstantSeparateElement[2] = startSizeConstantSeparateArray[2];
			particleSystem.startSizeConstantMin = customProps.startSizeConstantMin;
			particleSystem.startSizeConstantMax = customProps.startSizeConstantMax;
			var startSizeConstantMinSeparateArray:Array = customProps.startSizeConstantMinSeparate;
			var startSizeConstantMinSeparateElement:Float32Array = particleSystem.startSizeConstantMinSeparate.elements;
			startSizeConstantMinSeparateElement[0] = startSizeConstantMinSeparateArray[0];
			startSizeConstantMinSeparateElement[1] = startSizeConstantMinSeparateArray[1];
			startSizeConstantMinSeparateElement[2] = startSizeConstantMinSeparateArray[2];
			var startSizeConstantMaxSeparateArray:Array = customProps.startSizeConstantMaxSeparate;
			var startSizeConstantMaxSeparateElement:Float32Array = particleSystem.startSizeConstantMaxSeparate.elements;
			startSizeConstantMaxSeparateElement[0] = startSizeConstantMaxSeparateArray[0];
			startSizeConstantMaxSeparateElement[1] = startSizeConstantMaxSeparateArray[1];
			startSizeConstantMaxSeparateElement[2] = startSizeConstantMaxSeparateArray[2];
			
			particleSystem.threeDStartRotation = customProps.threeDStartRotation;
			particleSystem.startRotationType = customProps.startRotationType;
			particleSystem.startRotationConstant = customProps.startRotationConstant * anglelToRad;
			var startRotationConstantSeparateArray:Array = customProps.startRotationConstantSeparate;
			var startRotationConstantSeparateElement:Float32Array = particleSystem.startRotationConstantSeparate.elements;
			startRotationConstantSeparateElement[0] = startRotationConstantSeparateArray[0] * anglelToRad;
			startRotationConstantSeparateElement[1] = startRotationConstantSeparateArray[1] * anglelToRad;
			startRotationConstantSeparateElement[2] = startRotationConstantSeparateArray[2] * anglelToRad;
			particleSystem.startRotationConstantMin = customProps.startRotationConstantMin * anglelToRad;
			particleSystem.startRotationConstantMax = customProps.startRotationConstantMax * anglelToRad;
			var startRotationConstantMinSeparateArray:Array = customProps.startRotationConstantMinSeparate;
			var startRotationConstantMinSeparateElement:Float32Array = particleSystem.startRotationConstantMinSeparate.elements;
			startRotationConstantMinSeparateElement[0] = startRotationConstantMinSeparateArray[0] * anglelToRad;
			startRotationConstantMinSeparateElement[1] = startRotationConstantMinSeparateArray[1] * anglelToRad;
			startRotationConstantMinSeparateElement[2] = startRotationConstantMinSeparateArray[2] * anglelToRad;
			var startRotationConstantMaxSeparateArray:Array = customProps.startRotationConstantMaxSeparate;
			var startRotationConstantMaxSeparateElement:Float32Array = particleSystem.startRotationConstantMaxSeparate.elements;
			startRotationConstantMaxSeparateElement[0] = startRotationConstantMaxSeparateArray[0] * anglelToRad;
			startRotationConstantMaxSeparateElement[1] = startRotationConstantMaxSeparateArray[1] * anglelToRad;
			startRotationConstantMaxSeparateElement[2] = startRotationConstantMaxSeparateArray[2] * anglelToRad;
			
			particleSystem.randomizeRotationDirection = customProps.randomizeRotationDirection;
			
			particleSystem.startColorType = customProps.startColorType;
			var startColorConstantArray:Array = customProps.startColorConstant;
			var startColorConstantElement:Float32Array = particleSystem.startColorConstant.elements;
			startColorConstantElement[0] = startColorConstantArray[0];
			startColorConstantElement[1] = startColorConstantArray[1];
			startColorConstantElement[2] = startColorConstantArray[2];
			startColorConstantElement[3] = startColorConstantArray[3];
			var startColorConstantMinArray:Array = customProps.startColorConstantMin;
			var startColorConstantMinElement:Float32Array = particleSystem.startColorConstantMin.elements;
			startColorConstantMinElement[0] = startColorConstantMinArray[0];
			startColorConstantMinElement[1] = startColorConstantMinArray[1];
			startColorConstantMinElement[2] = startColorConstantMinArray[2];
			startColorConstantMinElement[3] = startColorConstantMinArray[3];
			var startColorConstantMaxArray:Array = customProps.startColorConstantMax;
			var startColorConstantMaxElement:Float32Array = particleSystem.startColorConstantMax.elements;
			startColorConstantMaxElement[0] = startColorConstantMaxArray[0];
			startColorConstantMaxElement[1] = startColorConstantMaxArray[1];
			startColorConstantMaxElement[2] = startColorConstantMaxArray[2];
			startColorConstantMaxElement[3] = startColorConstantMaxArray[3];
			
			particleSystem.gravityModifier = customProps.gravityModifier;
			
			particleSystem.simulationSpace = customProps.simulationSpace;
			
			particleSystem.scaleMode = customProps.scaleMode;
			
			particleSystem.playOnAwake = customProps.playOnAwake;
			particleSystem.maxParticles = customProps.maxParticles;
			
			var autoRandomSeed:* = customProps.autoRandomSeed;
			(autoRandomSeed != null) && (particleSystem.autoRandomSeed = autoRandomSeed);
			var randomSeed:* = customProps.randomSeed;
			(randomSeed != null) && (particleSystem.randomSeed[0] = randomSeed);
			
			//Emission
			var emissionData:Object = customProps.emission;
			if (emissionData) {
				var emission:Emission = particleSystem.emission;
				emission.emissionRate = emissionData.emissionRate;
				var burstsData:Array = emissionData.bursts;
				if (burstsData)
					for (i = 0, n = burstsData.length; i < n; i++) {
						var brust:Object = burstsData[i];
						emission.addBurst(new Burst(brust.time, brust.min, brust.max));
					}
				emission.enbale = emissionData.enable;
			} else {
				emission.enbale = false;
			}
			
			//Shape
			var shapeData:Object = customProps.shape;
			if (shapeData) {
				var shape:BaseShape;
				switch (shapeData.shapeType) {
				case 0: 
					var sphereShape:SphereShape;
					shape = sphereShape = new SphereShape();
					sphereShape.radius = shapeData.sphereRadius;
					sphereShape.emitFromShell = shapeData.sphereEmitFromShell;
					sphereShape.randomDirection = shapeData.sphereRandomDirection;
					break;
				case 1: 
					var hemiSphereShape:HemisphereShape;
					shape = hemiSphereShape = new HemisphereShape();
					hemiSphereShape.radius = shapeData.hemiSphereRadius;
					hemiSphereShape.emitFromShell = shapeData.hemiSphereEmitFromShell;
					hemiSphereShape.randomDirection = shapeData.hemiSphereRandomDirection;
					break;
				case 2: 
					var coneShape:ConeShape;
					shape = coneShape = new ConeShape();
					coneShape.angle = shapeData.coneAngle * anglelToRad;
					coneShape.radius = shapeData.coneRadius;
					coneShape.length = shapeData.coneLength;
					coneShape.emitType = shapeData.coneEmitType;
					coneShape.randomDirection = shapeData.coneRandomDirection;
					break;
				case 3: 
					var boxShape:BoxShape;
					shape = boxShape = new BoxShape();
					boxShape.x = shapeData.boxX;
					boxShape.y = shapeData.boxY;
					boxShape.z = shapeData.boxZ;
					boxShape.randomDirection = shapeData.boxRandomDirection;
					break;
				case 7: 
					var circleShape:CircleShape;
					shape = circleShape = new CircleShape();
					circleShape.radius = shapeData.circleRadius;
					circleShape.arc = shapeData.circleArc * anglelToRad;
					circleShape.emitFromEdge = shapeData.circleEmitFromEdge;
					circleShape.randomDirection = shapeData.circleRandomDirection;
					break;
				/**
				 * ------------------------临时调整，待日后完善-------------------------------------
				 */
				default: 
					var tempShape:CircleShape;
					shape = tempShape = new CircleShape();
					tempShape.radius = shapeData.circleRadius;
					tempShape.arc = shapeData.circleArc * anglelToRad;
					tempShape.emitFromEdge = shapeData.circleEmitFromEdge;
					tempShape.randomDirection = shapeData.circleRandomDirection;
					break;
				}
				shape.enable = shapeData.enable;
				particleSystem.shape = shape;
			}
			
			//VelocityOverLifetime
			var velocityOverLifetimeData:Object = customProps.velocityOverLifetime;
			if (velocityOverLifetimeData) {
				var velocityData:Object = velocityOverLifetimeData.velocity;
				var velocity:GradientVelocity;
				switch (velocityData.type) {
				case 0: 
					var constantData:Array = velocityData.constant;
					velocity = GradientVelocity.createByConstant(new Vector3(constantData[0], constantData[1], constantData[2]));
					break;
				case 1: 
					velocity = GradientVelocity.createByGradient(_initParticleVelocity(velocityData.gradientX), _initParticleVelocity(velocityData.gradientY), _initParticleVelocity(velocityData.gradientZ));
					break;
				case 2: 
					var constantMinData:Array = velocityData.constantMin;
					var constantMaxData:Array = velocityData.constantMax;
					velocity = GradientVelocity.createByRandomTwoConstant(new Vector3(constantMinData[0], constantMinData[1], constantMinData[2]), new Vector3(constantMaxData[0], constantMaxData[1], constantMaxData[2]));
					break;
				case 3: 
					velocity = GradientVelocity.createByRandomTwoGradient(_initParticleVelocity(velocityData.gradientXMin), _initParticleVelocity(velocityData.gradientXMax), _initParticleVelocity(velocityData.gradientYMin), _initParticleVelocity(velocityData.gradientYMax), _initParticleVelocity(velocityData.gradientZMin), _initParticleVelocity(velocityData.gradientZMax));
					break;
				}
				var velocityOverLifetime:VelocityOverLifetime = new VelocityOverLifetime(velocity);
				velocityOverLifetime.space = velocityOverLifetimeData.space;
				velocityOverLifetime.enbale = velocityOverLifetimeData.enable;
				particleSystem.velocityOverLifetime = velocityOverLifetime;
			}
			
			//ColorOverLifetime
			var colorOverLifetimeData:Object = customProps.colorOverLifetime;
			if (colorOverLifetimeData) {
				var colorData:Object = colorOverLifetimeData.color;
				var color:GradientColor;
				switch (colorData.type) {
				case 0: 
					var constColorData:Array = colorData.constant;
					color = GradientColor.createByConstant(new Vector4(constColorData[0], constColorData[1], constColorData[2], constColorData[3]));
					break;
				case 1: 
					color = GradientColor.createByGradient(_initParticleColor(colorData.gradient));
					break;
				case 2: 
					var minConstColorData:Array = colorData.constantMin;
					var maxConstColorData:Array = colorData.constantMax;
					color = GradientColor.createByRandomTwoConstant(new Vector4(minConstColorData[0], minConstColorData[1], minConstColorData[2], minConstColorData[3]), new Vector4(maxConstColorData[0], maxConstColorData[1], maxConstColorData[2], maxConstColorData[3]));
					break;
				case 3: 
					color = GradientColor.createByRandomTwoGradient(_initParticleColor(colorData.gradientMin), _initParticleColor(colorData.gradientMax));
					break;
				}
				var colorOverLifetime:ColorOverLifetime = new ColorOverLifetime(color);
				colorOverLifetime.enbale = colorOverLifetimeData.enable;
				particleSystem.colorOverLifetime = colorOverLifetime;
			}
			
			//SizeOverLifetime
			var sizeOverLifetimeData:Object = customProps.sizeOverLifetime;
			if (sizeOverLifetimeData) {
				var sizeData:Object = sizeOverLifetimeData.size;
				var size:GradientSize;
				switch (sizeData.type) {
				case 0: 
					if (sizeData.separateAxes) {
						size = GradientSize.createByGradientSeparate(_initParticleSize(sizeData.gradientX), _initParticleSize(sizeData.gradientY), _initParticleSize(sizeData.gradientZ));
					} else {
						size = GradientSize.createByGradient(_initParticleSize(sizeData.gradient));
					}
					break;
				case 1: 
					if (sizeData.separateAxes) {
						var constantMinSeparateData:Array = sizeData.constantMinSeparate;
						var constantMaxSeparateData:Array = sizeData.constantMaxSeparate;
						size = GradientSize.createByRandomTwoConstantSeparate(new Vector3(constantMinSeparateData[0], constantMinSeparateData[1], constantMinSeparateData[2]), new Vector3(constantMaxSeparateData[0], constantMaxSeparateData[1], constantMaxSeparateData[2]));
					} else {
						size = GradientSize.createByRandomTwoConstant(sizeData.constantMin, sizeData.constantMax);
					}
					break;
				case 2: 
					if (sizeData.separateAxes) {
						size = GradientSize.createByRandomTwoGradientSeparate(_initParticleSize(sizeData.gradientXMin), _initParticleSize(sizeData.gradientYMin), _initParticleSize(sizeData.gradientZMin), _initParticleSize(sizeData.gradientXMax), _initParticleSize(sizeData.gradientYMax), _initParticleSize(sizeData.gradientZMax));
					} else {
						size = GradientSize.createByRandomTwoGradient(_initParticleSize(sizeData.gradientMin), _initParticleSize(sizeData.gradientMax));
					}
					break;
				}
				var sizeOverLifetime:SizeOverLifetime = new SizeOverLifetime(size);
				sizeOverLifetime.enbale = sizeOverLifetimeData.enable;
				particleSystem.sizeOverLifetime = sizeOverLifetime;
			}
			
			//RotationOverLifetime
			var rotationOverLifetimeData:Object = customProps.rotationOverLifetime;
			if (rotationOverLifetimeData) {
				var angularVelocityData:Object = rotationOverLifetimeData.angularVelocity;
				var angularVelocity:GradientAngularVelocity;
				switch (angularVelocityData.type) {
				case 0: 
					if (angularVelocityData.separateAxes) {
						//TODO:待补充
					} else {
						angularVelocity = GradientAngularVelocity.createByConstant(angularVelocityData.constant * anglelToRad);
					}
					break;
				case 1: 
					if (angularVelocityData.separateAxes) {
						//TODO:待补充
					} else {
						angularVelocity = GradientAngularVelocity.createByGradient(_initParticleRotation(angularVelocityData.gradient));
					}
					break;
				case 2: 
					if (angularVelocityData.separateAxes) {
						var minSep:Array = angularVelocityData.constantMinSeparate;//TODO:Y是否要取负数
						var maxSep:Array = angularVelocityData.constantMaxSeparate;//TODO:Y是否要取负数
						angularVelocity = GradientAngularVelocity.createByRandomTwoConstantSeparate(new Vector3(minSep[0]*anglelToRad,minSep[1]*anglelToRad,minSep[2]*anglelToRad),new Vector3(maxSep[0]*anglelToRad,maxSep[1]*anglelToRad,maxSep[2]*anglelToRad));
					} else {
						angularVelocity = GradientAngularVelocity.createByRandomTwoConstant(angularVelocityData.constantMin * anglelToRad, angularVelocityData.constantMax * anglelToRad);
					}
					break;
				case 3: 
					if (angularVelocityData.separateAxes) {
						//TODO:待补充
					} else {
						angularVelocity = GradientAngularVelocity.createByRandomTwoGradient(_initParticleRotation(angularVelocityData.gradientMin), _initParticleRotation(angularVelocityData.gradientMax));
					}
					break;
				}
				var rotationOverLifetime:RotationOverLifetime = new RotationOverLifetime(angularVelocity);
				rotationOverLifetime.enbale = rotationOverLifetimeData.enable;
				particleSystem.rotationOverLifetime = rotationOverLifetime;
			}
			
			//TextureSheetAnimation
			var textureSheetAnimationData:Object = customProps.textureSheetAnimation;
			if (textureSheetAnimationData) {
				var frameData:Object = textureSheetAnimationData.frame;
				var frameOverTime:FrameOverTime;
				switch (frameData.type) {
				case 0: 
					frameOverTime = FrameOverTime.createByConstant(frameData.constant);
					break;
				case 1: 
					frameOverTime = FrameOverTime.createByOverTime(_initParticleFrame(frameData.overTime));
					break;
				case 2: 
					frameOverTime = FrameOverTime.createByRandomTwoConstant(frameData.constantMin, frameData.constantMax);
					break;
				case 3: 
					frameOverTime = FrameOverTime.createByRandomTwoOverTime(_initParticleFrame(frameData.overTimeMin), _initParticleFrame(frameData.overTimeMax));
					break;
				}
				var startFrameData:Object = textureSheetAnimationData.startFrame;
				var startFrame:StartFrame;
				switch (startFrameData.type) {
				case 0: 
					startFrame = StartFrame.createByConstant(startFrameData.constant);
					break;
				case 1: 
					startFrame = StartFrame.createByRandomTwoConstant(startFrameData.constantMin, startFrameData.constantMax);
					break;
				}
				var textureSheetAnimation:TextureSheetAnimation = new TextureSheetAnimation(frameOverTime, startFrame);
				textureSheetAnimation.enable = textureSheetAnimationData.enable;
				var tilesData:Array = textureSheetAnimationData.tiles;
				textureSheetAnimation.tiles = new Vector2(tilesData[0], tilesData[1]);
				textureSheetAnimation.type = textureSheetAnimationData.type;
				textureSheetAnimation.randomRow = textureSheetAnimationData.randomRow;
				var rowIndex:* = textureSheetAnimationData.rowIndex;
				(rowIndex !== undefined) && (textureSheetAnimation.rowIndex = rowIndex);
				textureSheetAnimation.cycles = textureSheetAnimationData.cycles;
				particleSystem.textureSheetAnimation = textureSheetAnimation;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _activeHierarchy():void {
			super._activeHierarchy();
			(particleSystem.playOnAwake) && (particleSystem.play());
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _inActiveHierarchy():void {
			super._inActiveHierarchy();
			(particleSystem.isAlive) && (particleSystem.simulate(0, true));
		}
		
		/**
		 * @private
		 */
		override public function cloneTo(destObject:*):void {
			var destShuriKenParticle3D:ShuriKenParticle3D = destObject as ShuriKenParticle3D;
			var destParticleSystem:ShurikenParticleSystem = destShuriKenParticle3D._geometryFilter as ShurikenParticleSystem;
			(_geometryFilter as ShurikenParticleSystem).cloneTo(destParticleSystem);
			var destParticleRender:ShurikenParticleRender = destShuriKenParticle3D._render as ShurikenParticleRender;
			var particleRender:ShurikenParticleRender = _render as ShurikenParticleRender;
			destParticleRender.sharedMaterials = particleRender.sharedMaterials;
			destParticleRender.enable = particleRender.enable;
			destParticleRender.renderMode = particleRender.renderMode;
			destParticleRender.mesh = particleRender.mesh;
			destParticleRender.stretchedBillboardCameraSpeedScale = particleRender.stretchedBillboardCameraSpeedScale;
			destParticleRender.stretchedBillboardSpeedScale = particleRender.stretchedBillboardSpeedScale;
			destParticleRender.stretchedBillboardLengthScale = particleRender.stretchedBillboardLengthScale;
			destParticleRender.sortingFudge = particleRender.sortingFudge;
			super.cloneTo(destObject);//父类函数在最后,组件应该最后赋值，否则获取材质默认值等相关函数会有问题
		}
		
		/**
		 * <p>销毁此对象。</p>
		 * @param	destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
			super.destroy(destroyChild);
			(_geometryFilter as ShurikenParticleSystem)._destroy();
			_geometryFilter = null;
		}
	
	}

}