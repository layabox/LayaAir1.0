/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
    import Stage = laya.display.Stage;
    import TextArea = laya.ui.TextArea;
    import Browser = laya.utils.Browser;
    import Handler = laya.utils.Handler;
    import WebGL = laya.webgl.WebGL;

    export class UI_TextArea {
        private skin: string = "res/ui/textarea.png";

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(550, 400, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";


            Laya.loader.load(this.skin, Handler.create(this, this.onLoadComplete));
        }

        private onLoadComplete(): void {
            var ta: TextArea = new TextArea("");
            ta.skin = this.skin;

            ta.inputElementXAdjuster = -2;
            ta.inputElementYAdjuster = -1;

            ta.font = "Arial";
            ta.fontSize = 18;
            ta.bold = true;

            ta.color = "#3d3d3d";

            ta.pos(100, 15);
            ta.size(375, 355);

            ta.padding = "70,8,8,8";

            var scaleFactor: Number = Browser.pixelRatio;

            Laya.stage.addChild(ta);
        }
    }
}
new laya.UI_TextArea();