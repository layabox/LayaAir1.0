package laya.d3Extend.worldMaker {
	import laya.d3.math.Vector3;
	public class VoxTriangleFiller {
		
		// 三角形信息的赋值通过直接修改成员变量完成
		private static var SWAPI:int = 6;
		public var v0:Uint32Array = new Uint32Array([0, 0, 0, 0, 0, 0,0]);	// x,y,z,u,v,color,tmp	tmp是用来交换用的
		public var v1:Uint32Array = new Uint32Array([0, 0, 0, 0, 0, 0,0]);
		public var v2:Uint32Array = new Uint32Array([0, 0, 0, 0, 0, 0,0]);
		// 为了操作里面的浮点数:u,v
		public var v0f:Float32Array = new Float32Array(v0.buffer);
		public var v1f:Float32Array = new Float32Array(v1.buffer);
		public var v2f:Float32Array = new Float32Array(v2.buffer);
		
		private static var tmpVec30:Vector3 = new Vector3();
		private static var tmpVec31:Vector3 = new Vector3();
		private static var tmpVec32:Vector3 = new Vector3();
		
		// 包围盒
		private var bbxx:int = 0;
		private var bbxy:int = 0;
		private var bbxz:int = 0;
		
		public var hascolor:Boolean = false;		
		private var fillCB:Function = null; 	// x:int, y:int, z:int, u:Number, v:Number
		private var faceDir:int = 0;			// 0 表示投影到yz,数组中的值为 yzx， 1 投影到xz,数组中的值是xzy, 2 投影到xy,数组中的值是xyz
			
		public function interpolate(min: Number, max: Number, gradient: Number) {
			return min + (max - min) * gradient;
		}

		// y是当前y，pa,pb 是左起始线，pc,pd 是右结束线
		public function processScanLine(y: Number, 
				pa:Uint32Array, fpa:Float32Array, pb: Uint32Array, fpb:Float32Array, 
				pc:Uint32Array, fpc:Float32Array, pd: Uint32Array, fpd:Float32Array): void {
					
			// 水平线的处理，需要考虑谁在左边,
			// papb 可能的水平
			//   pb-----pa
			//   pa
			//   \
			//    \
			//    pb
			//  或者
			//    /pa
			//   /
			//  pb pa-----pb
			// pcpd 可能的水平
			//    pc----pd
			//        pc
			//       /
			//      /
			//      pd
			//  或者
			//     pc
			//      \
			//       \pd
			//   pd---pc
			var gradient1 = pa[1] != pb[1] ? (y - pa[1]) / (pb[1] - pa[1]) :(pa[0] > pb[0]?1:0);	// y的位置，0 在pa， 1在pb
			var gradient2 = pc[1] != pd[1] ? (y - pc[1]) / (pd[1] - pc[1]) :(pc[0] > pd[0]?0:1); // pc-pd

			var sx:int = interpolate(pa[0], pb[0], gradient1) | 0;	// 
			var ex:int = interpolate(pc[0], pd[0], gradient2) | 0;
			var sz:Number = interpolate(pa[2], pb[2], gradient1);	//[2]是被忽略的轴，不一定是z
			var ez:Number = interpolate(pc[2], pd[2], gradient2);
			var su:Number = interpolate(fpa[3], fpb[3], gradient1);
			var eu:Number = interpolate(fpc[3], fpd[3], gradient2);
			var sv:Number = interpolate(fpa[4], fpb[4], gradient1);
			var ev:Number = interpolate(fpc[4], fpd[4], gradient2);
			
			var x:int = 0;
			var stepx:Number = ex !=sx?1 / (ex - sx):0;
			var kx:Number = 0;
			var cz:int = sz;
			switch (faceDir) {
			case 0://yzx x是y，y是z，z是x
				for (x = sx; x <= ex; x++) {
					cz = (interpolate(sz, ez, kx) ) | 0;
					fillCB(cz, x, y, interpolate(su, eu, kx), interpolate(sv, ev, kx));
					kx += stepx;
				}
				break;
			case 1://xzy 即 x是x，y是z， z是y
				for (x = sx; x <= ex; x++) {
					cz = (interpolate(sz, ez, kx) ) | 0;
					fillCB(x, cz, y, interpolate(su,eu,kx), interpolate(sv,ev,kx));
					kx += stepx;
				}
				break;
			case 2://xyz x是x，y是y，z是z
				for (x = sx; x <= ex; x++) {
					cz = (interpolate(sz, ez, kx) ) | 0
					fillCB(x, y, cz, interpolate(su,eu,kx), interpolate(sv,ev,kx));
					kx += stepx;
				}
				break;
				default:
			}
		}

		/**
		 *  问题： 只用一个方向填充总是会有漏洞
		 * @param	cb
		 */
		public function fill1(cb:Function):void {
			fillCB = cb;
			
			// 计算面的法线，确定忽略那个轴
			var e1e:Float32Array = tmpVec30.elements;
			var e2e:Float32Array = tmpVec31.elements;
			e1e[0] = v1[0] - v0[0];
			e1e[1] = v1[1] - v0[1];
			e1e[2] = v1[2] - v0[2];
			e2e[0] = v2[0] - v0[0];
			e2e[1] = v2[1] - v0[1];
			e2e[2] = v2[2] - v0[2];
			Vector3.cross(tmpVec30, tmpVec31, tmpVec32);
			var v3e:Float32Array = tmpVec32.elements;
			var nx:Number = Math.abs(v3e[0]);
			var ny:Number = Math.abs(v3e[1]);
			var nz:Number = Math.abs(v3e[2]);
			// 化成2d三角形
			var dir:int = 0;
			if (nx >= ny && nx>= nz) {// x轴最长，总体朝向x，忽略x轴
				//zyx
				v0[SWAPI] = v0[0]; v0[0] = v0[2]; v0[2] = v0[SWAPI];
				v1[SWAPI] = v1[0]; v1[0] = v1[2]; v1[2] = v1[SWAPI];
				v2[SWAPI] = v2[0]; v2[0] = v2[2]; v2[2] = v2[SWAPI];
				//yzx
				v0[SWAPI] = v0[0]; v0[0] = v0[1]; v0[1] = v0[SWAPI];
				v1[SWAPI] = v1[0]; v1[0] = v1[1]; v1[1] = v1[SWAPI];
				v2[SWAPI] = v2[0]; v2[0] = v2[1]; v2[1] = v2[SWAPI];
			}else if (ny >= nx && ny>= nz) {// y轴最长
				//xzy
				dir = 1;
				v0[SWAPI] = v0[1]; v0[1] = v0[2]; v0[2] = v0[SWAPI];
				v1[SWAPI] = v1[1]; v1[1] = v1[2]; v1[2] = v1[SWAPI];
				v2[SWAPI] = v2[1]; v2[1] = v2[2]; v2[2] = v2[SWAPI];
			}else {	// z轴最长
				//xyz
				dir = 2;
			}
			faceDir = dir;
			
			fill_2d();
		}
		
		/**
		 * 3个点已经整理好了，只处理xy就行
		 */
		public function fill_2d():void {
			// 三个点按照2d的y轴排序，下面相当于是展开的冒泡排序,p0的y最小
			var temp:Array ;
			if (v0[1] > v1[1]) {
				temp = v1; v1 = v0; v0 = temp;
				temp = v1f; v1f = v0f; v0f = temp;
			}

			if (v1[1] > v2[1]) {
				temp = v1; v1 = v2; v2 = temp;
				temp = v1f; v1f = v2f; v2f = temp;
			}

			if (v0[1] > v1[1]) {
				temp = v1; v1 = v0; v0 = temp;
				temp = v1f; v1f = v0f; v0f = temp;
			}
			
			var y:int = 0;
			var turnDir:Number = (v1[0] - v0[0]) * (v2[1] - v0[1]) - (v2[0] - v0[0]) * (v1[1] - v0[1]);	 
			if (turnDir == 0) {	// 同一条线上
				
			}else if ( turnDir > 0) {// >0 则v0-v2在v0-v1的右边，即向右拐
				// v0
				// -
				// -- 
				// - -
				// -  -
				// -   - v1
				// -  -
				// - -
				// -
				// v2
				for (y = v0[1]; y <= v2[1]; y++) {
					
					if (y < v1[1]) {
						processScanLine(y, v0, v0f, v2, v2f, v0, v0f, v1, v1f);
					}
					else {
						processScanLine(y, v0, v0f, v2, v2f, v1, v1f, v2, v2f);
					}
				}
			}else {	// 否则，左拐
				//       v0
				//        -
				//       -- 
				//      - -
				//     -  -
				// v1 -   - 
				//     -  -
				//      - -
				//        -
				//       v2
				for (y = v0[1]; y <= v2[1]; y++) {
					if (y < v1[1]) {
						processScanLine(y, v0, v0f, v1, v1f, v0, v0f, v2, v2f);
					}
					else {
						processScanLine(y, v1, v1f, v2, v2f, v0, v0f, v2, v2f);
					}
				}
			}
		}
		
		/**
		 * 采用三个方向各扫描一次的方法
		 * @param	cb
		 */
		public function fill(cb:Function):void {
			fillCB = cb;
			//fill_xy();
			faceDir = 2;
			fill_2d();
			
			//fill_xz();
			//xzy
			v0[SWAPI] = v0[1]; v0[1] = v0[2]; v0[2] = v0[SWAPI];
			v1[SWAPI] = v1[1]; v1[1] = v1[2]; v1[2] = v1[SWAPI];
			v2[SWAPI] = v2[1]; v2[1] = v2[2]; v2[2] = v2[SWAPI];
			faceDir = 1;
			fill_2d();

			// 恢复顶点
			v0[SWAPI] = v0[1]; v0[1] = v0[2]; v0[2] = v0[SWAPI];
			v1[SWAPI] = v1[1]; v1[1] = v1[2]; v1[2] = v1[SWAPI];
			v2[SWAPI] = v2[1]; v2[1] = v2[2]; v2[2] = v2[SWAPI];
			
			//fill_yz();
			//zyx
			v0[SWAPI] = v0[0]; v0[0] = v0[2]; v0[2] = v0[SWAPI];
			v1[SWAPI] = v1[0]; v1[0] = v1[2]; v1[2] = v1[SWAPI];
			v2[SWAPI] = v2[0]; v2[0] = v2[2]; v2[2] = v2[SWAPI];
			//yzx
			v0[SWAPI] = v0[0]; v0[0] = v0[1]; v0[1] = v0[SWAPI];
			v1[SWAPI] = v1[0]; v1[0] = v1[1]; v1[1] = v1[SWAPI];
			v2[SWAPI] = v2[0]; v2[0] = v2[1]; v2[1] = v2[SWAPI];
			faceDir = 0;
			fill_2d();			
			
		}
	}
}	