/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
    import Animation = laya.display.Animation;
    import Stage = laya.display.Stage;
    import Browser = laya.utils.Browser;
    import Handler = laya.utils.Handler;
    import Tween = laya.utils.Tween;
    import WebGL = laya.webgl.WebGL;

    export class BlendMode_Lighter {
        // 一只凤凰的分辨率是550 * 400
        private phoenixWidth: number = 550;
        private phoenixHeight: number = 400;

        private bgColorTweener: Tween = new Tween();
        private gradientInterval: number = 2000;
        private bgColorChannels: any = { r: 99, g: 0, b: 0xFF };

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(this.phoenixWidth * 2, this.phoenixHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";

            this.setup();
        }

        private setup(): void {
            this.createPhoenixes();

            // 动态背景渲染
            this.evalBgColor();
            Laya.timer.frameLoop(1, this, this.renderBg);
        }

        private createPhoenixes(): void {
            var scaleFactor: number = Math.min(
                Laya.stage.width / (this.phoenixWidth * 2),
                Laya.stage.height / this.phoenixHeight);

            // 加了混合模式的凤凰
            var blendedPhoenix: Animation = this.createAnimation();
            blendedPhoenix.blendMode = "lighter";
            blendedPhoenix.scale(scaleFactor, scaleFactor);
            blendedPhoenix.y = (Laya.stage.height - this.phoenixHeight * scaleFactor) / 2;

            // 正常模式的凤凰
            var normalPhoenix: Animation = this.createAnimation();
            normalPhoenix.scale(scaleFactor, scaleFactor);
            normalPhoenix.x = this.phoenixWidth * scaleFactor;
            normalPhoenix.y = (Laya.stage.height - this.phoenixHeight * scaleFactor) / 2;
        }

        private createAnimation(): Animation {
            var frames: Array<string> = [];
            for (var i: number = 1; i <= 25; ++i) {
                frames.push("res/phoenix/phoenix" + this.preFixNumber(i, 4) + ".jpg");
            }

            var animation: Animation = new Animation();
            animation.loadImages(frames);
            Laya.stage.addChild(animation);

            var clips: Array<string> = animation.frames.concat();
            // 反转帧
            clips = clips.reverse();
            // 添加到已有帧末尾
            animation.frames = animation.frames.concat(clips);

            animation.play();

            return animation;
        }

        private preFixNumber(num:number, strLen:number):string
        {
            return ("0000000000" + num).slice(-strLen);
        }

        private evalBgColor(): void {
            var color: number = Math.random() * 0xFFFFFF;
            var channels: Array<number> = this.getColorChannals(color);
            this.bgColorTweener.to(this.bgColorChannels, { r: channels[0], g: channels[1], b: channels[2] }, this.gradientInterval, null, Handler.create(this, this.onTweenComplete));
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
            Laya.stage.graphics.drawRect(
                0, (Laya.stage.height - this.phoenixHeight * Browser.pixelRatio) / 2,
                this.phoenixWidth, this.phoenixHeight, this.getHexColorString());
        }

        private getHexColorString(): string {
            this.bgColorChannels.r = Math.floor(this.bgColorChannels.r);
            // 绿色通道使用0
            this.bgColorChannels.g = 0;
            //obj.g = Math.floor(obj.g);
            this.bgColorChannels.b = Math.floor(this.bgColorChannels.b);

            var r: String = this.bgColorChannels.r.toString(16);
            r = r.length == 2 ? r : "0" + r;
            var g: String = this.bgColorChannels.g.toString(16);
            g = g.length == 2 ? g : "0" + g;
            var b: String = this.bgColorChannels.b.toString(16);
            b = b.length == 2 ? b : "0" + b;
            return "#" + r + g + b;
        }
    }
}
new laya.BlendMode_Lighter();