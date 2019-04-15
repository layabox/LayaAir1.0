package laya.d3Extend.worldMaker {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.utils.Pool;

	/**
	 * ...
	 * @author ...
	 */
	public class CubeInfoArray {
		
		//0是默认
		public static var Add:int = 1;
		public static var Delete:int = 2;
		public static var Updata:int = 3;
		
		public var currentPosindex:int = 0;
		public var PositionArray:Vector.<int> = new Vector.<int>();
		public var currentColorindex:int = 0;
		public var colorArray:Vector.<Number> = new Vector.<Number>();
		
		public var Layar:int = 0;
		
		public var dx:int;
		public var dy:int;
		public var dz:int;
		
		public var sizex:int = 0;
		public var sizey:int = 0;
		public var sizez:int = 0;
		
		public var complete:Function;
		
		public var operation:int = 0;
		
		public function clear():void
		{
			PositionArray.length = 0;
			colorArray.length = 0;
			currentColorindex = currentPosindex = 0;
			dx = dy = dz = 0;
		}
		
		public function CubeInfoArray() {
			
		}
		
		public static function create():CubeInfoArray
		{
			var rs:CubeInfoArray= Pool.getItem("CubeInfoArray");
			return rs||new CubeInfoArray();
		}

		public function dispose():void
		{
			clear();
			//listObject={};
			Pool.recover("CubeInfoArray",this);
		}
		
		public static function recover(cubeinfoArray:CubeInfoArray):void{
			
		}

		public function append(x:int,y:int,z:int,color:int):void{
			PositionArray.push(x,y,z);
			colorArray.push(color);
			listObject[x+","+y+","+z]=color;
		}

		public function find(x:int,y:int,z:int):int
		{
			return listObject[x+","+y+","+z]||-1;
		}

		public function removefind():void{
			listObject={};
		}





		private var listObject:Object = {};
		private var _rotation:Quaternion;
		private var _v3:Vector3;
		public var maxminXYZ:Int32Array;
		
		private var midx:Number;
		private var midy:Number;
		private var midz:Number;
		
		public function setToCube(x:int, y:int, z:int, color:int):void
		{
			PositionArray.push(x, y, z);
			colorArray.push(color);
			if (maxminXYZ[0] < x) maxminXYZ[0] = x;
			if (maxminXYZ[1] > x) maxminXYZ[1] = x;
			if (maxminXYZ[2] < y) maxminXYZ[2] = y;
			if (maxminXYZ[3] > y) maxminXYZ[3] = y;
			if (maxminXYZ[4] < z) maxminXYZ[4] = z;
			if (maxminXYZ[5] > z) maxminXYZ[5] = z;
		}
		
		public function calMidxyz():void
		{
			midx = 0|((maxminXYZ[0] - maxminXYZ[1]) / 2+ maxminXYZ[1]);
			midy =0| ((maxminXYZ[2] - maxminXYZ[3]) / 2 + maxminXYZ[3]);
			midz =0| ((maxminXYZ[4] - maxminXYZ[5]) / 2 + maxminXYZ[5]);
		}
		
		
		public function rotation(x:int =0, y:int =0, z:int =0):void
		{
			if(!x && !y && !z)
				return;
			_rotation = _rotation || new Quaternion();
			_v3 = _v3 || new Vector3();
			if (x != 0)
				x = x / 180 * Math.PI;
			if (y != 0)
				y = y / 180 * Math.PI;
			if (z != 0)
				z = z / 180 * Math.PI;
				
			var positionArray:Vector.<int> = PositionArray;
			var i:int, l:int = positionArray.length;
			
			Quaternion.createFromYawPitchRoll(y,x,z,_rotation);
			for (i = 0; i < l; i += 3)
			{
				
				_v3.setValue(positionArray[i]-midx, positionArray[i + 1]-midy, positionArray[i + 2]-midz);
				Vector3.transformQuat(_v3, _rotation, _v3);
				positionArray[i] = Math.round(_v3.x+midx);
				positionArray[i + 1] = Math.round(_v3.y+midy);
				positionArray[i + 2] = Math.round(_v3.z+midz);
			}
		}
		
		public function scale(x:int = 1, y:int = 1, z:int = 1):void
		{
			console.time("scale");
			var newPositionArray:Vector.<int> =new Vector.<int>();
			var newColorArray:Vector.<Number> =new Vector.<Number>();
			var positionArray:Vector.<int> = PositionArray;
			newPositionArray.length = positionArray.length * x * y * z;
			newColorArray.length = colorArray.length * x * y * z;
			var i:int, l:int = colorArray.length;
			var j:int, p:int, g:int;
			var flag:int = 0;
			for (i = 0; i < l; i++)
			{
				//_v3.setValue(positionArray[i]-midx, positionArray[i + 1]-midy, positionArray[i + 2]-midz);
				//Vector3.transformQuat(_v3, _rotation, _v3);
				//positionArray[i] = Math.round(_v3.x+midx);
				//positionArray[i + 1] = Math.round(_v3.y+midy);
				//positionArray[i + 2] = Math.round(_v3.z+midz);
				var rx:int = positionArray[i*3];
				rx = rx + (rx - midx) * (x - 1);
				var ry:int = positionArray[i*3 + 1];
				ry = ry + (ry - midy) * (y - 1);
				var rz:int = positionArray[i*3 + 2];
				rz = rz + (rz - midz) * (z - 1);
				
				var ncolor:int = colorArray[i];
				for ( j = 0; j < x; j++)
				{
					for ( p = 0; p < y; p++)
					{
						for ( g = 0; g < z; g++)
						{
							//newPositionArray.push(rx + j, ry + p, rz + g);
							
							newPositionArray[flag*3] = rx + j;
							newPositionArray[flag*3+1] = ry + p;
							newPositionArray[flag*3+2] = rz + g;
							//
							newColorArray[flag++] = ncolor;
							//newColorArray.push(ncolor);
						}
					}
				}	
			}
			colorArray = newColorArray;
			PositionArray = newPositionArray;
			console.timeEnd("scale");
			
		}
		
	}

}