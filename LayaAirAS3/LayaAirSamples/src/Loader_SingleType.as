package 
{
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Handler;
	
	public class Loader_SingleType 
	{
		
		public function Loader_SingleType() 
		{
			Laya.init(100, 100);
			
			// 加载一张png类型资源
			Laya.loader.load("res/apes/monkey0.png", Handler.create(this, onAssetLoaded1));
			// 加载多张png类型资源
			Laya.loader.load(
				["res/apes/monkey0.png", "res/apes/monkey1.png", "res/apes/monkey2.png"],
				Handler.create(this, onAssetLoaded2));
		}
		
		private function onAssetLoaded1(texture:Texture):void
		{
			// 使用texture
		}
		
		private function onAssetLoaded2():void
		{
			var pic1:Texture = Loader.getRes("res/apes/monkey0.png");
			var pic2:Texture = Loader.getRes("res/apes/monkey1.png");
			var pic3:Texture = Loader.getRes("res/apes/monkey2.png");
			// 使用资源
		}
	}
}