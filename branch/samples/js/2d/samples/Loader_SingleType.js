(function()
{
	var Loader  = Laya.Loader;
	var Texture = Laya.Texture;
	var Handler = Laya.Handler;

	(function()
	{
		Laya.init(550, 400);

		// 加载一张png类型资源
		Laya.loader.load("../../res/apes/monkey0.png", Handler.create(this, onAssetLoaded1));
		// 加载多张png类型资源
		Laya.loader.load(
			["../../res/apes/monkey0.png", "../../res/apes/monkey1.png", "../../res/apes/monkey2.png"],
			Handler.create(this, onAssetLoaded2));
	})();

	function onAssetLoaded1(texture)
	{
		// 使用texture
	}

	function onAssetLoaded2()
	{
		var pic1 = Loader.getRes("../../res/apes/monkey0.png");
		var pic2 = Loader.getRes("../../res/apes/monkey1.png");
		var pic3 = Loader.getRes("../../res/apes/monkey2.png");
		// 使用资源
	}
})();