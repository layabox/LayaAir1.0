(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Event   = Laya.Event;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	var ape1;
	var ape2;

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
		//显示两只猩猩
		ape1 = new Sprite();
		ape2 = new Sprite();
		ape1.loadImage("res/apes/monkey2.png");
		ape2.loadImage("res/apes/monkey2.png");

		ape1.pivot(55, 72);
		ape2.pivot(55, 72);

		ape1.pos(Laya.stage.width / 2, Laya.stage.height / 2);
		ape2.pos(200, 0);

		//一只猩猩在舞台上，另一只被添加成第一只猩猩的子级
		Laya.stage.addChild(ape1);
		ape1.addChild(ape2);

		Laya.timer.frameLoop(1, this, animate);
	}

	function animate(e)
	{
		ape1.rotation += 2;
		ape2.rotation -= 4;
	}
})();