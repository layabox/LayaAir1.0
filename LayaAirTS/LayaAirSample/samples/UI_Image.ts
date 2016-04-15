/// <reference path="../../libs/LayaAir.d.ts" />
module ui {
    import Image=laya.ui.Image;
    export  class ImageSample
    {
       constructor()
       {
           Laya.init(550, 400);
           Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

           var dialog:Image = new Image("res/ui/dialog (3).png");
           dialog.pos(165, 62.5);
           Laya.stage.addChild(dialog);
        }
    }
}
new ui.ImageSample();