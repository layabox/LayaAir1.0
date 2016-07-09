(function()
{
	var Stage     = Laya.Stage;
	var TiledMap  = Laya.TiledMap;
	var Rectangle = Laya.Rectangle;
	var Browser   = Laya.Browser;
	var WebGL     = Laya.WebGL;

	var tiledMap;
	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(700, 500, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.bgColor = "#232628";

		createMap();
	})();

	function createMap()
	{
		tiledMap = new TiledMap();
		tiledMap.createMap("res/tiledMap/perspective_walls.json", new Rectangle(0, 0, Laya.stage.width, Laya.stage.height), null);
	}
})();