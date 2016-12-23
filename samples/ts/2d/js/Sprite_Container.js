var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Sprite_Container = (function () {
        function Sprite_Container() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.createApes();
        }
        Sprite_Container.prototype.createApes = function () {
            // 每只猩猩距离中心点150像素
            var layoutRadius = 150;
            var radianUnit = Math.PI / 2;
            this.apesCtn = new Sprite();
            Laya.stage.addChild(this.apesCtn);
            // 添加4张猩猩图片
            for (var i = 0; i < 4; i++) {
                var ape = new Sprite();
                ape.loadImage("../../res/apes/monkey" + i + ".png");
                ape.pivot(55, 72);
                // 以圆周排列猩猩
                ape.pos(Math.cos(radianUnit * i) * layoutRadius, Math.sin(radianUnit * i) * layoutRadius);
                this.apesCtn.addChild(ape);
            }
            this.apesCtn.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            Laya.timer.frameLoop(1, this, this.animate);
        };
        Sprite_Container.prototype.animate = function (e) {
            this.apesCtn.rotation += 1;
        };
        return Sprite_Container;
    }());
    laya.Sprite_Container = Sprite_Container;
})(laya || (laya = {}));
new laya.Sprite_Container();
