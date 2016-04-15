package 
{
	import laya.net.Loader;
	import laya.utils.Handler;
	public class Loader_MultipleType 
	{
		private const ROBOT_DATA_PATH:String = "res/robot/data.bin";
		private const ROBOT_TEXTURE_PATH:String = "res/robot/texture.png";
		
		public function Loader_MultipleType() 
		{
			Laya.init(100, 100);
			
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