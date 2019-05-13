package vox {
	/**
	 * voxel data压缩对象。
	 * 只能处理12x12x12的数据，如果不满足这个前提，请重新实现。
	 */
	public class VoxDataCompress {
		public var first:Boolean=true;
		public var curmem:int=4*1024;
		public var dataBuffer:ArrayBuffer; 
		public var dataView:DataView = null;
		private var uint8Data:Uint8Array = null;
		public var dataPos:int = 0;
		private var compressedData:ArrayBuffer=null;
		
		public var curx:Number=0;     //当前到什么格子位置了，增加顺序是 x,z,y
		public var cury:Number=0;
		public var curz:Number=0;
		public var curData:Array = [];

		public static var MAXPOS:int = 15;
		
		private var dataChanged:Boolean = true;
		private var voxdata:Array;		//完整的数据。setData存到这里，压缩的时候用来按照固定顺序扫描
		private var voxDataWidth:int = 12; //体素边长
		
		//head
		public static var version:int=1;
		public var dataByte:int=2;      // 颜色数据目前是2，但是以后可能是4。

		//操作指令固定占4bit，剩下4bit可以表示数据。由于限制格子为12*12，所以4bit可以直接表示绝对位置
		public static var OP_DATA:int  = 0;     // 余下的4个bit是连续个数，这期间不再检查op。这个会导致x增加
		public static var OP_ADD_X:int = 1;    	// 余下的4个bit是偏移量。
		public static var OP_RESET_X:int = 2; 	// 
		public static var OP_ADD_Z:int  = 3; 	// 
		public static var OP_RESET_Z:int = 4; 	//
		public static var OP_ADD_Y:int  = 5;    //
		public static var OP_SET_POS:int = 6;   // 后面跟着x,y,z
		
		
		/**
		 * 
		 * @param	read 是否是解码
		 */
		public function VoxDataCompress(size:int=12) {
			voxDataWidth = size;
			voxdata = new Array(size*size*size);
			dataBuffer = new ArrayBuffer(curmem);   //先分配这么多
			dataView = new DataView(dataBuffer);
			dataView.setUint16(0, version);
			dataView.setUint16(2, dataByte);
			uint8Data = new Uint8Array(dataBuffer);
			dataPos+=4;
		}
		

		// 要保证还有s这么大的空间
		private function needSize(s:Number):void{
			if(dataPos+s>curmem){
				expMem(s);
			}
		}

		private function expMem(s:Number):void{
			var expsz:Number = Math.max(s,4*1024);
			var buf:ArrayBuffer = new ArrayBuffer(this.curmem+expsz);
			this.curmem += expsz;
			//copy
			var olddt:Uint8Array = uint8Data;
			uint8Data = new Uint8Array(buf);
			uint8Data.set( olddt );
			this.dataView = new DataView( buf );
			this.dataBuffer = buf;
		}
		
		//解码
		public static function decodeData(data:ArrayBuffer, offset:int = 0,length:int =0,onAddData:Function=null):void{
			
			var dt:Uint8Array = new Uint8Array( data,offset,length);
			var dataPos:int = 0;
			var dv:DataView = new DataView(data,offset,length);
			var cx:int = 0;
			var cy:int = 0;
			var cz:int = 0;
			//version
			if (dv.getUint16(0) != version) {
				console.log('not supported voxdata version ');
				return;
			}
			
			//data format
			var dataSz:int = dv.getUint16(2);
			if (dataSz != 2) {
				console.log('not supported voxdata format');
				return;
			}
			dataPos = 4;
			while (dataPos < dt.length) {
				var v:int = dt[dataPos];	
				dataPos++;
				var op:int = v >>> 4;
				var opdata:int = v & 0xf;
				switch( op) {
					case OP_DATA:{
						for (var di:int = 0; di < opdata; di++) {
							if(dataSz==2){
								onAddData && onAddData(cx, cy, cz, dv.getUint16(dataPos));
								dataPos += 2;
							}else {
								onAddData && onAddData(cx, cy, cz, dv.getUint32(dataPos));	
								dataPos += 4;
							}
							cx++;
						}
						if(opdata>0)cx--;	//上面会多加一次。因为必然是先定位
						break;
					}
					case OP_ADD_X:
						cx += opdata;
						break;
					case OP_RESET_X:
						cx = opdata;
						break;
					case OP_ADD_Z:
						cz += opdata;
						break;
					case OP_RESET_Z:
						cz = opdata;
						break;
					case OP_ADD_Y:
						cy += opdata;
						break;
					case OP_SET_POS:{
						cx = opdata;
						var leftdata:int = dv.getUint8(dataPos++);
						cy = leftdata >>> 4;
						cz = leftdata & 0xf;
						break;
					}
					default:
						throw 'unknown op';
				}
			}
		}

		//可以先把数据转成三维数组，然后用扫描的方法保证连续性

		private function op_addx(d:Number):void{
			//if (d > MAXPOS || curx + d > MAXPOS) throw 'err 161';
			//console.log('op_addx', d);
			needSize(1);
			dataView.setUint8(dataPos, (OP_ADD_X<<4)|d);
			dataPos++;
			curx += d;
		}

		//x一定小于保留的bit
		private function op_resetx(x:Number):void{
			//if (x > MAXPOS) throw 'err 115';
			//console.log('op_resetx', x);
			needSize(1);
			dataView.setUint8(dataPos, ( OP_RESET_X<<4) | x);
			dataPos++;
			curx = x;
		}

		private function op_addz(d:Number):void { 
			//if (d > MAXPOS || curz + d > MAXPOS) throw 'err104';
			//console.log('op_addz', d);
			needSize(1);
			dataView.setUint8(dataPos, (OP_ADD_Z << 4) | d);
			dataPos++;
			curz += d;
		}

		private function op_writedata(data:Array):void{
			var len:* = data.length;
			//if (len > MAXPOS) throw 'err154';
			//console.log('op_data', data.length);
			needSize(1 + len * dataByte);
			dataView.setUint8(dataPos, (OP_DATA << 4) | len);
			dataPos += 1;
			for (var di:int = 0; di < len; di++) {
				if (dataByte == 2) {
					dataView.setUint16(dataPos, data[di]);
				}else {
					dataView.setUint32(dataPos, data[di]);
				}
				dataPos += dataByte;
			}
		}

		private function end():void{
			//保存还没处理的数据。
			flushData();
		}

		/**
		 * 添加数据，不可能超出范围。
		 * @param data 
		 */
		private function pushData(data:Number):void{
			curData.push(data);
			if (curData.length > MAXPOS) throw 'err 136';
		}

		private function flushData():void{
			op_writedata(curData);
			curData.length=0;
		}

		private function op_setPos(x:Number, y:Number, z:Number):void {
			//if ( x > MAXPOS || y > MAXPOS || z > MAXPOS ) throw 'err 158';
			//console.log('op_setpos', x, y, z);
			var maxv:Number = Math.max(x, y, z);
			needSize(2);
			dataView.setUint8(dataPos++, (OP_SET_POS << 4) | x);
			dataView.setUint8(dataPos++, (y << 4) | z);
			curx=x;
			cury=y;
			curz=z;
		}

		/**
		 * 添加 short类型的数据。 要求按照约定的顺序添加数据，即先遍历x,然后z,y
		 * 不允许在相同的位置添加多次数据。
		 * @param x 
		 * @param y 
		 * @param z 
		 * @param data 
		 */
		public function addDataU16(x:Number, y:Number, z:Number, data:Number):void {
			if (data === 0) data = 1;
			voxdata[x + z * voxDataWidth + y * voxDataWidth * voxDataWidth] = data;
			dataChanged = true;
		}
		
		private function _fetchData(x:Number, y:Number, z:Number, data:Number):void {
			if(first){
				first=false;
				op_setPos(x,y,z)
			}
			var dx:int = x-curx;   // 可以>=< 0
			var dz:int = z-curz;   // 可以>=< 0
			var dy:int = y-cury;   // 可以>= 0
			// 只考虑dz,dy的话，一共有6中组合
			if(dy===0 && dz===0){//只有x变化
				if( dx===0 ||dx===1){
					//=0是刚调了setPos
					pushData(data);
					curx += dx;
				}else if(dx<0){
					//不可能。yz不变，x一定增加
					throw 'err dx<0';
				}
				else {
					//x产生了间隔
					flushData();
					op_addx(dx);
					pushData(data);
				}
			}else {
				//dy，dz不为0，则必然不在一行了。
				flushData();
				// 分成有没有跨层两类
				if( dy>0){
					//跨层了。 dz可以>=<0
					op_setPos(x, y, z);
				}else{
					//dy=0没有跨层. dz可以><0
					op_resetx(x);
					op_addz(dz);
				}
				pushData(data);
			}
		}
		
		public function compress():void {
			dataPos = 4;
			curx = cury = curz = 0;
			first = true;
			curData.length = 0;
			
			var i:int = 0;
			for ( var y:int = 0; y < voxDataWidth; y++) {
				for (var z:int = 0; z < voxDataWidth; z++) {
					for ( var x:int = 0; x < voxDataWidth; x++) {
						var dt:* = voxdata[i++];
						dt && _fetchData(x, y, z, dt);
					}
				}
			}
			end();
			compressedData =  this.dataBuffer.slice(0,dataPos);
		}

		/**
		 * 获取结果，以便扩展
		 */
		public function getDataBuffer():ArrayBuffer {
			if (dataChanged) {
				compress();
			}
			dataChanged = false;
			return compressedData;
		}
		
		public function testSaveBig():void {
			
		}
		
		public function testLoad():void {
			
		}
	}
}