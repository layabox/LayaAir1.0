/// <reference path="../../libs/LayaAir.d.ts" />
import Sprite = laya.display.Sprite;
class SmartScale_SIZE_FULL_WIDTH {
	private rect: Sprite;

	constructor() {
		Laya.init(laya.utils.Browser.width, laya.utils.Browser.height);

		Laya.stage.sizeMode = laya.display.Stage.SIZE_FULL_WIDTH;

		this.rect = new laya.display.Sprite();
		this.rect.graphics.drawRect(-100, -100, 200, 200, "gray");
		Laya.stage.addChild(this.rect);

		this.updateRectPos();
		Laya.stage.on("resize", this, this.updateRectPos);
	}

	private updateRectPos() {
		this.rect.x = laya.utils.Browser.clientWidth / 2;
		this.rect.y = laya.utils.Browser.clientHeight / 2;
	}
}
new SmartScale_SIZE_FULL_WIDTH();