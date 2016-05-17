/// <reference path="../../libs/LayaAir.d.ts" />
var Matter;
var LayaRender;
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Stage = laya.display.Stage;
    var Stat = laya.utils.Stat;
    var WebGL = laya.webgl.WebGL;
    var Physics_Slingshot = (function () {
        function Physics_Slingshot() {
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
        Physics_Slingshot.prototype.initMatter = function () {
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
                        background: 'res/physics/img/background.png',
                        hasBounds: true
                    }
                }
            });
            this.mouseConstraint = Matter.MouseConstraint.create(this.engine, {
                constraint: {
                    angularStiffness: 0.1,
                    stiffness: 2
                }
            });
            Matter.World.add(this.engine.world, this.mouseConstraint);
            this.engine.render.mouse = this.mouseConstraint.mouse;
        };
        Physics_Slingshot.prototype.initWorld = function () {
            var ground = Matter.Bodies.rectangle(395, 600, 815, 50, {
                isStatic: true,
                render: {
                    visible: false
                }
            }), rockOptions = {
                density: 0.004,
                render: {
                    sprite: {
                        texture: 'res/physics/img/rock.png',
                        xOffset: 23.5,
                        yOffset: 23.5
                    }
                }
            }, rock = Matter.Bodies.polygon(170, 450, 8, 20, rockOptions), anchor = {
                x: 170,
                y: 450
            }, elastic = Matter.Constraint.create({
                pointA: anchor,
                bodyB: rock,
                stiffness: 0.05,
                render: {
                    lineWidth: 5,
                    strokeStyle: '#dfa417'
                }
            });
            var pyramid = Matter.Composites.pyramid(500, 300, 9, 10, 0, 0, function (x, y, column) {
                var texture = column % 2 === 0 ? 'res/physics/img/block.png' : 'res/physics/img/block-2.png';
                return Matter.Bodies.rectangle(x, y, 25, 40, {
                    render: {
                        sprite: {
                            texture: texture,
                            xOffset: 20.5,
                            yOffset: 28
                        }
                    }
                });
            });
            var ground2 = Matter.Bodies.rectangle(610, 250, 200, 20, {
                isStatic: true,
                render: {
                    fillStyle: '#edc51e',
                    strokeStyle: '#b5a91c'
                }
            });
            var pyramid2 = Matter.Composites.pyramid(550, 0, 5, 10, 0, 0, function (x, y, column) {
                var texture = column % 2 === 0 ? 'res/physics/img/block.png' : 'res/physics/img/block-2.png';
                return Matter.Bodies.rectangle(x, y, 25, 40, {
                    render: {
                        sprite: {
                            texture: texture,
                            xOffset: 20.5,
                            yOffset: 28
                        }
                    }
                });
            });
            Matter.World.add(this.engine.world, [this.mouseConstraint, ground, pyramid, ground2, pyramid2, rock, elastic]);
            Matter.Events.on(this.engine, 'afterUpdate', (function () {
                if (this.mouseConstraint.mouse.button === -1 && (rock.position.x > 190 || rock.position.y < 430)) {
                    rock = Matter.Bodies.polygon(170, 450, 7, 20, rockOptions);
                    Matter.World.add(this.engine.world, rock);
                    elastic.bodyB = rock;
                }
            }).bind(this));
            var renderOptions = this.engine.render.options;
            renderOptions.wireframes = false;
        };
        Physics_Slingshot.prototype.onResize = function () {
            // 设置鼠标的坐标缩放
            Matter.Mouse.setScale(this.mouseConstraint.mouse, { x: 1 / (Laya.stage.clientScaleX * Laya.stage._canvasTransform.a), y: 1 / (Laya.stage.clientScaleY * Laya.stage._canvasTransform.d) });
        };
        return Physics_Slingshot;
    }());
    laya.Physics_Slingshot = Physics_Slingshot;
})(laya || (laya = {}));
new laya.Physics_Slingshot();
