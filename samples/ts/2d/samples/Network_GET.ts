module laya {
	import Stage = Laya.Stage;
	import Text = Laya.Text;
	import Event = Laya.Event;
	import HttpRequest = Laya.HttpRequest;
	import Browser = Laya.Browser;
	import WebGL = Laya.WebGL;

	export class Network_GET {
		private hr: HttpRequest;
		private logger: Text;

		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			this.connect();
			this.showLogger();
		}

		private connect(): void {
			this.hr = new HttpRequest();
			this.hr.once(Event.PROGRESS, this, this.onHttpRequestProgress);
			this.hr.once(Event.COMPLETE, this, this.onHttpRequestComplete);
			this.hr.once(Event.ERROR, this, this.onHttpRequestError);
			this.hr.send('http://xkxz.zhonghao.huo.inner.layabox.com/api/getData?name=myname&psword=xxx', null, 'get', 'text');
		}

		private showLogger(): void {
			this.logger = new Text();

			this.logger.fontSize = 30;
			this.logger.color = "#FFFFFF";
			this.logger.align = 'center';
			this.logger.valign = 'middle';

			this.logger.size(Laya.stage.width, Laya.stage.height);
			this.logger.text = "等待响应...\n";
			Laya.stage.addChild(this.logger);
		}

		private onHttpRequestError(e: any): void {
			console.log(e);
		}

		private onHttpRequestProgress(e: any): void {
			console.log(e)
		}

		private onHttpRequestComplete(e: any): void {
			this.logger.text += "收到数据：" + this.hr.data;
		}
	}
}
new laya.Network_GET();