package laya.net {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.media.Sound;
	import laya.renders.Render;
	import laya.resource.HTMLImage;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.RunDriver;
	
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
		/**根路径，完整路径由basePath+url组成*/
		public static var basePath:String = "";
		/** 文本类型。*/
		public static const TEXT:String = "text";
		/** JSON 类型。*/
		public static const JSOn:String = "json";
		/** XML 类型。*/
		public static const XML:String = "xml";
		/** 二进制类型。*/
		public static const BUFFER:String = "arraybuffer";
		/** 图片类型。*/
		public static const IMAGE:String = "image";
		/** 声音类型。*/
		public static const SOUND:String = "sound";
		/** 纹理类型。*/
		public static const TEXTURE:String = "texture";
		/** 图集类型。*/
		public static const ATLAS:String = "atlas";
		/** 文件后缀和类型对应表。*/
		public static var typeMap:Object = /*[STATIC SAFE]*/ {"png": "image", "jpg": "image", "txt": "text", "json": "json", "xml": "xml", "als": "atlas", "mp3": "sound", "ogg": "sound", "wav": "sound"};
		/** 已加载的资源池。*/
		private static const loadedMap:Object = {};
		/** 已加载的图集资源池。*/
		private static const atlasMap:Object = {};
		private static var _loaders:Array = [];
		private static var _isWorking:Boolean = false;
		private static var _startIndex:int = 0;
		/** 每帧回调最大超时时间。*/
		public static var maxTimeOut:int = 100;
		
		/**@private 加载后的数据对象，只读*/
		private var _data:*;
		/**@private */
		private var _url:String;
		/**@private */
		private var _type:String;
		/**@private */
		private var _cache:Boolean;
		/**@private */
		private var _http:HttpRequest;
		/**@private */
		private static var _extReg:RegExp =/*[STATIC SAFE]*/ /\.(\w+)\??/g;
		
		/**
		 * 加载资源。
		 * @param	url 地址
		 * @param	type 类型，如果为null，则根据文件后缀，自动分析类型。
		 * @param	cache 是否缓存数据。
		 */
		public function load(url:String, type:String = null, cache:Boolean = true):void {
			url = URL.formatURL(url);
			this._url = url;
			this._type = type || (type = getTypeFromUrl(url));
			this._cache = cache;
			this._data = null;
			if (loadedMap[url]) {
				this._data = loadedMap[url];
				event(Event.PROGRESS, 1);
				event(Event.COMPLETE, this._data);
				return;
			}
			
			if (type === IMAGE)
				return _loadImage(url);
			
			if (type === SOUND)
				return _loadSound(url);
			
			if (!_http) {
				_http = new HttpRequest();
				_http.on(Event.PROGRESS, this, onProgress);
				_http.on(Event.ERROR, this, onError);
				_http.on(Event.COMPLETE, this, onLoaded);
			}
			_http.send(url, null, "get", type !== ATLAS ? type : "json");
		}
		
		/**
		 * 获取指定资源地址的数据类型。
		 * @param	url 资源地址。
		 * @return 数据类型。
		 */
		protected function getTypeFromUrl(url:String):String {
			_extReg.lastIndex = url.lastIndexOf(".");
			var result:Array = _extReg.exec(url);
			if (result && result.length > 1) {
				return typeMap[result[1].toLowerCase()];
			}
			trace("Not recognize the resources suffix", url);
			return "text";
		}
		
		/**
		 * @private
		 * 加载图片资源。
		 * @param	url 资源地址。
		 */
		protected function _loadImage(url:String):void {
			var image:HTMLImage =HTMLImage.create();
			var _this:Loader = this;
			image.onload = function():void {
				clear();
				_this.onLoaded(image);
			};
			image.onerror = function():void {
				clear();
				_this.event(Event.ERROR, "Load image filed");
			}
			
			function clear():void {
				image.onload = null;
				image.onerror = null;
			}
			image.src = url;
		}
		
		/**
		 * @private
		 * 加载声音资源。
		 * @param	url 资源地址。
		 */
		protected function _loadSound(url:String):void {
			var sound:Sound = new Sound();
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
				_this.event(Event.ERROR, "Load sound filed");
			}
			function clear():void {
				sound.off(Event.COMPLETE, this, soundOnload);
				sound.off(Event.ERROR, this, soundOnErr);
			}
		}
		
		/**@private */
		private function onProgress(value:Number):void {
			event(Event.PROGRESS, value);
		}
		
		/**@private */
		private function onError(message:String):void {
			event(Event.ERROR, message);
		}
		
		/**
		 * 资源加载完成的处理函数。
		 * @param	data 数据。
		 */
		protected function onLoaded(data:*):void {
			var type:String = this._type;
			if (type === IMAGE) {
				complete(new Texture(data));
			} else if (type === SOUND) {
				complete(data);
			} else if (type === TEXTURE) {
				complete(new Texture(data));
			} else if (type === ATLAS) {
				//处理图集
				var toloadPics:Array;
				if (!data.src) {
					if (!_data) {
						this._data = data;
						//构造加载图片信息
						if (data.meta && data.meta.image)//带图片信息的类型
						{
							toloadPics = data.meta.image.split(",");
							var folderPath:String;
							var split:String;
							split = _url.indexOf("/") >= 0 ? "/" : "\\";
							var idx:int;
							idx = _url.lastIndexOf(split);
							if (idx >= 0) {
								folderPath = _url.substr(0, idx + 1);
							} else {
								folderPath = "";
							}
							var i:int, len:int;
							len = toloadPics.length;
							for (i = 0; i < len; i++) {
								toloadPics[i] = folderPath + toloadPics[i];
							}
						} else//不带图片信息
						{
							toloadPics = [_url.replace(".json", ".png")];
						}
						
						// 保证图集的正序加载
						toloadPics.reverse();
						data.toLoads = toloadPics;
						data.pics = [];
					}
					
					return _loadImage(URL.formatURL(toloadPics.pop()));
				} else {
					_data.pics.push(data);
					if (_data.toLoads.length > 0)//有图片未加载
					{
						return _loadImage(URL.formatURL(_data.toLoads.pop()));
					}
					var frames:Object = this._data.frames;
					var directory:String = (this._data.meta && this._data.meta.prefix) ? URL.basePath + this._data.meta.prefix : this._url.substring(0, this._url.lastIndexOf(".")) + "/"
					var pics:Array;
					pics = _data.pics;
					var tPic:Object;
					
					var map:Array = atlasMap[this._url] || (atlasMap[this._url] = []);
					
					var needSub:Boolean = Config.atlasEnable && Render.isWebGL;
					for (var name:String in frames) {
						var obj:Object = frames[name];//取对应的图
						tPic = pics[obj.frame.idx ? obj.frame.idx : 0];//是否释放
						var url:String = directory + name;
						
						//if (needSub) {
						//var merageInAtlas:Boolean = false;
						//(obj.frame.w > Config.atlasLimitWidth || obj.frame.h > Config.atlasLimitHeight) && (merageInAtlas = true);
						//var webGLSubImage:HTMLSubImage = new HTMLSubImage(Browser.canvas.source, obj.frame.x, obj.frame.y, obj.frame.w, obj.frame.h,tPic.image,tPic.image.src, merageInAtlas);
						//var tex:Texture = new Texture(webGLSubImage);
						//tex.offsetX = obj.spriteSourceSize.x;
						//tex.offsetY = obj.spriteSourceSize.y;
						//loadedMap[url] = tex;
						//map.push(tex);
						//} else {
						loadedMap[url] = Texture.create(tPic, obj.frame.x, obj.frame.y, obj.frame.w, obj.frame.h, obj.spriteSourceSize.x, obj.spriteSourceSize.y, obj.sourceSize.w, obj.sourceSize.h);
						map.push(loadedMap[url]);
							//}
					}
					
					//if (needSub)
					//for (i = 0; i < pics.length; i++)
					//pics[i].dispose();//Sub后可直接释放
					
					complete(this._data);
				}
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
			_loaders.push(this);
			if (!_isWorking) checkNext();
		}
		
		/** @private */
		private static function checkNext():void {
			_isWorking = true;
			var startTimer:Number = Browser.now();
			var thisTimer:Number = startTimer;
			while (_startIndex < _loaders.length) {
				thisTimer = Browser.now();
				_loaders[_startIndex]._endLoad();
				_startIndex++;
				if (Browser.now() - startTimer > maxTimeOut) {
					trace("loader callback cost a long time:" + (Browser.now() - startTimer) + ")" + " url=" + _loaders[_startIndex - 1].url);
					Laya.timer.frameOnce(1, null, checkNext);
					return;
				}
			}
			
			_loaders.length = 0;
			_startIndex = 0;
			_isWorking = false;
		}
		
		/**
		 * @private
		 * 结束加载，派发进度 <code>Event.PROGRESS</code> 和完成事件 <code>Event.COMPLETE</code> 。
		 */
		public function _endLoad():void {
			if (this._cache) loadedMap[this._url] = this._data;
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
		 */
		public static function clearRes(url:String):void {
			url = URL.formatURL(url);
			//删除图集
			var arr:Array = atlasMap[url];
			if (arr) {
				for (var i:int = 0, n:int = arr.length; i < n; i++) {
					var tex:Texture = arr[i];
					if (tex) tex.destroy();
				}
				arr.length = 0;
				delete atlasMap[url];
			}
			delete loadedMap[url];
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
		 * 获取指定资源地址的图集纹理列表。
		 * @param	url 图集地址。
		 * @return	返回 Texture 集合。
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
			loadedMap[URL.formatURL(url)] = data;
		}
	}
}