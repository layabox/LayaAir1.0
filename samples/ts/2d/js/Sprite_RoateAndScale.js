var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Sprite_RoateAndScale = (function () {
        function Sprite_RoateAndScale() {
            this.scaleDelta = 0;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.createApe();
        }
        Sprite_RoateAndScale.prototype.createApe = function () {
            this.ape = new Sprite();
            this.ape.loadImage("../../res/apes/monkey2.png");
            Laya.stage.addChild(this.ape);
            this.ape.pivot(55, 72);
            this.ape.x = Laya.stage.width / 2;
            this.ape.y = Laya.stage.height / 2;
            Laya.timer.frameLoop(1, this, this.animate);
        };
        Sprite_RoateAndScale.prototype.animate = function (e) {
            this.ape.rotation += 2;
            //心跳缩放
            this.scaleDelta += 0.02;
            var scaleValue = Math.sin(this.scaleDelta);
            this.ape.scale(scaleValue, scaleValue);
        };
        return Sprite_RoateAndScale;
    }());
    laya.Sprite_RoateAndScale = Sprite_RoateAndScale;
})(laya || (laya = {}));
new laya.Sprite_RoateAndScale();
