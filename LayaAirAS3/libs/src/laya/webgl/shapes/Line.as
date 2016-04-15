package laya.webgl.shapes
{
	import laya.webgl.utils.Buffer;
	
	public class Line extends BasePoly
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/		
		private var points:Array
		
		public function Line(x:Number, y:Number, points:Array, color:uint, borderWidth:int)
		{
			super(x, y, 0, 0, 0, color, borderWidth, color, 0);
			this.points = points;
		}
		
		override public function getData(ib:Buffer, vb:Buffer, start:int):void
		{
			var indices:Array = [];
			var verts:Array = [];
			
			(borderWidth > 0) && createLine2(points, indices, borderWidth, start, verts, points.length / 2);
			ib.append(new Uint16Array(indices));
			vb.append(new Float32Array(verts));
		
			//			下面方法用来测试边儿
			//			var outVertex:Array=[];
			//			var outIndex:Array=[];
			//			createLine(verts,indices,40,0,outVertex,outIndex);
			//			ib.append(new Uint16Array(outIndex));
			//			vb.append(new Float32Array(outVertex));
		}
	}
}