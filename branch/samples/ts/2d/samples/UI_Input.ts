module laya {
    import Stage = Laya.Stage;
    import TextInput = Laya.TextInput;
    import Handler = Laya.Handler;
    import WebGL = Laya.WebGL;

    export class UI_Input {
        private SPACING: number = 100;
        private INPUT_WIDTH: number = 300;
        private INPUT_HEIGHT: number = 50;
        private Y_OFFSET: number = 50;
        private skins: Array<string>;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            this.skins = ["../../res/ui/input (1).png", "../../res/ui/input (2).png", "../../res/ui/input (3).png", "../../res/ui/input (4).png"];
            Laya.loader.load(this.skins, Handler.create(this, this.onLoadComplete));//加载资源。
        }

        private onLoadComplete(): void {
            for (var i: number = 0; i < this.skins.length; ++i) {
                var input: TextInput = this.createInput(this.skins[i]);
                input.prompt = 'Type:';
                input.x = (Laya.stage.width - input.width) / 2;
                input.y = i * this.SPACING + this.Y_OFFSET;
            }
        }

        private createInput(skin: string): TextInput {
            var ti: TextInput = new TextInput();

            ti.skin = skin;
            ti.size(300, 50);
            ti.sizeGrid = "0,40,0,40";
            ti.font = "Arial";
            ti.fontSize = 30;
            ti.bold = true;
            ti.color = "#606368";

            Laya.stage.addChild(ti);

            return ti;
        }
    }
}
new laya.UI_Input();