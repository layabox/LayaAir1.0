module laya {
    import Stage = laya.display.Stage;
    import Button = laya.ui.Button;
    import Dialog = laya.ui.Dialog;
    import Image = laya.ui.Image;
    import Handler = laya.utils.Handler;
    import WebGL = laya.webgl.WebGL;

    export class UI_Dialog {
        private DIALOG_WIDTH: number = 220;
        private DIALOG_HEIGHT: number = 275;
        private CLOSE_BTN_WIDTH: number = 43;
        private CLOSE_BTN_PADDING: number = 5;

        private assets: Array<string>;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);    

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            this.assets = ["../../res/ui/dialog (1).png", "../../res/ui/close.png"];
            Laya.loader.load(this.assets, Handler.create(this, this.onSkinLoadComplete));
        }

        private onSkinLoadComplete(): void {
            var dialog: Dialog = new Dialog();

            var bg: Image = new Image(this.assets[0]);
            dialog.addChild(bg);

            var button: Button = new Button(this.assets[1]);
            button.name = Dialog.CLOSE;
            button.pos(this.DIALOG_WIDTH - this.CLOSE_BTN_WIDTH - this.CLOSE_BTN_PADDING, this.CLOSE_BTN_PADDING);
            dialog.addChild(button);

            dialog.dragArea = "0,0," + this.DIALOG_WIDTH + "," + this.DIALOG_HEIGHT;
            dialog.show();
        }
    }
}
new laya.UI_Dialog();