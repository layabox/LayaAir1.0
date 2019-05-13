package Cube {
	
	/**
	 * <code>CubeInfo</code> 类用于实现方块信息(也可能是点)。
	 */
	public class CubeInfo {
		
		/**@private */
		public static var _aoFactor:int = 0.85;
		public static var aoFactor:Vector.<Number> = new Vector.<Number>();
		/**@private */
		//用来存储所有的情况
		public static var Objcect0down:Array =/*[STATIC SAFE]*/ new Array(256);//5,6,7
		public static var Objcect0front:Array =/*[STATIC SAFE]*/ new Array(256);//3,6,7
		public static var Objcect0right:Array =/*[STATIC SAFE]*/ new Array(256);//3,7,5
		
		public static var Objcect1down:Array =/*[STATIC SAFE]*/ new Array(256);//4,6,7
		public static var Objcect1left:Array =/*[STATIC SAFE]*/ new Array(256);//2,4,6
		public static var Objcect1front:Array =/*[STATIC SAFE]*/ new Array(256);//2,6,7
		
		public static var Objcect2down:Array =/*[STATIC SAFE]*/ new Array(256);//4,5,7
		public static var Objcect2back:Array =/*[STATIC SAFE]*/ new Array(256);//1,4,5
		public static var Objcect2right:Array =/*[STATIC SAFE]*/ new Array(256);//1,5,7
		
		
		public static var Objcect3down:Array =/*[STATIC SAFE]*/ new Array(256);//4,5,6
		public static var Objcect3left:Array =/*[STATIC SAFE]*/ new Array(256);//0,4,6
		public static var Objcect3back:Array =/*[STATIC SAFE]*/ new Array(256);//0,4,5
		
		public static var Objcect4up:Array =/*[STATIC SAFE]*/ new Array(256);//1,2,3
		public static var Objcect4front:Array =/*[STATIC SAFE]*/ new Array(256);//7,3,2
		public static var Objcect4right:Array =/*[STATIC SAFE]*/ new Array(256);//1,3,7
		
		public static var Objcect5up:Array =/*[STATIC SAFE]*/ new Array(256);//0,2,3
		public static var Objcect5left:Array =/*[STATIC SAFE]*/ new Array(256);//0,2,6
		public static var Objcect5front:Array =/*[STATIC SAFE]*/ new Array(256);//2,3,6
		
		public static var Objcect6up:Array =/*[STATIC SAFE]*/ new Array(256);//0,1,3
		public static var Objcect6back:Array =/*[STATIC SAFE]*/ new Array(256);//0,1,5
		public static var Objcect6right:Array =/*[STATIC SAFE]*/ new Array(256);//1,3,5
		
		public static var Objcect7up:Array =/*[STATIC SAFE]*/ new Array(256);//0,1,2
		public static var Objcect7back:Array =/*[STATIC SAFE]*/ new Array(256);//0,1,4
		public static var Objcect7left:Array =/*[STATIC SAFE]*/ new Array(256);//0,2,4
		
		public static var PanduanWei:Int32Array =/*[STATIC SAFE]*/ new Int32Array([1, 2, 4, 8, 16, 32, 64, 128]);
		/**@private */
		public static const MODIFYE_NONE:int = 0;
		/**@private */
		public static const MODIFYE_ADD:int = 1;
		/**@private */
		public static const MODIFYE_REMOVE:int = 2;
		/**@private */
		public static const MODIFYE_UPDATE:int = 3;
		/**@private */
		public static const MODIFYE_UPDATEAO:int = 4;
		/**@private */
		public static const MODIFYE_UPDATEPROPERTY:int = 5;
		/**@private */
		//24个点到底根据面的索引再到点的索引
		public var frontFaceAO:Int32Array = new Int32Array([0, 0, 0, 0, 0, 0]);
		
		/**@private */
		public static var _pool:Array = [];
		
		//选择画框的线的index
		public var selectArrayIndex:Vector.<int> = new Vector.<int>();
		
		
		/**
		 * @private
		 */
		public static function create(x:int, y:int, z:int):CubeInfo {
			if (_pool.length) {
				var cube:CubeInfo = _pool.pop();
				cube.x = x;
				cube.y = y;
				cube.z = z;
				cube.modifyFlag = MODIFYE_NONE;
				cube.frontVBIndex = -1;
				cube.backVBIndex = -1;
				cube.leftVBIndex = -1;
				cube.rightVBIndex = -1;
				cube.topVBIndex = -1;
				cube.downVBIndex = -1;
				cube.point = 0;
				cube.subCube = null;
				return cube;
			} else {
				return new CubeInfo(x, y, z);
			}
		}
		
		/**
		 * @private
		 */
		public static function recover(cube:CubeInfo):void {

			if (cube)
			{
				if (cube is CubeInfo)
				{
					_pool.push(cube);
				}
			}
			
		}
		
		/**@private [同步状态]*/
		public var subCube:SubCubeGeometry;
		/**@private 非同步状态,属于哪个SubCubeGeometry*/
		public var updateCube:SubCubeGeometry;
		/**@private */
		public var x:int;
		/**@private */
		public var y:int;
		/**@private */
		public var z:int;
		/**@private [同步状态]*/
		public var color:int;
		/**@private 点遮挡信息[同步状态]*/
		public var point:int;
		/**@private */
		public var modifyFlag:int = MODIFYE_NONE;//1
		/**@private */
		public var frontVBIndex:int = -1;
		/**@private */
		public var backVBIndex:int = -1;
		/**@private */
		public var leftVBIndex:int = -1;
		/**@private */
		public var rightVBIndex:int = -1;
		/**@private */
		public var topVBIndex:int = -1;
		/**@private */
		public var downVBIndex:int = -1;
		/**@private */
		public var modifyIndex:int = -1;
		/**@private */
		public var cubeProperty:int = 999;
		
		public function CubeInfo(_x:int, _y:int, _z:int) {
			x = _x;
			y = _y;
			z = _z;
		}
		
		/**
		 * @private
		 */
		public function update():void {
			updateCube.updatePlane(this);//更新面、颜色、AO相关数据
		}
		
		public function clearAoData():void
		{
			frontFaceAO[0] = 0;
			frontFaceAO[1] = 0;
			frontFaceAO[2] = 0;
			frontFaceAO[3] = 0;
			frontFaceAO[4] = 0;
			frontFaceAO[5] = 0;
			
		}
		
		//初始化的时候传值
		public static function Cal24Object():void {
			
			for (var j:int = 0; j < 4; j++) {
				aoFactor[j] = Math.pow(_aoFactor, j);
				
			}
			CalOneObjectKeyValue(Objcect0down, 5, 6, 7);
			CalOneObjectKeyValue(Objcect0front, 3, 6, 7);
			CalOneObjectKeyValue(Objcect0right, 3, 5, 7);
			
			CalOneObjectKeyValue(Objcect1down, 4, 6, 7);
			CalOneObjectKeyValue(Objcect1left, 2, 4, 6);
			CalOneObjectKeyValue(Objcect1front, 2, 6, 7);
			
			CalOneObjectKeyValue(Objcect2down, 4, 5, 7);
			CalOneObjectKeyValue(Objcect2back, 1, 4, 5);
			CalOneObjectKeyValue(Objcect2right, 1, 5, 7);
			
			CalOneObjectKeyValue(Objcect3down, 4, 5, 6);
			CalOneObjectKeyValue(Objcect3left, 0, 4, 6);
			CalOneObjectKeyValue(Objcect3back, 0, 4, 5);
			
			CalOneObjectKeyValue(Objcect4up, 1, 2, 3);
			CalOneObjectKeyValue(Objcect4front, 7, 3, 2);
			CalOneObjectKeyValue(Objcect4right, 1, 3, 7);
			
			CalOneObjectKeyValue(Objcect5up, 0, 2, 3);
			CalOneObjectKeyValue(Objcect5left, 0, 2, 6);
			CalOneObjectKeyValue(Objcect5front, 2, 3, 6);
			
			CalOneObjectKeyValue(Objcect6up, 0, 1, 3);
			CalOneObjectKeyValue(Objcect6back, 0, 1, 5);
			CalOneObjectKeyValue(Objcect6right, 1, 3, 5);
			
			CalOneObjectKeyValue(Objcect7up, 0, 1, 2);
			CalOneObjectKeyValue(Objcect7back, 0, 1, 4);
			CalOneObjectKeyValue(Objcect7left, 0, 2, 4);
		
		}
		
		private static function CalOneObjectKeyValue(array:Array, Wei1:int, Wei2:int, Wei3:int):void {
			
			for (var i:int = 0; i < 256; i++) {
				var num:int = 0;
				if ((i & PanduanWei[Wei1]) != 0) num++;
				if ((i & PanduanWei[Wei2]) != 0) num++;
				if ((i & PanduanWei[Wei3]) != 0) num++;
				array[i] = num;
			}
		}
		
		//判断点的某个Cube是否存在
		//存在返回1，不存在返回-1
		public function calDirectCubeExit(Wei:int):int {
			return ((point & PanduanWei[Wei]) != 0) ? 1 : -1;
		}
		
		public function getVBPointbyFaceIndex(faceIndex:int):int {
			switch (faceIndex) {
			case 0: 
				return frontVBIndex;
				break;
			case 1: 
				return rightVBIndex;
				break;
			case 2: 
				return topVBIndex;
				break;
			case 3: 
				return leftVBIndex;
				break;
			case 4: 
				return downVBIndex;
				break;
			case 5: 
				return backVBIndex;
				break;
			default:
				return -1;
			}
		}
		
		public function returnColorProperty():int
		{
			var ss:int = color & 0xff000000 >> 24;
			return ss;
		}
		
		
		
		public function ClearSelectArray():void
		{
			selectArrayIndex.length = 0;
		}
	
	}
}
