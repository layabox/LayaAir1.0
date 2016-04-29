package laya.webgl.shapes
{
	import laya.webgl.utils.Buffer;

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
	
		public function getData(ib:Buffer,vb:Buffer,start:int):void
		{
			
		}
	}
}