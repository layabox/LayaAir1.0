var HttpRequest = laya.net.HttpRequest;
var Text = laya.display.Text;
var Stage = laya.display.Stage;
var Event = laya.events.Event;

Laya.init(550, 400);
Laya.stage.scaleMode = Stage.SCALE_SHOWALL;

var hr = new HttpRequest();
hr.once(Event.PROGRESS, this, onHttpRequestProgress);
hr.once(Event.COMPLETE, this, onHttpRequestComplete);
hr.once(Event.ERROR, this, onHttpRequestError);
hr.send('http://xkxz.zhonghao.huo.inner.layabox.com/api/getData?name=myname&psword=xxx', null, 'get', 'text');

var info = new Text();
info.fontSize = 20;
info.align = 'center';
info.size(550 , 30);
info.y = 180;
info.color = "#FFFFFF";
info.text = "等待响应...";
Laya.stage.addChild(info);

function onHttpRequestError(e)
{
	console.log(e);
}

function onHttpRequestProgress(e)
{
	console.log(e)
}

function onHttpRequestComplete(e)
{
	info.text = "收到数据：" + hr.data;
}