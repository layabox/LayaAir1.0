package laya.effect 
{
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.filters.ColorFilter;
	import laya.utils.ColorUtils;
	import laya.utils.Utils;
	/**
	 * ...
	 * @author ww
	 */
	public class ColorFilterSetter extends FilterSetterBase
	{
		/**
		 * brightness 亮度,范围:-100~100
		 */
		private var _brightness:Number=0;
		/**
		 * contrast 对比度,范围:-100~100
		 */
		private var _contrast:Number=0;
		/**
		 * saturation 饱和度,范围:-100~100
		 */
		private var _saturation:Number=0;
		/**
		 * hue 色调,范围:-180~180
		 */
		private var _hue:Number = 0;
		
		/**
		 * red red增量,范围:0~255
		 */
		private var _red:Number = 0;
		
		/**
		 * green green增量,范围:0~255
		 */
		private var _green:Number = 0;
		
		/**
		 * blue blue增量,范围:0~255
		 */
		private var _blue:Number = 0;
		
		/**
		 * alpha alpha增量,范围:0~255
		 */
		private var _alpha:Number = 0;
		
		
		public function ColorFilterSetter() 
		{
			_filter = new ColorFilter();
		}
		
		override protected function buildFilter():void
		{
			_filter.reset();
			//_filter = new ColorFilter();

			_filter.color(red, green, blue, alpha);

			_filter.adjustHue(hue);
			_filter.adjustContrast(contrast);
			_filter.adjustBrightness(brightness);
			_filter.adjustSaturation(saturation);
			super.buildFilter();
		}
		

		
		
		public function get brightness():Number 
		{
			return _brightness;
		}
		
		public function set brightness(value:Number):void 
		{
			_brightness = value;
			paramChanged();
		}
		
		public function get contrast():Number 
		{
			return _contrast;
		}
		
		public function set contrast(value:Number):void 
		{
			_contrast = value;
			paramChanged();
		}
		
		public function get saturation():Number 
		{
			return _saturation;
		}
		
		public function set saturation(value:Number):void 
		{
			_saturation = value;
			paramChanged();
		}
		
		public function get hue():Number 
		{
			return _hue;
		}
		
		public function set hue(value:Number):void 
		{
			_hue = value;
			paramChanged();
		}
		
		public function get red():Number 
		{
			return _red;
		}
		
		public function set red(value:Number):void 
		{
			_red = value;
			paramChanged();
		}
		
		public function get green():Number 
		{
			return _green;
		}
		
		public function set green(value:Number):void 
		{
			_green = value;
			paramChanged();
		}
		
		public function get blue():Number 
		{
			return _blue;
		}
		
		public function set blue(value:Number):void 
		{
			_blue = value;
			paramChanged();
		}
		
		
		private var _color:String;
		public function get color():String
		{
			return _color;
		}
		
		public function set color(value:String):void
		{
			_color = value;
			var colorO:ColorUtils;
			colorO = ColorUtils.create(value);
			_red = colorO.arrColor[0] * 255;
			_green = colorO.arrColor[1] * 255;
			_blue = colorO.arrColor[2] * 255;
			paramChanged();
		}
		
		public function get alpha():Number 
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void 
		{
			_alpha = value;
			paramChanged();
		}
		
	}

}