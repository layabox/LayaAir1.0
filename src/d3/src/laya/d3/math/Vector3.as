package laya.d3.math {
	import laya.d3.core.IClone;
	import laya.renders.Render;
	/**
	 * <code>Vector3</code> 类用于创建三维向量。
	 */
	public class Vector3 implements IClone {
		/**@private	*/
		public static const _tempVector4:Vector4 = new Vector4();
		
		/**@private	*/
		public static const _ZERO:Vector3 =/*[STATIC SAFE]*/ new Vector3(0.0, 0.0, 0.0);
		/**@private	*/
		public static const _ONE:Vector3 =/*[STATIC SAFE]*/ new Vector3(1.0, 1.0, 1.0);
		/**@private	*/
		public static const _NegativeUnitX:Vector3 =/*[STATIC SAFE]*/ new Vector3(-1, 0, 0);
		/**@private	*/
		public static const _UnitX:Vector3 =/*[STATIC SAFE]*/ new Vector3(1, 0, 0);
		/**@private	*/
		public static const _UnitY:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 1, 0);
		/**@private	*/
		public static const _UnitZ:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 0, 1);
		/**@private	*/
		public static const _ForwardRH:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 0, -1);
		/**@private	*/
		public static const _ForwardLH:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 0, 1);
		/**@private	*/
		public static const _Up:Vector3 =/*[STATIC SAFE]*/ new Vector3(0, 1, 0);
		
		/**
		 * 两个三维向量距离的平方。
		 * @param	value1 向量1。
		 * @param	value2 向量2。
		 * @return	距离的平方。
		 */
		public static function distanceSquared(value1:Vector3, value2:Vector3):Number {
			var x:Number = value1.x - value2.x;
			var y:Number = value1.y - value2.y;
			var z:Number = value1.z - value2.z;
			return (x * x) + (y * y) + (z * z);
		}
		
		/**
		 * 两个三维向量距离。
		 * @param	value1 向量1。
		 * @param	value2 向量2。
		 * @return	距离。
		 */
		public static function distance(value1:Vector3, value2:Vector3):Number {
			var x:Number = value1.x - value2.x;
			var y:Number = value1.y - value2.y;
			var z:Number = value1.z - value2.z;
			return Math.sqrt((x * x) + (y * y) + (z * z));
		}
		
		/**
		 * 分别取两个三维向量x、y、z的最小值计算新的三维向量。
		 * @param	a。
		 * @param	b。
		 * @param	out。
		 */
		public static function min(a:Vector3, b:Vector3, out:Vector3):void {
			out.x = Math.min(a.x, b.x);
			out.y = Math.min(a.y, b.y);
			out.z = Math.min(a.z, b.z);
		}
		
		/**
		 * 分别取两个三维向量x、y、z的最大值计算新的三维向量。
		 * @param	a a三维向量。
		 * @param	b b三维向量。
		 * @param	out 结果三维向量。
		 */
		public static function max(a:Vector3, b:Vector3, out:Vector3):void {
			out.x = Math.max(a.x, b.x);
			out.y = Math.max(a.y, b.y);
			out.z = Math.max(a.z, b.z);
		}
		
		/**
		 * 根据四元数旋转三维向量。
		 * @param	source 源三维向量。
		 * @param	rotation 旋转四元数。
		 * @param	out 输出三维向量。
		 */
		public static function transformQuat(source:Vector3, rotation:Quaternion, out:Vector3):void {
			var x:Number = source.x, y:Number = source.y, z:Number = source.z, qx:Number = rotation.x, qy:Number = rotation.y, qz:Number = rotation.z, qw:Number = rotation.w,
			
			ix:Number = qw * x + qy * z - qz * y, iy:Number = qw * y + qz * x - qx * z, iz:Number = qw * z + qx * y - qy * x, iw:Number = -qx * x - qy * y - qz * z;
			
			out.x = ix * qw + iw * -qx + iy * -qz - iz * -qy;
			out.y = iy * qw + iw * -qy + iz * -qx - ix * -qz;
			out.z = iz * qw + iw * -qz + ix * -qy - iy * -qx;
		}
		
		/**
		 * 计算标量长度。
		 * @param	a 源三维向量。
		 * @return 标量长度。
		 */
		public static function scalarLength(a:Vector3):Number {
			var x:Number = a.x, y:Number = a.y, z:Number = a.z;
			return Math.sqrt(x * x + y * y + z * z);
		}
		
		/**
		 * 计算标量长度的平方。
		 * @param	a 源三维向量。
		 * @return 标量长度的平方。
		 */
		public static function scalarLengthSquared(a:Vector3):Number {
			var x:Number = a.x, y:Number = a.y, z:Number = a.z;
			return x * x + y * y + z * z;
		}
		
		/**
		 * 归一化三维向量。
		 * @param	s 源三维向量。
		 * @param	out 输出三维向量。
		 */
		public static function normalize(s:Vector3, out:Vector3):void {
			var x:Number = s.x, y:Number = s.y, z:Number = s.z;
			var len:Number = x * x + y * y + z * z;
			if (len > 0) {
				len = 1 / Math.sqrt(len);
				out.x = s.x * len;
				out.y = s.y * len;
				out.z = s.z * len;
			}
		}
		
		/**
		 * 计算两个三维向量的乘积。
		 * @param	a left三维向量。
		 * @param	b right三维向量。
		 * @param	out 输出三维向量。
		 */
		public static function multiply(a:Vector3, b:Vector3, out:Vector3):void {
			out.x = a.x * b.x;
			out.y = a.y * b.y;
			out.z = a.z * b.z;
		}
		
		/**
		 * 缩放三维向量。
		 * @param	a 源三维向量。
		 * @param	b 缩放值。
		 * @param	out 输出三维向量。
		 */
		public static function scale(a:Vector3, b:Number, out:Vector3):void {
			out.x = a.x * b;
			out.y = a.y * b;
			out.z = a.z * b;
		}
		
		/**
		 * 插值三维向量。
		 * @param	a left向量。
		 * @param	b right向量。
		 * @param	t 插值比例。
		 * @param	out 输出向量。
		 */
		public static function lerp(a:Vector3, b:Vector3, t:Number, out:Vector3):void {
			var ax:Number = a.x, ay:Number = a.y, az:Number = a.z;
			out.x = ax + t * (b.x - ax);
			out.y = ay + t * (b.y - ay);
			out.z = az + t * (b.z - az);
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
			result.x = intermediate.x;
			result.y = intermediate.y;
			result.z = intermediate.z;
		}
		
		/**
		 * 通过矩阵转换一个三维向量到另外一个四维向量。
		 * @param	vector 源三维向量。
		 * @param	transform  变换矩阵。
		 * @param	result 输出四维向量。
		 */
		public static function transformV3ToV4(vector:Vector3, transform:Matrix4x4, result:Vector4):void {
			var vectorX:Number = vector.x;
			var vectorY:Number = vector.y;
			var vectorZ:Number = vector.z;
			
			var transformElem:Float32Array = transform.elements;
			result.x = (vectorX * transformElem[0]) + (vectorY * transformElem[4]) + (vectorZ * transformElem[8]) + transformElem[12];
			result.y = (vectorX * transformElem[1]) + (vectorY * transformElem[5]) + (vectorZ * transformElem[9]) + transformElem[13];
			result.z = (vectorX * transformElem[2]) + (vectorY * transformElem[6]) + (vectorZ * transformElem[10]) + transformElem[14];
			result.w = (vectorX * transformElem[3]) + (vectorY * transformElem[7]) + (vectorZ * transformElem[11]) + transformElem[15];
		}
		
		/**
		 * 通过法线矩阵转换一个法线三维向量到另外一个三维向量。
		 * @param	normal 源法线三维向量。
		 * @param	transform  法线变换矩阵。
		 * @param	result 输出法线三维向量。
		 */
		public static function TransformNormal(normal:Vector3, transform:Matrix4x4, result:Vector3):void {
			var normalX:Number = normal.x;
			var normalY:Number = normal.y;
			var normalZ:Number = normal.z;
			
			var transformElem:Float32Array = transform.elements;
			result.x = (normalX * transformElem[0]) + (normalY * transformElem[4]) + (normalZ * transformElem[8]);
			result.y = (normalX * transformElem[1]) + (normalY * transformElem[5]) + (normalZ * transformElem[9]);
			result.z = (normalX * transformElem[2]) + (normalY * transformElem[6]) + (normalZ * transformElem[10]);
		}
		
		/**
		 * 通过矩阵转换一个三维向量到另外一个归一化的三维向量。
		 * @param	vector 源三维向量。
		 * @param	transform  变换矩阵。
		 * @param	result 输出三维向量。
		 */
		public static function transformCoordinate(coordinate:Vector3, transform:Matrix4x4, result:Vector3):void {
			var coordinateX:Number = coordinate.x;
			var coordinateY:Number = coordinate.y;
			var coordinateZ:Number = coordinate.z;
			
			var transformElem:Float32Array = transform.elements;
			var w:Number = ((coordinateX * transformElem[3]) + (coordinateY * transformElem[7]) + (coordinateZ * transformElem[11]) + transformElem[15]);
			result.x = (coordinateX * transformElem[0]) + (coordinateY * transformElem[4]) + (coordinateZ * transformElem[8]) + transformElem[12] / w;
			result.y = (coordinateX * transformElem[1]) + (coordinateY * transformElem[5]) + (coordinateZ * transformElem[9]) + transformElem[13] / w;
			result.z = (coordinateX * transformElem[2]) + (coordinateY * transformElem[6]) + (coordinateZ * transformElem[10]) + transformElem[14] / w;
		}
		
		/**
		 * 求一个指定范围的向量
		 * @param	value clamp向量
		 * @param	min  最小
		 * @param	max  最大
		 * @param   out 输出向量
		 */
		public static function Clamp(value:Vector3, min:Vector3, max:Vector3, out:Vector3):void {
			var x:Number = value.x;
			var y:Number = value.y;
			var z:Number = value.z;
			
			var mineX:Number = min.x;
			var mineY:Number = min.y;
			var mineZ:Number = min.z;
			
			var maxeX:Number = max.x;
			var maxeY:Number = max.y;
			var maxeZ:Number = max.z;
			
			x = (x > maxeX) ? maxeX : x;
			x = (x < mineX) ? mineX : x;
			
			y = (y > maxeY) ? maxeY : y;
			y = (y < mineY) ? mineY : y;
			
			z = (z > maxeZ) ? maxeZ : z;
			z = (z < mineZ) ? mineZ : z;
			
			out.x = x;
			out.y = y;
			out.z = z;
		}
		
		/**
		 * 求两个三维向量的和。
		 * @param	a left三维向量。
		 * @param	b right三维向量。
		 * @param	out 输出向量。
		 */
		public static function add(a:Vector3, b:Vector3, out:Vector3):void {
			out.x = a.x + b.x;
			out.y = a.y + b.y;
			out.z = a.z + b.z;
		}
		
		/**
		 * 求两个三维向量的差。
		 * @param	a  left三维向量。
		 * @param	b  right三维向量。
		 * @param	o out 输出向量。
		 */
		public static function subtract(a:Vector3, b:Vector3, o:Vector3):void {
			o.x = a.x - b.x;
			o.y = a.y - b.y;
			o.z = a.z - b.z;
		}
		
		/**
		 * 求两个三维向量的叉乘。
		 * @param	a left向量。
		 * @param	b right向量。
		 * @param	o 输出向量。
		 */
		public static function cross(a:Vector3, b:Vector3, o:Vector3):void {
			var ax:Number = a.x, ay:Number = a.y, az:Number = a.z, bx:Number = b.x, by:Number = b.y, bz:Number = b.z;
			o.x = ay * bz - az * by;
			o.y = az * bx - ax * bz;
			o.z = ax * by - ay * bx;
		}
		
		/**
		 * 求两个三维向量的点积。
		 * @param	a left向量。
		 * @param	b right向量。
		 * @return   点积。
		 */
		public static function dot(a:Vector3, b:Vector3):Number {
			return (a.x * b.x) + (a.y * b.y) + (a.z * b.z);
		}
		
		/**
		 * 判断两个三维向量是否相等。
		 * @param	a 三维向量。
		 * @param	b 三维向量。
		 * @return  是否相等。
		 */
		public static function equals(a:Vector3, b:Vector3):Boolean {
			return MathUtils3D.nearEqual(a.x, b.x) && MathUtils3D.nearEqual(a.y, b.y) && MathUtils3D.nearEqual(a.z, b.z);
		}
		
		/**X轴坐标*/
		public var x:Number;
		/**Y轴坐标*/
		public var y:Number;
		/**Z轴坐标*/
		public var z:Number;
		
		/**
		 * 创建一个 <code>Vector3</code> 实例。
		 * @param	x  X轴坐标。
		 * @param	y  Y轴坐标。
		 * @param	z  Z轴坐标。
		 */
		public function Vector3(x:Number = 0, y:Number = 0, z:Number = 0, nativeElements:Float32Array = null/*[NATIVE]*/) {
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		/**
		 * 设置xyz值。
		 * @param	x X值。
		 * @param	y Y值。
		 * @param	z Z值。
		 */
		public function setValue(x:Number, y:Number, z:Number):void {
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		/**
		 * 从Array数组拷贝值。
		 * @param  array 数组。
		 * @param  offset 数组偏移。
		 */
		public function fromArray(array:Array, offset:int = 0):void {
			x = array[offset + 0];
			y = array[offset + 1];
			z = array[offset + 2];
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destVector3:Vector3 = destObject as Vector3;
			destVector3.x = x;
			destVector3.y = y;
			destVector3.z = z;
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
			x = 0;
			y = 0;
			z = 0;
		}
	
		public function forNativeElement(nativeElements:Float32Array = null):void
		{			
			if (nativeElements)
			{
				__JS__("this.elements = nativeElements");
				__JS__("this.elements[0] = this.x");
				__JS__("this.elements[1] = this.y");
				__JS__("this.elements[2] = this.z");
			}
			else
			{
				__JS__("this.elements = new Float32Array([this.x,this.y,this.z])");
			}
			Vector2.rewriteNumProperty(this, "x", 0);
			Vector2.rewriteNumProperty(this, "y", 1);
			Vector2.rewriteNumProperty(this, "z", 2);
		}
	}
}