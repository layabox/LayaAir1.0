package laya.resource {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
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
		private static var _loadedResources:Vector.<Resource> = new Vector.<Resource>();
		
		/**
		 * 通过索引返回本类型已载入资源。
		 * @param index 索引。
		 * @return 资源 <code>Resource</code> 对象。
		 */
		public static function getLoadedResourceByIndex(index:int):Resource {
			return _loadedResources[index];
		}
		
		/**
		 * 本类型已载入资源个数。
		 */
		public static function getLoadedResourcesCount():int {
			return _loadedResources.length;
		}
		
		/**@private */
		private var __loaded:Boolean;
		/**@private */
		private var _memorySize:int;
		/**@private */
		private var _id:int;
		/**@private */
		private var _url:String;
		/**@private */
		private var _released:Boolean;
		/**@private */
		private var _disposed:Boolean;
		
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
		public function get disposed():Boolean {
			return _disposed;
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
		 * 设置资源的URL地址。
		 * @param value URL地址。
		 */
		public function set url(value:String):void {
			_url = value;
		}
		
		/**
		 * 创建一个 <code>Resource</code> 实例。
		 */
		public function Resource() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_id = ++_uniqueIDCounter;
			__loaded = true;
			_disposed = false;
			_loadedResources.push(this);
			_released = true;
			lock = false;
			_memorySize = 0;
			_lastUseFrameCount = -1;
			(ResourceManager.currentResourceManager) && (ResourceManager.currentResourceManager.addResource(this));//资源管理器为空不加入资源管理队列，如受大图合集资源管理
		}
		
		/**
		 * @private
		 */
		public function _endLoaded():void {
			__loaded = true;
			event(Event.LOADED, this);
		}
		
		/** 重新创建资源,override it，同时修改memorySize属性、处理startCreate()和compoleteCreate() 方法。*/
		protected function recreateResource():void {
			completeCreate();//处理创建完成后相关操作
		}
		
		/** 销毁资源，override it,同时修改memorySize属性。*/
		protected function detoryResource():void {
		
		}
		
		/**
		 * 激活资源，使用资源前应先调用此函数激活。
		 * @param force 是否强制创建。
		 */
		public function activeResource(force:Boolean = false):void {
			_lastUseFrameCount = Stat.loopCount;
			if (!_disposed&&__loaded && (_released || force))
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
				detoryResource();
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
		public function dispose():void {
			if (_disposed)
				return;
			if (_resourceManager !== null)
				_resourceManager.removeResource(this);
			
			_disposed = true;
			lock = false;//解锁资源，强制清理
			releaseResource();
			var index:int = _loadedResources.indexOf(this);
			(index !== -1) && (_loadedResources.splice(index, 1));
			
			Loader.clearRes(_url);
		}
		
		/** 完成资源激活。*/
		protected function completeCreate():void {
			_released = false;
			this.event(Event.RECOVERED, this);
		}
	}
}