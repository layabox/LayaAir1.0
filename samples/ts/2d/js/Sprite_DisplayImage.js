var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var Sprite_DisplayImage = (function () {
        function Sprite_DisplayImage() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.showApe();
        }
        Sprite_DisplayImage.prototype.showApe = function () {
            // 方法1：使用loadImage
            var ape = new Sprite();
            Laya.stage.addChild(ape);
            ape.loadImage("../../res/apes/monkey3.png");
            // 方法2：使用drawTexture
            Laya.loader.load("../../res/apes/monkey2.png", Handler.create(this, function () {
                var t = Laya.loader.getRes("../../res/apes/monkey2.png");
                var ape = new Sprite();
                ape.graphics.drawTexture(t, 0, 0);
                Laya.stage.addChild(ape);
                ape.pos(200, 0);
            }));
        };
        return Sprite_DisplayImage;
    }());
    laya.Sprite_DisplayImage = Sprite_DisplayImage;
})(laya || (laya = {}));
new laya.Sprite_DisplayImage();
