package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.map.MapLayer;
	import laya.map.TiledMap;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	public class TiledMap_Hexagon
	{
		private var msgText:Text;
		private var tiledMap:TiledMap;
		private var layer:MapLayer;
		private var mapSprite:Sprite;
		
		public function TiledMap_Hexagon()
		{
			Laya.init(Browser.width, Browser.height);
			
			createMap();
			createMsgText();
			
			Laya.stage.on("click", this, onTileClick);
		}
		
		private function createMap():void
		{
			tiledMap = new TiledMap();
			tiledMap.createMap("res/tiledMap/hexagonal-mini.json", new Rectangle(0, 0, Browser.width, Browser.height), Handler.create(this, mapLoaded));
		}
		
		private function mapLoaded():void
		{
			mapSprite = tiledMap.mapSprite();
			var mapBounds:Rectangle = mapSprite.getBounds();
			tiledMap.moveViewPort(-(Laya.stage.width - mapBounds.width >> 1), -(Laya.stage.height - mapBounds.height >> 1));
			layer = tiledMap.getLayerByIndex(0);
		}
		
		private function onTileClick():void
		{
			var result:Point = new Point();
			layer.getTilePositionByScreenPos(Laya.stage.mouseX - mapSprite.x, Laya.stage.mouseY - mapSprite.y, result);
			//layer.getScreenPositionByTilePos(result.x, result.y, result);
			msgText.text = "column: " + Math.floor(result.x) + ", row: " + Math.floor(result.y) + "\n";
		}
		
		private function createMsgText():void
		{
			msgText = new Text()
			Laya.stage.addChild(msgText);
			msgText.color = "white";
			msgText.fontSize = 20;
		}
	}
}
