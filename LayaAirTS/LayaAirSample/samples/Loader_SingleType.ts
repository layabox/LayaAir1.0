/// <reference path="../../libs/LayaAir.d.ts" />
import Handler = laya.utils.Handler;
import Loader = laya.net.Loader;
import Texture = laya.resource.Texture;

class Loader_SingleType
{
	constructor()
	{
		Laya.init(100, 100);

		// 加载一张png类型资源
		Laya.loader.load("res/apes/monkey0.png", Handler.create(this, this.onAssetLoaded1));
		// 加载多张png类型资源
		Laya.loader.load(
			["res/apes/monkey0.png", "res/apes/monkey1.png", "res/apes/monkey2.png"],
			Handler.create(this, this.onAssetLoaded2));
	}

	private onAssetLoaded1(texture:Texture):void
	{
		// 使用texture
	}

	private onAssetLoaded2():void
	{
		var pic1: Texture = Loader.getRes("res/apes/monkey0.png");
		var pic2: Texture = Loader.getRes("res/apes/monkey1.png");
		var pic3: Texture = Loader.getRes("res/apes/monkey2.png");
		// 使用资源
	}
}
new Loader_SingleType();