package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.utils.Browser;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class Physics_Avalanche
	{
		private const stageWidth:int = 800;
		private const stageHeight:int = 600;

		private var Matter:Object = Browser.window.Matter;
		private var LayaRender:Object = Browser.window.LayaRender;
		
		private var mouseConstraint:*;
		private var engine:*;
		
		public function Physics_Avalanche()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(stageWidth, stageHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Stat.show();

			setup();
		}

		private function setup():void
		{
			initMatter();
			initWorld();
			
			Matter.Engine.run(engine);
			Laya.stage.on("resize", this, onResize);
		}
		
		private function initMatter():void 
		{
			var gameWorld:Sprite = new Sprite();
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
							wireframes: true
						}
					}
				});
			
			mouseConstraint = Matter.MouseConstraint.create(engine);
			Matter.World.add(engine.world, mouseConstraint);
			engine.render.mouse = mouseConstraint.mouse;
		}
		private function initWorld():void 
		{
			var stack = Matter.Composites.stack(20, 20, 20, 5, 0, 0, function(x, y) {
				return Matter.Bodies.circle(x, y, Matter.Common.random(10, 20), { friction: 0.00001, restitution: 0.5, density: 0.001 });
			});
        
			Matter.World.add(engine.world, stack);
			
			Matter.World.add(engine.world, [
				Matter.Bodies.rectangle(200, 150, 700, 20, { isStatic: true, angle: Math.PI * 0.06 }),
				Matter.Bodies.rectangle(500, 350, 700, 20, { isStatic: true, angle: -Math.PI * 0.06 }),
				Matter.Bodies.rectangle(340, 580, 700, 20, { isStatic: true, angle: Math.PI * 0.04 })
			]);
			
			var offset:int = 5;
			Matter.World.add(engine.world, [
				Matter.Bodies.rectangle(400, -offset, 800.5 + 2 * offset, 50.5, { isStatic: true }),
				Matter.Bodies.rectangle(400, 600 + offset, 800.5 + 2 * offset, 50.5, { isStatic: true }),
				Matter.Bodies.rectangle(800 + offset, 300, 50.5, 600.5 + 2 * offset, { isStatic: true }),
				Matter.Bodies.rectangle(-offset, 300, 50.5, 600.5 + 2 * offset, { isStatic: true })
			]);
		}
		
		private function onResize():void
		{
			// 设置鼠标的坐标缩放
			Matter.Mouse.setScale(
				mouseConstraint.mouse, 
				{
					x: 1 / (Laya.stage.clientScaleX * Laya.stage._canvasTransform.a), 
					y: 1 / (Laya.stage.clientScaleY * Laya.stage._canvasTransform.d)
				});
		}
	}
}