package laya.webgl.shapes
{	
	public class Rect extends BasePoly
	{
		public function Rect(x:Number, y:Number, width:Number, height:Number, color:uint, borderWidth:int, borderColor:uint)
		{
			super(x + width / 2, y + height / 2, width / 2, height / 2, 4, color, borderWidth, borderColor);
		}
	
	}
}