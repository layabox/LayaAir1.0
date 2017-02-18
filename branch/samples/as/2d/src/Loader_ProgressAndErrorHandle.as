package
{
	import laya.events.Event;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Handler;
	
	public class Loader_ProgressAndErrorHandle
	{
		
		public function Loader_ProgressAndErrorHandle()
		{
			Laya.init(550, 400);
			
			// 无加载失败重试
			Laya.loader.retryNum = 0;

			var urls:Array = ["do not exist", "../../../../res/fighter/fighter.png", "../../../../res/legend/map.jpg"];
			Laya.loader.load(urls, Handler.create(this, onAssetLoaded), Handler.create(this, onLoading, null, false), Loader.TEXT);

			// 侦听加载失败
			Laya.loader.on(Event.ERROR, this, onError);
		}
		
		private function onAssetLoaded(texture:Texture):void
		{
			// 使用texture
			trace("加载结束");
		}
		
		// 加载进度侦听器
		private function onLoading(progress:Number):void
		{
			trace("加载进度: " + progress);
		}
		
		private function onError(err:String):void
		{
			trace("加载失败: " + err);
		}
	}
}