(function()
{
	var Loader  = laya.net.Loader;
	var Handler = laya.utils.Handler;

	var ROBOT_DATA_PATH = "../../res/skeleton/robot/robot.bin";
	var ROBOT_TEXTURE_PATH = "../../res/skeleton/robot/texture.png";

	(function()
	{
		Laya.init(100, 100);

		var assets = [];
		assets.push(
		{
			url: ROBOT_DATA_PATH,
			type: Loader.BUFFER
		});
		assets.push(
		{
			url: ROBOT_TEXTURE_PATH,
			type: Loader.IMAGE
		});

		Laya.loader.load(assets, Handler.create(this, onAssetsLoaded));
	})();

	function onAssetsLoaded()
	{
		var robotData = Loader.getRes(ROBOT_DATA_PATH);
		var robotTexture = Loader.getRes(ROBOT_TEXTURE_PATH);
		// 使用资源
	}
})();