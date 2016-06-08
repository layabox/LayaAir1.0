/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
    import Sprite = laya.display.Sprite;
    import Stage = laya.display.Stage;
    import Event = laya.events.Event;
    import Browser = laya.utils.Browser;
    import WebGL = laya.webgl.WebGL;

    export class Interaction_Rotate {
        private sp: Sprite;
        private preRadian: number = 0;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";

            this.setup();
        }

        private setup(): void {
            this.createSprite();

            Laya.stage.on(Event.MOUSE_UP, this, this.onMouseUp);
            Laya.stage.on(Event.MOUSE_OUT, this, this.onMouseUp);
        }

        private createSprite(): void {
            this.sp = new Sprite();
            var w: number = 200, h: number = 300;
            this.sp.graphics.drawRect(0, 0, w, h, "#FF7F50");
            this.sp.size(w, h);
            this.sp.pivot(w / 2, h / 2);
            this.sp.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            Laya.stage.addChild(this.sp);

            this.sp.on(Event.MOUSE_DOWN, this, this.onMouseDown);
        }

        private onMouseDown(e: Event): void {
            var touches: Array<any> = e.touches;

            if (touches && touches.length == 2) {
                this.preRadian = Math.atan2(
                    touches[0].stageY - touches[1].stageY,
                    touches[0].stageX - touches[1].stageX);

                Laya.stage.on(Event.MOUSE_MOVE, this, this.onMouseMove);
            }
        }

        private onMouseMove(e: Event): void {
            var touches: Array<any> = e.touches;
            var nowRadian: number = Math.atan2(
                touches[0].stageY - touches[1].stageY,
                touches[0].stageX - touches[1].stageX);

            this.sp.rotation += 180 / Math.PI * (nowRadian - this.preRadian);

            this.preRadian = nowRadian;
        }

        private onMouseUp(e: Event): void {
            Laya.stage.off(Event.MOUSE_MOVE, this, this.onMouseMove);
        }
    }
} new laya.Interaction_Rotate();