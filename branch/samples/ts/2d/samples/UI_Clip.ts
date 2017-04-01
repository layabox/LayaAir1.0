module laya {
    import Stage = Laya.Stage;
    import Button = Laya.Button;
    import Clip = Laya.Clip;
    import Image = Laya.Image;
    import Handler = Laya.Handler;
    import WebGL = Laya.WebGL;

    export class UI_Clip {
        private buttonSkin: string = "../../res/ui/button-7.png";
        private clipSkin: string = "../../res/ui/num0-9.png";
        private bgSkin: string = "../../res/ui/coutDown.png";

        private counter: Clip;
        private currFrame: number;
        private controller: Button;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            Laya.loader.load([this.buttonSkin, this.clipSkin, this.bgSkin], Laya.Handler.create(this, this.onSkinLoaded));
        }

        private onSkinLoaded(): void {
            this.showBg();
            this.createTimerAnimation();
            this.showTotalSeconds();
            this.createController();
        }

        private showBg(): void {
            var bg: Image = new Image(this.bgSkin);
            bg.size(224, 302);
            bg.pos(Laya.stage.width - bg.width >> 1, Laya.stage.height - bg.height >> 1);
            Laya.stage.addChild(bg);
        }

        private createTimerAnimation(): void {
            this.counter = new Clip(this.clipSkin, 10, 1);
            this.counter.autoPlay = true;
            this.counter.interval = 1000;

            this.counter.x = (Laya.stage.width - this.counter.width) / 2 - 35;
            this.counter.y = (Laya.stage.height - this.counter.height) / 2 - 40;

            Laya.stage.addChild(this.counter);
        }

        private showTotalSeconds(): void {
            var clip: Clip = new Clip(this.clipSkin, 10, 1);
            clip.index = clip.clipX - 1;
            clip.pos(this.counter.x + 60, this.counter.y);
            Laya.stage.addChild(clip);
        }

        private createController(): void {
            this.controller = new Button(this.buttonSkin, "暂停");
            this.controller.labelBold = true;
            this.controller.labelColors = "#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF";
            this.controller.size(84, 30);

            this.controller.on('click', this, this.onClipSwitchState);

            this.controller.x = (Laya.stage.width - this.controller.width) / 2;
            this.controller.y = (Laya.stage.height - this.controller.height) / 2 + 110;
            Laya.stage.addChild(this.controller);
        }

        private onClipSwitchState(): void {
            if (this.counter.isPlaying) {
                this.counter.stop();
                this.currFrame = this.counter.index;
                this.controller.label = "播放";
            }
            else {
                this.counter.play();
                this.counter.index = this.currFrame;
                this.controller.label = "暂停";
            }
        }
    }
}
new laya.UI_Clip();