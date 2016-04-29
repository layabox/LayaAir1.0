/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import Sprite = laya.display.Sprite;
	import Handler = laya.utils.Handler;
	import Texture = laya.resource.Texture;

	export class Sprite_DisplayImage {

		constructor() {
			Laya.init(550, 400);
			Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

			// 方法1：使用loadImage
			var ape: Sprite = new Sprite();
			Laya.stage.addChild(ape);
			ape.loadImage("res/apes/monkey3.png");

			// 方法2：使用drawTexture
			Laya.loader.load("res/apes/monkey2.png", Handler.create(this, function() {
				var t: Texture = Laya.loader.getRes("res/apes/monkey2.png");
				var ape: Sprite = new Sprite();
				ape.graphics.drawTexture(t, 0, 0);
				Laya.stage.addChild(ape);
				ape.pos(200, 0);
			}));
		}
	}
}
new laya.Sprite_DisplayImage();