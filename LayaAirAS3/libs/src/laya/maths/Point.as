package laya.maths {
	
	/**
	 * Point类
	 * @author yung
	 */
	public class Point {
		/**
		 * 临时使用的公用对象
		 */
		public static const TEMP:Point =/*[STATIC SAFE]*/ new Point();
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const EMPTY:Point =/*[STATIC SAFE]*/ new Point();
		
		public var x:Number;
		public var y:Number;
		
		public function Point(x:Number = 0, y:Number = 0) {
			this.x = x;
			this.y = y;
		}
		
		public function setTo(x:Number, y:Number):Point {
			this.x = x;
			this.y = y;
			return this;
		}	
	}
}