(function()
{
	var Sprite = laya.display.Sprite;
	var Stage = laya.display.Stage;
	var Browser = laya.utils.Browser;
	var Handler = laya.utils.Handler;
	var WebGL = laya.webgl.WebGL;

	var maskSp;
	var bg2;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(1136, 640, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		Laya.loader.load("res/bg.jpg", Handler.create(this, setup));
	})();

	function setup()
	{
		var bg = new Sprite();
		bg.loadImage("res/bg.jpg");
		Laya.stage.addChild(bg);

		bg2 = new Sprite();
		bg2.loadImage("res/bg.jpg");
		Laya.stage.addChild(bg2);
		bg2.scale(3, 3);

		//创建mask
		maskSp = new Sprite();
		maskSp.loadImage("res/mask.png");
		maskSp.pivot(50, 50);

		//设置mask
		bg2.mask = maskSp;

		Laya.stage.on("mousemove", this, onMouseMove);
	}

	function onMouseMove()
	{
		bg2.x = -Laya.stage.mouseX * 2;
		bg2.y = -Laya.stage.mouseY * 2;

		maskSp.x = Laya.stage.mouseX;
		maskSp.y = Laya.stage.mouseY;
		bg2.repaint();
	}
})();