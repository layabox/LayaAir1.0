package laya.webgl.shapes
{
	public class Circle extends BasePoly
	{
		
		public function Circle(x:Number,y:Number,r:Number,color:uint,borderWidth:int,borderColor:uint,fill:Boolean)
		{
			super(x,y,r,r,80,color,borderWidth,borderColor);
			this.fill=fill;
		}
		
	}
}