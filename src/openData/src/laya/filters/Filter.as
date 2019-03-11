package laya.filters {
	import laya.display.Sprite;

	/**
	 * <code>Filter</code> 是滤镜基类。
	 */
	public class Filter implements IFilter 
	{
		/**@private 模糊滤镜。*/
		public static const BLUR:int = 0x10;
		/**@private 颜色滤镜。*/
		public static const COLOR:int = 0x20;
		/**@private 发光滤镜。*/
		public static const GLOW:int = 0x08;
		/** @private */
		public static var _filter:*;
		
		/** @private */
		public var _action:*;
		/** @private*/
		public var _glRender:*;
		
		
		/**
		 * 创建一个 <code>Filter</code> 实例。
		 * */
		public function Filter() {}
		/**@private 滤镜类型。*/
		public function get type():int{return -1}
		
		public static var _recycleScope:*;
	}
}