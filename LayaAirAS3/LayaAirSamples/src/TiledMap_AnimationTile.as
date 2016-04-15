package
{
	import laya.map.TiledMap;
	import laya.maths.Rectangle;
		
	public class TiledMap_AnimationTile
	{
		private var tiledMap:TiledMap;
		
		public function TiledMap_AnimationTile()
		{
			Laya.init(1600, 800);
			
			createMap();
		}
		
		private function createMap():void
		{
			tiledMap = new TiledMap();
			tiledMap.createMap("res/tiledMap/orthogonal-test-movelayer.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
		}
	}
}