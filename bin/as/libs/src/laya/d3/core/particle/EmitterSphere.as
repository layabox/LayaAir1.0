package laya.d3.core.particle {
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.particle.ParticleSetting;
	import laya.particle.emitter.EmitterBase;
	
	/**
	 * <code>EmitterSphere</code> 类用于球发射器。
	 */
	public class EmitterSphere extends EmitterBase {
		/** @private */
		protected var _settings:ParticleSetting;
		/** @private */
		protected var _particle3D:Particle3D;
		/** @private */
		protected var _reultPosition:Vector3 = new Vector3();
		/** @private */
		protected var _resultVelocity:Vector3 = new Vector3();
		/** @private */
		protected var _direction:Vector3 = new Vector3();
		
		/**发射器中心位置。*/
		public var centerPosition:Vector3 = new Vector3();
		/**发射器半径。*/
		public var radius:Number = 1;
		/**发射器速度。*/
		public var velocity:Number = 0;
		/**发射器速度随机值。*/
		public var velocityAddVariance:Number = 0;
		
		/**
		 * 创建一个 <code>EmitterSphere</code> 实例。
		 * @param particle3D 粒子。
		 */
		public function EmitterSphere(particle3D:Particle3D) {
			_particle3D = particle3D;
			var setting:ParticleSetting = particle3D.templet.settings;
			for (var i:int = 0; i < 3; i++) {
				centerPosition.elements[i] = setting.sphereEmitterCenterPosition[i];
			}
			radius = setting.sphereEmitterRadius
			velocity = setting.sphereEmitterVelocity
			velocityAddVariance = setting.sphereEmitterVelocityAddVariance
			emissionRate = setting.emissionRate;
		}
		
		/**
		 * @private
		 */
		protected function _randomPositionOnSphere():Vector3 {
			var angleVer:Number = Math.random() * Math.PI * 2;
			var angleHor:Number = Math.random() * Math.PI * 2;
			var r:Number = Math.cos(angleVer) * radius;
			var y:Number = Math.sin(angleVer) * radius;
			var x:Number = Math.cos(angleHor) * r;
			var z:Number = Math.sin(angleHor) * r;
			
			var rpe:Float32Array = _reultPosition.elements;
			var cpe:Float32Array = centerPosition.elements;
			
			rpe[0] = cpe[0] + x;
			rpe[1] = cpe[1] + y;
			rpe[2] = cpe[2] + z;
			return _reultPosition;
		}
		
		/**
		 * @private
		 */
		protected function _randomVelocityOnSphere():Vector3 {
			var rve:Float32Array = _resultVelocity.elements;
			_reultPosition.cloneTo(_direction);
			Vector3.normalize(_direction, _direction);
			var de:Float32Array = _direction.elements;
			
			rve[0] = de[0] * (velocity + velocityAddVariance * Math.random());
			rve[1] = de[1] * (velocity + velocityAddVariance * Math.random());
			rve[2] = de[2] * (velocity + velocityAddVariance * Math.random());
			return _resultVelocity;
		}
		
		/**
		 * 球发射器发射函数。
		 */
		override public function emit():void {
			super.emit();
			_particle3D.templet.addParticle(_randomPositionOnSphere(), _randomVelocityOnSphere());
		}
		
		/**
		 * 更新球粒子发射器。
		 * @param state 渲染相关状态参数。
		 */
		public function update(state:RenderState):void {
			advanceTime(state.elapsedTime / 1000);
		}
	
	}
}