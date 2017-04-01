package
{
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	/**
	 * ...
	 * @author Survivor
	 */
	public class PIXI_Example_04
	{
		private var starCount:int = 2500;
		private var sx:Number = 1.0 + (Math.random() / 20);
		private var sy:Number = 1.0 + (Math.random() / 20);
		private var stars:Array = [];
		private var w:int = Browser.width;
		private var h:int = Browser.height;
		private var slideX:int = w / 2;
		private var slideY:int = h / 2;
		
		private var speedInfo:Text;
		
		public function PIXI_Example_04()
		{
			Laya.init(w, h, WebGL);
			
			createText();
			start();
		}
		
		private function start():void
		{
			for (var i:int = 0; i < starCount; i++)
			{
				var tempBall:Sprite = new Sprite();
				tempBall.loadImage("../../../../res/pixi/bubble_32x32.png");
				
				tempBall.x = (Math.random() * w) - slideX;
				tempBall.y = (Math.random() * h) - slideY;
				tempBall.pivot(16, 16);
				
				stars.push({sprite: tempBall, x: tempBall.x, y: tempBall.y});
				
				Laya.stage.addChild(tempBall);
			}
			
			Laya.stage.on('click', this, newWave);
			speedInfo.text = 'SX: ' + sx + '\nSY: ' + sy;
			
			resize();
			
			Laya.timer.frameLoop(1, this, update);
		}
		
		private function createText():void
		{
			speedInfo = new Text();
			speedInfo.color = "#FFFFFF";
			speedInfo.pos(w - 160, 20);
			speedInfo.zOrder = 1;
			Laya.stage.addChild(speedInfo);
		}
		
		private function newWave():void
		{
			sx = 1.0 + (Math.random() / 20);
			sy = 1.0 + (Math.random() / 20);
			speedInfo.text = 'SX: ' + sx + '\nSY: ' + sy;
		}
		
		private function resize():void
		{
			w = Laya.stage.width;
			h = Laya.stage.height;
			
			slideX = w / 2;
			slideY = h / 2;
		}
		
		private function update():void
		{
			for (var i:int = 0; i < starCount; i++)
			{
				stars[i].sprite.x = stars[i].x + slideX;
				stars[i].sprite.y = stars[i].y + slideY;
				stars[i].x = stars[i].x * sx;
				stars[i].y = stars[i].y * sy;
				
				if (stars[i].x > w)
				{
					stars[i].x = stars[i].x - w;
				}
				else if (stars[i].x < -w)
				{
					stars[i].x = stars[i].x + w;
				}
				
				if (stars[i].y > h)
				{
					stars[i].y = stars[i].y - h;
				}
				else if (stars[i].y < -h)
				{
					stars[i].y = stars[i].y + h;
				}
			}
		}
	
	}

}