var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var ColorFilter = Laya.ColorFilter;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var Filters_Color = (function () {
        function Filters_Color() {
            this.ApePath = "../../res/apes/monkey2.png";
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Laya.loader.load(this.ApePath, Handler.create(this, this.setup));
        }
        Filters_Color.prototype.setup = function () {
            this.normalizeApe();
            this.makeRedApe();
            this.grayingApe();
        };
        Filters_Color.prototype.normalizeApe = function () {
            var originalApe = this.createApe();
            this.apeTexture = Laya.loader.getRes(this.ApePath);
            originalApe.x = (Laya.stage.width - this.apeTexture.width * 3) / 2;
            originalApe.y = (Laya.stage.height - this.apeTexture.height) / 2;
        };
        Filters_Color.prototype.makeRedApe = function () {
            //由 20 个项目（排列成 4 x 5 矩阵）组成的数组，红色
            var redMat = [
                1, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 0, 0,
                0, 0, 0, 1, 0,
            ];
            //创建一个颜色滤镜对象,红色
            var redFilter = new ColorFilter(redMat);
            // 赤化猩猩
            var redApe = this.createApe();
            redApe.filters = [redFilter];
            var firstChild = Laya.stage.getChildAt(0);
            redApe.x = firstChild.x + this.apeTexture.width;
            redApe.y = firstChild.y;
        };
        Filters_Color.prototype.grayingApe = function () {
            //由 20 个项目（排列成 4 x 5 矩阵）组成的数组，灰图
            var grayscaleMat = [0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0];
            //创建一个颜色滤镜对象，灰图
            var grayscaleFilter = new ColorFilter(grayscaleMat);
            // 灰度猩猩
            var grayApe = this.createApe();
            grayApe.filters = [grayscaleFilter];
            var secondChild = Laya.stage.getChildAt(1);
            grayApe.x = secondChild.x + this.apeTexture.width;
            grayApe.y = secondChild.y;
        };
        Filters_Color.prototype.createApe = function () {
            var ape = new Sprite();
            ape.loadImage("../../res/apes/monkey2.png");
            Laya.stage.addChild(ape);
            return ape;
        };
        return Filters_Color;
    }());
    laya.Filters_Color = Filters_Color;
})(laya || (laya = {}));
new laya.Filters_Color();
