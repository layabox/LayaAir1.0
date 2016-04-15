/// <reference path="../../libs/LayaAir.d.ts" />
module sounds {
    import Sprite = laya.display.Sprite;
    import Text = laya.display.Text;
    import Event = laya.events.Event;
    import Handler = laya.utils.Handler;
    import SoundManager = laya.media.SoundManager;
    import Utils = laya.utils.Utils;
    export class SoundSimple {
        //声明一个信息文本
        private txtInfo: Text;
        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            //创建一个Sprite充当音效播放按钮
            var spBtnSound: Sprite = new Sprite();

            //绘制按钮
            spBtnSound.graphics.drawRect(0, 0, 110, 51, "#ff0000", "#ff0000", 1);
            spBtnSound.graphics.fillText("播放音效", 10, 10, "", "#ffffff", "left");

            spBtnSound.pos(17, 18);
            spBtnSound.size(100, 100);

            //设置接受鼠标事件
            spBtnSound.mouseEnabled = true;

            Laya.stage.addChild(spBtnSound);

            //创建一个Sprite充当音乐播放按钮
            var spBtnMusic: Sprite = new Sprite();

            //绘制按钮
            spBtnMusic.graphics.drawRect(0, 0, 110, 51, "#0000ff", "#0000ff", 1);
            spBtnMusic.graphics.fillText("播放音乐", 10, 10, "", "#ffffff", "left");

            spBtnMusic.pos(170, 18);
            spBtnMusic.size(100, 100);

            //设置接受鼠标事件
            spBtnMusic.mouseEnabled = true;

            Laya.stage.addChild(spBtnMusic);

            //创建一个信息文本，用来显示当前播放信息
            this.txtInfo = new Text();

            this.txtInfo.fontSize = 40;
            this.txtInfo.color = "#ffffff";

            this.txtInfo.size(300, 50);
            this.txtInfo.pos(17, 86);

            //添加进显示列表
            Laya.stage.addChild(this.txtInfo);

            spBtnSound.on(Event.CLICK, this, this.onPlaySound);
            spBtnMusic.on(Event.CLICK, this, this.onPlayMusic);

        }

        private onPlayMusic(e: Event): void {
            //显示播放音乐信息
            this.txtInfo.text = "播放音乐";
            SoundManager.playMusic("res/sounds/bgm.mp3", 1, new Handler(this, this.onComplete));
        }

        private onPlaySound(e: Event): void {
            //显示播放音效信息
            this.txtInfo.text = "播放音效";
            SoundManager.playSound("res/sounds/btn.mp3", 1, new Handler(this, this.onComplete));
        }

        private onComplete(): void {
            this.txtInfo.text = "播放完成";
        }
    }
}
new sounds.SoundSimple()