package laya.utils {
	import laya.renders.Render;
	import laya.resource.Bitmap;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.Resource;
	import laya.resource.ResourceManager;
	//import laya.webgl.utils.Buffer;
	
	/**
	 * 帧率统计
	 * @author yung
	 */
	public class Stat {
		public static var loopCount:int = 0;
		public static var maxMemorySize:int = 0;
		public static var currentMemorySize:int = 0;
		public static var texturesMemSize:int = 0;
		public static var buffersMemSize:int = 0;
		public static var shaderCall:int = 0;
		public static var drawCall:int = 0;
		public static var trianglesFaces:int = 0;
		public static var spriteDraw:int = 0;
		public static var FPS:int = 0;
		public static var canvasNormal:int = 0;
		public static var canvasBitmap:int = 0;
		public static var canvasReCache:int = 0;
		public static var interval:int = 0;
		public static var preFrameTime:int = 0;
		public static var bufferLen:int = 0;
		
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
		
		public static function show(x:Number = 0, y:Number = 0):void {
			preFrameTime = _timer = Browser.now() - 1000;
			_view[0] = {title: "FPS(3D)", value: "_fpsStr", color: "yellow", units: "int"};
			_view[1] = {title: "Sprite", value: "spriteDraw", color: "white", units: "int"};
			_view[2] = {title: "DrawCall", value: "drawCall", color: "white", units: "int"};
			_view[3] = {title: "Canvas", value: "_canvasStr", color: "white", units: "int"};
			_view[4] = {title: "MaxMem", value: "maxMemorySize", color: "white", units: "M"};
			_view[5] = {title: "CurMem", value: "currentMemorySize", color: "Yellow", units: "M"};
			_view[6] = {title: "TexMem", value: "texturesMemSize", color: "LightGoldenRodYellow", units: "M"};
			_view[7] = {title: "BufMem", value: "buffersMemSize", color: "LightGoldenRodYellow", units: "M"};
			_view[8] = {title: "Shader", value: "shaderCall", color: "white", units: "int"};
			_view[9] = {title: "TriFaces", value: "trianglesFaces", color: "white", units: "int"};
			_view[10] = {title: "BufLen", value: "bufferLen", color: "white", units: "int"};
			if (!Render.isWebGl) {
				_view[0].title = "FPS(2D)";
				_view.length = 4;
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
			Browser.document.body.appendChild(_canvas.source);
		}
		
		public static function hide():void {
			var canvas:* = _canvas.source;
			Browser.removeElement(canvas);
			Laya.timer.clear(Stat, loop);
		}
		
		public static function clear():void {
			trianglesFaces = 0;
			drawCall = 0;
			shaderCall = 0;
			spriteDraw = -1;
			bufferLen = 0;
			canvasNormal = 0;
			canvasBitmap = 0;
			canvasReCache = 0;
		}
		
		public static function set onclick(fn:Function):void
		{
			_canvas.source.onclick = fn;
			_canvas.source.style.pointerEvents='';
		}
		
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
			
			_fpsStr = _count +(renderSlow?" slow":"");
			_canvasStr = canvasReCache+ "/" + canvasNormal+"/"+canvasBitmap;
			
			var ctx:* = _ctx;
			ctx.clearRect(0, 0, _width, _height);
			ctx.fillStyle = "rgba(50,50,60,0.8)";
			ctx.fillRect(0, 0, _width, _height);
			for ( i = 0; i < _view.length; i++) {
				var one:* = _view[i];
				ctx.fillStyle = "white";
				ctx.fillText(one.title, one.x, one.y);
				ctx.fillStyle = one.color;
				var value:* = Stat[one.value];
				(one.units == "M") && (value = Math.floor(value / (1024 * 1024) * 100) / 100 + " M");
				ctx.fillText(value + "", one.x + 60, one.y);
			}
			_count = 0;
			_timer = timer;
			clear();
		}
	}
}