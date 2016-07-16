(function()
{
	var Animation = laya.display.Animation;
	var Stage     = laya.display.Stage;
	var Rectangle = laya.maths.Rectangle;
	var Loader    = laya.net.Loader;
	var Browser   = laya.utils.Browser;
	var Handler   = laya.utils.Handler;
	var WebGL     = laya.webgl.WebGL;

	var AniConfPath = "../../res/fighter/fighter.json";

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		Laya.loader.load(AniConfPath, Handler.create(this, createAnimation), null, Loader.ATLAS);
	})();

	function createAnimation()
	{
		var ani = new Animation();
		ani.loadAtlas(AniConfPath); // 加载图集动画
		ani.interval = 30;			// 设置播放间隔（单位：毫秒）
		ani.index = 1; 				// 当前播放索引
		ani.play(); 				// 播放图集动画

		// 获取动画的边界信息
		var bounds = ani.getGraphicBounds();
		ani.pivot(bounds.width / 2, bounds.height / 2);

		ani.pos(Laya.stage.width / 2, Laya.stage.height / 2);

		Laya.stage.addChild(ani);
	}
})();