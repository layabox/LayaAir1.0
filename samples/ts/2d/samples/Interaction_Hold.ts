module laya {
    import Sprite = Laya.Sprite;
    import Stage = Laya.Stage;
    import Event = Laya.Event;
    import Texture = Laya.Texture;
    import Browser = Laya.Browser;
    import Ease = Laya.Ease;
    import Handler = Laya.Handler;
    import Tween = Laya.Tween;
    import WebGL = Laya.WebGL;

    export class Interaction_Hold {
        private HOLD_TRIGGER_TIME: number = 1000;
        private apePath: string = "../../res/apes/monkey2.png";

        //触发hold事件时间为1秒
        private ape: Sprite;
        private isApeHold: Boolean;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";

            Laya.loader.load(this.apePath, Handler.create(this, this.createApe));
        }

        private createApe(): void {
            // 添加一只猩猩
            this.ape = new Sprite();
            this.ape.loadImage(this.apePath);

            var texture: Texture = Laya.loader.getRes(this.apePath);
            this.ape.pivot(texture.width / 2, texture.height / 2);
            this.ape.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            this.ape.scale(0.8, 0.8);
            Laya.stage.addChild(this.ape);

            // 鼠标交互
            this.ape.on(Event.MOUSE_DOWN, this, this.onApePress);
        }

        private onApePress(e: Event): void {
            // 鼠标按下后，HOLD_TRIGGER_TIME毫秒后hold
            Laya.timer.once(this.HOLD_TRIGGER_TIME, this, this.onHold);
            Laya.stage.on(Event.MOUSE_UP, this, this.onApeRelease);
        }

        private onHold(): void {
            Tween.to(this.ape, { "scaleX": 1, "scaleY": 1 }, 500, Ease.bounceOut);
            this.isApeHold = true;
        }

        /** 鼠标放开后停止hold */
        private onApeRelease(): void {
            // 鼠标放开时，如果正在hold，则播放放开的效果
            if (this.isApeHold) {
                this.isApeHold = false;
                Tween.to(this.ape, { "scaleX": 0.8, "scaleY": 0.8 }, 300);
            }
            else // 如果未触发hold，终止触发hold
                Laya.timer.clear(this, this.onHold);

            Laya.stage.off(Event.MOUSE_UP, this, this.onApeRelease);
        }
    }
} new laya.Interaction_Hold();