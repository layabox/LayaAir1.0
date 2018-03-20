package laya.webgl.shapes
{
	import laya.webgl.utils.Buffer2D;

	public class Ellipse extends BasePoly
	{
		
		public function Ellipse(x:Number,y:Number,width:Number,height:Number,color:uint,borderWidth:int,borderColor:uint)
		{
			super(x,y,width,height,40,color,borderWidth,borderColor);
		}
		
	}
}