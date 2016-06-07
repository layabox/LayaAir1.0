(function()
{
	var MovieClip = laya.ani.swf.MovieClip;
	var Stage     = laya.display.Stage;
	var Browser   = laya.utils.Browser;
	var WebGL     = laya.webgl.WebGL;

	var SWFPath = "res/swf/dragon.swf";

	var MCWidth = 318;
	var MCHeight = 406;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		createMovieClip();
	})();

	function createMovieClip()
	{
		var mc = new MovieClip();
		mc.load(SWFPath);

		mc.x = (Laya.stage.width - MCWidth) / 2;
		mc.y = (Laya.stage.height - MCHeight) / 2;

		Laya.stage.addChild(mc);
	}
})();