/// <reference path="../../libs/LayaAir.d.ts" />
import Handler = laya.utils.Handler;
import Loader = laya.net.Loader;

class Loader_MultipleType
{
	private ROBOT_DATA_PATH:string = "res/robot/data.bin";
	private ROBOT_TEXTURE_PATH:string = "res/robot/texture.png";

	constructor()
	{
		Laya.init(100, 100);

		var assets: Array<Object> = [];
		assets.push({ url: this.ROBOT_DATA_PATH, type: Loader.BUFFER });
		assets.push({ url: this.ROBOT_TEXTURE_PATH, type: Loader.IMAGE });

		Laya.loader.load(assets, Handler.create(this, this.onAssetsLoaded));
	}

	private onAssetsLoaded():void
	{
		var robotData:Object = Loader.getRes(this.ROBOT_DATA_PATH);
		var robotTexture:Object = Loader.getRes(this.ROBOT_TEXTURE_PATH);
	}
}
new Loader_MultipleType();