/// <reference path="../../libs/LayaAir.d.ts" />
class SmartScale_Align_Contral {
	constructor() {
		Laya.init(100, 100);
		Laya.stage.scaleMode = laya.display.Stage.SCALE_NOSCALE;

		Laya.stage.alignH = laya.display.Stage.ALIGN_CENTER;
		Laya.stage.alignV = laya.display.Stage.ALIGN_MIDDLE;
	}
}
new SmartScale_Align_Contral();