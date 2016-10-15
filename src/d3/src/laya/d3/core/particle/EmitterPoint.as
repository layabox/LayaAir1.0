package laya.d3.core.particle {
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.particle.ParticleSetting;
	import laya.particle.emitter.EmitterBase;
	
	/**
	 * <code>EmitterPoint</code> 类用于点发射器。
	 */
	public class EmitterPoint extends EmitterBase {
		/** @private */
		protected var _settings:ParticleSetting;
		/** @private */
		protected var _particle3D:Particle3D;
		/** @private */
		protected var _resultPosition:Vector3 = new Vector3();
		/** @private */
		protected var _resultVelocity:Vector3 = new Vector3();
		
		/**发射器位置。*/
		public var position:Vector3 = new Vector3();
		/**发射器位置随机值。*/
		public var positionVariance:Vector3 = new Vector3();
		/**发射器速度。*/
		public var velocity:Vector3 = new Vector3();
		/**发射器速度随机值。*/
		public var velocityAddVariance:Vector3 = new Vector3();
		
		/**
		 * 创建一个 <code>EmitterPoint</code> 实例。
		 * @param particle3D 粒子。
		 */
		public function EmitterPoint(particle3D:Particle3D) {
			_particle3D = particle3D;
			var setting:ParticleSetting = particle3D.templet.settings;
			for (var i:int = 0; i < 3; i++) {
				position.elements[i] = setting.pointEmitterPosition[i];
				positionVariance.elements[i] = setting.pointEmitterPositionVariance[i];
				velocity.elements[i] = setting.pointEmitterVelocity[i];
				velocityAddVariance.elements[i] = setting.pointEmitterVelocityAddVariance[i];
			}
			emissionRate = setting.emissionRate;
		}
		
		/**
		 * @private
		 */
		protected function _randomPositionOnPoint():Vector3 {
			var rpe:Float32Array = _resultPosition.elements;
			var pe:Float32Array = position.elements;
			var pve:Float32Array = positionVariance.elements;
			
			rpe[0] = pe[0] + pve[0] * (Math.random() - 0.5) * 2;
			rpe[1] = pe[1] + pve[1] * (Math.random() - 0.5) * 2;
			rpe[2] = pe[2] + pve[2] * (Math.random() - 0.5) * 2;
			return _resultPosition;
		}
		
		/**
		 * @private
		 */
		protected function _randomVelocityOnPoint():Vector3 {
			var rve:Float32Array = _resultVelocity.elements;
			var ve:Float32Array = velocity.elements;
			var vve:Float32Array = velocityAddVariance.elements;
			
			rve[0] = ve[0] + vve[0] * Math.random();
			rve[1] = ve[1] + vve[1] * Math.random();
			rve[2] = ve[2] + vve[2] * Math.random();
			return _resultVelocity;
		}
		
		/**
		 * 点发射器发射函数。
		 */
		override public function emit():void {
			super.emit();
			_particle3D.templet.addParticle(_randomPositionOnPoint(), _randomVelocityOnPoint());
		}
		
		/**
		 * 更新点粒子发射器。
		 * @param state 渲染相关状态参数。
		 */
		public function update(state:RenderState):void {
			advanceTime(state.elapsedTime / 1000);
		}
	
	}
}