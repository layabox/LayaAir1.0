package laya.d3.math {
	
	/**
	 * <code>MathUtils</code> 类用于创建数学工具。
	 */
	public class MathUtils3D {
		/**单精度浮点(float)零的容差*/
		public static const zeroTolerance:Number = 1e-6;
		/**浮点数默认最大值*/
		public static const MaxValue:Number = 3.40282347e+38;
		/**浮点数默认最小值*/
		public static const MinValue:Number = -3.40282347e+38;
		
		/**
		 * 创建一个 <code>MathUtils</code> 实例。
		 */
		public function MathUtils3D() {
		
		}
		
		/**
		 * 是否在容差的范围内近似于0
		 * @param  判断值
		 * @return  是否近似于0
		 */
		public static function isZero(v:Number):Boolean {
			return Math.abs(v) < zeroTolerance;
		}
		
		/**
		 * 两个值是否在容差的范围内近似相等Sqr Magnitude
		 * @param  判断值
		 * @return  是否近似于0
		 */
		public static function nearEqual(n1:Number, n2:Number):Boolean {
			if (isZero(n1 - n2))
				return true;
			return false;
		}
		
		public static function fastInvSqrt(value:Number):Number {
			if (isZero(value))
				return value;
			return 1.0 / Math.sqrt(value);
		}
	}

}