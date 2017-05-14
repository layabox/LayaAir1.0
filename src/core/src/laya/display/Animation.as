package laya.display {
	import laya.net.Loader;
	import laya.utils.GraphicAnimation;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
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
	 * <p> <code>Animation</code> 是Graphics动画类（不断切换Graphics来实现动画），实现了基于Graphics的动画创建，播放控制接口。</p>
	 * <p> <code>Animation</code> 可以加载一组图片集合或图集文件或IDE设计好的动画进行播放。</p>
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
		/**全局缓存动画缓存池，存储了全局Graphics动画数据。使用缓存可以播放指定动画，比如播放"hero_run"动画：ani.play(0 , true ,"hero_run"); */
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
		 * 播放动画。可以指定name属性，播放缓存中某个动画。
		 * @param	start 开始播放的动画索引或label。
		 * @param	loop 是否循环播放。
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
		
		/**@private */
		protected function _setFramesFromCache(name:String):Boolean {
			var showWarn:Boolean = name != "";
			if (_url) name = _url + "#" + name;
			if (name && framesMap[name]) {
				var tAniO:*;
				tAniO = framesMap[name];
				if (tAniO is Array) {
					this._frames = framesMap[name];
					this._count = _frames.length;
				} else {
					this._frames = tAniO.frames;
					this._count = _frames.length;
					//如果是读取动的画配置信息，帧率按照动画设置的帧率播放
					if (!_frameRateChanged) _interval = tAniO.interval;
					_labels = _copyLabels(tAniO.labels);
				}
				return true;
			} else {
				if (showWarn) trace("ani not found:", name);
			}
			return false;
		}
		
		/**@private */
		private function _copyLabels(labels:Object):Object {
			if (!labels) return null;
			var rst:Object;
			rst = {};
			var key:String;
			for (key in labels) {
				rst[key] = Utils.copyArray([], labels[key]);
			}
			return rst;
		}
		
		/**@private */
		override protected function _frameLoop():void {
			if (_style.visible && _style.alpha > 0.01) {
				super._frameLoop();
			}
		}
		
		/**@private */
		override protected function _displayToIndex(value:int):void {
			if (this._frames) this.graphics = this._frames[value];
		}
		
		/**动画帧信息，里面存储的是Graphics数组，Animation本身就是不断切换Graphics来实现动画效果。*/
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
		
		/**动画数据源，可以是图集，图片集合，IDE动画
		 * 比如：图集："xx/a1.json" 图片集合："a1.png,a2.png,a3.png" IDE动画"xx/a1.ani"
		 */
		public function set source(value:String):void {
			if (value.indexOf(".ani") > -1) loadAnimation(value);
			else if (value.indexOf(".json") > -1 || value.indexOf("als") > -1 || value.indexOf("atlas") > -1) loadAtlas(value);
			else loadImages(value.split(","));
		}
		
		/**设置默认播放的动画名称，IDE里面可以制作多个动画，设置其中一个动画名称进行播放*/
		public function set autoAnimation(value:String):void {
			play(0, true, value);
		}
		
		/**是否自动播放，默认为false，如果设置为true，则动画被添加到舞台后，就会自动播放*/
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
		 * 加载图片集合作为动画。
		 * @param	urls	图片地址集合。如：[url1,url2,url3,...]。
		 * @param	cacheName 缓存的动画模板名称。此模板为全局模板，缓存后，可以使用play(start,loop,name)接口进行播放，无需重复创建动画模板（相同动画能节省创建动画模板开销），设置为空则不缓存。
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
		 * 加载一个图集作为动画。
		 * @param	url 	图集地址。
		 * @param	loaded	加载完毕回调。
		 * @param	cacheName 缓存的动画模板名称。此模板为全局模板，缓存后，可以使用play(start,loop,name)接口进行播放，无需重复创建动画模板（相同动画能节省创建动画模板开销），设置为空则不缓存。
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
		 * 加载由IDE制作的动画。播放的帧率则按照IDE设计的帧率。加载后，默认会根据 "url+动画名称" 缓存为动画模板。
		 * 【注意】加载解析IDE动画之前，请确保动画使用的图片被预加载，否则会导致动画创建失败。
		 * @param	url 	动画地址。
		 * @param	loaded	加载完毕回调（可选）。
		 * @param	atlas	动画用到的图集地址（可选）。
		 * @return 	返回动画本身。
		 */
		public function loadAnimation(url:String, loaded:Handler = null, atlas:String = null):Animation {
			this._url = url;
			var _this:Animation = this;
			if (!_actionName) _actionName = "";
			if (!_this._setFramesFromCache("")) {
				if (!atlas || Loader.getAtlas(atlas)) {
					_loadAnimationData(url, loaded, atlas);
				} else {
					Laya.loader.load(atlas, Handler.create(this, _loadAnimationData, [url, loaded, atlas]), null, Loader.ATLAS)
				}
			} else {
				_this._setFramesFromCache(_actionName);
				if (loaded) loaded.run();
			}
			return this;
		}
		
		/**@private */
		private function _loadAnimationData(url:String, loaded:Handler = null, atlas:String = null):void {
			if (atlas && !Loader.getAtlas(atlas)) {
				console.warn("atlas load fail:" + atlas);
				return;
			}
			var _this:Animation = this;
			
			function onLoaded(loadUrl:String):void {
				if (!Loader.getRes(loadUrl)) return;
				if (url === loadUrl) {
					var tAniO:Object;
					if (!framesMap[url + "#"]) {
						var aniData:Object = _this._parseGraphicAnimation(Loader.getRes(url));
						if (!aniData) return;
						//缓存动画数据
						var aniList:Array = aniData.animationList;
						var i:int, len:int = aniList.length;
						var defaultO:Object;
						for (i = 0; i < len; i++) {
							tAniO = aniList[i];
							if (tAniO.frames.length) {
								framesMap[url + "#" + tAniO.name] = tAniO;
								if (!defaultO) defaultO = tAniO;
							}
						}
						if (defaultO) {
							framesMap[url + "#"] = defaultO;
							_this._setFramesFromCache(_actionName);
							index = 0;
						}
						_checkResumePlaying();
					} else {
						_this._setFramesFromCache(_actionName);
						index = 0;
						_checkResumePlaying();
					}
					if (loaded) loaded.run();
				}
			}
			if (Loader.getRes(url)) onLoaded(url);
			else Laya.loader.load(url, Handler.create(null, onLoaded, [url]), null, Loader.JSON);
			
			//清理掉配置
			Loader.clearRes(url);
		}
		
		/**@private */
		protected function _parseGraphicAnimation(animationData:Object):Object {
			return GraphicAnimation.parseAnimationData(animationData)
		}
		
		/**
		 * 创建动画模板，相同地址的动画可共享播放模板，而不必每次都创建一份新的，从而节省创建Graphics集合的开销
		 * createFrames如果url是图集则需要预加载图集，而loadAtlas方法则不需要
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