package laya.resource {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Stat;
	
	///**
	//* 当设置内存尺寸时调度。回调参数为内存变化量。
	//* @eventType Event.MEMORY_CHANGED
	//*/
	//[Event(name = "memorychanged", type = "laya.events.Event")]
	
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
	 * <code>Resource</code> 资源存取类。
	 */
	public class Resource extends EventDispatcher implements ICreateResource,IDispose{
		/**唯一标识ID计数器*/
		private static var _uniqueIDCounter:int = 0/*int.MIN_VALUE*/;
		/**此类型已载入资源*/
		private static var _loadedResources:Vector.<Resource> = new Vector.<Resource>();
		/**是否对已载入资源排序（开启会有性能损耗）*/
		private static var _isLoadedResourcesSorted:Boolean;
		
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
		
		/**
		 * 本类型排序后的已载入资源。
		 */
		public static function get sortedLoadedResourcesByName():Vector.<Resource> {
			if (!_isLoadedResourcesSorted) {
				_isLoadedResourcesSorted = true;
				_loadedResources.sort(compareResourcesByName);
			}
			return _loadedResources;
		}
		
		/**
		 * <p>资源排序函数。</p>
		 * <p><b>注意：</b> 如果名字相同，可能会重命名某个元素并排序。</p>
		 * @param left 左侧资源对象。
		 * @param right 右侧资源对象。
		 * @return 比较结果。
		 */
		private static function compareResourcesByName(left:Resource, right:Resource):int {
			if (left === right)//同一资源相同
				return 0;
			
			var x:String = left.name;
			var y:String = right.name;
			if (x === null) {
				if (y === null)//x,y都为null,资源相同
					return 0;
				else//x为null,y不为null,y大
					return -1;
			} else {
				if (y == null)//x不为null，y为null,x更大
					return 1;
				else {
					var retval:int = x.localeCompare(y);//x和y均不为null,比较字符串（两个字符串长度不一样，长的字符串更大）,待测试结果
					
					if (retval != 0)
						return retval;
					else {
						right.setUniqueName(y);//如果两个字符串相等则重新赋值唯一名字并再次比较
						y = right.name;
						return x.localeCompare(y);//待测试结果
					}
				}
			}
		}
		
		/**唯一标识ID(通常用于优化或识别)。*/
		private var _id:int;
		/**上次使用帧数。*/
		private var _lastUseFrameCount:int;
		/**占用内存尺寸。*/
		private var _memorySize:int;
		/**名字。*/
		private var _name:String;
		/**是否已加载,限于首次加载。*/
		protected var _loaded:Boolean = false;
		/**是否已释放。*/
		private var _released:Boolean;
		/** @private
		 * 所属资源管理器，通常禁止修改，如果为null则不受资源管理器，可能受大图合集资源管理。
		 * */
		public var _resourceManager:ResourceManager;
		/**是否加锁，true为不能使用自动释放机制。*/
		public var lock:Boolean;
		
		/**
		 * 获取唯一标识ID(通常用于优化或识别)。
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取名字。
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * 设置名字
		 */
		public function set name(value:String):void {
			if ((value || value !== "") && name !== value) {
				_name = value;
				_isLoadedResourcesSorted = false;
			}
		}
		
		/**
		 * 资源管理员。
		 */
		public function get resourceManager():ResourceManager {
			return _resourceManager;
		}
		
		/**
		 * 距离上次使用帧率。
		 */
		public function get lastUseFrameCount():int {
			return _lastUseFrameCount;
		}
		
		/**
		 * 占用内存尺寸。
		 */
		public function get memorySize():int {
			return _memorySize;
		}
		
		/**
		 * 是否已释放。
		 */
		public function get released():Boolean {
			return _released;
		}
		
		public function get loaded():Boolean {
			return _loaded;
		}
		
		public function set memorySize(value:int):void {
			var offsetValue:int = value - _memorySize;
			_memorySize = value;
			//this.event(Event.MEMORY_CHANGED, offsetValue);
			resourceManager && resourceManager.addSize(offsetValue);
		}
		
		/**
		 * 创建一个 <code>Resource</code> 实例。
		 */
		public function Resource() {
			_id = ++_uniqueIDCounter;
			_loadedResources.push(this);
			_isLoadedResourcesSorted = false;
			_released = true;
			lock = false;
			_memorySize = 0;
			_lastUseFrameCount = -1;
			(ResourceManager.currentResourceManager) && (ResourceManager.currentResourceManager.addResource(this));//资源管理器为空不加入资源管理队列，如受大图合集资源管理
		}
		
		/** 重新创建资源。override it，同时修改memorySize属性、处理startCreate()和compoleteCreate() 方法。*/
		protected function recreateResource():void {
			startCreate();
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
			if (_released || force) {
				recreateResource();
			}
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
		 * 设置唯一名字,如果名字重复则自动加上“-copy”。
		 * @param newName 名字。
		 */
		public function setUniqueName(newName:String):void {
			var isUnique:Boolean = true;
			for (var i:int = 0; i < _loadedResources.length; i++) {
				if (_loadedResources[i]._name !== newName || _loadedResources[i] === this)
					continue;
				isUnique = false;
				return;
			}
			if (isUnique) {
				if (name != newName) {
					name = newName;
					_isLoadedResourcesSorted = false;
				}
			} else//设置唯一名称，并重新判断
			{
				setUniqueName(newName.concat("-copy"));
			}
		}
		
		/**
		 *@private
		 */
		public function onAsynLoaded(url:String, data:*):void {
			throw new Error("Resource: must override this function!");
		}
		
		/**
		 * <p>彻底清理资源。</p>
		 * <p><b>注意：</b>会强制解锁清理。</p>
		 */
		public function dispose():void//待优化
		{
			if (_resourceManager !== null)
				throw new Error("附属于resourceManager的资源不能独立释放！");
			lock = false;//解锁资源，强制清理
			releaseResource();
			var index:int = _loadedResources.indexOf(this);
			if (index !== -1) {
				_loadedResources.splice(index, 1);
				_isLoadedResourcesSorted = false;
			}
		}
		
		/** 开始资源激活。*/
		protected function startCreate():void {
			this.event(Event.RECOVERING, this);
		}
		
		/** 完成资源激活。*/
		protected function completeCreate():void {
			_released = false;
			this.event(Event.RECOVERED, this);
		}
	}
}