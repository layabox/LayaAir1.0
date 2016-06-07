(function()
{
	var Stage   = laya.display.Stage;
	var Text    = laya.display.Text;
	var Event   = laya.events.Event;
	var Browser = laya.utils.Browser;
	var WebGL   = laya.webgl.WebGL;

	var logger, keyDownList;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";


		setup();
	})();

	function setup()
	{
		listenKeyboard();
		createLogger();

		Laya.timer.frameLoop(1, this, keyboardInspector);
	}

	function listenKeyboard()
	{
		keyDownList = [];

		//添加键盘按下事件,一直按着某按键则会不断触发
		Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
		//添加键盘抬起事件
		Laya.stage.on(Event.KEY_UP, this, onKeyUp);
	}

	/**键盘按下处理*/
	function onKeyDown(e)
	{
		keyDownList[e["keyCode"]] = true;
	}

	/**键盘抬起处理*/
	function onKeyUp(e)
	{
		delete keyDownList[e["keyCode"]];
	}

	function keyboardInspector()
	{
		var numKeyDown = keyDownList.length;

		var newText = '[ ';
		for (var i = 0; i < numKeyDown; i++)
		{
			if (keyDownList[i])
			{
				newText += i + " ";
			}
		}
		newText += ']';

		logger.changeText(newText);
	}

	/**添加提示文本*/
	function createLogger()
	{
		logger = new Text();

		logger.size(Laya.stage.width, Laya.stage.height);
		logger.fontSize = 30;
		logger.font = "SimHei";
		logger.wordWrap = true;
		logger.color = "#FFFFFF";
		logger.align = 'center';
		logger.valign = 'middle';

		Laya.stage.addChild(logger);
	}
})();