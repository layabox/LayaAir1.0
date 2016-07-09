package
{
	import laya.display.Sprite;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.maths.Rectangle;
	import laya.webgl.WebGL;
	
	public class PerformanceTest_Maggots
	{
		private var texturePath:String = "res/tinyMaggot.png";
		
		private var padding:int = 100;
		private var maggotAmount:int = 5000;

		private var tick:Number = 0;		
		private var maggots:Array = [];
		private var wrapBounds:Rectangle;
		private var maggotTexture:*;
		
		public function PerformanceTest_Maggots()
		{
			Laya.init(Browser.width,Browser.height, WebGL);
			Laya.stage.bgColor = "#000000";
			Stat.show();
			
			wrapBounds = new Rectangle(-padding, -padding, Laya.stage.width + padding * 2, Laya.stage.height + padding * 2);
			
			Laya.loader.load(texturePath, Handler.create(this, onTextureLoaded));
		}
		
		private function onTextureLoaded(e:*=null):void
		{
			maggotTexture = Laya.loader.getRes(texturePath);
			initMaggots();
			Laya.timer.frameLoop(1, this, animate);
		}
		
		private function initMaggots():void 
		{
			var maggotContainer:Sprite;
			for (var i:int = 0; i < maggotAmount; i++)
			{
				if (i % 16000 == 0)
					maggotContainer = createNewContainer();

				var maggot:Maggot = newMaggot();
				maggotContainer.addChild(maggot);
				maggots.push(maggot);
			}
		}

		private function createNewContainer():Sprite
		{
			var container:Sprite = new Sprite();
			container.size(Browser.clientWidth,Browser.clientHeight);
			// 此处cacheAsBitmap主要是为了创建新画布
			// 解除IBQuadrangle数量限制
			// 在显示虫子数量超过16383时需要打开下面一行
			// container.cacheAsBitmap = true;
			Laya.stage.addChild(container);
			return container;
		}

		private function newMaggot():Maggot
		{
			var maggot:Maggot = new Maggot();
			maggot.graphics.drawTexture(maggotTexture, 0, 0);

			maggot.pivot(16.5, 35);

			var rndScale:Number = 0.8 + Math.random() * 0.3;
			maggot.scale(rndScale, rndScale);
			maggot.rotation = 0.1;
			maggot.x = Math.random() * Laya.stage.width;
			maggot.y = Math.random() * Laya.stage.height;
			
			maggot.direction = Math.random() * Math.PI;
			maggot.turningSpeed = Math.random() - 0.8;
			maggot.speed = (2 + Math.random() * 2) * 0.2;
			maggot.offset = Math.random() * 100;

			return maggot;
		}
		
		private function animate():void
		{
			var maggot:*;
			var wb:Rectangle = this.wrapBounds;
			var angleUnit:Number = 180 / Math.PI;
			var dir:*, x:Number = 0.0, y:Number = 0.0;
			for (var i:int = 0; i < maggotAmount; i++)
			{
				maggot = maggots[i];
				
				maggot.scaleY = 0.90 + Math.sin(tick + maggot.offset) * 0.1;
				
				maggot.direction += maggot.turningSpeed * 0.01;
				dir = maggot.direction;
				x = maggot.x;
				y = maggot.y;

				x += Math.sin(dir) * (maggot.speed * maggot.scaleY);
				y += Math.cos(dir) * (maggot.speed * maggot.scaleY);
				
				maggot.rotation = (-dir + Math.PI) * angleUnit;
				
				if (x < wb.x)
					x += wb.width;
				else if (x > wb.x + wb.width)
					x -= wb.width;
				if (y < wb.y)
					y += wb.height;
				else if (y > wb.y + wb.height)
					y -= wb.height;
				
				maggot.pos(x, y);
			}
			
			tick += 0.1;
		}
	}
}

import laya.display.Sprite;
class Maggot extends Sprite
{
	public var direction:Number;
	public var turningSpeed:Number;
	public var speed:Number;
	public var offset:Number;
}