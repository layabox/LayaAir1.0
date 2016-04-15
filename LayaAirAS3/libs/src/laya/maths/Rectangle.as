package laya.maths {
	
	/**
	 * 矩形
	 * @author yung
	 */
	public class Rectangle {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**全局空的矩形区域x=0,y=0,width=0,height=0*/
		public static const EMPTY:Rectangle =/*[STATIC SAFE]*/ new Rectangle();
		/**全局临时的矩形区域，此对象用于全局复用，以减少对象创建*/
		public static const TEMP:Rectangle =/*[STATIC SAFE]*/ new Rectangle();
		
		/**矩形左上角的 x 坐标。*/
		public var x:Number;
		/**矩形左上角的 y 坐标。*/
		public var y:Number;
		/**矩形的宽度。*/
		public var width:Number;
		/**矩形的高度。*/
		public var height:Number;
		
		public function Rectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0) {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		/**x 和 width 属性的和。*/
		public function get right():Number {
			return x + width;
		}
		
		/**y 和 height 属性的和。*/
		public function get bottom():Number {
			return y + height;
		}
		
		/**
		 * 将 Rectangle 的成员设置为指定值
		 * @param	x	矩形左上角的 x 坐标。
		 * @param	y	矩形左上角的 y 坐标。
		 * @param	width	矩形的宽度。
		 * @param	height	矩形的高。
		 * @return	返回矩形对象本身
		 */
		public function setTo(x:Number, y:Number, width:Number, height:Number):Rectangle {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			return this;
		}
		
		/**
		 * 复制 source 对象的值到此矩形对象中。
		 * @param	sourceRect	源 Rectangle 对象
		 * @return	返回对象本身
		 */
		public function copyFrom(source:Rectangle):Rectangle {
			this.x = source.x;
			this.y = source.y;
			this.width = source.width;
			this.height = source.height;
			return this;
		}
		
		/**
		 * 确定此矩形对象是否包含指定的点。
		 * @param	x	点的 x 坐标（水平位置）。
		 * @param	y	点的 y 坐标（垂直位置）。
		 * @return	如果 Rectangle 对象包含指定的点，则值为 true；否则为 false。
		 */
		public function contains(x:Number, y:Number):Boolean {
			if (this.width <= 0 || this.height <= 0) return false;
			
			if (x >= this.x && x < this.right) {
				if (y >= this.y && y < this.bottom) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 确定在 rect 参数中指定的对象是否与此 Rectangle 对象相交。
		 * @param	rect 要与此 Rectangle 对象比较的 Rectangle 对象
		 * @return	如果相交，则返回 true 值，否则返回 false
		 */
		public function intersects(rect:Rectangle):Boolean {
			return !(rect.x > this.right || rect.right < this.x || rect.y > this.bottom || rect.bottom < this.y);
		}
		
		/**
		 * 获取和某个矩形区域相交的区域
		 * @param	rect 比较的矩形区域
		 * @param	out	输出的矩形区域，尽量用此对象复用对象，减少对象创建消耗
		 * @return	返回相交的矩形区域
		 */
		public function intersection(rect:Rectangle, out:Rectangle = null):Rectangle {
			if (!intersects(rect)) return null;
			out || (out = new Rectangle());
			out.x = Math.max(this.x, rect.x);
			out.y = Math.max(this.y, rect.y);
			out.width = Math.min(this.right, rect.right) - out.x;
			out.height = Math.min(this.bottom, rect.bottom) - out.y;
			return out;
		}
		
		/**
		 * 合并矩形
		 * @param r 要合并的矩形
		 * @return 合并后的矩形
		 */
		/**
		 * 通过填充两个矩形之间的水平和垂直空间，将这两个矩形组合在一起以创建一个新的 Rectangle 对象
		 * @param	目标矩形对象
		 * @param	out	输出的矩形区域，尽量用此对象复用对象，减少对象创建消耗
		 * @return	充当两个矩形的联合的新 Rectangle 对象
		 */
		public function union(source:Rectangle, out:Rectangle = null):Rectangle {
			out || (out = new Rectangle());
			this.clone(out);
			if (source.width <= 0 || source.height <= 0) return out;
			out.addPoint(source.x, source.y);
			out.addPoint(source.right, source.bottom);
			return this;
		}
		
		/**
		 * 返回一个新的 Rectangle 对象，其 x、y、width 和 height 属性的值与原始 Rectangle 对象的对应值相同。
		 * @param	out	输出的矩形区域，尽量用此对象复用对象，减少对象创建消耗
		 * @return	新的 Rectangle 对象，其 x、y、width 和 height 属性的值与原始 Rectangle 对象的对应值相同。
		 */
		public function clone(out:Rectangle = null):Rectangle {
			out || (out = new Rectangle());
			out.x = x;
			out.y = y;
			out.width = width;
			out.height = height;
			return out;
		}
		
		/**
		 * 生成并返回一个字符串，该字符串列出 Rectangle 对象的水平位置和垂直位置以及高度和宽度。
		 */
		public function toString():String {
			return x + "," + y + "," + width + "," + height;
		}
		
		/**
		 * 确定在 rect 参数中指定的对象是否等于此 Rectangle 对象。
		 * @param	rect 要与此 Rectangle 对象进行比较的矩形
		 * @return	如果对象具有与此 Rectangle 对象完全相同的 x、y、width 和 height 属性值，则返回 true 值，否则返回 false
		 */
		public function equal(rect:Rectangle):Boolean {
			if (!rect || rect.x !== x || rect.y !== y || rect.width !== width || rect.height !== height) return false;
			return true;
		}
		
		/**
		 * 在矩形区域中加一个点
		 * @param x	x坐标
		 * @param y	y坐标
		 * @return 返回此对象
		 */
		public function addPoint(x:Number, y:Number):Rectangle {
			this.x > x && (width += this.x - x, this.x = x);//左边界比较
			this.y > y && (height += this.y - y, this.y = y);//上边界比较
			if (width < x - this.x) width = x - this.x;//右边界比较
			if (height < y - this.y) height = y - this.y;//下边界比较
			return this;
		}
		
		
		/** @private */
		private static var _temB:Array = [];
		
		/**
		 * 返回代表当前矩形的顶点数据
		 * @return 顶点数据
		 * @private
		 */
		public function _getBoundPoints():Array {
			var rst:Array = _temB;
			rst.length = 0;
			if (width == 0 || height == 0) return rst;
			rst.push(x, y, x + width, y, x, y + height, x + width, y + height);
			return rst;
		}
		
		/** @private */
		private static var _temA:Array = [];
		
		/**
		 * 返回矩形的顶点数据
		 * @private
		 */
		public static function _getBoundPointS(x:Number, y:Number, width:Number, height:Number):Array {
			var rst:Array = _temA;
			rst.length = 0;
			if (width == 0 || height == 0) return rst;
			rst.push(x, y, x + width, y, x, y + height, x + width, y + height);
			return rst;
		}
		
		/**
		 * 返回包括所有点的最小矩形
		 * @param pointList 点列表
		 * @return 最小矩形
		 * @private
		 */
		public static function _getWrapRec(pointList:Array, rst:Rectangle = null):Rectangle {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			if (!pointList || pointList.length < 1) return rst ? rst.setTo(0, 0, 0, 0) : EMPTY;
			rst = rst ? rst : new Rectangle();
			var i:int, len:int = pointList.length, minX:Number, maxX:Number, minY:Number, maxY:Number, tPoint:Point = Point.TEMP;
			minX = minY = 99999;
			maxX = maxY = -minX;
			for (i = 0; i < len; i += 2) {
				tPoint.x = pointList[i];
				tPoint.y = pointList[i + 1];
				minX = minX < tPoint.x ? minX : tPoint.x;
				minY = minY < tPoint.y ? minY : tPoint.y;
				maxX = maxX > tPoint.x ? maxX : tPoint.x;
				maxY = maxY > tPoint.y ? maxY : tPoint.y;
			}
			return rst.setTo(minX, minY, maxX - minX, maxY - minY);
		}
	}
}