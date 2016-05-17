/// <reference path="../../libs/LayaAir.d.ts" />
var Matter;
var LayaRender;
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Stage = laya.display.Stage;
    var Stat = laya.utils.Stat;
    var WebGL = laya.webgl.WebGL;
    var Physics_NewtonsCradle = (function () {
        function Physics_NewtonsCradle() {
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
        Physics_NewtonsCradle.prototype.initMatter = function () {
            var gameWorld = new Sprite();
            Laya.stage.addChild(gameWorld);
            // 初始化物理引擎
            this.engine = Matter.Engine.create({
                enableSleeping: true,
                render: {
                    container: gameWorld,
                    controller: LayaRender,
                    options: {
                        width: 800,
                        height: 600,
                        wireframes: false
                    }
                }
            });
            this.mouseConstraint = Matter.MouseConstraint.create(this.engine);
            Matter.World.add(this.engine.world, this.mouseConstraint);
            this.engine.render.mouse = this.mouseConstraint.mouse;
        };
        Physics_NewtonsCradle.prototype.initWorld = function () {
            var cradle = Matter.Composites.newtonsCradle(280, 100, 5, 30, 200);
            Matter.World.add(this.engine.world, cradle);
            Matter.Body.translate(cradle.bodies[0], {
                x: -180,
                y: -100
            });
            cradle = Matter.Composites.newtonsCradle(280, 380, 7, 20, 140);
            Matter.World.add(this.engine.world, cradle);
            Matter.Body.translate(cradle.bodies[0], {
                x: -140,
                y: -100
            });
        };
        Physics_NewtonsCradle.prototype.onResize = function () {
            // 设置鼠标的坐标缩放
            Matter.Mouse.setScale(this.mouseConstraint.mouse, { x: 1 / (Laya.stage.clientScaleX * Laya.stage._canvasTransform.a), y: 1 / (Laya.stage.clientScaleY * Laya.stage._canvasTransform.d) });
        };
        return Physics_NewtonsCradle;
    }());
    laya.Physics_NewtonsCradle = Physics_NewtonsCradle;
})(laya || (laya = {}));
new laya.Physics_NewtonsCradle();
