(function()
{
	Laya.init(800, 600, Laya.WebGL);

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
				background: 'res/physics/img/background.png',
				hasBounds: true
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
	engine.render.mouse = mouseConstraint.mouse;

	// 创建游戏场景
	var ground = Bodies.rectangle(395, 600, 815, 50,
		{
			isStatic: true,
			render:
			{
				visible: false
			}
		}),
		rockOptions = {
			density: 0.004,
			render:
			{
				sprite:
				{
					texture: 'res/physics/img/rock.png',
					xOffset: 23.5,
					yOffset: 23.5
				}
			}
		},
		rock = Bodies.polygon(170, 450, 8, 20, rockOptions),
		anchor = {
			x: 170,
			y: 450
		},
		elastic = Constraint.create(
		{
			pointA: anchor,
			bodyB: rock,
			stiffness: 0.05,
			render:
			{
				lineWidth: 5,
				strokeStyle: '#dfa417'
			}
		});

	var pyramid = Composites.pyramid(500, 300, 9, 10, 0, 0, function(x, y, column)
	{
		var texture = column % 2 === 0 ? 'res/physics/img/block.png' : 'res/physics/img/block-2.png';
		return Bodies.rectangle(x, y, 25, 40,
		{
			render:
			{
				sprite:
				{
					texture: texture,
					xOffset: 20.5,
					yOffset: 28
				}
			}
		});
	});

	var ground2 = Bodies.rectangle(610, 250, 200, 20,
	{
		isStatic: true,
		render:
		{
			fillStyle: '#edc51e',
			strokeStyle: '#b5a91c'
		}
	});

	var pyramid2 = Composites.pyramid(550, 0, 5, 10, 0, 0, function(x, y, column)
	{
		var texture = column % 2 === 0 ? 'res/physics/img/block.png' : 'res/physics/img/block-2.png';
		return Bodies.rectangle(x, y, 25, 40,
		{
			render:
			{
				sprite:
				{
					texture: texture,
					xOffset: 20.5,
					yOffset: 28
				}
			}
		});
	});

	World.add(engine.world, [mouseConstraint, ground, pyramid, ground2, pyramid2, rock, elastic]);

	Events.on(engine, 'afterUpdate', function()
	{
		if (mouseConstraint.mouse.button === -1 && (rock.position.x > 190 || rock.position.y < 430))
		{
			rock = Bodies.polygon(170, 450, 7, 20, rockOptions);
			World.add(engine.world, rock);
			elastic.bodyB = rock;
		}
	});

	var renderOptions = engine.render.options;
	renderOptions.wireframes = false;
	Engine.run(engine);

	Laya.stage.on("resize", this, onResize);

	function onResize()
	{
		// 设置鼠标的坐标缩放
		Matter.Mouse.setScale(engine.render.mouse,
		{
			x: 1 / (Laya.stage.clientScaleX * Laya.stage._canvasTransform.a),
			y: 1 / (Laya.stage.clientScaleY * Laya.stage._canvasTransform.d)
		});
	}
})();