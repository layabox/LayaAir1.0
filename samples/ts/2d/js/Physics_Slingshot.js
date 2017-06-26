var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Render = Laya.Render;
    var Browser = Laya.Browser;
    var Physics_Slingshot = (function () {
        function Physics_Slingshot() {
            this.stageWidth = 800;
            this.stageHeight = 600;
            this.Matter = Browser.window.Matter;
            this.LayaRender = Browser.window.LayaRender;
            Laya.init(this.stageWidth, this.stageHeight);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            this.setup();
        }
        Physics_Slingshot.prototype.setup = function () {
            this.initMatter();
            this.initWorld();
            Laya.stage.on("resize", this, this.onResize);
        };
        Physics_Slingshot.prototype.initMatter = function () {
            var gameWorld = new Sprite();
            Laya.stage.addChild(gameWorld);
            // 初始化物理引擎
            this.engine = Matter.Engine.create({ enableSleeping: true });
            Matter.Engine.run(this.engine);
            var render = this.LayaRender.create({ engine: this.engine, width: 800, height: 600, options: { background: '../../res/physics/img/background.png', wireframes: false } });
            this.LayaRender.run(render);
            this.mouseConstraint = Matter.MouseConstraint.create(this.engine, { constraint: { angularStiffness: 0.1, stiffness: 2 }, element: Render.canvas });
            Matter.World.add(this.engine.world, this.mouseConstraint);
            render.mouse = this.mouseConstraint.mouse;
        };
        Physics_Slingshot.prototype.initWorld = function () {
            var ground = Matter.Bodies.rectangle(395, 600, 815, 50, { isStatic: true, render: { visible: false } }), rockOptions = { density: 0.004, render: { sprite: { texture: '../../res/physics/img/rock.png', xOffset: 23.5, yOffset: 23.5 } } }, rock = Matter.Bodies.polygon(170, 450, 8, 20, rockOptions), anchor = { x: 170, y: 450 }, elastic = Matter.Constraint.create({ pointA: anchor, bodyB: rock, stiffness: 0.05, render: { lineWidth: 5, strokeStyle: '#dfa417' } });
            var pyramid = Matter.Composites.pyramid(500, 300, 9, 10, 0, 0, function (x, y, column) {
                var texture = column % 2 === 0 ? '../../res/physics/img/block.png' : '../../res/physics/img/block-2.png';
                return Matter.Bodies.rectangle(x, y, 25, 40, { render: { sprite: { texture: texture, xOffset: 20.5, yOffset: 28 } } });
            });
            var ground2 = Matter.Bodies.rectangle(610, 250, 200, 20, { isStatic: true, render: { fillStyle: '#edc51e', strokeStyle: '#b5a91c' } });
            var pyramid2 = Matter.Composites.pyramid(550, 0, 5, 10, 0, 0, function (x, y, column) {
                var texture = column % 2 === 0 ? '../../res/physics/img/block.png' : '../../res/physics/img/block-2.png';
                return Matter.Bodies.rectangle(x, y, 25, 40, { render: { sprite: { texture: texture, xOffset: 20.5, yOffset: 28 } } });
            });
            Matter.World.add(this.engine.world, [this.mouseConstraint, ground, pyramid, ground2, pyramid2, rock, elastic]);
            Matter.Events.on(this.engine, 'afterUpdate', function () {
                if (this.mouseConstraint.mouse.button === -1 && (rock.position.x > 190 || rock.position.y < 430)) {
                    rock = Matter.Bodies.polygon(170, 450, 7, 20, rockOptions);
                    Matter.World.add(this.engine.world, rock);
                    elastic.bodyB = rock;
                }
            }.bind(this));
        };
        Physics_Slingshot.prototype.onResize = function () {
            // 设置鼠标的坐标缩放
            // Laya.stage.clientScaleX代表舞台缩放
            // Laya.stage._canvasTransform代表画布缩放
            Matter.Mouse.setScale(this.mouseConstraint.mouse, { x: 1 / (Laya.stage.clientScaleX * Laya.stage._canvasTransform.a), y: 1 / (Laya.stage.clientScaleY * Laya.stage._canvasTransform.d) });
        };
        return Physics_Slingshot;
    }());
    laya.Physics_Slingshot = Physics_Slingshot;
})(laya || (laya = {}));
new laya.Physics_Slingshot();
