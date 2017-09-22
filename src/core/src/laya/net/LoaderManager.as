package laya.net {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.resource.Texture;
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
		 * @param	clas		资源类名。如果url和clas同时指定了资源类型，优先使用url指定的资源类型。参数形如：Texture。
		 * @param	params		资源构造参数。
		 * @param	priority	(default = 1)加载的优先级，优先级高的优先加载。有0-4共5个优先级，0最高，4最低。
		 * @param	cache		是否缓存加载的资源。
		 * @return	如果url为数组，返回true；否则返回指定的资源类对象。
		 */
		public function create(url:*, complete:Handler = null, progress:Handler = null, clas:Class = null, params:Array = null, priority:int = 1, cache:Boolean = true):* {
			if (url is Array) {
				var items:Array = url as Array;
				var itemCount:int = items.length;
				var loadedCount:int = 0;
				if (progress) {
					var progress2:Handler = Handler.create(progress.caller, progress.method, progress.args, false);
				}
				for (var i:int = 0; i < itemCount; i++) {
					var item:* = items[i];
					if (item is String) item = items[i] = {url: item};
					item.progress = 0;
					var progressHandler:Handler = progress ? Handler.create(null, onProgress, [item], false) : null;
					var completeHandler:Handler = (progress || complete) ? Handler.create(null, onComplete, [item]) : null;
					_create(item.url, completeHandler, progressHandler, item.clas || clas, item.params || params, item.priority || priority, cache);
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
			} else return _create(url, complete, progress, clas, params, priority, cache);
		}
		
		private function _create(url:String, complete:Handler = null, progress:Handler = null, clas:Class = null, params:Array = null, priority:int = 1, cache:Boolean = true):* {
			url = URL.formatURL(url);
			
			var item:* = getRes(url);
			if (!item) {
				var extension:String = Utils.getFileExtension(url);
				var creatItem:Array = createMap[extension];
				if (!creatItem)
					throw new Error("LoaderManager:unknown file(" + url + ") extension with: " + extension + ".");
				
				if (!clas) clas = creatItem[0];
				var type:String = creatItem[1];
				if (extension == "atlas") {
					load(url, complete, progress, type, priority, cache);
				} else {
					if (clas === Texture) type = "htmlimage";
					item = clas ? new clas() : null;
					if (item.hasOwnProperty("_loaded"))
						item._loaded = false;
					load(url, Handler.create(null, onLoaded), progress, type, priority, false, null, true);
					function onLoaded(data:*):void {
						(item && !item.disposed && data) && (item.onAsynLoaded.call(item, url, data, params));//TODO:精灵如何处理
						if (complete) complete.run();
						Laya.loader.event(url);
					}
					if (cache) {
						cacheRes(url, item);
						item.url = url;
					}
				}
			} else {
				if (!item.hasOwnProperty("loaded") || item.loaded) {
					progress && progress.runWith(1);
					complete && complete.run();
				} else if (complete) {
					Laya.loader._createListener(url, complete.caller, complete.method, complete.args, true, false);
				}
			}
			return item;
		}
		
		/**
		 * <p>加载资源。资源加载错误时，本对象会派发 Event.ERROR 事件，事件回调参数值为加载出错的资源地址。</p>
		 * <p>因为返回值为 LoaderManager 对象本身，所以可以使用如下语法：Laya.loader.load(...).load(...);</p>
		 * @param	url			要加载的单个资源地址或资源信息数组。比如：简单数组：["a.png","b.png"]；复杂数组[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSON,size:50,priority:1}]。
		 * @param	complete	加载结束回调。根据url类型不同分为2种情况：1. url为String类型，也就是单个资源地址，如果加载成功，则回调参数值为加载完成的资源，否则为null；2. url为数组类型，指定了一组要加载的资源，如果全部加载成功，则回调参数值为true，否则为false。
		 * @param	progress	加载进度回调。回调参数值为当前资源的加载进度信息(0-1)。
		 * @param	type		资源类型。比如：Loader.IMAGE。
		 * @param	priority	(default = 1)加载的优先级，优先级高的优先加载。有0-4共5个优先级，0最高，4最低。
		 * @param	cache		是否缓存加载结果。
		 * @param	group		分组，方便对资源进行管理。
		 * @param	ignoreCache	是否忽略缓存，强制重新加载。
		 * @return 此 LoaderManager 对象本身。
		 */
		public function load(url:*, complete:Handler = null, progress:Handler = null, type:String = null, priority:int = 1, cache:Boolean = true, group:String = null, ignoreCache:Boolean = false):LoaderManager {
			if (url is Array) return _loadAssets(url as Array, complete, progress, type, priority, cache, group);
			var content:* = Loader.getRes(url);
			if (content != null) {
				//增加延迟回掉
				Laya.timer.frameOnce(1, null, function():void {
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
					info.cache = cache;
					info.group = group;
					info.ignoreCache = ignoreCache;
					complete && info.on(Event.COMPLETE, complete.caller, complete.method, complete.args);
					progress && info.on(Event.PROGRESS, progress.caller, progress.method, progress.args);
					_resMap[url] = info;
					priority = priority < this._maxPriority ? priority : this._maxPriority - 1;
					this._resInfos[priority].push(info);
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
			var url:String = resInfo.url;
			if (content == null) {
				var errorCount:int = this._failRes[url] || 0;
				if (errorCount < this.retryNum) {
					console.warn("[warn]Retry to load:", url);
					this._failRes[url] = errorCount + 1;
					Laya.timer.once(retryDelay, this, _addReTry, [resInfo], false);
					return;
				} else {
					console.warn("[error]Failed to load:", url);
					event(Event.ERROR, url);
				}
			}
			if (_failRes[url]) _failRes[url] = 0;
			delete _resMap[url];
			resInfo.event(Event.COMPLETE, content);
			resInfo.offAll();
			_infoPool.push(resInfo);
		}
		
		private function _addReTry(resInfo:ResInfo):void {
			this._resInfos[this._maxPriority - 1].push(resInfo);
			_next();
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
		 * @param arr 简单：["a.png","b.png"]，复杂[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSON,size:50,priority:1}]*/
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
				load(item.url, completeHandler, progressHandler, item.type, item.priority || 1, cache, item.group || group);
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