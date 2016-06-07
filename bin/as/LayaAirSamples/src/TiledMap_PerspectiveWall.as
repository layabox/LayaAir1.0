package
{
	import laya.display.Stage;
	import laya.map.TiledMap;
	import laya.maths.Rectangle;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class TiledMap_PerspectiveWall
	{
		private var tiledMap:TiledMap;
		public function TiledMap_PerspectiveWall()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(700, 500, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
			
			createMap();
		}
		
		private function createMap():void
		{
			tiledMap = new TiledMap();
			tiledMap.createMap("res/tiledMap/perspective_walls.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
		}
	}
}