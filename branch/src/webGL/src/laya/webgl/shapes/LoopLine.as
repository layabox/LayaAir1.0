package laya.webgl.shapes {
	import laya.webgl.utils.Buffer2D;
	
	public class LoopLine extends BasePoly {
		
		private var _points:Array = [];
		
		public function LoopLine(x:Number, y:Number, points:Array, width:int, color:uint) {
			//把没用的顶点数据过滤掉
			var tCurrX:Number;
			var tCurrY:Number;
			var tLastX:Number = -1;
			var tLastY:Number = -1;
			var tLen:int = points.length / 2 - 1;
			for (var i:int = 0; i < tLen; i++) {
				tCurrX = points[i * 2];
				tCurrY = points[i * 2 + 1];
				if (Math.abs(tLastX - tCurrX) > 0.01 || Math.abs(tLastY - tCurrY) > 0.01) {
					_points.push(tCurrX, tCurrY);
				}
				tLastX = tCurrX;
				tLastY = tCurrY;
			}
			tCurrX = points[tLen * 2];
			tCurrY = points[tLen * 2 + 1];
			tLastX = _points[0];
			tLastY = _points[1];
			if (Math.abs(tLastX - tCurrX) > 0.01 || Math.abs(tLastY - tCurrY) > 0.01) {
				_points.push(tCurrX, tCurrY);
			}
			super(x, y, 0, 0, _points.length / 2, 0, width, color);
		}
		
		override public function getData(ib:Buffer2D, vb:Buffer2D, start:int):void {
			if (borderWidth > 0) {
				var color:uint = this.color;
				var r:Number = ((color >> 16) & 0x0000ff) / 255, g:Number = ((color >> 8) & 0xff) / 255, b:Number = (color & 0x0000ff) / 255;
				
				var verts:Array = [];
				var tLastX:Number = -1, tLastY:Number = -1;
				var tCurrX:Number = 0, tCurrY:Number = 0;
				var indices:Array = [];
				var tLen:int = Math.floor(_points.length / 2);
				for (var i:int = 0; i < tLen; i++) {
					tCurrX = _points[i * 2];
					tCurrY = _points[i * 2 + 1];
					verts.push(x + tCurrX, y + tCurrY, r, g, b);
				}
				createLoopLine(verts, indices, borderWidth, start + verts.length / 5);
				ib.append(new Uint16Array(indices));
				vb.append(new Float32Array(verts));
			}
		}
		
		override public function createLoopLine(p:Array, indices:Array, lineWidth:Number, len:Number, outVertex:Array = null, outIndex:Array = null):Array {
			var tLen:int = p.length / 5;
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var points:Array = p.concat();
			var result:Array = outVertex ? outVertex : p;
			var color:uint = this.borderColor;
			var r:Number = ((color >> 16) & 0x0000ff) / 255, g:Number = ((color >> 8) & 0xff) / 255, b:Number = (color & 0x0000ff) / 255;
			
			var firstPoint:Array = [points[0], points[1]];
			var lastPoint:Array = [points[points.length - 5], points[points.length - 4]];
			
			var midPointX:Number = lastPoint[0] + (firstPoint[0] - lastPoint[0]) * 0.5;
			var midPointY:Number = lastPoint[1] + (firstPoint[1] - lastPoint[1]) * 0.5;
			
			points.unshift(midPointX, midPointY, 0, 0, 0);
			points.push(midPointX, midPointY, 0, 0, 0);
			
			var length:int = points.length / 5;
			var iStart:int = len, w:Number = lineWidth / 2;
			
			var px:Number, py:Number, p1x:Number, p1y:Number, p2x:Number, p2y:Number, p3x:Number, p3y:Number;
			var perpx:Number, perpy:Number, perp2x:Number, perp2y:Number, perp3x:Number, perp3y:Number;
			var a1:Number, b1:Number, c1:Number, a2:Number, b2:Number, c2:Number;
			var denom:Number, pdist:Number, dist:Number;
			
			p1x = points[0];
			p1y = points[1];
			p2x = points[5];
			p2y = points[6];
			
			perpx = -(p1y - p2y);
			perpy = p1x - p2x;
			dist = Math.sqrt(perpx * perpx + perpy * perpy);
			perpx = perpx / dist * w;
			perpy = perpy / dist * w;
			
			result.push(p1x - perpx, p1y - perpy, r, g, b, p1x + perpx, p1y + perpy, r, g, b);
			
			for (var i:int = 1; i < length - 1; i++) {
				p1x = points[(i - 1) * 5];
				p1y = points[(i - 1) * 5 + 1];
				p2x = points[(i) * 5];
				p2y = points[(i) * 5 + 1];
				p3x = points[(i + 1) * 5];
				p3y = points[(i + 1) * 5 + 1];
				
				perpx = -(p1y - p2y);
				perpy = p1x - p2x;
				dist = Math.sqrt(perpx * perpx + perpy * perpy);
				perpx = perpx / dist * w;
				perpy = perpy / dist * w;
				perp2x = -(p2y - p3y);
				perp2y = p2x - p3x;
				dist = Math.sqrt(perp2x * perp2x + perp2y * perp2y);
				perp2x = perp2x / dist * w;
				perp2y = perp2y / dist * w;
				
				a1 = (-perpy + p1y) - (-perpy + p2y);
				b1 = (-perpx + p2x) - (-perpx + p1x);
				c1 = (-perpx + p1x) * (-perpy + p2y) - (-perpx + p2x) * (-perpy + p1y);
				a2 = (-perp2y + p3y) - (-perp2y + p2y);
				b2 = (-perp2x + p2x) - (-perp2x + p3x);
				c2 = (-perp2x + p3x) * (-perp2y + p2y) - (-perp2x + p2x) * (-perp2y + p3y);
				denom = a1 * b2 - a2 * b1;
				if (Math.abs(denom) < 0.1) {
					denom += 10.1;
					result.push(p2x - perpx, p2y - perpy, r, g, b, p2x + perpx, p2y + perpy, r, g, b);
					continue;
				}
				px = (b1 * c2 - b2 * c1) / denom;
				py = (a2 * c1 - a1 * c2) / denom;
				pdist = (px - p2x) * (px - p2x) + (py - p2y) + (py - p2y);
				result.push(px, py, r, g, b, p2x - (px - p2x), p2y - (py - p2y), r, g, b);
			}
			if (outIndex) {
				indices = outIndex;
			}
			var groupLen:int = this.edges + 1;
			for (i = 1; i < groupLen; i++) {
				indices.push(iStart + (i - 1) * 2, iStart + (i - 1) * 2 + 1, iStart + i * 2 + 1, iStart + i * 2 + 1, iStart + i * 2, iStart + (i - 1) * 2);
			}
			indices.push(iStart + (i - 1) * 2, iStart + (i - 1) * 2 + 1, iStart + 1, iStart + 1, iStart, iStart + (i - 1) * 2);
			
			return result;
		}
	
	}

}