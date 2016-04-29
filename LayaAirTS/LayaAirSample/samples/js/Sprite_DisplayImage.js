/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Handler = laya.utils.Handler;
    var Sprite_DisplayImage = (function () {
        function Sprite_DisplayImage() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            // 方法1：使用loadImage
            var ape = new Sprite();
            Laya.stage.addChild(ape);
            ape.loadImage("res/apes/monkey3.png");
            // 方法2：使用drawTexture
            Laya.loader.load("res/apes/monkey2.png", Handler.create(this, function () {
                var t = Laya.loader.getRes("res/apes/monkey2.png");
                var ape = new Sprite();
                ape.graphics.drawTexture(t, 0, 0);
                Laya.stage.addChild(ape);
                ape.pos(200, 0);
            }));
        }
        return Sprite_DisplayImage;
    }());
    laya.Sprite_DisplayImage = Sprite_DisplayImage;
})(laya || (laya = {}));
new laya.Sprite_DisplayImage();
