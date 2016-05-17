package laya.display {
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	
	/**
	 * 动画播放完毕后调度。
	 * @eventType Event.COMPLETE
	 */
	[Event(name = "complete", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Animation</code> 类是位图动画,用于创建位图动画。</p>
	 * <p> <code>Animation</code> 类可以加载并显示一组位图图片，并组成动画进行播放。</p>
	 * @example 以下示例代码，创建了一个 <code>Text</code> 实例。
	 * <listing version="3.0">
	 * package
	 * {
	 * 	import laya.display.Animation;
	 * 	import laya.net.Loader;
	 * 	import laya.utils.Handler;
	 *
	 * 	public class Animation_Example
	 * 	{
	 * 		public function Animation_Example()
	 * 		{
	 * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 * 			init();//初始化
	 * 		}
	 *
	 * 		private function init():void
	 * 		{
	 * 			var animation:Animation = new Animation();//创建一个 Animation 类的实例对象 animation 。
	 * 			animation.loadAtlas("resource/ani/fighter.json");//加载图集并播放
	 * 			animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 * 			animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 * 			animation.interval = 30;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
	 * 			animation.play();//播放动画。
	 * 			Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
	 * 		}
	 * 	}
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * Animation_Example();
	 * function Animation_Example(){
	 *     Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *     Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *     init();//初始化
	 * }
	 * function init()
	 * {
	 *     var animation = new Animation();//创建一个 Animation 类的实例对象 animation 。
	 * 	   animation.loadAtlas("resource/ani/fighter.json");//加载图集并播放
	 *     animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 *     animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 *     animation.interval = 30;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
	 *     animation.play();//播放动画。
	 *     Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import Loader = laya.net.Loader;
	 * import Handler = laya.utils.Handler;
	 *  class Animation_Example {
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load("resource/ani/fighter.json", Handler.create(this, this.onLoadComplete), null, Loader.ATLAS);
	 *     }
	 *
	 *     private init(): void {
	 *         var animation:Animation = new Animation();//创建一个 Animation 类的实例对象 animation 。
	 * 		   animation.loadAtlas("resource/ani/fighter.json");//加载图集并播放
	 *         animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 *         animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 *         animation.interval = 30;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
	 *         animation.play();//播放动画。
	 *         Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
	 *     }
	 * }
	 * </listing>
	 */
	public class Animation extends Sprite {
		/**全局缓存动画索引，存储全局Graphics动画数据，可以指定播放某个动画，比如ani.play(0 , true ,"hero_run"); */
		public static var framesMap:Object = {};
		/** 播放间隔(单位：毫秒)。*/
		public var interval:int = Config.animationInterval;
		/**是否循环播放 */
		public var loop:Boolean;
		/**@private */
		protected var _frames:Array;
		/**@private */
		protected var _index:int;
		/**@private */
		protected var _count:int;
		/**@private */
		protected var _isPlaying:Boolean;
		
		/**
		 * 创建一个新的 <code>Animation</code> 实例。
		 */
		public function Animation():void {
			on(Event.DISPLAY, this, _onDisplay);
			on(Event.UNDISPLAY, this, _onDisplay);
		}
		
		/** @inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			stop();
			super.destroy(destroyChild);
			this._frames = null;
		}
		
		private function _onDisplay():void {
			if (_isPlaying) {
				if (_displayInStage) play(_index, loop);
				else clearTimer(this, _frameLoop);
			}
		}
		
		/**
		 * 播放动画。
		 * @param	start 开始播放的动画索引。
		 * @param	loop 是否循环。
		 * @param	name 如果name为空(可选)，则播放当前动画，如果不为空，则播放全局缓存动画（如果有）
		 */
		public function play(start:int = 0, loop:Boolean = true, name:String = ""):void {
			if (name && framesMap[name]) {
				this._frames = framesMap[name];
				this._count = _frames.length;
			}
			this._isPlaying = true;
			this.index = start;
			this.loop = loop;
			if (this._frames && this._frames.length > 0 && this.interval > 0) {
				_index++;
				timerLoop(this.interval, this, _frameLoop, null, true);
			}
		}
		
		private function _frameLoop():void {
			if (_style.visible && _style.alpha > 0.01) {
				this.index = _index, _index++;
				if (this._index >= this._count) {
					if (loop) this._index = 0;
					else {
						_index--;
						stop();
					}
					event(Event.COMPLETE);
				}
			}
		}
		
		/**
		 * 停止播放。
		 */
		public function stop():void {
			this._isPlaying = false;
			clearTimer(this, _frameLoop);
		}
		
		/**当前播放索引。*/
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			_index = value;
			if (this._frames) this.graphics = this._frames[value];
		}
		
		/**动画长度。*/
		public function get count():int {
			return _count;
		}
		
		/**Graphics集合*/
		public function get frames():Array {
			return _frames;
		}
		
		public function set frames(value:Array):void {
			this._frames = value;
			if (value) {
				this._count = value.length;
				if (_isPlaying) play(_index, loop);
				else index = _index;
			}
		}
		
		/**清理。方便对象复用。*/
		public function clear():void {
			stop();
			this.graphics = null;
			this._frames = null;
		}
		
		/**
		 * 加载图片集合，组成动画。
		 * @param	urls 图片地址集合。如：[url1,url2,url3,...]。
		 * @return 	返回动画本身。
		 */
		public function loadImages(urls:Array):Animation {
			this.frames = createFrames(urls, "");
			return this;
		}
		
		/**
		 * 加载并播放一个图集。
		 * @param	url 图集地址。
		 * @return 	返回动画本身。
		 */
		public function loadAtlas(url:String):Animation {
			if (Loader.getAtlas(url)) onLoaded(url);
			else Laya.loader.load(url, Handler.create(null, onLoaded, [url]), null, Loader.ATLAS);
			function onLoaded(loadUrl:String):void {
				if (url === loadUrl) {
					this.frames = createFrames(url, "");
				}
			}
			return this;
		}
		
		/**
		 * 创建动画模板，相同地址的动画可共享播放模板，而不必每次都创建一份新的，从而节省创建Graphics集合的开销
		 * @param	url 图集路径(已经加载过的)或者url数组(可以异步加载)
		 * @param	name 全局动画名称，如果name不为空，则缓存动画模板，否则不缓存
		 * @return	Graphics动画模板
		 */
		public static function createFrames(url:*, name:String):Array {
			var arr:Array;
			if (url is String) {
				var atlas:Array = Loader.getAtlas(url);
				if (atlas && atlas.length) {
					arr = [];
					for (var i:int = 0, n:int = atlas.length; i < n; i++) {
						var g:Graphics = new Graphics();
						g.drawTexture(atlas[i], 0, 0);
						arr.push(g);
					}
				}
			} else if (url is Array) {
				arr = [];
				for (i = 0, n = url.length; i < n; i++) {
					g = new Graphics();
					g.loadImage(url[i], 0, 0);
					arr.push(g);
				}
			}
			if (name) framesMap[name] = arr;
			return arr;
		}
	}
}