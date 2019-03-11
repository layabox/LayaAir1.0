package laya.d3Extend.worldMaker {
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	
	public class ArcBall {
		private var width: Number;  // 用来把屏幕坐标缩放到[-1,1]的
		private var height: Number;
		private var lastPos:Vector3 = new Vector3(); // 上次的点的位置，是已经规格化的了
		private var curPos: Vector3  = new Vector3();
		private var halfPos: Vector3  = new Vector3();
		
		private var newQuat:Quaternion = new Quaternion();
		protected static var e:Number = 1e-6;
		public var quatResult:Quaternion = new Quaternion();    // drag结果
		
		private var isDrag:Boolean = false;
		
		static private var xUnitVec3:Vector3 = new Vector3(1, 0, 0);
		static private var yUnitVec3:Vector3 = new Vector3(0, 1, 0);
		static public var tmpVec3:Vector3 = new Vector3();
		
		private var camStartWorldMat:Matrix4x4 = new Matrix4x4();	//开始拖动的时候的矩阵

		// 设置屏幕范围。可以不是方形的，对应的arcball也会变形。
		public function init(w: Number, h: Number):void {
			if (w <= ArcBall.e || h <= ArcBall.e) throw '设置大小不对，不能为0';
			width = w;
			height = h;
		}

		/**
		 * 这是一个 glmatrix中的函数
		 * Sets a quaternion to represent the shortest rotation from one
		 * vector to another.
		 *
		 * Both vectors are assumed to be unit length.
		 *
		 * @param {quat} out the receiving quaternion.
		 * @param {vec3} a the initial vector
		 * @param {vec3} b the destination vector
		 * @returns {quat} out
		 */
		public static function rotationTo(out:Quaternion, a:Vector3, b:Vector3):Quaternion {
			var dot:Number = Vector3.dot(a, b);
			if (dot < -0.999999) {
				Vector3.cross(xUnitVec3, a, tmpVec3);
				if (Vector3.scalarLength( tmpVec3) < 0.000001)
				Vector3.cross(yUnitVec3, a, tmpVec3);
				Vector3.normalize(tmpVec3, tmpVec3);
				Quaternion.createFromAxisAngle(tmpVec3, Math.PI, out);
				return out;
			} else if (dot > 0.999999) {
			  out.elements[0] = 0;
			  out.elements[1] = 0;
			  out.elements[2] = 0;
			  out.elements[3] = 1;
			  return out;
			} else {
				Vector3.cross(a, b, tmpVec3);
				out.elements[0] = tmpVec3.elements[0];
				out.elements[1] = tmpVec3.elements[1];
				out.elements[2] = tmpVec3.elements[2];
				out.elements[3] = 1 + dot;
				out.normalize(out);
				return out;
			}
			return null;
		}	
		
		// 把屏幕空间换成-1,1
		public function normx(x: Number):Number{
			return x * 2 / this.width - 1;
		}
		public function normy(y: Number):Number{
			return -(y * 2 / this.height - 1);
		}

		// 根据屏幕坐标返回一个arcball表面上的位置
		public function hitpos(x: Number, y: Number, out: Vector3):void {
			var x1:Number = this.normx(x);
			var y1:Number = this.normy(y);
			var l:Number = x1 * x1 + y1 * y1;
			var nl:Number = Math.sqrt(l);
			if (l > 1.0) {
				// 在球外面
				out.elements[0] = x1 / nl;   
				out.elements[1] = y1 / nl;   
				out.elements[2] = 0;         
			} else {
				// 在球面上了
				out.elements[0] = x1;        // x
				out.elements[1] = y1;        // z
				out.elements[2] = Math.sqrt(1 - l);  //y
			}
			Vector3.TransformNormal(out, camStartWorldMat, out);
		}
		
		/**
		 * 开始新的拖动。
		 * 以后调用dragTo的时候就不用再计算hitpos了
		 */
		public function setTouchPos(x: Number, y: Number):void {
			this.hitpos(x, y, this.lastPos);
		}

		/**
		 * 返回本次变化的四元数
		 * 累计结果在quatResult中
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function dragTo(x: Number, y: Number):Quaternion {
			hitpos(x, y, curPos);
			// vec3.add(this.halfPos, this.lastPos, this.curPos);
			// vec3.normalize(this.halfPos, this.halfPos);
			// this.quatFromUnitV2V(this.newQuat, this.lastPos, this.halfPos);  //这个函数好像有问题。
			rotationTo(newQuat, lastPos, curPos);
			Quaternion.multiply(newQuat, quatResult, quatResult);
			curPos.cloneTo(lastPos);
			return newQuat;
		}
		
		public function startDrag(x:Number, y:Number, camWorldMatrix:Matrix4x4):void {
			isDrag = true;
			camWorldMatrix.cloneTo(camStartWorldMat );
			setTouchPos(x, y);
		}
		
		public function drag(x:Number, y:Number):void {
			if (isDrag) {
				dragTo(x, y);
			}
		}
		
		public function stopDrag():void {
			isDrag = false;
		}
	}
}
