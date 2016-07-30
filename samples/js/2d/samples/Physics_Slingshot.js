(function()
{
	var Sprite  = Laya.Sprite;
	var Stage   = Laya.Stage;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;

	const stageWidth = 800;
	const stageHeight = 600;

	var Matter = Browser.window.Matter;
	var LayaRender = Browser.window.LayaRender;

	var mouseConstraint;
	var engine;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(stageWidth, stageHeight, WebGL);
		Laya.Stat.show()

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
					width: 800,
					height: 600,
					background: '../../res/physics/img/background.png',
					hasBounds: true
				}
			}
		});

		mouseConstraint = Matter.MouseConstraint.create(engine,
		{
			constraint:
			{
				angularStiffness: 0.1,
				stiffness: 2
			}
		});
		Matter.World.add(engine.world, mouseConstraint);
		engine.render.mouse = mouseConstraint.mouse;
	}

	function initWorld()
	{
		var ground = Matter.Bodies.rectangle(395, 600, 815, 50,
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
						texture: '../../res/physics/img/rock.png',
						xOffset: 23.5,
						yOffset: 23.5
					}
				}
			},
			rock = Matter.Bodies.polygon(170, 450, 8, 20, rockOptions),
			anchor = {
				x: 170,
				y: 450
			},
			elastic = Matter.Constraint.create(
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

		var pyramid = Matter.Composites.pyramid(500, 300, 9, 10, 0, 0, function(x, y, column)
		{
			var texture = column % 2 === 0 ? '../../res/physics/img/block.png' : '../../res/physics/img/block-2.png';
			return Matter.Bodies.rectangle(x, y, 25, 40,
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

		var ground2 = Matter.Bodies.rectangle(610, 250, 200, 20,
		{
			isStatic: true,
			render:
			{
				fillStyle: '#edc51e',
				strokeStyle: '#b5a91c'
			}
		});

		var pyramid2 = Matter.Composites.pyramid(550, 0, 5, 10, 0, 0, function(x, y, column)
		{
			var texture = column % 2 === 0 ? '../../res/physics/img/block.png' : '../../res/physics/img/block-2.png';
			return Matter.Bodies.rectangle(x, y, 25, 40,
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

		Matter.World.add(engine.world, [mouseConstraint, ground, pyramid, ground2, pyramid2, rock, elastic]);

		Matter.Events.on(engine, 'afterUpdate', function()
		{
			if (mouseConstraint.mouse.button === -1 && (rock.position.x > 190 || rock.position.y < 430))
			{
				rock = Matter.Bodies.polygon(170, 450, 7, 20, rockOptions);
				Matter.World.add(engine.world, rock);
				elastic.bodyB = rock;
			}
		});

		var renderOptions = engine.render.options;
		renderOptions.wireframes = false;
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