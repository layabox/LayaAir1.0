var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var GlowFilter = Laya.GlowFilter;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var Filters_Glow = (function () {
        function Filters_Glow() {
            this.apePath = "../../res/apes/monkey2.png";
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Laya.loader.load(this.apePath, Handler.create(this, this.setup));
        }
        Filters_Glow.prototype.setup = function () {
            this.createApe();
            this.applayFilter();
        };
        Filters_Glow.prototype.createApe = function () {
            this.ape = new Sprite();
            this.ape.loadImage(this.apePath);
            var texture = Laya.loader.getRes(this.apePath);
            this.ape.x = (Laya.stage.width - texture.width) / 2;
            this.ape.y = (Laya.stage.height - texture.height) / 2;
            Laya.stage.addChild(this.ape);
        };
        Filters_Glow.prototype.applayFilter = function () {
            //创建一个发光滤镜
            var glowFilter = new GlowFilter("#ffff00", 10, 0, 0);
            //设置滤镜集合为发光滤镜
            this.ape.filters = [glowFilter];
        };
        return Filters_Glow;
    }());
    laya.Filters_Glow = Filters_Glow;
})(laya || (laya = {}));
new laya.Filters_Glow();
