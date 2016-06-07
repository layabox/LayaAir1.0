/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Stage = laya.display.Stage;
    var Handler = laya.utils.Handler;
    var WebGL = laya.webgl.WebGL;
    var Sprite_MagnifyingGlass = (function () {
        function Sprite_MagnifyingGlass() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(1136, 640, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Laya.loader.load("res/bg.jpg", Handler.create(this, this.setup));
        }
        Sprite_MagnifyingGlass.prototype.setup = function () {
            var bg = new Sprite();
            bg.loadImage("res/bg.jpg");
            Laya.stage.addChild(bg);
            this.bg2 = new Sprite();
            this.bg2.loadImage("res/bg.jpg");
            Laya.stage.addChild(this.bg2);
            this.bg2.scale(3, 3);
            //创建mask
            this.maskSp = new Sprite();
            this.maskSp.loadImage("res/mask.png");
            this.maskSp.pivot(50, 50);
            //设置mask
            this.bg2.mask = this.maskSp;
            Laya.stage.on("mousemove", this, this.onMouseMove);
        };
        Sprite_MagnifyingGlass.prototype.onMouseMove = function () {
            this.bg2.x = -Laya.stage.mouseX * 2;
            this.bg2.y = -Laya.stage.mouseY * 2;
            this.maskSp.x = Laya.stage.mouseX;
            this.maskSp.y = Laya.stage.mouseY;
            this.bg2.repaint();
        };
        return Sprite_MagnifyingGlass;
    }());
    laya.Sprite_MagnifyingGlass = Sprite_MagnifyingGlass;
})(laya || (laya = {}));
new laya.Sprite_MagnifyingGlass();
