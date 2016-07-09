/// <reference path="../../../bin/ts/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Text = laya.display.Text;
    var Browser = laya.utils.Browser;
    var WebGL = laya.webgl.WebGL;
    var PIXI_Example_04 = (function () {
        function PIXI_Example_04() {
            this.starCount = 2500;
            this.sx = 1.0 + (Math.random() / 20);
            this.sy = 1.0 + (Math.random() / 20);
            this.stars = [];
            this.w = Browser.width;
            this.h = Browser.height;
            this.slideX = this.w / 2;
            this.slideY = this.h / 2;
            Laya.init(this.w, this.h, WebGL);
            this.createText();
            this.start();
        }
        PIXI_Example_04.prototype.start = function () {
            for (var i = 0; i < this.starCount; i++) {
                var tempBall = new Sprite();
                tempBall.loadImage("res/pixi/bubble_32x32.png");
                tempBall.x = (Math.random() * this.w) - this.slideX;
                tempBall.y = (Math.random() * this.h) - this.slideY;
                tempBall.pivot(16, 16);
                this.stars.push({ sprite: tempBall, x: tempBall.x, y: tempBall.y });
                Laya.stage.addChild(tempBall);
            }
            Laya.stage.on('click', this, this.newWave);
            this.speedInfo.text = 'SX: ' + this.sx + '\nSY: ' + this.sy;
            this.resize();
            Laya.timer.frameLoop(1, this, this.update);
        };
        PIXI_Example_04.prototype.createText = function () {
            this.speedInfo = new Text();
            this.speedInfo.color = "#FFFFFF";
            this.speedInfo.pos(this.w - 160, 20);
            this.speedInfo.zOrder = 1;
            Laya.stage.addChild(this.speedInfo);
        };
        PIXI_Example_04.prototype.newWave = function () {
            this.sx = 1.0 + (Math.random() / 20);
            this.sy = 1.0 + (Math.random() / 20);
            this.speedInfo.text = 'SX: ' + this.sx + '\nSY: ' + this.sy;
        };
        PIXI_Example_04.prototype.resize = function () {
            this.w = Laya.stage.width;
            this.h = Laya.stage.height;
            this.slideX = this.w / 2;
            this.slideY = this.h / 2;
        };
        PIXI_Example_04.prototype.update = function () {
            for (var i = 0; i < this.starCount; i++) {
                this.stars[i].sprite.x = this.stars[i].x + this.slideX;
                this.stars[i].sprite.y = this.stars[i].y + this.slideY;
                this.stars[i].x = this.stars[i].x * this.sx;
                this.stars[i].y = this.stars[i].y * this.sy;
                if (this.stars[i].x > this.w) {
                    this.stars[i].x = this.stars[i].x - this.w;
                }
                else if (this.stars[i].x < -this.w) {
                    this.stars[i].x = this.stars[i].x + this.w;
                }
                if (this.stars[i].y > this.h) {
                    this.stars[i].y = this.stars[i].y - this.h;
                }
                else if (this.stars[i].y < -this.h) {
                    this.stars[i].y = this.stars[i].y + this.h;
                }
            }
        };
        return PIXI_Example_04;
    }());
    laya.PIXI_Example_04 = PIXI_Example_04;
})(laya || (laya = {}));
new laya.PIXI_Example_04();
