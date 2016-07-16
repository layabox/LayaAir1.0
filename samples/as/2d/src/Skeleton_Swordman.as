package
{
	import laya.ani.bone.Skeleton;
	import laya.ani.bone.Templet;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.events.Keyboard;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.webgl.WebGL;

	public class Skeleton_Swordman
	{
		private const ANI_STAND:int = 0;
		private const ANI_FLOAT:int = 1;
		private const ANI_SPRINT:int = 2;
		private const ANI_RUN:int = 3;
		private const ANI_JUMP:int = 4;
		private const ANI_ATTACK1:int = 5;
		private const ANI_COME_ON_STAGE	:int = 6;
		private const ANI_ATTACK2:int = 7;

		private var dataPath:String = "../../../../res/skeleton/SwordsMan/SwordsMan_1.sk";
		private var texturePath:String = "../../../../res/skeleton/SwordsMan/texture.png";

		private var factory:Templet;

		private var stageWidth:int = 800;
		private var stageHeight:int = 600;

		private var landingY:int = stageHeight - 100;

		private const Speed:int = 4;
		private const forceInAir:Number = 1.5;
		private const InintialScale:Number = 0.3;
		private const friction:Number = 0.94;
		private var keyList:Array = [];

		private var currAction    : int;
		private var isRunning     : Boolean;
		private var isSprinting   : Boolean;
		private var isInAir       : Boolean;
		private var isJumping     : Boolean;
		private var isComeOnStage : Boolean;
		private var isAttacking   : Boolean;

		private var vx:int, vy:int;

		private var swordman:Skeleton;

		public function Skeleton_Swordman()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(stageWidth, stageHeight, WebGL);

			// 舞台适配
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			// 资源加载
			var assets:Array = [];
			assets.push({ url:dataPath, type:Loader.BUFFER });
			assets.push({ url:texturePath, type:Loader.IMAGE });
			Laya.loader.load(assets, Handler.create(this, onAssetLoaded));
		}

		private function onAssetLoaded(e:*=null):void
		{
			// 获取资源
			var texture:Texture = Loader.getRes(texturePath);
			var data:ArrayBuffer = Loader.getRes(dataPath);

			// 解析骨骼
			factory = new Templet();
			factory.on(Event.COMPLETE, this, onSkeletonDataParsed);
			factory.parseData(texture, data, 60);
		}

		private function onSkeletonDataParsed(e:*=null):void
		{
			// 创建骨骼动画
			swordman = factory.buildArmature(2);
			swordman.scale(InintialScale, InintialScale);
			swordman.play(currAction = ANI_STAND, true);
			Laya.stage.addChild(swordman);
			//swordman.filters = [new GlowFilter("#ffff00", 10, 0, 0)];
			swordman.pos(200, landingY);
			swordman.on(Event.STOPPED, this, onAnimationFinish);

			// 键盘事件和游戏循环
			Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
			Laya.stage.on(Event.KEY_UP, this, onKeyUp);
			Laya.timer.frameLoop(1, this, gameLoop);
		}

		private function onKeyDown(e:*=null):void
		{
			keyList[e.keyCode] = true;
		}

		private function onKeyUp(e:*=null):void
		{
			keyList[e.keyCode] = false;
		}

		private function gameLoop():void
		{
			// 左右移动和站立
			if(keyList[Keyboard.A] || keyList[Keyboard.D])	move();
			else stand();

			if(keyList[Keyboard.W])		float();
			else if(keyList[Keyboard.S]) landing();

			if(keyList[Keyboard.SPACE])		jump();
			else if(keyList[Keyboard.J])	attack(ANI_ATTACK1);
			else if(keyList[Keyboard.K]) 	attack(ANI_ATTACK2);
			else if(keyList[Keyboard.L])	comeOnStage();

			motion();
		}

		// 移动
		private function move():void
		{
			var dir:int = (keyList[Keyboard.A] ? -1 : 1);

			// 在陆地上速度为Speed，空中速度为Speed * forceInAir
			vx = dir * Speed;
			if(isInAir) vx *= 2;

			// 改变人物朝向
			swordman.scaleX = dir * InintialScale;

			// 播放动画 & 设置动作标记变量
			if(	isPlayingMovingAnimation()	== false && 
				isPlayingOtherAnimation()	== false)
			{
				if(isInAir)
				{
					currAction = ANI_SPRINT;
					isSprinting = true;
				}
				else
				{
					currAction = ANI_RUN;
					isRunning = true;
				}
				swordman.play(currAction, true);
			}
		}

		// 站立
		private function stand():void
		{
			// 在陆地上，没有按下A|D直接停止
			if(!isInAir)
				vx = 0;

			if(	currAction	!= ANI_STAND &&
				isInAir		== false	 && 
				!isPlayingOtherAnimation())
			{
				swordman.play(currAction = ANI_STAND, true);
				isRunning = isSprinting = false;
			}
		}

		// 漂浮在空中
		private function float():void
		{
			if(isPlayingOtherAnimation())
				return;

			vy = -Speed * forceInAir;
			if(!isInAir)
			{
				isInAir = true;

				if(isPlayingMovingAnimation())
				{
					currAction  = ANI_SPRINT;
					isSprinting = true;
					isRunning   = false;
				}
				else
					currAction = ANI_FLOAT;

				swordman.play(currAction, true);
			}
		}

		// 从空中降落
		private function landing():void
		{
			if(!isInAir)
				return;
			vy = Speed * forceInAir;
		}

		// 跳跃
		private function jump():void
		{
			if(	isPlayingOtherAnimation() ||
				isInAir)
				return;

			swordman.play(currAction = ANI_JUMP, false);
			isJumping = true;
			isRunning = false;
		}

		// 攻击
		private function attack(action:int):void
		{
			if(	isPlayingOtherAnimation() ||
				isInAir)
				return;

			swordman.play(currAction = action, false);
			isAttacking = true;
			isRunning = false;
		}

		// 播放“进入舞台？？”的动画
		private function comeOnStage():void
		{
			if(	isPlayingOtherAnimation() ||
				isInAir)
				return;

			swordman.play(currAction = ANI_COME_ON_STAGE, false);
			isComeOnStage = true;
			isRunning = false;
		}

		// 游戏循环
		private function motion():void
		{
			if(!isPlayingOtherAnimation() || isJumping)
			{
				if(vx != 0)
				{
					swordman.x += vx;
				}
				if(vy != 0)
				{
					swordman.y += vy;
				}
			}
			applyFriction();
			checkStaticInAir();
			checkLanding();
		}

		// 在空中应用摩擦力，陆地中视为无限大
		private function applyFriction():void
		{
			if(isInAir)
			{
				if(vx != 0)
				{
					vx *= friction;
					if(Math.abs(vx) < 1) vx = 0;
				}
				if(vy != 0)
				{
					vy *= friction;
					if(Math.abs(vy) < 1) vy = 0;
				}
			}
		}

		// 检测由惯性造成移动后何时停止
		private function checkStaticInAir():void
		{
			if(!isInAir ||
				currAction == ANI_FLOAT ||
				vx != 0)
			return;

			swordman.play(currAction = ANI_FLOAT, true);
			isSprinting = false;
		}

		// 检测从空中着陆
		private function checkLanding():void
		{
			if(isInAir && swordman.y >= landingY)
			{
				swordman.play(currAction = ANI_STAND, true);

				swordman.y = landingY;
				vy = 0;

				isInAir = false;
				isSprinting = false;
			}
		}

		private function isPlayingMovingAnimation() : Boolean
		{
			return	isRunning ||
					isSprinting;
		}

		private function isPlayingOtherAnimation() : Boolean
		{
			return	isJumping	||
					isAttacking	||
					isComeOnStage;
		}

		// 监测动作结束
		private function onAnimationFinish(e:Event=null):void
		{
			switch(currAction)
			{
				case ANI_JUMP:
					isJumping = false;
					break;
				case ANI_ATTACK1:
				case ANI_ATTACK2:
					isAttacking = false;
					break;
				case ANI_COME_ON_STAGE:
					isComeOnStage = false;
					break;
			}
		}
	}
}