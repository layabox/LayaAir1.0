package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>RotationOverLifetime</code> 类用于粒子的生命周期旋转。
	 */
	public class RotationOverLifetime implements IClone {
		/**@private */
		private var _angularVelocity:GradientAngularVelocity;
		
		/**是否启用*/
		public var enbale:Boolean;
		
		/**
		 *获取角速度。
		 */
		public function get angularVelocity():GradientAngularVelocity {
			return _angularVelocity;
		}
		
		/**
		 * 创建一个 <code>RotationOverLifetime,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function RotationOverLifetime(angularVelocity:GradientAngularVelocity) {
			_angularVelocity = angularVelocity;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destRotationOverLifetime:RotationOverLifetime = destObject as RotationOverLifetime;
			_angularVelocity.cloneTo(destRotationOverLifetime._angularVelocity);
			destRotationOverLifetime.enbale = enbale;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destAngularVelocity:GradientAngularVelocity;
			switch (_angularVelocity.type) {
			case 0: 
				if (_angularVelocity.separateAxes)
					destAngularVelocity = GradientAngularVelocity.createByConstantSeparate(_angularVelocity.constantSeparate.clone());
				else
					destAngularVelocity = GradientAngularVelocity.createByConstant(_angularVelocity.constant);
				break;
			case 1: 
				if (_angularVelocity.separateAxes)
					destAngularVelocity = GradientAngularVelocity.createByGradientSeparate(_angularVelocity.gradientX.clone(), _angularVelocity.gradientY.clone(), _angularVelocity.gradientZ.clone(), _angularVelocity.gradientW.clone());
				else
					destAngularVelocity = GradientAngularVelocity.createByGradient(_angularVelocity.gradient.clone());
				break;
			case 2: 
				if (_angularVelocity.separateAxes)
					destAngularVelocity = GradientAngularVelocity.createByRandomTwoConstantSeparate(_angularVelocity.constantMinSeparate.clone(), _angularVelocity.constantMaxSeparate.clone());
				else
					destAngularVelocity = GradientAngularVelocity.createByRandomTwoConstant(_angularVelocity.constantMin, _angularVelocity.constantMax);
				break;
			case 3: 
				if (_angularVelocity.separateAxes)
					destAngularVelocity = GradientAngularVelocity.createByRandomTwoGradientSeparate(_angularVelocity.gradientXMin.clone(), _angularVelocity.gradientYMin.clone(), _angularVelocity.gradientZMin.clone(),_angularVelocity.gradientWMin.clone(), _angularVelocity.gradientXMax.clone(), _angularVelocity.gradientYMax.clone(), _angularVelocity.gradientZMax.clone(),_angularVelocity.gradientWMax.clone());
				else
					destAngularVelocity = GradientAngularVelocity.createByRandomTwoGradient(_angularVelocity.gradientMin.clone(), _angularVelocity.gradientMax.clone());
				break;
			}
			
			var destRotationOverLifetime:RotationOverLifetime = __JS__("new this.constructor(destAngularVelocity)");
			destRotationOverLifetime.enbale = enbale;
			return destRotationOverLifetime;
		}
	
	}

}