package laya.webgl.shapes
{
	import laya.maths.Matrix;
	import laya.webgl.utils.Buffer2D;

	public class Vertex implements IShape
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var points:Float32Array;
		public function Vertex(p:*)
		{
			
			if(p is Float32Array)
			this.points=p;
			else if(p is Array)
			{
				var len:int=p.length;
				points=new Float32Array(p);
			}
		}
	
		public function getData(ib:Buffer2D,vb:Buffer2D,start:int):void
		{
			
		}
		
		public function needUpdate(mat:Matrix):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function rebuild(points:Array):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function setMatrix(mat:Matrix):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}