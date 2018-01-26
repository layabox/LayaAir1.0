package laya.d3.core.particleShuriKen {
	import laya.d3.core.Transform3D;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.GradientColor;
	import laya.d3.core.particleShuriKen.module.GradientDataNumber;
	import laya.d3.core.particleShuriKen.module.GradientSize;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.StartFrame;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Rand;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.maths.MathUtil;
	
	/**
	 *  @private
	 */
	public class ShurikenParticleData {
		/**@private */
		private static var _tempVector30:Vector3 = new Vector3();
		/**@private */
		private static var _tempQuaternion:Quaternion = new Quaternion();
		
		public static var startLifeTime:Number;
		public static var startColor:Float32Array = new Float32Array(4);
		public static var startSize:Float32Array = new Float32Array(3);
		public static var startRotation:Float32Array = new Float32Array(3);
		public static var startSpeed:Number;
		public static var startUVInfo:Float32Array = new Float32Array(4);
		public static var simulationWorldPostion:Float32Array = new Float32Array(3);
		public static var simulationWorldRotation:Float32Array = new Float32Array(4);
		
		public function ShurikenParticleData() {
		}
		
		/**
		 * @private
		 */
		private static function _getStartLifetimeFromGradient(startLifeTimeGradient:GradientDataNumber, emissionTime:Number):Number {
			for (var i:int = 1, n:int = startLifeTimeGradient.gradientCount; i < n; i++) {
				var key:Number = startLifeTimeGradient.getKeyByIndex(i);
				if (key >= emissionTime) {
					var lastKey:Number = startLifeTimeGradient.getKeyByIndex(i - 1);
					var age:Number = (emissionTime - lastKey) / (key - lastKey);
					return MathUtil.lerp(startLifeTimeGradient.getValueByIndex(i - 1), startLifeTimeGradient.getValueByIndex(i), age)
				}
			}
			throw new Error("ShurikenParticleData: can't get value foam startLifeTimeGradient.");
		}
		
		/**
		 * @private
		 */
		private static function _randomInvertRoationArray(rotatonE:Float32Array, outE:Float32Array, randomizeRotationDirection:Number, rand:Rand, randomSeeds:Uint32Array):void {
			var randDic:Number;
			if (rand) {
				rand.seed = randomSeeds[6];
				randDic = rand.getFloat();
				randomSeeds[6] = rand.seed;
			} else {
				randDic = Math.random();
			}
			if (randDic < randomizeRotationDirection) {
				outE[0] = -rotatonE[0];
				outE[1] = -rotatonE[1];
				outE[2] = -rotatonE[2];
			} else {
				outE[0] = rotatonE[0];
				outE[1] = rotatonE[1];
				outE[2] = rotatonE[2];
			}
		}
		
		/**
		 * @private
		 */
		private static function _randomInvertRoation(rotaton:Number, randomizeRotationDirection:Number, rand:Rand, randomSeeds:Uint32Array):Number {
			var randDic:Number;
			if (rand) {
				rand.seed = randomSeeds[6];
				randDic = rand.getFloat();
				randomSeeds[6] = rand.seed;
			} else {
				randDic = Math.random();
			}
			if (randDic < randomizeRotationDirection)
				rotaton = -rotaton;
			return rotaton;
		}
		
		/**
		 * @private
		 */
		public static function create(particleSystem:ShurikenParticleSystem, particleRender:ShurikenParticleRender, transform:Transform3D):void {
			var autoRandomSeed:Boolean = particleSystem.autoRandomSeed;
			var rand:Rand = particleSystem._rand;
			var randomSeeds:Uint32Array = particleSystem._randomSeeds;
			
			//StartColor
			switch (particleSystem.startColorType) {
			case 0: 
				var constantStartColorE:Float32Array = particleSystem.startColorConstant.elements;
				startColor[0] = constantStartColorE[0];
				startColor[1] = constantStartColorE[1];
				startColor[2] = constantStartColorE[2];
				startColor[3] = constantStartColorE[3];
				break;
			case 2: 
				if (autoRandomSeed) {
					MathUtil.lerpVector4(particleSystem.startColorConstantMin.elements, particleSystem.startColorConstantMax.elements, Math.random(), startColor);
				} else {
					rand.seed = randomSeeds[3];
					MathUtil.lerpVector4(particleSystem.startColorConstantMin.elements, particleSystem.startColorConstantMax.elements, rand.getFloat(), startColor);
					randomSeeds[3] = rand.seed;
				}
				break;
			}
			var colorOverLifetime:ColorOverLifetime = particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale) {
				var color:GradientColor = colorOverLifetime.color;
				switch (color.type) {
				case 0: 
					startColor[0] = startColor[0] * color.constant.x;
					startColor[1] = startColor[1] * color.constant.y;
					startColor[2] = startColor[2] * color.constant.z;
					startColor[3] = startColor[3] * color.constant.w;
					break;
				case 2: 
					var colorRandom:Number;
					if (autoRandomSeed) {
						colorRandom = Math.random();
					} else {
						rand.seed = randomSeeds[10];
						colorRandom = rand.getFloat();
						randomSeeds[10] = rand.seed;
					}
					var minConstantColor:Vector4 = color.constantMin;
					var maxConstantColor:Vector4 = color.constantMax;
					startColor[0] = startColor[0] * MathUtil.lerp(minConstantColor.x, maxConstantColor.x, colorRandom);
					startColor[1] = startColor[1] * MathUtil.lerp(minConstantColor.y, maxConstantColor.y, colorRandom);
					startColor[2] = startColor[2] * MathUtil.lerp(minConstantColor.z, maxConstantColor.z, colorRandom);
					startColor[3] = startColor[3] * MathUtil.lerp(minConstantColor.w, maxConstantColor.w, colorRandom);
					break;
				}
			}
			
			//StartSize
			var particleSize:Float32Array = startSize;
			switch (particleSystem.startSizeType) {
			case 0: 
				if (particleSystem.threeDStartSize) {
					var startSizeConstantSeparate:Vector3 = particleSystem.startSizeConstantSeparate;
					particleSize[0] = startSizeConstantSeparate.x;
					particleSize[1] = startSizeConstantSeparate.y;
					particleSize[2] = startSizeConstantSeparate.z;
				} else {
					particleSize[0] = particleSize[1] = particleSize[2] = particleSystem.startSizeConstant;
				}
				break;
			case 2: 
				if (particleSystem.threeDStartSize) {
					var startSizeConstantMinSeparate:Vector3 = particleSystem.startSizeConstantMinSeparate;
					var startSizeConstantMaxSeparate:Vector3 = particleSystem.startSizeConstantMaxSeparate;
					if (autoRandomSeed) {
						particleSize[0] = MathUtil.lerp(startSizeConstantMinSeparate.x, startSizeConstantMaxSeparate.x, Math.random());
						particleSize[1] = MathUtil.lerp(startSizeConstantMinSeparate.y, startSizeConstantMaxSeparate.y, Math.random());
						particleSize[2] = MathUtil.lerp(startSizeConstantMinSeparate.z, startSizeConstantMaxSeparate.z, Math.random());
					} else {
						rand.seed = randomSeeds[4];
						particleSize[0] = MathUtil.lerp(startSizeConstantMinSeparate.x, startSizeConstantMaxSeparate.x, rand.getFloat());
						particleSize[1] = MathUtil.lerp(startSizeConstantMinSeparate.y, startSizeConstantMaxSeparate.y, rand.getFloat());
						particleSize[2] = MathUtil.lerp(startSizeConstantMinSeparate.z, startSizeConstantMaxSeparate.z, rand.getFloat());
						randomSeeds[4] = rand.seed;
					}
				} else {
					if (autoRandomSeed) {
						particleSize[0] = particleSize[1] = particleSize[2] = MathUtil.lerp(particleSystem.startSizeConstantMin, particleSystem.startSizeConstantMax, Math.random());
					} else {
						rand.seed = randomSeeds[4];
						particleSize[0] = particleSize[1] = particleSize[2] = MathUtil.lerp(particleSystem.startSizeConstantMin, particleSystem.startSizeConstantMax, rand.getFloat());
						randomSeeds[4] = rand.seed;
					}
				}
				break;
			}
			
			var sizeOverLifetime:SizeOverLifetime = particleSystem.sizeOverLifetime;
			if (sizeOverLifetime && sizeOverLifetime.enbale && sizeOverLifetime.size.type === 1) {
				var size:GradientSize = sizeOverLifetime.size;
				if (size.separateAxes) {
					if (autoRandomSeed) {
						particleSize[0] = particleSize[0] * MathUtil.lerp(size.constantMinSeparate.x, size.constantMaxSeparate.x, Math.random());
						particleSize[1] = particleSize[1] * MathUtil.lerp(size.constantMinSeparate.y, size.constantMaxSeparate.y, Math.random());
						particleSize[2] = particleSize[2] * MathUtil.lerp(size.constantMinSeparate.z, size.constantMaxSeparate.z, Math.random());
					} else {
						rand.seed = randomSeeds[11];
						particleSize[0] = particleSize[0] * MathUtil.lerp(size.constantMinSeparate.x, size.constantMaxSeparate.x, rand.getFloat());
						particleSize[1] = particleSize[1] * MathUtil.lerp(size.constantMinSeparate.y, size.constantMaxSeparate.y, rand.getFloat());
						particleSize[2] = particleSize[2] * MathUtil.lerp(size.constantMinSeparate.z, size.constantMaxSeparate.z, rand.getFloat());
						randomSeeds[11] = rand.seed;
					}
				} else {
					var randomSize:Number;
					if (autoRandomSeed) {
						randomSize = MathUtil.lerp(size.constantMin, size.constantMax, Math.random());
					} else {
						rand.seed = randomSeeds[11];
						randomSize = MathUtil.lerp(size.constantMin, size.constantMax, rand.getFloat());
						randomSeeds[11] = rand.seed;
					}
					particleSize[0] = particleSize[0] * randomSize;
					particleSize[1] = particleSize[1] * randomSize;
					particleSize[2] = particleSize[2] * randomSize;
				}
			}
			
			//StartRotation//TODO:renderMode2、3模式都不需要旋转，是否移除。
			var renderMode:int = particleRender.renderMode;
			if (renderMode !== 1) {
				switch (particleSystem.startRotationType) {
				case 0: 
					if (particleSystem.threeDStartRotation) {
						var startRotationConstantSeparate:Vector3 = particleSystem.startRotationConstantSeparate;
						var randomRotationE:Float32Array = _tempVector30.elements;
						_randomInvertRoationArray(startRotationConstantSeparate.elements, randomRotationE, particleSystem.randomizeRotationDirection, autoRandomSeed ? null : rand, randomSeeds);
						startRotation[0] = randomRotationE[0];
						startRotation[1] = randomRotationE[1];
						if (renderMode !== 4)
							startRotation[2] = -randomRotationE[2];
						else
							startRotation[2] = randomRotationE[2];
					} else {
						startRotation[0] = _randomInvertRoation(particleSystem.startRotationConstant, particleSystem.randomizeRotationDirection, autoRandomSeed ? null : rand, randomSeeds);
					}
					break;
				case 2: 
					if (particleSystem.threeDStartRotation) {
						var startRotationConstantMinSeparate:Vector3 = particleSystem.startRotationConstantMinSeparate;
						var startRotationConstantMaxSeparate:Vector3 = particleSystem.startRotationConstantMaxSeparate;
						var lerpRoationE:Float32Array = _tempVector30.elements;
						if (autoRandomSeed) {
							lerpRoationE[0] = MathUtil.lerp(startRotationConstantMinSeparate.x, startRotationConstantMaxSeparate.x, Math.random());
							lerpRoationE[1] = MathUtil.lerp(startRotationConstantMinSeparate.y, startRotationConstantMaxSeparate.y, Math.random());
							lerpRoationE[2] = MathUtil.lerp(startRotationConstantMinSeparate.z, startRotationConstantMaxSeparate.z, Math.random());
						} else {
							rand.seed = randomSeeds[5];
							lerpRoationE[0] = MathUtil.lerp(startRotationConstantMinSeparate.x, startRotationConstantMaxSeparate.x, rand.getFloat());
							lerpRoationE[1] = MathUtil.lerp(startRotationConstantMinSeparate.y, startRotationConstantMaxSeparate.y, rand.getFloat());
							lerpRoationE[2] = MathUtil.lerp(startRotationConstantMinSeparate.z, startRotationConstantMaxSeparate.z, rand.getFloat());
							randomSeeds[5] = rand.seed;
						}
						_randomInvertRoationArray(lerpRoationE, lerpRoationE, particleSystem.randomizeRotationDirection, autoRandomSeed ? null : rand, randomSeeds);
						startRotation[0] = lerpRoationE[0];
						startRotation[1] = lerpRoationE[1];
						if (renderMode !== 4)
							startRotation[2] = -lerpRoationE[2];
						else
							startRotation[2] = lerpRoationE[2];
					} else {
						if (autoRandomSeed) {
							startRotation[0] = _randomInvertRoation(MathUtil.lerp(particleSystem.startRotationConstantMin, particleSystem.startRotationConstantMax, Math.random()), particleSystem.randomizeRotationDirection, autoRandomSeed ? null : rand, randomSeeds);
						} else {
							rand.seed = randomSeeds[5];
							startRotation[0] = _randomInvertRoation(MathUtil.lerp(particleSystem.startRotationConstantMin, particleSystem.startRotationConstantMax, rand.getFloat()), particleSystem.randomizeRotationDirection, autoRandomSeed ? null : rand, randomSeeds);
							randomSeeds[5] = rand.seed;
						}
					}
					break;
				}
			}
			
			//StartLifetime
			switch (particleSystem.startLifetimeType) {
			case 0: 
				startLifeTime = particleSystem.startLifetimeConstant;
				break;
			case 1: 
				startLifeTime = _getStartLifetimeFromGradient(particleSystem.startLifeTimeGradient, particleSystem.emissionTime);
				break;
			case 2: 
				if (autoRandomSeed) {
					startLifeTime = MathUtil.lerp(particleSystem.startLifetimeConstantMin, particleSystem.startLifetimeConstantMax, Math.random());
				} else {
					rand.seed = randomSeeds[7];
					startLifeTime = MathUtil.lerp(particleSystem.startLifetimeConstantMin, particleSystem.startLifetimeConstantMax, rand.getFloat());
					randomSeeds[7] = rand.seed;
				}
				break;
			case 3: 
				var emissionTime:Number = particleSystem.emissionTime;
				if (autoRandomSeed) {
					startLifeTime = MathUtil.lerp(_getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMin, emissionTime), _getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMax, emissionTime), Math.random());
				} else {
					rand.seed = randomSeeds[7];
					startLifeTime = MathUtil.lerp(_getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMin, emissionTime), _getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMax, emissionTime), rand.getFloat());
					randomSeeds[7] = rand.seed;
				}
				break;
			}
			
			//StartSpeed
			switch (particleSystem.startSpeedType) {
			case 0: 
				startSpeed = particleSystem.startSpeedConstant;
				break;
			case 2: 
				if (autoRandomSeed) {
					startSpeed = MathUtil.lerp(particleSystem.startSpeedConstantMin, particleSystem.startSpeedConstantMax, Math.random());
				} else {
					rand.seed = randomSeeds[8];
					startSpeed = MathUtil.lerp(particleSystem.startSpeedConstantMin, particleSystem.startSpeedConstantMax, rand.getFloat());
					randomSeeds[8] = rand.seed;
				}
				break;
			}
			
			//StartUV
			var textureSheetAnimation:TextureSheetAnimation = particleSystem.textureSheetAnimation;
			var enableSheetAnimation:Boolean = textureSheetAnimation && textureSheetAnimation.enable;
			if (enableSheetAnimation) {
				var title:Vector2 = textureSheetAnimation.tiles;
				var titleX:int = title.x, titleY:int = title.y;
				var subU:Number = 1.0 / titleX, subV:Number = 1.0 / titleY;
				
				var startFrameCount:int;
				var startFrame:StartFrame = textureSheetAnimation.startFrame;
				switch (startFrame.type) {
				case 0://常量模式
					startFrameCount = startFrame.constant;
					break;
				case 1://随机双常量模式
					if (autoRandomSeed) {
						startFrameCount = MathUtil.lerp(startFrame.constantMin, startFrame.constantMax, Math.random());
					} else {
						rand.seed = randomSeeds[14];
						startFrameCount = MathUtil.lerp(startFrame.constantMin, startFrame.constantMax, rand.getFloat());
						randomSeeds[14] = rand.seed;
					}
					break;
				}
				
				var frame:FrameOverTime = textureSheetAnimation.frame;
				switch (frame.type) {
				case 0: 
					startFrameCount += frame.constant;
					break;
				case 2: 
					if (autoRandomSeed) {
						startFrameCount += MathUtil.lerp(frame.constantMin, frame.constantMax, Math.random());
					} else {
						rand.seed = randomSeeds[15];
						startFrameCount += MathUtil.lerp(frame.constantMin, frame.constantMax, rand.getFloat());
						randomSeeds[15] = rand.seed;
					}
					break;
				}
				
				var startRow:int;
				switch (textureSheetAnimation.type) {
				case 0://Whole Sheet
					startRow = Math.floor(startFrameCount / titleX);
					break;
				case 1://Singal Row
					if (textureSheetAnimation.randomRow) {
						if (autoRandomSeed) {
							startRow = Math.floor(Math.random() * titleY);
							
						} else {
							rand.seed = randomSeeds[13];
							startRow = Math.floor(rand.getFloat() * titleY);
							randomSeeds[13] = rand.seed;
						}
					} else {
						startRow = textureSheetAnimation.rowIndex;
					}
					break;
				}
				
				var startCol:int = Math.floor(startFrameCount % titleX);
				startUVInfo = startUVInfo;
				startUVInfo[0] = subU;
				startUVInfo[1] = subV;
				startUVInfo[2] = startCol * subU;
				startUVInfo[3] = startRow * subV;
			} else {
				startUVInfo = startUVInfo;
				startUVInfo[0] = 1.0;
				startUVInfo[1] = 1.0;
				startUVInfo[2] = 0.0;
				startUVInfo[3] = 0.0;
			}
			
			switch (particleSystem.simulationSpace) {
			case 0: 
				var positionE:Float32Array = transform.position.elements;
				simulationWorldPostion[0] = positionE[0];
				simulationWorldPostion[1] = positionE[1];
				simulationWorldPostion[2] = positionE[2];
				
				var rotationE:Float32Array = transform.rotation.elements;
				simulationWorldRotation[0] = rotationE[0];
				simulationWorldRotation[1] = rotationE[1];
				simulationWorldRotation[2] = rotationE[2];
				simulationWorldRotation[3] = rotationE[3];
				break;
			case 1: 
				break;
			default: 
				throw new Error("ShurikenParticleMaterial: SimulationSpace value is invalid.");
				break;
			}
		}
	
	}

}