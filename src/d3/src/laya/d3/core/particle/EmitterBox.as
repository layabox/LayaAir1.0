package laya.d3.core.particle {
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.particle.ParticleSetting;
	import laya.particle.emitter.EmitterBase;
	
	/**
	 * <code>EmitterBox</code> 类用于盒发射器。
	 */
	public class EmitterBox extends EmitterBase {
		/** @private */
		protected var _settings:ParticleSetting;
		/** @private */
		protected var _particle3D:Particle3D;
		/** @private */
		protected var _resultPosition:Vector3 = new Vector3();
		/** @private */
		protected var _resultVelocity:Vector3 = new Vector3();
		
		/**发射器中心位置。*/
		public var centerPosition:Vector3 = new Vector3();
		/**发射器尺寸。*/
		public var size:Vector3 = new Vector3();
		/**发射器速度。*/
		public var velocity:Vector3 = new Vector3();
		/**发射器速度随机值。*/
		public var velocityAddVariance:Vector3 = new Vector3();
		
		/**
		 * 创建一个 <code>EmitterBox</code> 实例。
		 * @param particle3D 粒子。
		 */
		public function EmitterBox(particle3D:Particle3D) {
			_particle3D = particle3D;
			var setting:ParticleSetting = particle3D.templet.settings;
			for (var i:int = 0; i < 3; i++) {
				centerPosition.elements[i] = setting.boxEmitterCenterPosition[i];
				size.elements[i] = setting.boxEmitterSize[i];
				velocity.elements[i] = setting.boxEmitterVelocity[i];
				velocityAddVariance.elements[i] = setting.boxEmitterVelocityAddVariance[i];
			}
			emissionRate = setting.emissionRate;
		}
		
		/**
		 * @private
		 */
		protected function _randomPositionOnBox():Vector3 {
			var rpe:Float32Array = _resultPosition.elements;
			var cpe:Float32Array = centerPosition.elements;
			var se:Float32Array = size.elements;
			rpe[0] = cpe[0] + se[0] * (Math.random() - 0.5);
			rpe[1] = cpe[1] + se[1] * (Math.random() - 0.5);
			rpe[2] = cpe[2] + se[2] * (Math.random() - 0.5);
			return _resultPosition;
		}
		
		/**
		 * @private
		 */
		protected function _randomVelocityOnBox():Vector3 {
			var rve:Float32Array = _resultVelocity.elements;
			var ve:Float32Array = velocity.elements;
			var vve:Float32Array = velocityAddVariance.elements;
			
			rve[0] = ve[0] + vve[0] * Math.random();
			rve[1] = ve[1] + vve[1] * Math.random();
			rve[2] = ve[2] + vve[2] * Math.random();
			return _resultVelocity;
		}
		
		/**
		 * 盒发射器发射函数。
		 */
		override public function emit():void {
			super.emit();
			_particle3D.templet.addParticle(_randomPositionOnBox(), _randomVelocityOnBox());
		}
		
		/**
		 * 更新盒粒子发射器。
		 * @param state 渲染相关状态参数。
		 */
		public function update(state:RenderState):void {
			advanceTime(state.elapsedTime / 1000);
		}
	
	}
}