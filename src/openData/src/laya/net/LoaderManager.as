package laya.net {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.resource.ICreateResource;
	import laya.resource.Resource;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	/**
	 * 所有资源加载完成时调度。
	 * @eventType Event.COMPLETE
	 * */
	[Event(name = "complete", type = "laya.events.Event")]
	
	/**
	 * 任何资源加载出错时调度。
	 * @eventType Event.ERROR
	 * */
	[Event(name = "error", type = "laya.events.Event")]
	
	/**
	 * <p> <code>LoaderManager</code> 类用于用于批量加载资源。此类是单例，不要手动实例化此类，请通过Laya.loader访问。</p>
	 * <p>全部队列加载完成，会派发 Event.COMPLETE 事件；如果队列中任意一个加载失败，会派发 Event.ERROR 事件，事件回调参数值为加载出错的资源地址。</p>
	 * <p> <code>LoaderManager</code> 类提供了以下几种功能：<br/>
	 * 多线程：默认5个加载线程，可以通过maxLoader属性修改线程数量；<br/>
	 * 多优先级：有0-4共5个优先级，优先级高的优先加载。0最高，4最低；<br/>
	 * 重复过滤：自动过滤重复加载（不会有多个相同地址的资源同时加载）以及复用缓存资源，防止重复加载；<br/>
	 * 错误重试：资源加载失败后，会重试加载（以最低优先级插入加载队列），retryNum设定加载失败后重试次数，retryDelay设定加载重试的时间间隔。</p>
	 * @see laya.net.Loader
	 */
	public class LoaderManager extends EventDispatcher {
		/**@private */
		private static var _resMap:Object = {};
		/**@private */
		public static var createMap:Object = {atlas: [null, Loader.ATLAS]};
		
		/** 加载出错后的重试次数，默认重试一次*/
		public var retryNum:int = 1;
		/** 延迟时间多久再进行错误重试，默认立即重试*/
		public var retryDelay:int = 0;
		/** 最大下载线程，默认为5个*/
		public var maxLoader:int = 5;
		
		/**@private */
		private var _loaders:Array = [];
		/**@private */
		private var _loaderCount:int = 0;
		/**@private */
		private var _resInfos:Array = [];
		
		/**@private */
		private var _infoPool:Array = [];
		/**@private */
		private var _maxPriority:int = 5;
		/**@private */
		private var _failRes:Object = {};
		/**@private */
		private var _statInfo:Object = {count: 1, loaded: 1};
		
		/**@private */
		public function getProgress():Number {
			return _statInfo.loaded / _statInfo.count;
		}
		
		/**@private */
		public function resetProgress():void {
			_statInfo.count = _statInfo.loaded = 1;
		}
		
		/**
		 * <p>创建一个新的 <code>LoaderManager</code> 实例。</p>
		 * <p><b>注意：</b>请使用Laya.loader加载资源，这是一个单例，不要手动实例化此类，否则会导致不可预料的问题。</p>
		 */
		public function LoaderManager() {
			for (var i:int = 0; i < this._maxPriority; i++) this._resInfos[i] = [];
		}
		
		/**
		 * <p>根据clas类型创建一个未初始化资源的对象，随后进行异步加载，资源加载完成后，初始化对象的资源，并通过此对象派发 Event.LOADED 事件，事件回调参数值为此对象本身。套嵌资源的子资源会保留资源路径"?"后的部分。</p>
		 * <p>如果url为数组，返回true；否则返回指定的资源类对象，可以通过侦听此对象的 Event.LOADED 事件来判断资源是否已经加载完毕。</p>
		 * <p><b>注意：</b>cache参数只能对文件后缀为atlas的资源进行缓存控制，其他资源会忽略缓存，强制重新加载。</p>
		 * @param	url			资源地址或者数组。如果url和clas同时指定了资源类型，优先使用url指定的资源类型。参数形如：[{url:xx,clas:xx,priority:xx,params:xx},{url:xx,clas:xx,priority:xx,params:xx}]。
		 * @param	complete	加载结束回调。根据url类型不同分为2种情况：1. url为String类型，也就是单个资源地址，如果加载成功，则回调参数值为加载完成的资源，否则为null；2. url为数组类型，指定了一组要加载的资源，如果全部加载成功，则回调参数值为true，否则为false。
		 * @param	progress	资源加载进度回调，回调参数值为当前资源加载的进度信息(0-1)。
		 * @param	type	资源类型。
		 * @param	constructParams		资源构造函数参数。
		 * @param	propertyParams		资源属性参数。
		 * @param	priority	(default = 1)加载的优先级，优先级高的优先加载。有0-4共5个优先级，0最高，4最低。
		 * @param	cache		是否缓存加载的资源。
		 * @return	如果url为数组，返回true；否则返回指定的资源类对象。
		 */
		public function create(url:*, complete:Handler = null, progress:Handler = null, type:String = null, constructParams:Array = null, propertyParams:Object = null, priority:int = 1, cache:Boolean = true):void {
			_create(url, true, complete, progress, type, constructParams, propertyParams, priority, cache);
		}
		
		/**
		 * @private
		 */
		public function _create(url:*, mainResou:Boolean, complete:Handler = null, progress:Handler = null, type:String = null, constructParams:Array = null, propertyParams:Object = null, priority:int = 1, cache:Boolean = true):void {
			if (url is Array) {
				var items:Array = url as Array;
				var itemCount:int = items.length;
				var loadedCount:int = 0;
				if (progress) {
					var progress2:Handler = Handler.create(progress.caller, progress.method, progress.args, false);
				}
				
				for (var i:int = 0; i < itemCount; i++) {
					var item:* = items[i];
					if (item is String)
						item = items[i] = {url: item};
					item.progress = 0;
				}
				for (i = 0; i < itemCount; i++) {
					item = items[i];
					var progressHandler:Handler = progress ? Handler.create(null, onProgress, [item], false) : null;
					var completeHandler:Handler = (progress || complete) ? Handler.create(null, onComplete, [item]) : null;
					_createOne(item.url,mainResou, completeHandler, progressHandler, item.type || type, item.constructParams || constructParams, item.propertyParams || propertyParams, item.priority || priority, cache);
				}
				function onComplete(item:Object, content:* = null):void {
					loadedCount++;
					item.progress = 1;
					if (loadedCount === itemCount && complete) {
						complete.run();
					}
				}
				
				function onProgress(item:Object, value:Number):void {
					item.progress = value;
					var num:Number = 0;
					for (var j:int = 0; j < itemCount; j++) {
						var item1:Object = items[j];
						num += item1.progress;
					}
					var v:Number = num / itemCount;
					progress2.runWith(v);
				}
			} else {
				_createOne(url,mainResou, complete, progress, type, constructParams, propertyParams, priority, cache);
			}
		}
		
		/**
		 * @private
		 */
		private function _createOne(url:String, mainResou:Boolean, complete:Handler = null, progress:Handler = null, type:String = null, constructParams:Array = null, propertyParams:Object = null, priority:int = 1, cache:Boolean = true):void {
			var item:* = getRes(url);
			if (!item) {
				var extension:String = Utils.getFileExtension(url);
				(type) || (type = createMap[extension]? createMap[extension][0]:null);
				
				if (!type){
					load(url, complete, progress, type, priority, cache);
					return;
				}
				var parserMap:Object = Loader.parserMap;
				if (!parserMap[type]) {//not custom parse type
					load(url, complete, progress, type, priority, cache);
					return;
				}
				_createLoad(url, Handler.create(null, onLoaded), progress, type, constructParams, propertyParams, priority, cache, true);
				function onLoaded(item:*):void {
					if (!mainResou && item is Resource)
						item._addReference();
					complete && complete.runWith(item);
					Laya.loader.event(url);
				};
			} else {
				if (!mainResou && item is Resource)
					item._addReference();
				progress && progress.runWith(1);
				complete && complete.runWith(item);
			}
		}
		
		/**
		 * <p>加载资源。资源加载错误时，本对象会派发 Event.ERROR 事件，事件回调参数值为加载出错的资源地址。</p>
		 * <p>因为返回值为 LoaderManager 对象本身，所以可以使用如下语法：loaderManager.load(...).load(...);</p>
		 * @param	url			要加载的单个资源地址或资源信息数组。比如：简单数组：["a.png","b.png"]；复杂数组[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSON,size:50,priority:1}]。
		 * @param	complete	加载结束回调。根据url类型不同分为2种情况：1. url为String类型，也就是单个资源地址，如果加载成功，则回调参数值为加载完成的资源，否则为null；2. url为数组类型，指定了一组要加载的资源，如果全部加载成功，则回调参数值为true，否则为false。
		 * @param	progress	加载进度回调。回调参数值为当前资源的加载进度信息(0-1)。
		 * @param	type		资源类型。比如：Loader.IMAGE。
		 * @param	priority	(default = 1)加载的优先级，优先级高的优先加载。有0-4共5个优先级，0最高，4最低。
		 * @param	cache		是否缓存加载结果。
		 * @param	group		分组，方便对资源进行管理。
		 * @param	ignoreCache	是否忽略缓存，强制重新加载。
		 * @param	useWorkerLoader(default = false)是否使用worker加载（只针对IMAGE类型和ATLAS类型，并且浏览器支持的情况下生效）
		 * @return 此 LoaderManager 对象本身。
		 */
		public function load(url:*, complete:Handler = null, progress:Handler = null, type:String = null, priority:int = 1, cache:Boolean = true, group:String = null, ignoreCache:Boolean = false, useWorkerLoader:Boolean = false):LoaderManager {
			if (url is Array) return _loadAssets(url as Array, complete, progress, type, priority, cache, group);
			var content:* = Loader.getRes(url);
			if (!ignoreCache && content != null) {
				//增加延迟回掉，防止快速回掉导致执行顺序错误
				Laya.systemTimer.frameOnce(1, null, function():void {
					progress && progress.runWith(1);
					complete && complete.runWith(content);
					//判断是否全部加载，如果是则抛出complete事件
					_loaderCount || event(Event.COMPLETE);
				});
			} else {
				var original:String;
				original = url;
				url = AtlasInfoManager.getFileLoadPath(url);
				if (url != original && type !== "nativeimage") {
					type = Loader.ATLAS;
				} else {
					original = null;
				}
				var info:ResInfo = _resMap[url];
				if (!info) {
					info = _infoPool.length ? _infoPool.pop() : new ResInfo();
					info.url = url;
					info.type = type;
					info.cache = cache;
					info.group = group;
					info.ignoreCache = ignoreCache;
					info.useWorkerLoader = useWorkerLoader;
					info.originalUrl = original;
					complete && info.on(Event.COMPLETE, complete.caller, complete.method, complete.args);
					progress && info.on(Event.PROGRESS, progress.caller, progress.method, progress.args);
					_resMap[url] = info;
					priority = priority < this._maxPriority ? priority : this._maxPriority - 1;
					this._resInfos[priority].push(info);
					_statInfo.count++;
					event(Event.PROGRESS, getProgress());
					_next();
				} else {
					if (complete) {
						if (original) {
							complete && info._createListener(Event.COMPLETE, this, _resInfoLoaded, [original, complete], false, false);
						} else {
							complete && info._createListener(Event.COMPLETE, complete.caller, complete.method, complete.args, false, false);
						}
					}
					progress && info._createListener(Event.PROGRESS, progress.caller, progress.method, progress.args, false, false);
				}
			}
			return this;
		}
		
		private function _resInfoLoaded(original:String, complete:Handler):void {
			complete.runWith(Loader.getRes(original));
		}
		
		/**
		 * @private
		 */
		public function _createLoad(url:*, complete:Handler = null, progress:Handler = null, type:String = null, constructParams:Array = null, propertyParams:Object = null, priority:int = 1, cache:Boolean = true, ignoreCache:Boolean = false):LoaderManager {
			if (url is Array) return _loadAssets(url as Array, complete, progress, type, priority, cache);
			var content:* = Loader.getRes(url);
			if (content != null) {
				//增加延迟回掉
				Laya.systemTimer.frameOnce(1, null, function():void {
					progress && progress.runWith(1);
					complete && complete.runWith(content);
					//判断是否全部加载，如果是则抛出complete事件
					_loaderCount || event(Event.COMPLETE);
				});
			} else {
				var info:ResInfo = _resMap[url];
				if (!info) {
					info = _infoPool.length ? _infoPool.pop() : new ResInfo();
					info.url = url;
					info.type = type;
					info.cache = false;
					info.ignoreCache = ignoreCache;
					info.originalUrl = null;
					
					info.createCache = cache;
					info.createConstructParams = constructParams;
					info.createPropertyParams = propertyParams;
					complete && info.on(Event.COMPLETE, complete.caller, complete.method, complete.args);
					progress && info.on(Event.PROGRESS, progress.caller, progress.method, progress.args);
					_resMap[url] = info;
					priority = priority < this._maxPriority ? priority : this._maxPriority - 1;
					this._resInfos[priority].push(info);
					_statInfo.count++;
					event(Event.PROGRESS, getProgress());
					_next();
				} else {
					complete && info._createListener(Event.COMPLETE, complete.caller, complete.method, complete.args, false, false);
					progress && info._createListener(Event.PROGRESS, progress.caller, progress.method, progress.args, false, false);
				}
			}
			return this;
		}
		
		private function _next():void {
			if (this._loaderCount >= this.maxLoader) return;
			for (var i:int = 0; i < this._maxPriority; i++) {
				var infos:Array = this._resInfos[i];
				while (infos.length > 0) {
					var info:ResInfo = infos.shift();
					if (info) return _doLoad(info);
				}
			}
			_loaderCount || event(Event.COMPLETE);
		}
		
		private function _doLoad(resInfo:ResInfo):void {
			this._loaderCount++;
			var loader:Loader = this._loaders.length ? this._loaders.pop() : new Loader();
			loader.on(Event.COMPLETE, null, onLoaded);
			loader.on(Event.PROGRESS, null, function(num:Number):void {
				resInfo.event(Event.PROGRESS, num);
			});
			loader.on(Event.ERROR, null, function(msg:*):void {
				onLoaded(null);
			});
			
			var _me:LoaderManager = this;
			function onLoaded(data:* = null):void {
				loader.offAll();
				loader._data = null;
				loader._customParse = false;
				_me._loaders.push(loader);
				_me._endLoad(resInfo, data is Array ? [data] : data);
				_me._loaderCount--;
				_me._next();
			}
			
			loader._constructParams = resInfo.createConstructParams;
			loader._propertyParams = resInfo.createPropertyParams;
			loader._createCache = resInfo.createCache;
			loader.load(resInfo.url, resInfo.type, resInfo.cache, resInfo.group, resInfo.ignoreCache, resInfo.useWorkerLoader);
		}
		
		private function _endLoad(resInfo:ResInfo, content:*):void {
			//如果加载后为空，放入队列末尾重试
			var url:String = resInfo.url;
			if (content == null) {
				var errorCount:int = this._failRes[url] || 0;
				if (errorCount < this.retryNum) {
					console.warn("[warn]Retry to load:", url);
					this._failRes[url] = errorCount + 1;
					Laya.systemTimer.once(retryDelay, this, _addReTry, [resInfo], false);
					return;
				} else {
					Loader.clearRes(url);//使用create加载失败需要清除资源
					console.warn("[error]Failed to load:", url);
					event(Event.ERROR, url);
				}
			}
			if (_failRes[url]) _failRes[url] = 0;
			delete _resMap[url];
			if (resInfo.originalUrl) {
				content = Loader.getRes(resInfo.originalUrl);
			}
			resInfo.event(Event.COMPLETE, content);
			resInfo.offAll();
			_infoPool.push(resInfo);
			_statInfo.loaded++;
			event(Event.PROGRESS, getProgress());
		}
		
		private function _addReTry(resInfo:ResInfo):void {
			this._resInfos[this._maxPriority - 1].push(resInfo);
			_next();
		}
		
		/**
		 * 清理指定资源地址缓存。
		 * @param	url 资源地址。
		 */
		public function clearRes(url:String):void {
			Loader.clearRes(url);
		}
		
		/**
		 * 销毁Texture使用的图片资源，保留texture壳，如果下次渲染的时候，发现texture使用的图片资源不存在，则会自动恢复
		 * 相比clearRes，clearTextureRes只是清理texture里面使用的图片资源，并不销毁texture，再次使用到的时候会自动恢复图片资源
		 * 而clearRes会彻底销毁texture，导致不能再使用；clearTextureRes能确保立即销毁图片资源，并且不用担心销毁错误，clearRes则采用引用计数方式销毁
		 * 【注意】如果图片本身在自动合集里面（默认图片小于512*512），内存是不能被销毁的，此图片被大图合集管理器管理
		 * @param	url	图集地址或者texture地址，比如 Loader.clearTextureRes("res/atlas/comp.atlas"); Loader.clearTextureRes("hall/bg.jpg");
		 */
		public function clearTextureRes(url:String):void {
			Loader.clearTextureRes(url);
		}
		
		/**
		 * 获取指定资源地址的资源。
		 * @param	url 资源地址。
		 * @return	返回资源。
		 */
		public function getRes(url:String):* {
			return Loader.getRes(url);
		}
		
		/**
		 * 缓存资源。
		 * @param	url 资源地址。
		 * @param	data 要缓存的内容。
		 */
		public function cacheRes(url:String, data:*):void {
			Loader.cacheRes(url, data);
		}
		
		/**
		 * 设置资源分组。
		 * @param url 资源地址。
		 * @param group 分组名
		 */
		public function setGroup(url:String, group:String):void {
			Loader.setGroup(url, group);
		}
		
		/**
		 * 根据分组清理资源。
		 * @param group 分组名
		 */
		public function clearResByGroup(group:String):void {
			Loader.clearResByGroup(group);
		}
		
		/**
		 * @private
		 * 缓存资源。
		 * @param	url 资源地址。
		 * @param	data 要缓存的内容。
		 */
		public static function cacheRes(url:String, data:*):void {
			Loader.cacheRes(url, data);
		}
		
		/** 清理当前未完成的加载，所有未加载的内容全部停止加载。*/
		public function clearUnLoaded():void {
			//回收Handler
			for (var i:int = 0; i < this._maxPriority; i++) {
				var infos:Array = this._resInfos[i];
				for (var j:int = infos.length - 1; j > -1; j--) {
					var info:ResInfo = infos[j];
					if (info) {
						info.offAll();
						_infoPool.push(info);
					}
				}
				infos.length = 0;
			}
			this._loaderCount = 0;
			_resMap = {};
		}
		
		/**
		 * 根据地址集合清理掉未加载的内容
		 * @param	urls 资源地址集合
		 */
		public function cancelLoadByUrls(urls:Array):void {
			if (!urls) return;
			for (var i:int = 0, n:int = urls.length; i < n; i++) {
				cancelLoadByUrl(urls[i]);
			}
		}
		
		/**
		 * 根据地址清理掉未加载的内容
		 * @param	url 资源地址
		 */
		public function cancelLoadByUrl(url:String):void {
			for (var i:int = 0; i < this._maxPriority; i++) {
				var infos:Array = this._resInfos[i];
				for (var j:int = infos.length - 1; j > -1; j--) {
					var info:ResInfo = infos[j];
					if (info && info.url === url) {
						infos[j] = null;
						info.offAll();
						_infoPool.push(info);
					}
				}
			}
			if (_resMap[url]) delete _resMap[url];
		}
		
		/**
		 * @private
		 * 加载数组里面的资源。
		 * @param arr 简单：["a.png","b.png"]，复杂[{url:"a.png",type:Loader.IMAGE,size:100,priority:1,useWorkerLoader:true},{url:"b.json",type:Loader.JSON,size:50,priority:1}]*/
		private function _loadAssets(arr:Array, complete:Handler = null, progress:Handler = null, type:String = null, priority:int = 1, cache:Boolean = true, group:String = null):LoaderManager {
			var itemCount:int = arr.length;
			var loadedCount:int = 0;
			var totalSize:int = 0;
			var items:Array = [];
			var success:Boolean = true;
			for (var i:int = 0; i < itemCount; i++) {
				var item:Object = arr[i];
				if (item is String) item = {url: item, type: type, size: 1, priority: priority};
				if (!item.size) item.size = 1;
				item.progress = 0;
				totalSize += item.size;
				items.push(item);
				var progressHandler:* = progress ? Handler.create(null, loadProgress, [item], false) : null;
				var completeHandler:* = (complete || progress) ? Handler.create(null, loadComplete, [item]) : null;
				load(item.url, completeHandler, progressHandler, item.type, item.priority || 1, cache, item.group || group, false, item.useWorkerLoader);
			}
			
			function loadComplete(item:Object, content:* = null):void {
				loadedCount++;
				item.progress = 1;
				if (!content) success = false;
				if (loadedCount === itemCount && complete) {
					complete.runWith(success);
				}
			}
			
			function loadProgress(item:Object, value:Number):void {
				if (progress != null) {
					item.progress = value;
					var num:Number = 0;
					for (var j:int = 0; j < items.length; j++) {
						var item1:Object = items[j];
						num += item1.size * item1.progress;
					}
					var v:Number = num / totalSize;
					progress.runWith(v);
				}
			}
			return this;
		}
		
		/**
		 * 解码Texture或者图集
		 * @param	urls texture地址或者图集地址集合
		 */
		//TODO:TESTs
		public function decodeBitmaps(urls:Array):void {
			var i:int, len:int = urls.length;
			var ctx:*;
			//ctx = Browser.context;
			ctx = Render._context;
			//经测试需要画到主画布上才能只解码一次
			//当前用法下webgl模式会报错
			for (i = 0; i < len; i++) {
				var atlas:Array;
				atlas = Loader.getAtlas(urls[i]);
				if (atlas) {
					_decodeTexture(atlas[0], ctx);
				} else {
					var tex:Texture;
					tex = getRes(urls[i]);
					if (tex && tex is Texture) {
						_decodeTexture(tex, ctx);
					}
				}
			}
		}
		
		private function _decodeTexture(tex:Texture, ctx:*):void {
			var bitmap:* = tex.bitmap;
			if (!tex || !bitmap) return;
			var tImg:* = bitmap.source || bitmap.image;
			if (!tImg) return;
			if (tImg is Browser.window.HTMLImageElement) {
				ctx.drawImage(tImg, 0, 0, 1, 1);
				var info:* = ctx.getImageData(0, 0, 1, 1);
			}
		}
	}
}
import laya.events.EventDispatcher;

class ResInfo extends EventDispatcher {
	public var url:String;
	public var type:String;
	public var cache:Boolean;
	public var group:String;
	public var ignoreCache:Boolean;
	public var useWorkerLoader:Boolean;
	public var originalUrl:String;
	
	public var createCache:Boolean;
	public var createConstructParams:Array;
	public var createPropertyParams:Object;
}