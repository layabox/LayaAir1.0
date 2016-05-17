package
{
	import laya.map.TiledMap;
	import laya.maths.Rectangle;
	
	public class TiledMap_PerspectiveWall
	{
		private var tiledMap:TiledMap;
		public function TiledMap_PerspectiveWall()
		{
			Laya.init(700, 450);
			
			createMap();
		}
		
		private function createMap():void
		{
			tiledMap = new TiledMap();
			tiledMap.createMap("res/tiledMap/perspective_walls.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
		}
	}
}