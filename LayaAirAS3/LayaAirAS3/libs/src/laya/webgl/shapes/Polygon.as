package laya.webgl.shapes {
	import laya.webgl.utils.Buffer;
	
	public class Polygon extends BasePoly {
		
		private var _points:Array;
		
		public function Polygon(x:Number, y:Number, points:Array, color:uint, borderWidth:int, borderColor:uint) {
			_points = points;
			super(x, y, 0, 0, _points.length / 2, color, borderWidth, borderColor);
		}
		
		override public function getData(ib:Buffer, vb:Buffer, start:int):void {
			var indices:Array = [];
			var verts:Array = [];
			
			var color:uint = this.color;
			var r:Number = ((color >> 16) & 0x0000ff) / 255, g:Number = ((color >> 8) & 0xff) / 255, b:Number = (color & 0x0000ff) / 255;
			
			var tArray:Array;// = Separate(indices, start);
			tArray = _points;
			var i:int,tLen:int = Math.floor(tArray.length / 2);
			for (i = 0; i < tLen; i++) {
				verts.push(x + tArray[i * 2], y + tArray[i * 2 + 1], r, g, b);
			}
			for (i = 2; i < tLen; i++) {
				indices.push(start, start + i - 1, start + i);
			}
			ib.append(new Uint16Array(indices));
			vb.append(new Float32Array(verts));
		}
	}
}