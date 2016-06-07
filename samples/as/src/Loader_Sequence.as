package
{
	import laya.resource.Texture;
	import laya.utils.Handler;
	
	public class Loader_Sequence
	{
		private var numLoaded:int = 0;
		private var resAmount:int = 3;
		
		public function Loader_Sequence()
		{
			Laya.init(500, 400);
			
			// 按序列加载 monkey2.png - monkey1.png - monkey0.png
			// 不开启缓存
			// 关闭并发加载
			Laya.loader.maxLoader = 1;
			Laya.loader.load("res/apes/monkey2.png", Handler.create(this, onAssetLoaded), null, null, 0, false);
			Laya.loader.load("res/apes/monkey1.png", Handler.create(this, onAssetLoaded), null, null, 1, false);
			Laya.loader.load("res/apes/monkey0.png", Handler.create(this, onAssetLoaded), null, null, 2, false);
		}
		
		private function onAssetLoaded(texture:Texture):void
		{
			trace(texture.source);
			
			// 恢复默认并发加载个数。
			if (++numLoaded == 3)
			{
				Laya.loader.maxLoader = 5;
				trace("All done.");
			}
		}
	}
}