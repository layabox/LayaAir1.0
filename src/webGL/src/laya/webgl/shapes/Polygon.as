package laya.webgl.shapes {
	import laya.maths.Matrix;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.shapes.Earcut;
	public class Polygon extends BasePoly {
		
		private var _points:Array;
		private var _start:int = -1;
		private var _mat:Matrix = Matrix.create();
		private var _repaint:Boolean = false;
		private var earcutTriangles:*;
		public function Polygon(x:Number, y:Number, points:Array, color:uint, borderWidth:int, borderColor:uint) {
			_points = points.slice(0,points.length);
			super(x, y, 0, 0, _points.length / 2, color, borderWidth, borderColor);
		}
		

		
		override public function rebuild(point:Array):void
		{
			//_start =-1;
			if (!_repaint)
			{
				_points.length = 0;
				_points = _points.concat(point);
			}
		}
		
		override public function  setMatrix(mat:Matrix):void
		{
			mat.copyTo(_mat);
		}
		
		override public function needUpdate(mat:Matrix):Boolean
		{
			_repaint=(_mat.a == mat.a && _mat.b == mat.b && _mat.c == mat.c && _mat.d == mat.d && _mat.tx == mat.tx && _mat.ty == mat.ty);
			return !_repaint;
		}
		
		override public function getData(ib:Buffer2D, vb:Buffer2D, start:int):void {
			
			var indices:Array,i:int;
			var tArray:Array = _points;
			var tLen:int;
			if (mUint16Array && mFloat32Array&&_repaint)
			{
				
				if (_start != start)
				{
					_start = start;
					indices = [];
					tLen = earcutTriangles.length;
					for (i = 0; i < tLen; i++) {
						indices.push(earcutTriangles[i] + start);
					}
					mUint16Array = new Uint16Array(indices);
				}
			}
			else {
				_start = start;
				indices = [];
				var verts:Array = [];
				var vertsEarcut:Array = [];
				
				var color:uint = this.color;
				var r:Number = ((color >> 16) & 0x0000ff) / 255, g:Number = ((color >> 8) & 0xff) / 255, b:Number = (color & 0x0000ff) / 255;
				
				tLen = Math.floor(tArray.length / 2);
				for (i = 0; i < tLen; i++) {
					verts.push(x + tArray[i * 2], y + tArray[i * 2 + 1], r, g, b);
					vertsEarcut.push(x + tArray[i * 2], y + tArray[i * 2 + 1]);
				}
				earcutTriangles = Earcut.earcut(vertsEarcut, null, 2);
				tLen = earcutTriangles.length;
				for (i = 0; i < tLen; i++) {
					indices.push(earcutTriangles[i] + start);
				}
				mUint16Array = new Uint16Array(indices); 
				mFloat32Array = new Float32Array(verts);
			}
			ib.append(mUint16Array);
			vb.append(mFloat32Array);
		}
	}
}