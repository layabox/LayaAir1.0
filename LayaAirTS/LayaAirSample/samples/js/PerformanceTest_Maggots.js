/// <reference path="../../libs/LayaAir.d.ts" />
var core;
(function (core) {
    var Sprite = laya.display.Sprite;
    var Handler = laya.utils.Handler;
    var Stat = laya.utils.Stat;
    var Rectangle = laya.maths.Rectangle;
    var WebGL = laya.webgl.WebGL;
    var Browser = laya.utils.Browser;
    var Aspixi = (function () {
        function Aspixi() {
            this.padding = 100;
            this.maggotAmount = 5000;
            this.tick = 0;
            this.maggots = [];
            WebGL.enable();
            Laya.init(Browser.width, Browser.height, WebGL);
            Stat.show();
            this.wrapBounds = new Rectangle(-this.padding, -this.padding, Laya.stage.width + this.padding * 2, Laya.stage.height + this.padding * 2);
            Laya.loader.load("res/tinyMaggot.png", Handler.create(this, this.onTextureLoaded));
        }
        Aspixi.prototype.onTextureLoaded = function () {
            this.maggotTexture = Laya.loader.getRes("res/tinyMaggot.png");
            this.initMaggots();
            Laya.timer.frameLoop(1, this, this.animate);
        };
        Aspixi.prototype.initMaggots = function () {
            var maggotContainer;
            for (var i = 0; i < this.maggotAmount; i++) {
                if (i % 16000 == 0)
                    maggotContainer = this.createNewContainer();
                var maggot = this.newMaggot();
                maggotContainer.addChild(maggot);
                this.maggots.push(maggot);
            }
        };
        Aspixi.prototype.createNewContainer = function () {
            var container = new Sprite();
            container.size(1000, 800);
            // 此处cacheAsBitmap主要是为了创建新画布
            // 解除IBQuadrangle数量限制
            // 在显示虫子数量超过16383时需要打开下面一行
            // container.cacheAsBitmap = true;
            Laya.stage.addChild(container);
            return container;
        };
        Aspixi.prototype.newMaggot = function () {
            var maggot = new Sprite();
            maggot.graphics.drawTexture(this.maggotTexture, 0, 0);
            maggot.pivot(16.5, 35);
            var rndScale = 0.8 + Math.random() * 0.3;
            maggot.scale(rndScale, rndScale);
            maggot.rotation = 0.1;
            maggot.x = Math.random() * Laya.stage.width;
            maggot.y = Math.random() * Laya.stage.height;
            maggot.direction = Math.random() * Math.PI;
            maggot.turningSpeed = Math.random() - 0.8;
            maggot.speed = (2 + Math.random() * 2) * 0.2;
            maggot.offset = Math.random() * 100;
            return maggot;
        };
        Aspixi.prototype.animate = function () {
            var maggot;
            var wb = this.wrapBounds;
            var angleUnit = 180 / Math.PI;
            var dir, x = 0.0, y = 0.0;
            for (var i = 0; i < this.maggotAmount; i++) {
                maggot = this.maggots[i];
                maggot.scaleY = 0.90 + Math.sin(this.tick + maggot.offset) * 0.1;
                maggot.direction += maggot.turningSpeed * 0.01;
                dir = maggot.direction;
                x = maggot.x;
                y = maggot.y;
                x += Math.sin(dir) * (maggot.speed * maggot.scaleY);
                y += Math.cos(dir) * (maggot.speed * maggot.scaleY);
                maggot.rotation = (-dir + Math.PI) * angleUnit;
                if (x < wb.x)
                    x += wb.width;
                else if (x > wb.x + wb.width)
                    x -= wb.width;
                if (y < wb.y)
                    y += wb.height;
                else if (y > wb.y + wb.height)
                    y -= wb.height;
                maggot.pos(x, y);
            }
            this.tick += 0.1;
        };
        return Aspixi;
    }());
    core.Aspixi = Aspixi;
})(core || (core = {}));
new core.Aspixi();
