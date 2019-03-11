package laya.resource {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.utils.RunDriver;
	
	/**
	 * 加载完成时调度。
	 * @eventType Event.LOADED
	 */
	[Event(name="loaded",type="laya.events.Event")]
	
	/**
	 * @private
	 * <code>Resource</code> 资源存取类。
	 */
	public class Resource extends EventDispatcher implements ICreateResource, IDestroy {
		/**@private */
		private static var _uniqueIDCounter:int = 0;
		/**@private */
		private static var _idResourcesMap:Object = {};
		/**@private */
		private static var _urlResourcesMap:Object = {};
		/**@private */
		private static var _groupResourcesMap:Object = {};
		
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
		public static function destroyUnusedResources(group:String = null):void {
			var res:Resource;
			if (group) {
				var resouList:Vector.<Resource> = _groupResourcesMap[group];
				if (resouList) {
					var tempResouList:Vector.<Resource> = resouList.slice();
					for (var i:int, n:int = tempResouList.length; i < n; i++) {
						res = tempResouList[i];
						if (!res.lock && res._referenceCount === 0)
							res.destroy();
					}
				}
			}
			else {
				for (var k:String in _idResourcesMap) {
					res = _idResourcesMap[k];
					if (!res.lock && res._referenceCount === 0)
						res.destroy();
				}
			}
		}
		
		/**@private */
		protected var _id:int;
		/**@private */
		private var _url:String;
		/**@private */
		private var _group:String;
		/**@private */
		private var _cpuMemory:int;
		/**@private */
		private var _gpuMemory:int;
		/**@private */
		private var _released:Boolean;
		/**@private */
		private var _destroyed:Boolean;
		
		/**@private */
		protected var _referenceCount:int;
		
		/**@private */
		public var _resourceManager:ResourceManager;
		
		/**是否加锁，如果true为不能使用自动释放机制。*/
		public var lock:Boolean;
		/**名称。 */
		public var name:String;
		
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
		 * 获取资源组名。
		 */
		public function get group():String {
			return _getGroup();
		}
		
		/**
		 * 设置资源组名。
		 */
		public function set group(value:String):void {
			_setGroup(value);
		}
		
		/**
		 * 资源管理员。
		 */
		public function get resourceManager():ResourceManager {
			return _resourceManager;
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
		 * 是否已释放。
		 */
		public function get released():Boolean {
			return _released;
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
			_released = true;
			lock = false;
			_gpuMemory = 0;
			(ResourceManager.currentResourceManager) && (ResourceManager.currentResourceManager.addResource(this)); //资源管理器为空不加入资源管理队列，如受大图合集资源管理
		}
		
		/**
		 * @private
		 */
		//TODO:coverage
		public function _setCPUMemory(value:int):void {
			var offsetValue:int = value - _cpuMemory;
			_cpuMemory = value;
			//resourceManager && resourceManager.addSize(offsetValue);
		}
		
		/**
		 * @private
		 */
		public function _setGPUMemory(value:int):void {
			var offsetValue:int = value - _gpuMemory;
			_gpuMemory = value;
			resourceManager && resourceManager.addSize(offsetValue);
		}
		
		/**
		 * @private
		 */
		public function _setUrl(url:String):void {
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
		//TODO:coverage
		public function _getGroup():String {
			return _group;
		}
		
		/**
		 * @private
		 */
		//TODO:coverage
		public function _setGroup(value:String):void {
			if (_group !== value) {
				var groupList:Vector.<Resource>;
				if (_group) {
					groupList = _groupResourcesMap[_group];
					groupList.splice(groupList.indexOf(this), 1);
					(groupList.length === 0) && (delete _groupResourcesMap[_group]);
				}
				if (value) {
					groupList = _groupResourcesMap[value];
					(groupList) || (_groupResourcesMap[value] = groupList = new Vector.<Resource>());
					groupList.push(this);
				}
				_group = value;
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
		//TODO:coverage
		public function _clearReference():void {
			_referenceCount = 0;
		}
		
		/**
		 * @private
		 */
		//TODO:coverage
		public function _completeLoad():void {
			_released = false;
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
			_released = false;
		}
		
		/**
		 *@private
		 */
		//TODO:coverage
		public function _onAsynLoaded(data:*, propertyParams:Object = null):void {
			throw new Error("Resource: must override this function!");
		}
		
		/**
		 * 释放资源。
		 * @param force 是否强制释放。
		 * @return 是否成功释放。
		 */
		public function releaseResource(force:Boolean = false):Boolean {
			if (!force && lock)
				return false;
			if (!_released || force) {
				_disposeResource();
				_released = true;
				return true;
			}
			else {
				return false;
			}
		}
		
		/**
		 * 销毁资源,销毁后资源不能恢复。
		 */
		public function destroy():void {
			if (_destroyed)
				return;
			if (_resourceManager !== null)
				_resourceManager.removeResource(this);
			
			_destroyed = true;
			lock = false; //解锁资源，强制清理
			releaseResource();
			delete _idResourcesMap[id];
			var resList:Vector.<Resource>;
			if (_url) {
				resList = _urlResourcesMap[_url];
				if (resList) {
					resList.splice(resList.indexOf(this), 1);
					(resList.length === 0) && (delete _urlResourcesMap[url]);
				}
				
				var resou:Resource = Loader.getRes(_url);
				(resou == this) && (delete Loader.loadedMap[_url]);
				RunDriver.cancelLoadByUrl(_url);
			}
			if (_group) {
				resList = _groupResourcesMap[_group];
				resList.splice(resList.indexOf(this), 1);
				(resList.length === 0) && (delete _groupResourcesMap[url]);
			}
		}
	}
}