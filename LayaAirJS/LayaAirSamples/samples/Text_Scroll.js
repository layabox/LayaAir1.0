(function() {
	var Text = Laya.Text;

	var txt;
	var prevX;
	var prevY;

	Laya.init(550, 400);
	Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

	txt = new Text();
	txt.overflow = Text.SCROLL;

	txt.text =
		"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
		"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
		"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
		"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
		"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
		"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！";


	txt.pos(175, 150);
	txt.size(200, 100);

	txt.borderColor = "#FFFF00";

	txt.fontSize = 20;
	txt.color = "#ffffff";

	Laya.stage.addChild(txt);

	txt.on(Laya.Event.MOUSE_DOWN, this, startScrollText);

	/* 开始滚动文本 */
	function startScrollText(e) {
		prevX = txt.mouseX;
		prevY = txt.mouseY;

		Laya.stage.on(Laya.Event.MOUSE_MOVE, this, scrollText);
		Laya.stage.on(Laya.Event.MOUSE_UP, this, finishScrollText);
	}

	/* 停止滚动文本 */
	function finishScrollText(e) {
		Laya.stage.off(Laya.Event.MOUSE_MOVE, this, scrollText);
		Laya.stage.off(Laya.Event.MOUSE_UP, this, finishScrollText);
	}

	/* 鼠标滚动文本 */
	function scrollText(e) {
		var nowX = txt.mouseX;
		var nowY = txt.mouseY;

		txt.scrollX += prevX - nowX;
		txt.scrollY += prevY - nowY;

		prevX = nowX;
		prevY = nowY;
	}
})();