/// <reference path="../../libs/LayaAir.d.ts" />
class SmartScale_EXTRACT_FIT {

	constructor() {
		Laya.init(550, 400);
		Laya.stage.scaleMode = laya.display.Stage.SCALE_EXACTFIT;

		var rect = new laya.display.Sprite();
		rect.graphics.drawRect(-100, -100, 200, 200, "gray");
		Laya.stage.addChild(rect);

		rect.x = Laya.stage.width / 2;
		rect.y = Laya.stage.height / 2;
	}
}
new SmartScale_EXTRACT_FIT();