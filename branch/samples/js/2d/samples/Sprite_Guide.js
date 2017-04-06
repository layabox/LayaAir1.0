(function()
{
	var Sprite = Laya.Sprite;
	var Stage = Laya.Stage;
	var HitArea = Laya.HitArea;
	var WebGL = Laya.WebGL;

	var red;
	var guideContainer;
	var tipContainer;

	var guideSteps =
		[
		{
			x: 151,
			y: 575,
			radius: 150,
			tip: "../../res/guide/help6.png",
			tipx: 200,
			tipy: 250
		},
		{
			x: 883,
			y: 620,
			radius: 100,
			tip: "../../res/guide/help4.png",
			tipx: 730,
			tipy: 380
		},
		{
			x: 1128,
			y: 583,
			radius: 110,
			tip: "../../res/guide/help3.png",
			tipx: 900,
			tipy: 300
		}];
	var guideStep = 0;
	var hitArea;
	var interactionArea;

	(function()
	{
		Laya.init(1285, 727);
		Laya.stage.alignH = Stage.ALIGN_CENTER;
		Laya.stage.alignV = Stage.ALIGN_MIDDLE;

		//绘制一个蓝色方块，不被抠图
		var gameContainer = new Sprite();
		gameContainer.loadImage("../../res/guide/crazy_snowball.png");
		Laya.stage.addChild(gameContainer);

		// 引导所在容器
		guideContainer = new Sprite();
		// 设置容器为画布缓存
		guideContainer.cacheAs = "bitmap";
		Laya.stage.addChild(guideContainer);
		gameContainer.on("click", this, nextStep);

		//绘制遮罩区，含透明度，可见游戏背景
		var maskArea = new Sprite();
		maskArea.alpha = 0.5;
		maskArea.graphics.drawRect(0, 0, Laya.stage.width, Laya.stage.height, "#000000");
		guideContainer.addChild(maskArea);

		//绘制一个圆形区域，利用叠加模式，从遮罩区域抠出可交互区
		interactionArea = new Sprite();
		//设置叠加模式
		interactionArea.blendMode = "destination-out";
		guideContainer.addChild(interactionArea);

		hitArea = new HitArea();
		hitArea.hit.drawRect(0, 0, Laya.stage.width, Laya.stage.height, "#000000");

		guideContainer.hitArea = hitArea;
		guideContainer.mouseEnabled = true;

		tipContainer = new Sprite();
		Laya.stage.addChild(tipContainer);

		nextStep();
	})();

	function nextStep()
	{
		if (guideStep == guideSteps.length)
		{
			Laya.stage.removeChild(guideContainer);
			Laya.stage.removeChild(tipContainer);
		}
		else
		{
			var step = guideSteps[guideStep++];

			hitArea.unHit.clear();
			hitArea.unHit.drawCircle(step.x, step.y, step.radius, "#000000");

			interactionArea.graphics.clear();
			interactionArea.graphics.drawCircle(step.x, step.y, step.radius, "#000000");

			tipContainer.graphics.clear();
			tipContainer.loadImage(step.tip);
			tipContainer.pos(step.tipx, step.tipy);
		}
	}
})();