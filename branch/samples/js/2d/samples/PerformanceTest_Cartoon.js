(function()
{
	var Sprite  = Laya.Sprite;
	var Loader  = Laya.Loader;
	var Browser = Laya.Browser;
	var Handler = Laya.Handler;
	var Stat    = Laya.Stat;
	var WebGL   = Laya.WebGL;

	var colAmount = 100;
	var extraSpace = 50;
	var moveSpeed = 2;
	var rotateSpeed = 2;

	var characterGroup;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.width, Browser.height, WebGL);
		Laya.stage.bgColor = "#232628";
		
		Stat.show();
		
		Laya.loader.load("../../res/cartoonCharacters/cartoonCharactors.json", Handler.create(this, createCharacters), null, Loader.ATLAS);
	})();

	function createCharacters()
	{
		characterGroup = [];

		for(var i = 0; i < colAmount; ++i)
		{
			var tx = (Laya.stage.width + extraSpace * 2) / colAmount * i - extraSpace;
			var tr = 360 / colAmount * i;
			var startY = (Laya.stage.height - 500) / 2;

			createCharacter("cartoonCharactors/1.png", 46, 50, tr).pos(tx, 50  + startY);
			createCharacter("cartoonCharactors/2.png", 34, 50, tr).pos(tx, 150 + startY);
			createCharacter("cartoonCharactors/3.png", 42, 50, tr).pos(tx, 250 + startY);
			createCharacter("cartoonCharactors/4.png", 48, 50, tr).pos(tx, 350 + startY);
			createCharacter("cartoonCharactors/5.png", 36, 50, tr).pos(tx, 450 + startY);
		}

		Laya.timer.frameLoop(1, this, animate);
	}

	function createCharacter(skin, pivotX, pivotY, rotation)
	{
		var charactor = new Sprite();
		charactor.loadImage(skin);
		charactor.rotation = rotation;
		charactor.pivot(pivotX, pivotY);
		Laya.stage.addChild(charactor);
		characterGroup.push(charactor);

		return charactor;
	}

	function animate()
	{
		for (var i = characterGroup.length - 1; i >= 0; --i)
		{
			animateCharactor(characterGroup[i]);
		}
	}

	function animateCharactor(charactor)
	{
		charactor.x += moveSpeed;
		charactor.rotation += rotateSpeed;

		if (charactor.x > Laya.stage.width + extraSpace)
		{
			charactor.x = -extraSpace;
		}
	}
})();