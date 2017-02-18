package laya.d3.core.particle {
	import laya.d3.math.Vector3;
	import laya.particle.ParticleSetting;
	import laya.particle.emitter.EmitterBase;
	
	/**
	 * <code>EmitterRing</code> 类用于环发射器。
	 */
	public class EmitterRing extends EmitterBase {
		/** @private */
		protected var _settings:ParticleSetting;
		/** @private */
		protected var _particle3D:Particle3D;
		/** @private */
		protected var _resultPosition:Vector3 = new Vector3();
		/** @private */
		protected var _resultVelocity:Vector3 = new Vector3();
		/** @private */
		protected var _direction:Vector3 = new Vector3();
		
		/**发射器中心位置。*/
		public var centerPosition:Vector3 = new Vector3();
		/**发射器半径。*/
		public var radius:Number = 30;
		/**发射器速度。*/
		public var velocity:Number = 0;
		/**发射器速度随机值。*/
		public var velocityAddVariance:Number = 0;
		/**发射器up向量，0代表X轴,1代表Y轴,2代表Z轴。*/
		public var up:int = 2;
		
		/**
		 * 创建一个 <code>EmitterRing</code> 实例。
		 * @param particle3D 粒子。
		 */
		public function EmitterRing(particle3D:Particle3D) {
			_particle3D = particle3D;
			var setting:ParticleSetting = particle3D.templet.settings;
			for (var i:int = 0; i < 3; i++) {
				centerPosition.elements[i] = setting.ringEmitterCenterPosition[i];
			}
			radius = setting.ringEmitterRadius
			velocity = setting.ringEmitterVelocity
			velocityAddVariance = setting.ringEmitterVelocityAddVariance
			emissionRate = setting.emissionRate;
		}
		
		/**
		 * @private
		 */
		protected function _randomPointOnRing():Vector3 {
			var angle:Number = Math.random() * Math.PI * 2;
			var x:Number = Math.cos(angle);
			var y:Number = Math.sin(angle);
			
			var rpe:Float32Array = _resultPosition.elements;
			var cpe:Float32Array = centerPosition.elements;
			switch (up) {
			case 0: 
				rpe[0] = cpe[0] + 0;
				rpe[1] = cpe[1] + x * radius;
				rpe[2] = cpe[2] + y * radius;
				break;
			case 1: 
				rpe[0] = cpe[0] + x * radius;
				rpe[1] = cpe[1] + 0;
				rpe[2] = cpe[2] + y * radius;
				break;
			case 2: 
				rpe[0] = cpe[0] + x * radius;
				rpe[1] = cpe[1] + y * radius;
				rpe[2] = cpe[2] + 0;
				break;
			}
			
			return _resultPosition;
		}
		
		/**
		 * @private
		 */
		protected function _randomVelocityOnRing():Vector3 {
			var rve:Float32Array = _resultVelocity.elements;
			
			_resultPosition.cloneTo(_direction);
			Vector3.normalize(_direction, _direction);
			var de:Float32Array = _direction.elements;
			
			rve[0] = de[0] * (velocity + velocityAddVariance * Math.random());
			rve[1] = de[1] * (velocity + velocityAddVariance * Math.random());
			rve[2] = de[2] * (velocity + velocityAddVariance * Math.random());
			return _resultVelocity;
		}
		
		/**
		 * 环发射器发射函数。
		 */
		override public function emit():void {
			super.emit();
			_particle3D.templet.addParticle(_randomPointOnRing(), _randomVelocityOnRing());
		}
		
		/**
		 * 更新环粒子发射器。
		 * @param state 渲染相关状态参数。
		 */
		public function update(elapsedTime:Number):void {
			advanceTime(elapsedTime / 1000);
		}
	
	}
}