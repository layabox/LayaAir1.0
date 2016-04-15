/// <reference path="../../libs/LayaAir.d.ts" />
import Stage = laya.display.Stage;
import HttpRequest = laya.net.HttpRequest;

class Network_GET
{
	private hr:HttpRequest;
	private info: laya.display.Text;

	constructor()
	{
		Laya.init(550, 400);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;

		this.hr = new HttpRequest();
		this.hr.once(laya.events.Event.PROGRESS, this, this.onHttpRequestProgress);
		this.hr.once(laya.events.Event.COMPLETE, this, this.onHttpRequestComplete);
		this.hr.once(laya.events.Event.ERROR, this, this.onHttpRequestError);
		this.hr.send('http://xkxz.zhonghao.huo.inner.layabox.com/api/getData?name=myname&psword=xxx', null, 'get', 'text');

		this.info = new laya.display.Text();
		this.info.fontSize = 20;
		this.info.align = 'center';
		this.info.size(550 , 30);
		this.info.y = 180;
		this.info.color = "#FFFFFF";
		this.info.text = "等待响应...";
		Laya.stage.addChild(this.info);
	}

	private onHttpRequestError(e:Object):void
	{
		console.log(e);
	}

	private onHttpRequestProgress(e:Object):void
	{
		console.log(e)
	}

	private onHttpRequestComplete(e:Object):void
	{
		this.info.text = "收到数据：" + this.hr.data;
	}
}
new Network_GET();