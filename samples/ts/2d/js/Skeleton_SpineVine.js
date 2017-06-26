var laya;
(function (laya) {
    var Templet = Laya.Templet;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var Stat = Laya.Stat;
    var WebGL = Laya.WebGL;
    var Skeleton_SpineVine = (function () {
        function Skeleton_SpineVine() {
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
        Skeleton_SpineVine.prototype.startFun = function () {
            this.mAniPath = "../../res/spine/spineRes5/vine.sk";
            this.mFactory = new Templet();
            this.mFactory.on(Event.COMPLETE, this, this.parseComplete);
            this.mFactory.on(Event.ERROR, this, this.onError);
            this.mFactory.loadAni(this.mAniPath);
        };
        Skeleton_SpineVine.prototype.onError = function () {
            console.log("error");
        };
        Skeleton_SpineVine.prototype.parseComplete = function () {
            //创建模式为1，可以启用换装
            this.mArmature = this.mFactory.buildArmature(1);
            this.mArmature.x = this.mStartX;
            this.mArmature.y = this.mStartY;
            this.mArmature.scale(0.5, 0.5);
            Laya.stage.addChild(this.mArmature);
            this.mArmature.on(Event.STOPPED, this, this.completeHandler);
            this.play();
        };
        Skeleton_SpineVine.prototype.completeHandler = function () {
            this.play();
        };
        Skeleton_SpineVine.prototype.play = function () {
            this.mCurrIndex++;
            if (this.mCurrIndex >= this.mArmature.getAnimNum()) {
                this.mCurrIndex = 0;
            }
            this.mArmature.play(this.mCurrIndex, false);
        };
        return Skeleton_SpineVine;
    }());
    laya.Skeleton_SpineVine = Skeleton_SpineVine;
})(laya || (laya = {}));
new laya.Skeleton_SpineVine();
