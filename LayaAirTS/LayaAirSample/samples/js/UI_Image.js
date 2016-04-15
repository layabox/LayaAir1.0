/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var Image = laya.ui.Image;
    var ImageSample = (function () {
        function ImageSample() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            var dialog = new Image("res/ui/dialog (3).png");
            dialog.pos(165, 62.5);
            Laya.stage.addChild(dialog);
        }
        return ImageSample;
    }());
    ui.ImageSample = ImageSample;
})(ui || (ui = {}));
new ui.ImageSample();
