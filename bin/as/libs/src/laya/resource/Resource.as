package laya.resource {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.utils.RunDriver;
	import laya.utils.Stat;
	
	/**
	 * 释放资源时调度。
	 * @eventType Event.RELEASED
	 */
	[Event(name = "released", type = "laya.events.Event")]
	
	/**
	 * 开始资源激活时调度。
	 * @eventType Event.RECOVERING
	 */
	[Event(name = "recovering", type = "laya.events.Event")]
	
	/**
	 *  完成资源激活后调度。
	 * @eventType Event.RECOVERED
	 */
	[Event(name = "recovered", type = "laya.events.Event")]
	
	/**
	 * @private
	 * <code>Resource</code> 资源存取类。
	 */
	public class Resource extends EventDispatcher implements ICreateResource, IDispose {
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
		 * 通过url返回已载入资源。
		 * @param url 资源URL
		 * @return 资源 <code>Resource</code> 对象。
		 * @param index 索引
		 */
		public static function getResourceCountByURL(url:String):int {
			return _urlResourcesMap[url].length;
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
			} else {
				for (var k:String in _idResourcesMap) {
					res = _idResourcesMap[k];
					if (!res.lock && res._referenceCount === 0)
						res.destroy();
				}
			}
		}
		
		/**@private */
		private var __loaded:Boolean;
		/**@private */
		private var _id:int;
		/**@private */
		private var _memorySize:int;
		/**@private */
		private var _released:Boolean;
		/**@private */
		private var _destroyed:Boolean;
		/**@private */
		private var _referenceCount:int;
		/**@private */
		private var _group:String;
		
		/**@private */
		protected var _url:String;
		
		/**@private */
		public var _resourceManager:ResourceManager;
		/**@private */
		public var _lastUseFrameCount:int;
		
		/**是否加锁，如果true为不能使用自动释放机制。*/
		public var lock:Boolean;
		/**名称。 */
		public var name:String;
		
		/**
		 * @private
		 */
		public function set _loaded(value:Boolean):void {
			__loaded = value;
		}
		
		/**
		 * 获取唯一标识ID,通常用于识别。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 资源管理员。
		 */
		public function get resourceManager():ResourceManager {
			return _resourceManager;
		}
		
		/**
		 * 占用内存尺寸。
		 */
		public function get memorySize():int {
			return _memorySize;
		}
		
		/**
		 * @private
		 */
		public function set memorySize(value:int):void {
			var offsetValue:int = value - _memorySize;
			_memorySize = value;
			resourceManager && resourceManager.addSize(offsetValue);
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
		 * 获取是否已加载完成。
		 */
		public function get loaded():Boolean {
			return __loaded;
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
			__loaded = true;
			_destroyed = false;
			_referenceCount = 0;
			_idResourcesMap[id] = this;
			_released = true;
			lock = false;
			_memorySize = 0;
			_lastUseFrameCount = -1;
			(ResourceManager.currentResourceManager) && (ResourceManager.currentResourceManager.addResource(this));//资源管理器为空不加入资源管理队列，如受大图合集资源管理
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
		public function _getGroup():String {
			return _group;
		}
		
		/**
		 * @private
		 */
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
		public function _addReference():void {
			_referenceCount++;
		}
		
		/**
		 * @private
		 */
		public function _removeReference():void {
			_referenceCount--;
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
		public function _endLoaded():void {
			__loaded = true;
			event(Event.LOADED, this);
		}
		
		/**
		 * @private
		 */
		protected function recreateResource():void {
			completeCreate();//处理创建完成后相关操作
		}
		
		/**
		 * @private
		 */
		protected function disposeResource():void {
		}
		
		/**
		 * 激活资源，使用资源前应先调用此函数激活。
		 * @param force 是否强制创建。
		 */
		public function activeResource(force:Boolean = false):void {
			_lastUseFrameCount = Stat.loopCount;
			if (!_destroyed && __loaded && (_released || force))
				recreateResource();
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
				disposeResource();
				_released = true;
				_lastUseFrameCount = -1;
				this.event(Event.RELEASED, this);//触发释放事件
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 *@private
		 */
		public function onAsynLoaded(url:String, data:*, params:Array):void {
			throw new Error("Resource: must override this function!");
		}
		
		/**
		 * <p>彻底处理资源，处理后不能恢复。</p>
		 * <p><b>注意：</b>会强制解锁清理。</p>
		 */
		public function destroy():void {
			if (_destroyed)
				return;
			if (_resourceManager !== null)
				_resourceManager.removeResource(this);
			
			_destroyed = true;
			lock = false;//解锁资源，强制清理
			releaseResource();
			delete _idResourcesMap[id];
			var resList:Vector.<Resource>;
			if (_url) {
				resList = _urlResourcesMap[_url];
				if (resList) {
					resList.splice(resList.indexOf(this), 1);
					(resList.length === 0) && (delete _urlResourcesMap[url]);
				}
				
				Loader.clearRes(_url);
				(__loaded)||(RunDriver.cancelLoadByUrl(_url));
			}
			if (_group) {
				resList = _groupResourcesMap[_group];
				resList.splice(resList.indexOf(this), 1);
				(resList.length === 0) && (delete _groupResourcesMap[url]);
			}
		}
		
		/** 完成资源激活。*/
		protected function completeCreate():void {
			_released = false;
			this.event(Event.RECOVERED, this);
		}
		
		/**
		 * @private
		 */
		public function dispose():void {//兼容方法
			destroy();
		}
	}
}