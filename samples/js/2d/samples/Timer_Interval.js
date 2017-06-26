(function()
{
	var Stage   = Laya.Stage;
	var Text    = Laya.Text;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	var rotateTimeBasedText, rotateFrameRateBasedText;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		var vGap = 200;

		rotateTimeBasedText = createText("基于时间旋转", Laya.stage.width / 2, (Laya.stage.height - vGap) / 2);
		rotateFrameRateBasedText = createText("基于帧频旋转", rotateTimeBasedText.x, rotateTimeBasedText.y + vGap);

		Laya.timer.loop(200, this, animateTimeBased);
		Laya.timer.frameLoop(2, this, animateFrameRateBased);
	}

	function createText(text, x, y)
	{
		var t = new Text();
		t.text = text;
		t.fontSize = 30;
		t.color = "white";	
		t.bold = true;
		t.pivot(t.width / 2, t.height / 2);
		t.pos(x, y);
		Laya.stage.addChild(t);

		return t;
	}

	function animateTimeBased()
	{
		rotateTimeBasedText.rotation += 1;
	}

	function animateFrameRateBased()
	{
		rotateFrameRateBasedText.rotation += 1;
	}
})();