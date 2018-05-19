package laya.d3.core.trail.module 
{
	
	public class Color 
	{
		/**
		 * 红色
		 */
		public static const RED:Color = new Color(1, 0, 0, 1);
		/**
		 * 绿色
		 */
		public static const GREEN:Color = new Color(0, 1, 0, 1);
		/**
		 * 蓝色
		 */
		public static const BLUE:Color = new Color(0, 0, 1, 1);
		/**
		 * 蓝绿色
		 */
		public static const CYAN:Color = new Color(0, 1, 1, 1);
		/**
		 * 黄色
		 */
		public static const YELLOW:Color = new Color(1, 0.92, 0.016, 1);
		/**
		 * 品红色
		 */
		public static const MAGENTA:Color = new Color(1, 0, 1, 1);
		/**
		 * 灰色
		 */
		public static const GRAY:Color = new Color(0.5, 0.5, 0.5, 1);
		/**
		 * 白色
		 */
		public static const WHITE:Color = new Color(1, 1, 1, 1);
		/**
		 * 黑色
		 */
		public static const BLACK:Color = new Color(0, 0, 0, 1);
		
		public var _r:Number;
		public var _g:Number;
		public var _b:Number;
		public var _a:Number;
		
		public function Color(r:Number = 1, g:Number = 1, b:Number = 1, a:Number = 1) 
		{
			_r = r;
			_g = g;
			_b = b;
			_a = a;
		}
		
		public function cloneTo(destObject:Color):void {
			destObject._r = _r;
			destObject._g = _g;
			destObject._b = _b;
			destObject._a = _a;
		}
		
	}

}