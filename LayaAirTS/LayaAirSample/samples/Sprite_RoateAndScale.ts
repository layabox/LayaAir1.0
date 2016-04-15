/// <reference path="../../libs/LayaAir.d.ts" />
module sprites {
    import Sprite = laya.display.Sprite;
    import Event = laya.events.Event;

    export class RoateAndScale {
        private ape: Sprite;
        private scaleDelta: number = 0;
        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            this.ape = new Sprite();

            this.ape.loadImage("res/apes/monkey2.png");
            Laya.stage.addChild(this.ape);
            this.ape.pivot(55, 72);
            this.ape.x = 275;
            this.ape.y = 200;

            Laya.timer.frameLoop(1, this, this.animate);
        }

        private animate(e: Event): void {
            this.ape.rotation += 2;

            //心跳缩放
            this.scaleDelta += 0.02;
            var scaleValue: number = Math.sin(this.scaleDelta);
            this.ape.scale(scaleValue, scaleValue);
        }
    }

}
new sprites.RoateAndScale()