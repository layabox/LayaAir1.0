package laya.d3.math {
	
	import laya.d3.core.IClone;
	
	/**
	 * <code>Vector4</code> 类用于创建四维向量。
	 */
	public class Vector4 implements IClone {
		
		/**零向量，禁止修改*/
		public static var ZERO:Vector4 = new Vector4();
		
		/*一向量，禁止修改*/
		public static var ONE:Vector4 = new Vector4(1.0, 1.0, 1.0, 1.0);
		
		/*X单位向量，禁止修改*/
		public static var UnitX:Vector4 = new Vector4(1.0, 0.0, 0.0, 0.0);
		
		/*Y单位向量，禁止修改*/
		public static var UnitY:Vector4 = new Vector4(0.0, 1.0, 0.0, 0.0);
		
		/*Z单位向量，禁止修改*/
		public static var UnitZ:Vector4 = new Vector4(0.0, 0.0, 1.0, 0.0);
		
		/*W单位向量，禁止修改*/
		public static var UnitW:Vector4 = new Vector4(0.0, 0.0, 0.0, 1.0);
		
		/**四维向量元素数组*/
		public var elements:* = new Float32Array(4);
		
		/**
		 * 获取X轴坐标。
		 * @return  X轴坐标。
		 */
		public function get x():Number {
			return this.elements[0];
		}
		
		/**
		 * 设置X轴坐标。
		 * @param value X轴坐标。
		 */
		public function set x(value:Number):void {
			this.elements[0] = value;
		}
		
		/**
		 * 获取Y轴坐标。
		 * @return	Y轴坐标。
		 */
		public function get y():Number {
			return this.elements[1];
		}
		
		/**
		 * 设置Y轴坐标。
		 * @param	value  Y轴坐标。
		 */
		public function set y(value:Number):void {
			this.elements[1] = value;
		}
		
		/**
		 * 获取Z轴坐标。
		 * @return	 Z轴坐标。
		 */
		public function get z():Number {
			return this.elements[2];
		}
		
		/**
		 * 设置Z轴坐标。
		 * @param	value  Z轴坐标。
		 */
		public function set z(value:Number):void {
			this.elements[2] = value;
		}
		
		/**
		 * 获取W轴坐标。
		 * @return	W轴坐标。
		 */
		public function get w():Number {
			return this.elements[3];
		}
		
		/**
		 * 设置W轴坐标。
		 * @param value	W轴坐标。
		 */
		public function set w(value:Number):void {
			this.elements[3] = value;
		}
		
		/**
		 * 创建一个 <code>Vector4</code> 实例。
		 * @param	x  X轴坐标。
		 * @param	y  Y轴坐标。
		 * @param	z  Z轴坐标。
		 * @param	w  W轴坐标。
		 */
		public function Vector4(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0) {
			var v:Float32Array = elements;
			v[0] = x;
			v[1] = y;
			v[2] = z;
			v[3] = w;
		}
		
		/**
		 * 从Array数组拷贝值。
		 * @param  array 数组。
		 * @param  offset 数组偏移。
		 */
		public function fromArray(array:Array, offset:int = 0):void {
			elements[0] = array[offset + 0];
			elements[1] = array[offset + 1];
			elements[2] = array[offset + 2];
			elements[3] = array[offset + 3];
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destVector4:Vector4 = destObject as Vector4;
			var destE:Float32Array = destVector4.elements;
			var s:Float32Array = this.elements;
			destE[0] = s[0];
			destE[1] = s[1];
			destE[2] = s[2];
			destE[3] = s[3];
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destVector4:Vector4 = __JS__("new this.constructor()");
			cloneTo(destVector4);
			return destVector4;
		}
		
		/**
		 * 插值四维向量。
		 * @param	a left向量。
		 * @param	b right向量。
		 * @param	t 插值比例。
		 * @param	out 输出向量。
		 */
		public static function lerp(a:Vector4, b:Vector4, t:Number, out:Vector4):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			var g:Float32Array = b.elements;
			
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2], aw:Number = f[3];
			e[0] = ax + t * (g[0] - ax);
			e[1] = ay + t * (g[1] - ay);
			e[2] = az + t * (g[2] - az);
			e[3] = aw + t * (g[3] - aw);
		}
		
		/**
		 * 通过4x4矩阵把一个四维向量转换为另一个四维向量
		 * @param	vector4 带转换四维向量。
		 * @param	M4x4    4x4矩阵。
		 * @param	out     转换后四维向量。
		 */
		public static function transformByM4x4(vector4:Vector4, m4x4:Matrix4x4, out:Vector4):void {
			
			var ve:Float32Array = vector4.elements;
			var vx:Number = ve[0];
			var vy:Number = ve[1];
			var vz:Number = ve[2];
			var vw:Number = ve[3];
			
			var me:Float32Array = m4x4.elements;
			var oe:Float32Array = out.elements;
			
			oe[0] = vx * me[0] + vy * me[4] + vz * me[8] + vw * me[12];
			oe[1] = vx * me[1] + vy * me[5] + vz * me[9] + vw * me[13];
			oe[2] = vx * me[2] + vy * me[6] + vz * me[10] + vw * me[14];
			oe[3] = vx * me[3] + vy * me[7] + vz * me[11] + vw * me[15];
		}
		
		/**
		 * 判断两个四维向量是否相等。
		 * @param	a 四维向量。
		 * @param	b 四维向量。
		 * @return  是否相等。
		 */
		public static function equals(a:Vector4, b:Vector4):Boolean {
			
			var ae:Float32Array = a.elements;
			var be:Float32Array = b.elements;
			return MathUtils3D.nearEqual(Math.abs(ae[0]), Math.abs(be[0])) && MathUtils3D.nearEqual(Math.abs(ae[1]), Math.abs(be[1])) && MathUtils3D.nearEqual(Math.abs(ae[2]), Math.abs(be[2])) && MathUtils3D.nearEqual(Math.abs(ae[3]), Math.abs(be[3]));
		}
		
		/**
		 * 求四维向量的长度。
		 * @return  长度。
		 */
		public function length():Number {
			
			return Math.sqrt(x * x + y * y + z * z + w * w);
		}
		
		/**
		 * 求四维向量长度的平方。
		 * @return  长度的平方。
		 */
		public function lengthSquared():Number {
			
			return x * x + y * y + z * z + w * w;
		}
		
		/**
		 * 归一化四维向量。
		 * @param	s   源四维向量。
		 * @param	out 输出四维向量。
		 */
		public static function normalize(s:Vector4, out:Vector4):void {
			
			var se:Float32Array = s.elements;
			var oe:Float32Array = out.elements;
			var len:Number = s.length();
			if (len > 0) {
				oe[0] = se[0] * len;
				oe[1] = se[1] * len;
				oe[2] = se[2] * len;
				oe[3] = se[3] * len;
			}
		}
		
		/**
		 * 求两个四维向量的和。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 输出向量。
		 */
		public static function add(a:Vector4, b:Vector4, out:Vector4):void {
			
			var oe:Float32Array = out.elements;
			var ae:Float32Array = a.elements;
			var be:Float32Array = b.elements;
			oe[0] = ae[0] + be[0];
			oe[1] = ae[1] + be[1];
			oe[2] = ae[2] + be[2];
			oe[3] = ae[3] + be[3];
		}
		
		/**
		 * 求两个四维向量的差。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 输出向量。
		 */
		public static function subtract(a:Vector4, b:Vector4, out:Vector4):void {
			
			var oe:Float32Array = out.elements;
			var ae:Float32Array = a.elements;
			var be:Float32Array = b.elements;
			oe[0] = ae[0] - be[0];
			oe[1] = ae[1] - be[1];
			oe[2] = ae[2] - be[2];
			oe[3] = ae[3] - be[3];
		}
		
		/**
		 * 计算两个四维向量的乘积。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 输出向量。
		 */
		public static function multiply(a:Vector4, b:Vector4, out:Vector4):void {
			
			var oe:Float32Array = out.elements;
			var ae:Float32Array = a.elements;
			var be:Float32Array = b.elements;
			oe[0] = ae[0] * be[0];
			oe[1] = ae[1] * be[1];
			oe[2] = ae[2] * be[2];
			oe[3] = ae[3] * be[3];
		}
		
		/**
		 * 缩放四维向量。
		 * @param	a   源四维向量。
		 * @param	b   缩放值。
		 * @param	out 输出四维向量。
		 */
		public static function scale(a:Vector4, b:Number, out:Vector4):void {
			
			var oe:Float32Array = out.elements;
			var ae:Float32Array = a.elements;
			oe[0] = ae[0] * b;
			oe[1] = ae[1] * b;
			oe[2] = ae[2] * b;
			oe[3] = ae[3] * b;
		}
		
		/**
		 * 求一个指定范围的四维向量
		 * @param	value clamp向量
		 * @param	min   最小
		 * @param	max   最大
		 * @param   out   输出向量
		 */
		public static function Clamp(value:Vector4, min:Vector4, max:Vector4, out:Vector4):void {
			
			var valuee:Float32Array = value.elements;
			var x:Number = valuee[0];
			var y:Number = valuee[1];
			var z:Number = valuee[2];
			var w:Number = valuee[3];
			
			var mine:Float32Array = min.elements;
			var mineX:Number = mine[0];
			var mineY:Number = mine[1];
			var mineZ:Number = mine[2];
			var mineW:Number = mine[3];
			
			var maxe:Float32Array = max.elements;
			var maxeX:Number = maxe[0];
			var maxeY:Number = maxe[1];
			var maxeZ:Number = maxe[2];
			var maxeW:Number = maxe[3];
			
			var oute:Float32Array = out.elements;
			
			x = (x > maxeX) ? maxeX : x;
			x = (x < mineX) ? mineX : x;
			
			y = (y > maxeY) ? maxeY : y;
			y = (y < mineY) ? mineY : y;
			
			z = (z > maxeZ) ? maxeZ : z;
			z = (z < mineZ) ? mineZ : z;
			
			w = (w > maxeW) ? maxeW : w;
			w = (w < mineW) ? mineW : w;
			
			oute[0] = x;
			oute[1] = y;
			oute[2] = z;
			oute[3] = w;
		}
		
		/**
		 * 两个四维向量距离的平方。
		 * @param	value1 向量1。
		 * @param	value2 向量2。
		 * @return	距离的平方。
		 */
		public static function distanceSquared(value1:Vector4, value2:Vector4):Number {
			
			var value1e:Float32Array = value1.elements;
			var value2e:Float32Array = value2.elements;
			
			var x:Number = value1e[0] - value2e[0];
			var y:Number = value1e[1] - value2e[1];
			var z:Number = value1e[2] - value2e[2];
			var w:Number = value1e[3] - value2e[3];
			
			return (x * x) + (y * y) + (z * z) + (w * w);
		}
		
		/**
		 * 两个四维向量距离。
		 * @param	value1 向量1。
		 * @param	value2 向量2。
		 * @return	距离。
		 */
		public static function distance(value1:Vector4, value2:Vector4):Number {
			
			var value1e:Float32Array = value1.elements;
			var value2e:Float32Array = value2.elements;
			
			var x:Number = value1e[0] - value2e[0];
			var y:Number = value1e[1] - value2e[1];
			var z:Number = value1e[2] - value2e[2];
			var w:Number = value1e[3] - value2e[3];
			
			return Math.sqrt((x * x) + (y * y) + (z * z) + (w * w));
		}
		
		/**
		 * 求两个四维向量的点积。
		 * @param	a 向量。
		 * @param	b 向量。
		 * @return  点积。
		 */
		public static function dot(a:Vector4, b:Vector4):Number {
			
			var ae:Float32Array = a.elements;
			var be:Float32Array = b.elements;
			
			var r:Number = (ae[0] * be[0]) + (ae[1] * be[1]) + (ae[2] * be[2]) + (ae[3] * be[3]);
			return r;
		}
		
		/**
		 * 分别取两个四维向量x、y、z的最小值计算新的四维向量。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 结果三维向量。
		 */
		public static function min(a:Vector4, b:Vector4, out:Vector4):void {
			
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			var g:Float32Array = b.elements
			
			e[0] = Math.min(f[0], g[0]);
			e[1] = Math.min(f[1], g[1]);
			e[2] = Math.min(f[2], g[2]);
			e[3] = Math.min(f[3], g[3]);
		}
		
		/**
		 * 分别取两个四维向量x、y、z的最大值计算新的四维向量。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 结果三维向量。
		 */
		public static function max(a:Vector4, b:Vector4, out:Vector4):void {
			
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			var g:Float32Array = b.elements
			
			e[0] = Math.max(f[0], g[0]);
			e[1] = Math.max(f[1], g[1]);
			e[2] = Math.max(f[2], g[2]);
			e[3] = Math.max(f[3], g[3]);
		}
	
	}
}