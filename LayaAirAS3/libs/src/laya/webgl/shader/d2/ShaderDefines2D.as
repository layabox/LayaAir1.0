package laya.webgl.shader.d2 
{
	import laya.webgl.shader.ShaderDefines;
	
	/**
	 * ...
	 * @author laya
	 */
	public class ShaderDefines2D extends ShaderDefines 
	{
		public static const TEXTURE2D:int 		= 0x01;
		public static const COLOR2D:int 		= 0x02;
		public static const PRIMITIVE:int		=0x04;
		
		public static const FILTERGLOW:int 		= 0x08;
		public static const FILTERBLUR:int 		= 0x10;
		public static const FILTERCOLOR:int 	= 0x20;
		public static const COLORADD:int 		= 0x40;
		
		private static var _name2int:Object = {};
		private static var _int2name:Array = [];
		private static var _int2nameMap:Array = [];
		
		public static function __init__():void
		{		
			reg("TEXTURE2D", TEXTURE2D);
			reg("COLOR2D", COLOR2D);
			reg("PRIMITIVE", PRIMITIVE);
			
			reg("GLOW_FILTER", FILTERGLOW);
			reg("BLUR_FILTER", FILTERBLUR);
			reg("COLOR_FILTER", FILTERCOLOR);
			reg("COLOR_ADD", COLORADD);
		}
		
		public function ShaderDefines2D() 
		{
			super(_name2int,_int2name,_int2nameMap);
		}
		
		public static function reg(name:String, value:int):void
		{
			_reg(name, value, _name2int, _int2name);
		}
		
		public static function toText(value:int,_int2name:Array,_int2nameMap:Object):*
		{
			return _toText(value, _int2name, _int2nameMap);
		}
		
		public static function toInt(names:String):int
		{
			return _toInt(names, _name2int);
		}		
	}

}