package laya.net {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.utils.Handler;
	
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
		
		/**
		 * 创建一个新的 <code>LoaderManager</code> 实例。
		 */
		public function LoaderManager() {
			for (var i:int = 0; i < this._maxPriority; i++) this._resInfos[i] = [];
		}
		
		/**
		 * 加载资源。
		 * @param	url 地址，或者资源对象数组。
		 * @param	complete 结束回调，如果加载失败，则返回 null 。
		 * @param	progress 进度回调，回调参数为当前文件加载的进度信息(0-1)。
		 * @param	type 资源类型。
		 * @param	priority 优先级，0-4，五个优先级，0优先级最高，默认为1。
		 * @param	cache 是否缓存加载结果。
		 * @return 此 LoaderManager 对象。
		 */
		public function load(url:*, complete:Handler = null, progress:Handler = null, type:String = null, priority:int = 1, cache:Boolean = true):LoaderManager {
			if (url is Array) return _loadAssets(url as Array, complete, progress, cache);
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
				if (infos.length > 0) return _doLoad(infos.shift())
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
			function onLoaded(data:*=null):void {
				loader.offAll();
				loader._data = null;
				_this._loaders.push(loader);
				_this._endLoad(resInfo, data);
				_this._loaderCount--;
				_this._next();
			}
			loader.load(resInfo.url, resInfo.type, resInfo.cache);
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
		 */
		public function clearRes(url:String):void {
			Loader.clearRes(url);
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
		
		/** 清理当前未完成的加载。*/
		public function clearUnLoaded():void {
			this._resInfos.length = 0;
			this._loaderCount = 0;
			this._resMap = {};
		}
		
		/**
		 * @private
		 * 加载数组里面的资源。
		 * @param arr 简单：["a.png","b.png"]，复杂[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSOn,size:50,priority:1}]*/
		private function _loadAssets(arr:Array, complete:Handler = null, progress:Handler = null, cache:Boolean = true):LoaderManager {
			var itemCount:int = arr.length;
			var loadedSize:int = 0;
			var totalSize:int = 0;
			var items:Array = [];
			for (var i:int = 0; i < itemCount; i++) {
				var item:Object = arr[i];
				if (item is String) item = {url: item, type: Loader.IMAGE, size: 1, priority: 1};
				if (!item.size) item.size = 1;
				item.progress = 0;
				totalSize += item.size;
				items.push(item);
				var progressHandler:* = progress ? Handler.create(this, loadProgress, [item]) : null;
				load(item.url, Handler.create(item, loadComplete, [item]), progressHandler, item.type, item.priority || 1, cache);
			}
			
			function loadComplete(item:Object, content:*= null):void {
				loadedSize++;
				item.progress = 1;
				if (loadedSize === itemCount && complete) {
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
}