package laya.debug.tools 
{
	import laya.events.EventDispatcher;
	/**
	 * 本类用于模块间消息传递
	 * @author ww
	 */
	public class Notice extends EventDispatcher
	{
		
		public function Notice() 
		{
			
		}
		public static var I:Notice = new Notice();
		
		/**
		 * 发送一个消息 
		 * @param type
		 * @param data
		 * 
		 */
		public static function notify(type:String,data:Object=null):void
		{
			I.event(type,data);
		}
		/**
		 * 监听一个消息 
		 * @param type
		 * @param _scope
		 * @param fun
		 * @param args
		 * 
		 */
		public static function listen(type:String,_scope:*,fun:Function,args:Array=null,cancelBefore:Boolean=false):void
		{
			if(cancelBefore) cancel(type,_scope,fun);
			I.on(type,_scope,fun,args);
		}
		/**
		 * 取消监听消息 
		 * @param type
		 * @param _scope
		 * @param fun
		 * 
		 */
		public static function cancel(type:String,_scope:*,fun:Function):void
		{
			I.off(type,_scope,fun);
		}
	}

}