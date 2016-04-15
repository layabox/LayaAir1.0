/// <reference path="../../libs/LayaAir.d.ts" />
var sprites;
(function (sprites) {
    var Sprite = laya.display.Sprite;
    var RoateAndScale = (function () {
        function RoateAndScale() {
            this.scaleDelta = 0;
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.ape = new Sprite();
            this.ape.loadImage("res/apes/monkey2.png");
            Laya.stage.addChild(this.ape);
            this.ape.pivot(55, 72);
            this.ape.x = 275;
            this.ape.y = 200;
            Laya.timer.frameLoop(1, this, this.animate);
        }
        RoateAndScale.prototype.animate = function (e) {
            this.ape.rotation += 2;
            //心跳缩放
            this.scaleDelta += 0.02;
            var scaleValue = Math.sin(this.scaleDelta);
            this.ape.scale(scaleValue, scaleValue);
        };
        return RoateAndScale;
    }());
    sprites.RoateAndScale = RoateAndScale;
})(sprites || (sprites = {}));
new sprites.RoateAndScale();
