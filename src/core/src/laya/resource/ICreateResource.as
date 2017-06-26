package laya.resource {
	
	/**
	 * @private
	 * <code>ICreateResource</code> 对象创建接口。
	 */
	public interface ICreateResource {
		function get loaded():Boolean;
		function set _loaded(value:Boolean):void;
		function get url():String;
		function set url(value:String):void;
		function onAsynLoaded(url:String, data:*, params:Array):void;
	}
}