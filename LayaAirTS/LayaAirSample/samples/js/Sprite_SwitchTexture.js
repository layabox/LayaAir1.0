/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Sprite = laya.display.Sprite;
    var Stage = laya.display.Stage;
    var Handler = laya.utils.Handler;
    var Sprite_SwitchTexture = (function () {
        function Sprite_SwitchTexture() {
            this.texture1 = "res/apes/monkey2.png";
            this.texture2 = "res/apes/monkey3.png";
            this.flag = false;
            Laya.init(550, 400);
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.loader.load([this.texture1, this.texture2], Handler.create(this, this.onAssetsLoaded));
        }
        Sprite_SwitchTexture.prototype.onAssetsLoaded = function () {
            this.ape = new Sprite();
            Laya.stage.addChild(this.ape);
            // 显示默认纹理
            this.switchTexture();
            this.ape.on("click", this, this.switchTexture);
        };
        Sprite_SwitchTexture.prototype.switchTexture = function () {
            var textureUrl = (this.flag = !this.flag) ? this.texture1 : this.texture2;
            // 更换纹理
            this.ape.graphics.clear();
            var texture = Laya.loader.getRes(textureUrl);
            this.ape.graphics.drawTexture(texture, 0, 0);
            // 设置交互区域
            this.ape.size(texture.width, texture.height);
        };
        return Sprite_SwitchTexture;
    }());
    laya.Sprite_SwitchTexture = Sprite_SwitchTexture;
})(laya || (laya = {}));
new laya.Sprite_SwitchTexture();
