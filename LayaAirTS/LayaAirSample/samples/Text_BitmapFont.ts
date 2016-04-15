/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import BitmapFont = laya.display.BitmapFont;
	import Handler = laya.utils.Handler;
	import Text = laya.display.Text;

	export class Text_BitmapFont {
		private fontName: string = "diyFont";

		constructor() {
			Laya.init(550, 400);

			var bitmapFont: BitmapFont = new BitmapFont();
			bitmapFont.loadFont("res/bitmapFont/test.fnt", new Handler(this, this.onLoaded, [bitmapFont]));
		}

		private onLoaded(bitmapFont: BitmapFont): void {
			bitmapFont.setSpaceWidth(10);
			Text.registerBitmapFont(this.fontName, bitmapFont);

			this.createText(this.fontName);
		}

		private createText(font: string): void {
			var txt: laya.display.Text = new laya.display.Text();
			txt.width = 250;
			txt.wordWrap = true;
			txt.text = "Do one thing at a time, and do well.";
			txt.font = font;
			txt.leading = 5;
			txt.pos(150, 100);
			Laya.stage.addChild(txt);
		}
	}
}
new laya.Text_BitmapFont();