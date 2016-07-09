(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	var stageWidth = 800;
	var stageHeight = 600;

	var Matter = Browser.window.Matter;
	var LayaRender = Browser.window.LayaRender;

	var mouseConstraint;
	var engine;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(stageWidth, stageHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		initMatter();
		initWorld();

		Matter.Engine.run(engine);
		Laya.stage.on("resize", this, onResize);
	}

	function initMatter()
	{
		var gameWorld = new Sprite();
		Laya.stage.addChild(gameWorld);

		// 初始化物理引擎
		engine = Matter.Engine.create(
		{
			enableSleeping: true,
			render:
			{
				container: gameWorld,
				controller: LayaRender,
				options:
				{
					width: stageWidth,
					height: stageHeight,
					wireframes: false
				}
			}
		});

		mouseConstraint = Matter.MouseConstraint.create(engine);
		Matter.World.add(engine.world, mouseConstraint);
		engine.render.mouse = mouseConstraint.mouse;
	}

	function initWorld()
	{
		var cradle = Matter.Composites.newtonsCradle(280, 100, 5, 30, 200);
		Matter.World.add(engine.world, cradle);
		Matter.Body.translate(cradle.bodies[0],
		{
			x: -180,
			y: -100
		});

		cradle = Matter.Composites.newtonsCradle(280, 380, 7, 20, 140);
		Matter.World.add(engine.world, cradle);
		Matter.Body.translate(cradle.bodies[0],
		{
			x: -140,
			y: -100
		});
	}

	function onResize()
	{
		// 设置鼠标的坐标缩放
		Matter.Mouse.setScale(mouseConstraint.mouse,
		{
			x: 1 / (Laya.stage.clientScaleX * Laya.stage._canvasTransform.a),
			y: 1 / (Laya.stage.clientScaleY * Laya.stage._canvasTransform.d)
		});
	}
})();