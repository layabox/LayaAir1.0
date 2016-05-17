package laya.particle {
	import laya.maths.MathUtil;
	
	/**
	 *  @private
	 */
	public class ParticleData {
		private static var  _tempVelocity:Float32Array = new Float32Array(3);
		private static var  _tempColor:Float32Array = new Float32Array(4);
		private static var  _tempSizeRotation:Float32Array = new Float32Array(3);
		private static var  _tempRadiusRadian:Float32Array=new Float32Array(4);
		
		public var position:Float32Array;
		public var velocity:Float32Array;
		public var color:Float32Array;
		public var sizeRotation:Float32Array;
		public var radiusRadian:Float32Array;
		public var durationAddScale:Number;
		public var time:Number;
		
		public function ParticleData() {
			
		}
		
		public static function Create(settings:ParticleSettings, position:Float32Array, velocity:Float32Array, time:Number):ParticleData {
			var particleData:ParticleData = new ParticleData();
			particleData.position = position;
			
			MathUtil.scaleVector3(velocity, settings.emitterVelocitySensitivity, _tempVelocity);
			var horizontalVelocity:Number = MathUtil.lerp(settings.minHorizontalVelocity, settings.maxHorizontalVelocity, Math.random());
			var horizontalAngle:Number = Math.random() * Math.PI * 2;
			_tempVelocity[0] += horizontalVelocity * Math.cos(horizontalAngle);
			_tempVelocity[2] += horizontalVelocity * Math.sin(horizontalAngle);
			_tempVelocity[1] += MathUtil.lerp(settings.minVerticalVelocity, settings.maxVerticalVelocity, Math.random());
			particleData.velocity = _tempVelocity;
			
			particleData.color = _tempColor;
			var i:int;
			if (settings.colorComponentInter) {
				for (i = 0; i < 4; i++)
					particleData.color[i] = MathUtil.lerp(settings.minColor[i], settings.maxColor[i], Math.random());//R、G、B、A插值
			} else {
				MathUtil.lerpVector4(settings.minColor, settings.maxColor, Math.random(), particleData.color);//RGBA统一插值
			}
			
			particleData.sizeRotation =_tempSizeRotation;
			var sizeRandom:Number = Math.random();
			particleData.sizeRotation[0] = MathUtil.lerp(settings.minStartSize, settings.maxStartSize, sizeRandom);//StartSize
			particleData.sizeRotation[1] = MathUtil.lerp(settings.minEndSize, settings.maxEndSize, sizeRandom);//EndSize
			particleData.sizeRotation[2] = MathUtil.lerp(settings.minRotateSpeed, settings.maxRotateSpeed, Math.random());//Rotation
			
			particleData.radiusRadian = _tempRadiusRadian;
			var radiusRandom:Number = Math.random();
			particleData.radiusRadian[0] = MathUtil.lerp(settings.minStartRadius, settings.maxStartRadius, radiusRandom);//StartRadius
			particleData.radiusRadian[1] = MathUtil.lerp(settings.minEndRadius, settings.maxEndRadius, radiusRandom);//EndRadius
			particleData.radiusRadian[2] = MathUtil.lerp(settings.minHorizontalEndRadian, settings.maxHorizontalEndRadian, Math.random());//EndHorizontalRadian
			particleData.radiusRadian[3] = MathUtil.lerp(settings.minVerticalEndRadian, settings.maxVerticalEndRadian, Math.random());//EndVerticleRadian
			
			particleData.durationAddScale = settings.ageAddScale * Math.random();
			
			particleData.time = time;
			return particleData;
		}
	
	}

}