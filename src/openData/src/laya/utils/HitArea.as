package laya.utils {
	import laya.display.Graphics;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	
	/**
	 * 鼠标点击区域，可以设置绘制一系列矢量图作为点击区域和非点击区域（目前只支持圆形，矩形，多边形）
	 *
	 */
	public class HitArea {
		
		/**@private */
		private static var _cmds:Array = [];
		/**@private */
		private static var _rect:Rectangle = new Rectangle();
		/**@private */
		private static var _ptPoint:Point = new Point();
		/**@private */
		private var _hit:Graphics;
		/**@private */
		private var _unHit:Graphics;
		
		/**
		 * 检测对象是否包含指定的点。
		 * @param	x	点的 X 轴坐标值（水平位置）。
		 * @param	y	点的 Y 轴坐标值（垂直位置）。
		 * @return	如果包含指定的点，则值为 true；否则为 false。
		 */
		public function contains(x:Number, y:Number):Boolean {
			if (!_isHitGraphic(x, y, hit)) return false;
			return !_isHitGraphic(x, y, unHit);
		}
		
		/**
		 * @private
		 * 是否击中Graphic
		 */
		public static function _isHitGraphic(x:Number, y:Number, graphic:Graphics):Boolean {
			if (!graphic) return false;
			var cmds:Array = graphic.cmds;
			if (!cmds && graphic._one) {
				cmds = _cmds;
				cmds.length = 1;
				cmds[0] = graphic._one;
			}
			if (!cmds) return false;
			var i:int, len:int;
			len = cmds.length;
			var cmd:Object;
			for (i = 0; i < len; i++) {
				cmd = cmds[i];
				if (!cmd) continue;
				switch (cmd.cmdID) {
				case "Translate": 
					x -= cmd.tx;
					y -= cmd.ty;
				}
				if (_isHitCmd(x, y, cmd)) return true;
			}
			return false;
		}
		
		/**
		 * @private
		 * 是否击中绘图指令
		 */
		public static function _isHitCmd(x:Number, y:Number, cmd:Object):Boolean {
			if (!cmd) return false;
			var rst:Boolean = false;
			switch (cmd.cmdID) {
			case "DrawRect": 
				_rect.setTo(cmd.x, cmd.y, cmd.width, cmd.height);
				rst = _rect.contains(x, y);
				break;
			case "DrawCircle": 
				var d:Number;
				x -= cmd.x;
				y -= cmd.y;
				d = x * x + y * y;
				rst = d < cmd.radius * cmd.radius;
				break;
			case "DrawPoly": 
				x -= cmd.x;
				y -= cmd.y;
				rst = _ptInPolygon(x, y, cmd.points);
				break;
			}
			return rst;
		}
		
		/**
		 * @private
		 * 坐标是否在多边形内
		 */
		public static function _ptInPolygon(x:Number, y:Number, areaPoints:Array):Boolean {
			var p:Point = _ptPoint;
			p.setTo(x, y);
			// 交点个数
			var nCross:int = 0;
			var p1x:Number, p1y:Number, p2x:Number, p2y:Number;
			var len:int;
			len = areaPoints.length;
			for (var i:int = 0; i < len; i += 2) {
				p1x = areaPoints[i];
				p1y = areaPoints[i + 1];
				p2x = areaPoints[(i + 2) % len];
				p2y = areaPoints[(i + 3) % len];
				//var p1:Point = areaPoints[i];
				//var p2:Point = areaPoints[(i + 1) % areaPoints.length]; // 最后一个点与第一个点连线
				if (p1y == p2y) continue;
				if (p.y < Math.min(p1y, p2y)) continue;
				if (p.y >= Math.max(p1y, p2y)) continue;
				// 求交点的x坐标
				var tx:Number = (p.y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x;
				// 只统计p1p2与p向右射线的交点
				if (tx > p.x) nCross++;
			}
			// 交点为偶数，点在多边形之外
			return (nCross % 2 == 1);
		}
		
		/**
		 * 可点击区域，可以设置绘制一系列矢量图作为点击区域（目前只支持圆形，矩形，多边形）
		 */
		public function get hit():Graphics {
			if (!_hit) _hit = new Graphics();
			return _hit;
		}
		
		public function set hit(value:Graphics):void {
			_hit = value;
		}
		
		/**
		 * 不可点击区域，可以设置绘制一系列矢量图作为非点击区域（目前只支持圆形，矩形，多边形）
		 */
		public function get unHit():Graphics {
			if (!_unHit) _unHit = new Graphics();
			return _unHit;
		}
		
		public function set unHit(value:Graphics):void {
			_unHit = value;
		}
	}
}