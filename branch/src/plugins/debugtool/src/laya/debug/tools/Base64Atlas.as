package laya.debug.tools 
{
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Handler;
	/**
	 * ...
	 * @author ww
	 */
	public class Base64Atlas 
	{
		public var data:Object;
		public var replaceO:Object;
		public var idKey:String;
		public function Base64Atlas(data:Object,idKey:String=null) 
		{
			this.data = data;
			if (!idKey) idKey = Math.random() + "key";
			this.idKey = idKey;
			init();
			//preLoad();
		}
		private function init():void
		{
			replaceO = { };
			var key:String;
			for (key in data)
			{
				replaceO[key] = idKey + "/" + key;
			}
		}
		public function getAdptUrl(url:String):String
		{
			return replaceO[url];
		}
		private var _loadedHandler:Handler;
	    public function preLoad(completeHandler:Handler=null):void
		{
			_loadedHandler = completeHandler;
			Laya.loader.load(Base64ImageTool.getPreloads(data),new Handler(this,preloadEnd));
		}
		private function preloadEnd():void
		{
			var key:String;
			for (key in data)
			{
				var tx:Texture;
				tx = Laya.loader.getRes(data[key]);
				Loader.cacheRes(replaceO[key], tx);
				//trace("cacheRes:",replaceO[key],tx);
			}
			if (_loadedHandler)
			{
				_loadedHandler.run();
			}
		}
		public function replaceRes(uiObj:Object):void
		{
			ObjectTools.replaceValue(uiObj, replaceO);
		}
		
	}

}