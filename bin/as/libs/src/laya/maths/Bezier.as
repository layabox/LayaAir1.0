package laya.maths {
	
	/**
	 * @private
	 * 计算贝塞尔曲线的工具类。
	 */
	public class Bezier {
		
		/**
		 * 工具类单例
		 */
		public static var I:Bezier = new Bezier();
		/** @private */
		private var _controlPoints:Array = [new Point(), new Point(), new Point()];
		/** @private */
		private var _calFun:Function = getPoint2;
		
		/** @private */
		private function _switchPoint(x:Number, y:Number):void {
			var tPoint:Point = _controlPoints.shift();
			tPoint.setTo(x, y);
			_controlPoints.push(tPoint);
		}
		
		/**
		 * 计算二次贝塞尔点。
		 * @param t
		 * @param rst
		 *
		 */
		public function getPoint2(t:Number, rst:Array):void {
			//二次贝塞尔曲线公式
			var p1:Point = _controlPoints[0];
			var p2:Point = _controlPoints[1];
			var p3:Point = _controlPoints[2];
			var lineX:Number = Math.pow((1 - t), 2) * p1.x + 2 * t * (1 - t) * p2.x + Math.pow(t, 2) * p3.x;
			var lineY:Number = Math.pow((1 - t), 2) * p1.y + 2 * t * (1 - t) * p2.y + Math.pow(t, 2) * p3.y;
			rst.push(lineX, lineY);
		}
		
		/**
		 * 计算三次贝塞尔点
		 * @param t
		 * @param rst
		 *
		 */
		public function getPoint3(t:Number, rst:Array):void {
			//三次贝塞尔曲线公式
			var p1:Point = _controlPoints[0];
			var p2:Point = _controlPoints[1];
			var p3:Point = _controlPoints[2];
			var p4:Point = _controlPoints[3];
			var lineX:Number = Math.pow((1 - t), 3) * p1.x + 3 * p2.x * t * (1 - t) * (1 - t) + 3 * p3.x * t * t * (1 - t) + p4.x * Math.pow(t, 3);
			var lineY:Number = Math.pow((1 - t), 3) * p1.y + 3 * p2.y * t * (1 - t) * (1 - t) + 3 * p3.y * t * t * (1 - t) + p4.y * Math.pow(t, 3);
			rst.push(lineX, lineY);
		}
		
		/**
		 * 计算贝塞尔点序列
		 * @param count
		 * @param rst
		 *
		 */
		public function insertPoints(count:Number, rst:Array):void {
			var i:Number;
			count = count > 0 ? count : 5;
			var dLen:Number;
			dLen = 1 / count;
			for (i = 0; i <= 1; i += dLen) {
				_calFun(i, rst);
			}
		
		}
		
		/**
		 * 获取贝塞尔曲线上的点。
		 * @param pList 控制点[x0,y0,x1,y1...]
		 * @param inSertCount 每次曲线的插值数量
		 * @return
		 *
		 */
		public function getBezierPoints(pList:Array, inSertCount:int = 5, count:int = 2):Array {
			var i:int, len:int;
			len = pList.length;
			if (len < (count + 1) * 2) return [];
			var rst:Array;
			rst = [];
			switch (count) {
			case 2: 
				_calFun = getPoint2;
				break;
			case 3: 
				_calFun = getPoint3;
				break;
			default: 
				return [];
			}
			while (_controlPoints.length <= count) {
				_controlPoints.push(new Point());
			}
			for (i = 0; i < count * 2; i += 2) {
				_switchPoint(pList[i], pList[i + 1]);
			}
			for (i = count * 2; i < len; i += 2) {
				_switchPoint(pList[i], pList[i + 1]);
				if ((i / 2) % count == 0)
					insertPoints(inSertCount, rst);
				
			}
			return rst;
		}
	}

}