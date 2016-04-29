package
{
	import laya.display.Sprite;
	import laya.map.MapLayer;
	import laya.map.TiledMap;
	import laya.maths.Rectangle;
	import laya.maths.Point;
	import laya.utils.Handler;
	
	public class TiledMap_IsometricWorld
	{
		private var tiledMap:TiledMap;
		private var layer:MapLayer;
		private var sprite:Sprite;
		
		public function TiledMap_IsometricWorld()
		{
			Laya.init(1600, 800);
			
			createMap();
			
			Laya.stage.on("click", this, onStageClick);
		}
		
		private function createMap():void
		{
			tiledMap = new TiledMap();
			tiledMap.createMap("res/tiledMap/isometric_grass_and_water.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), Handler.create(this, mapLoaded), null, new Point(1600, 800));
		}
		
		private function onStageClick():void
		{
			var p:Point = new Point(0, 0);
			layer.getTilePositionByScreenPos(Laya.stage.mouseX, Laya.stage.mouseY, p);
			layer.getScreenPositionByTilePos(Math.floor(p.x), Math.floor(p.y), p);
			sprite.pos(p.x, p.y);
		}
		
		private function mapLoaded():void
		{
			layer = tiledMap.getLayerByIndex(0);
			
			var radiusX:Number = 32;
			var radiusY:Number = Math.tan(180 / Math.PI * 30) * radiusX;
			var color:String = "cyan";
			
			sprite = new Sprite();
			sprite.graphics.drawLine(0, 0, -radiusX, radiusY, color);
			sprite.graphics.drawLine(0, 0, radiusX, radiusY, color);
			sprite.graphics.drawLine(-radiusX, radiusY, 0, radiusY * 2, color);
			sprite.graphics.drawLine(radiusX, radiusY, 0, radiusY * 2, color);
			Laya.stage.addChild(sprite);
		}
	}
}