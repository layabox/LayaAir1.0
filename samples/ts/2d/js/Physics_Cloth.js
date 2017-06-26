var Matter;
var LayaRender;
var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Browser = Laya.Browser;
    var Stat = Laya.Stat;
    var WebGL = Laya.WebGL;
    var Render = Laya.Render;
    var Physics_Cloth = (function () {
        function Physics_Cloth() {
            this.stageWidth = 800;
            this.stageHeight = 600;
            this.Matter = Browser.window.Matter;
            this.LayaRender = Browser.window.LayaRender;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(this.stageWidth, this.stageHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Stat.show();
            this.setup();
        }
        Physics_Cloth.prototype.setup = function () {
            this.initMatter();
            this.initWorld();
            Laya.stage.on("resize", this, this.onResize);
        };
        Physics_Cloth.prototype.initMatter = function () {
            var gameWorld = new Sprite();
            Laya.stage.addChild(gameWorld);
            // 初始化物理引擎
            this.engine = Matter.Engine.create({ enableSleeping: true });
            Matter.Engine.run(this.engine);
            var render = this.LayaRender.create({ engine: this.engine, container: gameWorld, width: this.stageWidth, height: this.stageHeight, options: { wireframes: false } });
            this.LayaRender.run(render);
            this.mouseConstraint = Matter.MouseConstraint.create(this.engine, { element: Render.canvas });
            Matter.World.add(this.engine.world, this.mouseConstraint);
            render.mouse = this.mouseConstraint.mouse;
        };
        Physics_Cloth.prototype.initWorld = function () {
            // 创建游戏场景
            var group = Matter.Body.nextGroup(true);
            var particleOptions = { friction: 0.00001, collisionFilter: { group: group }, render: { visible: false } };
            var cloth = Matter.Composites.softBody(200, 200, 20, 12, 5, 5, false, 8, particleOptions);
            for (var i = 0; i < 20; i++) {
                cloth.bodies[i].isStatic = true;
            }
            Matter.World.add(this.engine.world, [
                cloth,
                Matter.Bodies.circle(300, 500, 80, { isStatic: true }),
                Matter.Bodies.rectangle(500, 480, 80, 80, { isStatic: true })
            ]);
        };
        Physics_Cloth.prototype.onResize = function () {
            // 设置鼠标的坐标缩放
            Matter.Mouse.setScale(this.mouseConstraint.mouse, {
                x: 1 / (Laya.stage.clientScaleX * Laya.stage._canvasTransform.a),
                y: 1 / (Laya.stage.clientScaleY * Laya.stage._canvasTransform.d)
            });
        };
        return Physics_Cloth;
    }());
    laya.Physics_Cloth = Physics_Cloth;
})(laya || (laya = {}));
new laya.Physics_Cloth();
