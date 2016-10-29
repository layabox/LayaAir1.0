var laya;
(function (laya) {
    var Templet = Laya.Templet;
    var Stage = Laya.Stage;
    var Event = Laya.Event;
    var Keyboard = Laya.Keyboard;
    var Loader = Laya.Loader;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var Skeleton_Swordman = (function () {
        function Skeleton_Swordman() {
            this.ANI_STAND = 0;
            this.ANI_FLOAT = 1;
            this.ANI_SPRINT = 2;
            this.ANI_RUN = 3;
            this.ANI_JUMP = 4;
            this.ANI_ATTACK1 = 5;
            this.ANI_COME_ON_STAGE = 6;
            this.ANI_ATTACK2 = 7;
            this.dataPath = "../../res/skeleton/SwordsMan/SwordsMan_1.sk";
            this.texturePath = "../../res/skeleton/SwordsMan/texture.png";
            this.stageWidth = 800;
            this.stageHeight = 600;
            this.landingY = this.stageHeight - 100;
            this.Speed = 4;
            this.forceInAir = 1.5;
            this.InintialScale = 0.3;
            this.friction = 0.94;
            this.keyList = [];
            this.isRunning = false;
            this.isSprinting = false;
            this.isInAir = false;
            this.isJumping = false;
            this.isComeOnStage = false;
            this.isAttacking = false;
            this.vx = 0;
            this.vy = 0;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(this.stageWidth, this.stageHeight, WebGL);
            // 舞台适配
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            // 资源加载
            var assets = [];
            assets.push({ url: this.dataPath, type: Loader.BUFFER });
            assets.push({ url: this.texturePath, type: Loader.IMAGE });
            Laya.loader.load(assets, Handler.create(this, this.onAssetLoaded));
        }
        Skeleton_Swordman.prototype.onAssetLoaded = function () {
            // 获取资源
            var texture = Loader.getRes(this.texturePath);
            var data = Loader.getRes(this.dataPath);
            // 解析骨骼
            this.factory = new Templet();
            this.factory.on(Event.COMPLETE, this, this.onSkeletonDataParsed);
            this.factory.parseData(texture, data, 60);
        };
        Skeleton_Swordman.prototype.onSkeletonDataParsed = function () {
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
        };
        Skeleton_Swordman.prototype.onKeyDown = function (e) {
            this.keyList[e["keyCode"]] = true;
        };
        Skeleton_Swordman.prototype.onKeyUp = function (e) {
            this.keyList[e["keyCode"]] = false;
        };
        Skeleton_Swordman.prototype.gameLoop = function () {
            // 左右移动和站立
            if (this.keyList[Keyboard.A] || this.keyList[Keyboard.D])
                this.move();
            else
                this.stand();
            if (this.keyList[Keyboard.W])
                this.float();
            else if (this.keyList[Keyboard.S])
                this.landing();
            if (this.keyList[Keyboard.SPACE])
                this.jump();
            else if (this.keyList[Keyboard.J])
                this.attack(this.ANI_ATTACK1);
            else if (this.keyList[Keyboard.K])
                this.attack(this.ANI_ATTACK2);
            else if (this.keyList[Keyboard.L])
                this.comeOnStage();
            this.motion();
        };
        // 移动
        Skeleton_Swordman.prototype.move = function () {
            var dir = (this.keyList[Keyboard.A] ? -1 : 1);
            // 在陆地上速度为Speed，空中速度为Speed * forceInAir
            this.vx = dir * this.Speed;
            if (this.isInAir)
                this.vx *= 2;
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
        };
        // 站立
        Skeleton_Swordman.prototype.stand = function () {
            // 在陆地上，没有按下A|D直接停止
            if (!this.isInAir)
                this.vx = 0;
            if (this.currAction != this.ANI_STAND &&
                this.isInAir == false &&
                !this.isPlayingOtherAnimation()) {
                this.swordman.play(this.currAction = this.ANI_STAND, true);
                this.isRunning = this.isSprinting = false;
            }
        };
        // 漂浮在空中
        Skeleton_Swordman.prototype.float = function () {
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
        };
        // 从空中降落
        Skeleton_Swordman.prototype.landing = function () {
            if (!this.isInAir)
                return;
            this.vy = this.Speed * this.forceInAir;
        };
        // 跳跃
        Skeleton_Swordman.prototype.jump = function () {
            if (this.isPlayingOtherAnimation() ||
                this.isInAir)
                return;
            this.swordman.play(this.currAction = this.ANI_JUMP, false);
            this.isJumping = true;
            this.isRunning = false;
        };
        // 攻击
        Skeleton_Swordman.prototype.attack = function (action) {
            if (this.isPlayingOtherAnimation() ||
                this.isInAir)
                return;
            this.swordman.play(this.currAction = action, false);
            this.isAttacking = true;
            this.isRunning = false;
        };
        // 播放“进入舞台？？”的动画
        Skeleton_Swordman.prototype.comeOnStage = function () {
            if (this.isPlayingOtherAnimation() ||
                this.isInAir)
                return;
            this.swordman.play(this.currAction = this.ANI_COME_ON_STAGE, false);
            this.isComeOnStage = true;
            this.isRunning = false;
        };
        // 游戏循环
        Skeleton_Swordman.prototype.motion = function () {
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
        };
        // 在空中应用摩擦力，陆地中视为无限大
        Skeleton_Swordman.prototype.applyFriction = function () {
            if (this.isInAir) {
                if (this.vx != 0) {
                    this.vx *= this.friction;
                    if (Math.abs(this.vx) < 1)
                        this.vx = 0;
                }
                if (this.vy != 0) {
                    this.vy *= this.friction;
                    if (Math.abs(this.vy) < 1)
                        this.vy = 0;
                }
            }
        };
        // 检测由惯性造成移动后何时停止
        Skeleton_Swordman.prototype.checkStaticInAir = function () {
            if (!this.isInAir ||
                this.currAction == this.ANI_FLOAT ||
                this.vx != 0)
                return;
            this.swordman.play(this.currAction = this.ANI_FLOAT, true);
            this.isSprinting = false;
        };
        // 检测从空中着陆
        Skeleton_Swordman.prototype.checkLanding = function () {
            if (this.isInAir && this.swordman.y >= this.landingY) {
                this.swordman.play(this.currAction = this.ANI_STAND, true);
                this.swordman.y = this.landingY;
                this.vy = 0;
                this.isInAir = false;
                this.isSprinting = false;
            }
        };
        Skeleton_Swordman.prototype.isPlayingMovingAnimation = function () {
            return this.isRunning ||
                this.isSprinting;
        };
        Skeleton_Swordman.prototype.isPlayingOtherAnimation = function () {
            return this.isJumping ||
                this.isAttacking ||
                this.isComeOnStage;
        };
        // 监测动作结束
        Skeleton_Swordman.prototype.onAnimationFinish = function (e) {
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
        };
        return Skeleton_Swordman;
    }());
    laya.Skeleton_Swordman = Skeleton_Swordman;
})(laya || (laya = {}));
new laya.Skeleton_Swordman();
