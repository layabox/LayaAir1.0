var laya;
(function (laya) {
    var Templet = Laya.Templet;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var Stat = Laya.Stat;
    var WebGL = Laya.WebGL;
    var ChangeSkin = (function () {
        function ChangeSkin() {
            this.mStartX = 400;
            this.mStartY = 500;
            this.mActionIndex = 0;
            this.mCurrIndex = 0;
            this.mCurrSkinIndex = 0;
            this.mSkinList = ["goblin", "goblingirl"];
            WebGL.enable();
            Laya.init(Browser.width, Browser.height);
            Laya.stage.bgColor = "#ffffff";
            Stat.show();
            this.startFun();
        }
        ChangeSkin.prototype.startFun = function () {
            this.mAniPath = "../../res/spine/spineRes2/goblins-mesh.sk";
            this.mFactory = new Templet();
            this.mFactory.on(Event.COMPLETE, this, this.parseComplete);
            this.mFactory.on(Event.ERROR, this, this.onError);
            this.mFactory.loadAni(this.mAniPath);
        };
        ChangeSkin.prototype.onError = function () {
            console.log("error");
        };
        ChangeSkin.prototype.parseComplete = function () {
            //创建模式为1，可以启用换装
            this.mArmature = this.mFactory.buildArmature(1);
            this.mArmature.x = this.mStartX;
            this.mArmature.y = this.mStartY;
            Laya.stage.addChild(this.mArmature);
            this.mArmature.on(Event.STOPPED, this, this.completeHandler);
            this.play();
            this.changeSkin();
            Laya.timer.loop(1000, this, this.changeSkin);
        };
        ChangeSkin.prototype.changeSkin = function () {
            this.mCurrSkinIndex++;
            if (this.mCurrSkinIndex >= this.mSkinList.length) {
                this.mCurrSkinIndex = 0;
            }
            this.mArmature.showSkinByName(this.mSkinList[this.mCurrSkinIndex]);
        };
        ChangeSkin.prototype.completeHandler = function () {
            this.play();
        };
        ChangeSkin.prototype.play = function () {
            this.mCurrIndex++;
            if (this.mCurrIndex >= this.mArmature.getAnimNum()) {
                this.mCurrIndex = 0;
            }
            this.mArmature.play(this.mCurrIndex, false);
        };
        return ChangeSkin;
    }());
    laya.ChangeSkin = ChangeSkin;
})(laya || (laya = {}));
new laya.ChangeSkin();
