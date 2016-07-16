package laya.webgl.shapes
{
	
	import laya.maths.Point;
	import laya.webgl.utils.Buffer2D;
	//此类可以减少代码
	public class BasePoly implements IShape
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		public var x:Number, y:Number, r:Number, width:Number, height:Number, edges:Number, r0:Number = 0, r1:Number = Math.PI / 2;
		public var color:uint, borderColor:Number, borderWidth:Number, round:uint;
		public var fill:Boolean = true;
		
		public function BasePoly(x:Number, y:Number, width:Number, height:Number, edges:Number, color:uint, borderWidth:int, borderColor:uint, round:uint = 0)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.edges = edges;
			this.color = color;
			this.borderWidth = borderWidth;
			this.borderColor = borderColor;
		}
		
		public function getData(ib:Buffer2D, vb:Buffer2D, start:int):void
		{
			
		}
		
		protected function sector(outVert:Array, outIndex:Array, start:int):void
		{
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var x:Number = this.x, y:Number = this.y, edges:int = this.edges, seg:int = (r1 - r0) / edges;
			var w:Number = this.width, h:Number = this.height, color:uint = this.color
			var r:Number = ((color >> 16) & 0x0000ff) / 255, g:Number = ((color >> 8) & 0xff) / 255, b:Number = (color & 0x0000ff) / 255;
			outVert.push(x, y, r, g, b);
			
			for (var i:int = 0; i < edges + 1; i++)
			{
				outVert.push(x + Math.sin(seg * i + r0) * w, y + Math.cos(seg * i + r0) * h);
				outVert.push(r, g, b);
			}
			for (i = 0; i < edges; i++)
			{
				outIndex.push(start, start + i + 1, start + i + 2);
			}
			//outIndex[outIndex.length-1]=start+1;
		}
		
		//用于画线
		protected function createLine2(p:Array, indices:Array, lineWidth:Number, len:Number, outVertex:Array, indexCount:int):Array
		{
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var points:Array = p.concat();
			var result:Array = outVertex;
			var color:uint = this.borderColor;
			var r:Number = ((color >> 16) & 0x0000ff) / 255, g:Number = ((color >> 8) & 0xff) / 255, b:Number = (color & 0x0000ff) / 255;
			var length:int = points.length / 2;
			var iStart:int = len, w:Number = lineWidth / 2;
			
			var px:Number, py:Number, p1x:Number, p1y:Number, p2x:Number, p2y:Number, p3x:Number, p3y:Number;
			var perpx:Number, perpy:Number, perp2x:Number, perp2y:Number, perp3x:Number, perp3y:Number;
			var a1:Number, b1:Number, c1:Number, a2:Number, b2:Number, c2:Number;
			var denom:Number, pdist:Number, dist:Number;
			
			p1x = points[0];
			p1y = points[1];
			p2x = points[2];
			p2y = points[3];
			
			perpx = -(p1y - p2y);
			perpy = p1x - p2x;
			dist = Math.sqrt(perpx * perpx + perpy * perpy);
			perpx = perpx / dist * w;
			perpy = perpy / dist * w;
			
			result.push(p1x - perpx + this.x, p1y - perpy + this.y, r, g, b, p1x + perpx + this.x, p1y + perpy + this.y, r, g, b);
			for (var i:int = 1; i < length - 1; i++)
			{
				p1x = points[(i - 1) * 2];
				p1y = points[(i - 1) * 2 + 1];
				p2x = points[(i) * 2];
				p2y = points[(i) * 2 + 1];
				p3x = points[(i + 1) * 2];
				p3y = points[(i + 1) * 2 + 1];
				
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
				if (Math.abs(denom) < 0.1)
				{
					denom += 10.1;
					result.push(p2x - perpx + this.x, p2y - perpy + this.y, r, g, b, p2x + perpx + this.x, p2y + perpy + this.y, r, g, b);
					continue;
				}
				px = (b1 * c2 - b2 * c1) / denom;
				py = (a2 * c1 - a1 * c2) / denom;
				pdist = (px - p2x) * (px - p2x) + (py - p2y) + (py - p2y);
				result.push(px + this.x, py + this.y, r, g, b, p2x - (px - p2x) + this.x, p2y - (py - p2y) + this.y, r, g, b);
			}
			
			p1x = points[points.length - 4];
			p1y = points[points.length - 3];
			p2x = points[points.length - 2];
			p2y = points[points.length - 1];
			
			perpx = -(p1y - p2y);
			perpy = p1x - p2x;
			dist = Math.sqrt(perpx * perpx + perpy * perpy);
			perpx = perpx / dist * w;
			perpy = perpy / dist * w;
			result.push(p2x - perpx + this.x, p2y - perpy + this.y, r, g, b, p2x + perpx + this.x, p2y + perpy + this.y, r, g, b);
			var groupLen:int = indexCount;
			for (i = 1; i < groupLen; i++)
			{
				indices.push(iStart + (i - 1) * 2, iStart + (i - 1) * 2 + 1, iStart + i * 2 + 1, iStart + i * 2 + 1, iStart + i * 2, iStart + (i - 1) * 2);
			}
			//indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+1,iStart+1,iStart,iStart+(i-1)*2);
			
			return result;
		}
		
		//用于比如 扇形 不带两直线
		protected function createLine(p:Array, indices:Array, lineWidth:Number, len:Number /*,outVertex:Array,outIndex:Array*/):Array
		{
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var points:Array = p.concat();
			var result:Array = p;
			var color:uint = this.borderColor;
			var r:Number = ((color >> 16) & 0x0000ff) / 255, g:Number = ((color >> 8) & 0xff) / 255, b:Number = (color & 0x0000ff) / 255;
			points.splice(0, 5);
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
			for (var i:int = 1; i < length - 1; i++)
			{
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
				if (Math.abs(denom) < 0.1)
				{
					denom += 10.1;
					result.push(p2x - perpx, p2y - perpy, r, g, b, p2x + perpx, p2y + perpy, r, g, b);
					continue;
				}
				px = (b1 * c2 - b2 * c1) / denom;
				py = (a2 * c1 - a1 * c2) / denom;
				pdist = (px - p2x) * (px - p2x) + (py - p2y) + (py - p2y);
				result.push(px, py, r, g, b, p2x - (px - p2x), p2y - (py - p2y), r, g, b);
			}
			
			p1x = points[points.length - 10];
			p1y = points[points.length - 9];
			p2x = points[points.length - 5];
			p2y = points[points.length - 4];
			
			perpx = -(p1y - p2y);
			perpy = p1x - p2x;
			dist = Math.sqrt(perpx * perpx + perpy * perpy);
			perpx = perpx / dist * w;
			perpy = perpy / dist * w;
			result.push(p2x - perpx, p2y - perpy, r, g, b, p2x + perpx, p2y + perpy, r, g, b);
			var groupLen:int = this.edges + 1;
			for (i = 1; i < groupLen; i++)
			{
				indices.push(iStart + (i - 1) * 2, iStart + (i - 1) * 2 + 1, iStart + i * 2 + 1, iStart + i * 2 + 1, iStart + i * 2, iStart + (i - 1) * 2);
			}
			//indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+1,iStart+1,iStart,iStart+(i-1)*2);
			
			return result;
		}
		
		//闭合路径
		public function createLoopLine(p:Array, indices:Array, lineWidth:Number, len:Number, outVertex:Array = null, outIndex:Array = null):Array
		{
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var points:Array = p.concat();
			var result:Array = outVertex ? outVertex : p;
			var color:uint = this.borderColor;
			var r:Number = ((color >> 16) & 0x0000ff) / 255, g:Number = ((color >> 8) & 0xff) / 255, b:Number = (color & 0x0000ff) / 255;
			points.splice(0, 5);
			
			var firstPoint:Array = [points[0], points[1]];
			var lastPoint:Array = [points[points.length - 5], points[points.length - 4]];
			var midPointX:Number = lastPoint[0] + (firstPoint[0] - lastPoint[0]) * 0.5;
			var midPointY:Number = lastPoint[1] + (firstPoint[1] - lastPoint[1]) * 0.5;
			
			points.unshift(midPointX, midPointY, 0, 0, 0);
			points.push(midPointX, midPointY, 0, 0, 0);
			
			var length:int = points.length / 5;
			//var indexCount:int = length*2-2;
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
			
			for (var i:int = 1; i < length - 1; i++)
			{
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
				if (Math.abs(denom) < 0.1)
				{
					denom += 10.1;
					result.push(p2x - perpx, p2y - perpy, r, g, b, p2x + perpx, p2y + perpy, r, g, b);
					continue;
				}
				px = (b1 * c2 - b2 * c1) / denom;
				py = (a2 * c1 - a1 * c2) / denom;
				pdist = (px - p2x) * (px - p2x) + (py - p2y) + (py - p2y);
				result.push(px, py, r, g, b, p2x - (px - p2x), p2y - (py - p2y), r, g, b);
			}
			if (outIndex)
			{
				indices = outIndex;
			}
			var groupLen:int = this.edges + 1;
			for (i = 1; i < groupLen; i++)
			{
				indices.push(iStart + (i - 1) * 2, iStart + (i - 1) * 2 + 1, iStart + i * 2 + 1, iStart + i * 2 + 1, iStart + i * 2, iStart + (i - 1) * 2);
			}
			indices.push(iStart + (i - 1) * 2, iStart + (i - 1) * 2 + 1, iStart + 1, iStart + 1, iStart, iStart + (i - 1) * 2);
			
			return result;
		}
	}
}