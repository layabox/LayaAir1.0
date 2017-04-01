module laya {
    import Sprite = Laya.Sprite;
    import Stage = Laya.Stage;
    import Event = Laya.Event;
    import Browser = Laya.Browser;
    import WebGL = Laya.WebGL;

    export class Sprite_RoateAndScale {
        private ape: Sprite;
        private scaleDelta: number = 0;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";

            this.createApe();
        }

        private createApe(): void {
            this.ape = new Sprite();

            this.ape.loadImage("../../res/apes/monkey2.png");
            Laya.stage.addChild(this.ape);
            this.ape.pivot(55, 72);
            this.ape.x = Laya.stage.width / 2;
            this.ape.y = Laya.stage.height / 2;

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
new laya.Sprite_RoateAndScale();