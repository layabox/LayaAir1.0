package laya.filters {
	
	/**
	 * 滤镜接口。
	 */
	public interface IFilter {
		function get type():int;
		function get action():IFilterAction;
	}
}