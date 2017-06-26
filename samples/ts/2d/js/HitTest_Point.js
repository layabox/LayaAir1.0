var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var HitTest_Point = (function () {
        function HitTest_Point() {
            Laya.init(800, 600);
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            var size = 200;
            var color = "orange";
            this.rect = new Sprite();
            this.rect.graphics.drawRect(0, 0, size, size, color);
            this.rect.size(size, size);
            this.rect.x = (Laya.stage.width - this.rect.width) / 2;
            this.rect.y = (Laya.stage.height - this.rect.height) / 2;
            Laya.stage.addChild(this.rect);
            Laya.timer.frameLoop(1, this, this.loop);
        }
        HitTest_Point.prototype.loop = function () {
            var hit = this.rect.hitTestPoint(Laya.stage.mouseX, Laya.stage.mouseY);
            this.rect.alpha = hit ? 0.5 : 1;
        };
        return HitTest_Point;
    }());
    laya.HitTest_Point = HitTest_Point;
})(laya || (laya = {}));
new laya.HitTest_Point();
