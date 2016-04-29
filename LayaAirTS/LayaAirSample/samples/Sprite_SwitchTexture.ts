/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import Sprite = laya.display.Sprite;
	import Stage = laya.display.Stage;
	import Texture = laya.resource.Texture;
	import Handler = laya.utils.Handler;

	export class Sprite_SwitchTexture {
		private texture1: string = "res/apes/monkey2.png";
		private texture2: string = "res/apes/monkey3.png";
		private flag: boolean = false;

		private ape: Sprite;

		constructor() {
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;

			Laya.loader.load([this.texture1, this.texture2], Handler.create(this, this.onAssetsLoaded));
		}

		private onAssetsLoaded(): void {
			this.ape = new Sprite();
			Laya.stage.addChild(this.ape);

			// 显示默认纹理
			this.switchTexture();

			this.ape.on("click", this, this.switchTexture);
		}

		private switchTexture(): void {
			var textureUrl: string = (this.flag = !this.flag) ? this.texture1 : this.texture2;

			// 更换纹理
			this.ape.graphics.clear();
			var texture: Texture = Laya.loader.getRes(textureUrl);
			this.ape.graphics.drawTexture(texture, 0, 0);

			// 设置交互区域
			this.ape.size(texture.width, texture.height);
		}
	}
}
new laya.Sprite_SwitchTexture();