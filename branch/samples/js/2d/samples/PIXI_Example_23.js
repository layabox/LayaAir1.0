(function()
{
	var Sprite = Laya.Sprite;
	var Stage = Laya.Stage;
	var Point = Laya.Point;
	var Browser = Laya.Browser;
	var WebGL = Laya.WebGL;

	var viewWidth = Browser.width;
	var viewHeight = Browser.height;
	var lasers = [];
	var tick = 0;
	var frequency = 80;
	var type = 0;

	(function()
	{
		Laya.init(viewWidth, viewHeight, WebGL);
		Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
		Laya.stage.scaleMode = Stage.SCALE_NOBORDER;

		// create a background texture
		Laya.stage.loadImage("../../res/pixi/laserBG.jpg");

		Laya.stage.frameLoop(1, this, animate);
	})();

	function animate()
	{
		if (tick > frequency)
		{
			tick = 0;
			// iterate through the dudes and update the positions
			var laser = new Sprite();
			laser.loadImage("../../res/pixi/laser0" + ((type % 5) + 1) + ".png");
			type++;

			laser.life = 0;

			var pos1;
			var pos2;
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

			var distX = pos1.x - pos2.x;
			var distY = pos1.y - pos2.y;

			var dist = Math.sqrt(distX * distX + distY * distY) + 40;

			laser.scaleX = dist / 20;
			laser.pos(pos1.x, pos1.y);
			laser.pivotY = 43 / 2;
			laser.blendMode = "lighter";

			laser.rotation = (Math.atan2(distY, distX) + Math.PI) * 180 / Math.PI;

			lasers.push(laser);

			Laya.stage.addChild(laser);

			frequency *= 0.9;
		}

		for (var i = 0; i < lasers.length; i++)
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
})();