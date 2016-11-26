package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>RotationOverLifetime</code> 类用于粒子的生命周期旋转。
	 */
	public class RotationOverLifetime implements IClone{
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
			var destRotationOverLifetime:RotationOverLifetime = __JS__("new this.constructor()");
			cloneTo(destRotationOverLifetime);
			return destRotationOverLifetime;
		}
	
	}

}