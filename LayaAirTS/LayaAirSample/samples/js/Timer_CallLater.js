/// <reference path="../../libs/LayaAir.d.ts" />
var CallLater = (function () {
    function CallLater() {
        Laya.init(550, 400);
        Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
        for (var i = 0; i < 10; i++) {
            Laya.timer.callLater(this, this.onCallLater);
        }
    }
    CallLater.prototype.onCallLater = function () {
        console.log("onCallLater triggered");
        var text = new laya.display.Text();
        text.font = "SimHei";
        text.fontSize = 30;
        text.color = "#FFFFFF";
        text.pos(30, 180);
        text.text = "打开控制台可见该函数仅触发了一次";
        Laya.stage.addChild(text);
    };
    return CallLater;
}());
new CallLater();
