package laya.webgl.utils {
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.webgl.canvas.WebGLContext2D;
	
	public class GlUtils {
		// 这个矩阵已经进行Y-flip处理，屏幕左上角为 0,0 坐标.
		public static function make2DProjection(width:int, height:int, depth:int):* {
			return [2.0 / width, 0, 0, 0, 0, -2.0 / height, 0, 0, 0, 0, 2.0 / depth, 0, -1, 1, 0, 1,];
		}
		
		// 填充几何图形的Vb
		private static var _fillLineArray:Array =/*[STATIC SAFE]*/ [0, 0, /*0,*/ 0, 0, 0, 0, /*0,*/ 0, 0, 0, 0, /*0,*/ 0, 0, 0, 0, /*0,*/ 0, 0];
		
		/**
		 *  初始化全局IB,IB索引如下:
		 *   0___1
		 *	 |\  |
		 *	 | \ |
		 *	 |__\|
		 *	 3   2
		 */
		public static function fillIBQuadrangle(buffer:IndexBuffer2D, count:int):Boolean {
			if (count > 65535 / 4) {
				throw Error("IBQuadrangle count:" + count + " must<:" + Math.floor(65535 / 4));
				return false;
			}
			count = Math.floor(count);
			//trace("fillIBQuadrangle:" + count);
			buffer._resizeBuffer((count + 1) * 6 * Buffer2D.SHORT, false);
			buffer.byteLength = buffer.bufferLength;
			
			var bufferData:Uint16Array = buffer.getUint16Array();
			var idx:int = 0;
			for (var i:int = 0; i < count; i++) {
				bufferData[idx++] = i * 4;
				bufferData[idx++] = i * 4 + 2;
				bufferData[idx++] = i * 4 + 1;
				bufferData[idx++] = i * 4;
				bufferData[idx++] = i * 4 + 3;
				bufferData[idx++] = i * 4 + 2;
			}
			buffer.setNeedUpload();
			//buffer.upload();
			return true;
		}
		
		public static function expandIBQuadrangle(buffer:IndexBuffer2D, count:int):void {
			buffer.bufferLength >= (count * 6 * Buffer2D.SHORT) || fillIBQuadrangle(buffer, count);
		}
		
		public static function mathCeilPowerOfTwo(value:int):int {
			value--;
			value |= value >> 1;
			value |= value >> 2;
			value |= value >> 4;
			value |= value >> 8;
			value |= value >> 16;
			value++;
			return value;
		}
		
		public static function fillQuadrangleImgVb(vb:VertexBuffer2D, x:Number, y:Number, point4:Array, uv:Array, m:Matrix, _x:Number, _y:Number):Boolean {
			'use strict';
			
			var vpos:int = (vb._byteLength >> 2)/*FLOAT32*/ + WebGLContext2D._RECTVBSIZE;
			vb.byteLength = (vpos << 2);
			
			var vbdata:* = vb.getFloat32Array();
			vpos -= WebGLContext2D._RECTVBSIZE;
			
			vbdata[vpos + 2] = uv[0];
			vbdata[vpos + 3] = uv[1];
			vbdata[vpos + 6] = uv[2];
			vbdata[vpos + 7] = uv[3];
			vbdata[vpos + 10] = uv[4];
			vbdata[vpos + 11] = uv[5];
			vbdata[vpos + 14] = uv[6];
			vbdata[vpos + 15] = uv[7];
			var a:Number = m.a, b:Number = m.b, c:Number = m.c, d:Number = m.d;
			if (a !== 1 || b !== 0 || c !== 0 || d !== 1) {
				m.bTransform = true;
				
				var tx:Number = m.tx + _x, ty:Number = m.ty + _y;
				vbdata[vpos] = (point4[0] + x) * a + (point4[1] + y) * c + tx;
				vbdata[vpos + 1] = (point4[0] + x) * b + (point4[1] + y) * d + ty; //dh1 + bw1 + ty;
				vbdata[vpos + 4] = (point4[2] + x) * a + (point4[3] + y) * c + tx;
				vbdata[vpos + 5] = (point4[2] + x) * b + (point4[3] + y) * d + ty;
				vbdata[vpos + 8] = (point4[4] + x) * a + (point4[5] + y) * c + tx;
				vbdata[vpos + 9] = (point4[4] + x) * b + (point4[5] + y) * d + ty;
				vbdata[vpos + 12] = (point4[6] + x) * a + (point4[7] + y) * c + tx;
				vbdata[vpos + 13] = (point4[6] + x) * b + (point4[7] + y) * d + ty;
			} else {
				m.bTransform = false;
				
				x += m.tx + _x;
				y += m.ty + _y;
				
				vbdata[vpos] = x + point4[0];
				vbdata[vpos + 1] = y + point4[1];
				vbdata[vpos + 4] = x + point4[2];
				vbdata[vpos + 5] = y + point4[3];
				vbdata[vpos + 8] = x + point4[4];
				vbdata[vpos + 9] = y + point4[5];
				vbdata[vpos + 12] = x + point4[6];
				vbdata[vpos + 13] = y + point4[7];
			}
			vb._upload = true;
			return true;
		}
		
		public static function fillTranglesVB(vb:VertexBuffer2D, x:Number, y:Number, points:Array, m:Matrix, _x:Number, _y:Number):Boolean {
			//'use strict';
			//x |= 0; y |= 0;_x |= 0; _y |= 0;
			
			var vpos:int = (vb._byteLength >> 2)/*FLOAT32*/ + points.length;///    Context._RECTVBSIZE;
			vb.byteLength = (vpos << 2);
			
			var vbdata:* = vb.getFloat32Array();
			//vpos>=vbdata.length && (vbdata=(vb.resizeBuffer(vbdata.length*4+points.length*4/* 2*Buffer.FLOAT32*/ + 256,true).getFloat32Array()));			
			vpos -= points.length;
			
			var len:int = points.length;
			var a:Number = m.a, b:Number = m.b, c:Number = m.c, d:Number = m.d;
			
			for (var i:int = 0; i < len; i += 4) {
				
				vbdata[vpos + i + 2] = points[i + 2];   //u
				vbdata[vpos + i + 3] = points[i + 3];	   //v
				if (a !== 1 || b !== 0 || c !== 0 || d !== 1) {
					m.bTransform = true;
					var tx:Number = m.tx + _x, ty:Number = m.ty + _y;
					vbdata[vpos + i] = (points[i] + x) * a + (points[i + 1] + y) * c + tx;   // x
					vbdata[vpos + i + 1] = (points[i] + x) * b + (points[i + 1] + y) * d + ty; //dh1 + bw1 + ty;   //y 
					
				} else {
					m.bTransform = false;
					
					x += m.tx + _x;
					y += m.ty + _y;
					
					vbdata[vpos + i] = x + points[i];
					vbdata[vpos + i + 1] = y + points[i + 1];
				}
			}
			vb._upload = true;
			return true;
		}

		public static function copyPreImgVb(vb:VertexBuffer2D, dx:Number, dy:Number):void
		{
			
			var vpos:int = (vb._byteLength >> 2)/*FLOAT32*/;// + WebGLContext2D._RECTVBSIZE;
			vb.byteLength = ((vpos + WebGLContext2D._RECTVBSIZE) << 2);
			var vbdata:* = vb.getFloat32Array();
			for (var i:int = 0, ci:int = vpos - 16; i < 4; i++)
			{
				vbdata[vpos] = vbdata[ci] + dx;
				++vpos;
				++ci;
				vbdata[vpos] = vbdata[ci] + dy;
				++vpos;
				++ci;
				vbdata[vpos] = vbdata[ci];
				++vpos;
				++ci;
				vbdata[vpos] = vbdata[ci];
				++vpos;
				++ci;
			}
			vb._upload = true;
		}
		
		public static function fillRectImgVb(vb:VertexBuffer2D, clip:Rectangle, x:Number, y:Number, width:Number, height:Number, uv:Array, m:Matrix, _x:Number, _y:Number, dx:Number, dy:Number, round:Boolean = false):Boolean {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			//'use strict';
			
			var mType:int = 1;
			var toBx:Number, toBy:Number, toEx:Number, toEy:Number;
			var cBx:Number, cBy:Number, cEx:Number, cEy:Number;
			var w0:Number, h0:Number, tx:Number, ty:Number;
			var finalX:Number, finalY:Number, offsetX:Number, offsetY:Number;
			
			var a:Number = m.a, b:Number = m.b, c:Number = m.c, d:Number = m.d;
			var useClip:Boolean = clip && clip.width < WebGLContext2D._MAXSIZE;
			if (a !== 1 || b !== 0 || c !== 0 || d !== 1) {
				m.bTransform = true;
				if (b === 0 && c === 0) {
					
					mType = 23;// useClip ? 30 : 23;
					w0 = width + x, h0 = height + y;
					tx = m.tx + _x, ty = m.ty + _y;
					toBx = a * x + tx;
					toEx = a * w0 + tx;
					toBy = d * y + ty;
					toEy = d * h0 + ty;
				}
			} else {
				mType = 23;// useClip ? 30 : 23;
				m.bTransform = false;
				toBx = x + m.tx + _x;
				toEx = toBx + width;
				toBy = y + m.ty + _y;
				toEy = toBy + height;
			}
			
			if (useClip)//没有剪裁
			{
				cBx = clip.x, cBy = clip.y, cEx = clip.width + cBx, cEy = clip.height + cBy;
			}
			
			if (mType !== 1)
			{
				if (Math.min(toBx, toEx) >= cEx) return false;
				if (Math.min(toBy, toEy) >= cEy) return false;
				if (Math.max(toEx, toBx) <= cBx) return false;
				if (Math.max(toEy, toBy) <= cBy) return false;
			}
			
			var vpos:int = (vb._byteLength >> 2)/*FLOAT32*/;// + WebGLContext2D._RECTVBSIZE;
			vb.byteLength = ((vpos + WebGLContext2D._RECTVBSIZE) << 2);
			var vbdata:* = vb.getFloat32Array();
			//vpos -= WebGLContext2D._RECTVBSIZE;
			
			vbdata[vpos + 2] = uv[0];
			vbdata[vpos + 3] = uv[1];
			vbdata[vpos + 6] = uv[2];
			vbdata[vpos + 7] = uv[3];
			vbdata[vpos + 10] = uv[4];
			vbdata[vpos + 11] = uv[5];
			vbdata[vpos + 14] = uv[6];
			vbdata[vpos + 15] = uv[7];
			
			switch (mType) {
			case 1://有旋转，不管支持剪裁
				tx = m.tx + _x, ty = m.ty + _y;
				w0 = width + x, h0 = height + y;
				var w1:Number = x, h1:Number = y;
				var aw1:Number = a * w1, ch1:Number = c * h1, dh1:Number = d * h1, bw1:Number = b * w1;
				var aw0:Number = a * w0, ch0:Number = c * h0, dh0:Number = d * h0, bw0:Number = b * w0;
				if (round) {
					
					finalX = aw1 + ch1 + tx;
					offsetX = Math.round(finalX) - finalX;
					finalY = dh1 + bw1 + ty;
					offsetY = Math.round(finalY) - finalY;
					
					vbdata[vpos] = finalX + offsetX;
					vbdata[vpos + 1] = finalY + offsetY;
					vbdata[vpos + 4] = aw0 + ch1 + tx + offsetX;
					vbdata[vpos + 5] = dh1 + bw0 + ty + offsetY;
					vbdata[vpos + 8] = aw0 + ch0 + tx + offsetX;
					vbdata[vpos + 9] = dh0 + bw0 + ty + offsetY;
					vbdata[vpos + 12] = aw1 + ch0 + tx + offsetX;
					vbdata[vpos + 13] = dh0 + bw1 + ty + offsetY;
				} else {
					vbdata[vpos] = aw1 + ch1 + tx;
					vbdata[vpos + 1] = dh1 + bw1 + ty;
					vbdata[vpos + 4] = aw0 + ch1 + tx;
					vbdata[vpos + 5] = dh1 + bw0 + ty;
					vbdata[vpos + 8] = aw0 + ch0 + tx;
					vbdata[vpos + 9] = dh0 + bw0 + ty;
					vbdata[vpos + 12] = aw1 + ch0 + tx;
					vbdata[vpos + 13] = dh0 + bw1 + ty;
				}
				break;
			//case 2://有缩放，无剪裁
			case 23://无变换，无剪裁
				if (round) {
					finalX = toBx + dx;
					offsetX = Math.round(finalX) - finalX;
					finalY = toBy;
					offsetY = Math.round(finalY) - finalY;
					
					vbdata[vpos] = finalX + offsetX;
					vbdata[vpos + 1] = finalY + offsetY;
					vbdata[vpos + 4] = toEx + dx + offsetX;
					vbdata[vpos + 5] = toBy + offsetY;
					vbdata[vpos + 8] = toEx + offsetX;
					vbdata[vpos + 9] = toEy + offsetY;
					vbdata[vpos + 12] = toBx + offsetX;
					vbdata[vpos + 13] = toEy + offsetY;
				} else {
					vbdata[vpos] = toBx + dx;
					vbdata[vpos + 1] = toBy;
					vbdata[vpos + 4] = toEx + dx;
					vbdata[vpos + 5] = toBy;
					vbdata[vpos + 8] = toEx;
					vbdata[vpos + 9] = toEy;
					vbdata[vpos + 12] = toBx;
					vbdata[vpos + 13] = toEy;
				}
				break;
			/*
			//case 20://有缩放，有建材
			case 30://无变换，有剪裁
				if (toBx < cBx || toBy < cBy || toEx > cEx || toEy > cEy) {
					var dcx:Number = cBx - toBx, dcty:Number = cBy - toBy, decr:Number = toEx - cEx, decb:Number = toEy - cEy;
					
					if (dcx > 0) {
						toBx = cBx;
						vbdata[vpos + 14] = vbdata[vpos + 2] = vbdata[vpos + 2] + dcx / (width * a) * (vbdata[vpos + 6] - vbdata[vpos + 2])
					}
					if (dcty > 0) {
						toBy = cBy;
						vbdata[vpos + 7] = vbdata[vpos + 3] = vbdata[vpos + 3] + dcty / (height * d) * (vbdata[vpos + 11] - vbdata[vpos + 7])
					}
					if (decr > 0) {
						toEx = cEx;
						vbdata[vpos + 6] = vbdata[vpos + 10] = vbdata[vpos + 6] - decr / (width * a) * (vbdata[vpos + 6] - vbdata[vpos + 2])
					}
					if (decb > 0) {
						toEy = cEy;
						vbdata[vpos + 11] = vbdata[vpos + 15] = vbdata[vpos + 15] - decb / (height * d) * (vbdata[vpos + 11] - vbdata[vpos + 7])
					}
				}
				if (round) {
					
					finalX = toBx + dx;
					offsetX = Math.round(finalX) - finalX;
					finalY = toBy;
					offsetY = Math.round(finalY) - finalY;
					
					vbdata[vpos] = finalX + offsetX;
					vbdata[vpos + 1] = finalY + offsetY;
					vbdata[vpos + 4] = toEx + dx + offsetX;
					vbdata[vpos + 5] = toBy + offsetY;
					vbdata[vpos + 8] = toEx + offsetX;
					vbdata[vpos + 9] = toEy + offsetY;
					vbdata[vpos + 12] = toBx + offsetX;
					vbdata[vpos + 13] = toEy + offsetY;
				} else {
					vbdata[vpos] = toBx + dx;
					vbdata[vpos + 1] = toBy;
					vbdata[vpos + 4] = toEx + dx;
					vbdata[vpos + 5] = toBy;
					vbdata[vpos + 8] = toEx;
					vbdata[vpos + 9] = toEy;
					vbdata[vpos + 12] = toBx;
					vbdata[vpos + 13] = toEy;
				}*/
			}
			vb._upload = true;
			return true;
		}
		
		public static function fillLineVb(vb:VertexBuffer2D, clip:Rectangle, fx:Number, fy:Number, tx:Number, ty:Number, width:Number, mat:Matrix):Boolean {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			'use strict';
			
			var linew:Number = width * .5;
			
			var data:Array = _fillLineArray;
			var perpx:Number = -(fy - ty), perpy:Number = fx - tx;
			var dist:Number = Math.sqrt(perpx * perpx + perpy * perpy);
			perpx /= dist, perpy /= dist, perpx *= linew, perpy *= linew;
			data[0] = fx - perpx, data[1] = fy - perpy, data[4] = fx + perpx, data[5] = fy + perpy, data[8] = tx + perpx, data[9] = ty + perpy, data[12] = tx - perpx, data[13] = ty - perpy;
			mat && mat.transformPointArray(data, data);
			var vpos:int = (vb._byteLength >> 2)/*FLOAT32*/ + WebGLContext2D._RECTVBSIZE;
			vb.byteLength = (vpos << 2);
			vb.insertData(data, vpos - WebGLContext2D._RECTVBSIZE);
			return true;
		}
	}

}