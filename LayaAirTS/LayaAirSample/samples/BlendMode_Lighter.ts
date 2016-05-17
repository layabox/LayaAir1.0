/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
    import Animation = laya.display.Animation;
    import Sprite = laya.display.Sprite;
    import Handler = laya.utils.Handler;
    import Tween = laya.utils.Tween;
    import Utils = laya.utils.Utils;
    import Graphics = laya.display.Graphics;

    export class BlendMode_Lighter {
        private w: number = 1000;
        private h: number = 400;
        private tween: Tween = new Tween();
        private duration: number = 2000;
        private obj: any = { r: 99, g: 0, b: 0xFF };

        constructor() {
            Laya.init(this.w, this.h);

            this.createAnimation().blendMode = "lighter";
            this.createAnimation().pos(500, 0);
            this.evalBgColor();

            Laya.timer.frameLoop(1, this, this.renderBg);
        }

        private createAnimation(): Animation {
            var frames: Array<string> = [];
            for (var i: number = 1; i <= 25; ++i) {
                frames.push("res/phoenix/phoenix" + Utils.preFixNumber(i, 4) + ".jpg");
            }

            var animation: Animation = new Animation();
            animation.loadImages(frames);
            Laya.stage.addChild(animation);

            var clips: Array<any> = animation.frames.concat();
            // 反转帧
            clips = clips.reverse();
            // 添加到已有帧末尾
            animation.frames = animation.frames.concat(clips);

            animation.play();

            return animation;
        }

        private evalBgColor(): void {
            var color: number = Math.random() * 0xFFFFFF;
            var channels: Array<number> = this.getColorChannals(color);
            this.tween.to(this.obj, { r: channels[0], g: channels[1], b: channels[2] }, this.duration, null, Handler.create(this, this.onTweenComplete));
        }

        private getColorChannals(color: number): Array<number> {
            var result: Array<number> = [];
            result.push(color >> 16);
            result.push(color >> 8 & 0xFF);
            result.push(color & 0xFF);
            return result;
        }

        private onTweenComplete(): void {
            this.evalBgColor();
        }

        private renderBg(): void {
            Laya.stage.graphics.clear();
            Laya.stage.graphics.drawRect(0, 0, this.w, this.h, this.getColor());
        }

        private getColor(): string {
            this.obj.r = Math.floor(this.obj.r);
            // 绿色通道使用0
            this.obj.g = 0;
            //this.obj.g = Math.floor(this.obj.g);
            this.obj.b = Math.floor(this.obj.b);

            var r: String = this.obj.r.toString(16);
            r = r.length == 2 ? r : "0" + r;
            var g: String = this.obj.g.toString(16);
            g = g.length == 2 ? g : "0" + g;
            var b: String = this.obj.b.toString(16);
            b = b.length == 2 ? b : "0" + b;
            return "#" + r + g + b;
        }

    }
}
new laya.BlendMode_Lighter();