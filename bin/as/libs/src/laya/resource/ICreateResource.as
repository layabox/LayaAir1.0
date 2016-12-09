package laya.resource {
	
	/**
	 * @private
	 * <code>ICreateResource</code> 对象创建接口。
	 */
	public interface ICreateResource {
		function onAsynLoaded(url:String, data:*):void;
	}
}