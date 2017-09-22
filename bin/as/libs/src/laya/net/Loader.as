package laya.net {
	import laya.display.BitmapFont;
	import laya.display.Text;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.media.Sound;
	import laya.media.SoundManager;
	import laya.resource.HTMLImage;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	/**
	 * 加载进度发生改变时调度。
	 * @eventType Event.PROGRESS
	 * */
	[Event(name = "progress", type = "laya.events.Event")]
	/**
	 * 加载完成后调度。
	 * @eventType Event.COMPLETE
	 * */
	[Event(name = "complete", type = "laya.events.Event")]
	/**
	 * 加载出错时调度。
	 * @eventType Event.ERROR
	 * */
	[Event(name = "error", type = "laya.events.Event")]
	
	/**
	 * <code>Loader</code> 类可用来加载文本、JSON、XML、二进制、图像等资源。
	 */
	public class Loader extends EventDispatcher {
		/** 文本类型，加载完成后返回文本。*/
		public static const TEXT:String = "text";
		/** JSON 类型，加载完成后返回json数据。*/
		public static const JSON:String = "json";
		/** XML 类型，加载完成后返回domXML。*/
		public static const XML:String = "xml";
		/** 二进制类型，加载完成后返回arraybuffer二进制数据。*/
		public static const BUFFER:String = "arraybuffer";
		/** 纹理类型，加载完成后返回Texture。*/
		public static const IMAGE:String = "image";
		/** 声音类型，加载完成后返回sound。*/
		public static const SOUND:String = "sound";
		/** 图集类型，加载完成后返回图集json信息(并创建图集内小图Texture)。*/
		public static const ATLAS:String = "atlas";
		/** 位图字体类型，加载完成后返回BitmapFont。*/
		public static const FONT:String = "font";
		
		public static const PKM:String = "pkm";
		
		/** 文件后缀和类型对应表。*/
		public static var typeMap:Object = /*[STATIC SAFE]*/ {"png": "image", "jpg": "image", "jpeg": "image", "txt": "text", "json": "json", "xml": "xml", "als": "atlas", "atlas": "atlas", "mp3": "sound", "ogg": "sound", "wav": "sound", "part": "json", "fnt": "font", "pkm": "pkm"};
		/**资源解析函数对应表，用来扩展更多类型的资源加载解析。*/
		public static var parserMap:Object = /*[STATIC SAFE]*/ {};
		/** 资源分组对应表。*/
		public static const groupMap:Object = {};
		/** 每帧回调最大超时时间，如果超时，则下帧再处理。*/
		public static var maxTimeOut:int = 100;
		/** @private 已加载的资源池。*/
		public static const loadedMap:Object = {};
		/** @private 已加载的图集配置文件。*/
		public static const preLoadedAtlasConfigMap:Object = {};
		/**@private 已加载的图集资源池。*/
		protected static const atlasMap:Object = {};
		/**@private */
		protected static var _loaders:Array = [];
		/**@private */
		protected static var _isWorking:Boolean = false;
		/**@private */
		protected static var _startIndex:int = 0;
		/**@private */
		protected static const imgCache:Object = {};
		
		/**@private 加载后的数据对象，只读*/
		public var _data:*;
		/**@private */
		protected var _url:String;
		/**@private */
		protected var _type:String;
		/**@private */
		protected var _cache:Boolean;
		/**@private */
		protected var _http:HttpRequest;
		/**@private 自定义解析不派发complete事件，但会派发loaded事件，手动调用endLoad方法再派发complete事件*/
		public var _customParse:Boolean = false;
		
		/**
		 * 加载资源。加载错误会派发 Event.ERROR 事件，参数为错误信息。
		 * @param	url			资源地址。
		 * @param	type		(default = null)资源类型。可选值为：Loader.TEXT、Loader.JSON、Loader.XML、Loader.BUFFER、Loader.IMAGE、Loader.SOUND、Loader.ATLAS、Loader.FONT。如果为null，则根据文件后缀分析类型。
		 * @param	cache		(default = true)是否缓存数据。
		 * @param	group		(default = null)分组名称。
		 * @param	ignoreCache (default = false)是否忽略缓存，强制重新加载。
		 */
		public function load(url:String, type:String = null, cache:Boolean = true, group:String = null, ignoreCache:Boolean = false):void {
			this._url = url;
			if (url.indexOf("data:image") === 0) this._type = type = IMAGE;
			else {
				this._type = type || (type = getTypeFromUrl(url));
				url = URL.formatURL(url);
			} 
			this._cache = cache;
			this._data = null;
			
			if (!ignoreCache && loadedMap[url]) {
				this._data = loadedMap[url];
				event(Event.PROGRESS, 1);
				event(Event.COMPLETE, this._data);
				return;
			}
			if (group) setGroup(url, group);
			
			//如果自定义了解析器，则自己解析，自定义解析不派发complete事件，但会派发loaded事件，手动调用endLoad方法再派发complete事件
			if (parserMap[type] != null) {
				_customParse = true;
				if (parserMap[type] is Handler) parserMap[type].runWith(this);
				else parserMap[type].call(null, this);
				return;
			}
			
			//htmlimage和nativeimage为内部类型
			if (type === IMAGE || type === "htmlimage" || type === "nativeimage") return _loadImage(url);
			if (type === SOUND) return _loadSound(url);
			
			if (type == ATLAS) {
				if (preLoadedAtlasConfigMap[url]) {
					onLoaded(preLoadedAtlasConfigMap[url]);
					delete preLoadedAtlasConfigMap[url];
					return;
				}
			}
			if (!_http) {
				_http = new HttpRequest();
				_http.on(Event.PROGRESS, this, onProgress);
				_http.on(Event.ERROR, this, onError);
				_http.on(Event.COMPLETE, this, onLoaded);
			}
			var contentType:String;
			switch (type) {
			case ATLAS: 
				contentType = JSON;
				break;
			case FONT: 
				contentType = XML;
				break;
			case PKM: 
				contentType = BUFFER;
				break
			default: 
				contentType = type;
			}
			_http.send(url, null, "get", contentType);
		}
		
		/**
		 * 获取指定资源地址的数据类型。
		 * @param	url 资源地址。
		 * @return 数据类型。
		 */
		protected function getTypeFromUrl(url:String):String {
			var type:String = Utils.getFileExtension(url);
			if (type) return typeMap[type];
			console.warn("Not recognize the resources suffix", url);
			return "text";
		}
		
		/**
		 * @private
		 * 加载图片资源。
		 * @param	url 资源地址。
		 */
		protected function _loadImage(url:String):void {
			url = URL.formatURL(url);
			var _this:Loader = this;
			var image:*;
			function clear():void {
				image.onload = null;
				image.onerror = null;
				delete imgCache[url]
			}
			
			var onload:Function = function():void {
				clear();
				_this.onLoaded(image);
			};
			var onerror:Function = function():void {
				clear();
				_this.event(Event.ERROR, "Load image failed");
			}
			
			if (_type === "nativeimage") {
				image = new Browser.window.Image();
				image.crossOrigin = "";
				image.onload = onload;
				image.onerror = onerror;
				image.src = url;
				//增加引用，防止垃圾回收
				imgCache[url] = image;
			} else {
				new HTMLImage.create(url, {onload: onload, onerror: onerror, onCreate: function(img:*):void {
					image = img;
					//增加引用，防止垃圾回收
					imgCache[url] = img;
				}});
			}
		}
		
		/**
		 * @private
		 * 加载声音资源。
		 * @param	url 资源地址。
		 */
		protected function _loadSound(url:String):void {
			var sound:Sound = (new SoundManager._soundClass()) as Sound;
			var _this:Loader = this;
			
			sound.on(Event.COMPLETE, this, soundOnload);
			sound.on(Event.ERROR, this, soundOnErr);
			sound.load(url);
			
			function soundOnload():void {
				clear();
				_this.onLoaded(sound);
			}
			function soundOnErr():void {
				clear();
				sound.dispose();
				_this.event(Event.ERROR, "Load sound failed");
			}
			function clear():void {
				sound.offAll();
			}
		}
		
		/**@private */
		protected function onProgress(value:Number):void {
			if (this._type === ATLAS) event(Event.PROGRESS, value * 0.3);
			else event(Event.PROGRESS, value);
		}
		
		/**@private */
		protected function onError(message:String):void {
			event(Event.ERROR, message);
		}
		
		/**
		 * 资源加载完成的处理函数。
		 * @param	data 数据。
		 */
		protected function onLoaded(data:* = null):void {
			var type:String = this._type;
			if (type === IMAGE) {
				var tex:Texture = new Texture(data);
				tex.url = _url;
				complete(tex);
			} else if (type === SOUND || type === "htmlimage" || type === "nativeimage") {
				complete(data);
			} else if (type === ATLAS) {
				//处理图集
				if (!data.src && !data._setContext) {
					if (!_data) {
						this._data = data;
						//构造加载图片信息
						if (data.meta && data.meta.image) {
							//带图片信息的类型
							var toloadPics:Array = data.meta.image.split(",");
							var split:String = _url.indexOf("/") >= 0 ? "/" : "\\";
							var idx:int = _url.lastIndexOf(split);
							var folderPath:String = idx >= 0 ? _url.substr(0, idx + 1) : "";
							//idx = _url.indexOf("?");
							//var ver:String;
							//ver = idx >= 0 ? _url.substr(idx) : "";
							for (var i:int = 0, len:int = toloadPics.length; i < len; i++) {
								toloadPics[i] = folderPath + toloadPics[i];
							}
						} else {
							//不带图片信息
							toloadPics = [_url.replace(".json", ".png")];
						}
						
						//保证图集的正序加载
						toloadPics.reverse();
						data.toLoads = toloadPics;
						data.pics = [];
					}
					event(Event.PROGRESS, 0.3 + 1 / toloadPics.length * 0.6);
					return _loadImage(toloadPics.pop());
				} else {
					_data.pics.push(data);
					if (_data.toLoads.length > 0) {
						event(Event.PROGRESS, 0.3 + 1 / _data.toLoads.length * 0.6);
						//有图片未加载
						return _loadImage(_data.toLoads.pop());
					}
					var frames:Object = this._data.frames;
					var cleanUrl:String = this._url.split("?")[0];
					var directory:String = (this._data.meta && this._data.meta.prefix) ? this._data.meta.prefix : cleanUrl.substring(0, cleanUrl.lastIndexOf(".")) + "/";
					var pics:Array = _data.pics;
					var atlasURL:String = URL.formatURL(this._url);
					var map:Array = atlasMap[atlasURL] || (atlasMap[atlasURL] = []);
					map.dir = directory;
					for (var name:String in frames) {
						var obj:Object = frames[name];//取对应的图
						var tPic:Object = pics[obj.frame.idx ? obj.frame.idx : 0];//是否释放
						var url:String = URL.formatURL(directory + name);
						
						cacheRes(url, Texture.create(tPic, obj.frame.x, obj.frame.y, obj.frame.w, obj.frame.h, obj.spriteSourceSize.x, obj.spriteSourceSize.y, obj.sourceSize.w, obj.sourceSize.h));
						loadedMap[url].url = url;
						map.push(url);
					}
					
					delete _data.pics;
					
					/*[IF-FLASH]*/
					map.sort();
					complete(this._data);
				}
			} else if (type == FONT) {
				//处理位图字体
				if (!data.src) {
					_data = data;
					event(Event.PROGRESS, 0.5);
					return _loadImage(_url.replace(".fnt", ".png"));
				} else {
					var bFont:BitmapFont = new BitmapFont();
					bFont.parseFont(_data, data);
					var tArr:Array = this._url.split(".fnt")[0].split("/");
					var fontName:String = tArr[tArr.length - 1];
					Text.registerBitmapFont(fontName, bFont);
					_data = bFont;
					complete(this._data);
				}
			} else if (type == PKM) {
				var image:HTMLImage = HTMLImage.create(data, _url);
				var tex1:Texture = new Texture(image);
				tex1.url = _url;
				complete(tex1);
			} else {
				complete(data);
			}
		}
		
		/**
		 * 加载完成。
		 * @param	data 加载的数据。
		 */
		protected function complete(data:*):void {
			this._data = data;
			if (_customParse) {
				event(Event.LOADED, data is Array ? [data] : data);
			} else {
				_loaders.push(this);
				if (!_isWorking) checkNext();
			}
		}
		
		/** @private */
		private static function checkNext():void {
			_isWorking = true;
			var startTimer:Number = Browser.now();
			var thisTimer:Number = startTimer;
			while (_startIndex < _loaders.length) {
				thisTimer = Browser.now();
				_loaders[_startIndex].endLoad();
				_startIndex++;
				if (Browser.now() - startTimer > maxTimeOut) {
					console.warn("loader callback cost a long time:" + (Browser.now() - startTimer) + " url=" + _loaders[_startIndex - 1].url);
					Laya.timer.frameOnce(1, null, checkNext);
					return;
				}
			}
			
			_loaders.length = 0;
			_startIndex = 0;
			_isWorking = false;
		}
		
		/**
		 * 结束加载，处理是否缓存及派发完成事件 <code>Event.COMPLETE</code> 。
		 * @param	content 加载后的数据
		 */
		public function endLoad(content:* = null):void {
			content && (this._data = content);
			if (this._cache) cacheRes(this._url, this._data);
			
			_customParse = false;
			event(Event.PROGRESS, 1);
			event(Event.COMPLETE, data is Array ? [data] : data);
		
		}
		
		/** 加载地址。*/
		public function get url():String {
			return _url;
		}
		
		/**加载类型。*/
		public function get type():String {
			return _type;
		}
		
		/**是否缓存。*/
		public function get cache():Boolean {
			return _cache;
		}
		
		/**返回的数据。*/
		public function get data():* {
			return _data;
		}
		
		/**
		 * 清理指定资源地址的缓存。
		 * @param	url 资源地址。
		 * @param	forceDispose 是否强制销毁，有些资源是采用引用计数方式销毁，如果forceDispose=true，则忽略引用计数，直接销毁，比如Texture，默认为false
		 */
		public static function clearRes(url:String, forceDispose:Boolean = false):void {
			url = URL.formatURL(url);
			//删除图集
			var arr:Array = getAtlas(url);
			if (arr) {
				for (var i:int = 0, n:int = arr.length; i < n; i++) {
					var resUrl:String = arr[i];
					var tex:Texture = getRes(resUrl);
					delete loadedMap[resUrl];
					if (tex) tex.destroy(forceDispose);
					
				}
				arr.length = 0;
				delete atlasMap[url];
				delete loadedMap[url];
			} else {
				var res:* = loadedMap[url];
				if (res) {
					delete loadedMap[url];
					if (res is Texture && res.bitmap) Texture(res).destroy(forceDispose);				
				}
			}
		}
		
		/**
		 * 设置预加载的图集配置文件
		 * @param	url 资源地址。
		 * @param	configO 配置数据
		 */
		public static function setAtlasConfigs(url:String, config:Object):void {
			preLoadedAtlasConfigMap[URL.formatURL(url)] = config;
		}
		
		/**
		 * 获取指定资源地址的资源。
		 * @param	url 资源地址。
		 * @return	返回资源。
		 */
		public static function getRes(url:String):* {
			return loadedMap[URL.formatURL(url)];
		}
		
		/**
		 * 获取指定资源地址的图集地址列表。
		 * @param	url 图集地址。
		 * @return	返回地址集合。
		 */
		public static function getAtlas(url:String):Array {
			return atlasMap[URL.formatURL(url)];
		}
		
		/**
		 * 缓存资源。
		 * @param	url 资源地址。
		 * @param	data 要缓存的内容。
		 */
		public static function cacheRes(url:String, data:*):void {
			url = URL.formatURL(url);
			if (loadedMap[url] != null) {
				console.warn("Resources already exist,is repeated loading:", url);
			} else {
				loadedMap[url] = data;
			}
		}
		
		/**
		 * 设置资源分组。
		 * @param url 资源地址。
		 * @param group 分组名。
		 */
		public static function setGroup(url:String, group:String):void {
			if (!groupMap[group]) groupMap[group] = [];
			groupMap[group].push(url);
		}
		
		/**
		 * 根据分组清理资源。
		 * @param group 分组名。
		 */
		public static function clearResByGroup(group:String):void {
			if (!groupMap[group]) return;
			var arr:Array = groupMap[group], i:int, len:int = arr.length;
			for (i = 0; i < len; i++) {
				clearRes(arr[i]);
			}
			arr.length = 0;
		}
	}
}