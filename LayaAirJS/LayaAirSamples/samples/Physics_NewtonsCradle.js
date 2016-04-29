(function()
{
	Laya.init(800, 600, Laya.WebGL);
	Laya.Stat.show();

	var gameWorld = new Laya.Sprite();
	Laya.stage.addChild(gameWorld);

	// matter.js引擎成员
	var World = Matter.World,
		Engine = Matter.Engine,
		MouseConstraint = Matter.MouseConstraint,
		Bodies = Matter.Bodies,
		Composites = Matter.Composites,
		Constraint = Matter.Constraint;

	// 设置舞台
	Laya.stage.alignH = Laya.Stage.ALIGN_CENTER;
	Laya.stage.alignV = Laya.stage.ALIGN_MIDDLE;
	Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;

	// 初始化物理引擎
	var engine, mouseConstraint;
	engine = Engine.create(
	{
		enableSleeping: true,
		render:
		{
			container: gameWorld,
			controller: LayaRender,
			options:
			{
				width: 800,
				height: 600,
				wireframes: false
			}
		}
	});

	mouseConstraint = MouseConstraint.create(engine,
	{
		constraint:
		{
			angularStiffness: 0.1,
			stiffness: 2
		}
	});
	World.add(engine.world, mouseConstraint);
	engine.render.mouse = mouseConstraint.mouse;

	// 创建游戏场景
	var cradle = Composites.newtonsCradle(280, 100, 5, 30, 200);
	World.add(engine.world, cradle);
	Body.translate(cradle.bodies[0],
	{
		x: -180,
		y: -100
	});

	cradle = Composites.newtonsCradle(280, 380, 7, 20, 140);
	World.add(engine.world, cradle);
	Body.translate(cradle.bodies[0],
	{
		x: -140,
		y: -100
	});
	Engine.run(engine);

	Laya.stage.on("resize", this, onResize);

	function onResize()
	{
		// 设置鼠标的坐标缩放
		Matter.Mouse.setScale(engine.render.mouse,
		{
			x: 1 / (Laya.stage.clientScaleX),
			y: 1 / (Laya.stage.clientScaleY)
		});
	}
})();