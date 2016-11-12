package laya.particle {
	import laya.maths.MathUtil;
	
	/**
	 *  @private
	 */
	public class ParticleEmitter {
		private var _templet:ParticleTemplateBase;
		private var _timeBetweenParticles:Number;
		private var _previousPosition:Float32Array;
		private var _timeLeftOver:Number = 0;
		
		private var _tempVelocity:Float32Array = new Float32Array([0, 0, 0]);
		private var _tempPosition:Float32Array = new Float32Array([0, 0, 0]);
		
		public function ParticleEmitter(templet:ParticleTemplateBase, particlesPerSecond:Number, initialPosition:Float32Array) {
			_templet = templet;
			_timeBetweenParticles = 1.0 / particlesPerSecond;
			_previousPosition = initialPosition;
		}
		
		public function update(elapsedTime:Number, newPosition:Float32Array):void {
			elapsedTime = elapsedTime / 1000;//需秒为单位
			if (elapsedTime > 0) {
				MathUtil.subtractVector3(newPosition, _previousPosition, _tempVelocity);
				MathUtil.scaleVector3(_tempVelocity, 1 / elapsedTime, _tempVelocity);
				
				var timeToSpend:Number = _timeLeftOver + elapsedTime;
				var currentTime:Number = -_timeLeftOver;
				
				while (timeToSpend > _timeBetweenParticles) {
					currentTime += _timeBetweenParticles;
					timeToSpend -= _timeBetweenParticles;
					
					MathUtil.lerpVector3(_previousPosition, newPosition, currentTime / elapsedTime, _tempPosition);
					
					_templet.addParticleArray(_tempPosition, _tempVelocity);
				}
				
				_timeLeftOver = timeToSpend;
			}
			_previousPosition[0] = newPosition[0];
			_previousPosition[1] = newPosition[1];
			_previousPosition[2] = newPosition[2];
		}
	}
}