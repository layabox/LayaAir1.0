package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class Physics_Cloth
	{
		private const stageWidth:int = 800;
		private const stageHeight:int = 600;

		private var Matter:Object = Browser.window.Matter;
		private var LayaRender:Object = Browser.window.LayaRender;
		
		private var mouseConstraint:*;
		private var engine:*;
		
		public function Physics_Cloth()
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
			
			Laya.stage.on("resize", this, onResize);
		}
		
		private function initMatter():void 
		{
			var gameWorld:Sprite = new Sprite();
			Laya.stage.addChild(gameWorld);
			
			// 初始化物理引擎
			engine = Matter.Engine.create({enableSleeping: true});
			Matter.Engine.run(engine);
			
			var render = LayaRender.create({engine: engine, container: gameWorld, width: stageWidth, height: stageHeight, options: {wireframes: false}});
			LayaRender.run(render);
			
			mouseConstraint = Matter.MouseConstraint.create(engine, {element: Render.canvas});
			Matter.World.add(engine.world, mouseConstraint);
			render.mouse = mouseConstraint.mouse;
		}
		private function initWorld():void 
		{
			// 创建游戏场景
			var group:* = Matter.Body.nextGroup(true);
			var particleOptions:* = {friction: 0.00001, collisionFilter: {group: group}, render: {visible: false}};
			var cloth:* = Matter.Composites.softBody(200, 200, 20, 12, 5, 5, false, 8, particleOptions);
			
			for (var i:int = 0; i < 20; i++)
			{
				cloth.bodies[i].isStatic = true;
			}
			
			Matter.World.add(engine.world, 
				[
					cloth, 
					Matter.Bodies.circle(300, 500, 80, {isStatic: true}), 
					Matter.Bodies.rectangle(500, 480, 80, 80, {isStatic: true})
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