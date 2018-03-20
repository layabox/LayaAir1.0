package laya.webgl.canvas {
	import laya.utils.Color;
	
	public class DrawStyle {
		public static var DEFAULT:DrawStyle = new DrawStyle("#000000")
		
		public var _color:Color = Color.create("black");
		
		public static function create(value:*):DrawStyle {
			if (value) {
				var color:Color;
				
				if (value is String) color = Color.create(value as String);
				else if (value is Color) color = value as Color;
				
				if (color) {
					return color._drawStyle || (color._drawStyle = new DrawStyle(value));
				}
			}
			return DrawStyle.DEFAULT;
		}
		
		public function DrawStyle(value:*) {
			setValue(value);
		}
		
		public function setValue(value:*):void {
			if (value) {
				if (value is String) {
					_color = Color.create(value as String);
					return;
				}
				if (value is Color) {
					_color = value as Color;
					return;
				}
			}
		}
		
		public function reset():void {
			_color = Color.create("black");
		}
		
		public function equal(value:*):Boolean {
			if (value is String) return _color.strColor === value as String;
			if (value is Color) return _color.numColor === (value as Color).numColor;
			return false;
		}
		
		public function toColorStr():String {
			return _color.strColor;
		}
	}

}