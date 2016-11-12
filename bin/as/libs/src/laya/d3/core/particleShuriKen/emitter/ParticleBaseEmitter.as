package laya.d3.core.particleShuriKen.emitter {
	import laya.d3.core.particleShuriKen.emitter.Burst;
	import laya.d3.core.particleShuriKen.ShurikenParticleSystem;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.maths.MathUtil;
	
	/**
	 * <code>ParticleBaseShape</code> 类用于粒子形状，抽象类不允许实例。
	 */
	public class ParticleBaseEmitter {
		/**@private */
		private var _burstsIndex:int;
		/**@private 粒子的爆裂。*/
		private var _bursts:Vector.<Burst>;
		
		/**@private 是否播放。*/
		protected var _played:Boolean;
		/**@private 是否暂停。*/
		protected var _paused:Boolean;
		
		/**@private 发射的累计时间。*/
		protected var _frameTime:Number;
		/**@private 一次循环内的累计时间。*/
		protected var _emissionTime:Number;
		/**@private 发射粒子最小时间间隔。*/
		protected var _minEmissionTime:Number;
		/**@private 粒子发射速率,每秒发射的个数。*/
		protected var _emissionRate:int;
		
		/**@private 粒子数据模板,开发者禁止修改。*/
		public var _particleSystem:ShurikenParticleSystem;;
		
		/**
		 * 设置粒子发射速率。
		 * @param emissionRate 粒子发射速率 (个/秒)。
		 */
		public function set emissionRate(value:int):void {
			if (value < 0)
				throw new Error("ParticleBaseShape:emissionRate value must large or equal than 0.");
			_emissionRate = value;
			if (value === 0)
				_minEmissionTime = /*int.MAX_VALUE*/ 2147483647;
			else
				_minEmissionTime = 1 / value;
		}
		
		/**
		 * 获取粒子发射速率。
		 * @return 粒子发射速率 (个/秒)。
		 */
		public function get emissionRate():int {
			return _emissionRate;
		}
		
		/**
		 * 创建一个 <code>ParticleBaseShape</code> 实例。
		 */
		public function ParticleBaseEmitter() {
			_burstsIndex = 0;
			_played = false;
			_paused = false;
			_frameTime = 0;
			_emissionTime = 0;
			emissionRate = 10;
			_bursts = new Vector.<Burst>();
		}
		
		/**
		 * @private
		 */
		private function _burst(scale:Vector3 ):void {
			for (var n:int = _bursts.length; _burstsIndex < n; _burstsIndex++) {
				var burst:Burst = _bursts[_burstsIndex];
				var burstTime:Number = burst.time;
				if (_emissionTime >= burstTime && burstTime <= _particleSystem.duration) {
					var emitCount:int = MathUtil.lerp(burst.minCount, burst.maxCount, Math.random());
					for (var i:int = 0; i < emitCount; i++)
						emit(scale);
				} else {
					break;
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _advanceTime(elapsedTime:Number,scale:Vector3):void {
			if (!_played || _paused)
				return;
			
			_emissionTime += elapsedTime;
			_burst(scale);//提前计算，防止最后一帧爆裂丢失
			var duration:Number = _particleSystem.duration;
			if (_emissionTime > duration) {
				if (_particleSystem.looping) {
					_emissionTime -= duration;
					_burstsIndex = 0;
				} else {
					_played = false;
					return;
				}
				
			}
			
			_frameTime += elapsedTime;
			if (_frameTime < _minEmissionTime)
				return;
			while (_frameTime > _minEmissionTime) {
				_frameTime -= _minEmissionTime;
				emit(scale);
			}
		}
		
		/**
		 * 开始发射粒子。
		 */
		public function play():void {
			_burstsIndex = 0;
			_played = true;
			_paused = false;
			_frameTime = 0;
			_emissionTime = 0;
		}
		
		/**
		 * 暂停发射粒子。
		 */
		public function pause():void {
			_paused = true;
		}
		
		/**
		 * 停止发射粒子。
		 */
		public function stop():void {
			_burstsIndex = 0;
			_played = true;
			_paused = false;
			_frameTime = 0;
			_emissionTime = 0;
		}
		
		/**
		 * 获取粒子爆裂个数。
		 * @return 粒子爆裂个数。
		 */
		public function getBurstsCount():int {
			return _bursts.length;
		}
		
		/**
		 * 通过索引获取粒子爆裂。
		 * @param index 爆裂索引。
		 * @return 粒子爆裂。
		 */
		public function getBurstByIndex(index:int):Burst {
			return _bursts[index];
		}
		
		/**
		 * 增加粒子爆裂。
		 * @param burst 爆裂。
		 */
		public function addBurst(burst:Burst):void {
			var burstsCount:int = _bursts.length;
			if (burstsCount > 0)
				for (var i:int = 0; i < burstsCount; i++) {
					if (_bursts[i].time > burst.time)
						_bursts.splice(i, 0, burst);
				}
			else
				_bursts.push(burst);
		}
		
		/**
		 * 移除粒子爆裂。
		 * @param burst 爆裂。
		 */
		public function removeBurst(burst:Burst):void {
			var index:int = _bursts.indexOf(burst);
			if (index !== -1) {
				_bursts.splice(index, 1);
				var maxBurstsIndex:int = _bursts.length;
				if (_burstsIndex > maxBurstsIndex)
					_burstsIndex = maxBurstsIndex;
			}
		}
		
		/**
		 * 通过索引移除粒子爆裂。
		 * @param index 爆裂索引。
		 */
		public function removeBurstByIndex(index:int):void {
			_bursts.splice(index, 1);
			var maxBurstsIndex:int = _bursts.length;
			if (_burstsIndex > maxBurstsIndex)
				_burstsIndex = maxBurstsIndex;
		}
		
		/**
		 * 清空粒子爆裂。
		 */
		public function clearBurst():void {
			_burstsIndex = 0;
			_bursts.length = 0;
		}
		
		/**
		 * 更新球粒子发射器。
		 * @param state 渲染相关状态参数。
		 */
		public function update(elapsedTime:Number,scale:Vector3):void {
			_advanceTime(elapsedTime,scale);
		}
		
		/**
		 * 发射一个粒子,请重载此函数。
		 */
		public function emit(scale:Vector3):void {
			throw new Error("ParticleBaseShape: must override it.");
		}
	
	}

}