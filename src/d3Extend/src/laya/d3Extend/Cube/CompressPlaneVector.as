package Cube 
{
	import laya.d3.math.Color;
	import laya.d3.math.Vector4;
	import laya.d3Extend.vox.VoxFileData;
	import laya.d3Extend.Cube.CompressPlane;
	import laya.d3Extend.Cube.PlaneInfo;
	import test.Interaction_Hold;
	public class CompressPlaneVector {
		/**
		 * face 表示立体空间的六个朝向 front back up down left right(012345)
		 */
		public var face:int;
		public var vecCompressPlane:Vector.<CompressPlane>;
		public var vecLength:int = 0;
		
		public function CompressPlaneVector() {
			face = 0;
			vecCompressPlane = new Vector.<CompressPlane>;
		}
		/**
		 * 
		 * @param	thirdP 是第三分量(xyz其一)，取决于face，
		 * @param	planeInfo(中包含两个分量xyz其二)
		 */
		public function addPlaneInfo(thirdP:int,planeInfo:PlaneInfo):void {
		
			var planeInfoP1:int = planeInfo.p1;
			var planeInfoP2:int = planeInfo.p2;
			var thirdP = thirdP;
			
			var objP1:Object = getCompressAxis(planeInfoP1);
			var objP2:Object = getCompressAxis(planeInfoP2);
			var objP3:Object = getCompressAxis(thirdP);
			var p1Result = objP1.result;
			var p2Result = objP2.result;
			var p3Result = objP3.result;
			var p1Remainder = objP1.remainder;
			var p2Remainder = objP2.remainder;
			var p3Remainder = objP3.remainder;
			planeInfo.setP12(p1Remainder, p2Remainder)
			
			var p1:int = 0; 
			var p2:int = 0;
			var p3:int = 0;
			if (face == 0 || face == 1) {
				p1 = p1Result;
				p2 = p2Result;
				p3 = p3Result;
			}
			else if (face == 2 || face == 3) {
				p1 = p1Result;
				p2 = p3Result;
				p3 = p2Result;
			}
			else {
				p1 = p3Result;
				p2 = p1Result;
				p3 = p2Result;
			}	
			//用CompressPlane的xyz组合key标记唯一的CompressPlane
			var key:String = p1 + "," + p2 + "," + p3;
			
			if (vecCompressPlane[key] == null ) {
				var compressPlane:CompressPlane = new CompressPlane(p1, p2, p3);
				vecCompressPlane[key] = compressPlane;
				vecLength += 1;
				compressPlane.vecPlaneInfo.push(planeInfo);
			}
			else {
				vecCompressPlane[key].vecPlaneInfo.push(planeInfo);
			}
		}
		
		private function getCompressAxis(axis:int):Object {
			var obj:Object = new Object();
			if (axis < 0) {
				axis = -axis;
				var result:int = axis >> 4;
				var remainder:int = -(axis - result * 16);
				result = -result;
				obj.result = result;
				obj.remainder = remainder;
			}
			else {
				var result:int = axis >> 4;
				var remainder:int = axis - result * 16;
				obj.result = result;
				obj.remainder = remainder;
			}
			return obj;	
		}
		
		public function getVertexVector():Vector.<int> {
			var resultVec:Vector.<int> = new Vector.<int>;
			for (compressPlane in vecCompressPlane) {
				var comPlaneVec:CompressPlane = vecCompressPlane[compressPlane];
				var startX:int = comPlaneVec.startX * 16;
				var startY:int = comPlaneVec.startY * 16;
				var startZ:int = comPlaneVec.startZ * 16;
				var vecPlaneInfo:Vector.<PlaneInfo> = comPlaneVec.vecPlaneInfo;
				for (planeIndex in vecPlaneInfo) {
					var plane:PlaneInfo = vecPlaneInfo[planeIndex];
					var color:int = plane.colorIndex;
					if (face == 0 || face == 1) {
						var point1X:int = startX + plane.p1;
						var point1Y:int = startY + plane.p2;
						resultVec.push(point1X);
						resultVec.push(point1Y);
						resultVec.push(startZ);
						resultVec.push(color);
						var point2X:int = point1X + plane.width;
						var point2Y:int = point1Y;
						resultVec.push(point2X);
						resultVec.push(point2Y);
						resultVec.push(startZ);
						resultVec.push(color);
						var point3X:int = point2X;
						var point3Y:int = point2Y + plane.height;
						resultVec.push(point3X);
						resultVec.push(point3Y);
						resultVec.push(startZ);
						resultVec.push(color);
						var point4X:int = point1X;
						var point4Y:int = point3Y;
						resultVec.push(point4X);
						resultVec.push(point4Y);
						resultVec.push(startZ);
						resultVec.push(color);
					}
					else if (face == 2 || face == 3) {
						var point1X:int = startX + plane.p1;
						var point1Z:int = startZ + plane.p2;
						resultVec.push(point1X);
						resultVec.push(startY);
						resultVec.push(point1Z);
						resultVec.push(color);
						var point2X:int = point1X;
						var point2Z:int = point1Z + plane.width;
						resultVec.push(point2X);
						resultVec.push(startY);
						resultVec.push(point2Z);
						resultVec.push(color);
						var point3X:int = point2X + plane.height;
						var point3Z:int = point2Z;
						resultVec.push(point3X);
						resultVec.push(startY);
						resultVec.push(point3Z);
						resultVec.push(color);
						var point4X:int = point3X;
						var point4Z:int = point1Z;
						resultVec.push(point4X);
						resultVec.push(startY);
						resultVec.push(point4Z);
						resultVec.push(color);
					}
					else if (face == 4 || face == 5) {
						var point1Y:int = startY + plane.p1; 
						var point1Z:int = startZ + plane.p2; 
						resultVec.push(point1Y);
						resultVec.push(point1Z);
						resultVec.push(startX);
						resultVec.push(color);
						var point2Y:int = point1Y; 
						var point2Z:int = point1Z + plane.width; 
						resultVec.push(point2Y);
						resultVec.push(point2Z);
						resultVec.push(startX);
						resultVec.push(color);
						var point3Y:int = point2Y + plane.height; 
						var point3Z:int = point2Z; 
						resultVec.push(point3Y);
						resultVec.push(point3Z);
						resultVec.push(startX);
						resultVec.push(color);
						var point4Y:int = point3Y; 
						var point4Z:int = point1Z; 
						resultVec.push(point4Y);
						resultVec.push(point4Z);
						resultVec.push(startX);
						resultVec.push(color);
					}
				}
			}
			
			return resultVec;
		}
		
	}
}