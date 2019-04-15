package laya.d3Extend.vox
{
	import laya.d3Extend.Cube.CompressPlane;
	import laya.d3Extend.Cube.CompressPlaneVector;
	import laya.d3Extend.Cube.CubeSprite3D;
	import laya.d3Extend.Cube.PlaneInfo;
	import laya.d3Extend.FileSaver;
	import laya.net.Loader;
	import laya.utils.Byte;
	import laya.utils.Handler;
	
	/**
	 * <code>PlaneFile</code> 类用于读取PlaneFile文件
	 * @author zqx
	 */
	
	//***********lvox格式*********************
	//version："LayaBoxVox001"
	//byte[13] = string("LayaBoxVox001");
	//byte[1] = Uint8();//所有的CompressPlaneVector的数量,固定为6个
	////内容区
	//for(6)
	//{
	// byte[1] = Uint8();  face
	// byte[4] = int32     CompressPlane的数量
	// for(CompressPlane的数量)
	//{
	// byte[2] = Uint16 startX 
	// byte[2] = Uint16 startY 
	// byte[2] = Uint16 startZ
	// byte[2] = Uint16 PlaneInfo的数量
	// for(PlaneInfo的数量)
	//{
	// byte[1] = Uint8() 存储坐标组合（xy,xz,yz）
	// byte[1] = Uint8() 存储宽度和高度组合（wh）
	// byte[1] = Uint8() 存储颜色索引
	//}
	//}
	//}
	//****************************************
	public class PlaneFile{
		private static var _Version:String = "LayaBoxVox001";
		public function PlaneFile(){
		
		}
		
		//导出为lvox格式
		public static function ExportlvoxFile(cubeSprite3d:CubeSprite3D):void{
			var object:Object = new Object();
			var ss:Uint8Array = new Uint8Array(savelvoxfile(cubeSprite3d).buffer);
			FileSaver.saveBlob(FileSaver.createBlob([ss], {}), "PlaneInfo.lvox");
		}
		
		public static function savelvoxfile(cubeSprite3d:CubeSprite3D):Byte{
			var comPVectorVector:Vector.<CompressPlaneVector> = cubeSprite3d._cubeGeometry.comPressCube();
			//创建二进制数组
			//版本号
			var bytearray:Byte = new Byte();
			bytearray.writeUTFString(_Version);
			//CompressPlaneVector的数量
			var ComPlaneVecNum:int = comPVectorVector.length;
			bytearray.writeUint8(ComPlaneVecNum);
			for (var n:int = 0; n < ComPlaneVecNum; n++){
				var comPVector:CompressPlaneVector = comPVectorVector[n];
				//CompressPlaneVector face
				var face:int = comPVector.face;
				bytearray.writeUint8(comPVector.face);
				//CompressPlane的数量
				var vecCompressPlane:Vector.<CompressPlane> = comPVector.vecCompressPlane;
				var compressPlaneNum:int = comPVector.vecLength;
				bytearray.writeUint16(compressPlaneNum);
				
				for (conpIndex in vecCompressPlane) {
					var compressPlane:CompressPlane = vecCompressPlane[conpIndex];
					bytearray.writeUint16(compressPlane.startX);
					bytearray.writeUint16(compressPlane.startY);
					bytearray.writeUint16(compressPlane.startZ);
					var planeInfoVec:Vector.<PlaneInfo> = compressPlane.vecPlaneInfo;
					var planeInfoNum:int = planeInfoVec.length;
					bytearray.writeUint16(planeInfoNum); 
					
					for (var p:int = 0; p < planeInfoNum; p++ ){
						//这里需要注意在存储数据时候，要主要xyz的组合并不是三者全部都需要
						var plane:PlaneInfo = planeInfoVec[p]
						var p1:int = plane.p1;
						var p2:int = plane.p2;
						var xy:int;
						if (face == 0 || face == 1) {
							xy = p1;
							xy = xy << 4;
							xy = (xy |p2);
						}
						else if (face == 2 || face == 3) {
							xy = p1;
							xy = xy << 4;
							xy = (xy | p2);
						}
						else {
							xy = p1;
							xy = xy << 4;
							xy = (xy | p2);	
						}
						bytearray.writeUint8(xy);
						var wh:int = plane.width;
						wh = wh << 4;
						wh = (wh | plane.height);
						bytearray.writeUint8(wh);
						bytearray.writeUint16(plane.colorIndex);
					}
				}
			}
			return bytearray;
		}
		
		//读取lvox
		public static function LoadlVoxFile(Path:String, ReturnCubeInfoArray:Handler):void {
		    //测试
			debugger;
			var comPVectorVector:Vector.<CompressPlaneVector> = new Vector.<CompressPlaneVector>;	
			Laya.loader.load(Path, Handler.create(this, function(arraybuffer:ArrayBuffer):void {
				debugger;
				var offsetx:int = 0;
				var offsety:int = 0;
				var offsetz:int = 0;
				var length:int = 0;
				var bytearray:Byte = new Byte(arraybuffer);
				if (arraybuffer == null){
					throw "Failed to open file for FileStream";
				}
				var versionString:String = bytearray.readUTFString();
				//CompressPlaneVector的数量
			    var ComPlaneVecVecNum:int = bytearray.readUint8(); 
				for (var n:int = 0; n < ComPlaneVecVecNum; n++) {
					var compressPlaneVec:CompressPlaneVector = new CompressPlaneVector;
					var face:int = bytearray.readUint8();
					var compressPlaneNum:int = bytearray.readUint16();
					compressPlaneVec.face = face;

					var vecCompressPlane:Vector.<CompressPlane> = new Vector.<CompressPlane>;
					compressPlaneVec.vecCompressPlane = vecCompressPlane;
					for (var cpn:int = 0; cpn < compressPlaneNum; cpn++) {
						var compressPlane:CompressPlane = new CompressPlane;
						var startX:int = bytearray.readUint16();
						var startY:int = bytearray.readUint16();
						var startZ:int = bytearray.readUint16();
						compressPlane.setValue(startX, startY, startZ);
						
						var planeInfoNum:int = bytearray.readUint16();
						var planeInfoVec:Vector.<PlaneInfo> = new Vector.<PlaneInfo>;
						
						for (var j:int = 0; j < planeInfoNum; j++) {
							var planeInfo:PlaneInfo	= new PlaneInfo;
							//这里需要注意在存储数据时候，要主要xyz的组合并不是三者全部都需要
							if (face == 0 || face == 1) {
								var xy:int = bytearray.readUint8();
								var x:int = xy >> 4 ;
								var y:int = xy & 15;
								planeInfo.p1 = x;
								planeInfo.p2 = y;	
							}
							else if (face == 2 || face == 3) {
								var xz:int = bytearray.readUint8();
								var x:int = xz >> 4;
								var z:int = xz & 15;
								planeInfo.p1 = x;
								planeInfo.p2 = z;	
							}
							else {
								var yz:int = bytearray.readUint8();
								var y:int = yz >> 4;
								var z:int = yz & 15;
								planeInfo.p1 = y;
								planeInfo.p2 = z;	
							}
							var wh:int = bytearray.readUint8();
							var w:int = wh >> 4;
							var h:int = wh & 15;
							planeInfo.width = w;
							planeInfo.height = h;
							var colorIndex:int = bytearray.readUint16();
							planeInfo.colorIndex = colorIndex;
							planeInfoVec.push(planeInfo);
						}
						compressPlane.vecPlaneInfo = planeInfoVec;
						vecCompressPlane.push(compressPlane);
					}

					comPVectorVector.push(compressPlaneVec);	
				}
			}), null, Loader.BUFFER);
		}
	
	}

}