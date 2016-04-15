/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import HTMLDivElement = laya.html.dom.HTMLDivElement;
	import HTMLIframeElement = laya.html.dom.HTMLIframeElement;
	import Handler = laya.utils.Handler;
	import WebGL = laya.webgl.WebGL;

	export class Text_HTML {
		constructor() {
			Laya.init(550, 400, WebGL);

			Laya.loader.load("res/html/test.html", Handler.create(this, this.onAssetLoaded));
		}

		private onAssetLoaded(): void {
			this.createParagraph();
			this.showExternalHTML();
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
			p.href = "res/html/test.html";
			p.y = 100;
		}
	}
}
new laya.Text_HTML();
