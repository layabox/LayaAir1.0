package laya.physics {
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.resource.Context;
	import laya.utils.Browser;
	
	/**
	 * 物理辅助线，调用PhysicsDebugDraw.enable()开启，或者通过IDE设置打开
	 */
	public class PhysicsDebugDraw extends Sprite {
		/**@private */
		public var m_drawFlags:int = 99;
		/**@private */
		public static var box2d:*;
		/**@private */
		public static var DrawString_s_color:*;
		/**@private */
		public static var DrawStringWorld_s_p:*;
		/**@private */
		public static var DrawStringWorld_s_cc:*;
		/**@private */
		public static var DrawStringWorld_s_color:*;
		/**@private */
		public var world:*;
		/**@private */
		private var _camera:Object;
		/**@private */
		private static var _canvas:*;
		/**@private */
		private static var _inited:Boolean = false;
		/**@private */
		private var _mG:Graphics;
		/**@private */
		private var _textSp:Sprite;
		/**@private */
		private var _textG:Graphics;
		
		/**@private */
		public static function init():void {
			box2d = Browser.window.box2d;
			DrawString_s_color = new box2d.b2Color(0.9, 0.6, 0.6);
			DrawStringWorld_s_p = new box2d.b2Vec2();
			DrawStringWorld_s_cc = new box2d.b2Vec2();
			DrawStringWorld_s_color = new box2d.b2Color(0.5, 0.9, 0.5);
		}
		
		public function PhysicsDebugDraw() {
			if (!_inited) {
				_inited = true;
				init();
			}
			_camera = {};
			_camera.m_center = new box2d.b2Vec2(0, 0);
			_camera.m_extent = 25;
			_camera.m_zoom = 1;
			_camera.m_width = 1280;
			_camera.m_height = 800;
			
			_mG = new Graphics();
			this.graphics = _mG;
			
			_textSp = new Sprite();
			_textG = _textSp.graphics;
			addChild(_textSp);
		}
		
		/**@private */
		override public function render(ctx:Context, x:Number, y:Number):void {
			_renderToGraphic();
			super.render(ctx, x, y);
		}
		
		/**@private */
		private var lineWidth:Number;
		
		/**@private */
		private function _renderToGraphic():void {
			if (world) {
				_textG.clear();
				this._mG.clear();
				this._mG.save();
				this._mG.scale(Physics.PIXEL_RATIO, Physics.PIXEL_RATIO);
				lineWidth = 1 / Physics.PIXEL_RATIO;
				world.DrawDebugData();
				this._mG.restore();
			}
		}
		
		/**@private */
		public function SetFlags(flags:int):void {
			this.m_drawFlags = flags;
		}
		
		/**@private */
		public function GetFlags():int {
			return this.m_drawFlags;
		}
		
		/**@private */
		public function AppendFlags(flags:int):void {
			this.m_drawFlags |= flags;
		}
		
		/**@private */
		public function ClearFlags(flags:*):void {
			this.m_drawFlags &= ~flags;
		}
		
		/**@private */
		public function PushTransform(xf:*):void {
			this._mG.save();
			this._mG.translate(xf.p.x, xf.p.y);
			this._mG.rotate(xf.q.GetAngle());
		}
		
		/**@private */
		public function PopTransform(xf:*):void {
			this._mG.restore();
		}
		
		/**@private */
		public function DrawPolygon(vertices:*, vertexCount:*, color:*):void {
			var i:int, len:int;
			len = vertices.length;
			var points:Array;
			points = [];
			for (i = 0; i < vertexCount; i++) {
				points.push(vertices[i].x, vertices[i].y);
			}
			this._mG.drawPoly(0, 0, points, null, color.MakeStyleString(1), lineWidth);
		}
		
		/**@private */
		public function DrawSolidPolygon(vertices:*, vertexCount:*, color:*):void {
			var i:int, len:int;
			len = vertices.length;
			var points:Array;
			points = [];
			for (i = 0; i < vertexCount; i++) {
				points.push(vertices[i].x, vertices[i].y);
			}
			this._mG.drawPoly(0, 0, points, color.MakeStyleString(0.5), color.MakeStyleString(1), lineWidth);
		}
		
		/**@private */
		public function DrawCircle(center:*, radius:*, color:*):void {
			this._mG.drawCircle(center.x, center.y, radius, null, color.MakeStyleString(1), lineWidth);
		}
		
		/**@private */
		public function DrawSolidCircle(center:*, radius:*, axis:*, color:*):void {
			var cx:* = center.x;
			var cy:* = center.y;
			this._mG.drawCircle(cx, cy, radius, color.MakeStyleString(0.5), color.MakeStyleString(1), lineWidth);
			this._mG.drawLine(cx, cy, (cx + axis.x * radius), (cy + axis.y * radius), color.MakeStyleString(1), lineWidth);
		}
		
		/**@private */
		public function DrawParticles(centers:*, radius:*, colors:*, count:*):void {
			if (colors !== null) {
				for (var i:int = 0; i < count; ++i) {
					var center:* = centers[i];
					var color:* = colors[i];
					this._mG.drawCircle(center.x, center.y, radius, color.MakeStyleString(), null, lineWidth);
				}
			} else {
				
				for (i = 0; i < count; ++i) {
					center = centers[i];
					this._mG.drawCircle(center.x, center.y, radius, "#ffff00", null, lineWidth);
				}
			}
		}
		
		/**@private */
		public function DrawSegment(p1:*, p2:*, color:*):void {
			_mG.drawLine(p1.x, p1.y, p2.x, p2.y, color.MakeStyleString(1), lineWidth);
		}
		
		/**@private */
		public function DrawTransform(xf:*):void {
			this.PushTransform(xf);
			_mG.drawLine(0, 0, 1, 0, box2d.b2Color.RED.MakeStyleString(1), lineWidth);
			_mG.drawLine(0, 0, 0, 1, box2d.b2Color.GREEN.MakeStyleString(1), lineWidth);
			this.PopTransform(xf);
		}
		
		/**@private */
		public function DrawPoint(p:*, size:*, color:*):void {
			size *= _camera.m_zoom;
			size /= _camera.m_extent;
			var hsize:* = size / 2;
			
			_mG.drawRect(p.x - hsize, p.y - hsize, size, size, color.MakeStyleString(), null);
		}
		
		/**@private */
		public function DrawString(x:*, y:*, message:*):void {
			_textG.fillText(message, x, y, "15px DroidSans", DrawString_s_color.MakeStyleString(), "left");
		}
		
		/**@private */
		public function DrawStringWorld(x:*, y:*, message:*):void {
			DrawString(x, y, message);
		}
		
		/**@private */
		public function DrawAABB(aabb:*, color:*):void {
			var x:int = aabb.lowerBound.x;
			var y:int = aabb.lowerBound.y;
			var w:int = aabb.upperBound.x - aabb.lowerBound.x;
			var h:int = aabb.upperBound.y - aabb.lowerBound.y;
			
			this._mG.drawRect(x, y, w, h, null, color.MakeStyleString(), lineWidth);
		}
		
		/**@private */
		public static var I:PhysicsDebugDraw;
		
		/**
		 * 激活物理辅助线
		 * @param	flags 位标记值，其值是AND的结果，其值有-1:显示形状，2:显示关节，4:显示AABB包围盒,8:显示broad-phase pairs,16:显示质心
		 * @return	返回一个Sprite对象，本对象用来显示物理辅助线
		 */
		public static function enable(flags:int = 99):PhysicsDebugDraw {
			if (!I) {
				var debug:PhysicsDebugDraw = new PhysicsDebugDraw();
				debug.world = Physics.I.world;
				debug.world.SetDebugDraw(debug);
				debug.zOrder = 1000;
				debug.m_drawFlags = flags;
				Laya.stage.addChild(debug);
				I = debug;
				
			}
			return debug;
		}
	}
}