(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Browser = Laya.Browser;
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
		var terminalX = 200;

		var characterA = createCharacter("../../res/cartoonCharacters/1.png");
		characterA.pivot(46.5, 50);
		characterA.y = 100;

		var characterB = createCharacter("../../res/cartoonCharacters/2.png");
		characterB.pivot(34, 50);
		characterB.y = 250;

		Laya.stage.graphics.drawLine(terminalX, 0, terminalX, Laya.stage.height, "#FFFFFF");

		// characterA使用Tween.to缓动
		Tween.to(characterA,
		{
			x: terminalX
		}, 1000);
		// characterB使用Tween.from缓动
		characterB.x = terminalX;
		Tween.from(characterB,
		{
			x: 0
		}, 1000);
	}

	function createCharacter(skin)
	{
		var character = new Sprite();
		character.loadImage(skin);
		Laya.stage.addChild(character);

		return character;
	}
})();