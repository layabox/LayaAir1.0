package laya.d3.math {
	
	import laya.d3.core.IClone;
	import laya.renders.Render;

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
		
		/**X轴坐标*/
		public var x:Number;
		/**Y轴坐标*/
		public var y:Number;
		/**Z轴坐标*/
		public var z:Number;
		/**W轴坐标*/
		public var w:Number;
		
		/**
		 * 创建一个 <code>Vector4</code> 实例。
		 * @param	x  X轴坐标。
		 * @param	y  Y轴坐标。
		 * @param	z  Z轴坐标。
		 * @param	w  W轴坐标。
		 */
		public function Vector4(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		
		/**
		 * 设置xyzw值。
		 * @param	x X值。
		 * @param	y Y值。
		 * @param	z Z值。
		 * @param	w W值。
		 */
		public function setValue(x:Number, y:Number, z:Number, w:Number):void {
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
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
			w = array[offset + 3];
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destVector4:Vector4 = destObject as Vector4;
			destVector4.x = x;
			destVector4.y = y;
			destVector4.z = z;
			destVector4.w = w;
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
			var ax:Number = a.x, ay:Number = a.y, az:Number = a.z, aw:Number = a.w;
			out.x = ax + t * (b.x - ax);
			out.y = ay + t * (b.y - ay);
			out.z = az + t * (b.z - az);
			out.w = aw + t * (b.w - aw);
		}
		
		/**
		 * 通过4x4矩阵把一个四维向量转换为另一个四维向量
		 * @param	vector4 带转换四维向量。
		 * @param	M4x4    4x4矩阵。
		 * @param	out     转换后四维向量。
		 */
		public static function transformByM4x4(vector4:Vector4, m4x4:Matrix4x4, out:Vector4):void {
			var vx:Number = vector4.x;
			var vy:Number = vector4.y;
			var vz:Number = vector4.z;
			var vw:Number = vector4.w;
			
			var me:Float32Array = m4x4.elements;
			
			out.x = vx * me[0] + vy * me[4] + vz * me[8] + vw * me[12];
			out.y = vx * me[1] + vy * me[5] + vz * me[9] + vw * me[13];
			out.z = vx * me[2] + vy * me[6] + vz * me[10] + vw * me[14];
			out.w = vx * me[3] + vy * me[7] + vz * me[11] + vw * me[15];
		}
		
		/**
		 * 判断两个四维向量是否相等。
		 * @param	a 四维向量。
		 * @param	b 四维向量。
		 * @return  是否相等。
		 */
		public static function equals(a:Vector4, b:Vector4):Boolean {
			return MathUtils3D.nearEqual(Math.abs(a.x), Math.abs(b.x)) && MathUtils3D.nearEqual(Math.abs(a.y), Math.abs(b.y)) && MathUtils3D.nearEqual(Math.abs(a.z), Math.abs(b.z)) && MathUtils3D.nearEqual(Math.abs(a.w), Math.abs(b.w));
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
			var len:Number = s.length();
			if (len > 0) {
				out.x = s.x * len;
				out.y = s.y * len;
				out.z = s.z * len;
				out.w = s.w * len;
			}
		}
		
		/**
		 * 求两个四维向量的和。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 输出向量。
		 */
		public static function add(a:Vector4, b:Vector4, out:Vector4):void {
			out.x = a.x + b.x;
			out.y = a.y + b.y;
			out.z = a.z + b.z;
			out.w = a.w + b.w;
		}
		
		/**
		 * 求两个四维向量的差。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 输出向量。
		 */
		public static function subtract(a:Vector4, b:Vector4, out:Vector4):void {
			out.x = a.x - b.x;
			out.y = a.y - b.y;
			out.z = a.z - b.z;
			out.w = a.w - b.w;
		}
		
		/**
		 * 计算两个四维向量的乘积。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 输出向量。
		 */
		public static function multiply(a:Vector4, b:Vector4, out:Vector4):void {
			out.x = a.x * b.x;
			out.y = a.y * b.y;
			out.z = a.z * b.z;
			out.w = a.w * b.w;
		}
		
		/**
		 * 缩放四维向量。
		 * @param	a   源四维向量。
		 * @param	b   缩放值。
		 * @param	out 输出四维向量。
		 */
		public static function scale(a:Vector4, b:Number, out:Vector4):void {
			out.x = a.x * b;
			out.y = a.y * b;
			out.z = a.z * b;
			out.w = a.w * b;
		}
		
		/**
		 * 求一个指定范围的四维向量
		 * @param	value clamp向量
		 * @param	min   最小
		 * @param	max   最大
		 * @param   out   输出向量
		 */
		public static function Clamp(value:Vector4, min:Vector4, max:Vector4, out:Vector4):void {
			var x:Number = value.x;
			var y:Number = value.y;
			var z:Number = value.z;
			var w:Number = value.w;
			
			var mineX:Number = min.x;
			var mineY:Number = min.y;
			var mineZ:Number = min.z;
			var mineW:Number = min.w;
			
			var maxeX:Number = max.x;
			var maxeY:Number = max.y;
			var maxeZ:Number = max.z;
			var maxeW:Number = max.w;
			
			x = (x > maxeX) ? maxeX : x;
			x = (x < mineX) ? mineX : x;
			
			y = (y > maxeY) ? maxeY : y;
			y = (y < mineY) ? mineY : y;
			
			z = (z > maxeZ) ? maxeZ : z;
			z = (z < mineZ) ? mineZ : z;
			
			w = (w > maxeW) ? maxeW : w;
			w = (w < mineW) ? mineW : w;
			
			out.x = x;
			out.y = y;
			out.z = z;
			out.w = w;
		}
		
		/**
		 * 两个四维向量距离的平方。
		 * @param	value1 向量1。
		 * @param	value2 向量2。
		 * @return	距离的平方。
		 */
		public static function distanceSquared(value1:Vector4, value2:Vector4):Number {
			var x:Number = value1.x - value2.x;
			var y:Number = value1.y - value2.y;
			var z:Number = value1.z - value2.z;
			var w:Number = value1.w - value2.w;
			
			return (x * x) + (y * y) + (z * z) + (w * w);
		}
		
		/**
		 * 两个四维向量距离。
		 * @param	value1 向量1。
		 * @param	value2 向量2。
		 * @return	距离。
		 */
		public static function distance(value1:Vector4, value2:Vector4):Number {
			var x:Number = value1.x - value2.x;
			var y:Number = value1.y - value2.y;
			var z:Number = value1.z - value2.z;
			var w:Number = value1.w - value2.w;
			
			return Math.sqrt((x * x) + (y * y) + (z * z) + (w * w));
		}
		
		/**
		 * 求两个四维向量的点积。
		 * @param	a 向量。
		 * @param	b 向量。
		 * @return  点积。
		 */
		public static function dot(a:Vector4, b:Vector4):Number {
			return (a.x * b.x) + (a.y * b.y) + (a.z * b.z) + (a.w * b.w);
		}
		
		/**
		 * 分别取两个四维向量x、y、z的最小值计算新的四维向量。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 结果三维向量。
		 */
		public static function min(a:Vector4, b:Vector4, out:Vector4):void {
			out.x = Math.min(a.x, b.x);
			out.y = Math.min(a.y, b.y);
			out.z = Math.min(a.z, b.z);
			out.w = Math.min(a.w, b.w);
		}
		
		/**
		 * 分别取两个四维向量x、y、z的最大值计算新的四维向量。
		 * @param	a   四维向量。
		 * @param	b   四维向量。
		 * @param	out 结果三维向量。
		 */
		public static function max(a:Vector4, b:Vector4, out:Vector4):void {
			out.x = Math.max(a.x, b.x);
			out.y = Math.max(a.y, b.y);
			out.z = Math.max(a.z, b.z);
			out.w = Math.max(a.w, b.w);
		}
		
		public function forNativeElement(nativeElements:Float32Array = null):void
		{		
			if (nativeElements)
			{
				__JS__("this.elements = nativeElements");
				__JS__("this.elements[0] = this.x");
				__JS__("this.elements[1] = this.y");
				__JS__("this.elements[2] = this.z");
				__JS__("this.elements[3] = this.w");
			}
			else
			{
				__JS__("this.elements = new Float32Array([this.x,this.y,this.z,this.w])");
			}
			Vector2.rewriteNumProperty(this, "x", 0);
			Vector2.rewriteNumProperty(this, "y", 1);
			Vector2.rewriteNumProperty(this, "z", 2);
			Vector2.rewriteNumProperty(this, "w", 3);
		}
	
	}
}