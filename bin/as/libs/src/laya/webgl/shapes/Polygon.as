package laya.webgl.shapes {
	import laya.webgl.utils.Buffer2D;
	
	public class Polygon extends BasePoly {
		
		private var _points:Array;
		private var _start:int = -1;
		public function Polygon(x:Number, y:Number, points:Array, color:uint, borderWidth:int, borderColor:uint) {
			_points = points.slice(0,points.length);
			super(x, y, 0, 0, _points.length / 2, color, borderWidth, borderColor);
		}
		
		private var mUint16Array:Uint16Array;
		private var mFloat32Array:Float32Array;
		
		override public function getData(ib:Buffer2D, vb:Buffer2D, start:int):void {
			
			var indices:Array,i:int;
			var tArray:Array = _points;
			var tLen:int;
			if (mUint16Array && mFloat32Array)
			{
				if (_start != start)
				{
					_start = start;
					indices = [];
					tLen = Math.floor(tArray.length / 2);
					for (i = 2; i < tLen; i++) {
						indices.push(start, start + i - 1, start + i);
					}
					mUint16Array = new Uint16Array(indices);
				}
			}else {
				_start = start;
				indices = [];
				var verts:Array = [];
				
				var color:uint = this.color;
				var r:Number = ((color >> 16) & 0x0000ff) / 255, g:Number = ((color >> 8) & 0xff) / 255, b:Number = (color & 0x0000ff) / 255;
				
				tLen = Math.floor(tArray.length / 2);
				for (i = 0; i < tLen; i++) {
					verts.push(x + tArray[i * 2], y + tArray[i * 2 + 1], r, g, b);
				}
				for (i = 2; i < tLen; i++) {
					indices.push(start, start + i - 1, start + i);
				}
				mUint16Array = new Uint16Array(indices);
				mFloat32Array = new Float32Array(verts);
			}
			ib.append(mUint16Array);
			vb.append(mFloat32Array);
		}
	}
}