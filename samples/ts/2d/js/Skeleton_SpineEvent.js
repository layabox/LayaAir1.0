var laya;
(function (laya) {
    var Templet = Laya.Templet;
    var Sprite = Laya.Sprite;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var Stat = Laya.Stat;
    var Tween = Laya.Tween;
    var WebGL = Laya.WebGL;
    var Skeleton_SpineEvent = (function () {
        function Skeleton_SpineEvent() {
            this.mStartX = 400;
            this.mStartY = 500;
            this.mActionIndex = 0;
            this.mCurrIndex = 0;
            this.mCurrSkinIndex = 0;
            Laya.init(Browser.width, Browser.height, WebGL);
            Laya.stage.bgColor = "#ffffff";
            Stat.show();
            this.mLabelSprite = new Sprite();
            this.startFun();
        }
        Skeleton_SpineEvent.prototype.startFun = function () {
            this.mAniPath = "../../res/spine/spineRes6/alien.sk";
            this.mFactory = new Templet();
            this.mFactory.on(Event.COMPLETE, this, this.parseComplete);
            this.mFactory.on(Event.ERROR, this, this.onError);
            this.mFactory.loadAni(this.mAniPath);
        };
        Skeleton_SpineEvent.prototype.onError = function () {
            console.log("error");
        };
        Skeleton_SpineEvent.prototype.parseComplete = function () {
            //创建模式为1，可以启用换装
            this.mArmature = this.mFactory.buildArmature(1);
            this.mArmature.x = this.mStartX;
            this.mArmature.y = this.mStartY;
            this.mArmature.scale(0.5, 0.5);
            Laya.stage.addChild(this.mArmature);
            this.mArmature.on(Event.LABEL, this, this.onEvent);
            this.mArmature.on(Event.STOPPED, this, this.completeHandler);
            this.play();
        };
        Skeleton_SpineEvent.prototype.completeHandler = function () {
            this.play();
        };
        Skeleton_SpineEvent.prototype.play = function () {
            this.mCurrIndex++;
            if (this.mCurrIndex >= this.mArmature.getAnimNum()) {
                this.mCurrIndex = 0;
            }
            this.mArmature.play(this.mCurrIndex, false);
        };
        Skeleton_SpineEvent.prototype.onEvent = function (e) {
            var tEventData = e;
            Laya.stage.addChild(this.mLabelSprite);
            this.mLabelSprite.x = this.mStartX;
            this.mLabelSprite.y = this.mStartY;
            this.mLabelSprite.graphics.clear();
            this.mLabelSprite.graphics.fillText(tEventData.name, 0, 0, "20px Arial", "#ff0000", "center");
            Tween.to(this.mLabelSprite, { y: this.mStartY - 200 }, 1000, null, Handler.create(this, this.playEnd));
        };
        Skeleton_SpineEvent.prototype.playEnd = function () {
            this.mLabelSprite.removeSelf();
        };
        return Skeleton_SpineEvent;
    }());
    laya.Skeleton_SpineEvent = Skeleton_SpineEvent;
})(laya || (laya = {}));
new laya.Skeleton_SpineEvent();
