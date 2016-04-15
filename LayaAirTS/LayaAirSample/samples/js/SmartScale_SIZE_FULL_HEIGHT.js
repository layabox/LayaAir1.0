/// <reference path="../../libs/LayaAir.d.ts" />
var Sprite = laya.display.Sprite;
var SmartScale_SIZE_FULL_HEIGHT = (function () {
    function SmartScale_SIZE_FULL_HEIGHT() {
        Laya.init(laya.utils.Browser.width, laya.utils.Browser.height);
        Laya.stage.sizeMode = laya.display.Stage.SIZE_FULL_HEIGHT;
        this.rect = new laya.display.Sprite();
        this.rect.graphics.drawRect(-100, -100, 200, 200, "gray");
        Laya.stage.addChild(this.rect);
        this.updateRectPos();
        Laya.stage.on("resize", this, this.updateRectPos);
    }
    SmartScale_SIZE_FULL_HEIGHT.prototype.updateRectPos = function () {
        this.rect.x = laya.utils.Browser.clientWidth / 2;
        this.rect.y = laya.utils.Browser.clientHeight / 2;
    };
    return SmartScale_SIZE_FULL_HEIGHT;
}());
new SmartScale_SIZE_FULL_HEIGHT();
