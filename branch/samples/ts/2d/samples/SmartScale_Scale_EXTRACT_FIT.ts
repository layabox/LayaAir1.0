module laya {
	import Sprite = Laya.Sprite;
	import Stage = Laya.Stage;

	export class SmartScale_Scale_EXTRACT_FIT {
		private rect: Sprite;

		constructor() {
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_EXACTFIT;
			Laya.stage.bgColor = "#232628";
			this.createCantralRect();
		}

		private createCantralRect(): void {
			this.rect = new Sprite();
			this.rect.graphics.drawRect(-100, -100, 200, 200, "gray");
			Laya.stage.addChild(this.rect);

			this.updateRectPos();
		}

		private updateRectPos(): void {
			this.rect.x = Laya.stage.width / 2;
			this.rect.y = Laya.stage.height / 2;
		}
	}

} new laya.SmartScale_Scale_EXTRACT_FIT();