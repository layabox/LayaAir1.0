(function()
{
	var Sprite     = Laya.Sprite;
	var Stage      = Laya.Stage;
	var BlurFilter = Laya.BlurFilter;
	var Browser    = Laya.Browser;
	var Handler    = Laya.Handler;
	var WebGL      = Laya.WebGL;

	var apePath = "../../res/apes/monkey2.png";

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		Laya.loader.load(apePath, Handler.create(this, createApe));
	})();

	function createApe()
	{
		var ape = new Sprite();
		ape.loadImage(apePath);

		ape.x = (Laya.stage.width - ape.width) / 2;
		ape.y = (Laya.stage.height - ape.height) / 2;

		Laya.stage.addChild(ape);

		applayFilter(ape);
	}

	function applayFilter(ape)
	{
		var blurFilter = new BlurFilter();
		blurFilter.strength = 5;
		ape.filters = [blurFilter];
	}
})();