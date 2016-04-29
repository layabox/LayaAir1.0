/// <reference path="../../libs/LayaAir.d.ts" />
var sprites;
(function (sprites) {
    var DrawPath = (function () {
        function DrawPath() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            var canvas = new laya.display.Sprite();
            Laya.stage.addChild(canvas);
            var path = [];
            path.push(0, -130);
            path.push(33, -33);
            path.push(137, -30);
            path.push(55, 32);
            path.push(85, 130);
            path.push(0, 73);
            path.push(-85, 130);
            path.push(-55, 32);
            path.push(-137, -30);
            path.push(-33, -33);
            canvas.graphics.drawPoly(275, 200, path, "#00ffff");
        }
        return DrawPath;
    }());
    sprites.DrawPath = DrawPath;
})(sprites || (sprites = {}));
new sprites.DrawPath();
