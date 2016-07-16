(function()
{
	var Event   = laya.events.Event;
	var Loader  = laya.net.Loader;
	var Texture = laya.resource.Texture;
	var Handler = laya.utils.Handler;

	(function()
	{
		Laya.init(550, 400);

		// 无加载失败重试
		Laya.loader.retryNum = 0;

		var urls = ["do not exist", "../../res/fighter/fighter.png", "../../res/legend/map.jpg"];
		Laya.loader.load(urls, Handler.create(this, onAssetLoaded), Handler.create(this, onLoading, null, false), Loader.TEXT);

		// 侦听加载失败
		Laya.loader.on(Event.ERROR, this, onError);
	})();

	function onAssetLoaded(texture)
	{
		// 使用texture
		console.log("加载结束");
	}

	// 加载进度侦听器
	function onLoading(progress)
	{
		console.log("加载进度: " + progress);
	}

	function onError(err)
	{
		console.log("加载失败: " + err);
	}
})();