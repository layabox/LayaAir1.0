package laya.d3.math {
	
	/**
	 * <code>Matrix4x4</code> 类用于创建4x4矩阵。
	 */
	public class Matrix4x4 {
		/**@private */
		private static var _tempMatrix4x4:Matrix4x4 = /*[STATIC SAFE]*/ new Matrix4x4();
		/**@private */
		private static var _tempQuaternion:Quaternion =new Quaternion();
		/**默认矩阵,禁止修改*/
		public static const DEFAULT:Matrix4x4 =/*[STATIC SAFE]*/ new Matrix4x4();
		
		private static var _translationVector:Vector3 = new Vector3();
		
		/**
		 * 绕X轴旋转
		 * @param	rad  旋转角度
		 * @param	out 输出矩阵
		 */
		public static function createRotationX(rad:Number, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var oe:Float32Array = out.elements;
			var s:Number = Math.sin(rad), c:Number = Math.cos(rad);
			
			oe[1] = oe[2] = oe[3] = oe[4] = oe[7] = oe[8] = oe[11] = oe[12] = oe[13] = oe[14] = 0;
			oe[0] = oe[15] = 1;
			oe[5] = oe[10] = c;
			oe[6] = s;
			oe[9] = -s;
		}
		
		/**
		 * 
		 * 绕Y轴旋转
		 * @param	rad  旋转角度
		 * @param	out 输出矩阵
		 */
		public static function createRotationY(rad:Number, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var oe:Float32Array = out.elements;
			var s:Number = Math.sin(rad), c:Number = Math.cos(rad);
			
			oe[1] = oe[3] = oe[4] = oe[6] = oe[7] = oe[9] = oe[11] = oe[12] = oe[13] = oe[14] = 0;
			oe[5] = oe[15] = 1;
			oe[0] = oe[10] = c;
			oe[2] = -s;
			oe[8] = s;
		}
		
		/**
		 * 绕Z轴旋转
		 * @param	rad  旋转角度
		 * @param	out 输出矩阵
		 */
		public static function createRotationZ(rad:Number, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var oe:Float32Array = out.elements;
			var s:Number = Math.sin(rad), c:Number = Math.cos(rad);
			
			oe[2] = oe[3] = oe[6] = oe[7] = oe[8] = oe[9] = oe[11] = oe[12] = oe[13] = oe[14] = 0;
			oe[10] = oe[15] = 1;
			oe[0] = oe[5] = c;
			oe[1] = s;
			oe[4] = -s;
		}
		
		/**
		 * 通过yaw pitch roll旋转创建旋转矩阵。
		 * @param	yaw
		 * @param	pitch
		 * @param	roll
		 * @param	result
		 */
		public static function createRotationYawPitchRoll(yaw:Number, pitch:Number, roll:Number, result:Matrix4x4):void {
			Quaternion.createFromYawPitchRoll(yaw, pitch, roll, _tempQuaternion);
			createRotationQuaternion(_tempQuaternion, result);
		}
		
		/**
		 * 通过四元数创建旋转矩阵。
		 * @param	rotation 旋转四元数。
		 * @param	result 输出旋转矩阵
		 */
		public static function createRotationQuaternion(rotation:Quaternion, result:Matrix4x4):void {
			var rotationE:Float32Array = rotation.elements;
			var resultE:Float32Array = result.elements;
			var rotationX:Number = rotationE[0];
			var rotationY:Number = rotationE[1];
			var rotationZ:Number = rotationE[2];
			var rotationW:Number = rotationE[3];
			
			var xx:Number = rotationX * rotationX;
			var yy:Number = rotationY * rotationY;
			var zz:Number = rotationZ * rotationZ;
			var xy:Number = rotationX * rotationY;
			var zw:Number = rotationZ * rotationW;
			var zx:Number = rotationZ * rotationX;
			var yw:Number = rotationY * rotationW;
			var yz:Number = rotationY * rotationZ;
			var xw:Number = rotationX * rotationW;
			
			resultE[3] = resultE[7] = resultE[11] = resultE[12] = resultE[13] = resultE[14] = 0;
			resultE[15] = 1.0;
			resultE[0] = 1.0 - (2.0 * (yy + zz));
			resultE[1] = 2.0 * (xy + zw);
			resultE[2] = 2.0 * (zx - yw);
			resultE[4] = 2.0 * (xy - zw);
			resultE[5] = 1.0 - (2.0 * (zz + xx));
			resultE[6] = 2.0 * (yz + xw);
			resultE[8] = 2.0 * (zx + yw);
			resultE[9] = 2.0 * (yz - xw);
			resultE[10] = 1.0 - (2.0 * (yy + xx));
		}
		
		/**
		 * 根据平移计算输出矩阵
		 * @param	trans  平移向量
		 * @param	out 输出矩阵
		 */
		public static function createTranslate(trans:Vector3, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var te:Float32Array = trans.elements;
			var oe:Float32Array = out.elements;
			oe[4] = oe[8] = oe[1] = oe[9] = oe[2] = oe[6] = oe[3] = oe[7] = oe[11] = 0;
			oe[0] = oe[5] = oe[10] = oe[15] = 1;
			oe[12] = te[0];
			oe[13] = te[1];
			oe[14] = te[2];
		}
		
		/**
		 * 根据缩放计算输出矩阵
		 * @param	scale  缩放值
		 * @param	out 输出矩阵
		 */
		public static function createScaling(scale:Vector3, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var se:Float32Array = scale.elements;
			var oe:Float32Array = out.elements;
			oe[0] = se[0];
			oe[5] = se[1];
			oe[10] = se[2];
			oe[1] = oe[4] = oe[8] = oe[12] = oe[9] = oe[13] = oe[2] = oe[6] = oe[14] = oe[3] = oe[7] = oe[11] = 0;
			oe[15] = 1;
		}
		
		/**
		 * 计算两个矩阵的乘法
		 * @param	left left矩阵
		 * @param	right  right矩阵
		 * @param	out  输出矩阵
		 */
		public static function multiply(left:Matrix4x4, right:Matrix4x4, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, e:Float32Array, a:Float32Array, b:Float32Array, ai0:Number, ai1:Number, ai2:Number, ai3:Number;
			
			e = out.elements;
			a = left.elements;
			b = right.elements;
			if (e === b) {
				b = new Float32Array(16);
				for (i = 0; i < 16; ++i) {
					b[i] = e[i];
				}
			}
			
			for (i = 0; i < 4; i++) {
				ai0 = a[i];
				ai1 = a[i + 4];
				ai2 = a[i + 8];
				ai3 = a[i + 12];
				e[i] = ai0 * b[0] + ai1 * b[1] + ai2 * b[2] + ai3 * b[3];
				e[i + 4] = ai0 * b[4] + ai1 * b[5] + ai2 * b[6] + ai3 * b[7];
				e[i + 8] = ai0 * b[8] + ai1 * b[9] + ai2 * b[10] + ai3 * b[11];
				e[i + 12] = ai0 * b[12] + ai1 * b[13] + ai2 * b[14] + ai3 * b[15];
			}
		}
		
		/**
		 * 从四元数计算旋转矩阵
		 * @param	rotation 四元数
		 * @param	out 输出矩阵
		 */
		public static function createFromQuaternion(rotation:Quaternion, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array = out.elements;
			var q:Float32Array = rotation.elements;
			var x:Number = q[0], y:Number = q[1], z:Number = q[2], w:Number = q[3];
			var x2:Number = x + x;
			var y2:Number = y + y;
			var z2:Number = z + z;
			
			var xx:Number = x * x2;
			var yx:Number = y * x2;
			var yy:Number = y * y2;
			var zx:Number = z * x2;
			var zy:Number = z * y2;
			var zz:Number = z * z2;
			var wx:Number = w * x2;
			var wy:Number = w * y2;
			var wz:Number = w * z2;
			
			e[0] = 1 - yy - zz;
			e[1] = yx + wz;
			e[2] = zx - wy;
			e[3] = 0;
			
			e[4] = yx - wz;
			e[5] = 1 - xx - zz;
			e[6] = zy + wx;
			e[7] = 0;
			
			e[8] = zx + wy;
			e[9] = zy - wx;
			e[10] = 1 - xx - yy;
			e[11] = 0;
			
			e[12] = 0;
			e[13] = 0;
			e[14] = 0;
			out[15] = 1;
		}
		
		/**
		 * 计算仿射矩阵
		 * @param	trans 平移
		 * @param	rot 旋转
		 * @param	scale 缩放
		 * @param	out 输出矩阵
		 */
		public static function createAffineTransformation(trans:Vector3, rot:Quaternion, scale:Vector3, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var te:Float32Array = trans.elements;
			var re:Float32Array = rot.elements;
			var se:Float32Array = scale.elements;
			var oe:Float32Array = out.elements;
			
			var x:Number = re[0], y:Number = re[1], z:Number = re[2], w:Number = re[3], x2:Number = x + x, y2:Number = y + y, z2:Number = z + z;
			var xx:Number = x * x2, xy:Number = x * y2, xz:Number = x * z2, yy:Number = y * y2, yz:Number = y * z2, zz:Number = z * z2;
			var wx:Number = w * x2, wy:Number = w * y2, wz:Number = w * z2, sx:Number = se[0], sy:Number = se[1], sz:Number = se[2];
			
			oe[0] = (1 - (yy + zz)) * sx;
			oe[1] = (xy + wz) * sx;
			oe[2] = (xz - wy) * sx;
			oe[3] = 0;
			oe[4] = (xy - wz) * sy;
			oe[5] = (1 - (xx + zz)) * sy;
			oe[6] = (yz + wx) * sy;
			oe[7] = 0;
			oe[8] = (xz + wy) * sz;
			oe[9] = (yz - wx) * sz;
			oe[10] = (1 - (xx + yy)) * sz;
			oe[11] = 0;
			oe[12] = te[0];
			oe[13] = te[1];
			oe[14] = te[2];
			oe[15] = 1;
		}
		
		/**
		 *  计算观察矩阵
		 * @param	eye 视点位置
		 * @param	center 视点目标
		 * @param	up 向上向量
		 * @param	out 输出矩阵
		 */
		public static function createLookAt(eye:Vector3, center:Vector3, up:Vector3, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var ee:Float32Array = eye.elements;
			var ce:Float32Array = center.elements;
			var ue:Float32Array = up.elements;
			var oe:Float32Array = out.elements;
			
			var x0:Number, x1:Number, x2:Number, y0:Number, y1:Number, y2:Number, z0:Number, z1:Number, z2:Number, len:Number, eyex:Number = ee[0], eyey:Number = ee[1], eyez:Number = ee[2], upx:Number = ue[0], upy:Number = ue[1], upz:Number = ue[2], centerx:Number = ce[0], centery:Number = ce[1], centerz:Number = ce[2];
			
			if (Math.abs(eyex - centerx) < MathUtils3D.zeroTolerance && Math.abs(eyey - centery) < MathUtils3D.zeroTolerance && Math.abs(eyez - centerz) < MathUtils3D.zeroTolerance) {
				out.identity();
				return;
			}
			
			z0 = eyex - centerx;
			z1 = eyey - centery;
			z2 = eyez - centerz;
			
			len = 1 / Math.sqrt(z0 * z0 + z1 * z1 + z2 * z2);
			z0 *= len;
			z1 *= len;
			z2 *= len;
			
			x0 = upy * z2 - upz * z1;
			x1 = upz * z0 - upx * z2;
			x2 = upx * z1 - upy * z0;
			len = Math.sqrt(x0 * x0 + x1 * x1 + x2 * x2);
			if (!len) {
				x0 = x1 = x2 = 0;
			} else {
				len = 1 / len;
				x0 *= len;
				x1 *= len;
				x2 *= len;
			}
			
			y0 = z1 * x2 - z2 * x1;
			y1 = z2 * x0 - z0 * x2;
			y2 = z0 * x1 - z1 * x0;
			
			len = Math.sqrt(y0 * y0 + y1 * y1 + y2 * y2);
			if (!len) {
				y0 = y1 = y2 = 0;
			} else {
				len = 1 / len;
				y0 *= len;
				y1 *= len;
				y2 *= len;
			}
			
			oe[0] = x0;
			oe[1] = y0;
			oe[2] = z0;
			oe[3] = 0;
			oe[4] = x1;
			oe[5] = y1;
			oe[6] = z1;
			oe[7] = 0;
			oe[8] = x2;
			oe[9] = y2;
			oe[10] = z2;
			oe[11] = 0;
			oe[12] = -(x0 * eyex + x1 * eyey + x2 * eyez);
			oe[13] = -(y0 * eyex + y1 * eyey + y2 * eyez);
			oe[14] = -(z0 * eyex + z1 * eyey + z2 * eyez);
			oe[15] = 1;
		}
		
		/**
		 * 计算透视投影矩阵。
		 * @param	fov  视角。
		 * @param	aspect 横纵比。
		 * @param	near 近裁面。
		 * @param	far 远裁面。
		 * @param	out 输出矩阵。
		 */
		public static function createPerspective(fov:Number, aspect:Number, near:Number, far:Number, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			//var oe:Float32Array = out.elements;
			//
			//var f:Number = 1.0 / Math.tan(fov / 2), nf:Number = 1 / (near - far);
			//oe[0] = f / aspect;
			//oe[5] = f;
			//oe[10] = (far + near) * nf;
			//oe[11] = -1;
			//oe[14] = (2 * far * near) * nf;
			//oe[1] = oe[2] = oe[3] = oe[4] = oe[6] = oe[7] = oe[8] = oe[9] = oe[12] = oe[13] = oe[15] = 0;
			
			var oe:Float32Array = out.elements;
			
			var yScale:Number = 1.0 / Math.tan(fov * 0.5);
			var q:Number = far / (near - far);
			
			oe[0] = yScale / aspect;
			oe[5] = yScale;
			oe[10] = q;
			oe[11] = -1.0;
			oe[14] = q * near;
			oe[1] = oe[2] = oe[3] = oe[4] = oe[6] = oe[7] = oe[8] = oe[9] = oe[12] = oe[13] = oe[15] = 0;
		}
		
		/**
		 * 计算正交投影矩阵。
		 * @param	left 视椎左边界。
		 * @param	right 视椎右边界。
		 * @param	bottom 视椎底边界。
		 * @param	top 视椎顶边界。
		 * @param	near 视椎近边界。
		 * @param	far 视椎远边界。
		 * @param	out 输出矩阵。
		 */
		public static function createOrthogonal(left:Number, right:Number, bottom:Number, top:Number, near:Number, far:Number, out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var oe:Float32Array = out.elements;
			
			var lr:Number = 1 / (left - right);
			var bt:Number = 1 / (bottom - top);
			var nf:Number = 1 / (near - far);
			oe[1] = oe[2] = oe[3] = oe[4] = oe[6] = oe[7] = oe[8] = oe[9] = oe[11] = 0;
			oe[15] = 1;
			oe[0] = -2 * lr;
			oe[5] = -2 * bt;
			oe[10] = 2 * nf;
			oe[12] = (left + right) * lr;
			oe[13] = (top + bottom) * bt;
			oe[14] = (far + near) * nf;
		}
		
		/**矩阵元素数组*/
		public var elements:Float32Array;
		
		/**
		 * 创建一个 <code>Matrix4x4</code> 实例。
		 * @param	4x4矩阵的各元素
		 */
		public function Matrix4x4(m11:Number = 1, m12:Number = 0, m13:Number = 0, m14:Number = 0, m21:Number = 0, m22:Number = 1, m23:Number = 0, m24:Number = 0, m31:Number = 0, m32:Number = 0, m33:Number = 1, m34:Number = 0, m41:Number = 0, m42:Number = 0, m43:Number = 0, m44:Number = 1) {
			var e:Float32Array = this.elements = new Float32Array(16);
			e[0] = m11;
			e[1] = m12;
			e[2] = m13;
			e[3] = m14;
			e[4] = m21;
			e[5] = m22;
			e[6] = m23;
			e[7] = m24;
			e[8] = m31;
			e[9] = m32;
			e[10] = m33;
			e[11] = m34;
			e[12] = m41;
			e[13] = m42;
			e[14] = m43;
			e[15] = m44;
		}
		
		/**
		 * 判断两个4x4矩阵的值是否相等。
		 * @param	other 4x4矩阵
		 */
		public function equalsOtherMatrix(other:Matrix4x4):Boolean {
			
			var e:Float32Array = this.elements;
			var oe:Float32Array = other.elements;
			
			return (MathUtils3D.nearEqual(e[0], oe[0]) && MathUtils3D.nearEqual(e[1], oe[1]) && MathUtils3D.nearEqual(e[2], oe[2]) && MathUtils3D.nearEqual(e[3], oe[3]) && MathUtils3D.nearEqual(e[4], oe[4]) && MathUtils3D.nearEqual(e[5], oe[5]) && MathUtils3D.nearEqual(e[6], oe[6]) && MathUtils3D.nearEqual(e[7], oe[7]) && MathUtils3D.nearEqual(e[8], oe[8]) && MathUtils3D.nearEqual(e[9], oe[9]) && MathUtils3D.nearEqual(e[10], oe[10]) && MathUtils3D.nearEqual(e[11], oe[11]) && MathUtils3D.nearEqual(e[12], oe[12]) && MathUtils3D.nearEqual(e[13], oe[13]) && MathUtils3D.nearEqual(e[14], oe[14]) && MathUtils3D.nearEqual(e[15], oe[15]));
		}
		
		/**
		 * 分解矩阵
		 * @param	translation 平移
		 * @param	rotation 旋转
		 * @param	scale 缩放
		 * @return   是否成功
		 */
		public function decompose(translation:Vector3, rotation:Quaternion, scale:Vector3):Boolean {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var me:Float32Array = this.elements;
			var te:Float32Array = translation.elements;
			var re:Float32Array = rotation.elements;
			var se:Float32Array = scale.elements;
			
			//Get the translation. 
			te[0] = me[12];
			te[1] = me[13];
			te[2] = me[14];
			
			//Scaling is the length of the rows. 
			se[0] = Math.sqrt((me[0] * me[0]) + (me[1] * me[1]) + (me[2] * me[2]));
			se[1] = Math.sqrt((me[4] * me[4]) + (me[5] * me[5]) + (me[6] * me[6]));
			se[2] = Math.sqrt((me[8] * me[8]) + (me[9] * me[9]) + (me[10] * me[10]));
			
			//If any of the scaling factors are zero, than the rotation matrix can not exist. 
			if (MathUtils3D.isZero(se[0]) || MathUtils3D.isZero(se[1]) || MathUtils3D.isZero(se[2])) {
				re[0] = re[1] = re[2] = 0;
				re[3] = 1;
				return false;
			}
			
			//The rotation is the left over matrix after dividing out the scaling. 
			var rotationmatrix:Matrix4x4 = new Matrix4x4();
			var rme:Float32Array = rotationmatrix.elements;
			rme[0] = me[0] / se[0];
			rme[1] = me[1] / se[0];
			rme[2] = me[2] / se[0];
			
			rme[4] = me[4] / se[1];
			rme[5] = me[5] / se[1];
			rme[6] = me[6] / se[1];
			
			rme[8] = me[8] / se[2];
			rme[9] = me[9] / se[2];
			rme[10] = me[10] / se[2];
			
			rotationmatrix[15] = 1;
			
			Quaternion.createFromMatrix4x4(rotationmatrix, rotation);
			return true;
		}
		
		/**归一化矩阵 */
		public function normalize():void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var v:Float32Array = this.elements;
			var c:Number = v[0], d:Number = v[1], e:Number = v[2], g:Number = Math.sqrt(c * c + d * d + e * e);
			if (g) {
				if (g == 1)
					return;
			} else {
				v[0] = 0;
				v[1] = 0;
				v[2] = 0;
				return;
			}
			g = 1 / g;
			v[0] = c * g;
			v[1] = d * g;
			v[2] = e * g;
		}
		
		/**计算矩阵的转置矩阵*/
		public function transpose():Matrix4x4 {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var e:Float32Array, t:Number;
			e = this.elements;
			t = e[1];
			e[1] = e[4];
			e[4] = t;
			t = e[2];
			e[2] = e[8];
			e[8] = t;
			t = e[3];
			e[3] = e[12];
			e[12] = t;
			t = e[6];
			e[6] = e[9];
			e[9] = t;
			t = e[7];
			e[7] = e[13];
			e[13] = t;
			t = e[11];
			e[11] = e[14];
			e[14] = t;
			
			return this;
		}
		
		/**
		 * 计算一个矩阵的逆矩阵
		 * @param	out 输出矩阵
		 */
		public function invert(out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var ae:Float32Array = this.elements;
			var oe:Float32Array = out.elements;
			var a00:Number = ae[0], a01:Number = ae[1], a02:Number = ae[2], a03:Number = ae[3], a10:Number = ae[4], a11:Number = ae[5], a12:Number = ae[6], a13:Number = ae[7], a20:Number = ae[8], a21:Number = ae[9], a22:Number = ae[10], a23:Number = ae[11], a30:Number = ae[12], a31:Number = ae[13], a32:Number = ae[14], a33:Number = ae[15],
			
			b00:Number = a00 * a11 - a01 * a10, b01:Number = a00 * a12 - a02 * a10, b02:Number = a00 * a13 - a03 * a10, b03:Number = a01 * a12 - a02 * a11, b04:Number = a01 * a13 - a03 * a11, b05:Number = a02 * a13 - a03 * a12, b06:Number = a20 * a31 - a21 * a30, b07:Number = a20 * a32 - a22 * a30, b08:Number = a20 * a33 - a23 * a30, b09:Number = a21 * a32 - a22 * a31, b10:Number = a21 * a33 - a23 * a31, b11:Number = a22 * a33 - a23 * a32,
			
			// Calculate the determinant 
			det:Number = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;
			
			if (Math.abs(det) === 0.0) {
				return;
			}
			det = 1.0 / det;
			
			oe[0] = (a11 * b11 - a12 * b10 + a13 * b09) * det;
			oe[1] = (a02 * b10 - a01 * b11 - a03 * b09) * det;
			oe[2] = (a31 * b05 - a32 * b04 + a33 * b03) * det;
			oe[3] = (a22 * b04 - a21 * b05 - a23 * b03) * det;
			oe[4] = (a12 * b08 - a10 * b11 - a13 * b07) * det;
			oe[5] = (a00 * b11 - a02 * b08 + a03 * b07) * det;
			oe[6] = (a32 * b02 - a30 * b05 - a33 * b01) * det;
			oe[7] = (a20 * b05 - a22 * b02 + a23 * b01) * det;
			oe[8] = (a10 * b10 - a11 * b08 + a13 * b06) * det;
			oe[9] = (a01 * b08 - a00 * b10 - a03 * b06) * det;
			oe[10] = (a30 * b04 - a31 * b02 + a33 * b00) * det;
			oe[11] = (a21 * b02 - a20 * b04 - a23 * b00) * det;
			oe[12] = (a11 * b07 - a10 * b09 - a12 * b06) * det;
			oe[13] = (a00 * b09 - a01 * b07 + a02 * b06) * det;
			oe[14] = (a31 * b01 - a30 * b03 - a32 * b00) * det;
			oe[15] = (a20 * b03 - a21 * b01 + a22 * b00) * det;
		
		}
		
		/**设置矩阵为单位矩阵*/
		public function identity():void {
			var e:Float32Array = this.elements;
			e[1] = e[2] = e[3] = e[4] = e[6] = e[7] = e[8] = e[9] = e[11] = e[12] = e[13] = e[14] = 0;
			e[0] = e[5] = e[10] = e[15] = 1;
		}
		
		/**
		 *  克隆一个4x4矩阵
		 * @param	out 输出的4x4矩阵
		 */
		public function cloneTo(out:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, s:Float32Array, d:Float32Array;
			s = this.elements;
			d = out.elements;
			if (s === d) {
				return;
			}
			for (i = 0; i < 16; ++i) {
				d[i] = s[i];
			}
		}
		
		/**
		 * 从一个4x4矩阵复制
		 * @param	sou 源4x4矩阵
		 */
		public function copyFrom(sou:Matrix4x4):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var i:int, s:Float32Array, d:Float32Array;
			s = sou.elements;
			d = this.elements;
			if (s === d) {
				return;
			}
			for (i = 0; i < 16; ++i) {
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
			for (i = 0; i < 16; ++i) {
				d[i] = sou[i];
			}
		}
		
		public static function translation(v3:Vector3, out:Matrix4x4):void {
			
			var ve:Float32Array = v3.elements;
			var oe:Float32Array = out.elements;
			oe[0] = oe[5] = oe[10] = oe[15] = 1;
			oe[12] = ve[0];
			oe[13] = ve[1];
			oe[14] = ve[2];
		}
		
		public function get translationVector():Vector3 {
			
			var me:Float32Array = this.elements;
			var oe:Float32Array = _translationVector.elements;
			
			oe[0] = me[12];
			oe[1] = me[13];
			oe[2] = me[14];
			
			return _translationVector;
		}
		
		public function set translationVector(v3:Vector3):void {
			
			var me:Float32Array = this.elements;
			var ve:Float32Array = v3.elements;
			
			me[12] = ve[0];
			me[13] = ve[1];
			me[14] = ve[2];
		}
	
	}
}