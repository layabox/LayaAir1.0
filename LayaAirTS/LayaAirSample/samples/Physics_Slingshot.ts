/// <reference path="../../libs/LayaAir.d.ts" />
var Matter: any;
var LayaRender: any;

module laya {
	import Sprite = laya.display.Sprite;
	import Stage = laya.display.Stage;
	import Browser = laya.utils.Browser;
	import Stat = laya.utils.Stat;
	import WebGL = laya.webgl.WebGL;

	export class Physics_Slingshot {
		private mouseConstraint: any;
		private engine: any;

		constructor() {
			Laya.init(800, 600, WebGL);
			Stat.show();

			// 设置舞台
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;

			this.initMatter();
			this.initWorld();

			Matter.Engine.run(this.engine);
			Laya.stage.on("resize", this, this.onResize);
		}

		private initMatter(): void {
			var gameWorld: Sprite = new Sprite();
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
							width: 800,
							height: 600,
							background: 'res/physics/img/background.png',
							hasBounds: true
						}
					}
				});

			this.mouseConstraint = Matter.MouseConstraint.create(this.engine,
				{
					constraint:
					{
						angularStiffness: 0.1,
						stiffness: 2
					}
				});
			Matter.World.add(this.engine.world, this.mouseConstraint);
			this.engine.render.mouse = this.mouseConstraint.mouse;
		}
		private initWorld(): void {
			var ground: any = Matter.Bodies.rectangle(395, 600, 815, 50,
				{
					isStatic: true,
					render:
					{
						visible: false
					}
				}),
				rockOptions: Object = {
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
				rock: any = Matter.Bodies.polygon(170, 450, 8, 20, rockOptions),
				anchor: Object = {
					x: 170,
					y: 450
				},
				elastic: any = Matter.Constraint.create(
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

			var pyramid: any = Matter.Composites.pyramid(500, 300, 9, 10, 0, 0, function(x: number, y: number, column: number) {
				var texture = column % 2 === 0 ? 'res/physics/img/block.png' : 'res/physics/img/block-2.png';
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

			var ground2: any = Matter.Bodies.rectangle(610, 250, 200, 20,
				{
					isStatic: true,
					render:
					{
						fillStyle: '#edc51e',
						strokeStyle: '#b5a91c'
					}
				});

			var pyramid2: any = Matter.Composites.pyramid(550, 0, 5, 10, 0, 0, function(x: number, y: number, column: number) {
				var texture = column % 2 === 0 ? 'res/physics/img/block.png' : 'res/physics/img/block-2.png';
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

			Matter.World.add(this.engine.world, [this.mouseConstraint, ground, pyramid, ground2, pyramid2, rock, elastic]);

			Matter.Events.on(this.engine, 'afterUpdate', (function() {
				if (this.mouseConstraint.mouse.button === -1 && (rock.position.x > 190 || rock.position.y < 430)) {
					rock = Matter.Bodies.polygon(170, 450, 7, 20, rockOptions);
					Matter.World.add(this.engine.world, rock);
					elastic.bodyB = rock;
				}
			}).bind(this));

			var renderOptions = this.engine.render.options;
			renderOptions.wireframes = false;
		}

		private onResize() {
			// 设置鼠标的坐标缩放
			Matter.Mouse.setScale(this.mouseConstraint.mouse, { x: 1 / (Laya.stage.clientScaleX), y: 1 / (Laya.stage.clientScaleY) });
		}
	}
}
new laya.Physics_Slingshot();