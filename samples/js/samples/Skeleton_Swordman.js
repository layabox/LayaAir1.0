(function()
{
	var Skeleton = laya.ani.bone.Skeleton;
	var Templet = laya.ani.bone.Templet;
	var Stage = laya.display.Stage;
	var Event = laya.events.Event;
	var Keyboard = laya.events.Keyboard;
	var Loader = laya.net.Loader;
	var Texture = laya.resource.Texture;
	var Handler = laya.utils.Handler;
	var WebGL = laya.webgl.WebGL;

	var ANI_STAND = 0;
	var ANI_FLOAT = 1;
	var ANI_SPRINT = 2;
	var ANI_RUN = 3;
	var ANI_JUMP = 4;
	var ANI_ATTACK1 = 5;
	var ANI_COME_ON_STAGE = 6;
	var ANI_ATTACK2 = 7;

	var dataPath = "res/skeleton/SwordsMan/SwordsMan_1.sk";
	var texturePath = "res/skeleton/SwordsMan/texture.png";

	var factory;

	var stageWidth = 800;
	var stageHeight = 600;

	var landingY = stageHeight - 100;

	var Speed = 4;
	var forceInAir = 1.5;
	var InintialScale = 0.3;
	var friction = 0.94;
	var keyList = [];

	var currAction;
	var isRunning = false;
	var isSprinting = false;
	var isInAir = false;
	var isJumping = false;
	var isComeOnStage = false;
	var isAttacking = false;

	var vx = 0, vy = 0;

	var swordman;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(stageWidth, stageHeight, WebGL);

		// 舞台适配
		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		// 资源加载
		var assets = [];
		assets.push(
		{
			url: dataPath,
			type: Loader.BUFFER
		});
		assets.push(
		{
			url: texturePath,
			type: Loader.IMAGE
		});
		Laya.loader.load(assets, Handler.create(this, onAssetLoaded));
	})();

	function onAssetLoaded()
	{
		// 获取资源
		var texture = Loader.getRes(texturePath);
		var data = Loader.getRes(dataPath);

		// 解析骨骼
		factory = new Templet();
		factory.on(Event.COMPLETE, this, onSkeletonDataParsed);
		factory.parseData(texture, data, 60);
	}

	function onSkeletonDataParsed()
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

	function onKeyDown(e)
	{
		keyList[e.keyCode] = true;
	}

	function onKeyUp(e)
	{
		keyList[e.keyCode] = false;
	}

	function gameLoop()
	{
		// 左右移动和站立
		if (keyList[Keyboard.A] || keyList[Keyboard.D]) move();
		else stand();

		if (keyList[Keyboard.W]) float();
		else if (keyList[Keyboard.S]) landing();

		if (keyList[Keyboard.SPACE]) jump();
		else if (keyList[Keyboard.J]) attack(ANI_ATTACK1);
		else if (keyList[Keyboard.K]) attack(ANI_ATTACK2);
		else if (keyList[Keyboard.L]) comeOnStage();

		motion();
	}

	// 移动
	function move()
	{
		var dir = (keyList[Keyboard.A] ? -1 : 1);

		// 在陆地上速度为Speed，空中速度为Speed * forceInAir
		vx = dir * Speed;
		if (isInAir) vx *= 2;

		// 改变人物朝向
		swordman.scaleX = dir * InintialScale;

		// 播放动画 & 设置动作标记变量
		if (isPlayingMovingAnimation() == false &&
			isPlayingOtherAnimation() == false)
		{
			if (isInAir)
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
	function stand()
	{
		// 在陆地上，没有按下A|D直接停止
		if (!isInAir)
			vx = 0;

		if (currAction != ANI_STAND &&
			isInAir == false &&
			!isPlayingOtherAnimation())
		{
			swordman.play(currAction = ANI_STAND, true);
			isRunning = isSprinting = false;
		}
	}

	// 漂浮在空中
	function float()
	{
		if (isPlayingOtherAnimation())
			return;

		vy = -Speed * forceInAir;
		if (!isInAir)
		{
			isInAir = true;

			if (isPlayingMovingAnimation())
			{
				currAction = ANI_SPRINT;
				isSprinting = true;
				isRunning = false;
			}
			else
				currAction = ANI_FLOAT;

			swordman.play(currAction, true);
		}
	}

	// 从空中降落
	function landing()
	{
		if (!isInAir)
			return;
		vy = Speed * forceInAir;
	}

	// 跳跃
	function jump()
	{
		if (isPlayingOtherAnimation() ||
			isInAir)
			return;

		swordman.play(currAction = ANI_JUMP, false);
		isJumping = true;
		isRunning = false;
	}

	// 攻击
	function attack(action)
	{
		if (isPlayingOtherAnimation() ||
			isInAir)
			return;

		swordman.play(currAction = action, false);
		isAttacking = true;
		isRunning = false;
	}

	// 播放“进入舞台？？”的动画
	function comeOnStage()
	{
		if (isPlayingOtherAnimation() ||
			isInAir)
			return;

		swordman.play(currAction = ANI_COME_ON_STAGE, false);
		isComeOnStage = true;
		isRunning = false;
	}

	// 游戏循环
	function motion()
	{
		if (!isPlayingOtherAnimation() || isJumping)
		{
			if (vx != 0)
			{
				swordman.x += vx;
			}
			if (vy != 0)
			{
				swordman.y += vy;
			}
		}
		applyFriction();
		checkStaticInAir();
		checkLanding();
	}

	// 在空中应用摩擦力，陆地中视为无限大
	function applyFriction()
	{
		if (isInAir)
		{
			if (vx != 0)
			{
				vx *= friction;
				if (Math.abs(vx) < 1) vx = 0;
			}
			if (vy != 0)
			{
				vy *= friction;
				if (Math.abs(vy) < 1) vy = 0;
			}
		}
	}

	// 检测由惯性造成移动后何时停止
	function checkStaticInAir()
	{
		if (!isInAir ||
			currAction == ANI_FLOAT ||
			vx != 0)
			return;

		swordman.play(currAction = ANI_FLOAT, true);
		isSprinting = false;
	}

	// 检测从空中着陆
	function checkLanding()
	{
		if (isInAir && swordman.y >= landingY)
		{
			swordman.play(currAction = ANI_STAND, true);

			swordman.y = landingY;
			vy = 0;

			isInAir = false;
			isSprinting = false;
		}
	}

	function isPlayingMovingAnimation()
	{
		return isRunning ||
			isSprinting;
	}

	function isPlayingOtherAnimation()
	{
		return isJumping ||
			isAttacking ||
			isComeOnStage;
	}

	// 监测动作结束
	function onAnimationFinish(e)
	{
		switch (currAction)
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
})();