package laya.webgl.shapes
{
	import laya.webgl.utils.Buffer;
	public class Circle extends BasePoly
	{
		public function Circle(x:Number, y:Number, r:Number, edges:Number,color:uint,borderWidth:int,borderColor:uint)
		{
			super(x, y, r, r, edges,color,borderWidth,borderColor);
		}
		
		override public function getData(ib:Buffer, vb:Buffer, start:int):void
		{
			var indices:Array = [];
			var verts:Array = [];
			this.circle(verts, indices, start);
			if (fill)
			{
				(borderWidth > 0) && createLoopLine(verts, indices, borderWidth, start + verts.length / 5);
				ib.append(new Uint16Array(indices));
				vb.append(new Float32Array(verts));
			}
			else
			{
				var outV:Array = [];
				var outI:Array = [];
				createLoopLine(verts, indices, borderWidth, start, outV, outI);
				ib.append(new Uint16Array(outI));
				vb.append(new Float32Array(outV));
			}
		}
	}
}