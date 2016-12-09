package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.Transform3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleSystem;
	import laya.d3.core.particleShuriKen.module.shape.BaseShape;
	import laya.d3.core.particleShuriKen.module.Burst;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.maths.MathUtil;
	import laya.resource.IDestroy;
	import laya.utils.Stat;
	
	/**开始播放时调度。
	 * @eventType Event.PLAYED
	 * */
	[Event(name = "played", type = "laya.events.Event")]
	/**暂停时调度。
	 * @eventType Event.PAUSED
	 * */
	[Event(name = "paused", type = "laya.events.Event")]
	/**完成一次循环时调度。
	 * @eventType Event.COMPLETE
	 * */
	[Event(name = "complete", type = "laya.events.Event")]
	/**停止时调度。
	 * @eventType Event.STOPPED
	 * */
	[Event(name = "stopped", type = "laya.events.Event")]
	
	/**
	 * <code>Emission</code> 类用于粒子发射器。
	 */
	public class Emission extends EventDispatcher implements IDestroy{
		/** @private */
		private static var _tempPosition:Vector3 = new Vector3();
		/** @private */
		private static var _tempDirection:Vector3 = new Vector3();
		
		/**@private */
		private var _burstsIndex:int;
		/**@private 粒子的爆裂。*/
		private var _bursts:Vector.<Burst>;
		/**@private */
		private var _startDelay:Number;
		
		/**@private 是否播放。*/
		protected var _isPlaying:Boolean;
		/**@private 是否暂停。*/
		protected var _isPaused:Boolean;
		
		/**@private 发射的累计时间。*/
		protected var _frameTime:Number;
		/**@private 一次循环内的累计时间。*/
		protected var _emissionTime:Number;
		/**@private 播放的累计时间。*/
		protected var _playbackTime:Number;
		/**@private 发射粒子最小时间间隔。*/
		protected var _minEmissionTime:Number;
		/**@private 粒子发射速率,每秒发射的个数。*/
		protected var _emissionRate:int;
		
		/**@private 粒子数据模板,开发者禁止修改。*/
		public var _particleSystem:ShurikenParticleSystem;
		/**@private 粒子形状,开发者禁止修改。*/
		public var _shape:BaseShape;
		
		/**是否启用。*/
		public var enbale:Boolean;
		
		/**是否正在播放。*/
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		/**是否已暂停。*/
		public function get isPaused():Boolean {
			return _isPaused;
		}
		
		/**
		 * 获取一次循环内的累计时间。
		 * @return 一次循环内的累计时间。
		 */
		public function get emissionTime():int {
			var duration:Number = _particleSystem.duration;
			return _emissionTime > duration ? duration : _emissionTime;
		}
		
		/**
		 * 获取播放的累计时间。
		 * @return 播放的累计时间。
		 */
		public function get playbackTime():Number {
			return _playbackTime;
		}
		
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
		 * 创建一个 <code>Emission</code> 实例。
		 */
		public function Emission() {
			_burstsIndex = 0;
			_isPlaying = false;
			_isPaused = false;
			_frameTime = 0;
			_emissionTime = 0;
			_playbackTime = 0;
			emissionRate = 10;
			_bursts = new Vector.<Burst>();
		}
		
		/**
		 * @private
		 */
		private function _burst(fromTime:Number, toTime:Number):int {
			var totalEmitCount:int = 0;
			for (var n:int = _bursts.length; _burstsIndex < n; _burstsIndex++) {
				var burst:Burst = _bursts[_burstsIndex];
				var burstTime:Number = burst.time;
				if (burstTime >= fromTime && burstTime <= toTime) {
					var emitCount:int = MathUtil.lerp(burst.minCount, burst.maxCount, Math.random());
					totalEmitCount += emitCount;
				} else {
					break;
				}
			}
			return totalEmitCount;
		}
		
		/**
		 * @private
		 */
		private function _advanceTime(elapsedTime:Number, transform:Transform3D):void {
			if (!_isPlaying || _isPaused)
				return;
			
			_playbackTime += elapsedTime;
			if (_playbackTime < _startDelay)
				return;
			var i:int;
			var lastEmissionTime:Number = _emissionTime;
			_emissionTime += elapsedTime;
			var duration:Number = _particleSystem.duration;
			var totalBurstCount:int = 0;
			if (_emissionTime > duration) {
				totalBurstCount += _burst(lastEmissionTime, duration);//爆裂剩余未触发的//TODO:是否可以用_playbackTime代替计算，不必结束再爆裂一次。//TODO:待确认是否累计爆裂
				if (_particleSystem.looping) {//TODO:有while
					_emissionTime -= duration;
					this.event(Event.COMPLETE);
					_burstsIndex = 0;
					totalBurstCount += _burst(0, _emissionTime);
				} else {
					_isPlaying = false;
					
					totalBurstCount = Math.min(_particleSystem.maxParticles - _particleSystem.aliveParticleCount, totalBurstCount);
					for (i = 0; i < totalBurstCount; i++)
						emit(transform);
					
					this.event(Event.STOPPED);
					return;
				}
			} else {
				totalBurstCount += _burst(lastEmissionTime, _emissionTime);
			}
			
			totalBurstCount = Math.min(_particleSystem.maxParticles - _particleSystem.aliveParticleCount, totalBurstCount);
			for (i = 0; i < totalBurstCount; i++)
				emit(transform);
			
			_frameTime += elapsedTime;
			if (_frameTime < _minEmissionTime)
				return;
			while (_frameTime > _minEmissionTime) {
				if (emit(transform))//TODO:可像brust一样优化
					_frameTime -= _minEmissionTime;
				else
					break;
			}
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			offAll();
			_bursts = null;
			_particleSystem = null;
		}
		
		/**
		 * 开始发射粒子。
		 */
		public function play():void {
			_burstsIndex = 0;
			_isPlaying = true;
			_isPaused = false;
			_frameTime = 0;
			_emissionTime = 0;
			_playbackTime = 0;
			
			switch (_particleSystem.startDelayType) {
			case 0: 
				_startDelay = _particleSystem.startDelay;
				break;
			case 1: 
				_startDelay = MathUtil.lerp(_particleSystem.startDelayMin, _particleSystem.startDelayMax, Math.random());
				break;
			default: 
				throw new Error("Utils3D: startDelayType is invalid.");
			}
			
			_particleSystem._startUpdateLoopCount = Stat.loopCount;
			this.event(Event.PLAYED);
		}
		
		/**
		 * 暂停发射粒子。
		 */
		public function pause():void {
			_isPaused = true;
			this.event(Event.PAUSED);
		}
		
		/**
		 * 停止发射粒子。
		 */
		public function stop():void {
			_burstsIndex = 0;
			_frameTime = 0;
			
			_isPlaying = false;
			_isPaused = false;
			_emissionTime = 0;
			_playbackTime = 0;
			this.event(Event.STOPPED);
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
		public function update(elapsedTime:Number, transform:Transform3D):void {
			(enbale) && (_advanceTime(elapsedTime, transform));
		}
		
		/**
		 * 发射一个粒子。
		 */
		public function emit(transform:Transform3D):Boolean {
			var position:Vector3 = _tempPosition;
			var direction:Vector3 = _tempDirection;
			if (_shape.enbale) {
				_shape.generatePositionAndDirection(position, direction);
			} else {
				var positionE:Float32Array = position.elements;
				var directionE:Float32Array = direction.elements;
				positionE[0] = positionE[1] = positionE[2] = 0;
				directionE[0] = directionE[1] = 0;
				directionE[2] = 1;
			}
			
			return _particleSystem.addParticle(position, direction, transform);//TODO:提前判断优化
		}
	
	}

}