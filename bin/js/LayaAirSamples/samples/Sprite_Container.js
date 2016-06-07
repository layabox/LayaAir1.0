(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Event   = Laya.Event;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	// 该容器用于装载4张猩猩图片
	var apesCtn;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		createApes();
	})();

	function createApes()
	{
		// 每只猩猩距离中心点150像素
		var layoutRadius = 150;
		var radianUnit = Math.PI / 2;

		apesCtn = new Sprite();
		Laya.stage.addChild(apesCtn);

		// 添加4张猩猩图片
		for (var i = 0; i < 4; i++)
		{
			var ape = new Sprite();
			ape.loadImage("res/apes/monkey" + i + ".png");

			ape.pivot(55, 72);

			// 以圆周排列猩猩
			ape.pos(
				Math.cos(radianUnit * i) * layoutRadius,
				Math.sin(radianUnit * i) * layoutRadius);

			apesCtn.addChild(ape);
		}

		apesCtn.pos(Laya.stage.width / 2, Laya.stage.height / 2);

		Laya.timer.frameLoop(1, this, animate);
	}

	function animate(e)
	{
		apesCtn.rotation += 1;
	}
})();