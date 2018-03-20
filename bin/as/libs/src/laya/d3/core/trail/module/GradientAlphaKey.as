package laya.d3.core.trail.module 
{
	public class GradientAlphaKey 
	{
		private var _alpha:Number;
		
		private var _time:Number;
		
		/**
		 * 获取透明度。
		 * @return  透明度。
		 */
		public function get alpha():Number {
			return _alpha;
		}
		
		/**
		 * 设置透明度。
		 * @param value 透明度。
		 */
		public function set alpha(value:Number):void {
			_alpha = value;
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
		
		public function GradientAlphaKey(alpha:Number, time:Number) 
		{
			_alpha = alpha;
			_time = time;
		}
	}
}