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
	Laya.stage.alignV = Laya.Stage.ALIGN_MIDDLE;
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

	mouseConstraint = MouseConstraint.create(engine);
	World.add(engine.world, mouseConstraint);
	engine.render.mouse = mouseConstraint.mouse;

	// 创建游戏场景
	var group = Body.nextGroup(true),
		particleOptions = {
			friction: 0.00001,
			collisionFilter:
			{
				group: group
			},
			render:
			{
				visible: false
			}
		},
		cloth = Composites.softBody(200, 200, 20, 12, 5, 5, false, 8, particleOptions);

	for (var i = 0; i < 20; i++)
	{
		cloth.bodies[i].isStatic = true;
	}

	World.add(engine.world, [
		cloth,
		Bodies.circle(300, 500, 80,
		{
			isStatic: true
		}),
		Bodies.rectangle(500, 480, 80, 80,
		{
			isStatic: true
		})
	]);
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