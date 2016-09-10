package laya.utils 
{
	import laya.display.Graphics;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	/**
	 * 鼠标点击区域类
	 */
	public class HitArea 
	{
		
		/**
		 * 可点击区域
		 */
		public var hit:Graphics;
		/**
		 * 不可点击区域
		 */
		public var unHit:Graphics;
		/**
		 * @private 
		 */
		private static var _tCmds:Array = [];
		/**
		 * @private 
		 */
		private static var _rec:Rectangle = new Rectangle();
		/**
		 * @private 
		 */
		private static var _ptPoint:Point = new Point();
		public function HitArea() 
		{
			
		}
		/**
		 * 是否包含某个点 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public function isHit(x:Number, y:Number):Boolean
		{
			if (!isHitGraphic(x, y, hit)) return false;
			return !isHitGraphic(x, y, unHit);
		}

		/**
		 * 是否击中Graphic 
		 * @param x
		 * @param y
		 * @param graphic
		 * @return 
		 * 
		 */
		public static function isHitGraphic(x:Number, y:Number,graphic:Graphics):Boolean
		{
			if (!graphic) return false;
			var cmds:Array;
			cmds = graphic.cmds;
			if (!cmds&&graphic._one)
			{
				cmds = _tCmds;
				cmds.length = 1;
				cmds[0] = graphic._one;
				
			}
			if (!cmds) return false;
			var i:int, len:int;
			len = cmds.length;
			var cmd:Array;
			for (i = 0; i < len; i++)
			{
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
		 * 是否击中绘图指令 
		 * @param x
		 * @param y
		 * @param cmd
		 * @return 
		 * 
		 */
		public static function isHitCmd(x:Number, y:Number, cmd:Array):Boolean
		{
			if (!cmd) return false;
			var context:RenderContext = Render._context;
			var rst:Boolean=false;
			switch (cmd["callee"]) {
				
				case context._drawRect: 
				case 13://case context._drawRect:
					_rec.setTo(cmd[0], cmd[1], cmd[2], cmd[3]);
					rst= _rec.contains(x, y);
					break;
				case context._drawCircle: 
				case context._fillCircle: 
				case 14://case context._drawCircle
					var d:Number;
					x -= cmd[0];
					y -= cmd[1];
					d = x * x + y * y;
					rst= d < cmd[2] * cmd[2];
					break;
				
				case context._drawPoly: 
				case 18://drawpoly
					x -= cmd[0];
					y -= cmd[1];
					rst= ptInPolygon(x, y, cmd[2]);
					break;
				default:
					
				}
			return rst;
		}
		
		/**
		 * 坐标是否在多边形内 
		 * @param x
		 * @param y
		 * @param areaPoints 多边形顶点列表[x0,y0,x1,y1...]
		 * @return 
		 * 
		 */
		public static function ptInPolygon(x:Number,y:Number, areaPoints:Array):Boolean
		{
			var p:Point;
			p =_ptPoint;
			p.setTo(x, y);
			// 交点个数
			var nCross:int = 0;
			var p1x:Number, p1y:Number, p2x:Number, p2y:Number;
			var len:int;
			len = areaPoints.length;
			for (var i:int = 0; i < len; i+=2)
			{
				p1x = areaPoints[i];
				p1y = areaPoints[i + 1];
				p2x = areaPoints[(i + 2) % len];
				p2y = areaPoints[(i + 3) % len];
				var p1:Point = areaPoints[i];
				var p2:Point = areaPoints[(i + 1) % areaPoints.length]; // 最后一个点与第一个点连线
				if (p1y == p2y)
					continue;
				if (p.y < Math.min(p1y, p2y))
					continue;
				if (p.y >= Math.max(p1y, p2y))
					continue;
				// 求交点的x坐标
				var tx:Number = (p.y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x;
				// 只统计p1p2与p向右射线的交点
				if (tx > p.x)
				{
					nCross++;
				}
			}
			// 交点为偶数，点在多边形之外
			return (nCross % 2 == 1);
		}
	}

}