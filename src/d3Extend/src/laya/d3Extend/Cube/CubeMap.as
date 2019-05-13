package Cube {

	import laya.d3.math.Vector3;
	import laya.d3Extend.worldMaker.CubeInfoArray;

	
	/**
	 * <code>XYZMap</code> 类用于实现快速查找Map。
	 */
	public class CubeMap {
		public  static const SIZE:int = 3201;
		public static const CUBESIZE:int = 32;
		public static const CUBENUMS:int = 100;

		
		public var data:Object = {};
		public var length:int;

		//保存数组
		private var _fenKuaiArray:Array = [];
		public var xMax:int = 0;
		public var xMin:int = 0;
		public var yMax:int = 0;
		public var yMin:int = 0;
		public var zMax:int = 0;
		public var zMin:int = 0;
		public function CubeMap() {
			clear();
		}
		
	
		public function add(x:int, y:int, z:int, value:*):void {
			//data[y][x * SIZE + z] = value; return;
			//(data[y] || (data[y]=[]))[x * SIZE + z] = value;return;
			//32x32
			
			var key:int = (x >> 5) + ((y >> 5) << 8) + ((z >> 5) << 16);
			//var key:int = (x >> 5) + (y << 3) + (z << 11);
			var o:*= data[key] || (data[key] = {});
			o[x % 32 + ((y % 32) << 8) + ((z % 32) << 16)] = value;
			o.save = null;
			length++;
		}
		
		public function check32(x:int, y:int, z:int):*
		{
			var key:int = (x >> 5) + ((y >> 5) << 8) + ((z >> 5) << 16);
			//var key:int = (x >> 5) + (y << 3) + (z << 11);
			var o:*= data[key] || (data[key] = {});
			o.save = null;
		}
		
		
		public function add2(x:int, y:int, z:int, value:*):void {
			//var key:int = (x >> 5) + ((y >> 5) << 8) + ((z >> 5) << 16);
			data[(x >> 5) + (y << 3) + (z << 11)][x % 32 + ((y % 32) << 8) + ((z % 32) << 16)] = value;
		}
		
		
		public function find(x:int, y:int, z:int):* 
		{
			//return (y >= SIZE)?null:data[y][x * SIZE + z];
			//return (y >= SIZE || !data[y])?null:data[y][x * SIZE + z];
			//32x32
			var key:int = (x >> 5) + ((y >> 5) << 8) + ((z >> 5) << 16);
			var o:*= data[key];
			return o?o[x % 32 + ((y % 32) << 8) + ((z % 32) << 16)]:null;
		}
		
		
		public function remove(x:int, y:int, z:int):void {
			//(y >= SIZE) || (data[y][x * SIZE + z] = null);
			
			//32x32
	
			//if (y)
			//var CubeKey:int = (x / CUBESIZE | 0) + ((y / CUBESIZE | 0) << 8) + ((z / CUBESIZE | 0)<<16);
			var key:int = (x >> 5) + ((y >> 5) << 8) + ((z >> 5) << 16);
			var o:*= data[key];
			if (o)
			{
				var key:int = x % 32 + ((y % 32) << 8) + ((z % 32) << 16);
				if (o[key])
				{
					o[key] = null;
					o.save = null;
				}
			}
			length--;
		}
		
		public function clear():void {
			
			//for (var i:int = 0; i < 3200; i++) data[i] = []; return;
			
			//32x32
			for (var i:String in data) {
				data[i] = {};
			}
			length = 0;

		}
		
		public function saveData():Array
		{
			_fenKuaiArray = [];			
			var cubeinfo:CubeInfo;
			var sz:int, n:int, n2:int;
			var n:int = 0;
						for (var i:String in data) {
							n++;
						}
						console.log('n=', n);
			for (var i:String in data) {
				var o32:*= data[i];
				var o32save:Array=o32.save;
				if (!o32save)
				{
					o32save=o32.save = [];
					for (var j:String in o32)
					{
						cubeinfo = (o32[j] as CubeInfo);
						if(cubeinfo&&cubeinfo.subCube!=null)
							o32.save.push(cubeinfo.x,cubeinfo.y,cubeinfo.z,cubeinfo.color);
					}
				}
				o32save.length>0 && _fenKuaiArray.push( o32save.concat() );
			}
			return _fenKuaiArray;
		}
		
		public function returnData():Array
		{
			//32x32
			var Returnarray:Array = [];
			var array:Array;
			var cubeinfo:CubeInfo;
			for (var i:String in data) 
			{
				array = data[i];
				if (array)
				{
					var sv:Array=[];
					for (var j:String in array) {
						cubeinfo = (array[j] as CubeInfo)
						if(cubeinfo&&cubeinfo.subCube!=null)
						sv.push(cubeinfo.x,cubeinfo.y,cubeinfo.z,cubeinfo.color);
					}
					Returnarray.push(sv);
				}				
			}
			return Returnarray;
		}
		
		public function returnAllCube():Vector.<CubeInfo>
		{
	
			var cubeinfos:Vector.<CubeInfo> = new Vector.<CubeInfo>();
			var cubeinfoo:CubeInfo;
			var array:Array;
			for (var i:String in data) 
			{
				array = data[i];
				if (array)
				{
					for (var j:String in array) {
						cubeinfoo = (array[j] as CubeInfo)
						if(cubeinfoo&&cubeinfoo.subCube!=null)
						{
							if (!(cubeinfoo.backVBIndex ==-1 && cubeinfoo.frontVBIndex ==-1 && cubeinfoo.topVBIndex ==-1 && cubeinfoo.downVBIndex ==-1 && cubeinfoo.leftVBIndex ==-1 && cubeinfoo.rightVBIndex ==-1))
							{
								
								cubeinfos.push(cubeinfoo);
							}
						}
					}
				}				
			}
			return cubeinfos;
		}
		
		
		public function checkColor(colorNum:int):Boolean
		{
			var colorobject:Object = {};
			var nums:int = 0;
			var cubeinfoo:CubeInfo;
			var array:Array;
			for (var i:String in data) 
			{
				array = data[i];
				if (array)
				{
					for (var j:String in array) {
						cubeinfoo = (array[j] as CubeInfo)
						if(cubeinfoo&&cubeinfoo.subCube!=null)
						{
							if (!(cubeinfoo.backVBIndex ==-1 && cubeinfoo.frontVBIndex ==-1 && cubeinfoo.topVBIndex ==-1 && cubeinfoo.downVBIndex ==-1 && cubeinfoo.leftVBIndex ==-1 && cubeinfoo.rightVBIndex ==-1))
							{
								if (!colorobject[cubeinfoo.color])
								{
									//如果没有颜色key
									colorobject[cubeinfoo.color] = 1;
									nums++;
									if (nums > colorNum)
									{
										return true;
									}
								}
							}
						}
					}
				}				
			}
			return false;
		}
		
		public function modolCenter():Vector3
		{
			
			var cubeinfoo:CubeInfo;
			var xmax:int = -9999;
			var xmin:int = 9999;
			var ymax:int = -9999;
			var ymin:int = 9999;
			var zmax:int = -9999;
			var zmin:int = 9999;
			
			var array:Array;
			for (var i:String in data) 
			{
				array = data[i];
				if (array)
				{
					for (var j:String in array) {
						cubeinfoo = (array[j] as CubeInfo)
						if(cubeinfoo&&cubeinfoo.subCube!=null)
						{
							if (cubeinfoo.x > xmax)
							{
								xmax = cubeinfoo.x;
							}
							else
							{
								xmin = Math.min(xmin, cubeinfoo.x);
							}
							if (cubeinfoo.y > ymax)
							{
								ymax = cubeinfoo.y;
							}
							else
							{
								ymin = Math.min(ymin, cubeinfoo.y);
							}
							
							if (cubeinfoo.z > zmax)
							{
								zmax = cubeinfoo.z;
							}
							else
							{
								zmin = Math.min(zmin, cubeinfoo.z);
							}
						}
					}
					
				}				
			}
			xMax = xmax-1600;
			xMin = xmin-1600;
			yMax = ymax-1600;
			yMin = ymin-1600;
			zMax = zmax-1600;
			zMin = zmin-1600;
			cubeinfos = new Vector3((xmax + xmin) / 2-1600, (ymax + ymin) / 2-1600, (zmax + zmin) / 2-1600);
			return cubeinfos;
		}
		
		/*
		public function returnData():Array
		{
			//var Returnarray:Array = new Array();
			//var array:Array;
			//var cubeinfo:CubeInfo;
			//for (var i:int = MinHight; i <=MaxHight; i++) {
				//array = data[i];
				//if (array)
				//{
					//for (var key:String in array) 
					//{
						//cubeinfo = ( array[key] as CubeInfo);
						//if(cubeinfo&&cubeinfo.subCube!=null)
						//Returnarray.push(cubeinfo.x,cubeinfo.y,cubeinfo.z,cubeinfo.color);
					//}
				//}
			//}
			//return Returnarray;
			
			//32x32
			var Returnarray:Array = new Array();
			var array:Array;
			var cubeinfo:CubeInfo;
			for (var i:String in data) 
			{
				array = data[i];
				if (array)
				{
					for (var j:String in array) {
						cubeinfo = (array[j] as CubeInfo)
						if(cubeinfo&&cubeinfo.subCube!=null)
						Returnarray.push(cubeinfo.x,cubeinfo.y,cubeinfo.z,cubeinfo.color);
					}
				}
			}
			return Returnarray;
		}		
		
		public function returnCubeInfo():Vector.<CubeInfo>
		{
			//var Returnarray:Vector.<CubeInfo> = new Vector.<CubeInfo>();
			//var array:Array;
			//var cubeinfo:CubeInfo;
			//for (var i:int = MinHight; i <=MaxHight; i++) {
				//array = data[i];
				//if (array)
				//{
					//for (var key:String in array) 
					//{
						//cubeinfo = ( array[key] as CubeInfo);
						//if(cubeinfo&&cubeinfo.subCube!=null)
						//Returnarray.push(cubeinfo);
					//}
				//}
			//}
			//return Returnarray;
			
			
			//32x32
			var Returnarray:Vector.<CubeInfo> = new Vector.<CubeInfo>();
			var array:Array;
			var cubeinfo:CubeInfo;
			for (var i:String in data) 
			{
				array = data[i];
				if (array)
				{
					for (var j:String in array) {
						cubeinfo = (array[j] as CubeInfo)
						if(cubeinfo&&cubeinfo.subCube!=null)
						Returnarray.push(cubeinfo);
					}
				}
			}
			return Returnarray;
		}
		*/
	}

}