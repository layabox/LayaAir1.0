module laya {
    import Sprite = Laya.Sprite;
    import Stage = Laya.Stage;
    import Event = Laya.Event;
    import Browser = Laya.Browser;
    import WebGL = Laya.WebGL;

    export class Timer_DelayExcute {
        private button1: Sprite;
        private button2: Sprite;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            this.setup();
        }

        private setup(): void {
            var vGap: number = 100;

            this.button1 = this.createButton("点我3秒之后 alpha - 0.5");
            this.button1.x = (Laya.stage.width - this.button1.width) / 2;
            this.button1.y = (Laya.stage.height - this.button1.height - vGap) / 2;
            Laya.stage.addChild(this.button1);
            this.button1.on(Event.CLICK, this, this.onDecreaseAlpha1);

            this.button2 = this.createButton("点我60帧之后 alpha - 0.5");
            this.button2.pos(this.button1.x, this.button1.y + vGap);
            Laya.stage.addChild(this.button2);
            this.button2.on(Event.CLICK, this, this.onDecreaseAlpha2);
        }

        private createButton(label: string): Sprite {
            var w: number = 300, h: number = 60;

            var button: Sprite = new Sprite();
            button.graphics.drawRect(0, 0, w, h, "#FF7F50");
            button.size(w, h);
            button.graphics.fillText(label, w / 2, 17, "20px simHei", "#ffffff", "center");
            return button;
        }

        private onDecreaseAlpha1(e: Event): void {
            //移除鼠标单击事件
            this.button1.off(Event.CLICK, this, this.onDecreaseAlpha1);
            //定时执行一次(间隔时间)
            Laya.timer.once(3000, this, this.onComplete1);
        }

        private onDecreaseAlpha2(e: Event): void {
            //移除鼠标单击事件
            this.button2.off(Event.CLICK, this, this.onDecreaseAlpha2);
            //定时执行一次(基于帧率)
            Laya.timer.frameOnce(60, this, this.onComplete2);
        }

        private onComplete1(): void {
            //spBtn1的透明度减少0.5
            this.button1.alpha -= 0.5;
        }

        private onComplete2(): void {
            //spBtn2的透明度减少0.5
            this.button2.alpha -= 0.5;
        }
    }
}
new laya.Timer_DelayExcute();