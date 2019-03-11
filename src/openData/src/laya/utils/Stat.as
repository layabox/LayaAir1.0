package laya.utils {
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.ResourceManager;
	
	/**
	 * <p> <code>Stat</code> 是一个性能统计面板，可以实时更新相关的性能参数。</p>
	 * <p>参与统计的性能参数如下（所有参数都是每大约1秒进行更新）：<br/>
	 * FPS(Canvas)/FPS(WebGL)：Canvas 模式或者 WebGL 模式下的帧频，也就是每秒显示的帧数，值越高、越稳定，感觉越流畅；<br/>
	 * Sprite：统计所有渲染节点（包括容器）数量，它的大小会影响引擎进行节点遍历、数据组织和渲染的效率。其值越小，游戏运行效率越高；<br/>
	 * DrawCall：此值是决定性能的重要指标，其值越小，游戏运行效率越高。Canvas模式下表示每大约1秒的图像绘制次数；WebGL模式下表示每大约1秒的渲染提交批次，每次准备数据并通知GPU渲染绘制的过程称为1次DrawCall，在每次DrawCall中除了在通知GPU的渲染上比较耗时之外，切换材质与shader也是非常耗时的操作；<br/>
	 * CurMem：Canvas模式下，表示内存占用大小，值越小越好，过高会导致游戏闪退；WebGL模式下，表示内存与显存的占用，值越小越好；<br/>
	 * Shader：是 WebGL 模式独有的性能指标，表示每大约1秒 Shader 提交次数，值越小越好；<br/>
	 * Canvas：由三个数值组成，只有设置 CacheAs 后才会有值，默认为0/0/0。从左到右数值的意义分别为：每帧重绘的画布数量 / 缓存类型为"normal"类型的画布数量 / 缓存类型为"bitmap"类型的画布数量。</p>
	 */
	public class Stat {
		/** 每秒帧数。*/
		public static var FPS:int = 0;
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
		/** 精灵渲染使用缓存<code>Sprite</code> 的数量。*/
		public static var spriteRenderUseCacheCount:int = 0;
		/** 八叉树节点检测次数。*/
		public static var treeNodeCollision:int = 0;
		/** 八叉树精灵碰撞检测次数。*/
		public static var treeSpriteCollision:int = 0;
		
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
		private static var _spriteStr:String;
		private static var _fpsData:Array = [];
		private static var _timer:Number = 0;
		private static var _count:int = 0;
		private static var _view:Array = [];
		private static var _fontSize:int = 12;
		private static var _txt:Text;
		static private var _leftText:Text;
		/**@private */
		public static var _sp:Sprite;
		/**@private */
		public static var _titleSp:Sprite;
		/**@private */
		public static var _bgSp:Sprite;
		/**@private */
		public static var _show:Boolean = false;
		
		public static var _useCanvas:Boolean = false;
		private static var _canvas:HTMLCanvas;
		private static var _ctx:Context;
		private static var _first:Boolean;
		private static var _vx:Number;
		private static var _width:int;
		private static var _height:int = 100;
		
		/**
		 * 显示性能统计信息。
		 * @param	x X轴显示位置。
		 * @param	y Y轴显示位置。
		 */
		public static function show(x:Number = 0, y:Number = 0):void {
			if (!Browser.onMiniGame && !Browser.onLimixiu) _useCanvas = true;
			_show = true;
			_fpsData.length = 60;
			if (Render.isConchApp) {
				_view[0] = {title: "FPS", value: "_fpsStr", color: "yellow", units: "int"};
			} else {
				_view[0] = {title: "FPS(Canvas)", value: "_fpsStr", color: "yellow", units: "int"};
			}
			_view[1] = {title: "Sprite", value: "_spriteStr", color: "white", units: "int"};
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
					_view[6] = {title: "treeNodeColl", value: "treeNodeCollision", color: "white", units: "int"};
					_view[7] = {title: "treeSpriteColl", value: "treeSpriteCollision", color: "white", units: "int"};
				}
			} else {
				//_view[4] = {title: "Canvas", value: "_canvasStr", color: "white", units: "int"};
			}
			
			if (_useCanvas) {
				createUIPre(x, y);
			} else
				createUI(x, y);
			
			enable();
		}
		
		private static function createUIPre(x:Number, y:Number):void {
			var pixel:Number = Browser.pixelRatio;
			_width = pixel * 130;
			_vx = pixel * 75;
			_height = pixel * (_view.length * 12 + 3 * pixel) + 4;
			_fontSize = 12 * pixel;
			for (var i:int = 0; i < _view.length; i++) {
				_view[i].x = 4;
				_view[i].y = i * _fontSize + 2 * pixel;
			}
			if (Render.isConchApp) {
				_sp = new Sprite();
				_titleSp = new Sprite();
				_bgSp = new Sprite();
				_bgSp.graphics.drawRect(x, y, _width, _height, "#969696");
				_bgSp.alpha = 0.8;
				
				_sp.zOrder = 100000;	// 让stat显示在最前面
				_titleSp.zOrder = 100000;
				_bgSp.zOrder = 100000;
				_bgSp.addChild(_sp);
				_bgSp.addChild(_titleSp);
				Laya.stage.addChild(_bgSp);
			} else {
				if (!_canvas) {
					_canvas = new HTMLCanvas(true);
					_canvas.size(_width, _height);
					_ctx = _canvas.getContext('2d');
					_ctx.textBaseline = "top";
					_ctx.font = _fontSize + "px Arial";
					
					_canvas.source.style.cssText = "pointer-events:none;background:rgba(150,150,150,0.8);z-index:100000;position: absolute;direction:ltr;left:" + x + "px;top:" + y + "px;width:" + (_width / pixel) + "px;height:" + (_height / pixel) + "px;";
				}
				Browser.container.appendChild(_canvas.source);
			}
			_first = true;
			loop();
			_first = false;
		}
		
		private static function createUI(x:Number, y:Number):void {
			var stat:Sprite = _sp;
			var pixel:Number = Browser.pixelRatio;
			if (!stat) {
				stat = new Sprite();
				_leftText = new Text();
				_leftText.pos(5, 5);
				_leftText.color = "#ffffff";
				stat.addChild(_leftText);
				
				_txt = new Text();
				_txt.pos(80 * pixel, 5);
				_txt.color = "#ffffff";
				stat.addChild(_txt);
				_sp = stat;
			}
			
			stat.pos(x, y);
			
			var text:String = "";
			for (var i:int = 0; i < _view.length; i++) {
				var one:* = _view[i];
				text += one.title + "\n";
			}
			_leftText.text = text;
			
			//调整为合适大小和字体			
			var width:Number = pixel * 138;
			var height:Number = pixel * (_view.length * 12 + 3 * pixel) + 4;
			_txt.fontSize = _fontSize * pixel;
			_leftText.fontSize = _fontSize * pixel;
			
			stat.size(width, height);
			stat.graphics.clear();
			stat.graphics.alpha(0.5);
			stat.graphics.drawRect(0, 0, width, height, "#999999");
			stat.graphics.alpha(2);
			loop();
		}
		
		/**激活性能统计*/
		public static function enable():void {
			Laya.systemTimer.frameLoop(1, Stat, loop);
		}
		
		/**
		 * 隐藏性能统计信息。
		 */
		public static function hide():void {
			_show = false;
			Laya.systemTimer.clear(Stat, loop);
			if (_canvas) {
				Browser.removeElement(_canvas.source);
			}
		}
		
		/**
		 * @private
		 * 清零性能统计计算相关的数据。
		 */
		public static function clear():void {
			trianglesFaces = drawCall = shaderCall = spriteCount = spriteRenderUseCacheCount = treeNodeCollision = treeSpriteCollision = canvasNormal = canvasBitmap = canvasReCache = 0;
		}
		
		/**
		 * 点击性能统计显示区域的处理函数。
		 */
		public static function set onclick(fn:Function):void {
			if (_sp) {
				_sp.on("click", _sp, fn);
			}
			if (_canvas) {
				_canvas.source.onclick = fn;
				_canvas.source.style.pointerEvents = '';
			}
		}
		
		/**
		 * @private
		 * 性能统计参数计算循环处理函数。
		 */
		public static function loop():void {
			_count++;
			var timer:Number = Browser.now();
			if (timer - _timer < 1000) return;
			
			var count:int = _count;
			//计算更精确的FPS值
			FPS = Math.round((count * 1000) / (timer - _timer));
			
			if (_show) {
				//计算平均值
				trianglesFaces = Math.round(trianglesFaces / count);
				
				if (!_useCanvas) {
					drawCall = Math.round(drawCall / count) - 1;
					shaderCall = Math.round(shaderCall / count);
					spriteCount = Math.round(spriteCount / count) - 4;
				} else {
					drawCall = Math.round(drawCall / count);
					shaderCall = Math.round(shaderCall / count);
					spriteCount = Math.round(spriteCount / count) - 1;
				}
				spriteRenderUseCacheCount = Math.round(spriteRenderUseCacheCount / count);
				canvasNormal = Math.round(canvasNormal / count);
				canvasBitmap = Math.round(canvasBitmap / count);
				canvasReCache = Math.ceil(canvasReCache / count);
				treeNodeCollision = Math.round(treeNodeCollision / count);
				treeSpriteCollision = Math.round(treeSpriteCollision / count);
				
				var delay:String = FPS > 0 ? Math.floor(1000 / FPS).toString() : " ";
				_fpsStr = FPS + (renderSlow ? " slow" : "") + " " + delay;
				_spriteStr = spriteCount + (spriteRenderUseCacheCount ? ("/" + spriteRenderUseCacheCount) : '');
				_canvasStr = canvasReCache + "/" + canvasNormal + "/" + canvasBitmap;
				currentMemorySize = ResourceManager.systemResourceManager.memorySize;
				if (_useCanvas) {
					renderInfoPre();
				} else
					renderInfo();
				clear();
			}
			
			_count = 0;
			_timer = timer;
		}
		
		private static function renderInfoPre():void {
			var i:int = 0;
			var one:*;
			var value:*;
			if (Render.isConchApp) {
				_sp.graphics.clear();
				for ( i = 0; i < _view.length; i++) {
					one = _view[i];
					//只有第一次才渲染标题文字，减少文字渲染次数
					if (_first) {
						_titleSp.graphics.fillText(one.title, one.x, one.y, _fontSize + "px Arial", "#ffffff", "left");
					}
					value = Stat[one.value];
					(one.units == "M") && (value = Math.floor(value / (1024 * 1024) * 100) / 100 + " M");
					_sp.graphics.fillText(value + "", one.x + _vx, one.y, _fontSize + "px Arial", one.color, "left");
				}
			} else {
				if (_canvas) {
					var ctx:Context = _ctx;
					ctx.clearRect(_first ? 0 : _vx, 0, _width, _height);
					for (i = 0; i < _view.length; i++) {
						one = _view[i];
						//只有第一次才渲染标题文字，减少文字渲染次数
						if (_first) {
							ctx.fillStyle = "white";
							ctx.fillText(one.title, one.x, one.y);
						}
						ctx.fillStyle = one.color;
						value = Stat[one.value];
						(one.units == "M") && (value = Math.floor(value / (1024 * 1024) * 100) / 100 + " M");
						ctx.fillText(value + "", one.x + _vx, one.y);
					}
				}
			}
		}
		
		private static function renderInfo():void {
			var text:String = "";
			for (var i:int = 0; i < _view.length; i++) {
				var one:* = _view[i];
				var value:* = Stat[one.value];
				(one.units == "M") && (value = Math.floor(value / (1024 * 1024) * 100) / 100 + " M");
				(one.units == "K") && (value = Math.floor(value / (1024) * 100) / 100 + " K");
				text += value + "\n";
			}
			_txt.text = text;
		}
	}
}