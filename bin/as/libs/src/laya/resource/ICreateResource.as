package laya.resource {
	
	/**
	 * @private
	 * <code>ICreateResource</code> 对象创建接口。
	 */
	public interface ICreateResource {
		function set _loaded(value:Boolean):void;
		
		function get loaded():Boolean;
		function get destroyed():Boolean;
		
		function _getGroup():String;
		function _setGroup(value:String):void;
		function _setUrl(url:String):void;
		
		function onAsynLoaded(url:String, data:*, params:Array):void;
	}
}