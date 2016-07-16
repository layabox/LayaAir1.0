module laya {
	import Skeleton = laya.ani.bone.Skeleton;
	import Templet = laya.ani.bone.Templet;
	import Stage = laya.display.Stage;
	import Event = laya.events.Event;
	import Keyboard = laya.events.Keyboard;
	import Loader = laya.net.Loader;
	import Texture = laya.resource.Texture;
	import Handler = laya.utils.Handler;
	import WebGL = laya.webgl.WebGL;

	export class Skeleton_Swordman {
		private ANI_STAND: number = 0;
		private ANI_FLOAT: number = 1;
		private ANI_SPRINT: number = 2;
		private ANI_RUN: number = 3;
		private ANI_JUMP: number = 4;
		private ANI_ATTACK1: number = 5;
		private ANI_COME_ON_STAGE: number = 6;
		private ANI_ATTACK2: number = 7;

		private dataPath: string = "../../res/skeleton/SwordsMan/SwordsMan_1.sk";
		private texturePath: string = "../../res/skeleton/SwordsMan/texture.png";

		private factory: Templet;

		private stageWidth: number = 800;
		private stageHeight: number = 600;

		private landingY: number = this.stageHeight - 100;

		private Speed: number = 4;
		private forceInAir: number = 1.5;
		private InintialScale: number = 0.3;
		private friction: number = 0.94;
		private keyList: Array<boolean> = [];

		private currAction: number;
		private isRunning: boolean = false;
		private isSprinting: boolean = false;
		private isInAir: boolean = false;
		private isJumping: boolean = false;
		private isComeOnStage: boolean = false;
		private isAttacking: boolean = false;

		private vx: number = 0;
		private vy: number = 0;

		private swordman: Skeleton;

		constructor(){
			// 不支持WebGL时自动切换至Canvas
			Laya.init(this.stageWidth, this.stageHeight, WebGL);

			// 舞台适配
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			// 资源加载
			var assets: Array<any> = [];
			assets.push({ url: this.dataPath, type: Loader.BUFFER });
			assets.push({ url: this.texturePath, type: Loader.IMAGE });
			Laya.loader.load(assets, Handler.create(this, this.onAssetLoaded));
		}

		private onAssetLoaded(): void {
			// 获取资源
			var texture: Texture = Loader.getRes(this.texturePath);
			var data: ArrayBuffer = Loader.getRes(this.dataPath);

			// 解析骨骼
			this.factory = new Templet();
			this.factory.on(Event.COMPLETE, this, this.onSkeletonDataParsed);
			this.factory.parseData(texture, data, 60);
		}

		private onSkeletonDataParsed(): void {
			// 创建骨骼动画
			this.swordman = this.factory.buildArmature(2);
			this.swordman.scale(this.InintialScale, this.InintialScale);
			this.swordman.play(this.currAction = this.ANI_STAND, true);
			Laya.stage.addChild(this.swordman);
			//this.swordman.filters = [new GlowFilter("#ffff00", 10, 0, 0)];
			this.swordman.pos(200, this.landingY);
			this.swordman.on(Event.STOPPED, this, this.onAnimationFinish);

			// 键盘事件和游戏循环
			Laya.stage.on(Event.KEY_DOWN, this, this.onKeyDown);
			Laya.stage.on(Event.KEY_UP, this, this.onKeyUp);
			Laya.timer.frameLoop(1, this, this.gameLoop);
		}

		private onKeyDown(e: Event): void {
			this.keyList[e["keyCode"]] = true;
		}

		private onKeyUp(e: Event): void {
			this.keyList[e["keyCode"]] = false;
		}

		private gameLoop(): void {
			// 左右移动和站立
			if (this.keyList[Keyboard.A] || this.keyList[Keyboard.D]) this.move();
			else this.stand();

			if (this.keyList[Keyboard.W]) this.float();
			else if (this.keyList[Keyboard.S]) this.landing();

			if (this.keyList[Keyboard.SPACE]) this.jump();
			else if (this.keyList[Keyboard.J]) this.attack(this.ANI_ATTACK1);
			else if (this.keyList[Keyboard.K]) this.attack(this.ANI_ATTACK2);
			else if (this.keyList[Keyboard.L]) this.comeOnStage();

			this.motion();
		}

		// 移动
		private move(): void {
			var dir: number = (this.keyList[Keyboard.A] ? -1 : 1);

			// 在陆地上速度为Speed，空中速度为Speed * forceInAir
			this.vx = dir * this.Speed;
			if (this.isInAir) this.vx *= 2;

			// 改变人物朝向
			this.swordman.scaleX = dir * this.InintialScale;

			// 播放动画 & 设置动作标记变量
			if (this.isPlayingMovingAnimation() == false &&
				this.isPlayingOtherAnimation() == false) {
				if (this.isInAir) {
					this.currAction = this.ANI_SPRINT;
					this.isSprinting = true;
				}
				else {
					this.currAction = this.ANI_RUN;
					this.isRunning = true;
				}
				this.swordman.play(this.currAction, true);
			}
		}

		// 站立
		private stand(): void {
			// 在陆地上，没有按下A|D直接停止
			if (!this.isInAir)
				this.vx = 0;

			if (this.currAction != this.ANI_STAND &&
				this.isInAir == false &&
				!this.isPlayingOtherAnimation()) {
				this.swordman.play(this.currAction = this.ANI_STAND, true);
				this.isRunning = this.isSprinting = false;
			}
		}

		// 漂浮在空中
		private float(): void {
			if (this.isPlayingOtherAnimation())
				return;

			this.vy = -this.Speed * this.forceInAir;
			if (!this.isInAir) {
				this.isInAir = true;

				if (this.isPlayingMovingAnimation()) {
					this.currAction = this.ANI_SPRINT;
					this.isSprinting = true;
					this.isRunning = false;
				}
				else
					this.currAction = this.ANI_FLOAT;

				this.swordman.play(this.currAction, true);
			}
		}

		// 从空中降落
		private landing(): void {
			if (!this.isInAir)
				return;
			this.vy = this.Speed * this.forceInAir;
		}

		// 跳跃
		private jump(): void {
			if (this.isPlayingOtherAnimation() ||
				this.isInAir)
				return;

			this.swordman.play(this.currAction = this.ANI_JUMP, false);
			this.isJumping = true;
			this.isRunning = false;
		}

		// 攻击
		private attack(action: number): void {
			if (this.isPlayingOtherAnimation() ||
				this.isInAir)
				return;

			this.swordman.play(this.currAction = action, false);
			this.isAttacking = true;
			this.isRunning = false;
		}

		// 播放“进入舞台？？”的动画
		private comeOnStage(): void {
			if (this.isPlayingOtherAnimation() ||
				this.isInAir)
				return;

			this.swordman.play(this.currAction = this.ANI_COME_ON_STAGE, false);
			this.isComeOnStage = true;
			this.isRunning = false;
		}

		// 游戏循环
		private motion(): void {
			if (!this.isPlayingOtherAnimation() || this.isJumping) {
				if (this.vx != 0) {
					this.swordman.x += this.vx;
				}
				if (this.vy != 0) {
					this.swordman.y += this.vy;
				}
			}
			this.applyFriction();
			this.checkStaticInAir();
			this.checkLanding();
		}

		// 在空中应用摩擦力，陆地中视为无限大
		private applyFriction(): void {
			if (this.isInAir) {
				if (this.vx != 0) {
					this.vx *= this.friction;
					if (Math.abs(this.vx) < 1) this.vx = 0;
				}
				if (this.vy != 0) {
					this.vy *= this.friction;
					if (Math.abs(this.vy) < 1) this.vy = 0;
				}
			}
		}

		// 检测由惯性造成移动后何时停止
		private checkStaticInAir(): void {
			if (!this.isInAir ||
				this.currAction == this.ANI_FLOAT ||
				this.vx != 0)
				return;

			this.swordman.play(this.currAction = this.ANI_FLOAT, true);
			this.isSprinting = false;
		}

		// 检测从空中着陆
		private checkLanding(): void {
			if (this.isInAir && this.swordman.y >= this.landingY) {
				this.swordman.play(this.currAction = this.ANI_STAND, true);

				this.swordman.y = this.landingY;
				this.vy = 0;

				this.isInAir = false;
				this.isSprinting = false;
			}
		}

		private isPlayingMovingAnimation() {
			return this.isRunning ||
				this.isSprinting;
		}

		private isPlayingOtherAnimation() {
			return this.isJumping ||
				this.isAttacking ||
				this.isComeOnStage;
		}

		// 监测动作结束
		private onAnimationFinish(e: Event): void {
			switch (this.currAction) {
				case this.ANI_JUMP:
					this.isJumping = false;
					break;
				case this.ANI_ATTACK1:
				case this.ANI_ATTACK2:
					this.isAttacking = false;
					break;
				case this.ANI_COME_ON_STAGE:
					this.isComeOnStage = false;
					break;
			}
		}
	}
}
new laya.Skeleton_Swordman();