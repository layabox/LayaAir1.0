package laya.utils {
	import laya.renders.Render;
	import laya.resource.Bitmap;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.Resource;
	import laya.resource.ResourceManager;
	
	/**
	 * <code>Stat</code> 用于显示帧率统计信息。
	 */
	public class Stat {
		/**主舞台 <code>Stage</code> 渲染次数计数。 */
		public static var loopCount:int = 0;
		/** 自动释放机制的内存触发上限,以字节为单位。 */
		public static var maxMemorySize:int = 0;//--此处可修改为私有
		/** 资源管理器所管理资源的累计内存,以字节为单位。*/
		public static var currentMemorySize:int = 0;//--此处可修改为私有
		/** 纹理资源所占的内存。 */
		public static var texturesMemSize:int = 0;//--此处可修改为私有
		/** 缓冲区内存大小。*/
		public static var buffersMemSize:int = 0;//--此处可修改为私有--未被有效使用。
		/** 着色器请求次数。*/
		public static var shaderCall:int = 0;
		/** 描绘次数。*/
		public static var drawCall:int = -6;
		/** 三角形面数。*/
		public static var trianglesFaces:int = 0;
		/** 精灵<code>Sprite</code> 的渲染次数。*/
		public static var spriteDraw:int = 0;
		/** 每秒帧数。*/
		public static var FPS:int = 0;
		/** 画布 canvas 使用标准渲染的次数。*/
		public static var canvasNormal:int = 0;
		/** 画布 canvas 使用位图渲染的次数。*/
		public static var canvasBitmap:int = 0;
		/** 画布 canvas 缓冲区重绘次数。*/
		public static var canvasReCache:int = 0;
		/** 当前帧与上一帧的时间间隔，以毫秒为单位。*/
		public static var interval:int = 0;
		/** 记录上一帧的时间戳，以毫秒为单位。*/
		public static var preFrameTime:int = 0;
		/** 上传至缓冲区的数据字节长度。*/
		public static var bufferLen:int = 0;
		/** 表示当前使用的是否为慢渲染模式。*/
		public static var renderSlow:Boolean = false;
		
		private static var _fpsStr:String;
		private static var _canvasStr:String;
		private static var _canvas:HTMLCanvas;
		private static var _ctx:Context;
		private static var _timer:Number;
		private static var _count:int = 0;
		
		private static var _width:int = 120;
		private static var _height:int = 100;
		
		private static var _view:Array = [];
		
		/**
		 * 显示帧频信息。
		 * @param	x X轴显示位置。
		 * @param	y Y轴显示位置。
		 */
		public static function show(x:Number = 0, y:Number = 0):void {
			preFrameTime = _timer = Browser.now() - 1000;
			
			_view[0] = {title: "FPS(Canvas)", value: "_fpsStr", color: "yellow", units: "int"};
			_view[1] = {title: "Sprite", value: "spriteDraw", color: "white", units: "int"};
			_view[2] = {title: "DrawCall", value: "drawCall", color: "white", units: "int"};
			_view[3] = {title: "CurMem", value: "currentMemorySize", color: "yellow", units: "M"};
			if (Render.isWebGL) {
				if (!Render.is3DMode) {
					_view[0].title = "FPS(WebGL)";
					_view[4] = {title: "Canvas", value: "_canvasStr", color: "white", units: "int"};
				} else {
					_view[0].title = "FPS(3D)";
					_view[5] = {title: "TriFaces", value: "trianglesFaces", color: "white", units: "int"};
				}
				_view[4] = { title: "Shader", value: "shaderCall", color: "white", units: "int" };
				_view[5] = {title: "Canvas", value: "_canvasStr", color: "white", units: "int"};
			}
			else
			{
				_view[4] = {title: "Canvas", value: "_canvasStr", color: "white", units: "int"};
			}
			
			for (var i:int = 0; i < _view.length; i++) {
				_view[i].x = 4;
				_view[i].y = i * 12 + 2;
			}
			_height = _view.length * 12 + 4;
			if (!_canvas) {
				_canvas = new HTMLCanvas('2D');
				_canvas.size(_width, _height);
				_ctx = _canvas.getContext('2d');
				_ctx.textBaseline = "top";
				
				var canvas:* = _canvas.source;
				
				canvas.style.cssText = "pointer-events:none;z-index:100000;position: absolute;left:" + x + "px;top:" + y + "px;width:" + _width + "px;height:" + _height + "px;";
			}
			Laya.timer.frameLoop(1, Stat, loop);
			Browser.container.appendChild(_canvas.source);
		}
		
		/**
		 * 隐藏帧频信息。
		 */
		public static function hide():void {
			var canvas:* = _canvas.source;
			Browser.removeElement(canvas);
			Laya.timer.clear(Stat, loop);
		}
		
		/**
		 * @private
		 * 清除帧频计算相关的数据。
		 */
		public static function clear():void {
			trianglesFaces = 0;
			drawCall = -6;
			shaderCall = 0;
			spriteDraw = -1;
			bufferLen = 0;
			canvasNormal = 0;
			canvasBitmap = 0;
			canvasReCache = 0;
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
			interval = Browser.now() - preFrameTime;
			preFrameTime = timer;
			
			if (timer - _timer < 1000) {
				clear();
				return;
			}
			_count = Math.round((_count * 1000) / (timer - _timer));
			
			maxMemorySize = ResourceManager.systemResourceManager.autoReleaseMaxSize;
			
			currentMemorySize = ResourceManager.systemResourceManager.memorySize;
			
			texturesMemSize = 0;
			buffersMemSize = 0;
			for (var i:int = 0; i < Resource.getLoadedResourcesCount(); i++) {
				var resource:Resource = Resource.getLoadedResourceByIndex(i);
				if ((resource is Bitmap))
					texturesMemSize += resource.memorySize;
					//else if (resource is Buffer)
					//buffersMemSize += resource.memorySize;
			}
			
			FPS = _count;
			
			_fpsStr = _count + (renderSlow ? " slow" : "");
			_canvasStr = canvasReCache + "/" + canvasNormal + "/" + canvasBitmap;
			
			var ctx:Context = _ctx;
			ctx.clearRect(0, 0, _width, _height);
			ctx.fillStyle = "rgba(150,150,150,0.8)";
			ctx.fillRect(0, 0, _width, _height, null);
			for (i = 0; i < _view.length; i++) {
				var one:* = _view[i];
				ctx.fillStyle = "white";
				ctx.fillText(one.title, one.x, one.y, null, null, null);
				ctx.fillStyle = one.color;
				var value:* = Stat[one.value];
				(one.units == "M") && (value = Math.floor(value / (1024 * 1024) * 100) / 100 + " M");
				ctx.fillText(value + "", one.x + 70, one.y, null, null, null);
			}
			_count = 0;
			_timer = timer;
			clear();
		}
	}
}