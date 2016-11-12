package laya.d3.core.particleShuriKen {
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.GradientColor;
	import laya.d3.core.particleShuriKen.module.GradientAngularVelocity;
	import laya.d3.core.particleShuriKen.module.GradientSize;
	import laya.d3.core.particleShuriKen.module.RotationOverLifetime;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.StartFrame;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector4;
	import laya.maths.MathUtil;
	
	/**
	 *  @private
	 */
	public class ShurikenParticleData {
		private static var _tempDirection:Float32Array = new Float32Array(3);
		private static var _tempStartColor:Float32Array = new Float32Array(4);
		private static var _tempStartSize:Float32Array = new Float32Array(3);
		private static var _tempStartRotation:Float32Array = new Float32Array(3);
		private static var _tempStartUVInfo:Float32Array = new Float32Array(4);
		
		public var startLifeTime:Number;
		
		public var position:Float32Array;
		public var direction:Float32Array;
		public var startColor:Float32Array;
		public var startSize:Float32Array;
		public var startRotation:Float32Array;
		
		public var time:Number;
		public var startSpeed:Number;
		public var startUVInfo:Float32Array;
		
		public function ShurikenParticleData() {
		
		}
		
		public static function Create(particleSystem:ShurikenParticleSystem, position:Float32Array, direction:Float32Array, time:Number):ShurikenParticleData {
			var particleData:ShurikenParticleData = new ShurikenParticleData();
			particleData.position = position;
			
			MathUtil.scaleVector3(direction, 1.0/*settings.emitterVelocitySensitivity*/, _tempDirection);//TODO
			//var horizontalVelocity:Number = MathUtil.lerp(settings.minHorizontalVelocity, settings.maxHorizontalVelocity, Math.random());
			//var horizontalAngle:Number = Math.random() * Math.PI * 2;
			//_tempDirection[0] += horizontalVelocity * Math.cos(horizontalAngle);
			//_tempDirection[2] += horizontalVelocity * Math.sin(horizontalAngle);
			//_tempDirection[1] += MathUtil.lerp(settings.minVerticalVelocity, settings.maxVerticalVelocity, Math.random());
			particleData.direction = _tempDirection;
			
			//StartColor
			particleData.startColor = _tempStartColor;
			switch (particleSystem.startColorType) {
			case 0: 
				var startColorE:Float32Array = particleData.startColor;
				var constantStartColorE:Float32Array = particleSystem.constantStartColor.elements;
				startColorE[0] = constantStartColorE[0];
				startColorE[1] = constantStartColorE[1];
				startColorE[2] = constantStartColorE[2];
				startColorE[3] = constantStartColorE[3];
				break;
			case 2: 
				MathUtil.lerpVector4(particleSystem.constantMinStartColor.elements, particleSystem.constantMaxStartColor.elements, Math.random(), particleData.startColor);
				break;
			}
			var colorOverLifetime:ColorOverLifetime = particleSystem.colorOverLifetime;
			if (colorOverLifetime && colorOverLifetime.enbale) {
				var startColor:Float32Array = particleData.startColor;
				var color:GradientColor = colorOverLifetime.color;
				switch (color.type) {
				case 0: 
					startColor[0] = startColor[0] * color.constantColor.x;
					startColor[1] = startColor[1] * color.constantColor.y;
					startColor[2] = startColor[2] * color.constantColor.z;
					startColor[3] = startColor[3] * color.constantColor.w;
					break;
				case 2: 
					var colorRandom:Number = Math.random();
					var minConstantColor:Vector4 = color.minConstantColor;
					var maxConstantColor:Vector4 = color.maxConstantColor;
					startColor[0] = startColor[0] * MathUtil.lerp(minConstantColor.x, maxConstantColor.x, colorRandom);
					startColor[1] = startColor[1] * MathUtil.lerp(minConstantColor.y, maxConstantColor.y, colorRandom);
					startColor[2] = startColor[2] * MathUtil.lerp(minConstantColor.z, maxConstantColor.z, colorRandom);
					startColor[3] = startColor[3] * MathUtil.lerp(minConstantColor.w, maxConstantColor.w, colorRandom);
					break;
				}
			}
			
			//StartSize
			particleData.startSize = _tempStartSize;
			var startSize:Number;
			var particleSize:Float32Array = particleData.startSize;
			switch (particleSystem.startSizeType) {
			case 0: 
				startSize = particleSystem.constantStartSize;
				break;
			case 2: 
				startSize = MathUtil.lerp(particleSystem.constantMinStartSize, particleSystem.constantMaxStartSize, Math.random());
				break;
			}
			var sizeOverLifetime:SizeOverLifetime = particleSystem.sizeOverLifetime;
			if (sizeOverLifetime && sizeOverLifetime.enbale && sizeOverLifetime.size.type === 1) {
				var size:GradientSize = sizeOverLifetime.size;
				if (size.separateAxes) {
					particleSize[0] = startSize * MathUtil.lerp(size.constantMinSeparate.x, size.constantMaxSeparate.x, Math.random());
					particleSize[1] = startSize * MathUtil.lerp(size.constantMinSeparate.y, size.constantMaxSeparate.y, Math.random());
					particleSize[2] = startSize * MathUtil.lerp(size.constantMinSeparate.z, size.constantMaxSeparate.z, Math.random());
				} else {
					particleSize[0] = particleSize[1] = particleSize[2] = startSize * MathUtil.lerp(size.constantMin, size.constantMax, Math.random());
				}
			} else {
				particleSize[0] = particleSize[1] = particleSize[2] = startSize;
			}
			
			//StartRotation
			particleData.startRotation = _tempStartRotation;
			var startRotation:Number;
			var particleRotation:Float32Array = particleData.startRotation;
			switch (particleSystem.startRotationType) {
			case 0: 
				startRotation = particleSystem.constantStartRotation;
				break;
			case 2: 
				startRotation = MathUtil.lerp(particleSystem.constantMinStartRotation, particleSystem.constantMaxStartRotation, Math.random());
				break;
			}
			(Math.random() < particleSystem.randomizeRotationDirection) && (startRotation = -startRotation);
			particleRotation[0] = particleRotation[1] = particleRotation[2] = startRotation;
			
			//StartLifetime
			switch (particleSystem.startLifeTimeType) {
			case 0: 
				particleData.startLifeTime = particleSystem.constantStartLifeTime;
				break;
			case 2: 
				particleData.startLifeTime = MathUtil.lerp(particleSystem.constantMinStartLifeTime, particleSystem.constantMaxStartLifeTime, Math.random());
				break;
			}
			
			switch (particleSystem.startSpeedType) {
			case 0: 
				particleData.startSpeed = particleSystem.constantStartSpeed;
				break;
			case 2: 
				particleData.startSpeed = MathUtil.lerp(particleSystem.constantMinStartSpeed, particleSystem.constantMaxStartSpeed, Math.random());
				break;
			}
			

			//StartUV
			particleData.startUVInfo = _tempStartUVInfo;
			var textureSheetAnimation:TextureSheetAnimation = particleSystem.textureSheetAnimation;
			var enableSheetAnimation:Boolean = textureSheetAnimation && textureSheetAnimation.enbale;
			var startUVInfo:Float32Array;
			if (enableSheetAnimation) {
				var title:Vector2 = textureSheetAnimation.title;
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
					if (randomRow)
						startRow = Math.round(Math.random() * titleY);
					else
						startRow = 0;
					break;
				}
				
				var startFrameCount:int;
				var startFrame:StartFrame = textureSheetAnimation.startFrame;
				switch (startFrame.type) {
				case 0://常量模式
					startFrameCount = startFrame.constant;
					break;
				case 1://随机双常量模式
					startFrameCount = Math.round(MathUtil.lerp(startFrame.constantMin, startFrame.constantMax, Math.random()));
					break;
				}
				
				var frame:FrameOverTime = textureSheetAnimation.frame;
				switch (frame.type) {
				case 0: 
					startFrameCount += frame.constant;
					break;
				case 2: 
					startFrameCount += Math.round(MathUtil.lerp(frame.constantMin, frame.constantMax, Math.random()));
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
			return particleData;
		}
	
	}

}