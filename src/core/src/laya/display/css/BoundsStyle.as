package laya.display.css {
	import laya.maths.Rectangle;
	import laya.utils.Pool;
	
	/**
	 * @private
	 * Graphic bounds数据类
	 */
	public class BoundsStyle {
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**@private */
		public var bounds:Rectangle;
		/**用户设的bounds*/
		public var userBounds:Rectangle;
		/**缓存的bounds顶点,sprite计算bounds用*/
		public var temBM:Array;

		/**
		 * 重置
		 */
		public function reset():BoundsStyle {
			if(bounds) bounds.recover();
			if(userBounds) userBounds.recover();
			bounds=null;
			userBounds=null;
			temBM=null;
			return this;
		}
		
		/**
		 * 回收
		 */
		public function recover():void{
			Pool.recover("BoundsStyle", reset());
		}
		
		/**
		 * 创建
		 */
		public static function create():BoundsStyle {
			return Pool.getItemByClass("BoundsStyle", BoundsStyle);
		}
	}
}