package laya.particle.emitter {
	import laya.particle.ParticleTemplateBase;
	import laya.particle.ParticleTemplateBase;
	/**
	 * <code>EmitterBase</code> 类是粒子发射器类
	 */
	public class EmitterBase {
		/**
		 * 积累的帧时间
		 */
		protected var _frameTime:Number = 0;
		/**
		 * 粒子发射速率
		 */
		protected var _emissionRate:Number = 60; // emitted particles per second
		/**
		 * 当前剩余发射时间
		 */
		protected var _emissionTime:Number = 0;
		/**
		 * 发射粒子最小时间间隔
		 */
		public var minEmissionTime:Number = 1 / 60;
		
		/**@private */
		public var _particleTemplate:ParticleTemplateBase;
		
		/**
		 * 设置粒子粒子模板
		 * @param particleTemplate 粒子模板
		 *
		 */
		public function set particleTemplate(particleTemplate:ParticleTemplateBase):void {
			this._particleTemplate = particleTemplate;
		}
		
		/**
		 * 设置粒子发射速率
		 * @param emissionRate 粒子发射速率 (个/秒)
		 */
		public function set emissionRate(_emissionRate:Number):void {
			if (_emissionRate <= 0) return;
			this._emissionRate = _emissionRate;
			(_emissionRate > 0) && (minEmissionTime = 1 / _emissionRate);
		}
		
		/**
		 * 获取粒子发射速率
		 * @return 发射速率  粒子发射速率 (个/秒)
		 */
		public function get emissionRate():Number {
			return _emissionRate;
		}
		
		/**
		 * 开始发射粒子
		 * @param duration 发射持续的时间(秒)
		 */
		public function start(duration:Number = 2147483647):void {
			if (_emissionRate != 0)
				_emissionTime = duration;
		}
		
		/**
		 * 停止发射粒子
		 * @param clearParticles 是否清理当前的粒子
		 */
		public function stop():void {
			_emissionTime = 0;
		}
		
		/**
		 * 清理当前的活跃粒子
		 * @param clearTexture 是否清理贴图数据,若清除贴图数据将无法再播放
		 */
		public function clear():void {
			_emissionTime = 0;
		}
		
		/**
		 * 发射一个粒子
		 *
		 */
		public function emit():void {
		
		}
		
		/**
		 * 时钟前进
		 * @param passedTime 前进时间
		 *
		 */
		public function advanceTime(passedTime:Number = 1):void {
			_emissionTime -= passedTime;
			if (_emissionTime < 0) return;
			_frameTime += passedTime;
			if (_frameTime < minEmissionTime) return;
			while (_frameTime > minEmissionTime) {
				_frameTime -= minEmissionTime;
				emit();
			}
		}
	}

}