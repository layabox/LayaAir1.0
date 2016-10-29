package laya.debug.tools 
{

	import laya.net.Loader;
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.resource.ResourceManager;
	import laya.resource.Texture;
	/**
	 * ...
	 * @author ww
	 */
	public class ResTools 
	{
		
		public function ResTools() 
		{
			
		}
		public static function getCachedResList():Array
		{
			if (Render.isWebGL)
			{
				return getWebGlResList();
			}else
			{
				return getCanvasResList();
			}
		}
		private static function getWebGlResList():Array
		{
			var rst:Array;
			rst = [];
			var tResource:Resource;
			var _resources:Array;
			_resources=ResourceManager.currentResourceManager["_resources"];
			for(var i:int = 0;i <_resources.length; i++)
			{
				tResource = 	_resources[i];
				//trace(ClassTool.getClassName(tResource));
				if( ClassTool.getClassName(tResource)=="WebGLImage")
				{
					var url:String = tResource["src"];
					if(url&&url.indexOf("data:image/png;base64")<0)
					rst.push(url);
				}
			}
			return rst;
		}
		
		private static function getCanvasResList():Array
		{
			var picDic:Object;
			picDic = { };
			var dataO:Object;
			dataO = Loader.loadedMap;
			collectPics(dataO, picDic);
		
			return getArrFromDic(picDic);
		}
		private static function getArrFromDic(dic:Object):Array
		{

			var key:String;
			var rst:Array;
			rst = [];
			for (key in dic) {
				
				rst.push(key);
			}
			return rst;
		}
		private static function collectPics(dataO:Object, picDic:Object):void
		{
			if (!dataO) return;
			var key:String;
			var tTexture:Texture;
			for (key in dataO)
			{
				tTexture = dataO[key];
				if (tTexture) 
				{
					if (tTexture.bitmap&&tTexture.bitmap.src)
					{
						var url:String = tTexture.bitmap.src;
						if(url.indexOf("data:image/png;base64")<0)
						picDic[tTexture.bitmap.src] = true;
					}
					
				}
			}
		}
	}

}