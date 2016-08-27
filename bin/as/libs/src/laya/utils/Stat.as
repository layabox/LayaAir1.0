package laya.utils {
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.ResourceManager;
	
	/**
	 * <code>Stat</code> 用于显示帧率统计信息。
	 */
	public class Stat {
		/**主舞台 <code>Stage</code> 渲染次数计数。 */
		public static var loopCount:int = 0;
		/** 着色器请求次数。*/
		public static var shaderCall:int = 0;
		/** 描绘次数。*/
		public static var drawCall:int = 0;
		/** 三角形面数。*/
		public static var trianglesFaces:int = 0;
		/** 精灵<code>Sprite</code> 的数量。*/
		public static var spriteCount:int = 0;
		/** 每秒帧数。*/
		public static var FPS:int = 0;
		/** 画布 canvas 使用标准渲染的次数。*/
		public static var canvasNormal:int = 0;
		/** 画布 canvas 使用位图渲染的次数。*/
		public static var canvasBitmap:int = 0;
		/** 画布 canvas 缓冲区重绘次数。*/
		public static var canvasReCache:int = 0;
		/** 表示当前使用的是否为慢渲染模式。*/
		public static var renderSlow:Boolean = false;
		/** 资源管理器所管理资源的累计内存,以字节为单位。*/
		public static var currentMemorySize:int;
		
		private static var _fpsStr:String;
		private static var _canvasStr:String;
		private static var _canvas:HTMLCanvas;
		private static var _ctx:Context;
		private static var _timer:Number = 0;
		private static var _count:int = 0;
		private static var _width:int = 120;
		private static var _height:int = 100;
		private static var _view:Array = [];
		private static var _fontSize:int = 12;
		private static var _first:Boolean;
		private static var _vx:Number;
		
		/**
		 * 显示帧频信息。
		 * @param	x X轴显示位置。
		 * @param	y Y轴显示位置。
		 */
		public static function show(x:Number = 0, y:Number = 0):void {
			if (Render.isConchApp) {
				__JS__("conch.showFPS&&conch.showFPS(x,y)");
				return;
			}
			var pixel:Number = Browser.pixelRatio;
			_width = pixel * 120;
			_vx = pixel * 70;
			
			_view[0] = {title: "FPS(Canvas)", value: "_fpsStr", color: "yellow", units: "int"};
			_view[1] = {title: "Sprite", value: "spriteCount", color: "white", units: "int"};
			_view[2] = {title: "DrawCall", value: "drawCall", color: "white", units: "int"};
			_view[3] = {title: "CurMem", value: "currentMemorySize", color: "yellow", units: "M"};
			if (Render.isWebGL) {
				_view[4] = {title: "Shader", value: "shaderCall", color: "white", units: "int"};
				if (!Render.is3DMode) {
					_view[0].title = "FPS(WebGL)";
					
					_view[5] = {title: "Canvas", value: "_canvasStr", color: "white", units: "int"};
				} else {
					_view[0].title = "FPS(3D)";
					_view[5] = {title: "TriFaces", value: "trianglesFaces", color: "white", units: "int"};
				}
			} else {
				_view[4] = {title: "Canvas", value: "_canvasStr", color: "white", units: "int"};
			}
			
			_fontSize = 12 * pixel;
			for (var i:int = 0; i < _view.length; i++) {
				_view[i].x = 4;
				_view[i].y = i * _fontSize + 2 * pixel;
			}
			_height = pixel * (_view.length * 12 + 3 * pixel);
			
			if (!_canvas) {
				_canvas = new HTMLCanvas('2D');
				_canvas.size(_width, _height);
				_ctx = _canvas.getContext('2d');
				_ctx.textBaseline = "top";
				_ctx.font = _fontSize + "px Sans-serif";
				
				_canvas.source.style.cssText = "pointer-events:none;background:rgba(150,150,150,0.8);z-index:100000;position: absolute;left:" + x + "px;top:" + y + "px;width:" + (_width / pixel) + "px;height:" + (_height / pixel) + "px;";
			}
			_first = true;
			loop();
			_first = false;
			Browser.container.appendChild(_canvas.source);
			enable();
		}
		
		/**激活帧率统计*/
		public static function enable():void {
			Laya.timer.frameLoop(1, Stat, loop);
		}
		
		/**
		 * 隐藏帧频信息。
		 */
		public static function hide():void {
			Browser.removeElement(_canvas.source);
			Laya.timer.clear(Stat, loop);
		}
		
		/**
		 * @private
		 * 清除帧频计算相关的数据。
		 */
		public static function clear():void {
			trianglesFaces = drawCall = shaderCall = spriteCount = canvasNormal = canvasBitmap = canvasReCache = 0;
		}
		
		/**
		 * 点击帧频显示区域的处理函数。
		 */
		public static function set onclick(fn:Function):void {
			_canvas.source.onclick = fn;
			_canvas.source.style.pointerEvents = '';
		}
		
		/**
		 * @private
		 * 帧频计算循环处理函数。
		 */
		public static function loop():void {
			_count++;
			var timer:Number = Browser.now();
			if (timer - _timer < 1000) return;
			
			var count:int = _count;
			//计算更精确的FPS值
			FPS = Math.round((count * 1000) / (timer - _timer));
			
			if (_canvas) {
				//计算平均值
				trianglesFaces = Math.round(trianglesFaces / count);
				drawCall = Math.round(drawCall / count) - 2;
				shaderCall = Math.round(shaderCall / count);
				spriteCount = Math.round(spriteCount / count) - 1;
				canvasNormal = Math.round(canvasNormal / count);
				canvasBitmap = Math.round(canvasBitmap / count);
				canvasReCache = Math.ceil(canvasReCache / count);
				
				_fpsStr = FPS + (renderSlow ? " slow" : "");
				_canvasStr = canvasReCache + "/" + canvasNormal + "/" + canvasBitmap;
				currentMemorySize = ResourceManager.systemResourceManager.memorySize;
				
				var ctx:Context = _ctx;
				ctx.clearRect(_first ? 0 : _vx, 0, _width, _height);
				for (var i:int = 0; i < _view.length; i++) {
					var one:* = _view[i];
					//只有第一次才渲染标题文字，减少文字渲染次数
					if (_first) {
						ctx.fillStyle = "white";
						ctx.fillText(one.title, one.x, one.y, null, null, null);
					}
					ctx.fillStyle = one.color;
					var value:* = Stat[one.value];
					(one.units == "M") && (value = Math.floor(value / (1024 * 1024) * 100) / 100 + " M");
					ctx.fillText(value + "", one.x + _vx, one.y, null, null, null);
				}
				clear();
			}
			_count = 0;
			_timer = timer;
		}
	}
}