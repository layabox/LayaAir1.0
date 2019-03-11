package laya.utils {
	import laya.utils.Utils;
	
	/**
	 * @private
	 * <code>ColorUtils</code> 是一个颜色值处理类。
	 */
	public class ColorUtils {
		/*[FILEINDEX:10000]*/
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**@private */
		public static var _SAVE:* = /*[STATIC SAFE]*/ {};
		/**@private */
		public static var _SAVE_SIZE:int = 0;
		/**@private */
		private static var _COLOR_MAP:Object = /*[STATIC SAFE]*/ { "purple":"#800080","orange":"#ffa500","white": '#FFFFFF', "red": '#FF0000', "green": '#00FF00', "blue": '#0000FF', "black": '#000000', "yellow": '#FFFF00', 'gray': '#808080' };
		/**@private */
		private static var _DEFAULT:Object = /*[STATIC SAFE]*/ _initDefault();
		/**@private */
		private static var _COLODID:int = 1;
		
		/**rgba 取值范围0-1*/
		//TODO:delete？
		public var arrColor:Array = [];
		/** 字符串型颜色值。*/
		public var strColor:String;
		/** uint 型颜色值。*/
		public var numColor:uint;
		/**@private TODO:*/
		public var _drawStyle:*;
		
		/**
		 * 根据指定的属性值，创建一个 <code>Color</code> 类的实例。
		 * @param	value 颜色值，可以是字符串："#ff0000"或者16进制颜色 0xff0000。
		 */
		public function ColorUtils(value:*) {
			if (value == null) {
				strColor = "#00000000";
				numColor = 0;
				arrColor = [0, 0, 0, 0];
				return;
			}
			var i:int, len:int;
			var color:int;
			if (value is String) {
				if ((value as String).indexOf("rgba(")>=0||(value as String).indexOf("rgb(")>=0)
				{
					var tStr:String = value;
					var beginI:int, endI:int;
					beginI = tStr.indexOf("(");
					endI = tStr.indexOf(")");
					tStr = tStr.substring(beginI + 1, endI);
					arrColor = tStr.split(",");
					len = arrColor.length;
					for (i = 0; i < len; i++)
					{
						arrColor[i] = parseFloat(arrColor[i]);
						if (i < 3)
						{
							arrColor[i] = Math.round(arrColor[i]);
						}
					}
					if (arrColor.length == 4)
					{
						color= ((arrColor[0] * 256 + arrColor[1]) * 256 + arrColor[2]) * 256 + Math.round(arrColor[3] * 255);
					}else
					{
						color= ((arrColor[0] * 256 + arrColor[1]) * 256 + arrColor[2]);
					}
					
					strColor = value;
				}else
				{
					strColor = value;
					value.charAt(0) === '#' && (value = value.substr(1));
					len=value.length;
					if (len === 3 || len === 4) {
						var temp:String = "";
						for (i= 0; i < len; i++) {
							temp += (value[i] + value[i]);
						}
						value = temp;
					}
					color= parseInt(value, 16);
				}
				
			} else {
				color = value;
				strColor = Utils.toHexColor(color);
			}
			
			if (strColor.indexOf("rgba") >= 0 || strColor.length === 9) {
				//color:0xrrggbbaa numColor此时为负数
				arrColor = [((0xFF000000 & color)>>>24) / 255, ((0xFF0000 & color) >> 16) / 255, ((0xFF00 & color)>>8) / 255, (0xFF & color) / 255];
				numColor = (0xff000000&color)>>>24|(color & 0xff0000) >> 8 | (color & 0x00ff00)<<8 | ((color & 0xff) <<24);//to 0xffbbggrr
			} else {
				arrColor = [((0xFF0000 & color) >> 16) / 255, ((0xFF00 & color) >> 8) / 255, (0xFF & color) / 255, 1];
				numColor = 0xff000000|(color & 0xff0000) >> 16 | (color & 0x00ff00) | (color & 0xff) << 16;//to 0xffbbggrr
			}
			(arrColor as Object).__id = ++_COLODID;
		}
		
		/**@private */
		public static function _initDefault():* {
			_DEFAULT = {};
			for (var i:String in _COLOR_MAP) _SAVE[i] = _DEFAULT[i] = new ColorUtils(_COLOR_MAP[i]);
			return _DEFAULT;
		}
		
		/**@private 缓存太大，则清理缓存*/
		public static function _initSaveMap():void {
			_SAVE_SIZE = 0;
			_SAVE = {};
			for (var i:String in _DEFAULT) _SAVE[i] = _DEFAULT[i];
		}
		
		/**
		 * 根据指定的属性值，创建并返回一个 <code>Color</code> 类的实例。
		 * @param	value 颜色值，可以是字符串："#ff0000"或者16进制颜色 0xff0000。
		 * @return 一个 <code>Color</code> 类的实例。
		 */
		public static function create(value:*):ColorUtils {
			var key:String = value + "";
			var color:ColorUtils = _SAVE[key];
			if (color != null) return color;
			if (_SAVE_SIZE < 1000) _initSaveMap();
			return _SAVE[key] = new ColorUtils(value);
		}
	}
}