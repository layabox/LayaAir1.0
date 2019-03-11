package laya.webgl.canvas {
	import laya.utils.ColorUtils;
	
	public class DrawStyle {
		public static var DEFAULT:DrawStyle = new DrawStyle("#000000")
		
		public var _color:ColorUtils;
		
		public static function create(value:*):DrawStyle {
			if (value) {
				var color:ColorUtils = (value is ColorUtils)?(value as ColorUtils):ColorUtils.create(value);
				return color._drawStyle || (color._drawStyle = new DrawStyle(value));				
			}
			return DEFAULT;
		}
		
		public function DrawStyle(value:*) {
			setValue(value);
		}
		
		public function setValue(value:*):void {
			if (value) {
				_color = (value is ColorUtils)?(value as ColorUtils):ColorUtils.create(value);
			}
			else _color = ColorUtils.create("#000000");
		}
		
		public function reset():void {
			_color = ColorUtils.create("#000000");
		}
		
		public function toInt():int
		{
			return _color.numColor;
		}
		
		public function equal(value:*):Boolean {
			if (value is String) return _color.strColor === value as String;
			if (value is ColorUtils) return _color.numColor === (value as ColorUtils).numColor;
			return false;
		}
		
		public function toColorStr():String {
			return _color.strColor;
		}
	}

}