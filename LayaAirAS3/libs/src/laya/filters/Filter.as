package laya.filters {

	/**
	 * ...
	 * @author wk
	 */
	public class Filter implements IFilter 
	{
		public static const BLUR:int = 0x10;
		public static const COLOR:int = 0x20;
		public static const GLOW:int = 0x08;	
		
		public static var _filterStart:Function;
		public static var _filterEnd:Function;
		public static var _EndTarget:Function;
		public static var _recycleScope:Function;
		public static var _filter:Function;		
		
		public var _action:*;
		public function Filter() {}
		public function get type():int{return -1}
		public function get action():IFilterAction{return _action}		
	}
}