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
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Rand;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.maths.MathUtil;
	
	/**
	 *  @private
	 */
	public class ShurikenParticleData {
		private static var _tempRotationMatrix:Matrix4x4 = new Matrix4x4();
		private static var _tempStartColor:Float32Array = new Float32Array(4);
		private static var _tempStartSize:Float32Array = new Float32Array(3);
		private static var _tempStartRotation0:Float32Array = new Float32Array(3);
		private static var _tempStartRotation1:Float32Array = new Float32Array(3);
		private static var _tempStartRotation2:Float32Array = new Float32Array(3);
		private static var _tempStartUVInfo:Float32Array = new Float32Array(4);
		private static var _tempSimulationWorldPostion:Float32Array = new Float32Array(3);
		
		public var startLifeTime:Number;
		
		public var position:Float32Array;
		public var direction:Float32Array;
		public var startColor:Float32Array;
		public var startSize:Float32Array;
		public var startRotation0:Float32Array;
		public var startRotation1:Float32Array;
		public var startRotation2:Float32Array;
		
		public var time:Number;
		public var startSpeed:Number;
		public var startUVInfo:Float32Array;
		
		public var simulationWorldPostion:Float32Array;
		
		public function ShurikenParticleData() {
		
		}
		
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
		
		public static function create(particleSystem:ShurikenParticleSystem, particleRender:ShurikenParticleRender, position:Float32Array, direction:Float32Array, time:Number, transform:Transform3D):ShurikenParticleData {
			var autoRandomSeed:Boolean = particleSystem.autoRandomSeed;
			var rand:Rand = particleSystem._rand;
			var randomSeeds:Uint32Array = particleSystem._randomSeeds;
			
			var particleData:ShurikenParticleData = new ShurikenParticleData();
			particleData.position = position;
			particleData.direction = direction;
			
			//StartColor
			particleData.startColor = _tempStartColor;
			switch (particleSystem.startColorType) {
			case 0: 
				var startColorE:Float32Array = particleData.startColor;
				var constantStartColorE:Float32Array = particleSystem.startColorConstant.elements;
				startColorE[0] = constantStartColorE[0];
				startColorE[1] = constantStartColorE[1];
				startColorE[2] = constantStartColorE[2];
				startColorE[3] = constantStartColorE[3];
				break;
			case 2: 
				if (autoRandomSeed) {
					MathUtil.lerpVector4(particleSystem.startColorConstantMin.elements, particleSystem.startColorConstantMax.elements, Math.random(), particleData.startColor);
				} else {
					rand.seed = randomSeeds[3];
					MathUtil.lerpVector4(particleSystem.startColorConstantMin.elements, particleSystem.startColorConstantMax.elements, rand.getFloat(), particleData.startColor);
					randomSeeds[3] = rand.seed;
				}
				break;
			}
			var colorOverLifetime:ColorOverLifetime = particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale) {
				var startColor:Float32Array = particleData.startColor;
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
			particleData.startSize = _tempStartSize;
			var particleSize:Float32Array = particleData.startSize;
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
						particleSize[1] = particleSize[1] * MathUtil.lerp(size.constantMinSeparate.y, size.constantMaxSeparate.y, rand.getFloat());;
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
			
			//StartRotation
			var particleRotation0:Float32Array;
			var particleRotation1:Float32Array;
			var particleRotation2:Float32Array;
			var rotationMatrixE:Float32Array;
			switch (particleSystem.startRotationType) {
			case 0: 
				if (particleSystem.threeDStartRotation && (particleRender.renderMode !== 1) && (particleRender.renderMode !== 1)) {
					var startRotationConstantSeparate:Vector3 = particleSystem.startRotationConstantSeparate;
					Matrix4x4.createRotationYawPitchRoll(startRotationConstantSeparate.y, startRotationConstantSeparate.x, startRotationConstantSeparate.z, _tempRotationMatrix);
					rotationMatrixE = _tempRotationMatrix.elements;
					particleData.startRotation0 = _tempStartRotation0;
					particleRotation0 = particleData.startRotation0;
					particleRotation0[0] = rotationMatrixE[0];
					particleRotation0[1] = rotationMatrixE[1];
					particleRotation0[2] = rotationMatrixE[2];
					
					particleData.startRotation1 = _tempStartRotation1;
					particleRotation1 = particleData.startRotation1;
					particleRotation1[0] = rotationMatrixE[4];
					particleRotation1[1] = rotationMatrixE[5];
					particleRotation1[2] = rotationMatrixE[6];
					
					particleData.startRotation2 = _tempStartRotation2;
					particleRotation2 = particleData.startRotation2;
					particleRotation2[0] = rotationMatrixE[8];
					particleRotation2[1] = rotationMatrixE[9];
					particleRotation2[2] = rotationMatrixE[10];
					
				} else {
					particleData.startRotation0 = _tempStartRotation0;
					particleRotation0 = particleData.startRotation0;
					particleRotation0[0] = particleRotation0[1] = particleRotation0[2] = particleSystem.startRotationConstant;
				}
				break;
			case 2: 
				if (particleSystem.threeDStartRotation && (particleRender.renderMode !== 1) && (particleRender.renderMode !== 2)) {
					particleData.startRotation0 = _tempStartRotation0;
					particleRotation0 = particleData.startRotation0;
					var startRotationConstantMinSeparate:Vector3 = particleSystem.startRotationConstantMinSeparate;
					var startRotationConstantMaxSeparate:Vector3 = particleSystem.startRotationConstantMaxSeparate;
					if (autoRandomSeed) {
						Matrix4x4.createRotationYawPitchRoll(MathUtil.lerp(startRotationConstantMinSeparate.y, startRotationConstantMaxSeparate.y, Math.random()), MathUtil.lerp(startRotationConstantMinSeparate.x, startRotationConstantMaxSeparate.x, Math.random()), MathUtil.lerp(startRotationConstantMinSeparate.z, startRotationConstantMaxSeparate.z, Math.random()), _tempRotationMatrix);
					} else {
						rand.seed = randomSeeds[5];
						Matrix4x4.createRotationYawPitchRoll(MathUtil.lerp(startRotationConstantMinSeparate.y, startRotationConstantMaxSeparate.y, rand.getFloat()), MathUtil.lerp(startRotationConstantMinSeparate.x, startRotationConstantMaxSeparate.x, rand.getFloat()), MathUtil.lerp(startRotationConstantMinSeparate.z, startRotationConstantMaxSeparate.z, rand.getFloat()), _tempRotationMatrix);
						randomSeeds[5] = rand.seed;
					}
					rotationMatrixE = _tempRotationMatrix.elements;
					particleData.startRotation0 = _tempStartRotation0;
					particleRotation0 = particleData.startRotation0;
					particleRotation0[0] = rotationMatrixE[0];
					particleRotation0[1] = rotationMatrixE[1];
					particleRotation0[2] = rotationMatrixE[2];
					
					particleData.startRotation1 = _tempStartRotation1;
					particleRotation1 = particleData.startRotation1;
					particleRotation1[0] = rotationMatrixE[4];
					particleRotation1[1] = rotationMatrixE[5];
					particleRotation1[2] = rotationMatrixE[6];
					
					particleData.startRotation2 = _tempStartRotation2;
					particleRotation2 = particleData.startRotation2;
					particleRotation2[0] = rotationMatrixE[8];
					particleRotation2[1] = rotationMatrixE[9];
					particleRotation2[2] = rotationMatrixE[10];
				} else {
					particleData.startRotation0 = _tempStartRotation0;
					particleRotation0 = particleData.startRotation0;
					if (autoRandomSeed) {
						particleRotation0[0] = particleRotation0[1] = particleRotation0[2] = MathUtil.lerp(particleSystem.startRotationConstantMin, particleSystem.startRotationConstantMax, Math.random());
					} else {
						rand.seed = randomSeeds[5];
						particleRotation0[0] = particleRotation0[1] = particleRotation0[2] = MathUtil.lerp(particleSystem.startRotationConstantMin, particleSystem.startRotationConstantMax, rand.getFloat());
						randomSeeds[5] = rand.seed;
					}
				}
				break;
			}
			
			var randDic:Number;
			if (autoRandomSeed) {
				randDic = Math.random();
			} else {
				rand.seed = randomSeeds[6];
				randDic = rand.getFloat();
				randomSeeds[6] = rand.seed;
			}
			if (randDic < particleSystem.randomizeRotationDirection) {
				particleRotation0[0] = -particleRotation0[0];
				particleRotation0[1] = -particleRotation0[1];
				particleRotation0[2] = -particleRotation0[2];
			}
			
			particleData.startRotation1 = _tempStartRotation1;
			particleData.startRotation2 = _tempStartRotation2;
			
			//StartLifetime
			switch (particleSystem.startLifetimeType) {
			case 0: 
				particleData.startLifeTime = particleSystem.startLifetimeConstant;
				break;
			case 1: 
				particleData.startLifeTime = _getStartLifetimeFromGradient(particleSystem.startLifeTimeGradient, particleSystem.emissionTime);
				break;
			case 2: 
				if (autoRandomSeed) {
					particleData.startLifeTime = MathUtil.lerp(particleSystem.startLifetimeConstantMin, particleSystem.startLifetimeConstantMax, Math.random());
				} else {
					rand.seed = randomSeeds[7];
					particleData.startLifeTime = MathUtil.lerp(particleSystem.startLifetimeConstantMin, particleSystem.startLifetimeConstantMax, rand.getFloat());
					randomSeeds[7] = rand.seed;
				}
				break;
			case 3: 
				var emissionTime:Number = particleSystem.emissionTime;
				if (autoRandomSeed) {
					particleData.startLifeTime = MathUtil.lerp(_getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMin, emissionTime), _getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMax, emissionTime), Math.random());
				} else {
					rand.seed = randomSeeds[7];
					particleData.startLifeTime = MathUtil.lerp(_getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMin, emissionTime), _getStartLifetimeFromGradient(particleSystem.startLifeTimeGradientMax, emissionTime), rand.getFloat());
					randomSeeds[7] = rand.seed;
				}
				break;
			}
			
			//StartSpeed
			switch (particleSystem.startSpeedType) {
			case 0: 
				particleData.startSpeed = particleSystem.startSpeedConstant;
				break;
			case 2: 
				if (autoRandomSeed) {
					particleData.startSpeed = MathUtil.lerp(particleSystem.startSpeedConstantMin, particleSystem.startSpeedConstantMax, Math.random());
				} else {
					rand.seed = randomSeeds[8];
					particleData.startSpeed = MathUtil.lerp(particleSystem.startSpeedConstantMin, particleSystem.startSpeedConstantMax, rand.getFloat());
					randomSeeds[8] = rand.seed;
				}
				break;
			}
			
			//StartUV
			particleData.startUVInfo = _tempStartUVInfo;
			var textureSheetAnimation:TextureSheetAnimation = particleSystem.textureSheetAnimation;
			var enableSheetAnimation:Boolean = textureSheetAnimation && textureSheetAnimation.enbale;
			var startUVInfo:Float32Array;
			if (enableSheetAnimation) {
				var title:Vector2 = textureSheetAnimation.tiles;
				var titleX:int = title.x, titleY:int = title.y;
				var subU:Number = 1.0 / titleX, subV:Number = 1.0 / titleY;
				
				var totalFrameCount:int;
				var startRow:int;
				var randomRow:Boolean = textureSheetAnimation.randomRow;
				switch (textureSheetAnimation.type) {
				case 0://Whole Sheet
					totalFrameCount = titleX * titleY;
					break;
				case 1://Singal Row
					totalFrameCount = titleX;
					if (randomRow) {
						if (autoRandomSeed) {
							startRow = Math.round(Math.random() * titleY);
						} else {
							rand.seed = randomSeeds[13];
							startRow = Math.round(rand.getFloat() * titleY);
							randomSeeds[13] = rand.seed;
						}
					} else {
						startRow = 0;
					}
					break;
				}
				
				var startFrameCount:int;
				var startFrame:StartFrame = textureSheetAnimation.startFrame;
				switch (startFrame.type) {
				case 0://常量模式
					startFrameCount = startFrame.constant;
					break;
				case 1://随机双常量模式
					if (autoRandomSeed) {
						startFrameCount = Math.round(MathUtil.lerp(startFrame.constantMin, startFrame.constantMax, Math.random()));
					} else {
						rand.seed = randomSeeds[14];
						startFrameCount = Math.round(MathUtil.lerp(startFrame.constantMin, startFrame.constantMax, rand.getFloat()));
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
						startFrameCount += Math.round(MathUtil.lerp(frame.constantMin, frame.constantMax, Math.random()));
					} else {
						rand.seed = randomSeeds[15];
						startFrameCount += Math.round(MathUtil.lerp(frame.constantMin, frame.constantMax, rand.getFloat()));
						randomSeeds[15] = rand.seed;
					}
					break;
				}
				
				if (!randomRow)
					startRow = Math.floor(startFrameCount / titleX);
				
				var startCol:int = startFrameCount % titleX;
				startUVInfo = particleData.startUVInfo;
				startUVInfo[0] = subU;
				startUVInfo[1] = subV;
				startUVInfo[2] = startCol * subU;
				startUVInfo[3] = startRow * subV;
			} else {
				startUVInfo = particleData.startUVInfo;
				startUVInfo[0] = 1.0;
				startUVInfo[1] = 1.0;
				startUVInfo[2] = 0.0;
				startUVInfo[3] = 0.0;
			}
			
			particleData.time = time;
			
			particleData.simulationWorldPostion = _tempSimulationWorldPostion;
			var particleSimulationWorldPostion:Float32Array = particleData.simulationWorldPostion;
			if (particleSystem.simulationSpace === 0) {
				var positionE:Float32Array = transform.position.elements;
				particleSimulationWorldPostion[0] = positionE[0];
				particleSimulationWorldPostion[1] = positionE[1];
				particleSimulationWorldPostion[2] = positionE[2];
			} else {//TODO:是否可以不传
				particleSimulationWorldPostion[0] = 0;
				particleSimulationWorldPostion[1] = 0;
				particleSimulationWorldPostion[2] = 0;
			}
			
			return particleData;
		}
	
	}

}