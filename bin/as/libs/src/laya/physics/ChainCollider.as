package laya.physics {
	
	/**
	 * 2D线形碰撞体
	 */
	public class ChainCollider extends ColliderBase {
		/**相对节点的x轴偏移*/
		private var _x:Number = 0;
		/**相对节点的y轴偏移*/
		private var _y:Number = 0;
		/**用逗号隔开的点的集合，格式：x,y,x,y ...*/
		private var _points:String = "0,0,100,0";
		/**是否是闭环，注意不要有自相交的链接形状，它可能不能正常工作*/
		private var _loop:Boolean = false;
		
		override protected function getDef():* {
			if (!_shape) {
				_shape = new window.box2d.b2ChainShape();
				_setShape(false);
			}
			this.label = (this.label || "ChainCollider");
			return super.getDef();
		}
		
		private function _setShape(re:Boolean = true):void {
			var arr:Array = _points.split(",");
			var len:int = arr.length;
			if (len % 2 == 1) throw "ChainCollider points lenth must a multiplier of 2";
			
			var ps:Array = [];
			for (var i:int = 0, n:int = len; i < n; i += 2) {
				ps.push(new window.box2d.b2Vec2((_x + parseInt(arr[i])) / Physics.PIXEL_RATIO, (_y + parseInt(arr[i + 1])) / Physics.PIXEL_RATIO));
			}
			_loop ? _shape.CreateLoop(ps, len / 2) : _shape.CreateChain(ps, len / 2);
			
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
			if (!value) throw "ChainCollider points cannot be empty";
			_points = value;
			if (_shape) _setShape();
		}
		
		/**是否是闭环，注意不要有自相交的链接形状，它可能不能正常工作*/
		public function get loop():Boolean {
			return _loop;
		}
		
		public function set loop(value:Boolean):void {
			_loop = value;
			if (_shape) _setShape();
		}
	}
}