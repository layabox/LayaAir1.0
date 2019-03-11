package laya.physics {
	
	/**
	 * 2D多边形碰撞体，暂时不支持凹多边形，如果是凹多边形，先手动拆分为多个凸多边形
	 * 节点个数最多是b2_maxPolygonVertices，这数值默认是8，所以点的数量不建议超过8个，也不能小于3个
	 */
	public class PolygonCollider extends ColliderBase {
		/**相对节点的x轴偏移*/
		private var _x:Number = 0;
		/**相对节点的y轴偏移*/
		private var _y:Number = 0;
		/**用逗号隔开的点的集合，格式：x,y,x,y ...*/
		private var _points:String = "50,0,100,100,0,100";
		
		override protected function getDef():* {
			if (!_shape) {
				_shape = new window.box2d.b2PolygonShape();
				_setShape(false);
			}
			this.label = (this.label || "PolygonCollider");
			return super.getDef();
		}
		
		private function _setShape(re:Boolean = true):void {
			var arr:Array = _points.split(",");
			var len:int = arr.length;
			if (len < 6) throw "PolygonCollider points must be greater than 3";
			if (len % 2 == 1) throw "PolygonCollider points lenth must a multiplier of 2";
			
			var ps:Array = [];
			for (var i:int = 0, n:int = len; i < n; i += 2) {
				ps.push(new window.box2d.b2Vec2((_x + parseInt(arr[i])) / Physics.PIXEL_RATIO, (_y + parseInt(arr[i + 1])) / Physics.PIXEL_RATIO));
			}
			
			_shape.Set(ps, len / 2);
			if (re) refresh();
		}
		
		/**相对节点的x轴偏移*/
		public function get x():Number {
			return _x;
		}
		
		public function set x(value:Number):void {
			_x = value;
			if (_shape) _setShape();
		}
		
		/**相对节点的y轴偏移*/
		public function get y():Number {
			return _y;
		}
		
		public function set y(value:Number):void {
			_y = value;
			if (_shape) _setShape();
		}
		
		/**用逗号隔开的点的集合，格式：x,y,x,y ...*/
		public function get points():String {
			return _points;
		}
		
		public function set points(value:String):void {
			if (!value) throw "PolygonCollider points cannot be empty";
			_points = value;
			if (_shape) _setShape();
		}
	}
}