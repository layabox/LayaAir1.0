package laya.effect 
{
	import laya.filters.GlowFilter;
	/**
	 * ...
	 * @author ww
	 */
	public class GlowFilterSetter extends FilterSetterBase
	{
		/**
		 * 滤镜的颜色
		 */
		private var _color:String = "#ff0000";
		/**
		 * 边缘模糊的大小 0~20
		 */
		private var _blur:Number = 4;
		/**
		 * X轴方向的偏移
		 */
		private var _offX:Number = 6;
		/**
		 * Y轴方向的偏移
		 */
		private var _offY:Number = 6;
		public function GlowFilterSetter() 
		{
			_filter = new GlowFilter(_color);
		}
		
		override protected function buildFilter():void 
		{
			
			_filter = new GlowFilter(color, blur, offX, offY);
			super.buildFilter();
		}
		
		public function get color():String 
		{
			return _color;
		}
		
		public function set color(value:String):void 
		{
			_color = value;
			paramChanged();
		}
		
		public function get blur():Number 
		{
			return _blur;
		}
		
		public function set blur(value:Number):void 
		{
			_blur = value;
			paramChanged();
		}
		
		public function get offX():Number 
		{
			return _offX;
		}
		
		public function set offX(value:Number):void 
		{
			_offX = value;
			paramChanged();
		}
		
		public function get offY():Number 
		{
			return _offY;
		}
		
		public function set offY(value:Number):void 
		{
			_offY = value;
			paramChanged();
		}
	}

}