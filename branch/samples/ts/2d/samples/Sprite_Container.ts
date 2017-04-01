module laya {
    import Sprite = Laya.Sprite;
    import Stage = Laya.Stage;
    import Event = Laya.Event;
    import Browser = Laya.Browser;
    import WebGL = Laya.WebGL;

    export class Sprite_Container {
        // 该容器用于装载4张猩猩图片
        private apesCtn: Sprite;

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
            // 每只猩猩距离中心点150像素
            var layoutRadius: number = 150;
            var radianUnit: number = Math.PI / 2;

            this.apesCtn = new Sprite();
            Laya.stage.addChild(this.apesCtn);

            // 添加4张猩猩图片
            for (var i: number = 0; i < 4; i++) {
                var ape: Sprite = new Sprite();
                ape.loadImage("../../res/apes/monkey" + i + ".png");

                ape.pivot(55, 72);

                // 以圆周排列猩猩
                ape.pos(
                    Math.cos(radianUnit * i) * layoutRadius,
                    Math.sin(radianUnit * i) * layoutRadius);

                this.apesCtn.addChild(ape);
            }

            this.apesCtn.pos(Laya.stage.width / 2, Laya.stage.height / 2);

            Laya.timer.frameLoop(1, this, this.animate);
        }

        private animate(e: Event): void {
            this.apesCtn.rotation += 1;
        }
    }
}
new laya.Sprite_Container();