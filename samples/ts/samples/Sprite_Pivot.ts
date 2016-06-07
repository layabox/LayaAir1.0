/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
    import Sprite = laya.display.Sprite;
    import Stage = laya.display.Stage;
    import Event = laya.events.Event;
    import Browser = laya.utils.Browser;
    import WebGL = laya.webgl.WebGL;

    export class Sprite_Pivot {
        private sp1: Sprite;
        private sp2: Sprite;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";

            this.createApes();
        }

        private createApes(): void {
            var gap: number = 300;

            this.sp1 = new Sprite();
            this.sp1.loadImage("res/apes/monkey2.png", 0, 0);

            this.sp1.pos((Laya.stage.width - gap) / 2, Laya.stage.height / 2);
            //设置轴心点为中心
            this.sp1.pivot(55, 72);
            Laya.stage.addChild(this.sp1);

            //不设置轴心点默认为左上角
            this.sp2 = new Sprite();
            this.sp2.loadImage("res/apes/monkey2.png", 0, 0);
            this.sp2.pos((Laya.stage.width + gap) / 2, Laya.stage.height / 2);
            Laya.stage.addChild(this.sp2);

            Laya.timer.frameLoop(1, this, this.animate);
        }

        private animate(e: Event): void {
            this.sp1.rotation += 2;
            this.sp2.rotation += 2;
        }
    }
}
new laya.Sprite_Pivot();