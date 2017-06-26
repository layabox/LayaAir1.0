var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Event = laya.events.Event;
    var HitTest_Rectangular = (function () {
        function HitTest_Rectangular() {
            Laya.init(800, 600);
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.rect1 = this.createCircle(100, "orange");
            this.rect2 = this.createCircle(200, "purple");
            Laya.timer.frameLoop(1, this, this.loop);
        }
        HitTest_Rectangular.prototype.createCircle = function (radius, color) {
            var rect = new Sprite();
            rect.graphics.drawRect(0, 0, radius, radius, color);
            rect.size(radius * 2, radius * 2);
            Laya.stage.addChild(rect);
            rect.on(Event.MOUSE_DOWN, this, this.startDrag, [rect]);
            rect.on(Event.MOUSE_UP, this, this.stopDrag, [rect]);
            return rect;
        };
        HitTest_Rectangular.prototype.startDrag = function (target) {
            target.startDrag();
        };
        HitTest_Rectangular.prototype.stopDrag = function (target) {
            target.stopDrag();
        };
        HitTest_Rectangular.prototype.loop = function () {
            var bounds1 = this.rect1.getBounds();
            var bounds2 = this.rect2.getBounds();
            var hit = bounds1.intersects(bounds2);
            this.rect1.alpha = this.rect2.alpha = hit ? 0.5 : 1;
        };
        return HitTest_Rectangular;
    }());
    laya.HitTest_Rectangular = HitTest_Rectangular;
})(laya || (laya = {}));
new laya.HitTest_Rectangular();
