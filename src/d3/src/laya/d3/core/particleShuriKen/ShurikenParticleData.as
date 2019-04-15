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
		public static var startColor:Vector4 = new Vector4();
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
		private static function _randomInvertRoationArray(rotatonE:Vector3, outE:Vector3, randomizeRotationDirection:Number, rand:Rand, randomSeeds:Uint32Array):void {
			var randDic:Number;
			if (rand) {
				rand.seed = randomSeeds[6];
				randDic = rand.getFloat();
				randomSeeds[6] = rand.seed;
			} else {
				randDic = Math.random();
			}
			if (randDic < randomizeRotationDirection) {
				outE.x = -rotatonE.x;
				outE.y = -rotatonE.y;
				outE.z = -rotatonE.z;
			} else {
				outE.x = rotatonE.x;
				outE.y = rotatonE.y;
				outE.z = rotatonE.z;
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
		public static function create(particleSystem:ShurikenParticleSystem, particleRender:ShurikenParticleRenderer, transform:Transform3D):void {
			var autoRandomSeed:Boolean = particleSystem.autoRandomSeed;
			var rand:Rand = particleSystem._rand;
			var randomSeeds:Uint32Array = particleSystem._randomSeeds;
			
			//StartColor
			switch (particleSystem.startColorType) {
			case 0: 
				var constantStartColor:Vector4 = particleSystem.startColorConstant;
				startColor.x = constantStartColor.x;
				startColor.y = constantStartColor.y;
				startColor.z = constantStartColor.z;
				startColor.w = constantStartColor.w;
				break;
			case 2: 
				if (autoRandomSeed) {
					Vector4.lerp(particleSystem.startColorConstantMin, particleSystem.startColorConstantMax, Math.random(), startColor);
				} else {
					rand.seed = randomSeeds[3];
					Vector4.lerp(particleSystem.startColorConstantMin, particleSystem.startColorConstantMax, rand.getFloat(), startColor);
					randomSeeds[3] = rand.seed;
				}
				break;
			}
			var colorOverLifetime:ColorOverLifetime = particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale) {
				var color:GradientColor = colorOverLifetime.color;
				switch (color.type) {
				case 0: 
					startColor.x = startColor.x * color.constant.x;
					startColor.y = startColor.y * color.constant.y;
					startColor.z = startColor.z * color.constant.z;
					startColor.w = startColor.w * color.constant.w;
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
					startColor.x = startColor.x * MathUtil.lerp(minConstantColor.x, maxConstantColor.x, colorRandom);
					startColor.y = startColor.y * MathUtil.lerp(minConstantColor.y, maxConstantColor.y, colorRandom);
					startColor.z = startColor.z * MathUtil.lerp(minConstantColor.z, maxConstantColor.z, colorRandom);
					startColor.w = startColor.w * MathUtil.lerp(minConstantColor.w, maxConstantColor.w, colorRandom);
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
						var randomRotationE:Vector3 = _tempVector30;
						_randomInvertRoationArray(startRotationConstantSeparate, randomRotationE, particleSystem.randomizeRotationDirection, autoRandomSeed ? null : rand, randomSeeds);
						startRotation[0] = randomRotationE.x;
						startRotation[1] = randomRotationE.y;
						if (renderMode !== 4)
							startRotation[2] = -randomRotationE.z;
						else
							startRotation[2] = randomRotationE.z;
					} else {
						startRotation[0] = _randomInvertRoation(particleSystem.startRotationConstant, particleSystem.randomizeRotationDirection, autoRandomSeed ? null : rand, randomSeeds);
						startRotation[1] = 0;
						startRotation[2] = 0;//需要置0,否则上次缓存影响数据。TODO:mesh模式下使用Z,但是这里为什么是X
					}
					break;
				case 2: 
					if (particleSystem.threeDStartRotation) {
						var startRotationConstantMinSeparate:Vector3 = particleSystem.startRotationConstantMinSeparate;
						var startRotationConstantMaxSeparate:Vector3 = particleSystem.startRotationConstantMaxSeparate;
						var lerpRoationE:Vector3 = _tempVector30;
						if (autoRandomSeed) {
							lerpRoationE.x = MathUtil.lerp(startRotationConstantMinSeparate.x, startRotationConstantMaxSeparate.x, Math.random());
							lerpRoationE.y = MathUtil.lerp(startRotationConstantMinSeparate.y, startRotationConstantMaxSeparate.y, Math.random());
							lerpRoationE.z = MathUtil.lerp(startRotationConstantMinSeparate.z, startRotationConstantMaxSeparate.z, Math.random());
						} else {
							rand.seed = randomSeeds[5];
							lerpRoationE.x = MathUtil.lerp(startRotationConstantMinSeparate.x, startRotationConstantMaxSeparate.x, rand.getFloat());
							lerpRoationE.y = MathUtil.lerp(startRotationConstantMinSeparate.y, startRotationConstantMaxSeparate.y, rand.getFloat());
							lerpRoationE.z = MathUtil.lerp(startRotationConstantMinSeparate.z, startRotationConstantMaxSeparate.z, rand.getFloat());
							randomSeeds[5] = rand.seed;
						}
						_randomInvertRoationArray(lerpRoationE, lerpRoationE, particleSystem.randomizeRotationDirection, autoRandomSeed ? null : rand, randomSeeds);
						startRotation[0] = lerpRoationE.x;
						startRotation[1] = lerpRoationE.y;
						if (renderMode !== 4)
							startRotation[2] = -lerpRoationE.z;
						else
							startRotation[2] = lerpRoationE.z;
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
				var position:Vector3 = transform.position;
				simulationWorldPostion[0] = position.x;
				simulationWorldPostion[1] = position.y;
				simulationWorldPostion[2] = position.z;
				
				var rotation:Quaternion = transform.rotation;
				simulationWorldRotation[0] = rotation.x;
				simulationWorldRotation[1] = rotation.y;
				simulationWorldRotation[2] = rotation.z;
				simulationWorldRotation[3] = rotation.w;
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