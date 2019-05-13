package laya.resource {
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.RunDriver;
	
	/**
	 * @private
	 * <code>Resource</code> 资源存取类。
	 */
	public class Resource extends EventDispatcher implements ICreateResource, IDestroy {
		/** @private */
		private static var _uniqueIDCounter:int = 0;
		/** @private */
		private static var _idResourcesMap:Object = {};
		/** @private */
		private static var _urlResourcesMap:Object = {};
		/** @private 以字节为单位。*/
		private static var _cpuMemory:int = 0;
		/** @private 以字节为单位。*/
		private static var _gpuMemory:int = 0;
		
		/**
		 * 当前内存，以字节为单位。
		 */
		public static function get cpuMemory():int {
			return _cpuMemory;
		}
		
		/**
		 * 当前显存，以字节为单位。
		 */
		public static function get gpuMemory():int {
			return _gpuMemory;
		}
		
		/**
		 * @private
		 */
		public static function _addCPUMemory(size:int):void {
			_cpuMemory += size;
		}
		
		/**
		 * @private
		 */
		public static function _addGPUMemory(size:int):void {
			_gpuMemory += size;
		}
		
		/**
		 * @private
		 */
		public static function _addMemory(cpuSize:int, gpuSize:int):void {
			_cpuMemory += cpuSize;
			_gpuMemory += gpuSize;
		}
		
		/**
		 * 通过资源ID返回已载入资源。
		 * @param id 资源ID
		 * @return 资源 <code>Resource</code> 对象。
		 */
		public static function getResourceByID(id:int):Resource {
			return _idResourcesMap[id];
		}
		
		/**
		 * 通过url返回已载入资源。
		 * @param url 资源URL
		 * @param index 索引
		 * @return 资源 <code>Resource</code> 对象。
		 */
		public static function getResourceByURL(url:String, index:int = 0):Resource {
			return _urlResourcesMap[url][index];
		}
		
		/**
		 * 销毁当前没有被使用的资源,该函数会忽略lock=true的资源。
		 * @param group 指定分组。
		 */
		public static function destroyUnusedResources():void {
			for (var k:String in _idResourcesMap) {
				var res:Resource = _idResourcesMap[k];
				if (!res.lock && res._referenceCount === 0)
					res.destroy();
			}
		}
		
		/**@private */
		protected var _id:int=0;
		/**@private */
		private var _url:String=null;
		/**@private */
		private var _cpuMemory:int = 0;
		/**@private */
		private var _gpuMemory:int = 0;
		/**@private */
		private var _destroyed:Boolean=false;
		
		/**@private */
		protected var _referenceCount:int=0;
		
		/**是否加锁，如果true为不能使用自动释放机制。*/
		public var lock:Boolean=false;
		/**名称。 */
		public var name:String=null;
		
		/**
		 * 获取唯一标识ID,通常用于识别。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取资源的URL地址。
		 * @return URL地址。
		 */
		public function get url():String {
			return _url;
		}
		
		/**
		 * 内存大小。
		 */
		public function get cpuMemory():int {
			return _cpuMemory;
		}
		
		/**
		 * 显存大小。
		 */
		public function get gpuMemory():int {
			return _gpuMemory;
		}
		
		/**
		 * 是否已处理。
		 */
		public function get destroyed():Boolean {
			return _destroyed;
		}
		
		/**
		 * 获取资源的引用计数。
		 */
		public function get referenceCount():int {
			return _referenceCount;
		}
		
		/**
		 * 创建一个 <code>Resource</code> 实例。
		 */
		public function Resource() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_id = ++_uniqueIDCounter;
			_destroyed = false;
			_referenceCount = 0;
			_idResourcesMap[id] = this;
			lock = false;
		}
		
		/**
		 * @private
		 */
		public function _setCPUMemory(value:int):void {
			var offsetValue:int = value - _cpuMemory;
			_cpuMemory = value;
			_addCPUMemory(offsetValue);
		}
		
		/**
		 * @private
		 */
		public function _setGPUMemory(value:int):void {
			var offsetValue:int = value - _gpuMemory;
			_gpuMemory = value;
			_addGPUMemory(offsetValue);
		}
		
		/**
		 * @private
		 */
		public function _setCreateURL(url:String):void {
			url = URL.formatURL(url);//需要序列化为绝对路径
			if (_url !== url) {
				var resList:Vector.<Resource>;
				if (_url) {
					resList = _urlResourcesMap[_url];
					resList.splice(resList.indexOf(this), 1);
					(resList.length === 0) && (delete _urlResourcesMap[_url]);
				}
				if (url) {
					resList = _urlResourcesMap[url];
					(resList) || (_urlResourcesMap[url] = resList = new Vector.<Resource>());
					resList.push(this);
				}
				_url = url;
			}
		}
		
		/**
		 * @private
		 */
		public function _addReference(count:int = 1):void {
			_referenceCount += count;
		}
		
		/**
		 * @private
		 */
		public function _removeReference(count:int = 1):void {
			_referenceCount -= count;
		}
		
		/**
		 * @private
		 */
		public function _clearReference():void {
			_referenceCount = 0;
		}
		
		/**
		 * @private
		 */
		protected function _recoverResource():void {
		}
		
		/**
		 * @private
		 */
		protected function _disposeResource():void {
		}
		
		/**
		 * @private
		 */
		protected function _activeResource():void {
		
		}
		
		/**
		 * 销毁资源,销毁后资源不能恢复。
		 */
		public function destroy():void {
			if (_destroyed)
				return;
			
			_destroyed = true;
			lock = false; //解锁资源，强制清理
			_disposeResource();
			delete _idResourcesMap[id];
			var resList:Vector.<Resource>;
			if (_url) {
				resList = _urlResourcesMap[_url];
				if (resList) {
					resList.splice(resList.indexOf(this), 1);
					(resList.length === 0) && (delete _urlResourcesMap[_url]);
				}
				
				var resou:Resource = Loader.getRes(_url);
				(resou == this) && (delete Loader.loadedMap[_url]);
			}
		}
	}
}