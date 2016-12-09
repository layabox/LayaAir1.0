package laya.display {
	import laya.net.Loader;
	import laya.utils.Handler;
	
	/**
	 * 动画播放完毕后调度。
	 * @eventType Event.COMPLETE
	 */
	[Event(name = "complete", type = "laya.events.Event")]
	
	/**
	 * 播放到某标签后调度。
	 * @eventType Event.LABEL
	 */
	[Event(name = "label", type = "laya.events.Event")]
	
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
	 * 	public class Animation_Example
	 * 	{
	 * 		public function Animation_Example()
	 * 		{
	 * 			Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 * 			Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 * 			init();//初始化
	 * 		}
	 * 		private function init():void
	 * 		{
	 * 			var animation:Animation = new Animation();//创建一个 Animation 类的实例对象 animation 。
	 * 			animation.loadAtlas("resource/ani/fighter.json");//加载图集并播放
	 * 			animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 * 			animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 * 			animation.interval = 50;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
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
	 *     var animation = new Laya.Animation();//创建一个 Animation 类的实例对象 animation 。
	 *     animation.loadAtlas("resource/ani/fighter.json");//加载图集并播放
	 *     animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 *     animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 *     animation.interval = 50;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
	 *     animation.play();//播放动画。
	 *     Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import Animation = laya.display.Animation;
	 * class Animation_Example {
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         this.init();
	 *     }
	 *     private init(): void {
	 *         var animation:Animation = new Laya.Animation();//创建一个 Animation 类的实例对象 animation 。
	 *         animation.loadAtlas("resource/ani/fighter.json");//加载图集并播放
	 *         animation.x = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 *         animation.y = 200;//设置 animation 对象的属性 x 的值，用于控制 animation 对象的显示位置。
	 *         animation.interval = 50;//设置 animation 对象的动画播放间隔时间，单位：毫秒。
	 *         animation.play();//播放动画。
	 *         Laya.stage.addChild(animation);//将 animation 对象添加到显示列表。
	 *     }
	 * }
	 * new Animation_Example();
	 * </listing>
	 */
	public class Animation extends AnimationPlayerBase {
		/**全局缓存动画索引，存储全局Graphics动画数据，可以指定播放某个动画，比如ani.play(0 , true ,"hero_run"); */
		public static var framesMap:Object = {};
		/**@private */
		protected var _frames:Array;
		/**@private */
		protected var _url:String;
		
		/**
		 * 创建一个新的 <code>Animation</code> 实例。
		 */
		public function Animation():void {
			_setControlNode(this);
		}
		
		/** @inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			stop();
			super.destroy(destroyChild);
			this._frames = null;
			this._labels = null;
		}
		
		/**
		 * 播放动画。
		 * @param	start 开始播放的动画索引或label。
		 * @param	loop 是否循环。
		 * @param	name 如果name为空(可选)，则播放当前动画，如果不为空，则播放全局缓存动画（如果有）
		 */
		override public function play(start:* = 0, loop:Boolean = true, name:String = ""):void {
			if (name) _setFramesFromCache(name);
			this._isPlaying = true;
			this.index = (start is String) ? _getFrameByLabel(start) : start;
			this.loop = loop;
			this._actionName = name;
			_isReverse = wrapMode == 1;
			if (this._frames && this.interval > 0) {
				timerLoop(this.interval, this, _frameLoop, null, true);
			}
		}
		
		protected function _setFramesFromCache(name:String):Boolean {
			if (_url) name = _url + "#" + name;
			if (name && framesMap[name]) {
				this._frames = framesMap[name];
				this._count = _frames.length;
				//如果是读取动的画配置信息，帧率按照动画设置的帧率播放
				if (!_frameRateChanged && framesMap[name+"$len"]) _interval = framesMap[name+"$len"];
				return true;
			}
			return false;
		}
		
		override protected function _frameLoop():void {
			if (_style.visible && _style.alpha > 0.01) {
				super._frameLoop();
			}
		}
		
		override protected function _displayToIndex(value:int):void {
			if (this._frames) this.graphics = this._frames[value];
		}
		
		/**Graphics集合*/
		public function get frames():Array {
			return _frames;
		}
		
		public function set frames(value:Array):void {
			this._frames = value;
			if (value) {
				this._count = value.length;
				if (_isPlaying) play(_index, loop, _actionName);
				else index = _index;
			}
		}
		
		/**图集地址或者图片集合*/
		public function set source(value:String):void {
			if (value.indexOf(".ani") > -1) loadAnimation(value);
			else if (value.indexOf(".json") > -1 || value.indexOf("als") > -1) loadAtlas(value);
			else loadImages(value.split(","));
		}
		
		/**是否自动播放*/
		public function set autoPlay(value:Boolean):void {
			if (value) play();
			else stop();
		}
		
		/**清理。方便对象复用。*/
		override public function clear():void {
			stop();
			this.graphics = null;
			this._frames = null;
			this._labels = null;
		}
		
		/**
		 * 加载图片集合，组成动画。
		 * @param	urls	图片地址集合。如：[url1,url2,url3,...]。
		 * @param	cacheName 缓存为模板的名称，下次可以直接使用play调用，无需重新创建动画模板，设置为空则不缓存
		 * @return 	返回动画本身。
		 */
		public function loadImages(urls:Array, cacheName:String = ""):Animation {
			this._url = "";
			if (!_setFramesFromCache(cacheName)) {
				this.frames = framesMap[cacheName] ? framesMap[cacheName] : createFrames(urls, cacheName);
			}
			return this;
		}
		
		/**
		 * 加载并播放一个图集。
		 * @param	url 	图集地址。
		 * @param	loaded	加载完毕回调
		 * @param	cacheName 缓存为模板的名称，下次可以直接使用play调用，无需重新创建动画模板，设置为空则不缓存
		 * @return 	返回动画本身。
		 */
		public function loadAtlas(url:String, loaded:Handler = null, cacheName:String = ""):Animation {
			this._url = "";
			var _this:Animation = this;
			if (!_this._setFramesFromCache(cacheName)) {
				function onLoaded(loadUrl:String):void {
					if (url === loadUrl) {
						_this.frames = framesMap[cacheName] ? framesMap[cacheName] : createFrames(url, cacheName);
						if (loaded) loaded.run();
					}
				}
				if (Loader.getAtlas(url)) onLoaded(url);
				else Laya.loader.load(url, Handler.create(null, onLoaded, [url]), null, Loader.ATLAS);
			}
			return this;
		}
		
		/**
		 * 加载并播放一个由IDE制作的动画，播放的帧率按照IDE设计的帧率
		 * @param	url 	动画地址。
		 * @param	loaded	加载完毕回调
		 * @return 	返回动画本身。
		 */
		public function loadAnimation(url:String, loaded:Handler = null):Animation {
			this._url = url;
			var _this:Animation = this;
			if (!_this._setFramesFromCache("")) {
				function onLoaded(loadUrl:String):void {
					if (url === loadUrl) {
						if (!framesMap[url + "#"]) {
							var aniData:Object = _this._parseGraphicAnimation(Loader.getRes(url));
							if (!aniData) return;
							
							//缓存动画数据
							var obj:Object = aniData.animationDic;
							var flag:Boolean = true;
							for (var name:String in obj) {
								var info:Object = obj[name];
								if (info.frames.length) {
									framesMap[url + "#" + name] = info.frames;
									framesMap[url + "#" + name+"$len"] = info.interval;
								} else {
									flag = false;
								}
							}
							
							//设置第一个为默认
							if(!_this._frameRateChanged) _this._interval=aniData.animationList[0].interval;
							_this.frames = aniData.animationList[0].frames;							
							if (flag) {							
								framesMap[url + "#$len"] = aniData.animationList[0].interval;
								framesMap[url + "#"] = _this.frames;
							}
						} else {
							if(!_this._frameRateChanged) _this._interval=framesMap[url + "#$len"];
							_this.frames = framesMap[url + "#"];							
						}
						
						if (loaded) loaded.run();
					}
				}
				if (Loader.getRes(url)) onLoaded(url);
				else Laya.loader.load(url, Handler.create(null, onLoaded, [url]), null, Loader.JSON);
				
				//清理掉配置
				Loader.clearRes(url);
			}
			return this;
		}
		
		/**@private */
		protected function _parseGraphicAnimation(animationData:Object):Object {
			return GraphicAnimation.parseAnimationData(animationData)
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
						g.drawTexture(Loader.getRes(atlas[i]), 0, 0);
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
		
		/**
		 * 清除动画缓存数据
		 * @param key 动画名称或路径
		 */
		public static function clearCache(key:String):void {
			var cache:Object = framesMap;
			var val:String;
			var key2:String = key + "#";
			for (val in cache) {
				if (val === key || val.indexOf(key2) == 0) {
					delete framesMap[val];
				}
			}
		}
	}
}