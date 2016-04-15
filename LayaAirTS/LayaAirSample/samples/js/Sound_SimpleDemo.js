/// <reference path="../../libs/LayaAir.d.ts" />
var sounds;
(function (sounds) {
    var Sprite = laya.display.Sprite;
    var Text = laya.display.Text;
    var Event = laya.events.Event;
    var Handler = laya.utils.Handler;
    var SoundManager = laya.media.SoundManager;
    var SoundSimple = (function () {
        function SoundSimple() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            //创建一个Sprite充当音效播放按钮
            var spBtnSound = new Sprite();
            //绘制按钮
            spBtnSound.graphics.drawRect(0, 0, 110, 51, "#ff0000", "#ff0000", 1);
            spBtnSound.graphics.fillText("播放音效", 10, 10, "", "#ffffff", "left");
            spBtnSound.pos(17, 18);
            spBtnSound.size(100, 100);
            //设置接受鼠标事件
            spBtnSound.mouseEnabled = true;
            Laya.stage.addChild(spBtnSound);
            //创建一个Sprite充当音乐播放按钮
            var spBtnMusic = new Sprite();
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
        SoundSimple.prototype.onPlayMusic = function (e) {
            //显示播放音乐信息
            this.txtInfo.text = "播放音乐";
            SoundManager.playMusic("res/sounds/bgm.mp3", 1, new Handler(this, this.onComplete));
        };
        SoundSimple.prototype.onPlaySound = function (e) {
            //显示播放音效信息
            this.txtInfo.text = "播放音效";
            SoundManager.playSound("res/sounds/btn.mp3", 1, new Handler(this, this.onComplete));
        };
        SoundSimple.prototype.onComplete = function () {
            this.txtInfo.text = "播放完成";
        };
        return SoundSimple;
    }());
    sounds.SoundSimple = SoundSimple;
})(sounds || (sounds = {}));
new sounds.SoundSimple();
