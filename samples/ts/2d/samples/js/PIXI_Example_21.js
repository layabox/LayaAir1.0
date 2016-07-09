/// <reference path="../../../bin/ts/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Browser = laya.utils.Browser;
    var WebGL = laya.webgl.WebGL;
    var PIXI_Example_21 = (function () {
        function PIXI_Example_21() {
            this.colors = ["#5D0776", "#EC8A49", "#AF3666", "#F6C84C", "#4C779A"];
            this.colorCount = 0;
            this.isDown = false;
            this.path = [];
            this.color = this.colors[0];
            Laya.init(Browser.width, Browser.height, WebGL);
            Laya.stage.bgColor = "#3da8bb";
            this.createCanvases();
            Laya.timer.frameLoop(1, this, this.animate);
            Laya.stage.on('mousedown', this, this.onMouseDown);
            Laya.stage.on('mousemove', this, this.onMouseMove);
            Laya.stage.on('mouseup', this, this.onMouseUp);
        }
        PIXI_Example_21.prototype.createCanvases = function () {
            var graphicsCanvas = new Sprite();
            Laya.stage.addChild(graphicsCanvas);
            var liveGraphicsCanvas = new Sprite();
            Laya.stage.addChild(liveGraphicsCanvas);
            this.liveGraphics = liveGraphicsCanvas.graphics;
            this.canvasGraphics = graphicsCanvas.graphics;
        };
        PIXI_Example_21.prototype.onMouseDown = function () {
            this.isDown = true;
            this.color = this.colors[this.colorCount++ % this.colors.length];
            this.path.length = 0;
        };
        PIXI_Example_21.prototype.onMouseMove = function () {
            if (!this.isDown)
                return;
            this.path.push(Laya.stage.mouseX);
            this.path.push(Laya.stage.mouseY);
        };
        PIXI_Example_21.prototype.onMouseUp = function () {
            this.isDown = false;
            this.canvasGraphics.drawPoly(0, 0, this.path.concat(), this.color);
        };
        PIXI_Example_21.prototype.animate = function () {
            this.liveGraphics.clear();
            this.liveGraphics.drawPoly(0, 0, this.path, this.color);
        };
        return PIXI_Example_21;
    }());
    laya.PIXI_Example_21 = PIXI_Example_21;
})(laya || (laya = {}));
new laya.PIXI_Example_21();
