package
{
	import laya.resource.Texture;
	import laya.utils.Handler;
	
	public class Loader_Sequence
	{
		public function Loader_Sequence()
		{
				Laya.init(100, 100);
				
				// 按序列加载 monkey2.png - monkey1.png - monkey0.png
				// 不开启缓存
				Laya.loader.load("res/apes/monkey2.png", Handler.create(this, onAssetLoaded), null, null, 0, false);
				Laya.loader.load("res/apes/monkey1.png", Handler.create(this, onAssetLoaded), null, null, 1, false);
				Laya.loader.load("res/apes/monkey0.png", Handler.create(this, onAssetLoaded), null, null, 2, false);
			}
			
			private function onAssetLoaded(texture:Texture)
			{
				trace(texture.source);
			}
		}
	}
}