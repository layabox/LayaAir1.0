module laya {
    import Sprite = Laya.Sprite;
    import Stage = Laya.Stage;
    import Event = Laya.Event;
    import Browser = Laya.Browser;
    import WebGL = Laya.WebGL;

    export class Sprite_NodeControl {
        private ape1: Sprite;
        private ape2: Sprite;

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
            //显示两只猩猩
            this.ape1 = new Sprite();
            this.ape2 = new Sprite();
            this.ape1.loadImage("../../res/apes/monkey2.png");
            this.ape2.loadImage("../../res/apes/monkey2.png");

            this.ape1.pivot(55, 72);
            this.ape2.pivot(55, 72);

            this.ape1.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            this.ape2.pos(200, 0);

            //一只猩猩在舞台上，另一只被添加成第一只猩猩的子级
            Laya.stage.addChild(this.ape1);
            this.ape1.addChild(this.ape2);

            Laya.timer.frameLoop(1, this, this.animate);
        }

        private animate(e: Event): void {
            this.ape1.rotation += 2;
            this.ape2.rotation -= 4;
        }
    }
}
new laya.Sprite_NodeControl();