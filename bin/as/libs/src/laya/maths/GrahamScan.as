package laya.maths {
	import laya.utils.Utils;
	
	/**
	 * @private
	 * 凸包算法。
	 */
	public class GrahamScan {
		
		private static var _mPointList:Array;
		private static var _tempPointList:Array = [];
		private static var _temPList:Array = [];
		private static var _temArr:Array = [];
		
		public static function multiply(p1:Point, p2:Point, p0:Point):Number {
			return ((p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y));
		}
		
		/**
		 * 计算两个点的距离。
		 * @param	p1
		 * @param	p2
		 * @return
		 */
		public static function dis(p1:Point, p2:Point):Number {
			return (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y);
		}
		
		private static function _getPoints(count:int, tempUse:Boolean = false, rst:Array = null):Array {
			if (!_mPointList) _mPointList = [];
			while (_mPointList.length < count) _mPointList.push(new Point());
			if (!rst) rst = [];
			rst.length = 0;
			if (tempUse) {
				//				rst=_mPointList.slice(0,count);
				getFrom(rst, _mPointList, count);
			} else {
				//				rst=_mPointList.splice(0,count);
				getFromR(rst, _mPointList, count);
			}
			return rst;
		}
		
		/**
		 * 将数组 src 从索引0位置 依次取 cout 个项添加至 tst 数组的尾部。
		 * @param	rst 原始数组，用于添加新的子元素。
		 * @param	src 用于取子元素的数组。
		 * @param	count 需要取得子元素个数。
		 * @return 添加完子元素的 rst 对象。
		 */
		public static function getFrom(rst:Array, src:Array, count:int):Array {
			var i:int;
			for (i = 0; i < count; i++) {
				rst.push(src[i]);
			}
			return rst;
		}
		
		/**
		 * 将数组 src 从末尾索引位置往头部索引位置方向 依次取 cout 个项添加至 tst 数组的尾部。
		 * @param	rst 原始数组，用于添加新的子元素。
		 * @param	src 用于取子元素的数组。
		 * @param	count 需要取得子元素个数。
		 * @return 添加完子元素的 rst 对象。
		 */
		public static function getFromR(rst:Array, src:Array, count:int):Array {
			var i:int;
			for (i = 0; i < count; i++) {
				rst.push(src.pop());
			}
			return rst;
		}
		
		/**
		 *  [x,y...]列表 转 Point列表
		 * @param pList Point列表
		 * @return [x,y...]列表
		 */
		public static function pListToPointList(pList:Array, tempUse:Boolean = false):Array {
			var i:int, len:int = pList.length / 2, rst:Array = _getPoints(len, tempUse, _tempPointList);
			for (i = 0; i < len; i++) {
				rst[i].setTo(pList[i + i], pList[i + i + 1]);
			}
			return rst;
		}
		
		/**
		 * Point列表转[x,y...]列表
		 * @param pointList Point列表
		 * @return [x,y...]列表
		 */
		public static function pointListToPlist(pointList:Array):Array {
			var i:int, len:int = pointList.length, rst:Array = _temPList, tPoint:Point;
			rst.length = 0;
			for (i = 0; i < len; i++) {
				tPoint = pointList[i];
				rst.push(tPoint.x, tPoint.y);
			}
			return rst;
		}
		
		/**
		 *  寻找包括所有点的最小多边形顶点集合
		 * @param pList 形如[x0,y0,x1,y1...]的点列表
		 * @return  最小多边形顶点集合
		 */
		public static function scanPList(pList:Array):Array {
			return Utils.copyArray(pList, pointListToPlist(scan(pListToPointList(pList, true))));
		}
		
		/**
		 * 寻找包括所有点的最小多边形顶点集合
		 * @param PointSet Point列表
		 * @return 最小多边形顶点集合
		 */
		public static function scan(PointSet:Array):Array {
			var i:int, j:int, k:int = 0, top:int = 2, tmp:Point, n:int = PointSet.length, ch:Array;
			var _tmpDic:Object = {};
			var key:String;
			ch = _temArr;
			ch.length = 0;
			n = PointSet.length;
			for (i = n - 1; i >= 0; i--) {
				tmp = PointSet[i];
				key = tmp.x + "_" + tmp.y;
				if (!_tmpDic.hasOwnProperty(key)) {
					_tmpDic[key] = true;
					ch.push(tmp);
				}
			}
			n = ch.length;
			Utils.copyArray(PointSet, ch);
			//			PointSet=ch;
			//			n=PointSet.length;
			//找到最下且偏左的那个点  
			for (i = 1; i < n; i++)
				if ((PointSet[i].y < PointSet[k].y) || ((PointSet[i].y == PointSet[k].y) && (PointSet[i].x < PointSet[k].x)))
					k = i;
			//将这个点指定为PointSet[0]  
			tmp = PointSet[0];
			PointSet[0] = PointSet[k];
			PointSet[k] = tmp;
			//按极角从小到大,距离偏短进行排序  
			for (i = 1; i < n - 1; i++) {
				k = i;
				for (j = i + 1; j < n; j++)
					if ((multiply(PointSet[j], PointSet[k], PointSet[0]) > 0) || ((multiply(PointSet[j], PointSet[k], PointSet[0]) == 0) && (dis(PointSet[0], PointSet[j]) < dis(PointSet[0], PointSet[k]))))
						k = j;//k保存极角最小的那个点,或者相同距离原点最近  
				tmp = PointSet[i];
				PointSet[i] = PointSet[k];
				PointSet[k] = tmp;
			}
			//第三个点先入栈  
			ch = _temArr;
			ch.length = 0;
			//trace("scan:",PointSet[0],PointSet[1],PointSet[2]);
			if (PointSet.length < 3) {
				return Utils.copyArray(ch, PointSet);
			}
			ch.push(PointSet[0], PointSet[1], PointSet[2]);
			//ch=[PointSet[0],PointSet[1],PointSet[2]];
			//判断与其余所有点的关系  
			for (i = 3; i < n; i++) {
				//不满足向左转的关系,栈顶元素出栈  
				while (ch.length >= 2 && multiply(PointSet[i], ch[ch.length - 1], ch[ch.length - 2]) >= 0) ch.pop();
				//当前点与栈内所有点满足向左关系,因此入栈.  
				PointSet[i] && ch.push(PointSet[i]);
			}
			return ch;
		}
	
	}
}