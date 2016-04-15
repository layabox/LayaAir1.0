/// <reference path="../../libs/LayaAir.d.ts" />
var ui;
(function (ui) {
    var Button = laya.ui.Button;
    var Dialog = laya.ui.Dialog;
    var Handler = laya.utils.Handler;
    var Image = laya.ui.Image;
    var DialogSample = (function () {
        function DialogSample() {
            this.DIALOG_WIDTH = 220;
            this.DIALOG_HEIGHT = 275;
            this.CLOSE_BTN_WIDTH = 43;
            this.CLOSE_BTN_PADDING = 5;
            this.assets = ["res/ui/dialog (1).png", "res/ui/close.png"];
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load(this.assets, Handler.create(this, this.onSkinLoadComplete));
        }
        DialogSample.prototype.onSkinLoadComplete = function () {
            var dialog = new Dialog();
            var bg = new Image(this.assets[0]);
            dialog.addChild(bg);
            var button = new Button(this.assets[1]);
            button.name = Dialog.CLOSE;
            button.pos(this.DIALOG_WIDTH - this.CLOSE_BTN_WIDTH - this.CLOSE_BTN_PADDING, this.CLOSE_BTN_PADDING);
            dialog.addChild(button);
            dialog.dragArea = "0,0," + this.DIALOG_WIDTH + "," + this.DIALOG_HEIGHT;
            dialog.show();
        };
        return DialogSample;
    }());
    ui.DialogSample = DialogSample;
})(ui || (ui = {}));
new ui.DialogSample();
