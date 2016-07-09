/// <reference path="../../../bin/ts/LayaAir.d.ts" />
module laya {
	import Sprite = laya.display.Sprite;
	import Stage = laya.display.Stage;
	import Browser = laya.utils.Browser;
	import WebGL = laya.webgl.WebGL;
	export class Physics_NewtonsCradle {
		private stageWidth: number = 800;
		private stageHeight: number = 600;

		private Matter: any = Browser.window.Matter;
		private LayaRender: any = Browser.window.LayaRender;

		private mouseConstraint: any;
		private engine: any;

		constructor() {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(this.stageWidth, this.stageHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			this.setup();
		}

		private setup(): void {
			this.initMatter();
			this.initWorld();

			this.Matter.Engine.run(this.engine);
			Laya.stage.on("resize", this, this.onResize);
		}

		private initMatter(): void {
			var gameWorld: Sprite = new Sprite();
			Laya.stage.addChild(gameWorld);


			// 初始化物理引擎
			this.engine = this.Matter.Engine.create(
				{
					enableSleeping: true,
					render:
					{
						container: gameWorld,
						controller: this.LayaRender,
						options:
						{
							width: this.stageWidth,
							height: this.stageHeight,
							wireframes: false
						}
					}
				});

			this.mouseConstraint = this.Matter.MouseConstraint.create(this.engine);
			this.Matter.World.add(this.engine.world, this.mouseConstraint);
			this.engine.render.mouse = this.mouseConstraint.mouse;
		}

		private initWorld(): void {
			var cradle: any = this.Matter.Composites.newtonsCradle(280, 100, 5, 30, 200);
			this.Matter.World.add(this.engine.world, cradle);
			this.Matter.Body.translate(cradle.bodies[0],
				{
					x: -180,
					y: -100
				});

			cradle = this.Matter.Composites.newtonsCradle(280, 380, 7, 20, 140);
			this.Matter.World.add(this.engine.world, cradle);
			this.Matter.Body.translate(cradle.bodies[0],
				{
					x: -140,
					y: -100
				});
		}

		private onResize(): void {
			// 设置鼠标的坐标缩放
			this.Matter.Mouse.setScale(this.mouseConstraint.mouse, { x: 1 / (Laya.stage.clientScaleX * Laya.stage._canvasTransform.a), y: 1 / (Laya.stage.clientScaleY * Laya.stage._canvasTransform.d) });
		}
	}
}
new laya.Physics_NewtonsCradle();