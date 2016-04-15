package laya.maths {
	
	/**
	 * 矩阵
	 * @author yung
	 */
	public class Matrix {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		public static var EMPTY:Matrix =/*[STATIC SAFE]*/ new Matrix();
		public static var TEMP:Matrix =/*[STATIC SAFE]*/ new Matrix();
		public static var _cache:* = [];
		
		public var cos:Number = 1;
		public var sin:Number = 0;
		
		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;
		public var tx:Number;
		public var ty:Number;
		
		public var bTransform:Boolean = false;
		public var inPool:Boolean = false;
		
		public function Matrix(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0) {
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			this.tx = tx;
			this.ty = ty;
			_checkTransform();
		}
		
		public function identity():Matrix {
			this.a = this.d = 1;
			this.b = this.tx = this.ty = this.c = 0;
			bTransform = false;
			return this;
		}
		
		public function _checkTransform():Boolean {
			return bTransform = (a !== 1 || b !== 0 || c !== 0 || d !== 1);
		}
		
		public function setTranslate(x:Number, y:Number):void {
			this.tx = x;
			this.ty = y;
		}
		
		public function translate(x:Number, y:Number):Matrix {
			this.tx += x;
			this.ty += y;
			return this;
		}
		
		public function scale(x:Number, y:Number):void {
			this.a *= x;
			this.d *= y;
			this.c *= x;
			this.b *= y;
			this.tx *= x;
			this.ty *= y;
			bTransform = true;
		}
		
		public function rotate(angle:Number):void {
			var cos:Number = this.cos = Math.cos(angle);
			var sin:Number = this.sin = Math.sin(angle);
			var a1:Number = this.a;
			var c1:Number = this.c;
			var tx1:Number = this.tx;
			
			this.a = a1 * cos - this.b * sin;
			this.b = a1 * sin + this.b * cos;
			this.c = c1 * cos - this.d * sin;
			this.d = c1 * sin + this.d * cos;
			this.tx = tx1 * cos - this.ty * sin;
			this.ty = tx1 * sin + this.ty * cos;
			bTransform = true;
		}
		
		public function skew(x:Number, y:Number):Matrix {
			var tanX:Number = Math.tan(x);
			var tanY:Number = Math.tan(y);
			var a1:Number = a;
			var b1:Number = b;
			a += tanY * c;
			b += tanY * d;
			c += tanX * a1;
			d += tanX * b1;
			return this;
		}
		
		public function invertTransformPoint(out:Point):void {
			var a1:Number = this.a;
			var b1:Number = this.b;
			var c1:Number = this.c;
			var d1:Number = this.d;
			var tx1:Number = this.tx;
			var n:Number = a1 * d1 - b1 * c1;
			
			var a2:Number = d1 / n;
			var b2:Number = -b1 / n;
			var c2:Number = -c1 / n;
			var d2:Number = a1 / n;
			var tx2:Number = (c1 * this.ty - d1 * tx1) / n;
			var ty2:Number = -(a1 * this.ty - b1 * tx1) / n;
			out.setTo(a2 * out.x + c2 * out.y + tx2, b2 * out.x + d2 * out.y + ty2);
		}
		
		public function transformPoint(x:Number, y:Number, out:Point):void {
			out.setTo(a * x + c * y + tx, b * x + d * y + ty);
		}
		
		public function transformPointArray(data:Array, out:Array):void {
			var len:int = data.length;
			for (var i:int; i < len; i += 2) {
				var x:Number = data[i], y:Number = data[i + 1];
				out[i] = a * x + c * y + tx;
				out[i + 1] = b * x + d * y + ty;
			}
		}
		
		public function transformPointArrayScale(data:Array, out:Array):void {
			var len:int = data.length;
			for (var i:int; i < len; i += 2) {
				var x:Number = data[i], y:Number = data[i + 1];
				out[i] = a * x + c * y;
				out[i + 1] = b * x + d * y;
			}
		}
		
		public function getScaleX():Number {
			return b === 0 ? a : Math.sqrt(a * a + b * b);
		}
		
		public function getScaleY():Number {
			return c === 0 ? d : Math.sqrt(c * c + d * d);
		}
		
		public function invert():Matrix {
			var a1:Number = this.a;
			var b1:Number = this.b;
			var c1:Number = this.c;
			var d1:Number = this.d;
			var tx1:Number = this.tx;
			var n:Number = a1 * d1 - b1 * c1;
			a = d1 / n;
			b = -b1 / n;
			c = -c1 / n;
			d = a1 / n;
			tx = (c1 * ty - d1 * tx1) / n;
			ty = -(a1 * ty - b1 * tx1) / n;
			return this;
		}
		
		public function setTo(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):Matrix {
			this.a = a, this.b = b, this.c = c, this.d = d, this.tx = tx, this.ty = ty;
			return this;
		}
		
		public function concat(mtx:Matrix):Matrix {
			var a:Number = this.a;
			var c:Number = this.c;
			var tx:Number = this.tx;
			this.a = a * mtx.a + this.b * mtx.c;
			this.b = a * mtx.b + this.b * mtx.d;
			this.c = c * mtx.a + this.d * mtx.c;
			this.d = c * mtx.b + this.d * mtx.d;
			this.tx = tx * mtx.a + this.ty * mtx.c + mtx.tx;
			this.ty = tx * mtx.b + this.ty * mtx.d + mtx.ty;
			return this;
		}
		
		public static function mul(m1:Matrix, m2:Matrix, out:Matrix):Matrix {
			var aa:Number = m1.a, ab:Number = m1.b, ac:Number = m1.c, ad:Number = m1.d, atx:Number = m1.tx, aty:Number = m1.ty;
			var ba:Number = m2.a, bb:Number = m2.b, bc:Number = m2.c, bd:Number = m2.d, btx:Number = m2.tx, bty:Number = m2.ty;
			if (bb !== 0 || bc !== 0) {
				out.a = aa * ba + ab * bc;
				out.b = aa * bb + ab * bd;
				out.c = ac * ba + ad * bc;
				out.d = ac * bb + ad * bd;
				out.tx = ba * atx + bc * aty + btx;
				out.ty = bb * atx + bd * aty + bty;
			} else {
				out.a = aa * ba;
				out.b = ab * bd;
				out.c = ac * ba;
				out.d = ad * bd;
				out.tx = ba * atx + btx;
				out.ty = bd * aty + bty;
			}
			return out;
		}

		public static function mulPre(m1:Matrix, ba:Number,bb:Number,bc:Number,bd:Number,btx:Number,bty:Number, out:Matrix):Matrix {
			var aa:Number = m1.a, ab:Number = m1.b, ac:Number = m1.c, ad:Number = m1.d, atx:Number = m1.tx, aty:Number = m1.ty;
			if (bb !== 0 || bc !== 0) {
				out.a = aa * ba + ab * bc;
				out.b = aa * bb + ab * bd;
				out.c = ac * ba + ad * bc;
				out.d = ac * bb + ad * bd;
				out.tx = ba * atx + bc * aty + btx;
				out.ty = bb * atx + bd * aty + bty;
			} else {
				out.a = aa * ba;
				out.b = ab * bd;
				out.c = ac * ba;
				out.d = ad * bd;
				out.tx = ba * atx + btx;
				out.ty = bd * aty + bty;
			}
			return out;
		}
		public static function mulPos(m1:Matrix, aa:Number,ab:Number,ac:Number,ad:Number,atx:Number,aty:Number, out:Matrix):Matrix {
			var ba:Number = m1.a, bb:Number = m1.b, bc:Number = m1.c, bd:Number = m1.d, btx:Number = m1.tx, bty:Number = m1.ty;
			if (bb !== 0 || bc !== 0) {
				out.a = aa * ba + ab * bc;
				out.b = aa * bb + ab * bd;
				out.c = ac * ba + ad * bc;
				out.d = ac * bb + ad * bd;
				out.tx = ba * atx + bc * aty + btx;
				out.ty = bb * atx + bd * aty + bty;
			} else {
				out.a = aa * ba;
				out.b = ab * bd;
				out.c = ac * ba;
				out.d = ad * bd;
				out.tx = ba * atx + btx;
				out.ty = bd * aty + bty;
			}
			return out;
		}
		
		public static function preMul(parent:Matrix, self:Matrix, out:Matrix):Matrix {
			var pa:Number = parent.a, pb:Number = parent.b, pc:Number = parent.c, pd:Number = parent.d;
			var na:Number = self.a, nb:Number = self.b, nc:Number = self.c, nd:Number = self.d, ntx:Number = self.tx, nty:Number = self.ty;
			out.a = na * pa;
			out.b = out.c = 0;
			out.d = nd * pd;
			out.tx = ntx * pa + parent.tx;
			out.ty = nty * pd + parent.ty;
			if (nb !== 0 || nc !== 0 || pb !== 0 || pc !== 0) {
				out.a += nb * pc;
				out.d += nc * pb;
				out.b += na * pb + nb * pd;
				out.c += nc * pa + nd * pc;
				out.tx += nty * pc;
				out.ty += ntx * pb;
			}
			return out;
		}
		
		public static function preMulXY(parent:Matrix, x:Number, y:Number, out:Matrix):Matrix {
			var pa:Number = parent.a, pb:Number = parent.b, pc:Number = parent.c, pd:Number = parent.d;
			out.a = pa;
			out.b = pb;
			out.c = pc;
			out.d = pd;
			out.tx = x * pa + parent.tx + y * pc;
			out.ty = y * pd + parent.ty + x * pb;
			return out;
		}
		
		public function clone():Matrix {
			var no:* = _cache;
			var dec:Matrix = !no._length ? (new Matrix()) : no[--no._length];
			dec.a = a;
			dec.b = b;
			dec.c = c;
			dec.d = d;
			dec.tx = tx;
			dec.ty = ty;
			dec.bTransform = bTransform;
			return dec;
		}
		
		public function copy(dec:Matrix):Matrix {
			dec.a = a;
			dec.b = b;
			dec.c = c;
			dec.d = d;
			dec.tx = tx;
			dec.ty = ty;
			dec.bTransform = bTransform;
			return dec;
		}
		
		public function toString():String {
			return a + "," + b + "," + c + "," + d + "," + tx + "," + ty;
		}
		
		//内存管理应该是数学计算以外的事情不能放到这里哎
		public function destroy():void {
			if (inPool) return;
			var cache:* = _cache;
			inPool = true;
			cache._length || (cache._length = 0);
			cache[cache._length++] = this;
			a = d = 1;
			b = c = tx = ty = 0;
			bTransform = false;
		}
		
		public static function create():Matrix {
			var cache:* = _cache;
			var mat:Matrix = !cache._length ? (new Matrix()) : cache[--cache._length];
			mat.inPool = false;
			return mat;
		}
	}
}