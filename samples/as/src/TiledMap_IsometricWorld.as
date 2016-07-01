package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.map.MapLayer;
	import laya.map.TiledMap;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class TiledMap_IsometricWorld
	{
		private var tiledMap:TiledMap;
		private var layer:MapLayer;
		private var sprite:Sprite;
		
		public function TiledMap_IsometricWorld()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(1600, 800, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
			
			createMap();
			
			Laya.stage.on("click", this, onStageClick);
		}
		
		private function createMap():void
		{
			tiledMap = new TiledMap();
			tiledMap.createMap("res/tiledMap/isometric_grass_and_water.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), Handler.create(this, mapLoaded), null, new Point(1600, 800));
		}
		
		private function onStageClick(e:*=null):void
		{
			var p:Point = new Point(0, 0);
			layer.getTilePositionByScreenPos(Laya.stage.mouseX, Laya.stage.mouseY, p);
			layer.getScreenPositionByTilePos(Math.floor(p.x), Math.floor(p.y), p);
			sprite.pos(p.x, p.y);
		}
		
		private function mapLoaded(e:*=null):void
		{
			layer = tiledMap.getLayerByIndex(0);
			
			var radiusX:Number = 32;
			var radiusY:Number = Math.tan(180 / Math.PI * 30) * radiusX;
			var color:String = "#FF7F50";
			
			sprite = new Sprite();
			sprite.graphics.drawLine(0, 0, -radiusX, radiusY, color);
			sprite.graphics.drawLine(0, 0, radiusX, radiusY, color);
			sprite.graphics.drawLine(-radiusX, radiusY, 0, radiusY * 2, color);
			sprite.graphics.drawLine(radiusX, radiusY, 0, radiusY * 2, color);
			Laya.stage.addChild(sprite);
		}
	}
}