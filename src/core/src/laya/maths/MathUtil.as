package laya.maths {
	
	/**
	 * @private
	 * <code>MathUtil</code> 是一个数据处理工具类。
	 */
	public class MathUtil {
		
		public static function subtractVector3(l:Float32Array, r:Float32Array, o:Float32Array):void {
			o[0] = l[0] - r[0];
			o[1] = l[1] - r[1];
			o[2] = l[2] - r[2];
		}
		
		public static function lerp(left:Number, right:Number, amount:Number):Number {
			return left * (1 - amount) + right * amount;
		}
		
		public static function scaleVector3(f:Float32Array, b:Number, e:Float32Array):void {
			e[0] = f[0] * b;
			e[1] = f[1] * b;
			e[2] = f[2] * b;
		}
		
		public static function lerpVector3(l:Float32Array, r:Float32Array, t:Number, o:Float32Array):void {
			var ax:Number = l[0], ay:Number = l[1], az:Number = l[2];
			o[0] = ax + t * (r[0] - ax);
			o[1] = ay + t * (r[1] - ay);
			o[2] = az + t * (r[2] - az);
		}
		
		public static function lerpVector4(l:Float32Array, r:Float32Array, t:Number, o:Float32Array):void {
			var ax:Number = l[0], ay:Number = l[1], az:Number = l[2], aw:Number = l[3];
			o[0] = ax + t * (r[0] - ax);
			o[1] = ay + t * (r[1] - ay);
			o[2] = az + t * (r[2] - az);
			o[3] = aw + t * (r[3] - aw);
		}
		
		public static function slerpQuaternionArray(a:Float32Array, Offset1:int, b:Float32Array, Offset2:int, t:Number, out:Float32Array, Offset3:int):Float32Array {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var ax:Number = a[Offset1 + 0], ay:Number = a[Offset1 + 1], az:Number = a[Offset1 + 2], aw:Number = a[Offset1 + 3], bx:Number = b[Offset2 + 0], by:Number = b[Offset2 + 1], bz:Number = b[Offset2 + 2], bw:Number = b[Offset2 + 3];
			
			var omega:Number, cosom:Number, sinom:Number, scale0:Number, scale1:Number;
			
			// calc cosine 
			cosom = ax * bx + ay * by + az * bz + aw * bw;
			// adjust signs (if necessary) 
			if (cosom < 0.0) {
				cosom = -cosom;
				bx = -bx;
				by = -by;
				bz = -bz;
				bw = -bw;
			}
			// calculate coefficients 
			if ((1.0 - cosom) > 0.000001) {
				// standard case (slerp) 
				omega = Math.acos(cosom);
				sinom = Math.sin(omega);
				scale0 = Math.sin((1.0 - t) * omega) / sinom;
				scale1 = Math.sin(t * omega) / sinom;
			} else {
				// "from" and "to" quaternions are very close  
				//  ... so we can do a linear interpolation 
				scale0 = 1.0 - t;
				scale1 = t;
			}
			// calculate final values 
			out[Offset3 + 0] = scale0 * ax + scale1 * bx;
			out[Offset3 + 1] = scale0 * ay + scale1 * by;
			out[Offset3 + 2] = scale0 * az + scale1 * bz;
			out[Offset3 + 3] = scale0 * aw + scale1 * bw;
			
			return out;
		
		}
		
		/**
		 * 获取指定的两个点组成的线段的弧度值。
		 * @param	x0 点一的 X 轴坐标值。
		 * @param	y0 点一的 Y 轴坐标值。
		 * @param	x1 点二的 X 轴坐标值。
		 * @param	y1 点二的 Y 轴坐标值。
		 * @return 弧度值。
		 */
		public static function getRotation(x0:Number, y0:Number, x1:Number, y1:Number):Number {
			return Math.atan2(y1 - y0,x1 - x0) / Math.PI * 180;
		}
		
		/**
		 * 一个用来确定数组元素排序顺序的比较函数。
		 * @param	a 待比较数字。
		 * @param	b 待比较数字。
		 * @return 如果a等于b 则值为0；如果b>a则值为1；如果b<则值为-1。
		 */
		public static function sortBigFirst(a:Number, b:Number):Number {
			if (a == b)
				return 0;
			return b > a ? 1 : -1;
		}
		
		/**
		 * 一个用来确定数组元素排序顺序的比较函数。
		 * @param	a 待比较数字。
		 * @param	b 待比较数字。
		 * @return 如果a等于b 则值为0；如果b>a则值为-1；如果b<则值为1。 
		 */
		public static function sortSmallFirst(a:Number, b:Number):Number {
			if (a == b)
				return 0;
			return b > a ? -1 : 1;
		}
		
		/**
		 * 将指定的元素转为数字进行比较。
		 * @param	a 待比较元素。
		 * @param	b 待比较元素。
		 * @return b、a转化成数字的差值 (b-a)。
		 */
		public static function sortNumBigFirst(a:*, b:*):Number {
			return parseFloat(b) - parseFloat(a);
		}
		/**
		 * 将指定的元素转为数字进行比较。
		 * @param	a 待比较元素。
		 * @param	b 待比较元素。
		 * @return a、b转化成数字的差值 (a-b)。
		 */
		public static function sortNumSmallFirst(a:*, b:*):Number {
			return parseFloat(a) - parseFloat(b);
		}
		/**
		 * 返回根据对象指定的属性进行排序的比较函数。
		 * @param	key 排序要依据的元素属性名。
		 * @param	bigFirst 如果值为true，则按照由大到小的顺序进行排序，否则按照由小到大的顺序进行排序。
		 * @param	forceNum 如果值为true，则将排序的元素转为数字进行比较。
		 * @return 排序函数。
		 */
		public static function sortByKey(key:String, bigFirst:Boolean = false, forceNum:Boolean = true):Function {
			var _sortFun:Function;
			if (bigFirst) {
				_sortFun = forceNum ? sortNumBigFirst : sortBigFirst;
			} else {
				_sortFun = forceNum ? sortNumSmallFirst : sortSmallFirst;
			}
			return function(a:Object, b:Object):Number {
				return _sortFun(a[key], b[key]);
			}		
		}
	}

}