package laya.resource {
	
	/**
	 * @private
	 * <code>IList</code> 可加入队列接口。
	 */
	public interface ISingletonElement {
		function _getIndexInList():int;
		function _setIndexInList(index:int):void;
	}
}