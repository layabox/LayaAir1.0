(function()
{
	var Sprite     = laya.display.Sprite;
	var Stage      = laya.display.Stage;
	var GlowFilter = laya.filters.GlowFilter;
	var Texture    = laya.resource.Texture;
	var Browser    = laya.utils.Browser;
	var Handler    = laya.utils.Handler;
	var WebGL      = laya.webgl.WebGL;

	var apePath = "res/apes/monkey2.png";

	var ape;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		Laya.loader.load(apePath, Handler.create(this, setup));
	})();

	function setup()
	{
		createApe();
		applayFilter();
	}

	function createApe()
	{
		ape = new Sprite();
		ape.loadImage(apePath);

		var texture = Laya.loader.getRes(apePath);
		ape.x = (Laya.stage.width - texture.width) / 2;
		ape.y = (Laya.stage.height - texture.height) / 2;

		Laya.stage.addChild(ape);
	}

	function applayFilter()
	{
		//创建一个发光滤镜
		var glowFilter = new GlowFilter("#ffff00", 10, 0, 0);
		//设置滤镜集合为发光滤镜
		ape.filters = [glowFilter];
	}
})();