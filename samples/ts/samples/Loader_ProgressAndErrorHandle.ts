/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import Event = laya.events.Event;
	import Loader = laya.net.Loader;
	import Texture = laya.resource.Texture;
	import Handler = laya.utils.Handler;

	export class Loader_ProgressAndErrorHandle {

		constructor() {
			Laya.init(550, 400);

			// 无加载失败重试
			Laya.loader.retryNum = 0;

			var urls: Array<string> = ["do not exist", "res/fighter/fighter.png", "res/legend/map.jpg"];
			Laya.loader.load(urls, Handler.create(this, this.onAssetLoaded), Handler.create(this, this.onLoading, null, false), Loader.TEXT);

			// 侦听加载失败
			Laya.loader.on(Event.ERROR, this, this.onError);
		}

		private onAssetLoaded(texture: Texture): void {
			// 使用texture
			console.log("加载结束");
		}

		// 加载进度侦听器
		private onLoading(progress: number): void {
			console.log("加载进度: " + progress);
		}

		private onError(err: String): void {
			console.log("加载失败: " + err);
		}
	}
} new laya.Loader_ProgressAndErrorHandle();