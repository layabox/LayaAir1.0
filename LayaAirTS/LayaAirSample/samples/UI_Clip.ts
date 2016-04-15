/// <reference path="../../libs/LayaAir.d.ts" />
module ui {
    import Event = laya.events.Event;
    import Button = laya.ui.Button;
    import Clip = laya.ui.Clip;
    import Image = laya.ui.Image;

    export class ClipSample
    {
        private buttonSkin:string = "res/ui/button-7.png";
        private clipSkin:string = "res/ui/num0-9.png";
        private bgSkin:string = "res/ui/coutDown.png";
        private counter:Clip;
        private currFrame:number;
        private controller:Button;

        constructor()
        {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load([this.buttonSkin, this.clipSkin, this.bgSkin], laya.utils.Handler.create(this, this.onSkinLoaded));
        }

        private onSkinLoaded():void
        {
            this.showBg();
            this.createTimerAnimation();
            this.showTotalSeconds();
            this.createController();
        }

        private showBg():void 
        {
            var bg:Image = new Image(this.bgSkin);
            bg.pos(163, 50);
            Laya.stage.addChild(bg);
        }

        private createTimerAnimation():void
        {
            this.counter = new Clip(this.clipSkin, 10, 1);
            this.counter.autoPlay = true;
            this.counter.interval = 1000;

            this.counter.pos(223, 130);

            Laya.stage.addChild(this.counter);
        }

        private showTotalSeconds():void 
        {
            var clip: Clip = new Clip(this.clipSkin, 10, 1);
            clip.index = clip.clipX - 1;
            clip.pos(285, 130);
            Laya.stage.addChild(clip);
        }

        private createController():void 
        {
            this.controller = new Button(this.buttonSkin, "暂停");
            this.controller.labelBold = true;
            this.controller.labelColors = "#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF";

            this.controller.on('click', this, this.onClipSwitchState);

            this.controller.pos(230, 300);
            Laya.stage.addChild(this.controller);
        }

        private onClipSwitchState():void 
        {
            if (this.counter.isPlaying) 
            {
                this.counter.stop();
                this.currFrame = this.counter.index;
                this.controller.label = "播放";
            }
            else 
            {
                this.counter.play();
                this.counter.index = this.currFrame;
                this.controller.label = "暂停";
            }
        }    
    }
}
new ui.ClipSample();