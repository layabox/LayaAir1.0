/// <reference path="../../libs/LayaAir.d.ts" />
module laya
{
	import Texture = laya.resource.Texture;
	import Event = laya.events.Event;
	import Loader = laya.net.Loader;
	import LoaderManager = laya.net.LoaderManager;
	import Handler = laya.utils.Handler;
	
	export class Loader_ProgressAndErrorHandle
	{
		
		constructor()
		{
			Laya.init(100, 100);
			
			var urls: Array<string> = ["res/fighter/fighter.png", "res/legend/map.jpg", "doNotExist"];
			Laya.loader.load(urls, Handler.create(this, this.onAssetLoaded), Handler.create(this, this.onLoading, null, false), Loader.TEXT);
			// 侦听加载失败
			Laya.loader.on(Event.ERROR, this, this.onError);
		}
		
		private onAssetLoaded(texture:Texture):void
		{
			// 使用texture
			console.log("加载结束");
		}
		
		// 加载进度侦听器
		private onLoading(progress:Number):void
		{
			console.log("加载进度: " + progress);
		}
		
		private onError(err:String):void
		{
			console.log("加载失败: " + err);
		}
	}
}
new laya.Loader_ProgressAndErrorHandle();