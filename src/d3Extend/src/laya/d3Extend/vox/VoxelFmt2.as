package laya.d3Extend.vox {
	import laya.d3Extend.Cube.CubeSprite3D;
	import laya.utils.Browser;
	import laya.utils.Byte;
	
	/**
	 * 格式：
	 * 	每个xz按照16X16为一段组织。每一段保存的数据可以超出本段
	 */
	public class VoxelFmt2 extends EncodeBase{
		public static var version:int = 4;
		private var datainst:Uint8Array = null; 	//复制的压缩数据。因为要修改，所以复制一下
		private var xsize:int = 0;
		private var ysize:int = 0;
		private var zsize:int = 0;
		private var xzsize:int = 0;
		private var usePal:Boolean = false;
		private var isLocal:Boolean = false;
		private var callBk:Function;
		private var iy:Number;
		// encode3 异步处理相关变量
		private var blockArr:Array; 	// 待处理数据
		private var palColor:Object;
		private var blocki:int  = 0; 	// 异步处理到哪一步了
		private var blockNum:int = 0; 	// 异步处理总量
		
		public var curver:int = 0;
		public static var ZEROPOS:int = 1600;
		public var flagstring:String = 'LayaBoxVox0002';	// 加上长度凑4的整数倍
		
		
		public function VoxelFmt2(encode:Boolean=true,rtnFun:Function=null) :void {
			super(encode);
			callBk = rtnFun;
		}
		
		/**
		 * 返回一个最长的方向和个数。 这时候可能是Uint8Array也可能是Uint16Array, 所以可以直接处理，不用自己合并。
		 * 注意不要越过边界
		 * @param	x
		 * @param	y
		 * @param	z
		 * @return
		 */
		public function getAndRmoveMaxLen(x:int, y:int, z:int):int {
			var ex:int = x + 63;	//每个区域64大小，从下一个开始，所以63。 因为2bit方向6bit长度
			var ey:int = y + 63;
			var ez:int = z + 63; 
			ex = ex > xsize-1?xsize-1:ex;
			ey = ey > ysize-1?ysize-1:ey;
			ez = ez > zsize-1?zsize-1:ez;
			var xlen:int = 0;	// 不算自己重复的次数。这样解码的时候容易
			var ylen:int = 0;
			var zlen:int = 0;
			var i:int = 0;
			var bpos:int = x + z * xsize+y * xzsize;
			var cval:int = datainst[bpos];
			var cpos:int = bpos;
			for (i = x; i < ex; i++) {
				if ( datainst[++cpos] != cval) break;
				xlen++;
			}
			
			if(!isLocal){
				cpos = bpos;
				for (i = y; i < ey; i++) {
					if (datainst[(cpos+=xzsize)] != cval) break;
					ylen++;
				}
				
				cpos = bpos;
				for ( i = z; i < ez; i++) {
					if (datainst[(cpos+=xsize)] != cval) break;
					zlen++;
				}
			}
			
			// 清理数据，返回结果。 当前位置不用清理，因为不会反向查找
			cpos = bpos;
			if (xlen >= ylen && xlen >= zlen) {
				for (i = x; i < x + xlen; i++) {
					datainst[++cpos] = 0;
				}
				return xlen;
			}
			if (ylen >= xlen && ylen >= zlen) {
				for (i = y; i < y + ylen; i++) {
					cpos += xzsize;
					datainst[cpos] = 0;
				}
				return (1<<6)|ylen;
			}
			if (zlen >= xlen && zlen >= ylen) {
				for (i = z; i < z + zlen; i++) {
					cpos += xsize;
					datainst[cpos] = 0;
				}
				return (2<<6)|zlen;
			}
			return 0;
		}
		
		/**
		 * 处理一个16x16的平面块
		 * 这个数据块可能是一个局部块。xoff，yoff，zoff表示这个相对全局的位置。 xyz是局部块内的位置
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	xoff	
		 * @param	yoff
		 * @param	zoff
		 */
		// 
		public function encodeAArea(x:int, y:int, z:int, xoff:int=0, yoff:int=0, zoff:int=0):void {
			// x:uint16, y:uint16, z:uint16, datasz:uint16, data:buffer
			// data:{offx:4,offz:4, dir:2, repeat:6, color:byte}[]
			needSize(1024);	//随意大一点 >16*16*3+8
			dataPos = ((dataPos + 1) >> 1) << 1;	// 按照2对齐。
			var curU16Pos:int = dataPos >> 1;
			uint16Data[curU16Pos++] = x + xoff;
			uint16Data[curU16Pos++] = z + zoff;
			uint16Data[curU16Pos++] = y + yoff;
			dataPos += 6;
			var dataSizePos:int = dataPos; dataPos += 2;		// 先占着位置
			var zmax:int = Math.min(zsize, z + 16);
			var xmax:int = Math.min(xsize, x + 16);
			var offx:int = 0;
			var offz:int = 0;
			var y1:int = y * xzsize;
			for (var cz:int = z; cz < zmax; cz++) {
				offx = 0;
				var cp:int = x + cz * xsize+y1;
				for (var cx:int = x; cx < xmax; cx++) {
					var val:int = datainst[cp++];
					//问题怎么表示不存在。先用0表示把
					if(val!=0){
						var dt:int = getAndRmoveMaxLen(cx, y, cz);
						uint8Data[dataPos++] = (offx << 4) | offz;
						uint8Data[dataPos++] = dt;
						if(usePal)
							uint8Data[dataPos++] = val;
						else {
							uint8Data[dataPos++] = val&0xff;
							uint8Data[dataPos++] = (val>>>8);
						}
					}
					offx++;
				}
				offz++;
			}
			dataView.setUint16(dataSizePos, (dataPos-dataSizePos-2),true);	//-2 是因为保存大小所占的不算，只要纯数据
		}
		
		/**
		 * 压缩数据。
		 * @param	pal  调色板数据。如果没有的话，表示数据是16位的。调色板只有rgb没有alpha
		 * @param	data {Uint8Array|uint16Array}	格子数组。大小是 xsize*ysize*zsize 字节。 每个字节保存的是调色板索引。
		 * @param	xsize  data的x方向的大小
		 * @param	ysize
		 * @param	zsize
		 * @return
		 */
		public function encode(blockarr:Array, pal:ArrayBuffer , data:Uint8Array,  xsize:int, ysize:int, zsize:int, minx:int=0, miny:int=0, minz:int=0, isLocal:Boolean=false):ArrayBuffer {
			this.isLocal = isLocal;
			this.xsize = xsize;
			this.ysize = ysize;
			this.zsize = zsize;
			xzsize = xsize * zsize;
			// 标识
			var str:Vector.<String> = flagstring.split('') as Vector.<String>;
			var strlen:int = str.length;
			dataView.setUint16(0, strlen,true);
			dataPos = 2;
			for (var i:int = 0; i < strlen; i++){
				dataView.setUint8(dataPos ++, str[i].charCodeAt(0));
			}
			// 版本号
			dataView.setUint32(dataPos,version);
			dataPos += 4;
			// 调色板
			dataView.setUint32(dataPos, pal?pal.byteLength:0);	// 调色板大小是byte
			dataPos += 4;
			if(pal){
				if (pal.byteLength != 256 * 3) throw 'palette size error';
				appendBuffer( pal);
				usePal = true;
			}
			
			if (data.length != xsize * ysize * zsize )
				throw "data size error";
				
			// 数据
			dataView.setInt16(dataPos, minx); dataPos += 2;
			dataView.setInt16(dataPos, miny); dataPos += 2;
			dataView.setInt16(dataPos, minz); dataPos += 2; 
			
			dataView.setUint16(dataPos, xsize); dataPos += 2;
			dataView.setUint16(dataPos, ysize); dataPos += 2;
			dataView.setUint16(dataPos, zsize); dataPos += 2; 
			
			if (usePal) {
				datainst = new Uint8Array(xsize * ysize * zsize);
				datainst.set(data);
			}
			else {
				datainst = new Uint16Array(xsize * ysize * zsize);
				datainst.set( new Uint16Array(data.buffer,0,data.length));
			}
			
			
			var x:int = 0;
			var y:int = 0;
			var z:int = 0;
			
			this.iy = 0;
			if(callBk){
				Laya.timer.frameLoop(1, this, _encode);
			}else {
				for (var y=0; y < ysize; y++) {
					for (var z:int=0; z < zsize; z += 16) {
						for (var x:int=0; x < xsize; x += 16) {
							// 当前处理一个xz 16x16的块
							encodeAArea(x, y, z);
						}
					}
				}
				return dataBuffer.slice(0, dataPos);
			}
		}
		
		private function _encode():void
		{
			var tm:Number = Browser.now();
			for (;  iy < ysize; iy++) {
				for (var z:int=0; z < zsize; z += 16) {
					for (var x:int=0; x < xsize; x += 16) {
						// 当前处理一个xz 16x16的块
						encodeAArea(x, iy, z);
					}
				}
				if ( (Browser.now() - tm) >= 20)
				{
					iy++;
					break;
				}
			}
			if (this.callBk && iy ===ysize)
			{
				this.callBk.call(null, new Byte(dataBuffer.slice(0, dataPos)));
				Laya.timer.clear(this, _encode);
			}
		}
		
		/**
		 * 按照32x32x32分块来压缩，这样可以避免内存太大的问题
		 * 
		 * @param	arr 分块数组，每个元素又是一个数组，{x,y,z,color}[][]
		 * @return
		 */
		public function encode3(arr:Array, local:Boolean, usePal:Boolean = true):ArrayBuffer {
			blockArr = arr;
			var minx:int = Number.MAX_VALUE;
			var miny:int = Number.MAX_VALUE;
			var minz:int = Number.MAX_VALUE;
			var maxx:int = 0;
			var maxy:int = 0; 
			var maxz:int = 0;
			
			this.usePal = usePal;
			this.isLocal = local;
			xsize = ysize = zsize = 32;	// 这个不再表示实际大小，只是一个32x32x32块的大小。因为有的函数需要这个变量，例如 encodeAArea 所以模拟一下
			xzsize = 32 * 32;
			var x:int, y:int, z:int;
			
			// 标识
			var str:Vector.<String> = flagstring.split('') as Vector.<String>;
			var strlen:int = str.length;
			dataView.setUint16(0, strlen,true);
			dataPos = 2;
			for (var i:int = 0; i < strlen; i++){
				dataView.setUint8(dataPos ++, str[i].charCodeAt(0));
			}
			// 版本号
			dataView.setUint32(dataPos,version);
			dataPos += 4;
			
			var i:int = 0;
			var ci:int = 0;
			console.time('handl color and size');
			// 收集颜色信息
			if(usePal){
				var pal256:Uint8Array = new Uint8Array(256 * 3);
				var colors:Array = [];	// 原始颜色。TODO 调色板生成改成直接使用 palColor
				palColor = { };
				palColor[0] = 1;
				var palCount:int = 1;
				for (var bi:int = 0; bi < arr.length; bi++) {
					var cb:Array = arr[bi];//一个块
					var cnum:int = cb.length / 4;	//x,y,z,color
					ci = 0;
					for (i = 0; i < cnum; i++) {
						x = cb[ci++];
						y = cb[ci++];
						z = cb[ci++];
						if (minx > x) minx = x;
						if (miny > y) miny = y;
						if (minz > z) minz = z;
						if (maxx < x) maxx = x;
						if (maxy < y) maxy = y;
						if (maxz < z) maxz = z;
						
						var col:int = cb[ci++];
						//colors.push(b,g,r);
						var statc:Array = palColor[col];
						if (!statc) {
							if(palCount<256){
								var r:int=((col>>>10)&0x1f);// 存的时候颜色暗点也没事
								var g:int=((col>>>5)&0x1f);
								var b:int=(col&0x1f);
								var pst:int = palCount * 3;
								pal256[pst] = b; 
								pal256[pst + 1] = g;
								pal256[pst + 2] = r;
							}
							palColor[col] =[palCount++,1]; //idx, count, 以后调色板算法会改idx
						}else {
							statc[1]++;	// 增加统计个数
						}
					}
				}			
				// 生成调色板
				var pal:Uint8Array = pal256;
				if (palCount >= 256){
					var reducer:ColorQuantization_Mediancut = new ColorQuantization_Mediancut();
					pal = reducer.mediancut1(palColor, palCount, 256);
					/*
					for (var col:String in palColor)
						palColor[col] = reducer.getNearestIndex((col & 0x1f), ((col >>> 5) & 0x1f), ((col >>> 10) & 0x1f), pal);
					*/
				}
			}else {
				for (var bi:int = 0; bi < arr.length; bi++) {
					var cb:Array = arr[bi];//一个块
					var cnum:int = cb.length / 4;	//x,y,z,color
					ci = 0;
					for (i = 0; i < cnum; i++) {
						x = cb[ci++];
						y = cb[ci++];
						z = cb[ci++];
						if (minx > x) minx = x;
						if (miny > y) miny = y;
						if (minz > z) minz = z;
						if (maxx < x) maxx = x;
						if (maxy < y) maxy = y;
						if (maxz < z) maxz = z;
						ci++;
					}
				}			
			}
			// 调色板
			dataView.setUint32(dataPos, usePal?pal.byteLength:0,true);	// 调色板大小是byte
			dataPos += 4;
			if(usePal){
				if (pal.byteLength != 256 * 3) throw 'palette size error';
				appendBuffer( pal);
			}
			
			console.timeEnd('handl color and size');			
			console.time('handl data');
			// 记录偏移和大小
			//dataView.setInt16(dataPos, minx-ZEROPOS,true); dataPos += 2;
			//dataView.setInt16(dataPos, miny-ZEROPOS,true); dataPos += 2;
			//dataView.setInt16(dataPos, minz-ZEROPOS,true); dataPos += 2; 
			dataPos += 6;//min值不记录了。
			
			dataView.setUint16(dataPos, maxx-minx+1,true); dataPos += 2;
			dataView.setUint16(dataPos, maxy-miny+1,true); dataPos += 2;
			dataView.setUint16(dataPos, maxz-minz+1,true); dataPos += 2; 
			
			// 构造一个块，以块为单位压缩. TODO 异步
			if (usePal) datainst = new Uint8Array(32 * 32 * 32);
			else datainst = new Uint16Array(32 * 32 * 32) ;
			
			blockNum = arr.length;
			blocki = 0;
			
			if (callBk) {
				Laya.timer.frameLoop(1, this, _encode3Step);
			}
			else {
				while(blocki < blockNum) {
					_encode3Step();
				}
				console.timeEnd('handl data');
				return dataBuffer.slice(0, dataPos);
			}
			return null;
		}
		
		/**
		 * 异步处理函数。一次处理一个块。
		 */
		public function _encode3Step():void {
			var w2:int = 32 * 32;
			//一个块
			var cb:Array = blockArr[blocki++];
			var cnum:int = cb.length / 4;	//x,y,z,color
			// 根据第一个位置确定块的位置。这时候还有1600在
			var stx:int = cb[0] & 0xffe0;
			var sty:int = cb[1] & 0xffe0;
			var stz:int = cb[2] & 0xffe0;
			var ci:int = 0;
			var x:int, y:int, z:int;
			for (var i:int = 0; i < cnum; i++) {
				x = cb[ci++] - stx;
				y = cb[ci++] - sty;
				z = cb[ci++] - stz;
				var col:int =   cb[ci++];
				if(usePal){
					var colidx:int = palColor[col][0];
					datainst[x + z * 32 + y * w2] = colidx;
				}else {
					datainst[x + z * 32 + y * w2] = col;
				}
			}
			// bdata 组成完毕，可以压缩
			for (y=0; y < ysize; y++) {
				for (z =0; z < zsize; z += 16) {
					for (x =0; x < xsize; x += 16) {
						encodeAArea(x, y, z, stx-ZEROPOS, sty-ZEROPOS, stz-ZEROPOS);	
					}
				}
			}
			// 清理块
			datainst.fill(0);
			if (blocki >= blockNum) {
				//完成了
				if (callBk) {
					console.timeEnd('handl data');
					callBk.call(null, new Byte(dataBuffer.slice(0, dataPos)));
					Laya.timer.clear(this, _encode3Step);
				}
			}
		}
		
		public function decode(data:ArrayBuffer, cb:Function):void {
			var dv:DataView = new DataView(data);
			var datapos:int = 0;
			var flag:String='';
			var flaglen:int = dv.getUint16(0,true);
			datapos = 2;
			for (var si:int; si < flaglen; si++) {
				flag += String.fromCharCode(dv.getUint8(datapos++));
			}
			if (flag != flagstring){
				console.error('bad voxel file ');
				return;
			}
			var ver:int = curver = dv.getUint32(datapos);	// 忘了用小头了，一失足啊，还好只一次。
			datapos += 4;
			if (ver <2 ) {
				trace('bad version :'+ver);
				return;
			}
			var le:Boolean = ver >= 4;
			var palLen:int = dv.getUint32(datapos,le);
			datapos += 4;
			var pal:Uint8Array = null;
			if (palLen > 0) {	//TODO 用实际大小
				usePal = true;
				pal = new Uint8Array(data, datapos, 256 * 3);
				cb.cb_setPalette(pal);
				datapos +=  256 * 3;
			}
			
			var minx:int=0, miny:int=0, minz:int=0;
			if (ver >= 3) {
				minx = dv.getInt16(datapos,le); datapos += 2;
				miny = dv.getInt16(datapos,le); datapos += 2;
				minz = dv.getInt16(datapos,le); datapos += 2;
			}
			
			xsize = dv.getUint16(datapos,le); datapos += 2;
			ysize = dv.getUint16(datapos,le); datapos += 2;
			zsize = dv.getUint16(datapos,le); datapos += 2;
			xzsize = xsize * zsize;
			cb.cb_setSize(xsize, ysize, zsize);
			while (datapos < data.byteLength) {
				//base pos
				ver >= 4 && (datapos = (datapos + 1)>>>1<<1);// 版本4以后，数据要按照2对齐
				var xbase:int = dv.getInt16(datapos,le)+minx;	datapos += 2;
				var zbase:int = dv.getInt16(datapos,le)+minz;	datapos += 2;
				var cy:int = dv.getInt16(datapos,le)+miny; datapos += 2;
				//console.log('base', xbase, zbase, cy);
				var areaDataSz:int = dv.getUint16(datapos,le); datapos += 2;	//本区域一共有多少数据
				var areaDV:Uint8Array = new Uint8Array(data, datapos);
				var areaDataPos:int = 0;
				while (areaDataPos < areaDataSz) {
					var off:int = areaDV[areaDataPos++];
					var dtinfo:int = areaDV[areaDataPos++];
					var val:int = areaDV[areaDataPos++];
					var val1:int = 0;
					if (!usePal) {
						val1 = areaDV[areaDataPos++];	//由于没有按照16bit对齐，只能自己处理uint16了
						val += val1 << 8;
					}
					
					var cx:int = xbase+(off >>> 4)+minx;
					var cz:int = zbase+(off & 0xf)+minz;
					var dir:int = dtinfo >>> 6;
					var repeatNum:int = dtinfo & 0x3f;
					//console.log('pos=', datapos + areaDataPos);
					var cpos:int = datapos + areaDataPos;
					if ( cb.cb_addRepeat) {// 优先调用连续添加的接口
						cb.cb_addRepeat(cx, cy, cz, dir, repeatNum, val, cpos);
					}else if (cb.cb_addData) {	// 如果没有连续添加的接口，就调用单个添加的
						cb.cb_addData(cx, cy, cz, val);
						if (repeatNum > 0 ) {
							var ri:int = 0;
							switch(dir) {
							case 0://x
								for (ri = 1; ri <= repeatNum; ri++) {
									cb.cb_addData(cx + ri, cy, cz, val);
								}
								break;
							case 1://y
								for (ri = 1; ri <= repeatNum; ri++) {
									cb.cb_addData(cx, cy+ri, cz, val);
								}
								break;
							case 2://z
								for (ri = 1; ri <= repeatNum; ri++) {
									cb.cb_addData(cx , cy, cz+ri, val);
								}
								break;
							default:
								console.error('addRepeatData bad dir!');
							}
						}
					}
				}
				datapos += areaDataSz;
			}
		}
		
		//cb
		public function cb_setSize(x:int, y:int, z:int):void {
		}
		public function cb_setPalette(pal:Uint8Array):void {
		}
		public function cb_add(x:int, y:int, z:int, value:int):void {
		}
		public function cb_addRepeat(x:int, y:int, z:int, dir:int, num:int, color:int):void {
		}
		//cb
		
		public function getTestData(x:int,y:int,z:int):Uint8Array {
			var ret:Uint8Array = new Uint8Array(x * y * z);
			var ci:int = 0;
			for (var cz:int = 0; cz < z; cz++) {
				for (var cy:int = 0; cy < y; cy++) {
					for (var cx:int = 0; cx < x; cx++) {
						if (cz == 50) ret[ci] = 10;
						else ret[ci] = 0;
						ci++;
					}
				}
			}
			/*
			ret.forEach(function(v:int, i) { 
				ret[i] = 12;
			} );
			*/
			return ret;
		}
	
		public function addRepeatData(x:int, y:int, z:int, dir:int, num:int, val:int):void {
			var pos:int = x + z * xsize+y * xzsize;
			datainst[pos] = val;
			if (num == 0) return;
			var i:int = 0;
			switch (dir) {
				case 0://x
					for (i = 0; i < num; i++) {
						datainst[++pos] = val;
					}
					break;
				case 1://y
					for (i = 0; i < num; i++) {
						datainst[(pos+=xzsize)] = val;
					}
					break;
				case 2://z
					for (i = 0; i < num; i++) {
						datainst[(pos+=zsize)] = val;
					}
					break;
				default:
					console.error('addRepeatData bad dir!');
			}
		}
		
		public function  test():void {
			var data:Uint8Array = getTestData(100, 100, 100);
			//var data:Uint16Array = new Uint16Array( getTestData(100, 100, 100));
			/*
			var data = new Uint16Array([
				51, 205, 218, 95, 79, 216, 107, 131, 
				192, 116, 78, 86, 66, 139, 108, 198, 
				78, 111, 223, 183, 72, 89, 40, 54, 
				128, 202, 23, 23, 101, 237, 210, 83, 
				101, 189, 246, 176, 81, 53, 46, 115, 
				75, 69, 91, 100, 133, 78, 244, 67, 
				78, 186, 109, 78, 155, 105, 58, 241, 
				229, 45, 143, 35, 79, 177, 213, 162]);
			*/	
			/*
			data = new Uint8Array([
				1, 1, 1, 1,
				2, 2, 2, 2,
				3, 3, 3, 3,
				4,4,4,4
			]);
			*/
			debugger;
			var comp:ArrayBuffer = encode(null, new Uint8Array(256*3), data, 100, 100, 100);
			debugger;
			var decompObj:VoxelFmt2 = new VoxelFmt2(false);
			decompObj.decode(comp, { 
				cb_setPalette:function(dt:ArrayBuffer):void{},
				cb_setSize:function (x:int, y:int, z:int):void {
					decompObj.datainst = new Uint8Array(x * y * z);
				},
				// num 0 表示没有重复，
				cb_addRepeat:function(x:int, y:int, z:int, dir:int, num:int, color:int,pos:int):void {
					//console.log('addrepeat', x, y, z, dir, num, color, pos);
					decompObj.addRepeatData( x, y, z, dir, num, color);
				}
			} );
			
			//比较数据
			for (var i:int = 0; i < this.datainst.length; i++) {
				if (data[i] != decompObj.datainst[i]) {
					console.log('err kkkkkkkkkkkk');
					break;
				}
				
			};
		}
	}
}	