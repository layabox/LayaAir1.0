package laya.resource {
	
	/**
	 * @private
	 * <code>ICreateResource</code> 资源创建接口。
	 */
	public interface ICreateResource {
		function onAsynLoaded(url:String, data:*):void;
	}

}