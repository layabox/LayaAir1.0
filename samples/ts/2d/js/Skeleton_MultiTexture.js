var laya;
(function (laya) {
    var Templet = Laya.Templet;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var Stat = Laya.Stat;
    var WebGL = Laya.WebGL;
    var MultiTexture = (function () {
        function MultiTexture() {
            this.mStartX = 400;
            this.mStartY = 500;
            this.mActionIndex = 0;
            this.mCurrIndex = 0;
            this.mCurrSkinIndex = 0;
            WebGL.enable();
            Laya.init(Browser.width, Browser.height);
            Laya.stage.bgColor = "#ffffff";
            Stat.show();
            this.startFun();
        }
        MultiTexture.prototype.startFun = function () {
            this.mAniPath = "../../res/spine/spineRes1/dragon.sk";
            this.mFactory = new Templet();
            this.mFactory.on(Event.COMPLETE, this, this.parseComplete);
            this.mFactory.on(Event.ERROR, this, this.onError);
            this.mFactory.loadAni(this.mAniPath);
        };
        MultiTexture.prototype.onError = function () {
            console.log("error");
        };
        MultiTexture.prototype.parseComplete = function () {
            //创建模式为1，可以启用换装
            this.mArmature = this.mFactory.buildArmature(1);
            this.mArmature.x = this.mStartX;
            this.mArmature.y = this.mStartY;
            this.mArmature.scale(0.5, 0.5);
            Laya.stage.addChild(this.mArmature);
            this.mArmature.on(Event.STOPPED, this, this.completeHandler);
            this.play();
        };
        MultiTexture.prototype.completeHandler = function () {
            this.play();
        };
        MultiTexture.prototype.play = function () {
            this.mCurrIndex++;
            if (this.mCurrIndex >= this.mArmature.getAnimNum()) {
                this.mCurrIndex = 0;
            }
            this.mArmature.play(this.mCurrIndex, false);
        };
        return MultiTexture;
    }());
    laya.MultiTexture = MultiTexture;
})(laya || (laya = {}));
new laya.MultiTexture();
