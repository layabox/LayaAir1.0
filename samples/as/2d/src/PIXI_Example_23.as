package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.maths.Point;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	/**
	 * ...
	 * @author Survivor
	 */
	public class PIXI_Example_23
	{
		private var viewWidth:int = Browser.width;
		private var viewHeight:int = Browser.height;
		private var lasers:Array = [];
		private var tick:int = 0;
		private var frequency:int = 80;
		private var type:int = 0;
		
		public function PIXI_Example_23()
		{
			Laya.init(viewWidth, viewHeight, WebGL);
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			Laya.stage.scaleMode = Stage.SCALE_NOBORDER;
			
			// create a background texture
			Laya.stage.loadImage("../../../../res/pixi/laserBG.jpg");
			
			Laya.stage.frameLoop(1, this, animate);
		}
		
		private function animate():void
		{
			if (tick > frequency)
			{
				tick = 0;
				// iterate through the dudes and update the positions
				var laser:Laser = new Laser();
				laser.loadImage("../../../../res/pixi/laser0" + ((type % 5) + 1) + ".png");
				type++;
				
				laser.life = 0;
				
				var pos1:Point;
				var pos2:Point;
				if (type % 2)
				{
					pos1 = new Point(-20, Math.random() * viewHeight);
					pos2 = new Point(viewWidth, Math.random() * viewHeight + 20);
					
				}
				else
				{
					pos1 = new Point(Math.random() * viewWidth, -20);
					pos2 = new Point(Math.random() * viewWidth, viewHeight + 20);
				}
				
				var distX:Number = pos1.x - pos2.x;
				var distY:Number = pos1.y - pos2.y;
				
				var dist:Number = Math.sqrt(distX * distX + distY * distY) + 40;
				
				laser.scaleX = dist / 20;
				laser.pos(pos1.x, pos1.y);
				laser.pivotY = 43 / 2;
				laser.blendMode = "lighter";
				
				laser.rotation = (Math.atan2(distY, distX) + Math.PI) * 180 / Math.PI;
				
				lasers.push(laser);
				
				Laya.stage.addChild(laser);
				
				frequency *= 0.9;
			}
			
			for (var i:int = 0; i < lasers.length; i++)
			{
				laser = lasers[i];
				laser.life++;
				if (laser.life > 60 * 0.3)
				{
					laser.alpha *= 0.9;
					laser.scaleY = laser.alpha;
					if (laser.alpha < 0.01)
					{
						lasers.splice(i, 1);
						Laya.stage.removeChild(laser);
						i--;
					}
				}
			}
			// increment the ticker
			tick += 1;
		}
	}
}
import laya.display.Sprite;

class Laser extends Sprite
{
	public var life:int;
}