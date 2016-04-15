Laya.init(100, 100);

// 加载一张png类型资源
Laya.loader.load("res/apes/monkey0.png", laya.utils.Handler.create(this, onAssetLoaded1));
// 加载多张png类型资源
Laya.loader.load(["res/apes/monkey0.png", "res/apes/monkey1.png", "res/apes/monkey2.png"], laya.utils.Handler.create(this, onAssetLoaded2));

function onAssetLoaded1(texture)
{
	// 使用texture
}

function onAssetLoaded2()
{
	var pic1 = Laya.loader.getRes("res/apes/monkey0.png");
	var pic2 = Laya.loader.getRes("res/apes/monkey1.png");
	var pic3 = Laya.loader.getRes("res/apes/monkey2.png");
	// 使用资源
}