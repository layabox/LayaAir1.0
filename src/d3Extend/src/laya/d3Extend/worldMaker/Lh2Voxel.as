package worldMaker {
	import Cube.CubeInfo;
	import Cube.CubeSprite3D;
	import laya.d3.core.MeshFilter;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.d3Extend.worldMaker.CubeInfoArray;
	import laya.utils.Handler;
	import laya.webgl.resource.BaseTexture;
	import vox.ColorQuantization_Mediancut;
	import vox.VoxFileData;
	import laya.webgl.resource.Texture2D;
	import laya.d3Extend.vox.VoxDataCompress;
	
	/**
	 * 使用方法：
	 * 
	 * var lv = new Lh2Voxel();
	 * lv.setModelData(vertices,indices);
	 * 
	 * var ret = lv.renderToPalVoxel(sz, colornum);
	 * 或者
	 * var ret = lv.renderToVoxel(xsize);				
	 * 		这种是不压缩颜色的。
	 *
	 * 如果要打印统计信息：
	 * lv.printDbgInfo();
	 * 
	 * 如果不使用贴图信息：
	 * lv.onlyMtl = true
	 * 
	 */
	
	public class Lh2Voxel {
		public var tempPos:Vector3 = new Vector3();
		public var tempUV:Vector2 =  new Vector2();
		
		private var tmpP0:Vector3 = new Vector3();
		private var tmpP1:Vector3 = new Vector3();
		private var tmpP2:Vector3 = new Vector3();
		
		public var faceIndex:Uint16Array = null;
		public var vertexArray:Array = [];	//[[x,y,z,u,v,Texture2D]]
		public var modelXSize:Number = 0;	//模型包围盒
		public var modelYSize:Number = 0;
		public var modelZSize:Number = 0;
		
		public var gridXSize:int = 0;
		public var gridYSize:int = 0;
		public var gridZSize:int = 0;
		
		public var gridSize:Number = 0.1;	//每个小方格的大小。单位是米
		
		private var tmpGridPos:Array = [0, 0, 0];
					
		public static var int32v:Uint32Array = new Uint32Array(1);
		
		private static var sampleCol:Array = [0, 0, 0, 0];
		private var trifiller:VoxTriangleFiller = new VoxTriangleFiller();
		
		public var onlyMtl:Boolean = false;	// 只用材质中的颜色
		// 统计信息
		private var duration_setModelData:int = 0;
		
		
		/**
		 * 设置模型数据。
		 * 
		 * @param	vertData 顶点数组。每个顶点又是一个数组。[x,y,z,u,v,texture2D][]
		 * 			其中的 texture2D可以是一个数组，直接表示颜色,[r,g,b], rgb范围是0~1
		 * @param	index	索引数组，例如 [0,1,2]
		 */
		public function setModelData( vertData:Array, index:Array) {
			console.time('setmodeldata');
			this.vertexArray = vertData.concat();
			vertData = this.vertexArray;
			
			var minx:Number = 10000; var maxx:Number = -10000;
			var miny:Number = 10000; var maxy:Number = -10000;
			var minz:Number = 10000; var maxz:Number = -10000;
			
			//计算包围盒
			for ( var vi = 0; vi < vertData.length; vi++) {
				var cvert:Array = vertData[vi];
				if (minx > cvert[0]) minx = cvert[0];
				if (miny > cvert[1]) miny = cvert[1];
				if (minz > cvert[2]) minz = cvert[2];
				if (maxx < cvert[0]) maxx = cvert[0];
				if (maxy < cvert[1]) maxy = cvert[1];
				if (maxz < cvert[2]) maxz = cvert[2];
			}
			modelXSize = maxx - minx;
			modelYSize = maxy - miny;
			modelZSize = maxz - minz;
			
			//移动到正象限
			for ( var vi = 0; vi < vertData.length; vi++) {
				var cvert:Array = vertData[vi];
				cvert[0] -= minx;
				cvert[1] -= miny;
				cvert[2] -= minz;
			}
			
			faceIndex = index;
			console.timeEnd('setmodeldata');
		}
		
		public function pos2GridId(x:Number, y:Number, z:Number) {
			//先计算x,y,z
			var xi:int = (x / gridSize) | 0;
			var yi:int = (y / gridSize) | 0;
			var zi:int = (z / gridSize) | 0;
			if (xi >= gridXSize) xi = gridXSize-1;
			if (yi >= gridYSize) yi = gridYSize-1;
			if (zi >= gridZSize) zi = gridZSize-1;
			/*
			if (xi >= gridXSize || yi >= gridYSize || zi >= gridZSize) {
				alert('格子数太少，至少要 ', +Math.max(xi, yi, zi));
				throw 'err';
			}
			*/
			//再计算id。如果要修改坐标系，在这里改
			return xi + zi * gridXSize + yi * gridXSize * gridZSize;
		}

		// 能恢复gridxyz的id
		public function pos2GridId1(x:Number, y:Number, z:Number) {
			if (x > 1023 || y > 1023 || z > 1023) {
				alert('最大不能超过1024');
			}
			//先计算x,y,z
			var xi:int = (x / gridSize) | 0;
			var yi:int = (y / gridSize) | 0;
			var zi:int = (z / gridSize) | 0;
			//console.log('grid', xi, yi, zi);
			if (xi >= gridXSize) xi = gridXSize-1;
			if (yi >= gridYSize) yi = gridYSize-1;
			if (zi >= gridZSize) zi = gridZSize-1;
			return xi << 20 | yi << 10 | zi;
		}
		
		/**
		 * 采用最近采样。 注意不要保留返回值，因为是共享的。
		 * @param	tex
		 * @param	u
		 * @param	v
		 * @return
		 */
		public function sampleTexture( tex:Texture2D, u:Number, v:Number):Array {
			if (!tex) return [255, 255, 255, 255];
			if (tex is Array) return [tex[0]*255,tex[1]*255,tex[2]*255,255];
			var x:int = ((tex.width * u) | 0) % tex.width;	
			var y:int = ((tex.height * v) | 0) % tex.height;
			var dt:Uint8Array = tex.getPixels();
			var st:int = (x + y * tex.width) * 4;
			sampleCol[0] = dt[st];
			sampleCol[1] = dt[st + 1];
			sampleCol[2] = dt[st + 2];
			sampleCol[3] = dt[st + 3];
			return sampleCol;
		}
		
		//rgba。0~255
		static public function colorToU16(colorArr:Array):Number {
			Lh2Voxel.int32v[0] =  ((colorArr[2]>>>3) << 10) | ((colorArr[1]>>>3) << 5) | (colorArr[0]>>>3);
			return Lh2Voxel.int32v[0];
		}
		
		static public function colorToU32(colorArr:Array):Number {
			Lh2Voxel.int32v[0] =  (colorArr[2] << 16) | (colorArr[1] << 8) | colorArr[0];
			return Lh2Voxel.int32v[0];
		}
		
		//rgba。0~1
		static public function color1ToU16(colorArr:Array):Number {
			Lh2Voxel.int32v[0] =  ((colorArr[2]*255>>>3) << 10) | ((colorArr[1]*255>>>3) << 5) | (colorArr[0]*255>>>3);
			return Lh2Voxel.int32v[0];
		}
		
		/**
		 * 返回是一个三维数组，每个里面是rgba的数组
		 * @param	xsize	水平分成多少格子
		 * @return 返回 {x:number,y:number,z:number,color:Number[]}[]
		 */
		public function renderToVoxel1(xsize:int):Array {
			console.log('modelsize ', modelXSize, modelYSize, modelZSize);
			if (xsize <= 0) xsize = 1;
			gridSize = (modelXSize+0.1) / xsize;	// 避免点正好在边界
			gridXSize = xsize;
			gridYSize = Math.max( Math.ceil( modelYSize / gridSize),1);
			gridZSize = Math.max( Math.ceil(modelZSize / gridSize), 1);
			
			var ret1:Array = [];		//x,y,z,color
			var ret:Array = [];			//三维数组
			
			console.time('格子化');
			var faceNum:int = faceIndex.length / 3;
			var smpPos:Array = [];
			var smpUV:Array = [];
			for ( var fi = 0; fi < faceNum; fi++) {
				//取出纹理对象
				var vert:Array = vertexArray[faceIndex[fi * 3]];	
				//三个顶点的贴图必然一致。只取第一个就行了
				var tex:Texture2D = vert[5];
				if (typeof(tex) !== 'object') {
					//有错误，没有贴图。如果打印会不会弄死浏览器
				}
				getSamplePoints(fi, smpPos, smpUV);
				var ptnum:int = smpPos.length / 3;
				var cp:int = 0;
				for ( var pi = 0; pi < ptnum; pi++) {
					//所属的格子
					var gridid = pos2GridId1(smpPos[cp++], smpPos[cp++], smpPos[cp++]);
					//取出颜色
					var col:Array = sampleTexture( tex, smpUV[pi << 1], smpUV[(pi << 1) + 1]);
					var curcoldt:Array = ret[gridid];
					if (!curcoldt)  ret[gridid] = [col[0], col[1], col[2], col[3], 1];
					else {
						curcoldt[0] += col[0];
						curcoldt[1] += col[1];
						curcoldt[2] += col[2];
						//curcoldt[3] += col[3];
						curcoldt[4]++;	// 多少个点
					}
				}
			}
			console.timeEnd('格子化');
			console.time('求平均值-输出');
			var gridnum:int = 0;
			var repeatNum:int = 0;
			//整理结果，每个格子只保留平均值
			for ( var posid:String in ret) {
				var colsum:Array = ret[posid];
				var rsum:int = colsum[0];
				var gsum:int = colsum[1];
				var bsum:int = colsum[2];
				var cnum:int = colsum[4];
				gridnum++;
				repeatNum += cnum;
				ret1.push( { x:posid>>>20, y:(posid>>10)&0x3ff, z:posid&0x3ff, color:[(rsum/cnum)|0,(gsum/cnum)|0,(bsum/cnum)|0,255] } );
			}
			console.timeEnd('求平均值-输出');
			console.log('gridnum=', gridnum, '每个格子重复度:', (repeatNum / gridnum) );
			return ret1;
		}
		
		/**
		 * 把当前对象保存的模型数据转换成格子信息。
		 * @param	xsize
		 * @return  返回一个对象数组 {x:number,y:number,z:number, color:number[]}[]  表示在什么位置有什么颜色。
		 */
		public function renderToVoxel(xsize:int):Array {
			return renderToVoxel2(xsize);
			console.log('modelsize ', modelXSize, modelYSize, modelZSize);
			if (xsize <= 0) xsize = 1;
			gridSize = (modelXSize+0.1) / xsize;	// 避免点正好在边界
			gridXSize = xsize;
			gridYSize = Math.max( Math.ceil( modelYSize / gridSize),1);
			gridZSize = Math.max( Math.ceil(modelZSize / gridSize), 1);
			
			var ret1:Array = [];		//x,y,z,color
			var ret:Array = [];			//三维数组
			
			console.time('格子化');
			var faceNum:int = faceIndex.length / 3;
			var smpPos:Array = [];
			var smpUV:Array = [];
			for ( var fi = 0; fi < faceNum; fi++) {
				var fidSt:int = fi * 3;
				//取出纹理对象
				var vert0:Array = vertexArray[faceIndex[fidSt]];	
				//三个顶点的贴图必然一致。只取第一个就行了
				var tex:Texture2D = vert0[5];
				//if (typeof(tex) !== 'object') {
					//有错误，没有贴图。如果打印会不会弄死浏览器
				//}
				// 针对所有的采样点
				var x0 = vert0[0];
				var y0 = vert0[1];
				var z0 = vert0[2];
				var u0 = vert0[3]; 
				var v0 = vert0[4]; 
				
				var vert1:Array = vertexArray[faceIndex[fidSt+1]];
				var x1 = vert1[0];
				var y1 = vert1[1];
				var z1 = vert1[2];
				var u1 = vert1[3]; 
				var v1 = vert1[4]; 

				var vert2:Array = vertexArray[faceIndex[fidSt+2]];
				var x2 = vert2[0];
				var y2 = vert2[1];
				var z2 = vert2[2];
				var u2 = vert2[3]; 
				var v2 = vert2[4]; 
			
				//e1
				var e1x:Number = x1 - x0;
				var e1y:Number = y1 - y0;
				var e1z:Number = z1 - z0;
				var e1len:Number = Math.sqrt(e1x * e1x + e1y * e1y + e1z * e1z);
				//e2
				var e2x:Number = x2 - x0;
				var e2y:Number = y2 - y0;
				var e2z:Number = z2 - z0;
				var e2len:Number = Math.sqrt(e2x * e2x + e2y * e2y + e2z * e2z);
				//console.log('len=', e1len, e2len);
				
				var du1:Number = u1 - u0;
				var dv1:Number = v1 - v0;
				var du2:Number = u2 - u0;
				var dv2:Number = v2 - v0;
				
				var sampleK:Number = 1.1;
				
				var sampleK_gridsize = sampleK / gridSize;
				var smpUNum:int = Math.ceil(e1len * sampleK_gridsize);
				var stepU:Number = 1.0 / smpUNum;
				var smpVNum:int = Math.ceil(e2len * sampleK_gridsize);
				var stepV:Number = 1.0 / smpVNum;
				for ( var cu:Number = 0; cu < 1.0; cu += stepU) {
					var vEnd:Number = 1 - cu;	// 只要三角形，所以v的取值范围是1-u
					for (var cv:Number = 0; cv < vEnd; cv += stepV) {
						var smpx:Number = x0 + e1x * cu + e2x * cv;
						var smpy:Number = y0 + e1y * cu + e2y * cv;
						var smpz:Number = z0 + e1z * cu + e2z * cv;
						var smpu:Number = u0 + du1 * cu + du2 * cv;	// TODO有的不用
						var smpv:Number = v0 + dv1 * cu + dv2 * cv;
						
						// 处理这个采样点
						var gridid:int = pos2GridId1(smpx, smpy, smpz);
						var col:Array = sampleTexture(tex, smpu, smpv);//[cu*255,cv*255,0,255];//
						
						var curcoldt:Array = ret[gridid];
						if (!curcoldt)  ret[gridid] = [col[0], col[1], col[2], col[3], 1];
						else {
							curcoldt[0] += col[0];
							curcoldt[1] += col[1];
							curcoldt[2] += col[2];
							//curcoldt[3] += col[3];
							curcoldt[4]++;	// 多少个点
						}
					}
				}
			}
			console.timeEnd('格子化');
			console.time('求平均值-输出');
			//整理结果，每个格子只保留平均值
			var gridnum:int = 0;
			var repeatNum:int = 0;
			for ( var posid:String in ret) {
				var colsum:Array = ret[posid];
				var rsum:int = colsum[0];
				var gsum:int = colsum[1];
				var bsum:int = colsum[2];
				var cnum:int = colsum[4];
				gridnum++;
				repeatNum += cnum;
				ret1.push( { x:posid>>>20, y:(posid>>10)&0x3ff, z:posid&0x3ff, color:[(rsum/cnum)|0,(gsum/cnum)|0,(bsum/cnum)|0,255] } );
			}
			console.timeEnd('求平均值-输出');
			console.log('gridnum=', gridnum, '每个格子重复度:', (repeatNum / gridnum) );
			return ret1;
		}
	
		public function renderToVoxel2(xsize:int):Array {
			console.log('modelsize ', modelXSize, modelYSize, modelZSize);

			if (xsize <= 0 || !xsize) {
				xsize = modelXSize;
			}
			gridSize = modelXSize / xsize;
			
			trifiller.gridw = gridSize;
			gridXSize = Math.max( Math.ceil( xsize),1);
			gridYSize = Math.max( Math.ceil( modelYSize / gridSize),1);
			gridZSize = Math.max( Math.ceil(modelZSize / gridSize), 1);
			
			var ret1:Array = [];		//x,y,z,color
			var ret:Array = [];			//三维数组
			
			console.time('格子化');
			var faceNum:int = faceIndex.length / 3;
			var gridnum:int = 0;
			var fidSt:int = 0;
			for ( var fi = 0; fi < faceNum; fi++) {
				//取出纹理对象
				var vert0:Array = vertexArray[faceIndex[fidSt++]];	
				var vert1:Array = vertexArray[faceIndex[fidSt++]];
				var vert2:Array = vertexArray[faceIndex[fidSt++]];
				//三个顶点的贴图必然一致。只取第一个就行了
				var tex:Texture2D = vert0[5];
				//if (typeof(tex) !== 'object') {
					//有错误，没有贴图。如果打印会不会弄死浏览器
				//}
				trifiller.v0[0] = (vert0[0] / gridSize+0.5) | 0;
				trifiller.v0[1] = (vert0[1] / gridSize+0.5) | 0;
				trifiller.v0[2] = (vert0[2] / gridSize+0.5) | 0;
				trifiller.v0f[3] = vert0[3];
				trifiller.v0f[4] = vert0[4];
				
				trifiller.v1[0] = (vert1[0] / gridSize+0.5) | 0;
				trifiller.v1[1] = (vert1[1] / gridSize+0.5) | 0;
				trifiller.v1[2] = (vert1[2] / gridSize+0.5) | 0;
				trifiller.v1f[3] = vert1[3];
				trifiller.v1f[4] = vert1[4];
				
				trifiller.v2[0] = (vert2[0] / gridSize+0.5) | 0;
				trifiller.v2[1] = (vert2[1] / gridSize+0.5) | 0;
				trifiller.v2[2] = (vert2[2] / gridSize+0.5) | 0;
				trifiller.v2f[3] = vert2[3];
				trifiller.v2f[4] = vert2[4];
				
				// TODO 现在的uv其实是不对的，应该根据重心坐标重新计算
				trifiller.fill(function(x:int, y:int, z:int, u:Number, v:Number) {
					var gridid:int =  x << 20 | y << 10 | z;
					var col:Array =  sampleTexture(tex, u, v);//[u*255,v*255,0,255];//
					var curcoldt:Array = ret[gridid];
					if (!curcoldt) {
						ret[gridid] = [col[0], col[1], col[2], 255, 1];
						gridnum++;
					}
					else {
						curcoldt[0] += col[0];
						curcoldt[1] += col[1];
						curcoldt[2] += col[2];
						//curcoldt[3] += col[3];
						curcoldt[4]++;	// 多少个点
					}
				});
			}
			console.timeEnd('格子化');
			console.time('求平均值-输出');
			ret1.length = gridnum;
			gridnum = 0;
			var repeatNum:int = 0;
			//整理结果，每个格子只保留平均值
			//var keys:Array = Object.keys(ret);
			for ( var posid:String in ret) {
				var colsum:Array = ret[posid];
				var rsum:int = colsum[0];
				var gsum:int = colsum[1];
				var bsum:int = colsum[2];
				var cnum:int = colsum[4];
				repeatNum += cnum;
				ret1[gridnum++] = { x:posid >>> 20, y:(posid >> 10) & 0x3ff, z:posid & 0x3ff, color:[(rsum / cnum) | 0, (gsum / cnum) | 0, (bsum / cnum) | 0, 255] } ;
				//ret1.push( );
			}
			console.timeEnd('求平均值-输出');
			console.log('gridnum=', gridnum, '每个格子重复度:', (repeatNum / gridnum) );
			return ret1;
		}
		
		
		//这个不需要了。转voxel都用原色就行
		/**
		 * 
		 * @param	xsize  		x方向上的格子数量，根据包围盒可以知道每个格子的大小。
		 * @param	colorNum	颜色数。现在都是256就行。
		 * @return
		 */
		public function renderToPalVoxel(xsize:int, colorNum:int=256):Object {
			var ret:Array = renderToVoxel(xsize);
			console.time('renderToPalVoxel计算调色板');
			var i:int = 0;
			// 统计所有的颜色
			var origColor:Uint8Array = new Uint8Array(ret.length * 4);
			for (i = 0; i < ret.length; i++) {
				var colarr:Array = ret[i].color;
				origColor[i * 4] = colarr[0] | 0;
				origColor[i * 4 + 1] = colarr[1] | 0;
				origColor[i * 4 + 2] = colarr[2] | 0;
				origColor[i * 4 + 3] = 255;
			}
			// 转成调色板
			var reducer:ColorQuantization_Mediancut = new ColorQuantization_Mediancut();
			var pal:Uint8Array = reducer.mediancut(origColor, colorNum);
			var idxRet:Uint8Array = new Uint8Array(ret.length);
			// 获得原始颜色的索引
			for (i = 0; i < ret.length; i++) {
				var colarr:Array = ret[i].color;
				var r:int = colarr[0] | 0;
				var g:int = colarr[1] | 0;
				var b:int = colarr[2] | 0;
				var idx:int = reducer.getNearestIndex(r, g, b, pal);
				idxRet[i] = idx;
				// TEST 原始颜色转成调色板颜色
				colarr[0] = pal[idx * 3];
				colarr[1] = pal[idx * 3 + 1];
				colarr[2] = pal[idx * 3 + 2];
			}
			console.timeEnd('renderToPalVoxel计算调色板');
			return {palcolor:ret, pal:pal,idx:idxRet};
		}
		
		/**
		 * 采样一个三角形，返回位置和uv。返回的是一个数组，根据三角形的面积返回不同的采样个数
		 * @param	id  面id
		 * @param	outPos
		 * @param	outUV
		 */
		public function getSamplePoints(id:int, outPos:Array, outUV:Array):void {
			if (!outPos) outPos = [];
			if (!outUV) outUV = [];
			outPos.length = 0;
			outUV.length = 0;
			var fidSt:int = id * 3;
			var vid = faceIndex[fidSt];
			var x0 = vertexArray[vid][0];
			var y0 = vertexArray[vid][1];
			var z0 = vertexArray[vid][2];
			var u0 = vertexArray[vid][3]; 
			var v0 = vertexArray[vid][4]; 
			
			vid = faceIndex[fidSt+1];
			var x1 = vertexArray[vid][0];
			var y1 = vertexArray[vid][1];
			var z1 = vertexArray[vid][2];
			var u1 = vertexArray[vid][3]; 
			var v1 = vertexArray[vid][4]; 

			vid = faceIndex[fidSt+2];
			var x2 = vertexArray[vid][0];
			var y2 = vertexArray[vid][1];
			var z2 = vertexArray[vid][2];
			var u2 = vertexArray[vid][3]; 
			var v2 = vertexArray[vid][4]; 
		
			//e0
			tmpP0.x  = x1 - x0;
			tmpP0.y  = y1 - y0;
			tmpP0.z  = z1 - z0;
			
			//e1
			tmpP1.x = x2 - x0;
			tmpP1.y = y2 - y0;
			tmpP1.z = z2 - z0;
			
			Vector3.cross(tmpP0, tmpP1, tmpP2);
			var area:Number = Vector3.scalarLength(tmpP2);
			var k:int = 12;	//每单位面积的随机次数
		
			var smpleNum = (area / gridSize / gridSize * k) | 0 + 1;	//最少1个
			var du1:Number = u1 - u0;
			var dv1:Number = v1 - v0;
			var du2:Number = u2 - u0;
			var dv2:Number = v2 - v0;
			for (var i = 0; i < smpleNum; i++) {
				var u:Number = Math.random();			//
				var v:Number = Math.random()*(1-u);		// 问题 这样可能不均匀
				var px:Number = x0 + tmpP0.x * u + tmpP1.x * v;
				var py:Number = y0 + tmpP0.y * u + tmpP1.y * v;
				var pz:Number = z0 + tmpP0.z * u + tmpP1.z * v;
				outPos.push(px, py, pz);
				outUV.push(
					u0 + du1 * u + du2 * v,
					v0 + dv1 * u + dv2 * v);
			}
		}
		
		/// 辅助函数
		/**
		 * 转换一个lh文件
		 * @param	f
		 * @param sz	x方向的格子的个数
		 * @param cb	完成的回调函数， cb(arr:CubeInfoArray)
		 */
		public function loadLH(f:String, sz:int, cb:Function):void {
			// 先不支持贴图 TODO
			onlyMtl = true;
			
			Sprite3D.load( f, Handler.create(null, function(sprite:Sprite3D):void{
				var arr:Array = new Array();
				ParseSprite3D(sprite, arr);
				var vertex:Array = [];
				var index:Array = [];
				var vnum = 0;
				for ( var vi = 0; vi < arr.length; vi++) {
					vertex = vertex.concat( arr[vi].vertexData);
					var ib:Uint16Array = arr[vi].indexData;
					var tindex:Array = [];	
					ib.forEach(function(v:int, i:int) { 
						tindex[i] = v + vnum;
					} );
					index = index.concat(tindex);
					vnum += arr[vi].vertexData.length;
				}
				
				var carr:CubeInfoArray = toVoxel(vertex, index, sz);
				cb && cb(carr);
			}));
			
		}
		
		public function toVoxel(verteices:Array, indices:Array, sz:int):CubeInfoArray {
			setModelData(verteices, indices);
			var i:int = 0;
			var ret:Array = renderToVoxel(sz);
			var carr:CubeInfoArray  = CubeInfoArray.create();
			for (i = 0; i < ret.length; i++) {
				var o:Object = ret[i];
				//cubeMeshSprite3D.AddCube(o.x, o.y, o.z, Lh2Voxel.colorToU32(o.color),0);
				carr.append(o.x, o.y, o.z, Lh2Voxel.colorToU32(o.color));
			}
			return carr;
		}
		
		private function ParseSprite3D(sprite:Sprite3D, arr:Array):void{
			if (sprite is MeshSprite3D){
				arr.push(ParseMeshSprite3D(sprite));
			}
			var numChildren = sprite.numChildren;
			for (var i = 0; i < numChildren; i++){
				var mp:Sprite3D = sprite.getChildAt(i) as Sprite3D;
				ParseSprite3D(mp, arr);
			}
		}
		
		private function ParseMeshSprite3D(meshsprite:MeshSprite3D):Array{
			var data:Object = {};
			var resultArray:Array = new Array();
			data.vertexData = resultArray;
			//meshsprite.meshRenderer.sharedMaterials
			var altexture:BaseTexture =(meshsprite.meshRenderer && meshsprite.meshRenderer.sharedMaterial)?(meshsprite.meshRenderer.sharedMaterial).albedoTexture:null;
			
			var mf:MeshFilter = meshsprite.meshFilter as MeshFilter;
			var mh:Mesh = mf.sharedMesh as Mesh;
			
			var mypositions:Vector.<Vector3> = mh._getPositions();
			var uvs:Vector.<Vector2> = new Vector.<Vector2>();
			var indices:Uint16Array = mh._indexBuffer.getData();
			data.indexData = indices;
			var transformWorldMatrix:Matrix4x4 = meshsprite.transform.worldMatrix;
			
			//得到所有的subMesh
			var subMeshes:Vector.<SubMesh> = mh._subMeshes;
			//得到所有的材质
			var sharedMaterials:Vector.<BaseMaterial> =  meshsprite.meshRenderer.sharedMaterials;
			//得到所有的texture
			var subTextures:Array = new Array();
			for (var m = 0; m < sharedMaterials.length; m++){
				subTextures.push((sharedMaterials[m] as BlinnPhongMaterial).albedoTexture);
			}
			
			var i:int, j:int, vertexBuffer:VertexBuffer3D, uvElement:VertexElement, vertexElements:Array, vertexElement:VertexElement, ofset:int, verticesData:Float32Array;
			var vertexBufferCount:int = mh._vertexBuffers.length;
			
			for (i = 0; i < vertexBufferCount; i++){
				vertexBuffer = mh._vertexBuffers[i];
				vertexElements = vertexBuffer.vertexDeclaration.vertexElements;
				for (j = 0; j < vertexElements.length; j++){
					vertexElement = vertexElements[j];
					if (vertexElement.elementFormat === VertexElementFormat.Vector2 && vertexElement.elementUsage === VertexMesh.MESH_TEXTURECOORDINATE0){
						uvElement = vertexElement;
						break;
					}
				}
				
				verticesData = vertexBuffer.getData();
				for (j = 0; j < verticesData.length; j += vertexBuffer.vertexDeclaration.vertexStride / 4){
					ofset = j + uvElement.offset / 4;
					uvs.push(new Vector3(verticesData[ofset + 0], verticesData[ofset + 1]));
				}
				
			}
			
			var pointCount:int = mypositions.length;
			for (var k:int = 0; k < pointCount; k++){
				var resultVector:Vector3 = new Vector3();
				Vector3.transformV3ToV3(mypositions[k], transformWorldMatrix, resultVector);
				resultArray[k] = [resultVector.x, resultVector.y, resultVector.z, uvs[k].x, uvs[k].y, altexture];
			}
			
			for (var m:int = 0; m < subMeshes.length; m++) {
				var indexStart:int = subMeshes[m]._indexStart;
				var indexCount:int = subMeshes[m]._indexCount;
				var mtl:BlinnPhongMaterial = (sharedMaterials[m] as BlinnPhongMaterial);
				var mtlcolor:Array = [mtl._ColorR, mtl._ColorG, mtl._ColorB];
				for (var ii:int = 0; ii < indexCount; ii++) {
					resultArray[indices[ii + indexStart]][5] = onlyMtl?mtlcolor:subTextures[m];
				}
			}
			return data;
		}
		
	}
}