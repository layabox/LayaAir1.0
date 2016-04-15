/// <reference path="../../libs/LayaAir.d.ts" />
var Orientation_Portrait = (function () {
    function Orientation_Portrait() {
        Laya.init(550, 400);
        Laya.stage.scaleMode = laya.display.Stage.SCALE_NOSCALE;
        Laya.stage.screenMode = laya.display.Stage.SCREEN_VERTICAL;
        showText();
        function showText() {
            var text = new laya.display.Text();
            text.text = "Orientation-Portrait";
            text.color = "dimgray";
            text.font = "Impact";
            text.fontSize = 50;
            text.x = Laya.stage.width - text.width >> 1;
            text.y = Laya.stage.height - text.height >> 1;
            Laya.stage.addChild(text);
        }
    }
    return Orientation_Portrait;
}());
new Orientation_Portrait();
