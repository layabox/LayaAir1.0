(function()
{
	var Stage   = Laya.Stage;
	var Text    = Laya.Text;
	var Event   = Laya.Event;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	var txt;
	var prevX = 0;
	var prevY = 0;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		createText();
	})();

	function createText()
	{
		txt = new Text();
		txt.overflow = Text.SCROLL;
		txt.text =
			"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
			"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
			"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
			"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
			"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
			"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！";

		txt.size(200, 100);
		txt.x = Laya.stage.width - txt.width >> 1;
		txt.y = Laya.stage.height - txt.height >> 1;

		txt.borderColor = "#FFFF00";

		txt.fontSize = 20;
		txt.color = "#ffffff";

		Laya.stage.addChild(txt);

		txt.on(Event.MOUSE_DOWN, this, startScrollText);
	}

	/* 开始滚动文本 */
	function startScrollText(e)
	{
		prevX = txt.mouseX;
		prevY = txt.mouseY;

		Laya.stage.on(Event.MOUSE_MOVE, this, scrollText);
		Laya.stage.on(Event.MOUSE_UP, this, finishScrollText);
	}

	/* 停止滚动文本 */
	function finishScrollText(e)
	{
		Laya.stage.off(Event.MOUSE_MOVE, this, scrollText);
		Laya.stage.off(Event.MOUSE_UP, this, finishScrollText);
	}

	/* 鼠标滚动文本 */
	function scrollText(e)
	{
		var nowX = txt.mouseX;
		var nowY = txt.mouseY;

		txt.scrollX += prevX - nowX;
		txt.scrollY += prevY - nowY;

		prevX = nowX;
		prevY = nowY;
	}
})();