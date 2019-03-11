package laya.physics {
	
	/**
	 * 2D圆形碰撞体
	 */
	public class CircleCollider extends ColliderBase {
		/**@private */
		private static var _temp:*;
		/**相对节点的x轴偏移*/
		private var _x:Number = 0;
		/**相对节点的y轴偏移*/
		private var _y:Number = 0;
		/**圆形半径，必须为正数*/
		private var _radius:Number = 50;
		
		override protected function getDef():* {
			if (!_shape) {
				_shape = new window.box2d.b2CircleShape();
				_setShape(false);
			}
			this.label = (this.label || "CircleCollider");
			return super.getDef();
		}
		
		private function _setShape(re:Boolean = true):void {
			var scale:Number = this.owner["scaleX"] || 1;
			_shape.m_radius = _radius / Physics.PIXEL_RATIO * scale;
			_shape.m_p.Set((_radius + _x) / Physics.PIXEL_RATIO * scale, (_radius + _y) / Physics.PIXEL_RATIO * scale);
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
		
		/**圆形半径，必须为正数*/
		public function get radius():Number {
			return _radius;
		}
		
		public function set radius(value:Number):void {
			if (value <= 0) throw "CircleCollider radius cannot be less than 0";
			_radius = value;
			if (_shape) _setShape();
		}
		
		/**@private 重置形状*/
		override public function resetShape(re:Boolean = true):void {
			_setShape();
		}
	}
}