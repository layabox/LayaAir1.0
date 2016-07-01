package laya.d3.math {
	
	/**
	 * <code>Quaternion</code> 类用于创建四元数。
	 */
	public class Quaternion {
		/**@private */
		private static var TEMPVector30:Vector3 = new Vector3();
		/**@private */
		private static var TEMPVector31:Vector3 = new Vector3();
		/**@private */
		private static var TEMPVector32:Vector3 = new Vector3();
		/**@private */
		private static var TEMPVector33:Vector3 = new Vector3();
		/**@private */
		private static var TEMPMatrix0:Matrix4x4 = new Matrix4x4();
		/**@private */
		private static var TEMPMatrix1:Matrix4x4 = new Matrix4x4();
		
		/**默认矩阵,禁止修改*/
		public static const DEFAULT:Quaternion =/*[STATIC SAFE]*/ new Quaternion();
		
		/**
		 *  从欧拉角基元四元数（顺序为Yaw、Pitch、Roll）
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
			
			var oe:Float32Array = out.elements;
			oe[0] = (cosYaw * sinPitch * cosRoll) + (sinYaw * cosPitch * sinRoll);
			oe[1] = (sinYaw * cosPitch * cosRoll) - (cosYaw * sinPitch * sinRoll);
			oe[2] = (cosYaw * cosPitch * sinRoll) - (sinYaw * sinPitch * cosRoll);
			oe[3] = (cosYaw * cosPitch * cosRoll) + (sinYaw * sinPitch * sinRoll);
		}
		
		/**
		 * 计算两个四元数相乘
		 * @param	left left四元数
		 * @param	right  right四元数
		 * @param	out 输出四元数
		 */
		public static function multiply(left:Quaternion, right:Quaternion, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var le:Float32Array = left.elements;
			var re:Float32Array = right.elements;
			var oe:Float32Array = out.elements;
			
			var lx:Number = le[0];
			var ly:Number = le[1];
			var lz:Number = le[2];
			var lw:Number = le[3];
			var rx:Number = re[0];
			var ry:Number = re[1];
			var rz:Number = re[2];
			var rw:Number = re[3];
			var a:Number = (ly * rz - lz * ry);
			var b:Number = (lz * rx - lx * rz);
			var c:Number = (lx * ry - ly * rx);
			var d:Number = (lx * rx + ly * ry + lz * rz);
			oe[0] = (lx * rw + rx * lw) + a;
			oe[1] = (ly * rw + ry * lw) + b;
			oe[2] = (lz * rw + rz * lw) + c;
			oe[3] = lw * rw - d;
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
			
			angle.elements[0] = Math.asin(TEMPVector30.y);
			angle.elements[1] = arcTanAngle(-TEMPVector30.z, -TEMPVector30.x);
		}
		
		/**
		 * 从指定的轴和角度计算四元数
		 * @param	axis  轴
		 * @param	rad  角度
		 * @param	out  输出四元数
		 */
		public static function createFromAxisAngle(axis:Vector3, rad:Number, out:Quaternion):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = axis.elements;
			
			rad = rad * 0.5;
			var s:Number = Math.sin(rad);
			e[0] = s * f[0];
			e[1] = s * f[1];
			e[2] = s * f[2];
			e[3] = Math.cos(rad);
		}
		
		/**
		 * 根据3x3矩阵计算四元数
		 * @param	sou 源矩阵
		 * @param	out 输出四元数
		 */
		public static function createFromMatrix3x3(sou:Matrix3x3, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = sou.elements;
			
			var fTrace:Number = f[0] + f[4] + f[8];
			var fRoot:Number;
			if (fTrace > 0.0) {
				// |w| > 1/2, may as well choose w > 1/2
				fRoot = Math.sqrt(fTrace + 1.0);  // 2w
				e[3] = 0.5 * fRoot;
				fRoot = 0.5 / fRoot;  // 1/(4w)
				e[0] = (f[5] - f[7]) * fRoot;
				e[1] = (f[6] - f[2]) * fRoot;
				e[2] = (f[1] - f[3]) * fRoot;
			} else {
				// |w| <= 1/2
				var i:Number = 0;
				if (f[4] > f[0])
					i = 1;
				if (f[8] > f[i * 3 + i])
					i = 2;
				var j:Number = (i + 1) % 3;
				var k:Number = (i + 2) % 3;
				
				fRoot = Math.sqrt(f[i * 3 + i] - f[j * 3 + j] - f[k * 3 + k] + 1.0);
				e[i] = 0.5 * fRoot;
				fRoot = 0.5 / fRoot;
				e[3] = (f[j * 3 + k] - f[k * 3 + j]) * fRoot;
				e[j] = (f[j * 3 + i] + f[i * 3 + j]) * fRoot;
				e[k] = (f[k * 3 + i] + f[i * 3 + k]) * fRoot;
			}
			
			return;
		
		}
		
		/**
		 *  从旋转矩阵计算四元数
		 * @param	mat 旋转矩阵
		 * @param	out  输出四元数
		 */
		public static function createFromMatrix4x4(mat:Matrix4x4, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var me:Float32Array = mat.elements;
			var oe:Float32Array = out.elements;
			
			var sqrt:Number;
			var half:Number;
			var scale:Number = me[0] + me[5] + me[10];
			
			if (scale > 0.0) {
				sqrt = Math.sqrt(scale + 1.0);
				oe[3] = sqrt * 0.5;
				sqrt = 0.5 / sqrt;
				
				oe[0] = (me[6] - me[9]) * sqrt;
				oe[1] = (me[8] - me[2]) * sqrt;
				oe[2] = (me[1] - me[4]) * sqrt;
			} else if ((me[0] >= me[5]) && (me[0] >= me[10])) {
				sqrt = Math.sqrt(1.0 + me[0] - me[5] - me[10]);
				half = 0.5 / sqrt;
				
				oe[0] = 0.5 * sqrt;
				oe[1] = (me[1] + me[4]) * half;
				oe[2] = (me[2] + me[8]) * half;
				oe[3] = (me[6] - me[9]) * half;
			} else if (me[5] > me[10]) {
				sqrt = Math.sqrt(1.0 + me[5] - me[0] - me[10]);
				half = 0.5 / sqrt;
				
				oe[0] = (me[4] + me[1]) * half;
				oe[1] = 0.5 * sqrt;
				oe[2] = (me[9] + me[6]) * half;
				oe[3] = (me[8] - me[2]) * half;
			} else {
				sqrt = Math.sqrt(1.0 + me[10] - me[0] - me[5]);
				half = 0.5 / sqrt;
				
				oe[0] = (me[8] + me[2]) * half;
				oe[1] = (me[9] + me[6]) * half;
				oe[2] = 0.5 * sqrt;
				oe[3] = (me[1] - me[4]) * half;
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
		public static function slerp(left:Quaternion, right:Quaternion, t:Number, out:Quaternion):Float32Array {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var a:Float32Array = left.elements;
			var b:Float32Array = right.elements;
			var oe:Float32Array = out.elements;
			var ax:Number = a[0], ay:Number = a[1], az:Number = a[2], aw:Number = a[3], bx:Number = b[0], by:Number = b[1], bz:Number = b[2], bw:Number = b[3];
			
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
			oe[0] = scale0 * ax + scale1 * bx;
			oe[1] = scale0 * ay + scale1 * by;
			oe[2] = scale0 * az + scale1 * bz;
			oe[3] = scale0 * aw + scale1 * bw;
			
			return oe;
		}
		
		/**
		 * 计算两个四元数的线性插值
		 * @param	left left四元数
		 * @param	right right四元数b
		 * @param	t 插值比例
		 * @param	out 输出四元数
		 */
		public static function lerp(left:Quaternion, right:Quaternion, t:Number, out:Quaternion):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = left.elements;
			var g:Float32Array = right.elements;
			
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2], aw:Number = f[3];
			e[0] = ax + t * (g[0] - ax);
			e[1] = ay + t * (g[1] - ay);
			e[2] = az + t * (g[2] - az);
			e[3] = aw + t * (g[3] - aw);
		}
		
		/**
		 * 计算两个四元数的和
		 * @param	left  left四元数
		 * @param	right right 四元数
		 * @param	out 输出四元数
		 */
		public static function add(left:Quaternion, right:Quaternion, out:Quaternion):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = left.elements;
			var g:Float32Array = right.elements;
			
			e[0] = f[0] + g[0];
			e[1] = f[1] + g[1];
			e[2] = f[2] + g[2];
			e[3] = f[3] + g[3];
		}
		
		/**
		 * 计算两个四元数的点积
		 * @param	left left四元数
		 * @param	right right四元数
		 * @return  点积
		 */
		public static function dot(left:Quaternion, right:Quaternion):Number {
			var f:Float32Array = left.elements;
			var g:Float32Array = right.elements;
			
			return f[0] * g[0] + f[1] * g[1] + f[2] * g[2] + f[3] * g[3];
		}
		
		/**四元数元素数组*/
		public var elements:Float32Array = new Float32Array(4);
		
		/**
		 * 获取四元数的x值
		 */
		public function get x():Number {
			return this.elements[0];
		}
		
		/**
		 * 获取四元数的y值
		 */
		public function get y():Number {
			return this.elements[1];
		}
		
		/**
		 * 获取四元数的z值
		 */
		public function get z():Number {
			return this.elements[2];
		}
		
		/**
		 * 获取四元数的w值
		 */
		public function get w():Number {
			return this.elements[3];
		}
		
		/**
		 * 创建一个 <code>Quaternion</code> 实例。
		 * @param	x 四元数的x值
		 * @param	y 四元数的y值
		 * @param	z 四元数的z值
		 * @param	w 四元数的w值
		 */
		public function Quaternion(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 1) {
			elements[0] = x;
			elements[1] = y;
			elements[2] = z;
			elements[3] = w;
		}
		
		/**
		 * 根据缩放值缩放四元数
		 * @param	scale 缩放值
		 * @param	out 输出四元数
		 */
		public function scaling(scaling:Number, out:Quaternion):void {
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			e[0] = f[0] * scaling;
			e[1] = f[1] * scaling;
			e[2] = f[2] * scaling;
			e[3] = f[3] * scaling;
		}
		
		/**
		 * 归一化四元数
		 * @param	out 输出四元数
		 */
		public function normalize(out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			var x:Number = f[0], y:Number = f[1], z:Number = f[2], w:Number = f[3];
			var len:Number = x * x + y * y + z * z + w * w;
			if (len > 0) {
				len = 1 / Math.sqrt(len);
				e[0] = x * len;
				e[1] = y * len;
				e[2] = z * len;
				e[3] = w * len;
			}
		}
		
		/**
		 * 计算四元数的长度
		 * @return  长度
		 */
		public function length():Number {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var f:Float32Array = this.elements;
			
			var x:Number = f[0], y:Number = f[1], z:Number = f[2], w:Number = f[3];
			return Math.sqrt(x * x + y * y + z * z + w * w);
		}
		
		/**
		 * 根据绕X轴的角度旋转四元数
		 * @param	rad 角度
		 * @param	out 输出四元数
		 */
		public function rotateX(rad:Number, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			rad *= 0.5;
			
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2], aw:Number = f[3];
			var bx:Number = Math.sin(rad), bw:Number = Math.cos(rad);
			
			e[0] = ax * bw + aw * bx;
			e[1] = ay * bw + az * bx;
			e[2] = az * bw - ay * bx;
			e[3] = aw * bw - ax * bx;
		}
		
		/**
		 * 根据绕Y轴的制定角度旋转四元数
		 * @param	rad 角度
		 * @param	out 输出四元数
		 */
		public function rotateY(rad:Number, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			rad *= 0.5;
			
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2], aw:Number = f[3], by:Number = Math.sin(rad), bw:Number = Math.cos(rad);
			
			e[0] = ax * bw - az * by;
			e[1] = ay * bw + aw * by;
			e[2] = az * bw + ax * by;
			e[3] = aw * bw - ay * by;
		}
		
		/**
		 * 根据绕Z轴的制定角度旋转四元数
		 * @param	rad 角度
		 * @param	out 输出四元数
		 */
		public function rotateZ(rad:Number, out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			rad *= 0.5;
			
			var ax:Number = f[0], ay:Number = f[1], az:Number = f[2], aw:Number = f[3], bz:Number = Math.sin(rad), bw:Number = Math.cos(rad);
			
			e[0] = ax * bw + ay * bz;
			e[1] = ay * bw - ax * bz;
			e[2] = az * bw + aw * bz;
			e[3] = aw * bw - az * bz;
		}
		
		/**
		 * 分解四元数到欧拉角（顺序为Yaw、Pitch、Roll），参考自http://xboxforums.create.msdn.com/forums/p/4574/23988.aspx#23988,问题绕X轴翻转超过±90度时有，会产生瞬间反转
		 * @param	quaternion 源四元数
		 * @param	out 欧拉角值
		 */
		public function getYawPitchRoll(out:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			Vector3.transformQuat(Vector3.ForwardRH, this, TEMPVector31/*forwarldRH*/);
			
			Vector3.transformQuat(Vector3.Up, this, TEMPVector32/*up*/);
			var upe:Float32Array = TEMPVector32.elements;
			
			angleTo(Vector3.ZERO, TEMPVector31, TEMPVector33/*angle*/);
			var anglee:Float32Array = TEMPVector33.elements;
			
			if (anglee[0] == Math.PI / 2) {
				anglee[1] = arcTanAngle(upe[2], upe[0]);
				anglee[2] = 0;
			} else if (anglee[0] == -Math.PI / 2) {
				anglee[1] = arcTanAngle(-upe[2], -upe[0]);
				anglee[2] = 0;
			} else {
				Matrix4x4.createRotationY(-anglee[1], TEMPMatrix0);
				Matrix4x4.createRotationX(-anglee[0], TEMPMatrix1);
				
				Vector3.transformCoordinate(TEMPVector32, TEMPMatrix0, TEMPVector32);
				Vector3.transformCoordinate(TEMPVector32, TEMPMatrix1, TEMPVector32);
				anglee[2] = arcTanAngle(upe[1], -upe[0]);
			}
			
			// Special cases.
			if (anglee[1] <= -Math.PI)
				anglee[1] = Math.PI;
			if (anglee[2] <= -Math.PI)
				anglee[2] = Math.PI;
			
			if (anglee[1] >= Math.PI && anglee[2] >= Math.PI) {
				anglee[1] = 0;
				anglee[2] = 0;
				anglee[0] = Math.PI - anglee[0];
			}
			
			var oe:Float32Array = out.elements;
			oe[0] = anglee[1];
			oe[1] = anglee[0];
			oe[2] = anglee[2];
		}
		
		/**
		 * 求四元数的逆
		 * @param	out  输出四元数
		 */
		public function invert(out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var f:Float32Array = this.elements;
			
			var a0:Number = f[0], a1:Number = f[1], a2:Number = f[2], a3:Number = f[3];
			var dot:Number = a0 * a0 + a1 * a1 + a2 * a2 + a3 * a3;
			var invDot:Number = dot ? 1.0 / dot : 0;
			
			// TODO: Would be faster to return [0,0,0,0] immediately if dot == 0
			e[0] = -a0 * invDot;
			e[1] = -a1 * invDot;
			e[2] = -a2 * invDot;
			e[3] = a3 * invDot;
		}
		
		/**
		 *设置四元数为单位算数
		 * @param out  输出四元数
		 */
		public function identity():void {
			var e:Float32Array = this.elements;
			e[0] = 0;
			e[1] = 0;
			e[2] = 0;
			e[3] = 1;
		}
		
		/**
		 *  克隆一个四元数
		 * @param	out 输出的四元数
		 */
		public function cloneTo(out:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, s:Float32Array, d:Float32Array;
			s = this.elements;
			d = out.elements;
			if (s === d) {
				return;
			}
			for (i = 0; i < 4; ++i) {
				d[i] = s[i];
			}
		}
		
		/**
		 * 从一个四元数复制
		 * @param	sou 源四元数
		 */
		public function copyFrom(sou:Quaternion):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, s:Float32Array, d:Float32Array;
			s = sou.elements;
			d = this.elements;
			if (s === d) {
				return;
			}
			for (i = 0; i < 4; ++i) {
				d[i] = s[i];
			}
		}
		
		/**
		 * 从一个数组复制
		 * @param	sou 源Float32Array数组
		 */
		public function copyFromArray(sou:Float32Array):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, d:Float32Array;
			d = this.elements;
			if (sou === d) {
				return;
			}
			for (i = 0; i < 4; ++i) {
				d[i] = sou[i];
			}
		}
	}
}
