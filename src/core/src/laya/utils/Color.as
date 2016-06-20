package laya.utils {
	import laya.utils.Utils;
	
	/**
	 * <code>Color</code> 是一个颜色值处理类。
	 */
	public class Color {
		/**@private */
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static var _SAVE:* = /*[STATIC SAFE]*/ {};
		/**@private */
		public static var _SAVE_SIZE:int = 0;
		
		private static var _COLOR_MAP:Object = /*[STATIC SAFE]*/ {"white": '#FFFFFF', "red": '#FF0000', "green": '#00FF00', "blue": '#0000FF', "black": '#000000', "yellow": '#FFFF00', 'gray': '#AAAAAA'};
		private static var _DEFAULT:Object = /*[STATIC SAFE]*/ _initDefault();
		private static var _COLODID:int = 1;
		
		/**@private */
		public var _color:Array = [];
		/** 字符串型颜色值。*/
		public var strColor:String;
		/** uint 型颜色值。*/
		public var numColor:uint;
		
		public var _drawStyle:*;
		
		/**
		 * 根据指定的属性值，创建一个 <code>Color</code> 类的实例。
		 * @param	str 颜色值。
		 */
		public function Color(str:*) {
			//TODO:增加arpg的支持
			if (str is String) {
				strColor = str;
				if (str === null) str = "#000000";
				
				str.charAt(0) == '#' && (str = str.substr(1));
				var color:int = numColor = parseInt(str, 16);
				var flag:Boolean = (str.length == 8);
				if (flag) {
					_color = [parseInt(str.substr(0,2),16) / 255, ((0x00FF0000 & color) >> 16) / 255, ((0x0000FF00 & color) >> 8) / 255, (0x000000FF & color) / 255];
					return;
				}
			} else {
				color = numColor = str;
				strColor = Utils.toHexColor(color);
			}
			_color = [((0xFF0000 & color) >> 16) / 255, ((0xFF00 & color) >> 8) / 255, (0xFF & color) / 255, 1];
			(_color as Object).__id = ++_COLODID;
		}
		
		/**@private */
		public static function _initDefault():* {
			_DEFAULT = {};
			for (var i:String in _COLOR_MAP) _SAVE[i] = _DEFAULT[i] = new Color(_COLOR_MAP[i]);
			return _DEFAULT;
		}
		
		/**@private */
		public static function _initSaveMap():void {
			_SAVE_SIZE = 0;
			_SAVE = {};
			for (var i:String in _DEFAULT) _SAVE[i] = _DEFAULT[i];
		}
		
		/**
		 * 根据指定的属性值，创建并返回一个 <code>Color</code> 类的实例。
		 * @param	str 颜色值。
		 * @return 一个 <code>Color</code> 类的实例。
		 */
		public static function create(str:*):Color {
			var color:Color = _SAVE[str + ""];
			if (color != null) return color;
			(_SAVE_SIZE < 1000) || _initSaveMap();
			return _SAVE[str + ""] = new Color(str);
		}
	}

}