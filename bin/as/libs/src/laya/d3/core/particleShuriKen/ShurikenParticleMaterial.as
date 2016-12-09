package laya.d3.core.particleShuriKen {
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
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderDefines3D;
	import laya.utils.Stat;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShurikenParticleMaterial extends BaseMaterial {
		public static const WORLDPOSITION:String = "WORLDPOSITION";
		public static const WORLDROTATIONMATRIX:String = "WORLDROTATIONMATRIX";
		
		public static const THREEDSTARTROTATION:String = "THREEDSTARTROTATION";
		public static const SCALINGMODE:String = "SCALINGMODE";
		public static const POSITIONSCALE:String = "POSITIONSCALE";
		public static const SIZESCALE:String = "SIZESCALE";
		public static const VIEWMATRIX:String = "MATRIX1";
		public static const PROJECTIONMATRIX:String = "MATRIX2";
		public static const CURRENTTIME:String = "CURRENTTIME";
		public static const GRAVITY:String = "GRAVITY";
		public static const DIFFUSETEXTURE:String = "DIFFUSETEXTURE";
		public static const CAMERADIRECTION:String = "CAMERADIRECTION";
		public static const CAMERAUP:String = "CAMERAUP";
		public static const STRETCHEDBILLBOARDLENGTHSCALE:String = "STRETCHEDBILLBOARDLENGTHSCALE";
		public static const STRETCHEDBILLBOARDSPEEDSCALE:String = "STRETCHEDBILLBOARDSPEEDSCALE";
		public static const SIMULATIONSPACE:String = "SIMULATIONSPACE";
		
		//VelocityOverLifetime
		public static const VOLTYPE:String = "VOLTYPE";
		public static const VOLVELOCITYCONST:String = "VOLVELOCITYCONST";
		public static const VOLVELOCITYGRADIENTX:String = "VOLVELOCITYGRADIENTX";
		public static const VOLVELOCITYGRADIENTY:String = "VOLVELOCITYGRADIENTY";
		public static const VOLVELOCITYGRADIENTZ:String = "VOLVELOCITYGRADIENTZ";
		public static const VOLVELOCITYCONSTMAX:String = "VOLVELOCITYCONSTMAX";
		public static const VOLVELOCITYGRADIENTXMAX:String = "VOLVELOCITYGRADIENTXMAX";
		public static const VOLVELOCITYGRADIENTYMAX:String = "VOLVELOCITYGRADIENTYMAX";
		public static const VOLVELOCITYGRADIENTZMAX:String = "VOLVELOCITYGRADIENTZMAX";
		public static const VOLSPACETYPE:String = "VOLSPACETYPE";
		
		//ColorOverLifetime
		public static const COLOROVERLIFEGRADIENTALPHAS:String = "COLOROVERLIFEGRADIENTALPHAS";
		public static const COLOROVERLIFEGRADIENTCOLORS:String = "COLOROVERLIFEGRADIENTCOLORS";
		public static const MAXCOLOROVERLIFEGRADIENTALPHAS:String = "MAXCOLOROVERLIFEGRADIENTALPHAS";
		public static const MAXCOLOROVERLIFEGRADIENTCOLORS:String = "MAXCOLOROVERLIFEGRADIENTCOLORS";
		
		//SizeOverLifetime
		public static const SOLTYPE:String = "SOLTYPE";
		public static const SOLSEPRARATE:String = "SOLSEPRARATE";
		public static const SOLSIZEGRADIENT:String = "SOLSIZEGRADIENT";
		public static const SOLSIZEGRADIENTX:String = "SOLSIZEGRADIENTX";
		public static const SOLSIZEGRADIENTY:String = "SOLSIZEGRADIENTY";
		public static const SOLSizeGradientZ:String = "SOLSizeGradientZ";
		public static const SOLSizeGradientMax:String = "SOLSizeGradientMax";
		public static const SOLSIZEGRADIENTXMAX:String = "SOLSIZEGRADIENTXMAX";
		public static const SOLSIZEGRADIENTYMAX:String = "SOLSIZEGRADIENTYMAX";
		public static const SOLSizeGradientZMAX:String = "SOLSizeGradientZMAX";
		
		//RotationOverLifetime
		public static const ROLTYPE:String = "ROLTYPE";
		public static const ROLSEPRARATE:String = "ROLSEPRARATE";
		public static const ROLANGULARVELOCITYCONST:String = "ROLANGULARVELOCITYCONST";
		public static const ROLANGULARVELOCITYCONSTSEPRARATE:String = "ROLANGULARVELOCITYCONSTSEPRARATE";
		public static const ROLANGULARVELOCITYGRADIENT:String = "ROLANGULARVELOCITYGRADIENT";
		public static const ROLANGULARVELOCITYGRADIENTX:String = "ROLANGULARVELOCITYGRADIENTX";
		public static const ROLANGULARVELOCITYGRADIENTY:String = "ROLANGULARVELOCITYGRADIENTY";
		public static const ROLANGULARVELOCITYGRADIENTZ:String = "ROLANGULARVELOCITYGRADIENTZ";
		public static const ROLANGULARVELOCITYCONSTMAX:String = "ROLANGULARVELOCITYCONSTMAX";
		public static const ROLANGULARVELOCITYCONSTMAXSEPRARATE:String = "ROLANGULARVELOCITYCONSTMAXSEPRARATE";
		public static const ROLANGULARVELOCITYGRADIENTMAX:String = "ROLANGULARVELOCITYGRADIENTMAX";
		public static const ROLANGULARVELOCITYGRADIENTXMAX:String = "ROLANGULARVELOCITYGRADIENTXMAX";
		public static const ROLANGULARVELOCITYGRADIENTYMAX:String = "ROLANGULARVELOCITYGRADIENTYMAX";
		public static const ROLANGULARVELOCITYGRADIENTZMAX:String = "ROLANGULARVELOCITYGRADIENTZMAX";
		
		//TextureSheetAnimation
		public static const TEXTURESHEETANIMATIONTYPE:String = "TEXTURESHEETANIMATIONTYPE";
		public static const TEXTURESHEETANIMATIONCYCLES:String = "TEXTURESHEETANIMATIONCYCLES";
		public static const TEXTURESHEETANIMATIONSUBUVLENGTH:String = "TEXTURESHEETANIMATIONSUBUVLENGTH";
		public static const TEXTURESHEETANIMATIONGRADIENTUVS:String = "TEXTURESHEETANIMATIONGRADIENTUVS";
		public static const TEXTURESHEETANIMATIONGRADIENTMAXUVS:String = "TEXTURESHEETANIMATIONGRADIENTMAXUVS";
		
		/** @private */
		private static var _tempGravity:Vector3 = new Vector3();
		
		/** @private */
		private var _tempRotationMatrix:Matrix4x4 = new Matrix4x4();
		
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
		
		/** @private */
		private var _uvLength:Vector2 = new Vector2();
		
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
			if (value) {
				_addShaderDefine(ShaderDefines3D.DIFFUSEMAP);
			} else {
				_removeShaderDefine(ShaderDefines3D.DIFFUSEMAP);
			}
			_setTexture(value, _diffuseTextureIndex, DIFFUSETEXTURE);
		}
		
		public function ShurikenParticleMaterial() {
			super();
			setShaderName("PARTICLESHURIKEN");
		}
		
		override public function _setLoopShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
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
			
			var shaderValues:ValusArray = state.shaderValue;
			shaderValues.pushValue(GRAVITY, finalGravityE);

			shaderValues.pushValue(SIMULATIONSPACE, particleSystem.simulationSpace);
			
			switch (particleSystem.simulationSpace) {
			case 0: //World
				shaderValues.pushValue(WORLDPOSITION, Vector3.ZERO.elements);//TODO是否可不传
				break;
			case 1: //Local
				shaderValues.pushValue(WORLDPOSITION, transform.position.elements);
				break;
			default: 
				throw new Error("ShurikenParticleMaterial: SimulationSpace value is invalid.");
			}
			
			Matrix4x4.createFromQuaternion(transform.rotation, _tempRotationMatrix);
			shaderValues.pushValue(WORLDROTATIONMATRIX, _tempRotationMatrix.elements);
		
			shaderValues.pushValue(THREEDSTARTROTATION, particleSystem.threeDStartRotation);
			shaderValues.pushValue(SCALINGMODE, particleSystem.scaleMode);
			switch (particleSystem.scaleMode) {
			case 0: 
				shaderValues.pushValue(POSITIONSCALE, transform.scale.elements);
				shaderValues.pushValue(SIZESCALE, transform.scale.elements);
				break;
			case 1: 
				shaderValues.pushValue(POSITIONSCALE, transform.localScale.elements);
				shaderValues.pushValue(SIZESCALE, transform.localScale.elements);
				break;
			case 2: 
				shaderValues.pushValue(POSITIONSCALE, transform.scale.elements);
				shaderValues.pushValue(SIZESCALE, Vector3.ONE.elements);
				break;
			}
			
			shaderValues.pushValue(CAMERADIRECTION, state.camera.forward.elements);
			shaderValues.pushValue(CAMERAUP, state.camera.up.elements);
			
			shaderValues.pushValue(VIEWMATRIX, state.viewMatrix.elements);//TODO:或许可以合并
			shaderValues.pushValue(PROJECTIONMATRIX, state.projectionMatrix.elements);//TODO:或许可以合并
			
			shaderValues.pushValue(STRETCHEDBILLBOARDLENGTHSCALE, particleRender.stretchedBillboardLengthScale);
			shaderValues.pushValue(STRETCHEDBILLBOARDSPEEDSCALE, particleRender.stretchedBillboardSpeedScale);
			

			//设置粒子的时间参数，可通过此参数停止粒子动画
			shaderValues.pushValue(CURRENTTIME, particleSystem.currentTime);

			
			switch (particleRender.renderMode) {
			case 0: 
				state.shaderDefines.add(ShaderDefines3D.SPHERHBILLBOARD);
				break;
			case 1: 
				state.shaderDefines.add(ShaderDefines3D.STRETCHEDBILLBOARD);
				break;
			case 2: 
				state.shaderDefines.add(ShaderDefines3D.HORIZONTALBILLBOARD);
				break;
			case 3: 
				state.shaderDefines.add(ShaderDefines3D.VERTICALBILLBOARD);
				break;
			}
			
			//velocityOverLifetime
			var velocityOverLifetime:VelocityOverLifetime = particleSystem.velocityOverLifetime;
			if (velocityOverLifetime && velocityOverLifetime.enbale) {
				state.shaderDefines.add(ShaderDefines3D.VELOCITYOVERLIFETIME);
				var velocity:GradientVelocity = velocityOverLifetime.velocity;
				var velocityType:int = velocity.type;
				shaderValues.pushValue(VOLTYPE, velocityType);
				switch (velocityType) {
				case 0: 
					shaderValues.pushValue(VOLVELOCITYCONST, velocity.constant.elements);
					break;
				case 1: 
					shaderValues.pushValue(VOLVELOCITYGRADIENTX, velocity.gradientX._elements);
					shaderValues.pushValue(VOLVELOCITYGRADIENTY, velocity.gradientY._elements);
					shaderValues.pushValue(VOLVELOCITYGRADIENTZ, velocity.gradientZ._elements);
					break;
				case 2: 
					shaderValues.pushValue(VOLVELOCITYCONST, velocity.constantMin.elements);
					shaderValues.pushValue(VOLVELOCITYCONSTMAX, velocity.constantMax.elements);
					break;
				case 3: 
					shaderValues.pushValue(VOLVELOCITYGRADIENTX, velocity.gradientXMin._elements);
					shaderValues.pushValue(VOLVELOCITYGRADIENTXMAX, velocity.gradientXMax._elements);
					shaderValues.pushValue(VOLVELOCITYGRADIENTY, velocity.gradientYMin._elements);
					shaderValues.pushValue(VOLVELOCITYGRADIENTYMAX, velocity.gradientYMax._elements);
					shaderValues.pushValue(VOLVELOCITYGRADIENTZ, velocity.gradientZMin._elements);
					shaderValues.pushValue(VOLVELOCITYGRADIENTZMAX, velocity.gradientZMax._elements);
					break;
				}
				var spaceType:int = velocityOverLifetime.space;
				shaderValues.pushValue(VOLSPACETYPE, spaceType);
			}
			
			//ColorOverLifetime
			var colorOverLifetime:ColorOverLifetime = particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale) {
				var color:GradientColor = colorOverLifetime.color;
				switch (color.type) {
				case 1: 
					state.shaderDefines.add(ShaderDefines3D.COLOROVERLIFETIME);
					var gradientColor:GradientDataColor = color.gradient;
					shaderValues.pushValue(COLOROVERLIFEGRADIENTALPHAS, gradientColor._alphaElements);
					shaderValues.pushValue(COLOROVERLIFEGRADIENTCOLORS, gradientColor._rgbElements);
					break;
				case 3: 
					state.shaderDefines.add(ShaderDefines3D.RANDOMCOLOROVERLIFETIME);
					var minGradientColor:GradientDataColor = color.gradientMin;
					var maxGradientColor:GradientDataColor = color.gradientMax;
					shaderValues.pushValue(COLOROVERLIFEGRADIENTALPHAS, minGradientColor._alphaElements);
					shaderValues.pushValue(COLOROVERLIFEGRADIENTCOLORS, minGradientColor._rgbElements);
					shaderValues.pushValue(MAXCOLOROVERLIFEGRADIENTALPHAS, maxGradientColor._alphaElements);
					shaderValues.pushValue(MAXCOLOROVERLIFEGRADIENTCOLORS, maxGradientColor._rgbElements);
					break;
				}
			}
			
			//SizeOverLifetime
			var sizeOverLifetime:SizeOverLifetime = particleSystem.sizeOverLifetime;
			if (sizeOverLifetime && sizeOverLifetime.enbale) {
				var size:GradientSize = sizeOverLifetime.size;
				var sizeType:int = size.type;
				var sizeSeparate:Boolean;
				switch (sizeType) {
				case 0: 
					sizeSeparate = size.separateAxes;
					state.shaderDefines.add(ShaderDefines3D.SIZEOVERLIFETIME);
					shaderValues.pushValue(SOLTYPE, sizeType);
					shaderValues.pushValue(SOLSEPRARATE, sizeSeparate);
					if (sizeSeparate) {
						shaderValues.pushValue(SOLSIZEGRADIENTX, size.gradientSizeX._elements);
						shaderValues.pushValue(SOLSIZEGRADIENTY, size.gradientSizeY._elements);
						shaderValues.pushValue(SOLSizeGradientZ, size.gradientSizeZ._elements);
					} else {
						shaderValues.pushValue(SOLSIZEGRADIENT, size.gradientSize._elements);
					}
					break;
				case 2: 
					sizeSeparate = size.separateAxes;
					state.shaderDefines.add(ShaderDefines3D.SIZEOVERLIFETIME);
					shaderValues.pushValue(SOLTYPE, sizeType);
					shaderValues.pushValue(SOLSEPRARATE, sizeSeparate);
					if (sizeSeparate) {
						shaderValues.pushValue(SOLSIZEGRADIENTX, size.gradientXMin._elements);
						shaderValues.pushValue(SOLSIZEGRADIENTXMAX, size.gradientXMax._elements);
						shaderValues.pushValue(SOLSIZEGRADIENTY, size.gradientYMin._elements);
						shaderValues.pushValue(SOLSIZEGRADIENTYMAX, size.gradientYMax._elements);
						shaderValues.pushValue(SOLSizeGradientZ, size.gradientZMin._elements);
						shaderValues.pushValue(SOLSizeGradientZMAX, size.gradientZMax._elements);
					} else {
						shaderValues.pushValue(SOLSIZEGRADIENT, size.gradientMin._elements);
						shaderValues.pushValue(SOLSizeGradientMax, size.gradientMax._elements);
					}
					break;
				}
			}
			
			//RotationOverLifetime
			var rotationOverLifetime:RotationOverLifetime = particleSystem.rotationOverLifetime;
			if (rotationOverLifetime && rotationOverLifetime.enbale) {
				state.shaderDefines.add(ShaderDefines3D.ROTATIONOVERLIFETIME);
				var rotation:GradientAngularVelocity = rotationOverLifetime.angularVelocity;
				var rotationType:int = rotation.type;
				var rotationSeparate:Boolean = rotation.separateAxes;
				shaderValues.pushValue(ROLTYPE, rotationType);
				shaderValues.pushValue(ROLSEPRARATE, rotationSeparate);
				switch (rotationType) {
				case 0: 
					if (rotationSeparate) {
						shaderValues.pushValue(ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantSeparate.elements);
					} else {
						shaderValues.pushValue(ROLANGULARVELOCITYCONST, rotation.constant);
					}
					break;
				case 1: 
					if (rotationSeparate) {
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTX, rotation.gradientX._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTY, rotation.gradientY._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZ._elements);
					} else {
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENT, rotation.gradient._elements);
					}
					break;
				case 2: 
					if (rotationSeparate) {
						shaderValues.pushValue(ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantMinSeparate.elements);
						shaderValues.pushValue(ROLANGULARVELOCITYCONSTMAXSEPRARATE, rotation.constantMaxSeparate.elements);
					} else {
						shaderValues.pushValue(ROLANGULARVELOCITYCONST, rotation.constantMin);
						shaderValues.pushValue(ROLANGULARVELOCITYCONSTMAX, rotation.constantMax);
					}
					break;
				case 3: 
					if (rotationSeparate) {
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTX, rotation.gradientXMin._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTXMAX, rotation.gradientXMax._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTY, rotation.gradientYMin._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTYMAX, rotation.gradientYMax._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZMin._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTZMAX, rotation.gradientZMax._elements);
					} else {
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENT, rotation.gradientMin._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTMAX, rotation.gradientMax._elements);
					}
					break;
				}
			}

			//TextureSheetAnimation
			var textureSheetAnimation:TextureSheetAnimation = particleSystem.textureSheetAnimation;
			if (textureSheetAnimation && textureSheetAnimation.enbale) {
				var frameOverTime:FrameOverTime = textureSheetAnimation.frame;
				var textureAniType:int = frameOverTime.type;
				if (textureAniType === 1 || textureAniType === 3) {
					state.shaderDefines.add(ShaderDefines3D.TEXTURESHEETANIMATION);
					shaderValues.pushValue(TEXTURESHEETANIMATIONTYPE, textureAniType);
					shaderValues.pushValue(TEXTURESHEETANIMATIONCYCLES, textureSheetAnimation.cycles);
					var title:Vector2 = textureSheetAnimation.tiles;
					var _uvLengthE:Float32Array = _uvLength.elements;
					_uvLengthE[0] = 1.0 / title.x;
					_uvLengthE[1] = 1.0 / title.y;
					shaderValues.pushValue(TEXTURESHEETANIMATIONSUBUVLENGTH, _uvLength.elements);
				}
				switch (textureAniType) {
				case 1: 
					shaderValues.pushValue(TEXTURESHEETANIMATIONGRADIENTUVS, frameOverTime.frameOverTimeData._elements);
					break;
				case 3: 
					shaderValues.pushValue(TEXTURESHEETANIMATIONGRADIENTUVS, frameOverTime.frameOverTimeDataMin._elements);
					shaderValues.pushValue(TEXTURESHEETANIMATIONGRADIENTMAXUVS, frameOverTime.frameOverTimeDataMax._elements);
					break;
				}
			}
		
		}
	
	}

}