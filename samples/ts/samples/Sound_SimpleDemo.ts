/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
    import Sprite = laya.display.Sprite;
    import Stage = laya.display.Stage;
    import Text = laya.display.Text;
    import Event = laya.events.Event;
    import SoundManager = laya.media.SoundManager;
    import Browser = laya.utils.Browser;
    import Handler = laya.utils.Handler;
    import WebGL = laya.webgl.WebGL;

    export class Sound_SimpleDemo {
        //声明一个信息文本
        private txtInfo: Text;

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
            var gap: number = 10;

            //创建一个Sprite充当音效播放按钮
            var soundButton: Sprite = this.createButton("播放音效");
            soundButton.x = (Laya.stage.width - soundButton.width * 2 + gap) / 2;
            soundButton.y = (Laya.stage.height - soundButton.height) / 2;
            Laya.stage.addChild(soundButton);

            //创建一个Sprite充当音乐播放按钮
            var musicButton: Sprite = this.createButton("播放音乐");
            musicButton.x = soundButton.x + gap + soundButton.width;
            musicButton.y = soundButton.y;
            Laya.stage.addChild(musicButton);

            soundButton.on(Event.CLICK, this, this.onPlaySound);
            musicButton.on(Event.CLICK, this, this.onPlayMusic);
        }

        private createButton(label: string): Sprite {
            var w: number = 110;
            var h: number = 40;

            var button: Sprite = new Sprite();
            button.size(w, h);
            button.graphics.drawRect(0, 0, w, h, "#FF7F50");
            button.graphics.fillText(label, w / 2, 8, "25px SimHei", "#FFFFFF", "center");
            Laya.stage.addChild(button);
            return button;
        }

        private onPlayMusic(e: Event): void {
            console.log("播放音乐");
            SoundManager.playMusic("res/sounds/bgm.mp3", 1, new Handler(this, this.onComplete));
        }

        private onPlaySound(e: Event): void {
            console.log("播放音效");
            SoundManager.playSound("res/sounds/btn.mp3", 1, new Handler(this, this.onComplete));
        }

        private onComplete(): void {
            console.log("播放完成");
        }
    }
} new laya.Sound_SimpleDemo();