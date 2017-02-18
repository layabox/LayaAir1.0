package laya.debug.tools.enginehook 
{
	import laya.debug.view.nodeInfo.views.OutPutView;
	import laya.events.Event;
	import laya.net.LoaderManager;
	import laya.net.LocalStorage;
	import laya.utils.Handler;
	/**
	 * ...
	 * @author ww
	 */
	public class LoaderHook extends LoaderManager
	{
		
		public function LoaderHook() 
		{
			
		}
		private static var preFails:Object = { };
		private static var nowFails:Object = { };
		public static var enableFailDebugger:Boolean = true;
		public static const FailSign:String = "LoadFailItems";
		public static var isInited:Boolean = false;
		public static function init():void
		{	
			if (isInited) return;
			isInited = true;
			Laya.loader = new LoaderHook();
			Laya.loader.on(Event.ERROR, null, onFail);
			preFails = LocalStorage.getJSON(FailSign);
			if (!preFails) preFails = { };
			
		}
		
		private static function onFail(failFile:String):void
		{
			OutPutView.I.dTrace("LoadFail:" + failFile);
            nowFails[failFile] = true;
			LocalStorage.setJSON(FailSign, nowFails);
		}
		public static function resetFails():void
		{
			nowFails= {};
			LocalStorage.setJSON(FailSign, nowFails);
		}
		public function checkUrls(url:*):void
		{
			var tarUrl:String;
			if (url is String)
			{
				tarUrl = url;
			}else
			{
				tarUrl = url.url;
			}
			if (preFails[tarUrl])
			{
				
				if (enableFailDebugger)
				{
					debugger;
				}
			}
		}
		public function chekUrlList(urls:Array):void
		{
			var i:int, len:int;
			len = urls.length;
			for (i = 0; i < len; i++)
			{
				checkUrls(urls[i]);
			}
		}
		override public function load(url:*, complete:Handler = null, progress:Handler = null, type:String = null, priority:int = 1, cache:Boolean = true, group:String = null, ignoreCache:Boolean = false):LoaderManager 
		{
			if (url is Array)
			{
				chekUrlList(url as Array);
			}else
			{
				checkUrls(url);
			}
			return super.load(url, complete, progress, type, priority, cache,group,ignoreCache);
		}
		
		
	}

}