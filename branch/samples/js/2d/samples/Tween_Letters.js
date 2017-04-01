(function()
{
	var Stage   = Laya.Stage;
	var Text    = Laya.Text;
	var Browser = Laya.Browser;
	var Ease    = Laya.Ease;
	var Tween   = Laya.Tween;
	var WebGL   = Laya.WebGL;

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
		var w = 400;
		var offset = Laya.stage.width - w >> 1;
		var endY = Laya.stage.height / 2 - 50;
		var demoString = "LayaBox";

		for (var i = 0, len = demoString.length; i < len; ++i)
		{
			var letterText = createLetter(demoString.charAt(i));
			letterText.x = w / len * i + offset;

			Tween.to(letterText,
			{
				y: endY
			}, 1000, Ease.elasticOut, null, i * 1000);
		}
	}

	function createLetter(char)
	{
		var letter = new Text();
		letter.text = char;
		letter.color = "#FFFFFF";
		letter.font = "Impact";
		letter.fontSize = 110;
		Laya.stage.addChild(letter);

		return letter;
	}
})();