package laya.d3.core.particleShuriKen {
	import laya.d3.core.ParticleRender;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleSystem;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.GradientColor;
	import laya.d3.core.particleShuriKen.module.GradientDataColor;
	import laya.d3.core.particleShuriKen.module.GradientAngularVelocity;
	import laya.d3.core.particleShuriKen.module.GradientSize;
	import laya.d3.core.particleShuriKen.module.RotationOverLifetime;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.core.render.IRenderable;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.Texture2D;
	import laya.d3.shader.ShaderDefines3D;
	import laya.net.Loader;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShurikenParticleMaterial extends BaseMaterial {
		public static const WORLDMATRIX:String = "WORLDMATRIX";
		public static const SCALE:String = "SCALE";
		public static const VIEWMATRIX:String = "MATRIX1";
		public static const PROJECTIONMATRIX:String = "MATRIX2";
		public static const CURRENTTIME:String = "CURRENTTIME";
		public static const GRAVITY:String = "GRAVITY";
		public static const DIFFUSETEXTURE:String = "DIFFUSETEXTURE";
		public static const CAMERADIRECTION:String = "CAMERADIRECTION";
		public static const CAMERAUP:String = "CAMERAUP";
		public static const STRETCHEDBILLBOARDLENGTHSCALE:String = "STRETCHEDBILLBOARDLENGTHSCALE";
		public static const STRETCHEDBILLBOARDSPEEDSCALE:String = "STRETCHEDBILLBOARDSPEEDSCALE";
		
		//ColorOverLifetime
		public static const COLOROVERLIFEGRADIENTALPHAS:String = "COLOROVERLIFEGRADIENTALPHAS";
		public static const COLOROVERLIFEGRADIENTCOLORS:String = "COLOROVERLIFEGRADIENTCOLORS";
		public static const MAXCOLOROVERLIFEGRADIENTALPHAS:String = "MAXCOLOROVERLIFEGRADIENTALPHAS";
		public static const MAXCOLOROVERLIFEGRADIENTCOLORS:String = "MAXCOLOROVERLIFEGRADIENTCOLORS";
		
		//SizeOverLifetime
		public static const SIZEOVERLIFEGRADIENTSIZES:String = "SIZEOVERLIFEGRADIENTSIZES";
		public static const SIZEOVERLIFEGRADIENTSIZESX:String = "SIZEOVERLIFEGRADIENTSIZESX";
		public static const SIZEOVERLIFEGRADIENTSIZESY:String = "SIZEOVERLIFEGRADIENTSIZESY";
		public static const SIZEOVERLIFEGRADIENTSIZESZ:String = "SIZEOVERLIFEGRADIENTSIZESZ";
		public static const MAXSIZEOVERLIFEGRADIENTSIZES:String = "MAXSIZEOVERLIFEGRADIENTSIZES";
		public static const MAXSIZEOVERLIFEGRADIENTSIZESX:String = "MAXSIZEOVERLIFEGRADIENTSIZESX";
		public static const MAXSIZEOVERLIFEGRADIENTSIZESY:String = "MAXSIZEOVERLIFEGRADIENTSIZESY";
		public static const MAXSIZEOVERLIFEGRADIENTSIZESZ:String = "MAXSIZEOVERLIFEGRADIENTSIZESZ";
		
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
		public static const ROLANGULARVELOCITYGRADIENTMAXX:String = "ROLANGULARVELOCITYGRADIENTMAXX";
		public static const ROLANGULARVELOCITYGRADIENTMAXY:String = "ROLANGULARVELOCITYGRADIENTMAXY";
		public static const ROLANGULARVELOCITYGRADIENTMAXZ:String = "ROLANGULARVELOCITYGRADIENTMAXZ";
		
		//TextureSheetAnimation
		public static const TEXTURESHEETANIMATIONTYPE:String = "TEXTURESHEETANIMATIONTYPE";
		public static const TEXTURESHEETANIMATIONCYCLES:String = "TEXTURESHEETANIMATIONCYCLES";
		public static const TEXTURESHEETANIMATIONSUBUVLENGTH:String = "TEXTURESHEETANIMATIONSUBUVLENGTH";
		public static const TEXTURESHEETANIMATIONGRADIENTUVS:String = "TEXTURESHEETANIMATIONGRADIENTUVS";
		public static const TEXTURESHEETANIMATIONGRADIENTMAXUVS:String = "TEXTURESHEETANIMATIONGRADIENTMAXUVS";
		
		/** @private */
		private static var _tempGravity:Vector3 = new Vector3();
		/** @private */
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private static const _diffuseTextureIndex:int = 0;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:ShurikenParticleMaterial = new ShurikenParticleMaterial();
		
		/**
		 * 加载手里剑粒子材质。
		 * @param url 手里剑粒子材质地址。
		 */
		public static function load(url:String):ShurikenParticleMaterial {
			return Laya.loader.create(url,null, null, ShurikenParticleMaterial);
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
			
			var finalGravityE:Float32Array = _tempGravity.elements;
			var gravityE:Float32Array = particleSystem.gravity.elements;
			var gravityModifier:Number = particleSystem.gravityModifier;
			finalGravityE[0] = gravityE[0] * gravityModifier;
			finalGravityE[1] = gravityE[1] * gravityModifier;
			finalGravityE[2] = gravityE[2] * gravityModifier;
			
			var shaderValues:ValusArray = state.shaderValue;
			shaderValues.pushValue(GRAVITY, finalGravityE);
			
			//var pvw:Matrix4x4;
			//if (worldMatrix === Matrix4x4.DEFAULT) {
			//pvw = projectionView;//TODO:WORLD可以不传
			//} else {
			//pvw = _tempMatrix4x40;
			//Matrix4x4.multiply(projectionView, worldMatrix, pvw);
			//}
			
			
			var scale:Vector3;
			switch (particleSystem.scaleMode) {
			case 0: 
				shaderValues.pushValue(WORLDMATRIX, worldMatrix.elements);
				scale = state.owner.transform.scale;
				break;
			case 1: 
				shaderValues.pushValue(WORLDMATRIX, particle.transform.localMatrix.elements);
				scale = state.owner.transform.localScale;
				break;
			case 2: 
				shaderValues.pushValue(WORLDMATRIX, Matrix4x4.DEFAULT.elements);
				scale = Vector3.ONE;
				break;
			}
			shaderValues.pushValue(SCALE, scale.elements);
			
			shaderValues.pushValue(CAMERADIRECTION, state.camera.forward.elements);
			shaderValues.pushValue(CAMERAUP, state.camera.up.elements);
			
			shaderValues.pushValue(VIEWMATRIX, state.viewMatrix.elements);
			shaderValues.pushValue(PROJECTIONMATRIX, state.projectionMatrix.elements);
			
			shaderValues.pushValue(STRETCHEDBILLBOARDLENGTHSCALE, particleRender.stretchedBillboardLengthScale);
			shaderValues.pushValue(STRETCHEDBILLBOARDSPEEDSCALE, particleRender.stretchedBillboardSpeedScale);
			
			//设置粒子的时间参数，可通过此参数停止粒子动画
			shaderValues.pushValue(CURRENTTIME, particleSystem.currentTime);
			
			switch (particleRender.renderMode) {
			case 0: 
				state.shaderDefs.add(ShaderDefines3D.SPHERHBILLBOARD);
				break;
			case 1: 
				state.shaderDefs.add(ShaderDefines3D.STRETCHEDBILLBOARD);
				break;
			case 2: 
				state.shaderDefs.add(ShaderDefines3D.HORIZONTALBILLBOARD);
				break;
			case 3: 
				state.shaderDefs.add(ShaderDefines3D.VERTICALBILLBOARD);
				break;
			}
			
			//ColorOverLifetime
			var colorOverLifetime:ColorOverLifetime = particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale) {
				var color:GradientColor = colorOverLifetime.color;
				switch (color.type) {
				case 1: 
					state.shaderDefs.add(ShaderDefines3D.COLOROVERLIFETIME);
					var gradientColor:GradientDataColor = color.gradientColor;
					shaderValues.pushValue(COLOROVERLIFEGRADIENTALPHAS, gradientColor._alphaElements);
					shaderValues.pushValue(COLOROVERLIFEGRADIENTCOLORS, gradientColor._rgbElements);
					break;
				case 3: 
					state.shaderDefs.add(ShaderDefines3D.RANDOMCOLOROVERLIFETIME);
					var minGradientColor:GradientDataColor = color.minGradientColor;
					var maxGradientColor:GradientDataColor = color.maxGradientColor;
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
				switch (size.type) {
				case 0: 
					if (size.separateAxes) {
						state.shaderDefs.add(ShaderDefines3D.SIZEOVERLIFETIMESEPARATE);
						shaderValues.pushValue(SIZEOVERLIFEGRADIENTSIZESX, size.gradientSizeX._elements);
						shaderValues.pushValue(SIZEOVERLIFEGRADIENTSIZESY, size.gradientSizeY._elements);
						shaderValues.pushValue(SIZEOVERLIFEGRADIENTSIZESZ, size.gradientSizeZ._elements);
					} else {
						state.shaderDefs.add(ShaderDefines3D.SIZEOVERLIFETIME);
						shaderValues.pushValue(SIZEOVERLIFEGRADIENTSIZES, size.gradientSize._elements);
					}
					break;
				case 2: 
					if (size.separateAxes) {
						state.shaderDefs.add(ShaderDefines3D.RANDOMSIZEOVERLIFETIMESEPARATE);
						shaderValues.pushValue(SIZEOVERLIFEGRADIENTSIZESX, size.gradientSizeXMin._elements);
						shaderValues.pushValue(MAXSIZEOVERLIFEGRADIENTSIZESX, size.gradientSizeXMax._elements);
						shaderValues.pushValue(SIZEOVERLIFEGRADIENTSIZESY, size.gradientSizeYMin._elements);
						shaderValues.pushValue(MAXSIZEOVERLIFEGRADIENTSIZESY, size.gradientSizeYMax._elements);
						shaderValues.pushValue(SIZEOVERLIFEGRADIENTSIZESZ, size.gradientSizeZMin._elements);
						shaderValues.pushValue(MAXSIZEOVERLIFEGRADIENTSIZESZ, size.gradientSizeZMax._elements);
					} else {
						state.shaderDefs.add(ShaderDefines3D.RANDOMSIZEOVERLIFETIME);
						shaderValues.pushValue(SIZEOVERLIFEGRADIENTSIZES, size.gradientSizeMin._elements);
						shaderValues.pushValue(MAXSIZEOVERLIFEGRADIENTSIZES, size.gradientSizeMax._elements);
					}
					break;
				}
			}
			
			//RotationOverLifetime
			var rotationOverLifetime:RotationOverLifetime = particleSystem.rotationOverLifetime;
			if (rotationOverLifetime && rotationOverLifetime.enbale) {
				state.shaderDefs.add(ShaderDefines3D.ROTATIONOVERLIFETIME);
				var rotation:GradientAngularVelocity = rotationOverLifetime.angularVelocity;
				var rotationType:int = rotation.type;
				shaderValues.pushValue(ROLTYPE, rotationType);
				shaderValues.pushValue(ROLSEPRARATE, rotation.separateAxes);
				switch (rotationType) {
				case 0: 
					if (rotation.separateAxes) {
						shaderValues.pushValue(ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantSeparate.elements);
					} else {
						shaderValues.pushValue(ROLANGULARVELOCITYCONST, rotation.constant);
					}
					break;
				case 1: 
					if (rotation.separateAxes) {
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTX, rotation.gradientX._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTY, rotation.gradientY._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZ._elements);
					} else {
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENT, rotation.gradient._elements);
					}
					break;
				case 2: 
					if (rotation.separateAxes) {
						shaderValues.pushValue(ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantMinSeparate.elements);
						shaderValues.pushValue(ROLANGULARVELOCITYCONSTMAXSEPRARATE, rotation.constantMaxSeparate.elements);
					} else {
						shaderValues.pushValue(ROLANGULARVELOCITYCONST, rotation.constantMin);
						shaderValues.pushValue(ROLANGULARVELOCITYCONSTMAX, rotation.constantMax);
					}
					break;
				case 3: 
					if (rotation.separateAxes) {
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTX, rotation.gradientXMin._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTMAXX, rotation.gradientXMax._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTY, rotation.gradientYMin._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTMAXY, rotation.gradientYMax._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZMin._elements);
						shaderValues.pushValue(ROLANGULARVELOCITYGRADIENTMAXZ, rotation.gradientZMax._elements);
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
					state.shaderDefs.add(ShaderDefines3D.TEXTURESHEETANIMATION);
					shaderValues.pushValue(TEXTURESHEETANIMATIONTYPE, textureAniType);
					shaderValues.pushValue(TEXTURESHEETANIMATIONCYCLES, textureSheetAnimation.cycles);
					var title:Vector2 = textureSheetAnimation.title;
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