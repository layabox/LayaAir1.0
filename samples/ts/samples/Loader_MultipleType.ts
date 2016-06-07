/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import Loader = laya.net.Loader;
	import Handler = laya.utils.Handler;
	import Browser = laya.utils.Browser;

	export class Loader_MultipleType {
		private ROBOT_DATA_PATH: string = "res/skeleton/robot/robot.bin";
		private ROBOT_TEXTURE_PATH: string = "res/skeleton/robot/texture.png";

		constructor() {
			Laya.init(Browser.width, Browser.height);

			var assets: Array<any> = [];
			assets.push({ url: this.ROBOT_DATA_PATH, type: Loader.BUFFER });
			assets.push({ url: this.ROBOT_TEXTURE_PATH, type: Loader.IMAGE });

			Laya.loader.load(assets, Handler.create(this, this.onAssetsLoaded));
		}

		private onAssetsLoaded(): void {
			var robotData: any = Loader.getRes(this.ROBOT_DATA_PATH);
			var robotTexture: any = Loader.getRes(this.ROBOT_TEXTURE_PATH);
			// 使用资源
		}
	}
}
new laya.Loader_MultipleType();