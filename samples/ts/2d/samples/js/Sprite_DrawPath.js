/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Stage = laya.display.Stage;
    var Browser = laya.utils.Browser;
    var WebGL = laya.webgl.WebGL;
    var Sprite_DrawPath = (function () {
        function Sprite_DrawPath() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.drawPentagram();
        }
        Sprite_DrawPath.prototype.drawPentagram = function () {
            var canvas = new Sprite();
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
            canvas.graphics.drawPoly(Laya.stage.width / 2, Laya.stage.height / 2, path, "#FF7F50");
        };
        return Sprite_DrawPath;
    }());
    laya.Sprite_DrawPath = Sprite_DrawPath;
})(laya || (laya = {}));
new laya.Sprite_DrawPath();
