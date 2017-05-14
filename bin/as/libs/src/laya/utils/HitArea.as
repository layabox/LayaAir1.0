package laya.utils {
	import laya.display.Graphics;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	
	/**
	 * 鼠标点击区域，可以设置绘制一系列矢量图作为点击区域和非点击区域（目前只支持圆形，矩形，多边形）
	 */
	public class HitArea {
		
		/**@private */
		private static var _cmds:Array = [];
		/**@private */
		private static var _rec:Rectangle = new Rectangle();
		/**@private */
		private static var _ptPoint:Point = new Point();
		/**@private */
		private var _hit:Graphics;
		/**@private */
		private var _unHit:Graphics;
		
		/**
		 * 是否包含某个点
		 * @param x x坐标
		 * @param y y坐标
		 * @return 是否点击到
		 */
		public function isHit(x:Number, y:Number):Boolean {
			if (!isHitGraphic(x, y, hit)) return false;
			return !isHitGraphic(x, y, unHit);
		}
		
		/**
		 * 检测对象是否包含指定的点。
		 * @param	x	点的 X 轴坐标值（水平位置）。
		 * @param	y	点的 Y 轴坐标值（垂直位置）。
		 * @return	如果包含指定的点，则值为 true；否则为 false。
		 */
		public function contains(x:Number, y:Number):Boolean {
			return isHit(x, y);
		}
		
		/**
		 * @private
		 * 是否击中Graphic
		 */
		public static function isHitGraphic(x:Number, y:Number, graphic:Graphics):Boolean {
			if (!graphic) return false;
			var cmds:Array;
			cmds = graphic.cmds;
			if (!cmds && graphic._one) {
				cmds = _cmds;
				cmds.length = 1;
				cmds[0] = graphic._one;
				
			}
			if (!cmds) return false;
			var i:int, len:int;
			len = cmds.length;
			var cmd:Array;
			for (i = 0; i < len; i++) {
				cmd = cmds[i];
				if (!cmd) continue;
				var context:RenderContext = Render._context;
				switch (cmd.callee) {
				
				case context._translate: 
				case 6://translate
					x -= cmd[0];
					y -= cmd[1];
				default:
					
				}
				if (isHitCmd(x, y, cmd)) return true;
			}
			return false;
		}
		
		/**
		 * @private
		 * 是否击中绘图指令
		 */
		public static function isHitCmd(x:Number, y:Number, cmd:Array):Boolean {
			if (!cmd) return false;
			var context:RenderContext = Render._context;
			var rst:Boolean = false;
			switch (cmd["callee"]) {
			
			case context._drawRect: 
			case 13://case context._drawRect:
				_rec.setTo(cmd[0], cmd[1], cmd[2], cmd[3]);
				rst = _rec.contains(x, y);
				break;
			case context._drawCircle: 
			case context._fillCircle: 
			case 14://case context._drawCircle
				var d:Number;
				x -= cmd[0];
				y -= cmd[1];
				d = x * x + y * y;
				rst = d < cmd[2] * cmd[2];
				break;
			
			case context._drawPoly: 
			case 18://drawpoly
				x -= cmd[0];
				y -= cmd[1];
				rst = ptInPolygon(x, y, cmd[2]);
				break;
			default: 
				break;
			}
			return rst;
		}
		
		/**
		 * @private
		 * 坐标是否在多边形内
		 */
		public static function ptInPolygon(x:Number, y:Number, areaPoints:Array):Boolean {
			var p:Point;
			p = _ptPoint;
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
				if (p1y == p2y)
					continue;
				if (p.y < Math.min(p1y, p2y))
					continue;
				if (p.y >= Math.max(p1y, p2y))
					continue;
				// 求交点的x坐标
				var tx:Number = (p.y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x;
				// 只统计p1p2与p向右射线的交点
				if (tx > p.x) {
					nCross++;
				}
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