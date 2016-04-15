/// <reference path="../../libs/LayaAir.d.ts" />
module sprites {
    import Sprite = laya.display.Sprite;
    import Event = laya.events.Event;

    export class SpritePivot {
        private sp1: Sprite;
        private sp2: Sprite;
        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            this.sp1 = new Sprite();
            this.sp1.loadImage("res/apes/monkey2.png", 0, 0);

            this.sp1.pos(150, 200);
            this.sp1.size(110, 145);
            //设置轴心点为中心
            this.sp1.pivot(55, 72);
            Laya.stage.addChild(this.sp1);

            //不设置轴心点默认为左上角
            this.sp2 = new Sprite();
            this.sp2.loadImage("res/apes/monkey2.png", 0, 0);
            this.sp2.size(110, 145);
            this.sp2.pos(400, 200);
            Laya.stage.addChild(this.sp2);

            Laya.timer.frameLoop(1, this, this.animate);
        }

        private animate(e: Event): void {
            this.sp1.rotation += 2;
            this.sp2.rotation += 2;
        }
    }

}
new sprites.SpritePivot()