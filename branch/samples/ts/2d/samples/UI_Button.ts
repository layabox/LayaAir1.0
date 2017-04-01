module laya {
    import Stage = Laya.Stage;
    import Button = Laya.Button;
    import Handler = Laya.Handler;
    import WebGL = Laya.WebGL;

    export class UI_Button {
        private COLUMNS: number = 2;
        private BUTTON_WIDTH: number = 147;
        private BUTTON_HEIGHT: number = 165 / 3;
        private HORIZONTAL_SPACING: number = 200;
        private VERTICAL_SPACING: number = 100;

        private xOffset: number;
        private yOffset: number;

        private skins: Array<string>;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            this.skins = [
                "../../res/ui/button-1.png", "../../res/ui/button-2.png", "../../res/ui/button-3.png",
                "../../res/ui/button-4.png", "../../res/ui/button-5.png", "../../res/ui/button-6.png"
            ];

            // 计算将Button至于舞台中心的偏移量
            this.xOffset = (Laya.stage.width - this.HORIZONTAL_SPACING * (this.COLUMNS - 1) - this.BUTTON_WIDTH) / 2;
            this.yOffset = (Laya.stage.height - this.VERTICAL_SPACING * (this.skins.length / this.COLUMNS - 1) - this.BUTTON_HEIGHT) / 2;

            Laya.loader.load(this.skins, Handler.create(this, this.onUIAssetsLoaded));
        }

        private onUIAssetsLoaded(): void {
            for (var i: number = 0, len = this.skins.length; i < len; ++i) {
                var btn: Button = this.createButton(this.skins[i]);
                var x: number = i % this.COLUMNS * this.HORIZONTAL_SPACING + this.xOffset;
                var y: number = (i / this.COLUMNS | 0) * this.VERTICAL_SPACING + this.yOffset;
                btn.pos(x, y);
            }
        }

        private createButton(skin: string): Button {
            var btn: Button = new Button(skin);
            Laya.stage.addChild(btn);
            return btn;
        }
    }
}
new laya.UI_Button();