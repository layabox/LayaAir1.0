package laya.resource {
	import laya.utils.Stat;
	
	/**
	 * @private
	 * <code>ResourceManager</code> 是资源管理类。它用于资源的载入、获取、销毁。
	 */
	public class ResourceManager implements IDispose {
		/** 唯一标识ID计数器。*/
		private static var _uniqueIDCounter:int = 0/*int.MIN_VALUE*/;
		/** 系统ResourceManager。*/
		private static var _systemResourceManager:ResourceManager = new ResourceManager("System Resource Manager");
		/** 是否需要对资源管理器排序。*/
		private static var _isResourceManagersSorted:Boolean;
		/** 资源管理器列表。*/
		private static var _resourceManagers:Vector.<ResourceManager> = new Vector.<ResourceManager>();
		/** 当前资源管理器。*/
		public static var currentResourceManager:ResourceManager = _systemResourceManager;
		
		/**
		 * 系统资源管理器。
		 */
		public static function get systemResourceManager():ResourceManager {
			return _systemResourceManager;
		}
		
		/**
		 * @private
		 * 资源管理类初始化。
		 */
		public static function __init__():void {
			currentResourceManager = systemResourceManager;
		}
		
		/**
		 * 获取指定索引的资源管理器。
		 * @param index 索引。
		 * @return 资源管理器。
		 */
		public static function getLoadedResourceManagerByIndex(index:int):ResourceManager {
			return _resourceManagers[index];
		}
		
		/**
		 * 获取资源管理器总个数。
		 *  @return  资源管理器总个数。
		 */
		public static function getLoadedResourceManagersCount():int {
			return _resourceManagers.length;
		}
		
		/**
		 * 重新强制创建资源管理员以及所拥有资源（显卡丢失时处理）。
		 */
		public static function recreateContentManagers(force:Boolean = false):void {
			var temp:ResourceManager = currentResourceManager;
			for (var i:int = 0; i < _resourceManagers.length; i++) {
				currentResourceManager = _resourceManagers[i];
				for (var j:int; j < currentResourceManager._resources.length; j++) {//重新创建
					currentResourceManager._resources[j].releaseResource(force);
					currentResourceManager._resources[j].activeResource(force);
				}
			}
			currentResourceManager = temp;
		}
		
		/**释放资源管理员所拥有资源（显卡丢失时处理）。*/
		public static function releaseContentManagers(force:Boolean = false):void {
			var temp:ResourceManager = currentResourceManager;
			for (var i:int = 0; i < _resourceManagers.length; i++) {
				currentResourceManager = _resourceManagers[i];
				for (var j:int; j < currentResourceManager._resources.length; j++) {
					var resource:Resource = currentResourceManager._resources[j];
					(!resource.released) && (resource.releaseResource(force));
				}
			}
			currentResourceManager = temp;
		}
		
		/** 唯一标识ID。*/
		private var _id:int;
		/** 名字。*/
		private var _name:String;
		/** 所管理资源。*/
		private var _resources:Vector.<Resource>;//待优化，外部可以获取并修改
		/** 所管理资源的累计内存,以字节为单位。*/
		private var _memorySize:int;
		/** 垃圾回收比例，范围是0到1。*/
		private var _garbageCollectionRate:Number;
		/** 自动释放机制中内存是否溢出。*/
		private var _isOverflow:Boolean;
		/** 是否启用自动释放机制。*/
		public var autoRelease:Boolean;
		/**自动释放机制的内存触发上限,以字节为单位。*/
		public var autoReleaseMaxSize:int;
		
		///**资源载入器*/
		//public var resourcesLoader:ResourcesLoader;//待添加
		
		/**
		 * 唯一标识 ID 。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 名字。
		 */
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			if ((value || value !== "") && _name !== value) {
				_name = value;
				_isResourceManagersSorted = false;
			}
		}
		
		/**
		 * 此管理器所管理资源的累计内存，以字节为单位。
		 */
		public function get memorySize():int {
			return _memorySize;
		}
		
		/**
		 * 创建一个 <code>ResourceManager</code> 实例。
		 */
		public function ResourceManager(name:String = null) {
			_id = ++_uniqueIDCounter;
			_name = name ? name : "Content Manager";
			_isResourceManagersSorted = false;
			_memorySize = 0;
			_isOverflow = false;
			autoRelease = false;
			autoReleaseMaxSize = 1024 * 1024 * 512;//1M=1024KB,1KB=1024B
			_garbageCollectionRate = 0.2;
			_resourceManagers.push(this);
			_resources = new Vector.<Resource>();
		}
		
		/**
		 * 获取指定索引的资源 Resource 对象。
		 * @param 索引。
		 * @return 资源 Resource 对象。
		 */
		public function getResourceByIndex(index:int):Resource {
			return _resources[index];
		}
		
		/**
		 * 获取此管理器所管理的资源个数。
		 * @return 资源个数。
		 */
		public function getResourcesLength():int {
			return _resources.length;
		}
		
		/**
		 * 添加指定资源。
		 * @param	resource 需要添加的资源 Resource 对象。
		 * @return 是否添加成功。
		 */
		public function addResource(resource:Resource):Boolean//可优化
		{
			if (resource.resourceManager)
				resource.resourceManager.removeResource(resource);
			
			var index:int = _resources.indexOf(resource);
			if (index === -1) {
				resource._resourceManager = this;
				_resources.push(resource);
				addSize(resource.memorySize);
				//resource.on(Event.MEMORY_CHANGED, this, addSize);
				return true;
			}
			return false;
		}
		
		/**
		 * 移除指定资源。
		 * @param	resource 需要移除的资源 Resource 对象
		 * @return 是否移除成功。
		 */
		public function removeResource(resource:Resource):Boolean {
			var index:int = _resources.indexOf(resource);
			if (index !== -1) {
				_resources.splice(index, 1);
				resource._resourceManager = null;
				_memorySize -= resource.memorySize;
				return true;
			}
			return false;
		}
		
		/**
		 * 卸载此资源管理器载入的资源。
		 */
		public function unload():void {
			//if (this === _systemResourceManager)
			//throw new Error("systemResourceManager不能被释放！");
			var tempResources:Vector.<Resource> = _resources.slice(0, _resources.length);
			for (var i:int = 0; i < tempResources.length; i++) {
				var resource:Resource = tempResources[i];
				//resource.resourceManager.removeResource(resource);//TODO:暂时屏蔽，dispose中会调用
				resource.destroy();
			}
			tempResources.length = 0;
		}
		
		/** 释放资源。*/
		public function dispose():void {
			if (this === _systemResourceManager)
				throw new Error("systemResourceManager不能被释放！");
			
			_resourceManagers.splice(_resourceManagers.indexOf(this), 1);
			_isResourceManagersSorted = false;
			
			var tempResources:Vector.<Resource> = _resources.slice(0, _resources.length);
			for (var i:int = 0; i < tempResources.length; i++) {
				var resource:Resource = tempResources[i];
				resource.resourceManager.removeResource(resource);
				resource.destroy();
			}
			tempResources.length = 0;
		}
		
		/**
		 * 增加内存。
		 * @param add 需要增加的内存大小。
		 */
		public function addSize(add:int):void {
			if (add)//add如果为0传进来则为undefined
			{
				if (autoRelease && add > 0)//启动回收机制且增加尺寸才出发垃圾回收，如果为负则不
					((_memorySize + add) > autoReleaseMaxSize) && (garbageCollection((1 - _garbageCollectionRate) * autoReleaseMaxSize));
				_memorySize += add;
			}
		}
		
		/**
		 * 垃圾回收。
		 * @param reserveSize 保留尺寸。
		 */
		private function garbageCollection(reserveSize:int):void {
			var all:Vector.<Resource> = _resources;
			all = all.slice();//不破坏原有资源队列顺序
			all.sort(function(a:Resource, b:Resource):int {
				if (!a || !b)
					throw new Error("a或b不能为空！");
				
				if (a.released && b.released)//已释放排序处理，在队列最前
					return 0;
				else if (a.released)
					return 1;
				else if (b.released)
					return -1;
				
				return a._lastUseFrameCount - b._lastUseFrameCount;
			});
			var currentFrameCount:int = Stat.loopCount;
			for (var i:int = 0, n:int = all.length; i < n; i++) {
				var resou:Resource = all[i];
				if (currentFrameCount - resou._lastUseFrameCount > 1)//差值大于1帧时可释放
				{
					resou.releaseResource();
				} else {
					if (_memorySize >= reserveSize)
						_isOverflow = true;
					return;
				}
				if (_memorySize < reserveSize) {
					_isOverflow = false;
					return;
				}
			}
		}
	}
}