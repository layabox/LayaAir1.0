package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.core.particleShuriKen.ShurikenParticleSystem;
	import laya.d3.core.particleShuriKen.module.shape.BaseShape;
	import laya.d3.math.Vector3;
	import laya.resource.IDestroy;
	
	/**
	 * <code>Emission</code> 类用于粒子发射器。
	 */
	public class Emission implements IClone, IDestroy {
		/**@private */
		private var _destroyed:Boolean;
		/**@private 粒子发射速率,每秒发射的个数。*/
		private var _emissionRate:int;
		
		/**@private 粒子的爆裂,不允许修改。*/
		public var _bursts:Vector.<Burst>;
		
		/**是否启用。*/
		public var enbale:Boolean;
		
		/**
		 * 设置粒子发射速率。
		 * @param emissionRate 粒子发射速率 (个/秒)。
		 */
		public function set emissionRate(value:int):void {
			if (value < 0)
				throw new Error("ParticleBaseShape:emissionRate value must large or equal than 0.");
			_emissionRate = value;
		}
		
		/**
		 * 获取粒子发射速率。
		 * @return 粒子发射速率 (个/秒)。
		 */
		public function get emissionRate():int {
			return _emissionRate;
		}
		
		/**
		 * 获取是否已销毁。
		 * @return 是否已销毁。
		 */
		public function get destroyed():Boolean {
			return _destroyed;
		}
		
		/**
		 * 创建一个 <code>Emission</code> 实例。
		 */
		public function Emission() {
			_destroyed = false;
			emissionRate = 10;
			_bursts = new Vector.<Burst>();
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			_bursts = null;
			_destroyed = true;
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
			}
		}
		
		/**
		 * 通过索引移除粒子爆裂。
		 * @param index 爆裂索引。
		 */
		public function removeBurstByIndex(index:int):void {
			_bursts.splice(index, 1);
		}
		
		/**
		 * 清空粒子爆裂。
		 */
		public function clearBurst():void {
			_bursts.length = 0;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destEmission:Emission = destObject as Emission;
			
			var destBursts:Vector.<Burst> = destEmission._bursts;
			destBursts.length = _bursts.length;
			for (var i:int = 0, n:int = _bursts.length; i < n; i++) {
				var destBurst:Burst = destBursts[i];
				if (destBurst)
					_bursts[i].cloneTo(destBurst);
				else
					destBursts[i] = _bursts[i].clone();
			}
			
			destEmission._emissionRate = _emissionRate;
			destEmission.enbale = enbale;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destEmission:Vector3 = __JS__("new this.constructor()");
			cloneTo(destEmission);
			return destEmission;
		}
	}

}