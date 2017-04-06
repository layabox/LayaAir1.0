package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>VelocityOverLifetime</code> 类用于粒子的生命周期速度。
	 */
	public class VelocityOverLifetime implements IClone {
		/**@private */
		private var _velocity:GradientVelocity;
		
		/**是否启用*/
		public var enbale:Boolean;
		/**速度空间,0为local,1为world。*/
		public var space:int;
		
		/**
		 *获取尺寸。
		 */
		public function get velocity():GradientVelocity {
			return _velocity;
		}
		
		/**
		 * 创建一个 <code>VelocityOverLifetime</code> 实例。
		 */
		public function VelocityOverLifetime(velocity:GradientVelocity) {
			_velocity = velocity;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destVelocityOverLifetime:VelocityOverLifetime = destObject as VelocityOverLifetime;
			_velocity.cloneTo(destVelocityOverLifetime._velocity);
			destVelocityOverLifetime.enbale = enbale;
			destVelocityOverLifetime.space = space;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destVelocity:GradientVelocity;
			switch(_velocity.type){
				case 0:
					destVelocity = GradientVelocity.createByConstant( _velocity.constant.clone());
					break;
				case 1:
					destVelocity = GradientVelocity.createByGradient(_velocity.gradientX.clone(),_velocity.gradientY.clone(),_velocity.gradientZ.clone());
					break;
				case 2:
					destVelocity = GradientVelocity.createByRandomTwoConstant( _velocity.constantMin.clone(),_velocity.constantMax.clone());
					break;
				case 3:
					destVelocity = GradientVelocity.createByRandomTwoGradient(_velocity.gradientXMin.clone(),_velocity.gradientYMin.clone(),_velocity.gradientZMin.clone(),_velocity.gradientXMax.clone(),_velocity.gradientYMax.clone(),_velocity.gradientZMax.clone());
					break;
			}
			var destVelocityOverLifetime:VelocityOverLifetime = __JS__("new this.constructor(destVelocity)");
			destVelocityOverLifetime.enbale = enbale;
			destVelocityOverLifetime.space = space;
			return destVelocityOverLifetime;
		}
	
	}

}