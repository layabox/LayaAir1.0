(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Event   = Laya.Event;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	var button1, button2;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		var vGap = 100;

		button1 = createButton("点我3秒之后 alpha - 0.5");
		button1.x = (Laya.stage.width - button1.width) / 2;
		button1.y = (Laya.stage.height - button1.height - vGap) / 2;
		Laya.stage.addChild(button1);
		button1.on(Event.CLICK, this, onDecreaseAlpha1);

		button2 = createButton("点我60帧之后 alpha - 0.5");
		button2.pos(button1.x, button1.y + vGap);
		Laya.stage.addChild(button2);
		button2.on(Event.CLICK, this, onDecreaseAlpha2);
	}

	function createButton(label)
	{
		var w = 300,
			h = 60;

		var button = new Sprite();
		button.graphics.drawRect(0, 0, w, h, "#FF7F50");
		button.size(w, h);
		button.graphics.fillText(label, w / 2, 17, "20px simHei", "#ffffff", "center");
		return button;
	}

	function onDecreaseAlpha1(e)
	{
		//移除鼠标单击事件
		button1.off(Event.CLICK, this, onDecreaseAlpha1);
		//定时执行一次(间隔时间)
		Laya.timer.once(3000, this, onComplete1);
	}

	function onDecreaseAlpha2(e)
	{
		//移除鼠标单击事件
		button2.off(Event.CLICK, this, onDecreaseAlpha2);
		//定时执行一次(基于帧率)
		Laya.timer.frameOnce(60, this, onComplete2);
	}

	function onComplete1()
	{
		//spBtn1的透明度减少0.5
		button1.alpha -= 0.5;
	}

	function onComplete2()
	{
		//spBtn2的透明度减少0.5
		button2.alpha -= 0.5;
	}
})();