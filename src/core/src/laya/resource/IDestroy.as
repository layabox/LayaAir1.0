package laya.resource {
	
	/**
	 * @private
	 * <code>IDestroy</code> 是对象销毁的接口。
	 */
	public interface IDestroy {
		function get destroyed():Boolean;
		function _destroy():void;
	}
}