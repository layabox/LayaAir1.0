module laya {
    import Stage = Laya.Stage;
    import ComboBox = Laya.ComboBox;
    import Handler = Laya.Handler;
    import WebGL = Laya.WebGL;

    export class UI_ComboBox {
        private skin: string = "../../res/ui/combobox.png";

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            Laya.loader.load(this.skin, Handler.create(this, this.onLoadComplete));
        }

        private onLoadComplete(): void {
            var cb: ComboBox = this.createComboBox(this.skin);
            cb.autoSize = true;
            cb.pos((Laya.stage.width - cb.width) / 2, 100);
            cb.autoSize = false;
        }

        private createComboBox(skin: String): ComboBox {
            var comboBox: ComboBox = new ComboBox(this.skin, "item0,item1,item2,item3,item4,item5");
            comboBox.labelSize = 30;
            comboBox.itemSize = 25;
            comboBox.selectHandler = new Handler(this, this.onSelect, [comboBox]);
            Laya.stage.addChild(comboBox);

            return comboBox;
        }

        private onSelect(cb: ComboBox): void {
            console.log("选中了： " + cb.selectedLabel);
        }
    }
}
new laya.UI_ComboBox();