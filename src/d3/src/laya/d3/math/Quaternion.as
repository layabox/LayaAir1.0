package laya.d3.math {
	import laya.d3.core.IClone;
	import laya.renders.Render;
	/**
	 * <code>Quaternion</code> 类用于创建四元数。
	 */
	public class Quaternion implements IClone {
		/**@private */
		public static var TEMPVector30:Vector3 = new Vector3();
		/**@private */
		public static var TEMPVector31:Vector3 = new Vector3();
		/**@private */
		public static var TEMPVector32:Vector3 = new Vector3();
		/**@private */
		public static var TEMPVector33:Vector3 = new Vector3();
		/**@private */
		public static var TEMPMatrix0:Matrix4x4 = new Matrix4x4();
		/**@private */
		public static var TEMPMatrix1:Matrix4x4 = new Matrix4x4();
		/**@private */
		public static var _tempMatrix3x3:Matrix3x3 = new Matrix3x3();
		
		/**默认矩阵,禁止修改*/
		public static const DEFAULT:Quaternion =/*[STATIC SAFE]*/ new Quaternion();
		/**无效矩阵,禁止修改*/
		public static const NAN:Quaternion = new Quaternion(NaN, NaN, NaN, NaN);
		
		
		/**
		 *  从欧拉角生成四元数（顺序为Yaw、Pitch、Roll）
		 * @param	yaw yaw值
		 * @param	pitch pitch值
		 * @param	roll roll值
		 * @param	out 输出四元数
		 */
		public static function createFromYawPitchRoll(yaw:Number, pitch:Number, roll:Number, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var halfRoll:Number = roll * 0.5;
			var halfPitch:Number = pitch * 0.5;
			var halfYaw:Number = yaw * 0.5;
			
			var sinRoll:Number = Math.sin(halfRoll);
			var cosRoll:Number = Math.cos(halfRoll);
			var sinPitch:Number = Math.sin(halfPitch);
			var cosPitch:Number = Math.cos(halfPitch);
			var sinYaw:Number = Math.sin(halfYaw);
			var cosYaw:Number = Math.cos(halfYaw);
			

			out.x = (cosYaw * sinPitch * cosRoll) + (sinYaw * cosPitch * sinRoll);
			out.y = (sinYaw * cosPitch * cosRoll) - (cosYaw * sinPitch * sinRoll);
			out.z = (cosYaw * cosPitch * sinRoll) - (sinYaw * sinPitch * cosRoll);
			out.w = (cosYaw * cosPitch * cosRoll) + (sinYaw * sinPitch * sinRoll);
		}
		
		/**
		 * 计算两个四元数相乘
		 * @param	left left四元数
		 * @param	right  right四元数
		 * @param	out 输出四元数
		 */
		public static function multiply(left:Quaternion, right:Quaternion, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var lx:Number = left.x;
			var ly:Number = left.y;
			var lz:Number = left.z;
			var lw:Number = left.w;
			var rx:Number = right.x;
			var ry:Number = right.y;
			var rz:Number = right.z;
			var rw:Number = right.w;
			var a:Number = (ly * rz - lz * ry);
			var b:Number = (lz * rx - lx * rz);
			var c:Number = (lx * ry - ly * rx);
			var d:Number = (lx * rx + ly * ry + lz * rz);
			out.x = (lx * rw + rx * lw) + a;
			out.y = (ly * rw + ry * lw) + b;
			out.z = (lz * rw + rz * lw) + c;
			out.w = lw * rw - d;
		}
		
		private static function arcTanAngle(x:Number, y:Number):Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			if (x == 0) {
				if (y == 1)
					return Math.PI / 2;
				return -Math.PI / 2;
			}
			if (x > 0)
				return Math.atan(y / x);
			if (x < 0) {
				if (y > 0)
					return Math.atan(y / x) + Math.PI;
				return Math.atan(y / x) - Math.PI;
			}
			return 0;
		}
		
		private static function angleTo(from:Vector3, location:Vector3, angle:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			Vector3.subtract(location, from, TEMPVector30);
			Vector3.normalize(TEMPVector30, TEMPVector30);
			
			angle.x = Math.asin(TEMPVector30.y);
			angle.y = arcTanAngle(-TEMPVector30.z, -TEMPVector30.x);
		}
		
		/**
		 * 从指定的轴和角度计算四元数
		 * @param	axis  轴
		 * @param	rad  角度
		 * @param	out  输出四元数
		 */
		public static function createFromAxisAngle(axis:Vector3, rad:Number, out:Quaternion):void {
			rad = rad * 0.5;
			var s:Number = Math.sin(rad);
			out.x = s * axis.x;
			out.y = s * axis.y;
			out.z = s * axis.z;
			out.w = Math.cos(rad);
		}
		
		
		/**
		 *  从旋转矩阵计算四元数
		 * @param	mat 旋转矩阵
		 * @param	out  输出四元数
		 */
		public static function createFromMatrix4x4(mat:Matrix4x4, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var me:Float32Array = mat.elements;
			
			var sqrt:Number;
			var half:Number;
			var scale:Number = me[0] + me[5] + me[10];
			
			if (scale > 0.0) {
				sqrt = Math.sqrt(scale + 1.0);
				out.w = sqrt * 0.5;
				sqrt = 0.5 / sqrt;
				
				out.x = (me[6] - me[9]) * sqrt;
				out.y = (me[8] - me[2]) * sqrt;
				out.z = (me[1] - me[4]) * sqrt;
			} else if ((me[0] >= me[5]) && (me[0] >= me[10])) {
				sqrt = Math.sqrt(1.0 + me[0] - me[5] - me[10]);
				half = 0.5 / sqrt;
				
				out.x = 0.5 * sqrt;
				out.y = (me[1] + me[4]) * half;
				out.z = (me[2] + me[8]) * half;
				out.w = (me[6] - me[9]) * half;
			} else if (me[5] > me[10]) {
				sqrt = Math.sqrt(1.0 + me[5] - me[0] - me[10]);
				half = 0.5 / sqrt;
				
				out.x = (me[4] + me[1]) * half;
				out.y = 0.5 * sqrt;
				out.z = (me[9] + me[6]) * half;
				out.w = (me[8] - me[2]) * half;
			} else {
				sqrt = Math.sqrt(1.0 + me[10] - me[0] - me[5]);
				half = 0.5 / sqrt;
				
				out.x = (me[8] + me[2]) * half;
				out.y = (me[9] + me[6]) * half;
				out.z = 0.5 * sqrt;
				out.w = (me[1] - me[4]) * half;
			}
		
		}
		
		/**
		 * 球面插值
		 * @param	left left四元数
		 * @param	right  right四元数
		 * @param	a 插值比例
		 * @param	out 输出四元数
		 * @return   输出Float32Array
		 */
		public static function slerp(left:Quaternion, right:Quaternion, t:Number, out:Quaternion):Quaternion {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var ax:Number = left.x, ay:Number = left.y, az:Number = left.z, aw:Number = left.w, bx:Number = right.x, by:Number = right.y, bz:Number = right.z, bw:Number = right.w;
			
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
			out.x = scale0 * ax + scale1 * bx;
			out.y = scale0 * ay + scale1 * by;
			out.z = scale0 * az + scale1 * bz;
			out.w = scale0 * aw + scale1 * bw;
			
			return out;
		}
		
		/**
		 * 计算两个四元数的线性插值
		 * @param	left left四元数
		 * @param	right right四元数b
		 * @param	t 插值比例
		 * @param	out 输出四元数
		 */
		public static function lerp(left:Quaternion, right:Quaternion, amount:Number, out:Quaternion):void {
			var inverse:Number = 1.0 - amount;
			if (dot(left, right) >= 0) {
				out.x = (inverse * left.x) + (amount * right.x);
				out.y = (inverse * left.y) + (amount * right.y);
				out.z = (inverse * left.z) + (amount * right.z);
				out.w = (inverse * left.w) + (amount * right.w);
			} else {
				out.x = (inverse * left.x) - (amount * right.x);
				out.y = (inverse * left.y) - (amount * right.y);
				out.z = (inverse * left.z) - (amount * right.z);
				out.w = (inverse * left.w) - (amount * right.w);
			}
			out.normalize(out);
		}
		
		/**
		 * 计算两个四元数的和
		 * @param	left  left四元数
		 * @param	right right 四元数
		 * @param	out 输出四元数
		 */
		public static function add(left:Quaternion, right:Quaternion, out:Quaternion):void {
			out.x = left.x + right.x;
			out.y = left.y + right.y;
			out.z = left.z + right.z;
			out.w = left.w + right.w;
		}
		
		/**
		 * 计算两个四元数的点积
		 * @param	left left四元数
		 * @param	right right四元数
		 * @return  点积
		 */
		public static function dot(left:Quaternion, right:Quaternion):Number {
			return left.x * right.x + left.y * right.y + left.z * right.z + left.w * right.w;
		}
		
		/**X轴坐标*/
		public var x:Number;
		/**Y轴坐标*/
		public var y:Number;
		/**Z轴坐标*/
		public var z:Number;
		/**W轴坐标*/
		public var w:Number;
		
		/**
		 * 创建一个 <code>Quaternion</code> 实例。
		 * @param	x 四元数的x值
		 * @param	y 四元数的y值
		 * @param	z 四元数的z值
		 * @param	w 四元数的w值
		 */
		public function Quaternion(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 1, nativeElements:Float32Array = null/*[NATIVE]*/) {
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		
		/**
		 * 根据缩放值缩放四元数
		 * @param	scale 缩放值
		 * @param	out 输出四元数
		 */
		public function scaling(scaling:Number, out:Quaternion):void {
			out.x = x * scaling;
			out.y = y * scaling;
			out.z = z * scaling;
			out.w = w * scaling;
		}
		
		/**
		 * 归一化四元数
		 * @param	out 输出四元数
		 */
		public function normalize(out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var len:Number = x * x + y * y + z * z + w * w;
			if (len > 0) {
				len = 1 / Math.sqrt(len);
				out.x = x * len;
				out.y = y * len;
				out.z = z * len;
				out.w = w * len;
			}
		}
		
		/**
		 * 计算四元数的长度
		 * @return  长度
		 */
		public function length():Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			return Math.sqrt(x * x + y * y + z * z + w * w);
		}
		
		/**
		 * 根据绕X轴的角度旋转四元数
		 * @param	rad 角度
		 * @param	out 输出四元数
		 */
		public function rotateX(rad:Number, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			rad *= 0.5;
			
			var bx:Number = Math.sin(rad), bw:Number = Math.cos(rad);
			
			out.x = x * bw + w * bx;
			out.y = y * bw + z * bx;
			out.z = z * bw - y * bx;
			out.w = w * bw - x * bx;
		}
		
		/**
		 * 根据绕Y轴的制定角度旋转四元数
		 * @param	rad 角度
		 * @param	out 输出四元数
		 */
		public function rotateY(rad:Number, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			rad *= 0.5;
			
			var by:Number = Math.sin(rad), bw:Number = Math.cos(rad);
			
			out.x = x * bw - z * by;
			out.y = y * bw + w * by;
			out.z = z * bw + x * by;
			out.w = w * bw - y * by;
		}
		
		/**
		 * 根据绕Z轴的制定角度旋转四元数
		 * @param	rad 角度
		 * @param	out 输出四元数
		 */
		public function rotateZ(rad:Number, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			rad *= 0.5;
			var bz:Number = Math.sin(rad), bw:Number = Math.cos(rad);
			
			out.x = x * bw + y * bz;
			out.y = y * bw - x * bz;
			out.z = z * bw + w * bz;
			out.w = w * bw - z * bz;
		}
		
		/**
		 * 分解四元数到欧拉角（顺序为Yaw、Pitch、Roll），参考自http://xboxforums.create.msdn.com/forums/p/4574/23988.aspx#23988,问题绕X轴翻转超过±90度时有，会产生瞬间反转
		 * @param	quaternion 源四元数
		 * @param	out 欧拉角值
		 */
		public function getYawPitchRoll(out:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			Vector3.transformQuat(Vector3._ForwardRH, this, TEMPVector31/*forwarldRH*/);
			
			Vector3.transformQuat(Vector3._Up, this, TEMPVector32/*up*/);
			var upe:Vector3 = TEMPVector32;
			
			angleTo(Vector3._ZERO, TEMPVector31, TEMPVector33/*angle*/);
			var angle:Vector3 = TEMPVector33;
			
			if (angle.x == Math.PI / 2) {
				angle.y = arcTanAngle(upe.z, upe.x);
				angle.z = 0;
			} else if (angle.x == -Math.PI / 2) {
				angle.y = arcTanAngle(-upe.z, -upe.x);
				angle.z = 0;
			} else {
				Matrix4x4.createRotationY(-angle.y, TEMPMatrix0);
				Matrix4x4.createRotationX(-angle.x, TEMPMatrix1);
				
				Vector3.transformCoordinate(TEMPVector32, TEMPMatrix0, TEMPVector32);
				Vector3.transformCoordinate(TEMPVector32, TEMPMatrix1, TEMPVector32);
				angle.z = arcTanAngle(upe.y, -upe.x);
			}
			
			// Special cases.
			if (angle.y <= -Math.PI)
				angle.y = Math.PI;
			if (angle.z <= -Math.PI)
				angle.z = Math.PI;
			
			if (angle.y >= Math.PI && angle.z >= Math.PI) {
				angle.y = 0;
				angle.z = 0;
				angle.x = Math.PI - angle.x;
			}
			
			var oe:Vector3 = out;
			oe.x = angle.y;
			oe.y = angle.x;
			oe.z = angle.z;
		}
		
		/**
		 * 求四元数的逆
		 * @param	out  输出四元数
		 */
		public function invert(out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var a0:Number = x, a1:Number = y, a2:Number = z, a3:Number = w;
			var dot:Number = a0 * a0 + a1 * a1 + a2 * a2 + a3 * a3;
			var invDot:Number = dot ? 1.0 / dot : 0;
			
			// TODO: Would be faster to return [0,0,0,0] immediately if dot == 0
			out.x = -a0 * invDot;
			out.y = -a1 * invDot;
			out.z = -a2 * invDot;
			out.w = a3 * invDot;
		}
		
		/**
		 *设置四元数为单位算数
		 * @param out  输出四元数
		 */
		public function identity():void {
			x = 0;
			y = 0;
			z = 0;
			w = 1;
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
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			if (this === destObject) {
				return;
			}
			destObject.x = x;
			destObject.y = y;
			destObject.z = z;
			destObject.w = w;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:Quaternion = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
		
		public function equals(b:Quaternion):Boolean {
			return MathUtils3D.nearEqual(x, b.x) && MathUtils3D.nearEqual(y, b.y) && MathUtils3D.nearEqual(z, b.z) && MathUtils3D.nearEqual(w, b.w);
		}
		
		/**
		 * 计算旋转观察四元数
		 * @param	forward 方向
		 * @param	up     上向量
		 * @param	out    输出四元数
		 */
		public static function rotationLookAt(forward:Vector3, up:Vector3, out:Quaternion):void {
			lookAt(Vector3._ZERO, forward, up, out);
		}
		
		/**
		 * 计算观察四元数
		 * @param	eye    观察者位置
		 * @param	target 目标位置
		 * @param	up     上向量
		 * @param	out    输出四元数
		 */
		public static function lookAt(eye:Vector3, target:Vector3, up:Vector3, out:Quaternion):void {
			Matrix3x3.lookAt(eye, target, up, _tempMatrix3x3);
			rotationMatrix(_tempMatrix3x3, out);
		}
		
		/**
		 * 计算长度的平方。
		 * @return 长度的平方。
		 */
		public function lengthSquared():Number {
			return (x * x) + (y * y) + (z * z) + (w * w);
		}
		
		/**
		 * 计算四元数的逆四元数。
		 * @param	value 四元数。
		 * @param	out 逆四元数。
		 */
		public static function invert(value:Quaternion, out:Quaternion):void {
			var lengthSq:Number = value.lengthSquared();
			if (!MathUtils3D.isZero(lengthSq)) {
				lengthSq = 1.0 / lengthSq;
				
				out.x = -value.x * lengthSq;
				out.y = -value.y * lengthSq;
				out.z = -value.z * lengthSq;
				out.w = value.w * lengthSq;
			}
		}
		
		/**
		 * 通过一个3x3矩阵创建一个四元数
		 * @param	matrix3x3  3x3矩阵
		 * @param	out        四元数
		 */
		public static function rotationMatrix(matrix3x3:Matrix3x3, out:Quaternion):void {
			var me:Float32Array = matrix3x3.elements;
			var m11:Number = me[0];
			var m12:Number = me[1];
			var m13:Number = me[2];
			var m21:Number = me[3];
			var m22:Number = me[4];
			var m23:Number = me[5];
			var m31:Number = me[6];
			var m32:Number = me[7];
			var m33:Number = me[8];
			
			var sqrt:Number, half:Number;
			var scale:Number = m11 + m22 + m33;
			
			if (scale > 0) {
				
				sqrt = Math.sqrt(scale + 1);
				out.w = sqrt * 0.5;
				sqrt = 0.5 / sqrt;
				
				out.x = (m23 - m32) * sqrt;
				out.y = (m31 - m13) * sqrt;
				out.z = (m12 - m21) * sqrt;
				
			} else if ((m11 >= m22) && (m11 >= m33)) {
				
				sqrt = Math.sqrt(1 + m11 - m22 - m33);
				half = 0.5 / sqrt;
				
				out.x = 0.5 * sqrt;
				out.y = (m12 + m21) * half;
				out.z = (m13 + m31) * half;
				out.w = (m23 - m32) * half;
			} else if (m22 > m33) {
				
				sqrt = Math.sqrt(1 + m22 - m11 - m33);
				half = 0.5 / sqrt;
				
				out.x = (m21 + m12) * half;
				out.y = 0.5 * sqrt;
				out.z = (m32 + m23) * half;
				out.w = (m31 - m13) * half;
			} else {
				
				sqrt = Math.sqrt(1 + m33 - m11 - m22);
				half = 0.5 / sqrt;
				
				out.x = (m31 + m13) * half;
				out.y = (m32 + m23) * half;
				out.z = 0.5 * sqrt;
				out.w = (m12 - m21) * half;
			}
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
