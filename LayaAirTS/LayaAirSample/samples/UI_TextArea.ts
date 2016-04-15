/// <reference path="../../libs/LayaAir.d.ts" />
module ui {
    import TextArea=laya.ui.TextArea;
    import Handler=laya.utils.Handler;

    export class TextAreaSample 
    {
        private skin:string = "res/ui/textarea.png";

        constructor()
        {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load(this.skin, Handler.create(this, this.onLoadComplete));//加载资源。
        }

        private  onLoadComplete():void 
        {
            var ta:TextArea = new TextArea("");
            ta.skin = this.skin;

            ta.inputElementXAdjuster = -2;
            ta.inputElementYAdjuster = -1;
             
            ta.font = "Arial";
            ta.fontSize = 20;
            ta.bold = true;
             
            ta.color = "#3d3d3d";
             
            ta.pos(100, 15);
            ta.size(375, 355);
            
            ta.padding = "70,8,8,8";

            Laya.stage.addChild(ta);
        }
    }
}
new ui.TextAreaSample();