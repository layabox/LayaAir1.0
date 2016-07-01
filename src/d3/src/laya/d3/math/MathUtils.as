package laya.d3.math {
	
	/**
	 * <code>MathUtils</code> 类用于创建数学工具。
	 */
	public class MathUtils {
		/**单精度浮点(float)零的容差*/
		public static const zeroTolerance:Number = 1e-6;
		
		/**
		 * 创建一个 <code>MathUtils</code> 实例。
		 */
		public function MathUtils() {
		
		}
		
		/**
		 * 是否在容差的范围内近似于0
		 * @param  判断值
		 * @return  是否近似于0
		 */
		public static function isZero(v:Number):Boolean {
			return Math.abs(v) < zeroTolerance;
		}
	}

}