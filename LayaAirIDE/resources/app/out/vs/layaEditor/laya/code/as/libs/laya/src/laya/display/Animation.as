package laya.display {
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
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
		/**@private */
		private static var _urlReg:RegExp = /^(.*?)\{(.*?)\}(.*)$/;
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
		 */
		public function play(start:int = 0, loop:Boolean = true):void {
			this._isPlaying = true;
			this._index = start;
			this.loop = loop;
			if (this._frames && this._frames.length > 0 && this.interval > 0) {
				timerLoop(this.interval, this, _frameLoop, null, true);
			}
		}
		
		private function _frameLoop():void {
			if (_style.visible) {
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
			this._count = value.length;
			if (_isPlaying) play(_index, loop)
			else index = _index;
		}
		
		/**
		 * 加载图片集合，组成动画。
		 * @param	urls 图片地址集合。如：[url1,url2,url3,...]。
		 * @return 	返回动画本身。
		 */
		public function loadImages(urls:Array):Animation {
			var arr:Array = [];
			for (var i:int = 0, n:int = urls.length; i < n; i++) {
				var g:Graphics = new Graphics();
				g.loadImage(urls[i], 0, 0);
				arr.push(g);
			}
			this.frames = arr;
			return this;
		}
		
		/**清理。方便对象复用。*/
		public function clear():void {
			stop();
			this.graphics = null;
			this._frames = null;
		}
		
		/**
		 * 加载并播放一个图集。
		 * @param	url 图集地址。
		 * @return 	返回动画本身。
		 */
		public function loadAtlas(url:String):Animation {
			if (Loader.getAtlas(url)) onLoaded();
			else Laya.loader.load(url, Handler.create(null, onLoaded), null, Loader.ATLAS);
			function onLoaded():void {
				var atlas:Array = Loader.getAtlas(url);
				if (atlas && atlas.length) {
					var arr:Array = [];
					for (var i:int = 0, n:int = atlas.length; i < n; i++) {
						var g:Graphics = new Graphics();
						g.drawTexture(atlas[i], 0, 0);
						arr.push(g);
					}
					this.frames = arr;
				}
			}
			return this;
		}
		
		/**
		 * 根据地址创建一个动画。
		 * @param	url 第一张图片的url地址，变化的参数用“{}”包含，比如res/ani{001}.png
		 * @param	count 动画数量，会根据此数量替换url参数，比如url=res/ani{001}.png，count=3，会得到ani001.png，ani002.png，ani003.png
		 * @return	返回一个 Animation 对象。
		 */
		public static function fromUrl(url:String, count:int):Animation {
			var result:Array = _urlReg.exec(url);
			var base:String = result[1];
			var serialNum:String = result[2];
			var extension:String = result[3];
			var serialNumBegin:int = parseInt(serialNum);
			var serialNumLength:int = serialNum.length;
			
			var urls:Array = [];
			for (var i:int = 0; i < count; i++) {
				var countNow:int = serialNumBegin + i;
				var countString:String = Utils.preFixNumber(countNow, serialNumLength);
				urls.push(base + countString + extension);
			}
			
			return new Animation().loadImages(urls);
		}
	}
}