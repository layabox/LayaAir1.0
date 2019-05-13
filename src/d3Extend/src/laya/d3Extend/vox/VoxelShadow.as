package vox {
	import laya.d3.math.Vector3;
	import laya.d3Extend.CubeMeshManager;
	import laya.d3Extend.CubeMeshSprite3D;
	/**
	 *  sh = new VoxelShadow()
	 * sh.initFromData(dt,w,l,h)
	 * sh.addBlock(x,y,z)
	 * sh.delBlock(x,y,z)
	 * sh.lightDir(x,y,z)
	 * sh.inShadow(x,y,z)
	 */
	public class VoxelShadow {
		public var xsize:int = 0;
		private var xsizeBit:int = 0; 	//为了尽量加快定位，采用2的n次方的方法做偏移
		public var ysize:int = 0;
		private var ysizeBit:int = 0;
		public var zsize:int = 0;
		private var zsizeBit:int = 0;
		private var xzsize:int = 0;
		private var xzsizeBit:int = 0;
		
		public var shadowMap:Float32Array;	// 阴影图，每个方向的深度
		public var _lightDir:Vector3 = new Vector3(0, -1, 0);
		public var lightInvLine:VoxelLightRay = new VoxelLightRay();			//反向光线路径，每个xyz记录的是与起点的偏移。不包含起点
		
		public var edgeVoxids:Array = [];	// 没有完全被包住的点
		
		private var voxelData:Uint8Array;	
		public var voxelLight:Uint8Array;
		
		private var lightSphere:VoxelLightSphere = new VoxelLightSphere(1024,100);
		
		// 紧紧包住整个世界的膜
		private var bound_ymin:Uint16Array;	// 格子中的y最小的，比这个还小的地方一定没有方块了
		private var bound_ymax:Uint16Array;
		private var bound_xmin:Uint16Array;
		private var bound_xmax:Uint16Array;
		private var bound_zmin:Uint16Array;
		private var bound_zmax:Uint16Array;
		private var boundFace:Vector.<Uint16Array> = new Vector.<Uint16Array>(6);	//0 xmin 1 xmax, 2 ymin 3 ymax, 4 zmin 5 zmax
		
		private var tmpFaceLight:Array = new Array(6);
		//private var lit2color:Array = new Array(32);
		//
		public function getBitNum(v:int):int {
			if (v === 1) return 0;
			else if (v === 2) return 1;
			else if (v<=4) return 2;
			else if (v <= 8) return 3;
			else if (v <= 16) return 4;
			else if (v <= 32) return 5;
			else if (v <= 64) return 6;
			else if (v <= 128) return 7;
			else if (v <= 256) return 8;
			else if (v <= 512) return 9;
			else if (v <= 1024) return 10;
			else if (v <= 2048) return 11;
			else if (v <= 4096) return 12;
			else if (v <= 8192) return 13;
			else if (v <= 16384) return 14;
			else return Math.ceil(Math.log(v) / Math.log(2));	//TODO 当然不用这个，有个简单的方法
		}
		public function VoxelShadow(xs:int, ys:int, zs:int):void {
			// 大小按照2的n次方对齐。 问题：存在一个超出一点浪费大量空间的问题
			xsizeBit = getBitNum(xs);
			ysizeBit = getBitNum(ys);
			zsizeBit = getBitNum(zs);
			
			xsize = xs;// 1 << xsizeBit;
			ysize = ys;// 1 << ysizeBit;
			zsize = zs;// 1 << zsizeBit;
			xzsize = xsize * zsize;
			xzsizeBit = xsizeBit + zsizeBit;
			voxelData = new Uint8Array(ysize * xzsize);
			voxelLight = new Uint8Array(voxelData.length);
			
			var xmax:int = xsize-1;
			var ymax:int = ysize-1;
			var zmax:int = zsize-1;
			bound_xmin = new Uint16Array(ysize * zsize); bound_xmin.forEach(function(v, i):void { bound_xmin[i] = xmax; } );
			bound_xmax = new Uint16Array(ysize * zsize); bound_xmax.fill(0);
			bound_ymin = new Uint16Array(xsize * zsize); bound_ymin.forEach(function(v, i):void { bound_ymin[i] = ymax; } );
			bound_ymax = new Uint16Array(xsize * zsize); bound_ymax.fill(0);
			bound_zmin = new Uint16Array(xsize * ysize); bound_zmin.forEach(function(v, i):void { bound_zmin[i] = zmax; } );
			bound_zmax = new Uint16Array(xsize * ysize); bound_zmax.fill(0);
			boundFace[0] = bound_xmin; boundFace[1] = bound_xmax;
			boundFace[2] = bound_ymin; boundFace[3] = bound_ymax;
			boundFace[4] = bound_zmin; boundFace[6] = bound_zmax;
			
			//for (var i = 0; i < 32; i++) {
				//lit2color[i] = (i<<10)+(i<<5)+i
			//}
		}
		
		public function pos2id(x:int, y:int, z:int):int {
			/* 在数据大的情况下，这个判断会严重降低速度
			if (true) {	//保护用，如果确认没有问题了，可以关掉以提高效率
				if (x < 0 || x >= xsize || y < 0 || y >= ysize || z < 0 || z >= zsize) {
					throw 'err 70';
				}
			}
			*/
			return x + z * xsize+y * xzsize;
		}
		
		//根据一个0到32的值，返回一个认识的color值。 因为目前只能表示32级亮度
		//public function getColor(lit:int):int {
			//return lit2color[lit];
		//}
		
		public function findEdge():void {
			var ci:int = 0;
			
			// 获取边界信息
			var x:int = 0;
			var y:int = 0;
			var z:int = 0;
			//底面
			for (z = 0; z < zsize; z++) {
				for (x = 0; x < xsize; x++) {
					if(voxelData[pos2id(x,0,z)])
						edgeVoxids.push(x, 0, z);
				}
			}
			//上面
			y = ysize-1;
			for (z = 0; z < zsize; z++) {
				for ( x = 0; x < xsize; x++) {
					if(voxelData[pos2id(x,y,z)])
						edgeVoxids.push(x, y, z);
				}
			}
			//左面
			x = 0;
			for (z = 0; z < zsize; z++) {
				for ( y = 1; y < ysize-1; y++) {	//不要把底面和上面再加一次
					if(voxelData[pos2id(x,y,z)])
						edgeVoxids.push(x, y, z);
				}
			}
			//右面
			x = xsize-1;
			for (z = 0; z < zsize; z++) {
				for ( y = 1; y < ysize-1; y++) {	//不要把底面和上面再加一次
					if(voxelData[pos2id(x,y,z)])
						edgeVoxids.push(x, y, z);
				}
			}
			//前面
			z = zsize-1;
			for (x = 1; x < xsize-1; x++) {			// 不要考虑左右
				for ( y = 1; y < ysize-1; y++) {	//不要把底面和上面再加一次
					if(voxelData[pos2id(x,y,z)])
						edgeVoxids.push(x, y, z);
				}
			}
			//后面
			z = 0;
			for (x = 1; x < xsize-1; x++) {			// 不要考虑左右
				for ( y = 1; y < ysize-1; y++) {	//不要把底面和上面再加一次
					if(voxelData[pos2id(x,y,z)])
						edgeVoxids.push(x, y, z);
				}
			}
			
			//先只考虑去掉外壳的。外壳的一定是边界的。 TODO
			ci += xzsize;//第2层
			for ( y = 1; y < ysize-1; y++) {
				for ( z = 1; z < zsize-1; z++) {
					ci = y * xzsize+z * xsize;
					for ( x = 1; x < xsize-1; x++) {
						var cvid:int = ci + x;
						var cv:int = voxelData[cvid];
						if (cv) {
							if ( !voxelData[cvid + 1] 			// 右
								|| !voxelData[cvid - 1]			// 左
								|| !voxelData[cvid + xsize]		// 前
								|| !voxelData[cvid - xsize]		// 后
								|| !voxelData[cvid + xzsize]	// 上
								|| !voxelData[cvid - xzsize]	// 下
								) { 
									edgeVoxids.push(x, y, z);
							}
						}
					}
				}
			}
		}
		
		public function setBlockEnd():void {
			findEdge();
			// 打印统计信息
			var voxelNum:int = 0;
			var x:int = 0;
			var y:int = 0;
			var z:int = 0;
			var ci:int = 0;
			for ( y = 0; y < ysize; y++) {
				for ( z = 1; z < zsize; z++) {
					for ( x = 1; x < xsize; x++) {
						if (voxelData[ci++] > 0) voxelNum++;
					}
				}
			}
			// 统计可见面
			var faceNum = 0;
			forEachEdge(function(x:int, y:int, z:int) { 
				var cpos:int = pos2id(x, y, z);
				if (x == 0) {
					faceNum++;
					if (!voxelData[cpos + 1]) faceNum++;
				}
				else if (x == xsize-1) {
					faceNum++;
					if (!voxelData[cpos - 1]) faceNum++;
				}
				else {
					if (!voxelData[cpos - 1]) faceNum++;
					if (!voxelData[cpos + 1]) faceNum++;
				}
				
				if (y == 0) {
					faceNum++;
					if (!voxelData[cpos + xzsize]) faceNum++;
				}
				else if (y == ysize-1) {
					faceNum++;
					if (!voxelData[cpos - xzsize]) faceNum++;
				}else {
					if (!voxelData[cpos + xzsize]) faceNum++;
					if (!voxelData[cpos - xzsize]) faceNum++;
				}
				
				if (z == 0) {
					faceNum++;
					if (!voxelData[cpos + xsize]) faceNum++;
				}
				else if ( z == zsize-1) {
					faceNum++;
					if (!voxelData[cpos - xsize]) faceNum++;
				}else {
					if (!voxelData[cpos + xsize]) faceNum++;
					if (!voxelData[cpos - xsize]) faceNum++;
				}
			} );
			
			console.log("世界大小:", xsize, ysize, zsize, ' 总共:', ysize * xzsize);
			console.log("总体素个数:", voxelNum);
			console.log('位于边缘的体素个数:', edgeVoxids.length / 3);			
			console.log("边缘面数:", faceNum, ' 平均每格子可见面:', faceNum /(edgeVoxids.length / 3));
		}
		
		public function setCameraInfo():void {
			
		}
		
		public function setBlock(x:int, y:int, z:int):void {
			voxelData[x + z * xsize + y * xzsize] = 1;
			// 更新包围盒
			var yz:int = y * zsize+z;
			var xy:int = y * xsize+x;
			var xz:int = z * xsize+x;
			if (bound_xmin[yz] > x) bound_xmin[yz] = x;
			if (bound_xmax[yz] < x) bound_xmax[yz] = x;
			if (bound_ymin[xz] > y) bound_ymin[xz] = y;
			if (bound_ymax[xz] < y) bound_ymax[xz] = y;
			if (bound_zmin[xy] > z) bound_zmin[xy] = z;
			if (bound_zmax[xy] < z) bound_zmax[xy] = z;
		}

		//返回值如果>=0则表示遇到边界了
		public function isBound(x:int, y:int, z:int):int {
			var yz:int = y * zsize+z;
			var xy:int = y * xsize+x;
			var xz:int = z * xsize+x;
			if ( x <= bound_xmin[yz] ) return 0;
			if ( x >= bound_xmax[yz] ) return 1;
			if (y <= bound_ymin[xz]) return 2;
			if (y >= bound_ymax[xz]) return 3;
			if (z <= bound_zmin[xy]) return 4;
			if (z >= bound_zmax[xy]) return 5;
			return -1;
		}
		
		//已经出去边界了
		public function isOutBound(x:int, y:int, z:int):int {
			var yz:int = y * zsize+z;
			var xy:int = y * xsize+x;
			var xz:int = z * xsize+x;
			if ( x < bound_xmin[yz] ) return 0;
			if ( x > bound_xmax[yz] ) return 1;
			if (y < bound_ymin[xz]) return 2;
			if (y > bound_ymax[xz]) return 3;
			if (z < bound_zmin[xy]) return 4;
			if (z > bound_zmax[xy]) return 5;
			return -1;
		}
		
		public function isInShadow(x:int, y:int, z:int):Boolean {
			return !canPathEscape(x,y,z,lightInvLine);
		}
		
		/**
		 * 遍历所有的边界点
		 * @param	cb	(x,y,z)
		 */
		public function forEachEdge(cb:Function) {
			var edgeNum:int = edgeVoxids.length / 3;
			var st:int = 0;
			for (var i:int = 0; i < edgeNum; i++) {
				var x:int = edgeVoxids[st++];
				var y:int = edgeVoxids[st++];
				var z:int = edgeVoxids[st++];
				cb(x, y, z);
			}			
		}
		
		public function set lightDir(dir:Vector3):void {
			_lightDir.x = dir.x;
			_lightDir.y = dir.y;
			_lightDir.z = dir.z;
			
			var len:int = 200;
			var ex:int = (-dir.x * len)|0;
			var ey:int = (-dir.y * len)|0;
			var ez:int = ( -dir.z * len) | 0;
			
			lightInvLine.setEnd(ex, ey, ez);
		}
		
		/**
		 * 重新计算阴影图。
		 */
		public function recalcShadowMap(onend:Function):void {
			
		}
		
		/**
		 * 同步重新计算
		 */
		public function reclcShadowMapSync():void {
			
		}
		
		public function setSize(x:int, y:int, z:int) :void{
			
		}
		
		public function getLight(x, y, z, faceid):int {
			return 1;
			return voxelLight[pos2id(x, y, z)]/255;
		}
		
		/**
		 * 直接计算，不需要存储的。
		 * @param	outmesh
		 */
		public function  updateLight1(outmesh:CubeMeshManager):void {
			var maxLitFaceID:int = lightInvLine.maxLitFaceID;
			var faceLight:Array = lightInvLine.faceLight;
			forEachEdge(function(x:int, y:int, z:int) { 
				var posidx:int = pos2id(x, y, z);
				//阴影的影响
				var canLit:Boolean = !isInShadow(x, y, z);
				//输出结果
				for (var fi = 0; fi < 6; fi++) {
					var litface:Boolean = maxLitFaceID == fi;
					outmesh.ChangeOneFaceColor(x, y, z, fi, faceLight[fi]*((canLit&&litface)?1.0:0.5),false);
				}
				
			} );
		}
		
		/**
		 * 当前光线是否能不被遮挡
		 * @param ray 位置偏移数组
		 * @return
		 */
		public function canPathEscape( x:int, y:int, z:int, ray:VoxelLightRay ):Boolean {
			var line:Array = ray.path;
			var lightLen = line.length / 3;
			var cx:int = 0;
			var cy:int = 0;
			var cz:int = 0;
			var maxx:int = xsize-1;
			var maxy:int = ysize-1;
			var maxz:int = zsize-1;
			var cl:int = 0;
			for (var l:int = 0; l<lightLen; l++) {
				cx = x + line[cl++];
				cy = y + line[cl++];
				cz = z + line[cl++];
				if (cx<0||cy<0||cz<0||cx>=maxx||cy>=maxy||cz>=maxz) {
					return true;
				}
				//是否有东西阻挡
				if (voxelData[pos2id(cx, cy, cz)]) {
					return false;
				}
			}
			return true;
		}
		/**
		 * 获取当前点的直接照明效果
		 * @param	x
		 * @param	y
		 * @param	z
		 * @prame  faceLight 	6个面的亮度
		 * @return
		 */
		public function getDirectLight(x:int, y:int, z:int, faceLight:Array):void {
			faceLight.fill(0);
			
			var faceSum:Array = lightSphere.raysContrib;
			var lighte:Float32Array = _lightDir.elements; //注意方向
			var raye:Float32Array;
			// 先直接计算 l = dot(light*ray)* dot(ray*norm) 
			for (var ri:int = 0; ri < lightSphere.rays.length; ri++) {
				var ray:VoxelLightRay = lightSphere.rays[ri];
				raye = ray.dir.elements;
				
				if (canPathEscape(x, y, z, ray)) {
					var dot1:Number = Math.max( -(lighte[0] * raye[0] + lighte[1] * raye[1] + lighte[2] * raye[2]), 0); 	// 光线与采样线的dot
					for (var fi:int = 0; fi < 6; fi++) {
						faceLight[fi] += dot1 * ray.faceLight[fi]/faceSum[fi];
					}
				}
			}
		}
		
		/**
		 * GI
		 * @param	outmesh
		 */
		public function  updateLight2(outmesh:CubeMeshManager):void {
			//先把光照复原
			//voxelLight.fill(0);	// 先设成0
			
			// 第一遍计算
			forEachEdge(function(x:int, y:int, z:int) { 
				//var posidx:int = pos2id(x, y, z);
				getDirectLight(x, y, z, tmpFaceLight);
				
				//输出结果
				for (var fi = 0; fi < 6; fi++) {
					outmesh.ChangeOneFaceColor(x, y, z, fi, tmpFaceLight[fi],false);
				}
			} );
			
			// 第二遍计算
		}
	}
}	