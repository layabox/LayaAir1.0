package laya.webgl.shapes
{
	public class Polygon extends BasePoly
	{
		public function Polygon(x:Number, y:Number, r:Number, edges:Number,color:uint,borderWidth:int,borderColor:uint)
		{
			super(x, y, r, r, edges,color,borderWidth,borderColor);
		}
	}
}