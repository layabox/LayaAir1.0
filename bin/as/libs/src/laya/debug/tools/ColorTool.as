package laya.debug.tools
{
	
	
	/**
	 * ...
	 * @author ww
	 */
	public class ColorTool
	{
		
		public function ColorTool()
		{
		
		}
		public var red:Number;
		public var green:Number;
		public var blue:Number;
		
		public static function toHexColor(color:Number):String
		{
			if (color < 0 || isNaN(color))
				return null;
			var str:String = color.toString(16);
			while (str.length < 6)
				str = "0" + str;
			return "#" + str;
		}
		
		public static function getRGBByRGBStr(str:String):Array
		{
			str.charAt(0) == '#' && (str = str.substr(1));
			var color:int = __JS__('parseInt(str,16)');
			var flag:Boolean = (str.length == 8);
			var _color:Array;
			_color = [((0x00FF0000 & color) >> 16), ((0x0000FF00 & color) >> 8) , (0x000000FF & color) ];
			return _color;
		
		}
		public static function getColorBit(value:Number):String
		{
			var rst:String;
			rst = Math.floor(value).toString(16);
			rst = rst.length > 1 ? rst : "0" + rst;
			return rst;
		}
		public static function getRGBStr(rgb:Array):String
		{
			return "#" + getColorBit(rgb[0]) + getColorBit(rgb[1]) + getColorBit(rgb[2]);
		}
		public static function traseHSB(hsb:Array):void
		{
			trace("hsb:",hsb[0],hsb[1],hsb[2]);
		}
		public static function rgb2hsb(rgbR:int, rgbG:int, rgbB:int):Array
		{
			var rgb:Array = [rgbR, rgbG, rgbB];
			rgb.sort(MathTools.sortNumSmallFirst);
			var max:int = rgb[2];
			var min:int = rgb[0];
			
			var hsbB:Number = max / 255.0;
			var hsbS:Number = max == 0 ? 0 : (max - min) / max;
			
			var hsbH:Number = 0;
			if(max==min)
			{
				hsbH=1;
			}
			else
			if (rgbR == 0 && rgbG == 0&&rgbB == 0)
			{
			}else
			if (max == rgbR && rgbG >= rgbB)
			{
				hsbH = (rgbG - rgbB) * 60 / (max - min) + 0;
			}
			else if (max == rgbR && rgbG < rgbB)
			{
				hsbH = (rgbG - rgbB) * 60 / (max - min) + 360;
			}
			else if (max == rgbG)
			{
				hsbH = (rgbB - rgbR) * 60 / (max - min) + 120;
			}
			else if (max == rgbB)
			{
				hsbH = (rgbR - rgbG) * 60 / (max - min) + 240;
			}
			
			return [hsbH, hsbS, hsbB];
		}
		
		public static function hsb2rgb(h:Number, s:Number, v:Number):Array
		{
			var r:int = 0, g:int = 0, b:int = 0;
			var i:int = Math.floor((h / 60) % 6);
			var f:Number = (h / 60) - i;
			var p:Number = v * (1 - s);
			var q:Number = v * (1 - f * s);
			var t:Number = v * (1 - (1 - f) * s);
			switch (i)
			{
				case 0: 
					r = v;
					g = t;
					b = p;
					break;
				case 1: 
					r = q;
					g = v;
					b = p;
					break;
				case 2: 
					r = p;
					g = v;
					b = t;
					break;
				case 3: 
					r = p;
					g = q;
					b = v;
					break;
				case 4: 
					r = t;
					g = p;
					b = v;
					break;
				case 5: 
					r = v;
					g = p;
					b = q;
					break;
				default: 
					break;
			}
			return [Math.floor(r * 255.0), Math.floor(g * 255.0), Math.floor(b * 255.0)];
		}
	}

}