package laya.ani.bone
{
	import laya.ani.bone.canvasmesh.MeshData;
	import laya.maths.Point;
	
	/**
	 * @private
	 * Mesh数据处理工具
	 * @version 1.0
	 * 
	 * @created  2017-4-28 下午2:46:23
	 */
	public class MeshTools
	{

		/**
		 * 查找边界索引 
		 * @param verticles 顶点表
		 * @param offI 0表示x 1表示y
		 * @param min 是否是最小值
		 * @return 
		 * 
		 */		
		public static function findEdge(verticles:Array, offI:int=0, min:Boolean=true):int
		{
			var i:int, len:int;
			var tIndex:int;
			len = verticles.length;
			tIndex = -1;
			for (i = 0; i < len; i+=2)
			{
				if (tIndex < 0 || (min==(verticles[tIndex + offI] < verticles[i + offI])))
				{
					tIndex = i;
				}
			}
			return tIndex;
		}
		
		private static var _bestTriangle:Array = [];
		
		/**
		 * 从顶点列表中选取一个跨度最大的三角形 
		 * @param verticles 顶点列表
		 * @return 三角形顶点索引数组
		 * 
		 */		
		public static function findBestTriangle(verticles:Array):Array
		{
			var topI:int;
			topI = findEdge(verticles,1,true);
			var bottomI:int;
			bottomI = findEdge(verticles,1,false);
			
			var leftI:int;
			leftI = findEdge(verticles, 0, true);
			var rightI:int;
			rightI = findEdge(verticles, 0, false);
			var rst:Array;
			rst = _bestTriangle;
			rst.length = 0;
			
			//another type:
			//rst.push(topI, bottomI);
			//
			//if (rst.indexOf(rightI) < 0) rst.push(rightI);
			//if (rst.indexOf(leftI) < 0) rst.push(leftI);
			
			rst.push(leftI, rightI);
			
			if (rst.indexOf(topI) < 0) rst.push(topI);
			if (rst.indexOf(bottomI) < 0) rst.push(bottomI);
			return rst;
		}
		
		private static var _absArr:Array=[];
		/**
		 * 根据mesh的多顶点列表生成四顶点列表 
		 * @param mesh mesh数据
		 * @param rst
		 * @return 
		 * 
		 */		
		public static function solveMesh(mesh:MeshData,rst:Array=null):Array
		{
			rst=rst||[];
			rst.length=0;
			var mUv:Array;
			mUv = mesh.uvs;
			var mVer:Array;
			mVer = mesh.vertices;
			var uvAbs:Array;
			var indexs:Array;
			indexs = findBestTriangle(mUv);
			var index0:int;
			var index1:int;
			var index2:int;
			index0 = indexs[0];
			index1 = indexs[1];
			index2 = indexs[2];
			_absArr.length=0;
			uvAbs = solvePoints(mesh.texture.uv, mUv[index0], mUv[index0+1], mUv[index1]-mUv[index0], mUv[index1+1]-mUv[index0+1], mUv[index2]-mUv[index0], mUv[index2+1]-mUv[index0+1],_absArr);
			var newVerticles:Array;
			newVerticles = transPoints(uvAbs, mVer[index0], mVer[index0+1], mVer[index1]- mVer[index0], mVer[index1+1]-mVer[index0+1], mVer[index2]- mVer[index0], mVer[index2+1]-mVer[index0+1],rst);
			
			return newVerticles;
		}
		
		/**
		 * 计算ab列表，pointC=point0+a*v1+b*v2
		 * @param pointList pointC列表
		 * @param oX point0.x
		 * @param oY point0.y
		 * @param v1x v1.x
		 * @param v1y v1.y
		 * @param v2x v2.x
		 * @param v2y v2.y
		 * @param rst
		 * @return 
		 * 
		 */		
		public static function solvePoints(pointList:Array, oX:Number, oY:Number, v1x:Number, v1y:Number, v2x:Number, v2y:Number,rst:Array=null):Array
		{
			rst = rst||[];
			var i:int, len:int;
			len = pointList.length;
			var tRst:Array;
			for (i = 0; i < len; i+=2)
			{
				tRst = solve2(pointList[i], pointList[i + 1], oX, oY, v1x, v1y, v2x, v2y);
				rst.push(tRst[0],tRst[1]);
			}
			return rst;
		}
		
		/**
		 * 根据偏移ab列表，生成对应的点，pointC=point0+a*v1+b*v2
		 * @param abs ab列表
		 * @param oX point0.x
		 * @param oY point0.y
		 * @param v1x v1.x
		 * @param v1y v1.y
		 * @param v2x v2.x
		 * @param v2y v2.y
		 * @param rst
		 * @return 
		 * 
		 */		
		public static function transPoints(abs:Array, oX:Number, oY:Number, v1x:Number, v1y:Number, v2x:Number, v2y:Number,rst:Array=null):Array
		{
			rst =rst|| [];
			var i:int, len:int;
			len = abs.length;
			var tRst:Array;
			for (i = 0; i < len; i+=2)
			{
				tRst = transPoint(abs[i], abs[i + 1], oX, oY, v1x, v1y, v2x, v2y,rst);
			}
			return rst;
		}
		
		/**
		 * 获取 pointC=point0+a*v1+b*v2
		 * @param a
		 * @param b
		 * @param oX point0.x
		 * @param oY point0.y
		 * @param v1x v1.x
		 * @param v1y v1.y
		 * @param v2x v2.x
		 * @param v2y v2.y
		 * @param rst
		 * @return 
		 * 
		 */		
		public static function transPoint(a:Number, b:Number, oX:Number, oY:Number, v1x:Number, v1y:Number, v2x:Number, v2y:Number,rst:Array=null):Array
		{
			rst =rst|| [];
			var nX:Number;
			var nY:Number;
			nX = oX + v1x * a + v2x * b;
			nY = oY + v1y * a + v2y * b;
			rst.push(nX, nY)
			return rst;
		}
		
		/**
		 * 解方程 求解 pointC=point0+a*v1+b*v2,计算过程要求v1.x!=0
		 * @param rx pointC.x
		 * @param ry pointC.y
		 * @param oX point0.x
		 * @param oY point0.y
		 * @param v1x v1.x
		 * @param v1y v1.y
		 * @param v2x v2.x
		 * @param v2y v2.y
		 * @param rv 是否交换v1,v2
		 * @param rst
		 * @return 
		 * 
		 */		
		public static function solve2(rx:Number, ry:Number, oX:Number, oY:Number, v1x:Number, v1y:Number, v2x:Number, v2y:Number,rv:Boolean=false,rst:Array=null):Array
		{
			rst=rst||[];
			var a:Number, b:Number;
			//pointC.x = point0.x + a * v1.x + b * v2.x;
			//pointC.y = point0.y + a * v1.y + b * v2.y;
			
			//pointC.x - point0.x = a * v1.x + b * v2.x;
			//pointC.y - point0.y = a * v1.y + b * v2.y;
			
			if (v1x == 0)
			{
				return solve2(rx, ry, oX, oY, v2x, v2y, v1x, v1y, true,rst);
			}
			
			var dX:Number;
			var dY:Number;
			dX = rx -oX;
			dY = ry - oY;
			
			//dX = a * v1.x + b * v2.x;
			//dY = a * v1.y + b * v2.y;
			
			//a = (dX - b * v2.x) / v1.x;
			//dY = ((dX - b * v2.x) / v1.x) * v1.y + b * v2.y;
			//
			//dY = dX * v1.y / v1.x - b * v2.x * v1.y / v1.x  + b * v2.y;
			//dY = dX * v1.y / v1.x + b * (v2.y - v2.x * v1.y / v1.x);
			//dY - dX * v1.y / v1.x = b * (v2.y - v2.x * v1.y / v1.x);
			
			b = (dY - dX * v1y / v1x) / (v2y - v2x * v1y / v1x);
			a = (dX - b * v2x) / v1x;
			
			//trace("a,b", a, b);
			if(rv)
			{
				rst.push(b,a);
			}else
			{
				rst.push(a,b);
			}
			return rst;
		}
		
		/**
		 * 求解 pointC=point0+a*v1+b*v2,计算过程要求v1.x!=0
		 * v1,v2为不平行的向量
		 * @param pointC 目标点
		 * @param point0 起点
		 * @param v1 向量1
		 * @param v2 向量2
		 * @return 
		 * 
		 */		
		public static function solve(pointC:Point, point0:Point, v1:Point, v2:Point):Array
		{
			return solve2(pointC.x, pointC.y, point0.x, point0.y, v1.x, v1.y, v2.x, v2.y);
		}
	}
}