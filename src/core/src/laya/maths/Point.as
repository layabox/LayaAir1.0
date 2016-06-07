package laya.maths {
	
	/**
	 * <code>Point</code> 对象表示二维坐标系统中的某个位置，其中 x 表示水平轴，y 表示垂直轴。
	 */
	public class Point {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**临时使用的公用对象。*/
		public static const TEMP:Point =/*[STATIC SAFE]*/ new Point();
		/**@private 全局空的point对象(x=0，y=0)，不允许修改此对象内容*/
		public static const EMPTY:Point =/*[STATIC SAFE]*/ new Point();
		
		/**该点的水平坐标。*/
		public var x:Number;
		/**该点的垂直坐标。*/
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
		
		/**
		 * 计算当前点和目标x，y点的距离
		 * @param	x 水平坐标。
		 * @param	y 垂直坐标。
		 * @return	返回之间的距离
		 */
		public function distance(x:Number, y:Number):Number {
			return Math.sqrt((this.x - x) * (this.x - x) + (this.y - y) * (this.y - y));
		}
		
		/**返回包含 x 和 y 坐标的值的字符串。*/
		public function toString():String {
			return this.x + "," + this.y;
		}
		
		/**
		 * 标准化向量
		 */
		public function normalize():void
		{
			var d:Number = Math.sqrt(x * x + y * y);
			if (d > 0) {
				var id:Number = 1.0 / d;
				x *= id;
				y *= id;
			}
		}
	}
}