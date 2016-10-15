package laya.particle {
	import laya.maths.MathUtil;
	
	/**
	 *  @private
	 */
	public class ParticleData {
		private static var  _tempVelocity:Float32Array = new Float32Array(3);
		private static var  _tempStartColor:Float32Array = new Float32Array(4);
		private static var  _tempEndColor:Float32Array = new Float32Array(4);
		private static var  _tempSizeRotation:Float32Array = new Float32Array(3);
		private static var  _tempRadius:Float32Array = new Float32Array(2);
		private static var  _tempRadian:Float32Array=new Float32Array(4);
		
		public var position:Float32Array;
		public var velocity:Float32Array;
		public var startColor:Float32Array;
		public var endColor:Float32Array;
		public var sizeRotation:Float32Array;
		public var radius:Float32Array;
		public var radian:Float32Array;
		public var durationAddScale:Number;
		public var time:Number;
		
		public function ParticleData() {
			
		}
		
		public static function Create(settings:ParticleSetting, position:Float32Array, velocity:Float32Array, time:Number):ParticleData {
			var particleData:ParticleData = new ParticleData();
			particleData.position = position;
			
			MathUtil.scaleVector3(velocity, settings.emitterVelocitySensitivity, _tempVelocity);
			var horizontalVelocity:Number = MathUtil.lerp(settings.minHorizontalVelocity, settings.maxHorizontalVelocity, Math.random());
			var horizontalAngle:Number = Math.random() * Math.PI * 2;
			_tempVelocity[0] += horizontalVelocity * Math.cos(horizontalAngle);
			_tempVelocity[2] += horizontalVelocity * Math.sin(horizontalAngle);
			_tempVelocity[1] += MathUtil.lerp(settings.minVerticalVelocity, settings.maxVerticalVelocity, Math.random());
			particleData.velocity = _tempVelocity;
			
			particleData.startColor = _tempStartColor;
			particleData.endColor = _tempEndColor;
			var i:int;
			if (settings.colorComponentInter) {
				for (i = 0; i < 4; i++)
				{
					particleData.startColor[i] = MathUtil.lerp(settings.minStartColor[i], settings.maxStartColor[i], Math.random());//R、G、B、A插值
					particleData.endColor[i] = MathUtil.lerp(settings.minEndColor[i], settings.maxEndColor[i], Math.random());//R、G、B、A插值
				}
			} else {
				MathUtil.lerpVector4(settings.minStartColor, settings.maxStartColor, Math.random(), particleData.startColor);//RGBA统一插值
				MathUtil.lerpVector4(settings.minEndColor, settings.maxEndColor, Math.random(), particleData.endColor);//RGBA统一插值
			}
			
			particleData.sizeRotation =_tempSizeRotation;
			var sizeRandom:Number = Math.random();
			particleData.sizeRotation[0] = MathUtil.lerp(settings.minStartSize, settings.maxStartSize, sizeRandom);//StartSize
			particleData.sizeRotation[1] = MathUtil.lerp(settings.minEndSize, settings.maxEndSize, sizeRandom);//EndSize
			particleData.sizeRotation[2] = MathUtil.lerp(settings.minRotateSpeed, settings.maxRotateSpeed, Math.random());//Rotation
			
			particleData.radius = _tempRadius;
			var radiusRandom:Number = Math.random();
			particleData.radius[0] = MathUtil.lerp(settings.minStartRadius, settings.maxStartRadius, radiusRandom);//StartRadius
			particleData.radius[1] = MathUtil.lerp(settings.minEndRadius, settings.maxEndRadius, radiusRandom);//EndRadius
			
			particleData.radian = _tempRadian;
			particleData.radian[0] = MathUtil.lerp(settings.minHorizontalStartRadian, settings.maxHorizontalStartRadian, Math.random());//StartHorizontalRadian
			particleData.radian[1] = MathUtil.lerp(settings.minVerticalStartRadian, settings.maxVerticalStartRadian, Math.random());//StartVerticleRadian
			var  useEndRadian:Boolean = settings.useEndRadian;
			particleData.radian[2] = useEndRadian?MathUtil.lerp(settings.minHorizontalEndRadian, settings.maxHorizontalEndRadian, Math.random()):particleData.radian[0] ;//EndHorizontalRadian
			particleData.radian[3] = useEndRadian?MathUtil.lerp(settings.minVerticalEndRadian, settings.maxVerticalEndRadian, Math.random()):particleData.radian[1];//EndVerticleRadian
			
			particleData.durationAddScale = settings.ageAddScale * Math.random();
			
			particleData.time = time;
			return particleData;
		}
	
	}

}