package laya.maths {
	
	/**
	 * <code>Point</code> 对象表示二维坐标系统中的某个位置，其中 x 表示水平轴，y 表示垂直轴。
	 */
	public class Point {
		/**
		 * 临时使用的公用对象。
		 */
		public static const TEMP:Point =/*[STATIC SAFE]*/ new Point();
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const EMPTY:Point =/*[STATIC SAFE]*/ new Point();
		
		/**
		 * 该点的水平坐标。
		 */
		public var x:Number;
		/**
		 * 该点的垂直坐标。
		 */
		public var y:Number;
		
		/**
		 * 根据指定坐标，创建一个新的 <code>Point</code> 对象。
		 * @param	x 水平坐标。
		 * @param	y 垂直坐标。
		 */
		public function Point(x:Number = 0, y:Number = 0) {
			this.x = x;
			this.y = y;
		}
		
		/**
		 * 将 <code>Point</code> 的成员设置为指定值。
		 * @param	x 水平坐标。
		 * @param	y 垂直坐标。
		 * @return 当前 Point 对象。
		 */
		public function setTo(x:Number, y:Number):Point {
			this.x = x;
			this.y = y;
			return this;
		}
	}
}