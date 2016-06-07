(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Event   = Laya.Event;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	var sp1, sp2;

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
		var gap = 300;

		sp1 = new Sprite();
		sp1.loadImage("res/apes/monkey2.png", 0, 0);

		sp1.pos((Laya.stage.width - gap) / 2, Laya.stage.height / 2);
		//设置轴心点为中心
		sp1.pivot(55, 72);
		Laya.stage.addChild(sp1);

		//不设置轴心点默认为左上角
		sp2 = new Sprite();
		sp2.loadImage("res/apes/monkey2.png", 0, 0);
		sp2.pos((Laya.stage.width + gap) / 2, Laya.stage.height / 2);
		Laya.stage.addChild(sp2);

		Laya.timer.frameLoop(1, this, animate);
	}

	function animate(e)
	{
		sp1.rotation += 2;
		sp2.rotation += 2;
	}
})();