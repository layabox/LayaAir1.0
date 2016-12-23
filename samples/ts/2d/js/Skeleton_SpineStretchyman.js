var laya;
(function (laya) {
    var Templet = Laya.Templet;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var Stat = Laya.Stat;
    var WebGL = Laya.WebGL;
    var Skeleton_SpineStretchyman = (function () {
        function Skeleton_SpineStretchyman() {
            this.mStartX = 200;
            this.mStartY = 500;
            this.mActionIndex = 0;
            this.mCurrIndex = 0;
            this.mCurrSkinIndex = 0;
            Laya.init(Browser.width, Browser.height, WebGL);
            Laya.stage.bgColor = "#ffffff";
            Stat.show();
            this.startFun();
        }
        Skeleton_SpineStretchyman.prototype.startFun = function () {
            this.mAniPath = "../../res/spine/spineRes4/stretchyman.sk";
            this.mFactory = new Templet();
            this.mFactory.on(Event.COMPLETE, this, this.parseComplete);
            this.mFactory.on(Event.ERROR, this, this.onError);
            this.mFactory.loadAni(this.mAniPath);
        };
        Skeleton_SpineStretchyman.prototype.onError = function () {
            console.log("error");
        };
        Skeleton_SpineStretchyman.prototype.parseComplete = function () {
            //创建模式为1，可以启用换装
            this.mArmature = this.mFactory.buildArmature(1);
            this.mArmature.x = this.mStartX;
            this.mArmature.y = this.mStartY;
            //mArmature.scale(0.5, 0.5);
            Laya.stage.addChild(this.mArmature);
            this.mArmature.on(Event.STOPPED, this, this.completeHandler);
            this.play();
        };
        Skeleton_SpineStretchyman.prototype.completeHandler = function () {
            this.play();
        };
        Skeleton_SpineStretchyman.prototype.play = function () {
            this.mCurrIndex++;
            if (this.mCurrIndex >= this.mArmature.getAnimNum()) {
                this.mCurrIndex = 0;
            }
            this.mArmature.play(this.mCurrIndex, false);
        };
        return Skeleton_SpineStretchyman;
    }());
    laya.Skeleton_SpineStretchyman = Skeleton_SpineStretchyman;
})(laya || (laya = {}));
new laya.Skeleton_SpineStretchyman();
