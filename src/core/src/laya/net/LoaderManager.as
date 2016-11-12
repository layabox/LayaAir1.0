package laya.net {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.resource.ICreateResource;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Utils;
	
	/**
	 * 加载完成时调度。
	 * @eventType Event.COMPLETE
	 * */
	[Event(name = "complete", type = "laya.events.Event")]
	
	/**
	 * 加载出错时调度。
	 * @eventType Event.ERROR
	 * */
	[Event(name = "error", type = "laya.events.Event")]
	
	/**
	 * <p> <code>LoaderManager</code> 类用于用于批量加载资源、数据。</p>
	 * <p>批量加载器，单例，可以通过Laya.loader访问。</p>
	 * 多线程(默认5个线程)，5个优先级(0最快，4最慢,默认为1)
	 * 某个资源加载失败后，会按照最低优先级重试加载(属性retryNum决定重试几次)，如果重试后失败，则调用complete函数，并返回null
	 */
	public class LoaderManager extends EventDispatcher {
		/** 加载出错后的重试次数，默认重试一次*/
		public var retryNum:int = 1;
		/** 最大下载线程，默认为5个*/
		public var maxLoader:int = 5;
		
		/**@private */
		private var _loaders:Array = [];
		/**@private */
		private var _loaderCount:int = 0;
		/**@private */
		private var _resInfos:Array = [];
		/**@private */
		private var _resMap:Object = {};
		/**@private */
		private var _infoPool:Array = [];
		/**@private */
		private var _maxPriority:int = 5;
		/**@private */
		private var _failRes:Object = {};
		/**@private */
		public var createMap:Object = {};
		
		/**
		 * 创建一个新的 <code>LoaderManager</code> 实例。
		 */
		public function LoaderManager() {
			for (var i:int = 0; i < this._maxPriority; i++) this._resInfos[i] = [];
		}
		
		/**
		 * 根据clas定义创建一个资源空壳，随后进行异步加载，资源加载完成后，会调用资源类的onAsynLoaded方法回调真正的数据
		 * @param	url 资源地址或者数组，比如[{url:xx,clas:xx,priority:xx},{url:xx,clas:xx,priority:xx}]
		 * @param	progress 进度回调，回调参数为当前文件加载的进度信息(0-1)。
		 * @param	clas 资源类名，比如Texture
		 * @param	type 资源类型
		 * @param	priority 优先级
		 * @param	cache 是否缓存
		 * @return	返回资源对象
		 */
		public function create(url:*, complete:Handler = null, progress:Handler = null, clas:Class = null, priority:int = 1, cache:Boolean = true):* {
			if (url is Array) {
				var items:Array = url as Array;
				var itemCount:int = items.length;
				var loadedCount:int = 0;
				if (progress) {
					var progress2:Handler = Handler.create(progress.caller, progress.method, progress.args, false);
				}
				for (var i:int = 0; i < itemCount; i++) {
					var item:* = items[i];
					if (item is String) item =items[i] = {url:item};
					item.progress = 0;
					var progressHandler:Handler = progress ? Handler.create(null, onProgress, [item], false) : null;
					var completeHandler:Handler = (progress || complete) ? Handler.create(null, onComplete, [item]) : null;
					_create(item.url, completeHandler, progressHandler, item.clas || clas, item.priority || priority, cache);
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
				return true;
			} else return _create(url, complete, progress, clas, priority, cache);
		}
		
		private function _create(url:String, complete:Handler = null, progress:Handler = null, clas:Class=null, priority:int = 1, cache:Boolean = true):* {
			var item:ICreateResource = getRes(url);
			if (!item) {
				var extension:String = Utils.getFileExtension(url);
				var creatItem:Array = createMap[extension];
				if (!clas) clas = creatItem[0];
				var type:String = creatItem[1];
				
				if (clas is Texture) type = "htmlimage";
				item = new clas();
				load(url, Handler.create(null, onLoaded), progress, type, priority, false, null, true);
				function onLoaded(data:*):void {
					item.onAsynLoaded.call(item, url, data);
					if (complete) complete.run();
				}
				if (cache) cacheRes(url, item);
			}
			return item;
		}
		
		/**
		 * 加载资源。
		 * @param	url 地址，或者资源对象数组(简单数组：["a.png","b.png"]，复杂数组[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSON,size:50,priority:1}])。
		 * @param	complete 结束回调，如果加载失败，则返回 null 。
		 * @param	progress 进度回调，回调参数为当前文件加载的进度信息(0-1)。
		 * @param	type 资源类型。
		 * @param	priority 优先级，0-4，五个优先级，0优先级最高，默认为1。
		 * @param	cache 是否缓存加载结果。
		 * @param	group 分组。
		 * @param	ignoreCache 是否忽略缓存，强制重新加载
		 * @return 此 LoaderManager 对象。
		 */
		public function load(url:*, complete:Handler = null, progress:Handler = null, type:String = null, priority:int = 1, cache:Boolean = true, group:String = null, ignoreCache:Boolean = false):LoaderManager {
			if (url is Array) return _loadAssets(url as Array, complete, progress, type, priority, cache, group);
			url = URL.formatURL(url);
			var content:* = Loader.getRes(url);
			if (content != null) {
				complete && complete.runWith(content);
				//判断是否全部加载，如果是则抛出complete事件
				_loaderCount || event(Event.COMPLETE);
			} else {
				var info:ResInfo = this._resMap[url];
				if (!info) {
					info = _infoPool.length ? _infoPool.pop() : new ResInfo();
					info.url = url;
					info.type = type;
					info.cache = cache;
					info.group = group;
					info.ignoreCache = ignoreCache;
					complete && info.on(Event.COMPLETE, complete.caller, complete.method, complete.args);
					progress && info.on(Event.PROGRESS, progress.caller, progress.method, progress.args);
					this._resMap[url] = info;
					priority = priority < this._maxPriority ? priority : this._maxPriority - 1;
					this._resInfos[priority].push(info);
					_next();
				} else {
					complete && info.on(Event.COMPLETE, complete.caller, complete.method, complete.args);
					progress && info.on(Event.PROGRESS, progress.caller, progress.method, progress.args);
				}
			}
			return this;
		}
		
		private function _next():void {
			if (this._loaderCount >= this.maxLoader) return;
			for (var i:int = 0; i < this._maxPriority; i++) {
				var infos:Array = this._resInfos[i];
				if (infos.length > 0) {
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
			
			var _this:LoaderManager = this;
			function onLoaded(data:* = null):void {
				loader.offAll();
				loader._data = null;
				_this._loaders.push(loader);
				_this._endLoad(resInfo, data is Array ? [data] : data);
				_this._loaderCount--;
				_this._next();
			}
			loader.load(resInfo.url, resInfo.type, resInfo.cache, resInfo.group, resInfo.ignoreCache);
		}
		
		private function _endLoad(resInfo:ResInfo, content:*):void {
			//如果加载后为空，放入队列末尾重试
			if (content === null) {
				var errorCount:int = this._failRes[resInfo.url] || 0;
				if (errorCount < this.retryNum) {
					trace("[warn]Retry to load:", resInfo.url);
					this._failRes[resInfo.url] = errorCount + 1;
					this._resInfos[this._maxPriority - 1].push(resInfo);
					return;
				} else {
					trace("[error]Failed to load:", resInfo.url);
					event(Event.ERROR, resInfo.url);
				}
			}
			delete this._resMap[resInfo.url];
			resInfo.event(Event.COMPLETE, content);
			resInfo.offAll();
			_infoPool.push(resInfo);
		}
		
		/**
		 * 清理指定资源地址缓存。
		 * @param	url 资源地址。
		 * @param	forceDispose 是否强制销毁，有些资源是采用引用计数方式销毁，如果forceDispose=true，则忽略引用计数，直接销毁，比如Texture，默认为false
		 */
		public function clearRes(url:String, forceDispose:Boolean = false):void {
			Loader.clearRes(url, forceDispose);
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
			this._resMap = {};
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
			url = URL.formatURL(url);
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
			if (this._resMap[url]) delete this._resMap[url];
		}
		
		/**
		 * @private
		 * 加载数组里面的资源。
		 * @param arr 简单：["a.png","b.png"]，复杂[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSON,size:50,priority:1}]*/
		private function _loadAssets(arr:Array, complete:Handler = null, progress:Handler = null, type:String = null, priority:int = 1, cache:Boolean = true, group:String = null):LoaderManager {
			var itemCount:int = arr.length;
			var loadedCount:int = 0;
			var totalSize:int = 0;
			var items:Array = [];
			var defaultType:String = type || Loader.IMAGE;
			for (var i:int = 0; i < itemCount; i++) {
				var item:Object = arr[i];
				if (item is String) item = {url: item, type: defaultType, size: 1, priority: priority};
				if (!item.size) item.size = 1;
				item.progress = 0;
				totalSize += item.size;
				items.push(item);
				var progressHandler:* = progress ? Handler.create(null, loadProgress, [item], false) : null;
				var completeHandler:* = (complete || progress) ? Handler.create(null, loadComplete, [item]) : null;
				load(item.url, completeHandler, progressHandler, item.type, item.priority || 1, cache, item.group || group);
			}
			
			function loadComplete(item:Object, content:* = null):void {
				loadedCount++;
				item.progress = 1;
				if (loadedCount === itemCount && complete) {
					complete.run();
				}
			}
			
			function loadProgress(item:Object, value:Number):void {
				if (progress != null) {
					item.progress = value;
					var num:Number = 0;
					for (var j:int = 0; j < itemCount; j++) {
						var item1:Object = items[j];
						num += item1.size * item1.progress;
					}
					var v:Number = num / totalSize;
					progress.runWith(v);
				}
			}
			return this;
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
}