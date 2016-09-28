var Matter: any;
var LayaRender: any;

module laya
{
	import Sprite = Laya.Sprite;
	import Stage = Laya.Stage;
	import Browser = Laya.Browser;
	import Stat = Laya.Stat;
	import WebGL = Laya.WebGL;
	
	export class Physics_Cloth
	{
		private stageWidth: number = 800;
		private stageHeight: number = 600;

		private Matter:Object = Browser.window.Matter;
		private LayaRender:Object = Browser.window.LayaRender;

		private mouseConstraint:any;
		private engine:any;
		
		constructor()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(this.stageWidth, this.stageHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Stat.show();

			this.setup();
		}

		private setup():void
		{
			this.initMatter();
			this.initWorld();

			Matter.Engine.run(this.engine);
			Laya.stage.on("resize", this, this.onResize);
		}

		private initMatter():void 
		{
			var gameWorld:Sprite = new Sprite();
			Laya.stage.addChild(gameWorld);
			
			
			// 初始化物理引擎

			this.engine = Matter.Engine.create(
				{
					enableSleeping: true, 
					render: 
					{
						container: gameWorld, 
						controller: LayaRender, 
						options: 
						{
							width: this.stageWidth, 
							height: this.stageHeight, 
							wireframes: false
						}
					}
				});
			

			this.mouseConstraint = Matter.MouseConstraint.create(this.engine);

			Matter.World.add(this.engine.world, this.mouseConstraint);
			this.engine.render.mouse = this.mouseConstraint.mouse;
		}
		private initWorld():void 
		{
			// 创建游戏场景

			var group: any = Matter.Body.nextGroup(true);
			var particleOptions:any = {friction: 0.00001, collisionFilter: {group: group}, render: {visible: false}};

			var cloth: any = Matter.Composites.softBody(200, 200, 20, 12, 5, 5, false, 8, particleOptions);
			
			for (var i:number = 0; i < 20; i++)
			{
				cloth.bodies[i].isStatic = true;
			}


			Matter.World.add(this.engine.world, 
				[
					cloth,

					Matter.Bodies.circle(300, 500, 80, { isStatic: true }),

					Matter.Bodies.rectangle(500, 480, 80, 80, { isStatic: true })
				]);
		}
		
		private onResize()
		{
			// 设置鼠标的坐标缩放
			Matter.Mouse.setScale(
				this.mouseConstraint.mouse, 
				{
					x: 1 / (Laya.stage.clientScaleX * Laya.stage._canvasTransform.a), 
					y: 1 / (Laya.stage.clientScaleY * Laya.stage._canvasTransform.d)
				});
		}
	}
}
new laya.Physics_Cloth();