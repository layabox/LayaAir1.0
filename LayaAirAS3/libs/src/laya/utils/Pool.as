package laya.utils 
{
	/**
	 * 对象池类
	 * @author ww
	 */
	public class Pool 
	{
		
		public function Pool() 
		{
			
		}
		
		private static var _poolDic:Object = { };
		
		/**
		 * 是否在对象池中的属性Key 
		 */
		public static const InPoolSign:String = "__InPool";
		/**
		 * 获取对象池 
		 * @param sign 对象类型标识
		 * @return 
		 * 
		 */
		private static function getPoolBySign(sign:String):Array
		{
			return _poolDic[sign] || (_poolDic[sign] = []);
		}
		/**
		 * 将对象放回到池中 
		 * @param sign 对象类型标识
		 * @param item 对象
		 * 
		 */
		public static function recover(sign:String, item:Object):void
		{
			if (item[InPoolSign]) return;
			item[InPoolSign] = true;
			getPoolBySign(sign).push(item);
		}
		/**
		 * 根据对象类型标识获取对象 
		 * @param sign 对象类型标识
		 * @param clz 当对象池中无对象是用于创建对象的类
		 * @return 
		 * 
		 */
		public static function getItemByClass(sign:String,clz:Class):*
		{
			var pool:Array = getPoolBySign(sign);
			var rst:Object = pool.length?pool.pop():new clz();
			rst[InPoolSign] = false;
			return rst;
		}
		/**
		 * 根据对象类型标识获取对象  
		 * @param sign 对象类型标识
		 * @param createFun 当对象池中无对象是用于创建对象的方法
		 * @return 
		 * 
		 */
		public static function getItemByCreateFun(sign:String, createFun:Function):*
		{
			var pool:Array = getPoolBySign(sign);
			var rst:Object = pool.length?pool.pop():createFun();
			rst[InPoolSign] = false;
			return rst;
		}
		/**
		 * 根据对象类型标识获取对象
		 * @param sign 对象类型标识
		 * @return 当对象池中无对象时返回null
		 * 
		 */
		public static function getItem(sign:String):*
		{
			var pool:Array = getPoolBySign(sign);
			var rst:Object = pool.length?pool.pop():null;
			if(rst) rst[InPoolSign] = false;
			return rst;
		}
		
		
	}

}