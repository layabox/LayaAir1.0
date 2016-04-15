var Handler = laya.utils.Handler;

Laya.init(100, 100);

// 按序列加载 monkey2.png - monkey1.png - monkey0.png
// 不开启缓存
Laya.loader.load("res/apes/monkey2.png", Handler.create(this, onAssetLoaded), null, null, 0, false);
Laya.loader.load("res/apes/monkey1.png", Handler.create(this, onAssetLoaded), null, null, 1, false);
Laya.loader.load("res/apes/monkey0.png", Handler.create(this, onAssetLoaded), null, null, 2, false);

function onAssetLoaded(texture)
{
	console.log(texture.source);
}