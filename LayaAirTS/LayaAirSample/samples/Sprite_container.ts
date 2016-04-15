/// <reference path="../../libs/LayaAir.d.ts" />
module sprites {
    import Sprite = laya.display.Sprite;
    import Event = laya.events.Event;
    import WebGL = laya.webgl.WebGL;

    export class SpriteContainer {
        // 该容器用于装载4张猩猩图片
        private apesCtn:Sprite;

        constructor() {
            Laya.init(500, 500);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            // 每只猩猩距离中心点150像素
            var layoutRadius:number = 150;
            var radianUnit:number = Math.PI / 2;

            this.apesCtn = new Sprite();
            Laya.stage.addChild(this.apesCtn);

            // 添加4张猩猩图片
            for (var i:number = 0; i < 4; i++) {
                var ape:Sprite = new Sprite();
                ape.loadImage("res/apes/monkey" + i + ".png");

                ape.pivot(55, 72);

                // 以圆周排列猩猩
                ape.pos(
                    Math.cos(radianUnit * i) * layoutRadius,
                    Math.sin(radianUnit * i) * layoutRadius);

                this.apesCtn.addChild(ape);
            }

            // 将容器移动到舞台中央
            this.apesCtn.pos(250, 250);

            Laya.timer.frameLoop(1, this, this.animate);
        }

        private animate(e:Event):void {
            this.apesCtn.rotation += 1;
        }
    }
}
new sprites.SpriteContainer()