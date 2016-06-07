(function()
{
	var Stage       = laya.display.Stage;
	var Text        = laya.display.Text;
	var Event       = laya.events.Event;
	var HttpRequest = laya.net.HttpRequest;
	var Browser     = laya.utils.Browser;
	var WebGL       = laya.webgl.WebGL;

	var hr, logger;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		connect();
		showLogger();
	})();

	function connect()
	{
		hr = new HttpRequest();
		hr.once(Event.PROGRESS, this, onHttpRequestProgress);
		hr.once(Event.COMPLETE, this, onHttpRequestComplete);
		hr.once(Event.ERROR, this, onHttpRequestError);
		hr.send('http://xkxz.zhonghao.huo.inner.layabox.com/api/getData?name=myname&psword=xxx', null, 'get', 'text');
	}

	function showLogger()
	{
		logger = new Text();

		logger.fontSize = 30;
		logger.color = "#FFFFFF";
		logger.align = 'center';
		logger.valign = 'middle';

		logger.size(Laya.stage.width, Laya.stage.height);
		logger.text = "等待响应...\n";
		Laya.stage.addChild(logger);
	}

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
		logger.text += "收到数据：" + hr.data;
	}
})();