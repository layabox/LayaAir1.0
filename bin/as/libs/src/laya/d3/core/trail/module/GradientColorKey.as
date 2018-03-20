package laya.d3.core.trail.module {
	
	public class GradientColorKey {
		private var _color:Color;
		
		private var _time:Number;
		
		/**
		 * 获取颜色值。
		 * @return  颜色值。
		 */
		public function get color():Color {
			return _color;
		}
		
		/**
		 * 设置颜色值。
		 * @param value 颜色值。
		 */
		public function set color(value:Color):void {
			_color = value;
		}
		
		/**
		 * 获取时间。
		 * @return  时间。
		 */
		public function get time():Number {
			return _time;
		}
		
		/**
		 * 设置时间。
		 * @param value 时间。
		 */
		public function set time(value:Number):void {
			_time = value;
		}
		
		public function GradientColorKey(color:Color, time:Number) {
			_color = color;
			_time = time;
		}
	}
}