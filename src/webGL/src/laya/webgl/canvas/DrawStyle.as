package laya.webgl.canvas 
{
	import laya.utils.Color;

	/**
	 * ...
	 * @author laya
	 */
	public class DrawStyle 
	{
		public static var DEFAULT:DrawStyle=/*[STATIC SAFE]*/ new DrawStyle("#000000")
		
		public var _color:Color=Color.create("black");
		
		public function DrawStyle(value:*) 
		{
			setValue(value);
		}
		
		public function setValue(value:*):void
		{
			if (value)
			{
				if (value is String)
				{
					_color = Color.create(value as String);
					return ;
				}
				if (value is Color)
				{
					_color = value as Color;
					return;
				}
			}
		}
		
		public function reset():void
		{
			_color=Color.create("black");
		}
		
		public function equal(value:*):Boolean
		{
			if (value is String) return _color.strColor === value as String;
			return false;
		}
		
		public function toColorStr():String
		{
			return _color.strColor;
		}
		
	}

}