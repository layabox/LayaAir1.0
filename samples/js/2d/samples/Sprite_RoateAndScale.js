(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Event   = Laya.Event;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	var ape;
	var scaleDelta = 0;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		createApe();
	})();

	function createApe()
	{
		ape = new Sprite();

		ape.loadImage("../../res/apes/monkey2.png");
		Laya.stage.addChild(ape);
		ape.pivot(55, 72);
		ape.x = Laya.stage.width / 2;
		ape.y = Laya.stage.height / 2;

		Laya.timer.frameLoop(1, this, animate);
	}

	function animate(e)
	{
		ape.rotation += 2;

		//心跳缩放
		scaleDelta += 0.02;
		var scaleValue = Math.sin(scaleDelta);
		ape.scale(scaleValue, scaleValue);
	}
})();