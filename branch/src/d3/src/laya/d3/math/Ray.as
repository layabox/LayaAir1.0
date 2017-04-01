package laya.d3.math {
	
	/**
	 * <code>Ray</code> 类用于创建射线。
	 */
	public class Ray {
		/**原点*/
		public var origin:Vector3;
		/**方向*/
		public var direction:Vector3;
		
		/**
		 * 创建一个 <code>Ray</code> 实例。
		 * @param	origin 射线的起点
		 * @param	direction  射线的方向
		 */
		public function Ray(origin:Vector3, direction:Vector3) {
			this.origin = origin;
			this.direction = direction;
		}
	}
}