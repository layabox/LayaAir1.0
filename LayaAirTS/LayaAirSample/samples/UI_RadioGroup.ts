/// <reference path="../../libs/LayaAir.d.ts" />
module ui {
    import RadioGroup = laya.ui.RadioGroup;
    import Handler = laya.utils.Handler;
    export class RadioSample 
    {
        private SPACING:number = 150;
        private X_OFFSET:number = 60;
        private Y_OFFSET:number = 120;

        private skins:Array<string>;

        constructor() 
        {
            Laya.init(800, 500);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            this.skins = ["res/ui/radioButton (1).png", "res/ui/radioButton (2).png", "res/ui/radioButton (3).png"];
            Laya.loader.load(this.skins, Handler.create(this, this.initRadioGroups));
        }

        private initRadioGroups():void 
        {
            for (var i:number = 0; i < this.skins.length; ++i) 
            {
                var rg: RadioGroup = this.createRadioGroup(this.skins[i]);
                rg.selectedIndex = i;
                rg.x = i * this.SPACING + this.X_OFFSET;
                rg.y = this.Y_OFFSET;
            }
        }

        private createRadioGroup(skin:string):RadioGroup 
        {
            var rg:RadioGroup = new RadioGroup();
            rg.skin = skin;

            rg.space = 70;
            rg.direction = "v";

            rg.labels = "第一项,第二项,第三项";
            rg.labelSize = 20;
            rg.labelBold = true;
            rg.labelColors = "#787878,#d3d3d3,#FFFFFF";
            rg.labelPadding = "5,0,0,5";

            rg.selectHandler = new Handler(this, this.onSelectChange);
            Laya.stage.addChild(rg);

            return rg;
        }

        private onSelectChange(index:number):void {
            console.log("你选择了第 " + (index + 1) + " 项");
        }
    }
}
new ui.RadioSample();