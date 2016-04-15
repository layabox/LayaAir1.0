/// <reference path="../../libs/LayaAir.d.ts" />
module ui {
    import TextInput = laya.ui.TextInput;
    import Handler = laya.utils.Handler;

    export class InputSample 
    {
        private SPACING:number = 100;
        private INPUT_WIDTH:number = 300;
        private INPUT_HEIGHT:number = 50;
        private X_OFFSET:number = 125;
        private Y_OFFSET:number = 20;
        private skins:Array<string>;

        constructor()
        {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            this.skins = ["res/ui/input (1).png", "res/ui/input (2).png", "res/ui/input (3).png", "res/ui/input (4).png"];
            Laya.loader.load(this.skins, Handler.create(this, this.onLoadComplete));//加载资源。
        }

        private onLoadComplete():void
        {
            for (var i:number = 0; i < this.skins.length; ++i) 
            {
                var input:TextInput = this.createInput(this.skins[i]);
                input.x = this.X_OFFSET;
                input.y = i * this.SPACING + this.Y_OFFSET;
            }
        }

        private createInput(skin:string):TextInput
        {
            var ti:TextInput = new TextInput("");

            ti.inputElementXAdjuster = -1;
            ti.inputElementYAdjuster = 1;

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
new ui.InputSample();