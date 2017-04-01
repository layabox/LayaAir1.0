module laya {
    import Stage = Laya.Stage;
    import RadioGroup = Laya.RadioGroup;
    import Handler = Laya.Handler;
    import WebGL = Laya.WebGL;

    export class UI_RadioGroup {
        private SPACING: number = 150;
        private X_OFFSET: number = 200;
        private Y_OFFSET: number = 200;

        private skins: Array<string>;

        constructor(){
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            this.skins = ["../../res/ui/radioButton (1).png", "../../res/ui/radioButton (2).png", "../../res/ui/radioButton (3).png"];
            Laya.loader.load(this.skins, Handler.create(this, this.initRadioGroups));
        }

        private initRadioGroups(): void {
            for (var i: number = 0; i < this.skins.length; ++i) {
                var rg: RadioGroup = this.createRadioGroup(this.skins[i]);
                rg.selectedIndex = i;
                rg.x = i * this.SPACING + this.X_OFFSET;
                rg.y = this.Y_OFFSET;
            }
        }

        private createRadioGroup(skin: string): RadioGroup {
            var rg: RadioGroup = new RadioGroup();
            rg.skin = skin;

            rg.space = 70;
            rg.direction = "v";

            rg.labels = "Item1, Item2, Item3";
            rg.labelColors = "#787878,#d3d3d3,#FFFFFF";
            rg.labelSize = 20;
            rg.labelBold = true;
            rg.labelPadding = "5,0,0,5";

            rg.selectHandler = new Handler(this, this.onSelectChange);
            Laya.stage.addChild(rg);

            return rg;
        }

        private onSelectChange(index: number): void {
            console.log("你选择了第 " + (index + 1) + " 项");
        }
    }
}
new laya.UI_RadioGroup();