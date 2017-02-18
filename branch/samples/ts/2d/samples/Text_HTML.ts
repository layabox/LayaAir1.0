module laya {
	import Stage = Laya.Stage;
	import HTMLDivElement = Laya.HTMLDivElement;
	import HTMLIframeElement = Laya.HTMLIframeElement;
	import Browser = Laya.Browser;
	import WebGL = Laya.WebGL;

	export class Text_HTML {
		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			this.setup();
		}

		private setup(): void {
			this.createParagraph();	// 代码创建
			this.showExternalHTML(); // 使用外部定义的html
		}

		private createParagraph(): void {
			var p: HTMLDivElement = new HTMLDivElement();
			Laya.stage.addChild(p);

			p.style.font = "Impact";
			p.style.fontSize = 30;

			var html: string = "<span color='#e3d26a'>使用</span>";
			html += "<span style='color:#FFFFFF;font-weight:bold'>HTMLDivElement</span>";
			html += "<span color='#6ad2e3'>创建的</span><br/>";
			html += "<span color='#d26ae3'>HTML文本</span>";

			p.innerHTML = html;
		}

		private showExternalHTML(): void {
			var p: HTMLIframeElement = new HTMLIframeElement();
			Laya.stage.addChild(p);
			p.href = "../../res/html/test.html";
			p.y = 200;
		}
	}
}
new laya.Text_HTML();