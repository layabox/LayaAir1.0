package laya.webgl.shapes
{
	import laya.webgl.utils.Buffer2D;
	
	public class Line extends BasePoly
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/		
		private var _points:Array = [];
		
		public function Line(x:Number, y:Number, points:Array, borderWidth:int, color:uint)
		{
			//把没用的顶点数据过滤掉
			var tCurrX:Number;
			var tCurrY:Number;
			var tLastX:Number = -1;
			var tLastY:Number = -1;
			var tLen:int = points.length / 2 - 1;
			for (var i:int = 0; i < tLen; i++)
			{
				tCurrX = points[i * 2];
				tCurrY = points[i * 2 + 1];
				if (Math.abs(tLastX - tCurrX)> 0.01 || Math.abs(tLastY - tCurrY)>0.01)
				{
					_points.push(tCurrX, tCurrY);
				}
				tLastX = tCurrX;
				tLastY = tCurrY;
			}
			tCurrX = points[tLen * 2];
			tCurrY = points[tLen * 2 + 1];
			tLastX = _points[0];
			tLastY = _points[1];
			if (Math.abs(tLastX - tCurrX)> 0.01 || Math.abs(tLastY - tCurrY)>0.01)
			{
				_points.push(tCurrX, tCurrY);
			}
			super(x, y, 0, 0, 0, color, borderWidth, color, 0);
		}
		
		override public function getData(ib:Buffer2D, vb:Buffer2D, start:int):void
		{
			var indices:Array = [];
			var verts:Array = [];
			
			(borderWidth > 0) && createLine2(_points, indices, borderWidth, start, verts, _points.length / 2);
			ib.append(new Uint16Array(indices));
			vb.append(new Float32Array(verts));
		
			//下面方法用来测试边儿
			//var outVertex:Array=[];
			//var outIndex:Array=[];
			//createLine(verts,indices,40,0,outVertex,outIndex);
			//ib.append(new Uint16Array(outIndex));
			//vb.append(new Float32Array(outVertex));
		}
	}
}