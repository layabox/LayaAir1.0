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
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.shader.ValusArray;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShurikenParticleMaterial extends BaseMaterial {
		//public static const WORLDPOSITION:int = 0;
		//public static const WORLDROTATIONMATRIX:int = 1;
		
		public static const THREEDSTARTROTATION:int = 0;
		public static const SCALINGMODE:int = 1;
		//public static const POSITIONSCALE:int = 4;
		//public static const SIZESCALE:int = 5;
		//public static const VIEWMATRIX:int = 6;
		//public static const PROJECTIONMATRIX:int = 7;
		public static const CURRENTTIME:int = 2;
		public static const GRAVITY:int = 3;
		public static const DIFFUSETEXTURE:int = 4;
		public static const CAMERADIRECTION:int = 5;
		public static const CAMERAUP:int = 6;
		public static const STRETCHEDBILLBOARDLENGTHSCALE:int = 7;
		public static const STRETCHEDBILLBOARDSPEEDSCALE:int = 8;
		public static const SIMULATIONSPACE:int = 9;
		
		//VelocityOverLifetime
		public static const VOLTYPE:int = 10;
		public static const VOLVELOCITYCONST:int = 11;
		public static const VOLVELOCITYGRADIENTX:int = 12;
		public static const VOLVELOCITYGRADIENTY:int = 13;
		public static const VOLVELOCITYGRADIENTZ:int = 14;
		public static const VOLVELOCITYCONSTMAX:int = 15;
		public static const VOLVELOCITYGRADIENTXMAX:int = 16;
		public static const VOLVELOCITYGRADIENTYMAX:int = 17;
		public static const VOLVELOCITYGRADIENTZMAX:int = 18;
		public static const VOLSPACETYPE:int = 19;
		
		//ColorOverLifetime
		public static const COLOROVERLIFEGRADIENTALPHAS:int = 20;
		public static const COLOROVERLIFEGRADIENTCOLORS:int = 21;
		public static const MAXCOLOROVERLIFEGRADIENTALPHAS:int = 22;
		public static const MAXCOLOROVERLIFEGRADIENTCOLORS:int = 23;
		
		//SizeOverLifetime
		public static const SOLTYPE:int = 24;
		public static const SOLSEPRARATE:int = 25;
		public static const SOLSIZEGRADIENT:int = 26;
		public static const SOLSIZEGRADIENTX:int = 27;
		public static const SOLSIZEGRADIENTY:int = 28;
		public static const SOLSizeGradientZ:int = 29;
		public static const SOLSizeGradientMax:int = 30;
		public static const SOLSIZEGRADIENTXMAX:int = 31;
		public static const SOLSIZEGRADIENTYMAX:int = 32;
		public static const SOLSizeGradientZMAX:int = 33;
		
		//RotationOverLifetime
		public static const ROLTYPE:int = 34;
		public static const ROLSEPRARATE:int = 35;
		public static const ROLANGULARVELOCITYCONST:int = 36;
		public static const ROLANGULARVELOCITYCONSTSEPRARATE:int = 37;
		public static const ROLANGULARVELOCITYGRADIENT:int = 38;
		public static const ROLANGULARVELOCITYGRADIENTX:int = 39;
		public static const ROLANGULARVELOCITYGRADIENTY:int = 40;
		public static const ROLANGULARVELOCITYGRADIENTZ:int = 41;
		public static const ROLANGULARVELOCITYCONSTMAX:int = 42;
		public static const ROLANGULARVELOCITYCONSTMAXSEPRARATE:int = 43;
		public static const ROLANGULARVELOCITYGRADIENTMAX:int = 44;
		public static const ROLANGULARVELOCITYGRADIENTXMAX:int = 45;
		public static const ROLANGULARVELOCITYGRADIENTYMAX:int = 46;
		public static const ROLANGULARVELOCITYGRADIENTZMAX:int = 47;
		
		//TextureSheetAnimation
		public static const TEXTURESHEETANIMATIONTYPE:int = 48;
		public static const TEXTURESHEETANIMATIONCYCLES:int = 49;
		public static const TEXTURESHEETANIMATIONSUBUVLENGTH:int = 50;
		public static const TEXTURESHEETANIMATIONGRADIENTUVS:int = 51;
		public static const TEXTURESHEETANIMATIONGRADIENTMAXUVS:int = 52;
		
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
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		public function ShurikenParticleMaterial() {
			super();
			setShaderName("PARTICLESHURIKEN");
		}
		
		override public function _setMaterialShaderDefineParams(owner:Sprite3D, shaderDefine:ShaderDefines3D):void {
			var particle:ShuriKenParticle3D = owner as ShuriKenParticle3D;
			var particleSystem:ShurikenParticleSystem = particle.particleSystem;
			var particleRender:ShurikenParticleRender = particle.particleRender;
			
			switch (particleRender.renderMode) {
			case 0: 
				shaderDefine.add(ShaderDefines3D.SPHERHBILLBOARD);
				break;
			case 1: 
				shaderDefine.add(ShaderDefines3D.STRETCHEDBILLBOARD);
				break;
			case 2: 
				shaderDefine.add(ShaderDefines3D.HORIZONTALBILLBOARD);
				break;
			case 3: 
				shaderDefine.add(ShaderDefines3D.VERTICALBILLBOARD);
				break;
			}
			
			//velocityOverLifetime
			var velocityOverLifetime:VelocityOverLifetime = particleSystem.velocityOverLifetime;
			if (velocityOverLifetime && velocityOverLifetime.enbale) {
				shaderDefine.add(ShaderDefines3D.VELOCITYOVERLIFETIME);
			}
			
			//ColorOverLifetime
			var colorOverLifetime:ColorOverLifetime = particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale) {
				var color:GradientColor = colorOverLifetime.color;
				switch (color.type) {
				case 1: 
					shaderDefine.add(ShaderDefines3D.COLOROVERLIFETIME);
					break;
				case 3: 
					shaderDefine.add(ShaderDefines3D.RANDOMCOLOROVERLIFETIME);
					break;
				}
			}
			
			//SizeOverLifetime
			var sizeOverLifetime:SizeOverLifetime = particleSystem.sizeOverLifetime;
			if (sizeOverLifetime && sizeOverLifetime.enbale) {
				var size:GradientSize = sizeOverLifetime.size;
				var sizeType:int = size.type;
				switch (sizeType) {
				case 0: 
					shaderDefine.add(ShaderDefines3D.SIZEOVERLIFETIME);
					break;
				case 2: 
					shaderDefine.add(ShaderDefines3D.SIZEOVERLIFETIME);
					break;
				}
			}
			
			//RotationOverLifetime
			var rotationOverLifetime:RotationOverLifetime = particleSystem.rotationOverLifetime;
			if (rotationOverLifetime && rotationOverLifetime.enbale) {
				shaderDefine.add(ShaderDefines3D.ROTATIONOVERLIFETIME);
			}
			
			//TextureSheetAnimation
			var textureSheetAnimation:TextureSheetAnimation = particleSystem.textureSheetAnimation;
			if (textureSheetAnimation && textureSheetAnimation.enbale) {
				var frameOverTime:FrameOverTime = textureSheetAnimation.frame;
				var textureAniType:int = frameOverTime.type;
				if (textureAniType === 1 || textureAniType === 3) {
					shaderDefine.add(ShaderDefines3D.TEXTURESHEETANIMATION);
				}
			}
		}
		
		override public function _setMaterialShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
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
			
			debugger;
			_setBuffer(GRAVITY, finalGravityE);
			
			_setInt(SIMULATIONSPACE, particleSystem.simulationSpace);
			
			//switch (particleSystem.simulationSpace) {
			//case 0: //World
				//_setColor(WORLDPOSITION, Vector3.ZERO);//TODO是否可不传
				//break;
			//case 1: //Local
				//_setColor(WORLDPOSITION, transform.position);
				//break;
			//default: 
				//throw new Error("ShurikenParticleMaterial: SimulationSpace value is invalid.");
			//}
			
			//Matrix4x4.createFromQuaternion(transform.rotation, _tempRotationMatrix);
			//_setMatrix4x4(WORLDROTATIONMATRIX, _tempRotationMatrix);
			
			_setBool(THREEDSTARTROTATION, particleSystem.threeDStartRotation);
			_setInt(SCALINGMODE, particleSystem.scaleMode);
			//switch (particleSystem.scaleMode) {
			//case 0: 
				//_setColor(POSITIONSCALE, transform.scale);
				//_setColor(SIZESCALE, transform.scale);
				//break;
			//case 1: 
				//_setColor(POSITIONSCALE, transform.localScale);
				//_setColor(SIZESCALE, transform.localScale);
				//break;
			//case 2: 
				//_setColor(POSITIONSCALE, transform.scale);
				//_setColor(SIZESCALE, Vector3.ONE);
				//break;
			//}
			
			_setColor(CAMERADIRECTION, state.camera.forward);
			_setColor(CAMERAUP, state.camera.up);
			
			//_setMatrix4x4(VIEWMATRIX, state.viewMatrix);//TODO:或许可以合并
			//_setMatrix4x4(PROJECTIONMATRIX, state.projectionMatrix);//TODO:或许可以合并
			
			_setInt(STRETCHEDBILLBOARDLENGTHSCALE, particleRender.stretchedBillboardLengthScale);
			_setInt(STRETCHEDBILLBOARDSPEEDSCALE, particleRender.stretchedBillboardSpeedScale);
			
			//设置粒子的时间参数，可通过此参数停止粒子动画
			_setNumber(CURRENTTIME, particleSystem.currentTime);
			
			//switch (particleRender.renderMode) {
			//case 0: 
			//state.shaderDefines.add(ShaderDefines3D.SPHERHBILLBOARD);
			//break;
			//case 1: 
			//state.shaderDefines.add(ShaderDefines3D.STRETCHEDBILLBOARD);
			//break;
			//case 2: 
			//state.shaderDefines.add(ShaderDefines3D.HORIZONTALBILLBOARD);
			//break;
			//case 3: 
			//state.shaderDefines.add(ShaderDefines3D.VERTICALBILLBOARD);
			//break;
			//}
			
			//velocityOverLifetime
			var velocityOverLifetime:VelocityOverLifetime = particleSystem.velocityOverLifetime;
			if (velocityOverLifetime && velocityOverLifetime.enbale) {
				//state.shaderDefines.add(ShaderDefines3D.VELOCITYOVERLIFETIME);
				var velocity:GradientVelocity = velocityOverLifetime.velocity;
				var velocityType:int = velocity.type;
				_setInt(VOLTYPE, velocityType);
				switch (velocityType) {
				case 0: 
					_setColor(VOLVELOCITYCONST, velocity.constant);
					break;
				case 1: 
					_setBuffer(VOLVELOCITYGRADIENTX, velocity.gradientX._elements);
					_setBuffer(VOLVELOCITYGRADIENTY, velocity.gradientY._elements);
					_setBuffer(VOLVELOCITYGRADIENTZ, velocity.gradientZ._elements);
					break;
				case 2: 
					_setColor(VOLVELOCITYCONST, velocity.constantMin);
					_setColor(VOLVELOCITYCONSTMAX, velocity.constantMax);
					break;
				case 3: 
					_setBuffer(VOLVELOCITYGRADIENTX, velocity.gradientXMin._elements);
					_setBuffer(VOLVELOCITYGRADIENTXMAX, velocity.gradientXMax._elements);
					_setBuffer(VOLVELOCITYGRADIENTY, velocity.gradientYMin._elements);
					_setBuffer(VOLVELOCITYGRADIENTYMAX, velocity.gradientYMax._elements);
					_setBuffer(VOLVELOCITYGRADIENTZ, velocity.gradientZMin._elements);
					_setBuffer(VOLVELOCITYGRADIENTZMAX, velocity.gradientZMax._elements);
					break;
				}
				var spaceType:int = velocityOverLifetime.space;
				_setInt(VOLSPACETYPE, spaceType);
			}
			
			//ColorOverLifetime
			var colorOverLifetime:ColorOverLifetime = particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale) {
				var color:GradientColor = colorOverLifetime.color;
				switch (color.type) {
				case 1: 
					//state.shaderDefines.add(ShaderDefines3D.COLOROVERLIFETIME);
					var gradientColor:GradientDataColor = color.gradient;
					_setBuffer(COLOROVERLIFEGRADIENTALPHAS, gradientColor._alphaElements);
					_setBuffer(COLOROVERLIFEGRADIENTCOLORS, gradientColor._rgbElements);
					break;
				case 3: 
					//state.shaderDefines.add(ShaderDefines3D.RANDOMCOLOROVERLIFETIME);
					var minGradientColor:GradientDataColor = color.gradientMin;
					var maxGradientColor:GradientDataColor = color.gradientMax;
					_setBuffer(COLOROVERLIFEGRADIENTALPHAS, minGradientColor._alphaElements);
					_setBuffer(COLOROVERLIFEGRADIENTCOLORS, minGradientColor._rgbElements);
					_setBuffer(MAXCOLOROVERLIFEGRADIENTALPHAS, maxGradientColor._alphaElements);
					_setBuffer(MAXCOLOROVERLIFEGRADIENTCOLORS, maxGradientColor._rgbElements);
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
					//state.shaderDefines.add(ShaderDefines3D.SIZEOVERLIFETIME);
					_setInt(SOLTYPE, sizeType);
					_setBool(SOLSEPRARATE, sizeSeparate);
					if (sizeSeparate) {
						_setBuffer(SOLSIZEGRADIENTX, size.gradientX._elements);
						_setBuffer(SOLSIZEGRADIENTY, size.gradientY._elements);
						_setBuffer(SOLSizeGradientZ, size.gradientZ._elements);
					} else {
						_setBuffer(SOLSIZEGRADIENT, size.gradient._elements);
					}
					break;
				case 2: 
					sizeSeparate = size.separateAxes;
					//state.shaderDefines.add(ShaderDefines3D.SIZEOVERLIFETIME);
					_setInt(SOLTYPE, sizeType);
					_setBool(SOLSEPRARATE, sizeSeparate);
					if (sizeSeparate) {
						_setBuffer(SOLSIZEGRADIENTX, size.gradientXMin._elements);
						_setBuffer(SOLSIZEGRADIENTXMAX, size.gradientXMax._elements);
						_setBuffer(SOLSIZEGRADIENTY, size.gradientYMin._elements);
						_setBuffer(SOLSIZEGRADIENTYMAX, size.gradientYMax._elements);
						_setBuffer(SOLSizeGradientZ, size.gradientZMin._elements);
						_setBuffer(SOLSizeGradientZMAX, size.gradientZMax._elements);
					} else {
						_setBuffer(SOLSIZEGRADIENT, size.gradientMin._elements);
						_setBuffer(SOLSizeGradientMax, size.gradientMax._elements);
					}
					break;
				}
			}
			
			//RotationOverLifetime
			var rotationOverLifetime:RotationOverLifetime = particleSystem.rotationOverLifetime;
			if (rotationOverLifetime && rotationOverLifetime.enbale) {
				//state.shaderDefines.add(ShaderDefines3D.ROTATIONOVERLIFETIME);
				var rotation:GradientAngularVelocity = rotationOverLifetime.angularVelocity;
				var rotationType:int = rotation.type;
				var rotationSeparate:Boolean = rotation.separateAxes;
				_setInt(ROLTYPE, rotationType);
				_setBool(ROLSEPRARATE, rotationSeparate);
				switch (rotationType) {
				case 0: 
					if (rotationSeparate) {
						_setColor(ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantSeparate);
					} else {
						_setNumber(ROLANGULARVELOCITYCONST, rotation.constant);
					}
					break;
				case 1: 
					if (rotationSeparate) {
						_setBuffer(ROLANGULARVELOCITYGRADIENTX, rotation.gradientX._elements);
						_setBuffer(ROLANGULARVELOCITYGRADIENTY, rotation.gradientY._elements);
						_setBuffer(ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZ._elements);
					} else {
						_setBuffer(ROLANGULARVELOCITYGRADIENT, rotation.gradient._elements);
					}
					break;
				case 2: 
					if (rotationSeparate) {
						_setColor(ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantMinSeparate);
						_setColor(ROLANGULARVELOCITYCONSTMAXSEPRARATE, rotation.constantMaxSeparate);
					} else {
						_setNumber(ROLANGULARVELOCITYCONST, rotation.constantMin);
						_setNumber(ROLANGULARVELOCITYCONSTMAX, rotation.constantMax);
					}
					break;
				case 3: 
					if (rotationSeparate) {
						_setBuffer(ROLANGULARVELOCITYGRADIENTX, rotation.gradientXMin._elements);
						_setBuffer(ROLANGULARVELOCITYGRADIENTXMAX, rotation.gradientXMax._elements);
						_setBuffer(ROLANGULARVELOCITYGRADIENTY, rotation.gradientYMin._elements);
						_setBuffer(ROLANGULARVELOCITYGRADIENTYMAX, rotation.gradientYMax._elements);
						_setBuffer(ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZMin._elements);
						_setBuffer(ROLANGULARVELOCITYGRADIENTZMAX, rotation.gradientZMax._elements);
					} else {
						_setBuffer(ROLANGULARVELOCITYGRADIENT, rotation.gradientMin._elements);
						_setBuffer(ROLANGULARVELOCITYGRADIENTMAX, rotation.gradientMax._elements);
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
					//state.shaderDefines.add(ShaderDefines3D.TEXTURESHEETANIMATION);
					_setInt(TEXTURESHEETANIMATIONTYPE, textureAniType);
					_setInt(TEXTURESHEETANIMATIONCYCLES, textureSheetAnimation.cycles);
					var title:Vector2 = textureSheetAnimation.tiles;
					var _uvLengthE:Float32Array = _uvLength.elements;
					_uvLengthE[0] = 1.0 / title.x;
					_uvLengthE[1] = 1.0 / title.y;
					_setVector2(TEXTURESHEETANIMATIONSUBUVLENGTH, _uvLength);
				}
				switch (textureAniType) {
				case 1: 
					_setBuffer(TEXTURESHEETANIMATIONGRADIENTUVS, frameOverTime.frameOverTimeData._elements);
					break;
				case 3: 
					_setBuffer(TEXTURESHEETANIMATIONGRADIENTUVS, frameOverTime.frameOverTimeDataMin._elements);
					_setBuffer(TEXTURESHEETANIMATIONGRADIENTMAXUVS, frameOverTime.frameOverTimeDataMax._elements);
					break;
				}
			}
		
		}
	
	}

}