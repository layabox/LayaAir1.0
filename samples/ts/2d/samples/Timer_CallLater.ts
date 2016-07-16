module laya {
    import Stage = laya.display.Stage;
    import Text = laya.display.Text;
    import Browser = laya.utils.Browser;
    import WebGL = laya.webgl.WebGL;

    export class Timer_CallLater {
        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            this.demonstrate();
        }

        private demonstrate(): void {
            for (var i: number = 0; i < 10; i++) {
                Laya.timer.callLater(this, this.onCallLater);
            }
        }

        private onCallLater(): void {
            console.log("onCallLater triggered");

            var text: Text = new Text();
            text.font = "SimHei";
            text.fontSize = 30;
            text.color = "#FFFFFF";
            text.text = "打开控制台可见该函数仅触发了一次";
            text.size(Laya.stage.width, Laya.stage.height);
            text.wordWrap = true;
            text.valign = "middle";
            text.align = "center";
            Laya.stage.addChild(text);
        }
    }
}
new laya.Timer_CallLater();