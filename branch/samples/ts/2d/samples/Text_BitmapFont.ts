module laya {
	import BitmapFont = Laya.BitmapFont;
	import Stage = Laya.Stage;
	import Text = Laya.Text;
	import Browser = Laya.Browser;
	import Handler = Laya.Handler;
	import WebGL = Laya.WebGL;

	export class Text_BitmapFont {
		private fontName: string = "diyFont";

		constructor()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			this.loadFont();
		}

		private loadFont(): void {
			var bitmapFont: BitmapFont = new BitmapFont();
			bitmapFont.loadFont("../../res/bitmapFont/test.fnt", new Handler(this, this.onFontLoaded, [bitmapFont]));
		}

		private onFontLoaded(bitmapFont: BitmapFont): void {
			bitmapFont.setSpaceWidth(10);
			Text.registerBitmapFont(this.fontName, bitmapFont);

			this.createText(this.fontName);
		}

		private createText(font: string): void {
			var txt: Text = new Text();
			txt.width = 250;
			txt.wordWrap = true;
			txt.text = "Do one thing at a time, and do well.";
			txt.font = font;
			txt.leading = 5;
			txt.pos(Laya.stage.width - txt.width >> 1, Laya.stage.height - txt.height >> 1);
			Laya.stage.addChild(txt);
		}
	}
}
new laya.Text_BitmapFont();