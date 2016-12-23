var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Handler = Laya.Handler;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Sprite_SwitchTexture = (function () {
        function Sprite_SwitchTexture() {
            this.texture1 = "../../res/apes/monkey2.png";
            this.texture2 = "../../res/apes/monkey3.png";
            this.flag = false;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Laya.loader.load([this.texture1, this.texture2], Handler.create(this, this.onAssetsLoaded));
        }
        Sprite_SwitchTexture.prototype.onAssetsLoaded = function () {
            this.ape = new Sprite();
            Laya.stage.addChild(this.ape);
            this.ape.pivot(55, 72);
            this.ape.pos(Laya.stage.width / 2, Laya.stage.height / 2);
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
