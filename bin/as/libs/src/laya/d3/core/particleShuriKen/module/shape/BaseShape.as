package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.math.Vector3;
	
	/**
	 * <code>BaseShape</code> 类用于粒子形状。
	 */
	public class BaseShape {
		/**是否启用。*/
		public var enbale:Boolean;
		
		/**
		 * 创建一个 <code>BaseShape</code> 实例。
		 */
		public function BaseShape() {
		}
		
		/**
		 *  用于生成粒子初始位置和方向。
		 * @param	position 粒子位置。
		 * @param	direction 粒子方向。
		 */
		public function generatePositionAndDirection(position:Vector3, direction:Vector3):void {
			throw new Error("BaseShape: must override it.");
		}
	
	}

}