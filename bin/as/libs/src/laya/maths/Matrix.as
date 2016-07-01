package laya.maths {
	
	/**
	 * <code>Matrix</code> 类表示一个转换矩阵，它确定如何将点从一个坐标空间映射到另一个坐标空间。
	 */
	public class Matrix {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**@private 一个初始化的 <code>Matrix</code> 对象，不允许修改此对象内容。*/
		public static var EMPTY:Matrix =/*[STATIC SAFE]*/ new Matrix();
		/** 用于中转使用的 <code>Matrix</code> 对象。*/
		public static var TEMP:Matrix =/*[STATIC SAFE]*/ new Matrix();
		/**@private */
		public static var _cache:* = [];
		
		/**@private 矩阵旋转角度的余弦值。*/
		public var cos:Number = 1;
		/**@private 矩阵旋转角度的正弦值。*/
		public var sin:Number = 0;
		/**缩放或旋转图像时影响像素沿 x 轴定位的值。*/
		public var a:Number;
		/**旋转或倾斜图像时影响像素沿 y 轴定位的值。*/
		public var b:Number;
		/**旋转或倾斜图像时影响像素沿 x 轴定位的值。*/
		public var c:Number;
		/**缩放或旋转图像时影响像素沿 y 轴定位的值。*/
		public var d:Number;
		/**沿 x 轴平移每个点的距离。*/
		public var tx:Number;
		/**沿 y 轴平移每个点的距离。*/
		public var ty:Number;
		
		/**@private 表示此对象是否在对象池中。*/
		public var inPool:Boolean = false;
		/**@private 是否有改变矩阵的值。*/
		public var bTransform:Boolean = false;
		
		/**
		 * 使用指定参数创建新的 <code>Matrix</code> 对象。
		 * @param	a 缩放或旋转图像时影响像素沿 x 轴定位的值。
		 * @param	b 旋转或倾斜图像时影响像素沿 y 轴定位的值。
		 * @param	c 旋转或倾斜图像时影响像素沿 x 轴定位的值。
		 * @param	d 缩放或旋转图像时影响像素沿 y 轴定位的值。
		 * @param	tx 沿 x 轴平移每个点的距离。
		 * @param	ty 沿 y 轴平移每个点的距离。
		 */
		public function Matrix(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0) {
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			this.tx = tx;
			this.ty = ty;
			_checkTransform();
		}
		
		/**
		 * 为每个矩阵属性设置一个值。
		 * @return 返回当前矩形。
		 */
		public function identity():Matrix {
			this.a = this.d = 1;
			this.b = this.tx = this.ty = this.c = 0;
			bTransform = false;
			return this;
		}
		
		/**@private*/
		public function _checkTransform():Boolean {
			return bTransform = (a !== 1 || b !== 0 || c !== 0 || d !== 1);
		}
		
		/**
		 * 设置沿 x 、y 轴平移每个点的距离。
		 * @param	x 沿 x 轴平移每个点的距离。
		 * @param	y 沿 y 轴平移每个点的距离。
		 * @return	返回对象本身
		 */
		public function setTranslate(x:Number, y:Number):Matrix {
			this.tx = x;
			this.ty = y;
			return this;
		}
		
		/**
		 * 沿 x 和 y 轴平移矩阵，由 x 和 y 参数指定。
		 * @param	x 沿 x 轴向右移动的量（以像素为单位）。
		 * @param	y 沿 y 轴向下移动的量（以像素为单位）。
		 * @return 返回此矩形。
		 */
		public function translate(x:Number, y:Number):Matrix {
			this.tx += x;
			this.ty += y;
			return this;
		}
		
		/**
		 * 对矩阵应用缩放转换。
		 * @param	x 用于沿 x 轴缩放对象的乘数。
		 * @param	y 用于沿 y 轴缩放对象的乘数。
		 */
		public function scale(x:Number, y:Number):void {
			this.a *= x;
			this.d *= y;
			this.c *= x;
			this.b *= y;
			this.tx *= x;
			this.ty *= y;
			bTransform = true;
		}
		
		/**
		 * 对 Matrix 对象应用旋转转换。
		 * @param	angle 以弧度为单位的旋转角度。
		 */
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
		
		/**
		 * 对 Matrix 对象应用倾斜转换。
		 * @param	x 沿着 X 轴的 2D 倾斜弧度。
		 * @param	y 沿着 Y 轴的 2D 倾斜弧度。
		 * @return 当前 Matrix 对象。
		 */
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
		
		/**
		 * 对指定的点应用当前矩阵的逆转化并返回此点。
		 * @param	out 待转化的点 Point 对象。
		 * @return	返回out
		 */
		public function invertTransformPoint(out:Point):Point {
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
			return out.setTo(a2 * out.x + c2 * out.y + tx2, b2 * out.x + d2 * out.y + ty2);
		}
		
		/**
		 * 将 Matrix 对象表示的几何转换应用于指定点。
		 * @param	out 用来设定输出结果的点。
		 * @return	返回out
		 */
		public function transformPoint(out:Point):Point {
			return out.setTo(a * out.x + c * out.y + tx, b * out.x + d * out.y + ty);
		}
		
		/**
		 * @private
		 * 将 Matrix 对象表示的几何转换应用于指定点。
		 * @param	data 点集合。
		 * @param	out 存储应用转化的点的列表。
		 * @return	返回out数组
		 */
		public function transformPointArray(data:Array, out:Array):Array {
			var len:int = data.length;
			for (var i:int; i < len; i += 2) {
				var x:Number = data[i], y:Number = data[i + 1];
				out[i] = a * x + c * y + tx;
				out[i + 1] = b * x + d * y + ty;
			}
			return out;
		}
		
		/**
		 * @private
		 * 将 Matrix 对象表示的几何缩放转换应用于指定点。
		 * @param	data 点集合。
		 * @param	out 存储应用转化的点的列表。
		 * @return	返回out数组
		 */
		public function transformPointArrayScale(data:Array, out:Array):Array {
			var len:int = data.length;
			for (var i:int; i < len; i += 2) {
				var x:Number = data[i], y:Number = data[i + 1];
				out[i] = a * x + c * y;
				out[i + 1] = b * x + d * y;
			}
			return out;
		}
		
		/**
		 * 获取 X 轴缩放值。
		 * @return  X 轴缩放值。
		 */
		public function getScaleX():Number {
			return b === 0 ? a : Math.sqrt(a * a + b * b);
		}
		
		/**
		 * 获取 Y 轴缩放值。
		 * @return Y 轴缩放值。
		 */
		public function getScaleY():Number {
			return c === 0 ? d : Math.sqrt(c * c + d * d);
		}
		
		/**
		 * 执行原始矩阵的逆转换。
		 * @return 当前矩阵对象。
		 */
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
		
		/**
		 *  将 Matrix 的成员设置为指定值。
		 * @param	a 缩放或旋转图像时影响像素沿 x 轴定位的值。
		 * @param	b 旋转或倾斜图像时影响像素沿 y 轴定位的值。
		 * @param	c 旋转或倾斜图像时影响像素沿 x 轴定位的值。
		 * @param	d 缩放或旋转图像时影响像素沿 y 轴定位的值。
		 * @param	tx 沿 x 轴平移每个点的距离。
		 * @param	ty 沿 y 轴平移每个点的距离。
		 * @return 当前矩阵对象。
		 */
		public function setTo(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):Matrix {
			this.a = a, this.b = b, this.c = c, this.d = d, this.tx = tx, this.ty = ty;
			return this;
		}
		
		/**
		 * 将指定矩阵与当前矩阵连接，从而将这两个矩阵的几何效果有效地结合在一起。
		 * @param	matrix 要连接到源矩阵的矩阵。
		 * @return 当前矩阵。
		 */
		public function concat(matrix:Matrix):Matrix {
			var a:Number = this.a;
			var c:Number = this.c;
			var tx:Number = this.tx;
			this.a = a * matrix.a + this.b * matrix.c;
			this.b = a * matrix.b + this.b * matrix.d;
			this.c = c * matrix.a + this.d * matrix.c;
			this.d = c * matrix.b + this.d * matrix.d;
			this.tx = tx * matrix.a + this.ty * matrix.c + matrix.tx;
			this.ty = tx * matrix.b + this.ty * matrix.d + matrix.ty;
			return this;
		}
		
		/**
		 * 将指定的两个矩阵相乘后的结果赋值给指定的输出对象。
		 * @param	m1 矩阵一。
		 * @param	m2 矩阵二。
		 * @param	out 输出对象。
		 * @return 结果输出对象 out。
		 */
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
		
		/**@private */
		public static function mulPre(m1:Matrix, ba:Number, bb:Number, bc:Number, bd:Number, btx:Number, bty:Number, out:Matrix):Matrix {
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
		
		/**@private */
		public static function mulPos(m1:Matrix, aa:Number, ab:Number, ac:Number, ad:Number, atx:Number, aty:Number, out:Matrix):Matrix {
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
		
		/**@private */
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
		
		/**@private */
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
		
		/**
		 * 返回一个新的 Matrix 对象，它是此矩阵的克隆，带有与所含对象完全相同的副本。
		 * @return 一个 Matrix 对象。
		 */
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
		
		/**
		 * 将当前 Matrix 对象中的所有矩阵数据复制到指定的 Matrix 对象中。
		 * @param	dec 要复制当前矩阵数据的 Matrix 对象。
		 * @return 已复制当前矩阵数据的 Matrix 对象。
		 */
		public function copyTo(dec:Matrix):Matrix {
			dec.a = a;
			dec.b = b;
			dec.c = c;
			dec.d = d;
			dec.tx = tx;
			dec.ty = ty;
			dec.bTransform = bTransform;
			return dec;
		}
		
		/**
		 * 返回列出该 Matrix 对象属性的文本值。
		 * @return 一个字符串，它包含 Matrix 对象的属性值：a、b、c、d、tx 和 ty。
		 */
		public function toString():String {
			return a + "," + b + "," + c + "," + d + "," + tx + "," + ty;
		}
		
		//内存管理应该是数学计算以外的事情不能放到这里哎
		/**
		 * 销毁此对象。
		 */
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
		
		/**
		 * 从对象池中创建一个 <code>Matrix</code> 对象。
		 * @return <code>Matrix</code> 对象。
		 */
		public static function create():Matrix {
			var cache:* = _cache;
			var mat:Matrix = !cache._length ? (new Matrix()) : cache[--cache._length];
			mat.inPool = false;
			return mat;
		}
	}
}