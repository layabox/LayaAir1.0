package laya.d3.core.particleShuriKen {
	import laya.components.Component;
	import laya.d3.core.Gradient;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.particleShuriKen.module.Burst;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.Emission;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.GradientAngularVelocity;
	import laya.d3.core.particleShuriKen.module.GradientColor;
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
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.Color;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderDefines;
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
		
		//Base
		public static var WORLDPOSITION:int = Shader3D.propertyNameToID("u_WorldPosition");
		public static var WORLDROTATION:int= Shader3D.propertyNameToID("u_WorldRotation");
		public static var POSITIONSCALE:int= Shader3D.propertyNameToID("u_PositionScale");
		public static var SIZESCALE:int= Shader3D.propertyNameToID("u_SizeScale");
		public static var SCALINGMODE:int= Shader3D.propertyNameToID("u_ScalingMode");
		public static var GRAVITY:int= Shader3D.propertyNameToID("u_Gravity");
		public static var THREEDSTARTROTATION:int= Shader3D.propertyNameToID("u_ThreeDStartRotation");
		public static var STRETCHEDBILLBOARDLENGTHSCALE:int= Shader3D.propertyNameToID("u_StretchedBillboardLengthScale");
		public static var STRETCHEDBILLBOARDSPEEDSCALE:int= Shader3D.propertyNameToID("u_StretchedBillboardSpeedScale");
		public static var SIMULATIONSPACE:int= Shader3D.propertyNameToID("u_SimulationSpace");
		public static var CURRENTTIME:int= Shader3D.propertyNameToID("u_CurrentTime");
		
		//VelocityOverLifetime
		public static var VOLVELOCITYCONST:int= Shader3D.propertyNameToID("u_VOLVelocityConst");
		public static var VOLVELOCITYGRADIENTX:int= Shader3D.propertyNameToID("u_VOLVelocityGradientX");
		public static var VOLVELOCITYGRADIENTY:int= Shader3D.propertyNameToID("u_VOLVelocityGradientY");
		public static var VOLVELOCITYGRADIENTZ:int= Shader3D.propertyNameToID("u_VOLVelocityGradientZ");
		public static var VOLVELOCITYCONSTMAX:int= Shader3D.propertyNameToID("u_VOLVelocityConstMax");
		public static var VOLVELOCITYGRADIENTXMAX:int= Shader3D.propertyNameToID("u_VOLVelocityGradientMaxX");
		public static var VOLVELOCITYGRADIENTYMAX:int= Shader3D.propertyNameToID("u_VOLVelocityGradientMaxY");
		public static var VOLVELOCITYGRADIENTZMAX:int= Shader3D.propertyNameToID("u_VOLVelocityGradientMaxZ");
		public static var VOLSPACETYPE:int= Shader3D.propertyNameToID("u_VOLSpaceType");
		
		//ColorOverLifetime
		public static var COLOROVERLIFEGRADIENTALPHAS:int= Shader3D.propertyNameToID("u_ColorOverLifeGradientAlphas");
		public static var COLOROVERLIFEGRADIENTCOLORS:int= Shader3D.propertyNameToID("u_ColorOverLifeGradientColors");
		public static var MAXCOLOROVERLIFEGRADIENTALPHAS:int= Shader3D.propertyNameToID("u_MaxColorOverLifeGradientAlphas");
		public static var MAXCOLOROVERLIFEGRADIENTCOLORS:int= Shader3D.propertyNameToID("u_MaxColorOverLifeGradientColors");
	
		//SizeOverLifetime
		public static var SOLSIZEGRADIENT:int= Shader3D.propertyNameToID("u_SOLSizeGradient");
		public static var SOLSIZEGRADIENTX:int= Shader3D.propertyNameToID("u_SOLSizeGradientX");
		public static var SOLSIZEGRADIENTY:int= Shader3D.propertyNameToID("u_SOLSizeGradientY");
		public static var SOLSizeGradientZ:int= Shader3D.propertyNameToID("u_SOLSizeGradientZ");
		public static var SOLSizeGradientMax:int= Shader3D.propertyNameToID("u_SOLSizeGradientMax");
		public static var SOLSIZEGRADIENTXMAX:int= Shader3D.propertyNameToID("u_SOLSizeGradientMaxX");
		public static var SOLSIZEGRADIENTYMAX:int= Shader3D.propertyNameToID("u_SOLSizeGradientMaxY");
		public static var SOLSizeGradientZMAX:int= Shader3D.propertyNameToID("u_SOLSizeGradientMaxZ");
		
		//RotationOverLifetime
		public static var ROLANGULARVELOCITYCONST:int= Shader3D.propertyNameToID("u_ROLAngularVelocityConst");
		public static var ROLANGULARVELOCITYCONSTSEPRARATE:int= Shader3D.propertyNameToID("u_ROLAngularVelocityConstSeprarate");
		public static var ROLANGULARVELOCITYGRADIENT:int= Shader3D.propertyNameToID("u_ROLAngularVelocityGradient");
		public static var ROLANGULARVELOCITYGRADIENTX:int= Shader3D.propertyNameToID("u_ROLAngularVelocityGradientX");
		public static var ROLANGULARVELOCITYGRADIENTY:int= Shader3D.propertyNameToID("u_ROLAngularVelocityGradientY");
		public static var ROLANGULARVELOCITYGRADIENTZ:int= Shader3D.propertyNameToID("u_ROLAngularVelocityGradientZ");
		public static var ROLANGULARVELOCITYCONSTMAX:int= Shader3D.propertyNameToID("u_ROLAngularVelocityConstMax");
		public static var ROLANGULARVELOCITYCONSTMAXSEPRARATE:int= Shader3D.propertyNameToID("u_ROLAngularVelocityConstMaxSeprarate");
		public static var ROLANGULARVELOCITYGRADIENTMAX:int= Shader3D.propertyNameToID("u_ROLAngularVelocityGradientMax");
		public static var ROLANGULARVELOCITYGRADIENTXMAX:int= Shader3D.propertyNameToID("u_ROLAngularVelocityGradientMaxX");
		public static var ROLANGULARVELOCITYGRADIENTYMAX:int= Shader3D.propertyNameToID("u_ROLAngularVelocityGradientMaxY");
		public static var ROLANGULARVELOCITYGRADIENTZMAX:int= Shader3D.propertyNameToID("u_ROLAngularVelocityGradientMaxZ");
		public static var ROLANGULARVELOCITYGRADIENTWMAX:int= Shader3D.propertyNameToID("u_ROLAngularVelocityGradientMaxW");
		
		//TextureSheetAnimation
		public static var TEXTURESHEETANIMATIONCYCLES:int= Shader3D.propertyNameToID("u_TSACycles");
		public static var TEXTURESHEETANIMATIONSUBUVLENGTH:int= Shader3D.propertyNameToID("u_TSASubUVLength");
		public static var TEXTURESHEETANIMATIONGRADIENTUVS:int= Shader3D.propertyNameToID("u_TSAGradientUVs");
		public static var TEXTURESHEETANIMATIONGRADIENTMAXUVS:int= Shader3D.propertyNameToID("u_TSAMaxGradientUVs");
		
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
			SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS = shaderDefines.registerDefine("ROTATIONOVERLIFETIMERANDOMCONSTANTS");
			SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES = shaderDefines.registerDefine("ROTATIONOVERLIFETIMERANDOMCURVES");
			SHADERDEFINE_SIZEOVERLIFETIMECURVE = shaderDefines.registerDefine("SIZEOVERLIFETIMECURVE");
			SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE = shaderDefines.registerDefine("SIZEOVERLIFETIMECURVESEPERATE");
			SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES = shaderDefines.registerDefine("SIZEOVERLIFETIMERANDOMCURVES");
			SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE = shaderDefines.registerDefine("SIZEOVERLIFETIMERANDOMCURVESSEPERATE");
			SHADERDEFINE_RENDERMODE_MESH = shaderDefines.registerDefine("RENDERMODE_MESH");
			SHADERDEFINE_SHAPE = shaderDefines.registerDefine("SHAPE");
		}
		
		/** @private */
		private var _particleSystem:ShurikenParticleSystem;
		
		/**
		 * 获取粒子系统。
		 * @return  粒子系统。
		 */
		public function get particleSystem():ShurikenParticleSystem {
			return _particleSystem;
		}
		
		/**
		 * 获取粒子渲染器。
		 * @return  粒子渲染器。
		 */
		public function get particleRenderer():ShurikenParticleRenderer {
			return _render as ShurikenParticleRenderer;
		}
		
		/**
		 * 创建一个 <code>Particle3D</code> 实例。
		 * @param settings value 粒子配置。
		 */
		public function ShuriKenParticle3D() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(null);
			_render = new ShurikenParticleRenderer(this);
			
			_particleSystem = new ShurikenParticleSystem(this);
			
			var elements:Vector.<RenderElement> = _render._renderElements;
			var element:RenderElement = elements[0] = new RenderElement();
			element.setTransform(_transform);
			element.render = _render;
			element.setGeometry(_particleSystem);
			element.material = ShurikenParticleMaterial.defaultMaterial;
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
			return gradient
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
		private function _initParticleColor(gradientColorData:Object):Gradient {
			var gradientColor:Gradient = new Gradient(4, 4);
			var alphasData:Array = gradientColorData.alphas;
			var i:int, n:int;
			for (i = 0, n = alphasData.length; i < n; i++) {
				var alphaData:Object = alphasData[i];
				if ((i === 3) && ((alphaData.key !== 1))) {
					alphaData.key = 1;
					console.log("GradientDataColor warning:the forth key is  be force set to 1.");
				}
				gradientColor.addColorAlpha(alphaData.key, alphaData.value);
			}
			var rgbsData:Array = gradientColorData.rgbs;
			for (i = 0, n = rgbsData.length; i < n; i++) {
				var rgbData:Object = rgbsData[i];
				var rgbValue:Array = rgbData.value;
				
				if ((i === 3) && ((rgbData.key !== 1))) {
					rgbData.key = 1;
					console.log("GradientDataColor warning:the forth key is  be force set to 1.");
				}
				gradientColor.addColorRGB(rgbData.key, new Color(rgbValue[0], rgbValue[1], rgbValue[2], 1.0));
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
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			super._parse(data);
			const anglelToRad:Number = Math.PI / 180.0;
			var i:int, n:int;
			
			//Render
			var particleRender:ShurikenParticleRenderer = this.particleRenderer;
			var material:ShurikenParticleMaterial;
			
			var materialData:Object = data.material;
			(materialData) && (material = Loader.getRes(materialData.path));
			
			particleRender.sharedMaterial = material;
			var meshPath:String = data.meshPath;
			(meshPath) && (particleRender.mesh = Loader.getRes(meshPath));
			
			particleRender.renderMode = data.renderMode;
			particleRender.stretchedBillboardCameraSpeedScale = data.stretchedBillboardCameraSpeedScale;
			particleRender.stretchedBillboardSpeedScale = data.stretchedBillboardSpeedScale;
			particleRender.stretchedBillboardLengthScale = data.stretchedBillboardLengthScale;
			particleRender.sortingFudge = data.sortingFudge ? data.sortingFudge : 0.0;
			
			//particleSystem
			var particleSystem:ShurikenParticleSystem = this.particleSystem;
			particleSystem.isPerformanceMode = data.isPerformanceMode;
			
			particleSystem.duration = data.duration;
			particleSystem.looping = data.looping;
			particleSystem.prewarm = data.prewarm;
			
			particleSystem.startDelayType = data.startDelayType;
			particleSystem.startDelay = data.startDelay;
			particleSystem.startDelayMin = data.startDelayMin;
			particleSystem.startDelayMax = data.startDelayMax;
			
			particleSystem.startLifetimeType = data.startLifetimeType;
			particleSystem.startLifetimeConstant = data.startLifetimeConstant;
			particleSystem.startLifeTimeGradient = _initStartLife(data.startLifetimeGradient);
			particleSystem.startLifetimeConstantMin = data.startLifetimeConstantMin;
			particleSystem.startLifetimeConstantMax = data.startLifetimeConstantMax;
			particleSystem.startLifeTimeGradientMin = _initStartLife(data.startLifetimeGradientMin);
			particleSystem.startLifeTimeGradientMax = _initStartLife(data.startLifetimeGradientMax);
			
			particleSystem.startSpeedType = data.startSpeedType;
			particleSystem.startSpeedConstant = data.startSpeedConstant;
			particleSystem.startSpeedConstantMin = data.startSpeedConstantMin;
			particleSystem.startSpeedConstantMax = data.startSpeedConstantMax;
			
			particleSystem.threeDStartSize = data.threeDStartSize;
			particleSystem.startSizeType = data.startSizeType;
			particleSystem.startSizeConstant = data.startSizeConstant;
			var startSizeConstantSeparateArray:Array = data.startSizeConstantSeparate;
			var startSizeConstantSeparateElement:Vector3 = particleSystem.startSizeConstantSeparate;
			startSizeConstantSeparateElement.x = startSizeConstantSeparateArray[0];
			startSizeConstantSeparateElement.y = startSizeConstantSeparateArray[1];
			startSizeConstantSeparateElement.z = startSizeConstantSeparateArray[2];
			particleSystem.startSizeConstantMin = data.startSizeConstantMin;
			particleSystem.startSizeConstantMax = data.startSizeConstantMax;
			var startSizeConstantMinSeparateArray:Array = data.startSizeConstantMinSeparate;
			var startSizeConstantMinSeparateElement:Vector3 = particleSystem.startSizeConstantMinSeparate;
			startSizeConstantMinSeparateElement.x = startSizeConstantMinSeparateArray[0];
			startSizeConstantMinSeparateElement.y = startSizeConstantMinSeparateArray[1];
			startSizeConstantMinSeparateElement.z = startSizeConstantMinSeparateArray[2];
			var startSizeConstantMaxSeparateArray:Array = data.startSizeConstantMaxSeparate;
			var startSizeConstantMaxSeparateElement:Vector3 = particleSystem.startSizeConstantMaxSeparate;
			startSizeConstantMaxSeparateElement.x = startSizeConstantMaxSeparateArray[0];
			startSizeConstantMaxSeparateElement.y = startSizeConstantMaxSeparateArray[1];
			startSizeConstantMaxSeparateElement.z = startSizeConstantMaxSeparateArray[2];
			
			particleSystem.threeDStartRotation = data.threeDStartRotation;
			particleSystem.startRotationType = data.startRotationType;
			particleSystem.startRotationConstant = data.startRotationConstant * anglelToRad;
			var startRotationConstantSeparateArray:Array = data.startRotationConstantSeparate;
			var startRotationConstantSeparateElement:Vector3 = particleSystem.startRotationConstantSeparate;
			startRotationConstantSeparateElement.x = startRotationConstantSeparateArray[0] * anglelToRad;
			startRotationConstantSeparateElement.y = startRotationConstantSeparateArray[1] * anglelToRad;
			startRotationConstantSeparateElement.z = startRotationConstantSeparateArray[2] * anglelToRad;
			particleSystem.startRotationConstantMin = data.startRotationConstantMin * anglelToRad;
			particleSystem.startRotationConstantMax = data.startRotationConstantMax * anglelToRad;
			var startRotationConstantMinSeparateArray:Array = data.startRotationConstantMinSeparate;
			var startRotationConstantMinSeparateElement:Vector3 = particleSystem.startRotationConstantMinSeparate;
			startRotationConstantMinSeparateElement.x = startRotationConstantMinSeparateArray[0] * anglelToRad;
			startRotationConstantMinSeparateElement.y = startRotationConstantMinSeparateArray[1] * anglelToRad;
			startRotationConstantMinSeparateElement.z = startRotationConstantMinSeparateArray[2] * anglelToRad;
			var startRotationConstantMaxSeparateArray:Array = data.startRotationConstantMaxSeparate;
			var startRotationConstantMaxSeparateElement:Vector3 = particleSystem.startRotationConstantMaxSeparate;
			startRotationConstantMaxSeparateElement.x = startRotationConstantMaxSeparateArray[0] * anglelToRad;
			startRotationConstantMaxSeparateElement.y = startRotationConstantMaxSeparateArray[1] * anglelToRad;
			startRotationConstantMaxSeparateElement.z = startRotationConstantMaxSeparateArray[2] * anglelToRad;
			
			particleSystem.randomizeRotationDirection = data.randomizeRotationDirection;
			
			particleSystem.startColorType = data.startColorType;
			var startColorConstantArray:Array = data.startColorConstant;
			var startColorConstantElement:Vector4 = particleSystem.startColorConstant;
			startColorConstantElement.x = startColorConstantArray[0];
			startColorConstantElement.y = startColorConstantArray[1];
			startColorConstantElement.z = startColorConstantArray[2];
			startColorConstantElement.w = startColorConstantArray[3];
			var startColorConstantMinArray:Array = data.startColorConstantMin;
			var startColorConstantMinElement:Vector4 = particleSystem.startColorConstantMin;
			startColorConstantMinElement.x = startColorConstantMinArray[0];
			startColorConstantMinElement.y = startColorConstantMinArray[1];
			startColorConstantMinElement.z = startColorConstantMinArray[2];
			startColorConstantMinElement.w = startColorConstantMinArray[3];
			var startColorConstantMaxArray:Array = data.startColorConstantMax;
			var startColorConstantMaxElement:Vector4 = particleSystem.startColorConstantMax;
			startColorConstantMaxElement.x = startColorConstantMaxArray[0];
			startColorConstantMaxElement.y = startColorConstantMaxArray[1];
			startColorConstantMaxElement.z = startColorConstantMaxArray[2];
			startColorConstantMaxElement.w = startColorConstantMaxArray[3];
			
			particleSystem.gravityModifier = data.gravityModifier;
			
			particleSystem.simulationSpace = data.simulationSpace;
			
			particleSystem.scaleMode = data.scaleMode;
			
			particleSystem.playOnAwake = data.playOnAwake;
			particleSystem.maxParticles = data.maxParticles;
			
			var autoRandomSeed:* = data.autoRandomSeed;
			(autoRandomSeed != null) && (particleSystem.autoRandomSeed = autoRandomSeed);
			var randomSeed:* = data.randomSeed;
			(randomSeed != null) && (particleSystem.randomSeed[0] = randomSeed);
			
			//Emission
			var emissionData:Object = data.emission;
			var emission:Emission = particleSystem.emission;
			if (emissionData) {
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
			var shapeData:Object = data.shape;
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
			var velocityOverLifetimeData:Object = data.velocityOverLifetime;
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
			var colorOverLifetimeData:Object = data.colorOverLifetime;
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
			var sizeOverLifetimeData:Object = data.sizeOverLifetime;
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
			var rotationOverLifetimeData:Object = data.rotationOverLifetime;
			if (rotationOverLifetimeData) {
				var angularVelocityData:Object = rotationOverLifetimeData.angularVelocity;
				var angularVelocity:GradientAngularVelocity;
				switch (angularVelocityData.type) {
				case 0: 
					if (angularVelocityData.separateAxes) {
						var conSep:Array = angularVelocityData.constantSeparate;
						angularVelocity = GradientAngularVelocity.createByConstantSeparate(new Vector3(conSep[0]*anglelToRad,conSep[1]*anglelToRad,conSep[2]*anglelToRad));
					} else {
						angularVelocity = GradientAngularVelocity.createByConstant(angularVelocityData.constant * anglelToRad);
					}
					break;
				case 1: 
					if (angularVelocityData.separateAxes) {
						angularVelocity = GradientAngularVelocity.createByGradientSeparate(_initParticleRotation(angularVelocityData.gradientX),_initParticleRotation(angularVelocityData.gradientY),_initParticleRotation(angularVelocityData.gradientZ));
					} else {
						angularVelocity = GradientAngularVelocity.createByGradient(_initParticleRotation(angularVelocityData.gradient));
					}
					break;
				case 2: 
					if (angularVelocityData.separateAxes) {
						var minSep:Array = angularVelocityData.constantMinSeparate;//TODO:Y是否要取负数
						var maxSep:Array = angularVelocityData.constantMaxSeparate;//TODO:Y是否要取负数
						angularVelocity = GradientAngularVelocity.createByRandomTwoConstantSeparate(new Vector3(minSep[0] * anglelToRad, minSep[1] * anglelToRad, minSep[2] * anglelToRad), new Vector3(maxSep[0] * anglelToRad, maxSep[1] * anglelToRad, maxSep[2] * anglelToRad));
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
			var textureSheetAnimationData:Object = data.textureSheetAnimation;
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
		override public function _activeHierarchy(activeChangeComponents:Array):void {
			super._activeHierarchy(activeChangeComponents);
			(particleSystem.playOnAwake) && (particleSystem.play());
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _inActiveHierarchy(activeChangeComponents:Array):void {
			super._inActiveHierarchy(activeChangeComponents);
			(particleSystem.isAlive) && (particleSystem.simulate(0, true));
		}
		
		/**
		 * @private
		 */
		override public function cloneTo(destObject:*):void {
			var destShuriKenParticle3D:ShuriKenParticle3D = destObject as ShuriKenParticle3D;
			var destParticleSystem:ShurikenParticleSystem = destShuriKenParticle3D._particleSystem;
			_particleSystem.cloneTo(destParticleSystem);
			var destParticleRender:ShurikenParticleRenderer = destShuriKenParticle3D._render as ShurikenParticleRenderer;
			var particleRender:ShurikenParticleRenderer = _render as ShurikenParticleRenderer;
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
			_particleSystem.destroy();
			_particleSystem = null;
		}
	
	}

}