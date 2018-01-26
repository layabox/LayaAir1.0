package laya.d3.math {
	import laya.d3.core.IClone;
	
	/**
	 * <code>Vector3</code> 类用于创建三维向量。
	 */
	public class Vector3 implements IClone {
		/**@private	*/
		public static const _tempVector4:Vector4 = new Vector4();
		
		/**零向量，禁止修改*/
		public static const ZERO:Vector3 =/*[STATIC SAFE]*/ new Vector3(0.0, 0.0, 0.0);
		/**一向量，禁止修改*/
		public static const ONE:Vector3 =/*[STATIC SAFE]*/ new Vector3(1.0, 1.0, 1.0);
		/**X轴单位向量，禁止修改*/
		public static const NegativeUnitX:Vector3 =/*[STATIC SAFE]*/ new Vector3(-1, 0, 0);
		/**X轴单位向量，禁止修改*/
		public static const UnitX:Vector3 =/*[STATIC SAFE]*/ new Vector3(1, 0, 0);
		/**Y轴单位向量，禁止修改*/
		public static const UnitY:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 1, 0);
		/**Z轴单位向量，禁止修改*/
		public static const UnitZ:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 0, 1);
		/**右手坐标系统前向量，禁止修改*/
		public static const ForwardRH:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 0, -1);
		/**左手坐标系统前向量,禁止修改*/
		public static const ForwardLH:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 0, 1);
		/**上向量,禁止修改*/
		public static const Up:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 1, 0);
		/**无效矩阵,禁止修改*/
		public static const NAN:Vector3 =/*[STATIC SAFE]*/ new Vector3(NaN, NaN, NaN);
		
		/**
		 * 两个三维向量距离的平方。
		 * @param	value1 向量1。
		 * @param	value2 向量2。
		 * @return	距离的平方。
		 */
		public static function distanceSquared(value1:Vector3, value2:Vector3):Number {
			var value1e:Float32Array = value1.elements;
			var value2e:Float32Array = value2.elements;
			var x:Number = value1e[0] - value2e[0];
			var y:Number = value1e[1] - value2e[1];
			var z:Number = value1e[2] - value2e[2];
			return (x * x) + (y * y) + (z * z);
		}
		
		/**
		 * 两个三维向量距离。
		 * @param	value1 向量1。
		 * @param	value2 向量2。
		 * @return	距离。
		 */
		public static function distance(value1:Vector3, value2:Vector3):Number {
			var value1e:Float32Array = value1.elements;
			var value2e:Float32Array = value2.elements;
			var x:Number = value1e[0] - value2e[0];
			var y:Number = value1e[1] - value2e[1];
			var z:Number = value1e[2] - value2e[2];
			return Math.sqrt((x * x) + (y * y) + (z * z));
		}
		
		/**
		 * 分别取两个三维向量x、y、z的最小值计算新的三维向量。
		 * @param	a。
		 * @param	b。
		 * @param	out。
		 */
		public static function min(a:Vector3, b:Vector3, out:Vector3):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			var g:Float32Array = b.elements
			e[0] = Math.min(f[0], g[0]);
			e[1] = Math.min(f[1], g[1]);
			e[2] = Math.min(f[2], g[2]);
		}
		
		/**
		 * 分别取两个三维向量x、y、z的最大值计算新的三维向量。
		 * @param	a a三维向量。
		 * @param	b b三维向量。
		 * @param	out 结果三维向量。
		 */
		public static function max(a:Vector3, b:Vector3, out:Vector3):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			var g:Float32Array = b.elements
			e[0] = Math.max(f[0], g[0]);
			e[1] = Math.max(f[1], g[1]);
			e[2] = Math.max(f[2], g[2]);
		}
		
		/**
		 * 根据四元数旋转三维向量。
		 * @param	source 源三维向量。
		 * @param	rotation 旋转四元数。
		 * @param	out 输出三维向量。
		 */
		public static function transformQuat(source:Vector3, rotation:Quaternion, out:Vector3):void {
			var destination:Float32Array = out.elements;
			var se:Float32Array = source.elements;
			var re:Float32Array = rotation.elements;
			
			var x:Number = se[0], y:Number = se[1], z:Number = se[2], qx:Number = re[0], qy:Number = re[1], qz:Number = re[2], qw:Number = re[3],
			
			ix:Number = qw * x + qy * z - qz * y, iy:Number = qw * y + qz * x - qx * z, iz:Number = qw * z + qx * y - qy * x, iw:Number = -qx * x - qy * y - qz * z;
			
			destination[0] = ix * qw + iw * -qx + iy * -qz - iz * -qy;
			destination[1] = iy * qw + iw * -qy + iz * -qx - ix * -qz;
			destination[2] = iz * qw + iw * -qz + ix * -qy - iy * -qx;
		}
		
		/**
		 * 计算标量长度。
		 * @param	a 源三维向量。
		 * @return 标量长度。
		 */
		public static function scalarLength(a:Vector3):Number {
			var f:Float32Array = a.elements;
			var x:Number = f[0], y:Number = f[1], z:Number = f[2];
			return Math.sqrt(x * x + y * y + z * z);
		}
		
		/**
		 * 计算标量长度。
		 * @param	a 源三维向量。
		 * @return 标量长度的平方。
		 */
		public static function scalarLengthSquared(a:Vector3):Number {
			var f:Float32Array = a.elements;
			var x:Number = f[0], y:Number = f[1], z:Number = f[2];
			return x * x + y * y + z * z;
		}
		
		/**
		 * 归一化三维向量。
		 * @param	s 源三维向量。
		 * @param	out 输出三维向量。
		 */
		public static function normalize(s:Vector3, out:Vector3):void {
			var se:Float32Array = s.elements;
			var oe:Float32Array = out.elements;
			var x:Number = se[0], y:Number = se[1], z:Number = se[2];
			var len:Number = x * x + y * y + z * z;
			if (len > 0) {
				len = 1 / Math.sqrt(len);
				oe[0] = se[0] * len;
				oe[1] = se[1] * len;
				oe[2] = se[2] * len;
			}
		}
		
		/**
		 * 计算两个三维向量的乘积。
		 * @param	a left三维向量。
		 * @param	b right三维向量。
		 * @param	out 输出三维向量。
		 */
		public static function multiply(a:Vector3, b:Vector3, out:Vector3):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			var g:Float32Array = b.elements
			e[0] = f[0] * g[0];
			e[1] = f[1] * g[1];
			e[2] = f[2] * g[2];
		}
		
		/**
		 * 缩放三维向量。
		 * @param	a 源三维向量。
		 * @param	b 缩放值。
		 * @param	out 输出三维向量。
		 */
		public static function scale(a:Vector3, b:Number, out:Vector3):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			e[0] = f[0] * b;
			e[1] = f[1] * b;
			e[2] = f[2] * b;
		}
		
		/**
		 * 插值三维向量。
		 * @param	a left向量。
		 * @param	b right向量。
		 * @param	t 插值比例。
		 * @param	out 输出向量。
		 */
		public static function lerp(a:Vector3, b:Vector3, t:Number, out:Vector3):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			var g:Float32Array = b.elements;
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2];
			e[0] = ax + t * (g[0] - ax);
			e[1] = ay + t * (g[1] - ay);
			e[2] = az + t * (g[2] - az);
		}
		
		/**
		 * 通过矩阵转换一个三维向量到另外一个三维向量。
		 * @param	vector 源三维向量。
		 * @param	transform  变换矩阵。
		 * @param	result 输出三维向量。
		 */
		public static function transformV3ToV3(vector:Vector3, transform:Matrix4x4, result:Vector3):void {
			var intermediate:Vector4 = _tempVector4;
			transformV3ToV4(vector, transform, intermediate);
			var intermediateElem:Float32Array = intermediate.elements;
			var resultElem:Float32Array = result.elements;
			resultElem[0] = intermediateElem[0];
			resultElem[1] = intermediateElem[1];
			resultElem[2] = intermediateElem[2];
		}
		
		/**
		 * 通过矩阵转换一个三维向量到另外一个四维向量。
		 * @param	vector 源三维向量。
		 * @param	transform  变换矩阵。
		 * @param	result 输出四维向量。
		 */
		public static function transformV3ToV4(vector:Vector3, transform:Matrix4x4, result:Vector4):void {
			var vectorElem:Float32Array = vector.elements;
			var vectorX:Number = vectorElem[0];
			var vectorY:Number = vectorElem[1];
			var vectorZ:Number = vectorElem[2];
			
			var transformElem:Float32Array = transform.elements;
			var resultElem:Float32Array = result.elements;
			resultElem[0] = (vectorX * transformElem[0]) + (vectorY * transformElem[4]) + (vectorZ * transformElem[8]) + transformElem[12];
			resultElem[1] = (vectorX * transformElem[1]) + (vectorY * transformElem[5]) + (vectorZ * transformElem[9]) + transformElem[13];
			resultElem[2] = (vectorX * transformElem[2]) + (vectorY * transformElem[6]) + (vectorZ * transformElem[10]) + transformElem[14];
			resultElem[3] = (vectorX * transformElem[3]) + (vectorY * transformElem[7]) + (vectorZ * transformElem[11]) + transformElem[15];
		}
		
		/**
		 * 通过法线矩阵转换一个法线三维向量到另外一个三维向量。
		 * @param	normal 源法线三维向量。
		 * @param	transform  法线变换矩阵。
		 * @param	result 输出法线三维向量。
		 */
		public static function TransformNormal(normal:Vector3, transform:Matrix4x4, result:Vector3):void {
			var normalElem:Float32Array = normal.elements;
			var normalX:Number = normalElem[0];
			var normalY:Number = normalElem[1];
			var normalZ:Number = normalElem[2];
			
			var transformElem:Float32Array = transform.elements;
			var resultElem:Float32Array = result.elements;
			resultElem[0] = (normalX * transformElem[0]) + (normalY * transformElem[4]) + (normalZ * transformElem[8]);
			resultElem[1] = (normalX * transformElem[1]) + (normalY * transformElem[5]) + (normalZ * transformElem[9]);
			resultElem[2] = (normalX * transformElem[2]) + (normalY * transformElem[6]) + (normalZ * transformElem[10]);
		}
		
		/**
		 * 通过矩阵转换一个三维向量到另外一个归一化的三维向量。
		 * @param	vector 源三维向量。
		 * @param	transform  变换矩阵。
		 * @param	result 输出三维向量。
		 */
		public static function transformCoordinate(coordinate:Vector3, transform:Matrix4x4, result:Vector3):void {
			var vectorElem:Float32Array = _tempVector4.elements;
			
			var coordinateElem:Float32Array = coordinate.elements;
			var coordinateX:Number = coordinateElem[0];
			var coordinateY:Number = coordinateElem[1];
			var coordinateZ:Number = coordinateElem[2];
			
			var transformElem:Float32Array = transform.elements;
			
			vectorElem[0] = (coordinateX * transformElem[0]) + (coordinateY * transformElem[4]) + (coordinateZ * transformElem[8]) + transformElem[12];
			vectorElem[1] = (coordinateX * transformElem[1]) + (coordinateY * transformElem[5]) + (coordinateZ * transformElem[9]) + transformElem[13];
			vectorElem[2] = (coordinateX * transformElem[2]) + (coordinateY * transformElem[6]) + (coordinateZ * transformElem[10]) + transformElem[14];
			vectorElem[3] = 1.0 / ((coordinateX * transformElem[3]) + (coordinateY * transformElem[7]) + (coordinateZ * transformElem[11]) + transformElem[15]);
			
			var resultElem:Float32Array = result.elements;
			resultElem[0] = vectorElem[0] * vectorElem[3];
			resultElem[1] = vectorElem[1] * vectorElem[3];
			resultElem[2] = vectorElem[2] * vectorElem[3];
		}
		
		/**
		 * 求一个指定范围的向量
		 * @param	value clamp向量
		 * @param	min  最小
		 * @param	max  最大
		 * @param   out 输出向量
		 */
		public static function Clamp(value:Vector3, min:Vector3, max:Vector3, out:Vector3):void {
			
			var valuee:Float32Array = value.elements;
			var x:Number = valuee[0];
			var y:Number = valuee[1];
			var z:Number = valuee[2];
			
			var mine:Float32Array = min.elements;
			var mineX:Number = mine[0];
			var mineY:Number = mine[1];
			var mineZ:Number = mine[2];
			
			var maxe:Float32Array = max.elements;
			var maxeX:Number = maxe[0];
			var maxeY:Number = maxe[1];
			var maxeZ:Number = maxe[2];
			
			var oute:Float32Array = out.elements;
			
			x = (x > maxeX) ? maxeX : x;
			x = (x < mineX) ? mineX : x;
			
			y = (y > maxeY) ? maxeY : y;
			y = (y < mineY) ? mineY : y;
			
			z = (z > maxeZ) ? maxeZ : z;
			z = (z < mineZ) ? mineZ : z;
			
			oute[0] = x;
			oute[1] = y;
			oute[2] = z;
		}
		
		/**
		 * 求两个三维向量的和。
		 * @param	a left三维向量。
		 * @param	b right三维向量。
		 * @param	out 输出向量。
		 */
		public static function add(a:Vector3, b:Vector3, out:Vector3):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = a.elements;
			var g:Float32Array = b.elements
			e[0] = f[0] + g[0];
			e[1] = f[1] + g[1];
			e[2] = f[2] + g[2];
		}
		
		/**
		 * 求两个三维向量的差。
		 * @param	a  left三维向量。
		 * @param	b  right三维向量。
		 * @param	o out 输出向量。
		 */
		public static function subtract(a:Vector3, b:Vector3, o:Vector3):void {
			var oe:Float32Array = o.elements;
			var ae:Float32Array = a.elements;
			var be:Float32Array = b.elements;
			oe[0] = ae[0] - be[0];
			oe[1] = ae[1] - be[1];
			oe[2] = ae[2] - be[2];
		}
		
		/**
		 * 求两个三维向量的叉乘。
		 * @param	a left向量。
		 * @param	b right向量。
		 * @param	o 输出向量。
		 */
		public static function cross(a:Vector3, b:Vector3, o:Vector3):void {
			var ae:Float32Array = a.elements;
			var be:Float32Array = b.elements;
			var oe:Float32Array = o.elements;
			var ax:Number = ae[0], ay:Number = ae[1], az:Number = ae[2], bx:Number = be[0], by:Number = be[1], bz:Number = be[2];
			oe[0] = ay * bz - az * by;
			oe[1] = az * bx - ax * bz;
			oe[2] = ax * by - ay * bx;
		}
		
		/**
		 * 求两个三维向量的点积。
		 * @param	a left向量。
		 * @param	b right向量。
		 * @return   点积。
		 */
		public static function dot(a:Vector3, b:Vector3):Number {
			var ae:Float32Array = a.elements;
			var be:Float32Array = b.elements;
			var r:Number = (ae[0] * be[0]) + (ae[1] * be[1]) + (ae[2] * be[2]);
			return r;
		}
		
		/**
		 * 判断两个三维向量是否相等。
		 * @param	a 三维向量。
		 * @param	b 三维向量。
		 * @return  是否相等。
		 */
		public static function equals(a:Vector3, b:Vector3):Boolean {
			var ae:Float32Array = a.elements;
			var be:Float32Array = b.elements;
			return MathUtils3D.nearEqual(Math.abs(ae[0]), Math.abs(be[0])) && MathUtils3D.nearEqual(Math.abs(ae[1]), Math.abs(be[1])) && MathUtils3D.nearEqual(Math.abs(ae[2]), Math.abs(be[2]));
		}
		
		/**三维向量元素数组*/
		public var elements:Float32Array = new Float32Array(3);
		
		/**
		 * 获取X轴坐标。
		 * @return	X轴坐标。
		 */
		public function get x():Number {
			return this.elements[0];
		}
		
		/**
		 * 设置X轴坐标。
		 * @param	value  X轴坐标。
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
		 * @return	Z轴坐标。
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
		 * 创建一个 <code>Vector3</code> 实例。
		 * @param	x  X轴坐标。
		 * @param	y  Y轴坐标。
		 * @param	z  Z轴坐标。
		 */
		public function Vector3(x:Number = 0, y:Number = 0, z:Number = 0) {
			var v:* = elements;
			v[0] = x;
			v[1] = y;
			v[2] = z;
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
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destVector3:Vector3 = destObject as Vector3;
			var destE:Float32Array = destVector3.elements;
			var s:Float32Array = this.elements;
			destE[0] = s[0];
			destE[1] = s[1];
			destE[2] = s[2];
		
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destVector3:Vector3 = __JS__("new this.constructor()");
			cloneTo(destVector3);
			return destVector3;
		}
		
		public function toDefault():void {
			elements[0] = 0;
			elements[1] = 0;
			elements[2] = 0;
		}
	
	}
}