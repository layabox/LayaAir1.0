package 
{
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Browser;

	public class Loader_MultipleType 
	{
		private const ROBOT_DATA_PATH:String = "res/skeleton/robot/robot.bin";
		private const ROBOT_TEXTURE_PATH:String = "res/skeleton/robot/texture.png";
		
		public function Loader_MultipleType() 
		{
			Laya.init(Browser.width, Browser.height);
			
			var assets:Array = [];
			assets.push( { url:ROBOT_DATA_PATH, type:Loader.BUFFER } );
			assets.push( { url:ROBOT_TEXTURE_PATH, type:Loader.IMAGE } );
			
			Laya.loader.load(assets, Handler.create(this, onAssetsLoaded));
		}
		
		private function onAssetsLoaded():void
		{
			var robotData:* = Loader.getRes(ROBOT_DATA_PATH);
			var robotTexture:* = Loader.getRes(ROBOT_TEXTURE_PATH);
			// 使用资源
		}
	}
}