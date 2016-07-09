(function()
{
	var Sprite = Laya.Sprite;
	var Text = Laya.Text;
	var Browser = Laya.Browser;
	var WebGL = Laya.WebGL;

	var starCount = 2500;
	var sx = 1.0 + (Math.random() / 20);
	var sy = 1.0 + (Math.random() / 20);
	var stars = [];
	var w = Browser.width;
	var h = Browser.height;
	var slideX = w / 2;
	var slideY = h / 2;

	var speedInfo;

	(function()
	{
		Laya.init(w, h, WebGL);

		createText();
		start();
	})();

	function start()
	{
		for (var i = 0; i < starCount; i++)
		{
			var tempBall = new Sprite();
			tempBall.loadImage("res/pixi/bubble_32x32.png");

			tempBall.x = (Math.random() * w) - slideX;
			tempBall.y = (Math.random() * h) - slideY;
			tempBall.pivot(16, 16);

			stars.push(
			{
				sprite: tempBall,
				x: tempBall.x,
				y: tempBall.y
			});

			Laya.stage.addChild(tempBall);
		}

		Laya.stage.on('click', this, newWave);
		speedInfo.text = 'SX: ' + sx + '\nSY: ' + sy;

		resize();

		Laya.timer.frameLoop(1, this, update);
	}

	function createText()
	{
		speedInfo = new Text();
		speedInfo.color = "#FFFFFF";
		speedInfo.pos(w - 160, 20);
		speedInfo.zOrder = 1;
		Laya.stage.addChild(speedInfo);
	}

	function newWave()
	{
		sx = 1.0 + (Math.random() / 20);
		sy = 1.0 + (Math.random() / 20);
		speedInfo.text = 'SX: ' + sx + '\nSY: ' + sy;
	}

	function resize()
	{
		w = Laya.stage.width;
		h = Laya.stage.height;

		slideX = w / 2;
		slideY = h / 2;
	}

	function update()
	{
		for (var i = 0; i < starCount; i++)
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
})();