module laya {
    import Stage = Laya.Stage;
    import CheckBox = Laya.CheckBox;
    import Handler = Laya.Handler;
    import WebGL = Laya.WebGL;

    export class UI_CheckBox {
        private COL_AMOUNT: number = 2;
        private ROW_AMOUNT: number = 3;
        private HORIZONTAL_SPACING: number = 200;
        private VERTICAL_SPACING: number = 100;
        private X_OFFSET: number = 100;
        private Y_OFFSET: number = 50;

        private skins: Array<string>;


        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            this.skins = ["../../res/ui/checkbox (1).png", "../../res/ui/checkbox (2).png", "../../res/ui/checkbox (3).png", "../../res/ui/checkbox (4).png", "../../res/ui/checkbox (5).png", "../../res/ui/checkbox (6).png"];

            Laya.loader.load(this.skins, Handler.create(this, this.onCheckBoxSkinLoaded));
        }

        private onCheckBoxSkinLoaded(): void {
            var cb: CheckBox;
            for (var i: number = 0; i < this.COL_AMOUNT; ++i) {
                for (var j: number = 0; j < this.ROW_AMOUNT; ++j) {
                    cb = this.createCheckBox(this.skins[i * this.ROW_AMOUNT + j]);
                    cb.selected = true;

                    cb.x = this.HORIZONTAL_SPACING * i + this.X_OFFSET;
                    cb.y += this.VERTICAL_SPACING * j + this.Y_OFFSET;

                    // 给左边的三个CheckBox添加事件使其能够切换标签
                    if (i == 0) {
                        cb.y += 20;
                        cb.on("change", this, this.updateLabel, [cb]);
                        this.updateLabel(cb);
                    }
                }
            }
        }

        private createCheckBox(skin: string): CheckBox {
            var cb: CheckBox = new CheckBox(skin);
            Laya.stage.addChild(cb);

            cb.labelColors = "white";
            cb.labelSize = 20;
            cb.labelFont = "Microsoft YaHei";
            cb.labelPadding = "3,0,0,5";

            return cb;
        }

        private updateLabel(checkBox: CheckBox): void {
            checkBox.label = checkBox.selected ? "已选中" : "未选中";
        }
    }
}
new laya.UI_CheckBox();