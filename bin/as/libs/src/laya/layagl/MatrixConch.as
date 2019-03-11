package laya.layagl {
	import laya.maths.Point;
	
	/**
	 * <p> <code>Matrix</code> 类表示一个转换矩阵，它确定如何将点从一个坐标空间映射到另一个坐标空间。</p>
	 * <p>您可以对一个显示对象执行不同的图形转换，方法是设置 Matrix 对象的属性，将该 Matrix 对象应用于 Transform 对象的 matrix 属性，然后应用该 Transform 对象作为显示对象的 transform 属性。这些转换函数包括平移（x 和 y 重新定位）、旋转、缩放和倾斜。</p>
	 */
	public class MatrixConch {
		/**@private */
		public static const A:int = 0;
		/**@private */
		public static const B:int = 1;
		/**@private */
		public static const C:int = 2;
		/**@private */
		public static const D:int = 3;
		/**@private */
		public static const TX:int = 4;
		/**@private */
		public static const TY:int = 5;
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**@private 一个初始化的 <code>Matrix</code> 对象，不允许修改此对象内容。*/
		public static var EMPTY:MatrixConch =/*[STATIC SAFE]*/ new MatrixConch();
		/**用于中转使用的 <code>Matrix</code> 对象。*/
		public static var TEMP:MatrixConch =/*[STATIC SAFE]*/ new MatrixConch();
		/**@private */
		private static var _pool:Array = [];
		
		/**@private */
		public var _nums:Float32Array;
		/**@private 是否有旋转缩放操作*/
		public var _bTransform:Boolean;
		
		/**
		 * 使用指定参数创建新的 <code>Matrix</code> 对象。
		 * @param a		（可选）缩放或旋转图像时影响像素沿 x 轴定位的值。
		 * @param b		（可选）旋转或倾斜图像时影响像素沿 y 轴定位的值。
		 * @param c		（可选）旋转或倾斜图像时影响像素沿 x 轴定位的值。
		 * @param d		（可选）缩放或旋转图像时影响像素沿 y 轴定位的值。
		 * @param tx	（可选）沿 x 轴平移每个点的距离。
		 * @param ty	（可选）沿 y 轴平移每个点的距离。
		 */
		public function MatrixConch(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0, nums:Float32Array = null) {
			this._nums = nums = nums ? nums : new Float32Array(6);
			nums[A] = a;
			nums[B] = b;
			nums[C] = c;
			nums[D] = d;
			nums[TX] = tx;
			nums[TY] = ty;
			_checkTransform();
		}
		
		/**缩放或旋转图像时影响像素沿 x 轴定位的值。*/
		public function get a():Number {
			return _nums[A];
		}
		
		public function set a(value:Number):void {
			_nums[A] = value;
		}
		
		/**旋转或倾斜图像时影响像素沿 y 轴定位的值。*/
		public function get b():Number {
			return _nums[B];
		}
		
		public function set b(value:Number):void {
			_nums[B] = value;
		}
		
		/**旋转或倾斜图像时影响像素沿 x 轴定位的值。*/
		public function get c():Number {
			return _nums[C];
		}
		
		public function set c(value:Number):void {
			_nums[C] = value;
		}
		
		/**缩放或旋转图像时影响像素沿 y 轴定位的值。*/
		public function get d():Number {
			return _nums[D];
		}
		
		public function set d(value:Number):void {
			_nums[D] = value;
		}
		
		/**沿 x 轴平移每个点的距离。*/
		public function get tx():Number {
			return _nums[TX];
		}
		
		public function set tx(value:Number):void {
			_nums[TX] = value;
		}
		
		/**沿 y 轴平移每个点的距离。*/
		public function get ty():Number {
			return _nums[TY];
		}
		
		public function set ty(value:Number):void {
			_nums[TY] = value;
		}
		
		/**
		 * 将本矩阵设置为单位矩阵。
		 * @return	返回矩阵对象本身
		 */
		public function identity():MatrixConch {
			var nums:Float32Array = this._nums;
			nums[A] = nums[D] = 1;
			nums[B] = nums[TX] = nums[TY] = nums[C] = 0;
			_bTransform = false;
			return this;
		}
		
		/**@private */
		public function _checkTransform():Boolean {
			var nums:Float32Array = this._nums;
			return _bTransform = (nums[A] !== 1 || nums[B] !== 0 || nums[C] !== 0 || nums[D] !== 1);
		}
		
		/**
		 * 设置沿 x 、y 轴平移每个点的距离。
		 * @param	x 沿 x 轴平移每个点的距离。
		 * @param	y 沿 y 轴平移每个点的距离。
		 * @return	返回矩阵对象本身
		 */
		public function setTranslate(x:Number, y:Number):MatrixConch {
			this._nums[TX] = x;
			this._nums[TY] = y;
			return this;
		}
		
		/**
		 * 沿 x 和 y 轴平移矩阵，平移的变化量由 x 和 y 参数指定。
		 * @param	x 沿 x 轴向右移动的量（以像素为单位）。
		 * @param	y 沿 y 轴向下移动的量（以像素为单位）。
		 * @return	返回矩阵对象本身
		 */
		public function translate(x:Number, y:Number):MatrixConch {
			this._nums[TX] += x;
			this._nums[TY] += y;
			return this;
		}
		
		/**
		 * 对矩阵应用缩放转换。
		 * @param	x 用于沿 x 轴缩放对象的乘数。
		 * @param	y 用于沿 y 轴缩放对象的乘数。
		 * @return	返回矩阵对象本身
		 */
		public function scale(x:Number, y:Number):MatrixConch {
			var nums:Float32Array = this._nums;
			nums[A] *= x;
			nums[D] *= y;
			nums[C] *= x;
			nums[B] *= y;
			nums[TX] *= x;
			nums[TY] *= y;
			this._bTransform = true;
			return this;
		}
		
		/**
		 * 对 Matrix 对象应用旋转转换。
		 * @param	angle 以弧度为单位的旋转角度。
		 * @return	返回矩阵对象本身
		 */
		public function rotate(angle:Number):MatrixConch {
			var nums:Float32Array = this._nums;
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			var a1:Number = nums[A];
			var c1:Number = nums[C];
			var tx1:Number = nums[TX];
			
			nums[A] = a1 * cos - nums[B] * sin;
			nums[B] = a1 * sin + nums[B] * cos;
			nums[C] = c1 * cos - nums[D] * sin;
			nums[D] = c1 * sin + nums[D] * cos;
			nums[TX] = tx1 * cos - nums[TY] * sin;
			nums[TY] = tx1 * sin + nums[TY] * cos;
			_bTransform = true;
			return this;
		}
		
		/**
		 * 对 Matrix 对象应用倾斜转换。
		 * @param	x 沿着 X 轴的 2D 倾斜弧度。
		 * @param	y 沿着 Y 轴的 2D 倾斜弧度。
		 * @return	返回矩阵对象本身
		 */
		public function skew(x:Number, y:Number):MatrixConch {
			var nums:Float32Array = this._nums;
			var tanX:Number = Math.tan(x);
			var tanY:Number = Math.tan(y);
			var a1:Number = nums[A];
			var b1:Number = nums[B];
			nums[A] += tanY * nums[C];
			nums[B] += tanY * nums[D];
			nums[C] += tanX * a1;
			nums[D] += tanX * b1;
			return this;
		}
		
		/**
		 * 对指定的点应用当前矩阵的逆转化并返回此点。
		 * @param	out 待转化的点 Point 对象。
		 * @return	返回out
		 */
		public function invertTransformPoint(out:Point):Point {
			var nums:Float32Array = this._nums;
			var a1:Number = nums[A];
			var b1:Number = nums[B];
			var c1:Number = nums[C];
			var d1:Number = nums[D];
			var tx1:Number = nums[TX];
			var n:Number = a1 * d1 - b1 * c1;
			
			var a2:Number = d1 / n;
			var b2:Number = -b1 / n;
			var c2:Number = -c1 / n;
			var d2:Number = a1 / n;
			var tx2:Number = (c1 * nums[TY] - d1 * tx1) / n;
			var ty2:Number = -(a1 * nums[TY] - b1 * tx1) / n;
			return out.setTo(a2 * out.x + c2 * out.y + tx2, b2 * out.x + d2 * out.y + ty2);
		}
		
		/**
		 * 将 Matrix 对象表示的几何转换应用于指定点。
		 * @param	out 用来设定输出结果的点。
		 * @return	返回out
		 */
		public function transformPoint(out:Point):Point {
			var nums:Float32Array = this._nums;
			return out.setTo(nums[A] * out.x + nums[C] * out.y + nums[TX], nums[B] * out.x + nums[D] * out.y + nums[TY]);
		}
		
		/**
		 * 将 Matrix 对象表示的几何转换应用于指定点，忽略tx、ty。
		 * @param	out 用来设定输出结果的点。
		 * @return	返回out
		 */
		public function transformPointN(out:Point):Point {
			var nums:Float32Array = this._nums;
			return out.setTo(nums[A] * out.x + nums[C] * out.y /*+ tx*/, nums[B] * out.x + nums[D] * out.y /*+ ty*/);
		}
		
		/**
		 * @private
		 * 将 Matrix 对象表示的几何转换应用于指定点。
		 * @param	data 点集合。
		 * @param	out 存储应用转化的点的列表。
		 * @return	返回out数组
		 */
		/* 删掉了，因为这个只能用于x,y,x,y...这种数组。且没人用
		public function transformPointArray(data:Array, out:Array):Array {
			var nums:Float32Array = this._nums;
			var len:int = data.length;
			for (var i:int; i < len; i += 2) {
				var x:Number = data[i], y:Number = data[i + 1];
				out[i] = nums[A] * x + nums[C] * y + nums[TX];
				out[i + 1] = nums[B] * x + nums[D] * y + nums[TY];
			}
			return out;
		}
		*/
		
		/**
		 * 获取 X 轴缩放值。
		 * @return  X 轴缩放值。
		 */
		public function getScaleX():Number {
			var nums:Float32Array = this._nums;
			return nums[B] === 0 ? a : Math.sqrt(nums[A] * nums[A] + nums[B] * nums[B]);
		}
		
		/**
		 * 获取 Y 轴缩放值。
		 * @return Y 轴缩放值。
		 */
		public function getScaleY():Number {
			var nums:Float32Array = this._nums;
			return nums[C] === 0 ? nums[D] : Math.sqrt(nums[C] * nums[C] + nums[D] * nums[D]);
		}
		
		/**
		 * 执行原始矩阵的逆转换。
		 * @return	返回矩阵对象本身
		 */
		public function invert():MatrixConch {
			var nums:Float32Array = this._nums;
			var a1:Number = nums[A];
			var b1:Number = nums[B];
			var c1:Number = nums[C];
			var d1:Number = nums[D];
			var tx1:Number = nums[TX];
			var n:Number = a1 * d1 - b1 * c1;
			nums[A] = d1 / n;
			nums[B] = -b1 / n;
			nums[C] = -c1 / n;
			nums[D] = a1 / n;
			nums[TX] = (c1 * ty - d1 * tx1) / n;
			nums[TY] = -(a1 * ty - b1 * tx1) / n;
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
		 * @return	返回矩阵对象本身
		 */
		public function setTo(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):MatrixConch {
			var nums:Float32Array = this._nums;
			nums[A] = a, nums[B] = b, nums[C] = c, nums[D] = d, nums[TX] = tx, nums[TY] = ty;
			return this;
		}
		
		/**
		 * 将指定矩阵与当前矩阵连接，从而将这两个矩阵的几何效果有效地结合在一起。
		 * @param	matrix 要连接到源矩阵的矩阵。
		 * @return	当前矩阵。
		 */
		public function concat(matrix:MatrixConch):MatrixConch {
			var nums:Float32Array = this._nums;
			var aNums:Float32Array = matrix._nums;
			var a:Number = nums[A];
			var c:Number = nums[C];
			var tx:Number = nums[TX];
			nums[A] = a * aNums[A] + nums[B] * aNums[C];
			nums[B] = a * aNums[B] + nums[B] * aNums[D];
			nums[C] = c * aNums[A] + nums[D] * aNums[C];
			nums[D] = c * aNums[B] + nums[D] * aNums[D];
			nums[TX] = tx * aNums[A] + nums[TY] * aNums[C] + aNums[TX];
			nums[TY] = tx * aNums[B] + nums[TY] * aNums[D] + aNums[TY];
			return this;
		}
		
		/**
		 * 将指定的两个矩阵相乘后的结果赋值给指定的输出对象。
		 * @param	m1 矩阵一。
		 * @param	m2 矩阵二。
		 * @param	out 输出对象。
		 * @return	结果输出对象 out。
		 */
		public static function mul(m1:MatrixConch, m2:MatrixConch, out:MatrixConch):MatrixConch {
			var m1Nums:Float32Array = m1._nums;
			var m2Nums:Float32Array = m2._nums;
			var oNums:Float32Array = out._nums;
			var aa:Number = m1Nums[A], ab:Number = m1Nums[B], ac:Number = m1Nums[C], ad:Number = m1Nums[D], atx:Number = m1Nums[TX], aty:Number = m1Nums[TY];
			var ba:Number = m2Nums[A], bb:Number = m2Nums[B], bc:Number = m2Nums[C], bd:Number = m2Nums[D], btx:Number = m2Nums[TX], bty:Number = m2Nums[TY];
			if (bb !== 0 || bc !== 0) {
				oNums[A] = aa * ba + ab * bc;
				oNums[B] = aa * bb + ab * bd;
				oNums[C] = ac * ba + ad * bc;
				oNums[D] = ac * bb + ad * bd;
				oNums[TX] = ba * atx + bc * aty + btx;
				oNums[TY] = bb * atx + bd * aty + bty;
			} else {
				oNums[A] = aa * ba;
				oNums[B] = ab * bd;
				oNums[C] = ac * ba;
				oNums[D] = ad * bd;
				oNums[TX] = ba * atx + btx;
				oNums[TY] = bd * aty + bty;
			}
			return out;
		}
		
		/**
		 * 将指定的两个矩阵相乘，结果赋值给指定的输出数组，长度为16。
		 * @param m1	矩阵一。
		 * @param m2	矩阵二。
		 * @param out	输出对象Array。
		 * @return 结果输出对象 out。
		 */
		public static function mul16(m1:MatrixConch, m2:MatrixConch, out:Array):Array {
			//TODO:是否用到
			var m1Nums:Float32Array = m1._nums;
			var m2Nums:Float32Array = m2._nums;
			var aa:Number = m1Nums[A], ab:Number = m1Nums[B], ac:Number = m1Nums[C], ad:Number = m1Nums[D], atx:Number = m1Nums[TX], aty:Number = m1Nums[TY];
			var ba:Number = m2Nums[A], bb:Number = m2Nums[B], bc:Number = m2Nums[C], bd:Number = m2Nums[D], btx:Number = m2Nums[TX], bty:Number = m2Nums[TY];
			if (bb !== 0 || bc !== 0) {
				out[0] = aa * ba + ab * bc;
				out[1] = aa * bb + ab * bd;
				out[4] = ac * ba + ad * bc;
				out[5] = ac * bb + ad * bd;
				out[12] = ba * atx + bc * aty + btx;
				out[13] = bb * atx + bd * aty + bty;
			} else {
				out[0] = aa * ba;
				out[1] = ab * bd;
				out[4] = ac * ba;
				out[5] = ad * bd;
				out[12] = ba * atx + btx;
				out[13] = bd * aty + bty;
			}
			return out;
		}
		
		/**
		 * @private
		 * 对矩阵应用缩放转换。反向相乘
		 * @param	x 用于沿 x 轴缩放对象的乘数。
		 * @param	y 用于沿 y 轴缩放对象的乘数。
		 */
		public function scaleEx(x:Number, y:Number):void {
			var nums:Float32Array = this._nums;
			var ba:Number = nums[A], bb:Number = nums[B], bc:Number = nums[C], bd:Number = nums[D];
			if (bb !== 0 || bc !== 0) {
				nums[A] = x * ba;
				nums[B] = x * bb;
				nums[C] = y * bc;
				nums[D] = y * bd;
			} else {
				nums[A] = x * ba;
				nums[B] = 0 * bd;
				nums[C] = 0 * ba;
				nums[D] = y * bd;
			}
			_bTransform = true;
		}
		
		/**
		 * @private
		 * 对 Matrix 对象应用旋转转换。反向相乘
		 * @param	angle 以弧度为单位的旋转角度。
		 */
		public function rotateEx(angle:Number):void {
			var nums:Float32Array = this._nums;
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			var ba:Number = nums[A], bb:Number = nums[B], bc:Number = nums[C], bd:Number = nums[D];
			if (bb !== 0 || bc !== 0) {
				nums[A] = cos * ba + sin * bc;
				nums[B] = cos * bb + sin * bd;
				nums[C] = -sin * ba + cos * bc;
				nums[D] = -sin * bb + cos * bd;
			} else {
				nums[A] = cos * ba;
				nums[B] = sin * bd;
				nums[C] = -sin * ba;
				nums[D] = cos * bd;
			}
			_bTransform = true;
		}
		
		/**
		 * 返回此 Matrix 对象的副本。
		 * @return 与原始实例具有完全相同的属性的新 Matrix 实例。
		 */
		public function clone():MatrixConch {
			var nums:Float32Array = _nums;
			var dec:MatrixConch = create();
			var dNums:Float32Array = dec._nums;
			dNums[A] = nums[A];
			dNums[B] = nums[B];
			dNums[C] = nums[C];
			dNums[D] = nums[D];
			dNums[TX] = nums[TX];
			dNums[TY] = nums[TY];
			dec._bTransform = _bTransform;
			return dec;
		}
		
		/**
		 * 将当前 Matrix 对象中的所有矩阵数据复制到指定的 Matrix 对象中。
		 * @param	dec 要复制当前矩阵数据的 Matrix 对象。
		 * @return	已复制当前矩阵数据的 Matrix 对象。
		 */
		public function copyTo(dec:MatrixConch):MatrixConch {
			var nums:Float32Array = _nums;
			var dNums:Float32Array = dec._nums;
			dNums[A] = nums[A];
			dNums[B] = nums[B];
			dNums[C] = nums[C];
			dNums[D] = nums[D];
			dNums[TX] = nums[TX];
			dNums[TY] = nums[TY];
			dec._bTransform = _bTransform;
			return dec;
		}
		
		/**
		 * 返回列出该 Matrix 对象属性的文本值。
		 * @return 一个字符串，它包含 Matrix 对象的属性值：a、b、c、d、tx 和 ty。
		 */
		public function toString():String {
			return a + "," + b + "," + c + "," + d + "," + tx + "," + ty;
		}
		
		/**
		 * 销毁此对象。
		 */
		public function destroy():void {
			recover();
		}
		
		/**
		 * 回收到对象池，方便复用
		 */
		public function recover():void {
			//Pool.recover("Matrix", identity());
			_pool.push(this);
		}
		
		/**
		 * 从对象池中创建一个 <code>Matrix</code> 对象。
		 * @return <code>Matrix</code> 对象。
		 */
		public static function create(nums:Float32Array = null):MatrixConch {
			var m:MatrixConch;
			if (_pool.length) {
				m = _pool.pop();
				nums && (m._nums = nums);
				m.identity();
				return m;
			} else return new MatrixConch(1, 0, 0, 1, 0, 0, nums);
		}
	}
}