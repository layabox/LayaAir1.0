package laya.resource {
	import laya.events.Event;
	import laya.utils.Stat;
	
	/**
	 * ...
	 * @author
	 */
	public class ResourceManager implements IDispose {
		/**唯一标识ID计数器*/
		private static var _uniqueIDCounter:int = -2147483648/*int.MIN_VALUE*/;
		/**系统ResourceManager*/
		private static var _systemResourceManager:ResourceManager;
		/**是否需要对资源管理器排序*/
		private static var _isResourceManagersSorted:Boolean;
		/**资源管理器列表*/
		private static var _resourceManagers:Vector.<ResourceManager> = new Vector.<ResourceManager>();
		/**当前资源管理器*/
		public static var currentResourceManager:ResourceManager;
		/**资源加载根目录*/
		public static var resourcesDirectory:String = "";
		
		/**
		 * 返回本类型排序后的已载入资源
		 *  @return  本类型排序后的已载入资源
		 */
		public static function get systemResourceManager():ResourceManager {
			(_systemResourceManager === null) && (_systemResourceManager = new ResourceManager(), _systemResourceManager._name = "System Resource Manager");
			return _systemResourceManager;
		}
		
		public static function __init__():void {
			currentResourceManager = systemResourceManager;
		}
		
		/**
		 * 通过索引返回资源管理器
		 * @param index 索引
		 * @return 资源管理器
		 */
		public static function getLoadedResourceManagerByIndex(index:int):ResourceManager {
			return _resourceManagers[index];
		}
		
		/**
		 * 返回资源管理器个数
		 *  @return  资源管理器个数
		 */
		public static function getLoadedResourceManagersCount():int {
			return _resourceManagers.length;
		}
		
		/**
		 * 获取排序后资源管理器列表
		 *   @return 排序后资源管理器列表
		 */
		public static function get sortedResourceManagersByName():Vector.<ResourceManager> {
			if (!_isResourceManagersSorted) {
				_isResourceManagersSorted = true;
				_resourceManagers.sort(compareResourceManagersByName);
			}
			return _resourceManagers;
		}
		
		/**重新强制创建资源管理员以及所拥有资源（显卡丢失时处理）*/
		public static function recreateContentManagers():void {
			var temp:ResourceManager = currentResourceManager;
			for (var i:int = 0; i < _resourceManagers.length; i++) {
				currentResourceManager = _resourceManagers[i];
				for (var j:int; j < currentResourceManager._resources.length; j++)//重新创建
				{
					currentResourceManager._resources[i].activeResource(true);
				}
			}
			currentResourceManager = temp;
		}
		
		/**
		 * 资源排序函数（如果名字相同，可能会重命名某个元素并排序）
		 * @param left 资源
		 * @param right 资源
		 * @return 比较结果
		 */
		private static function compareResourceManagersByName(left:ResourceManager, right:ResourceManager):int {
			if (left == right)//同一资源相同
				return 0;
			
			var x:String = left._name;
			var y:String = right._name;
			if (x == null) {
				if (y == null)//x,y都为null,资源相同
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
						y = right._name;
						return x.localeCompare(y);//待测试结果
					}
				}
			}
		}
		
		/**唯一标识ID*/
		private var _id:int;
		/**名字*/
		private var _name:String;
		/**所管理资源*/
		private var _resources:Vector.<Resource>;//待优化，外部可以获取并修改
		/**所管理资源的累计内存,以字节为单位*/
		private var _memorySize:int;
		/**垃圾回收比例，范围是0到1*/
		private var _garbageCollectionRate:Number;
		/**自动释放机制中内存是否溢出*/
		private var _isOverflow:Boolean;
		/**是否启用自动释放机制*/
		public var autoRelease:Boolean;
		/**自动释放机制的内存触发上限,以字节为单位*/
		public var autoReleaseMaxSize:int;
		
		/**资源载入器*/
		//public var resourcesLoader:ResourcesLoader;//待添加
		
		/**
		 * 获取唯一标识ID
		 * @return 编号
		 */
		public function get id():int {
			return _id;
		}
		
		/**
		 * 获取名字
		 *   @return 名字
		 */
		public function get name():String {
			return _name;
		}
		
		/**
		 * 设置名字
		 * @param	value 名字
		 */
		public function set name(value:String):void {
			if ((value || value !== "") && _name !== value) {
				_name = value;
				_isResourceManagersSorted = false;
			}
		}
		
		/**
		 * 获取所管理资源的累计内存,以字节为单位
		 *   @return 内存尺寸
		 */
		public function get memorySize():int {
			return _memorySize;
		}
		
		public function ResourceManager() {
			_id = _uniqueIDCounter;
			_uniqueIDCounter++;
			_name = "Content Manager";
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
		 * 通过索引获取资源
		 * @param 索引
		 * @return 资源
		 */
		public function getResourceByIndex(index:int):Resource {
			return _resources[index];
		}
		
		/**
		 * 获取资源长度
		 * @return 资源
		 */
		public function getResourcesLength():int {
			return _resources.length;
		}
		
		/**
		 * 添加资源
		 * @param 资源
		 * @return 是否成功
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
				resource.on(Event.MEMORY_CHANGED, this, addSize);
				return true;
			}
			return false;
		}
		
		/**
		 * 移除资源
		 * @param 资源
		 * @return 是否成功
		 */
		public function removeResource(resource:Resource):Boolean {
			var index:int = _resources.indexOf(resource);
			if (index !== -1) {
				_resources.splice(index, 1);
				resource._resourceManager = null;
				_memorySize -= resource.memorySize;
				resource.off(Event.MEMORY_CHANGED, this, addSize);
				return true;
			}
			return false;
		}
		
		/**卸载所有被本资源管理员载入的资源*/
		public function unload():void {
			if (this === _systemResourceManager)
				throw new Error("systemResourceManager不能被释放！");
			
			var tempResources:Vector.<Resource> = _resources.slice(0, _resources.length);
			for (var i:int = 0; i < tempResources.length; i++) {
				var resource:Resource = tempResources[i];
				resource._resourceManager = null;//属性，内置remove函数
				resource.dispose();
			}
			tempResources.length = 0;
		}
		
		/**
		 * 设置唯一名字
		 * @param newName 名字,如果名字重复则自动加上“-copy”
		 */
		public function setUniqueName(newName:String):void {
			var isUnique:Boolean = true;
			for (var i:int = 0; i < _resourceManagers.length; i++) {
				if (_resourceManagers[i]._name !== newName || _resourceManagers[i] === this)
					continue;
				isUnique = false;
				return;
			}
			if (isUnique) {
				if (name != newName) {
					name = newName;
					_isResourceManagersSorted = false;
				}
			} else//设置唯一名称，并重新判断
			{
				setUniqueName(newName.concat("-copy"));
			}
		}
		
		/**释放资源*/
		public function dispose():void {
			if (this === _systemResourceManager)
				throw new Error("systemResourceManager不能被释放！");
			_resourceManagers.splice(_resourceManagers.indexOf(this), 1);
			_isResourceManagersSorted = false;
			
			//是否需要临时数组
			for (var i:int = 0; i < _resources.length; i++) {
				var resource:Resource = _resources[i];
				resource._resourceManager = null;//属性，内置remove函数
				resource.dispose();
			}
		}
		
		/**
		 * 增加内存
		 * @param add 添加尺寸
		 */
		private function addSize(add:int):void {
			if (add)//add如果为0传进来则为undefined
			{
				if (autoRelease && add > 0)//启动回收机制且增加尺寸才出发垃圾回收，如果为负则不
					((_memorySize + add) > autoReleaseMaxSize) && (garbageCollection((1 - _garbageCollectionRate) * autoReleaseMaxSize));
				_memorySize += add;
			}
		}
		
		/**
		 * 垃圾回收
		 * @param reserveSize 保留尺寸
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
				
				return a.lastUseFrameCount - b.lastUseFrameCount;
			});
			var currentFrameCount:int = Stat.loopCount;
			for (var i:int = 0, n:int = all.length; i < n; i++) {
				var resou:Resource = all[i];
				//trace(resou,currentFrameCount,resou.lastUseFrameCount,_memorySize);
				if (currentFrameCount - resou.lastUseFrameCount > 1)//插值大于1帧时可释放
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