var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Event = Laya.Event;
    var SoundManager = Laya.SoundManager;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var Sound_SimpleDemo = (function () {
        function Sound_SimpleDemo() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Sound_SimpleDemo.prototype.setup = function () {
            var gap = 10;
            //创建一个Sprite充当音效播放按钮
            var soundButton = this.createButton("播放音效");
            soundButton.x = (Laya.stage.width - soundButton.width * 2 + gap) / 2;
            soundButton.y = (Laya.stage.height - soundButton.height) / 2;
            Laya.stage.addChild(soundButton);
            //创建一个Sprite充当音乐播放按钮
            var musicButton = this.createButton("播放音乐");
            musicButton.x = soundButton.x + gap + soundButton.width;
            musicButton.y = soundButton.y;
            Laya.stage.addChild(musicButton);
            soundButton.on(Event.CLICK, this, this.onPlaySound);
            musicButton.on(Event.CLICK, this, this.onPlayMusic);
        };
        Sound_SimpleDemo.prototype.createButton = function (label) {
            var w = 110;
            var h = 40;
            var button = new Sprite();
            button.size(w, h);
            button.graphics.drawRect(0, 0, w, h, "#FF7F50");
            button.graphics.fillText(label, w / 2, 8, "25px SimHei", "#FFFFFF", "center");
            Laya.stage.addChild(button);
            return button;
        };
        Sound_SimpleDemo.prototype.onPlayMusic = function (e) {
            console.log("播放音乐");
            SoundManager.playMusic("../../res/sounds/bgm.mp3", 1, new Handler(this, this.onComplete));
        };
        Sound_SimpleDemo.prototype.onPlaySound = function (e) {
            console.log("播放音效");
            SoundManager.playSound("../../res/sounds/btn.mp3", 1, new Handler(this, this.onComplete));
        };
        Sound_SimpleDemo.prototype.onComplete = function () {
            console.log("播放完成");
        };
        return Sound_SimpleDemo;
    }());
    laya.Sound_SimpleDemo = Sound_SimpleDemo;
})(laya || (laya = {}));
new laya.Sound_SimpleDemo();
