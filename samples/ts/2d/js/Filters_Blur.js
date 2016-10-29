var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var BlurFilter = Laya.BlurFilter;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var Filters_Blur = (function () {
        function Filters_Blur() {
            this.apePath = "../../res/apes/monkey2.png";
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Laya.loader.load(this.apePath, Handler.create(this, this.createApe));
        }
        Filters_Blur.prototype.createApe = function () {
            var ape = new Sprite();
            ape.loadImage(this.apePath);
            ape.x = (Laya.stage.width - ape.width) / 2;
            ape.y = (Laya.stage.height - ape.height) / 2;
            Laya.stage.addChild(ape);
            this.applayFilter(ape);
        };
        Filters_Blur.prototype.applayFilter = function (ape) {
            var blurFilter = new BlurFilter();
            blurFilter.strength = 5;
            ape.filters = [blurFilter];
        };
        return Filters_Blur;
    }());
    laya.Filters_Blur = Filters_Blur;
})(laya || (laya = {}));
new laya.Filters_Blur();
