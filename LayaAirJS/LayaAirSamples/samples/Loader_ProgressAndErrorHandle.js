(function()
{
	var Event = Laya.Event;
	var Loader = Laya.Loader;
	var LoaderManager = Laya.LoaderManager;
	var Handler = Laya.Handler;

	Laya.init(100, 100);

	var urls = ["res/fighter/fighter.png", "res/legend/map.jpg", "doNotExist"];
	Laya.loader.load(urls, Handler.create(this, onAssetLoaded), Handler.create(this, onLoading, null, false), Loader.TEXT);
	// 侦听加载失败
	Laya.loader.on(Event.ERROR, this, onError);

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