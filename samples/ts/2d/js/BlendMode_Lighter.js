var laya;
(function (laya) {
    var Animation = Laya.Animation;
    var Stage = Laya.Stage;
    var Handler = Laya.Handler;
    var Tween = Laya.Tween;
    var WebGL = Laya.WebGL;
    var BlendMode_Lighter = (function () {
        function BlendMode_Lighter() {
            // 一只凤凰的分辨率是550 * 400
            this.phoenixWidth = 550;
            this.phoenixHeight = 400;
            this.bgColorTweener = new Tween();
            this.gradientInterval = 2000;
            this.bgColorChannels = { r: 99, g: 0, b: 0xFF };
            // 不支持WebGL时自动切换至Canvas
            Laya.init(this.phoenixWidth * 2, this.phoenixHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        BlendMode_Lighter.prototype.setup = function () {
            this.createPhoenixes();
            // 动态背景渲染
            this.evalBgColor();
            Laya.timer.frameLoop(1, this, this.renderBg);
        };
        BlendMode_Lighter.prototype.createPhoenixes = function () {
            var scaleFactor = Math.min(Laya.stage.width / (this.phoenixWidth * 2), Laya.stage.height / this.phoenixHeight);
            // 加了混合模式的凤凰
            var blendedPhoenix = this.createAnimation();
            blendedPhoenix.blendMode = "lighter";
            blendedPhoenix.scale(scaleFactor, scaleFactor);
            blendedPhoenix.y = (Laya.stage.height - this.phoenixHeight * scaleFactor) / 2;
            // 正常模式的凤凰
            var normalPhoenix = this.createAnimation();
            normalPhoenix.scale(scaleFactor, scaleFactor);
            normalPhoenix.x = this.phoenixWidth * scaleFactor;
            normalPhoenix.y = (Laya.stage.height - this.phoenixHeight * scaleFactor) / 2;
        };
        BlendMode_Lighter.prototype.createAnimation = function () {
            var frames = [];
            for (var i = 1; i <= 25; ++i) {
                frames.push("../../res/phoenix/phoenix" + this.preFixNumber(i, 4) + ".jpg");
            }
            var animation = new Animation();
            animation.loadImages(frames);
            Laya.stage.addChild(animation);
            var clips = animation.frames.concat();
            // 反转帧
            clips = clips.reverse();
            // 添加到已有帧末尾
            animation.frames = animation.frames.concat(clips);
            animation.play();
            return animation;
        };
        BlendMode_Lighter.prototype.preFixNumber = function (num, strLen) {
            return ("0000000000" + num).slice(-strLen);
        };
        BlendMode_Lighter.prototype.evalBgColor = function () {
            var color = Math.random() * 0xFFFFFF;
            var channels = this.getColorChannals(color);
            this.bgColorTweener.to(this.bgColorChannels, { r: channels[0], g: channels[1], b: channels[2] }, this.gradientInterval, null, Handler.create(this, this.onTweenComplete));
        };
        BlendMode_Lighter.prototype.getColorChannals = function (color) {
            var result = [];
            result.push(color >> 16);
            result.push(color >> 8 & 0xFF);
            result.push(color & 0xFF);
            return result;
        };
        BlendMode_Lighter.prototype.onTweenComplete = function () {
            this.evalBgColor();
        };
        BlendMode_Lighter.prototype.renderBg = function () {
            Laya.stage.graphics.clear();
            Laya.stage.graphics.drawRect(0, 0, this.phoenixWidth, this.phoenixHeight, this.getHexColorString());
        };
        BlendMode_Lighter.prototype.getHexColorString = function () {
            this.bgColorChannels.r = Math.floor(this.bgColorChannels.r);
            // 绿色通道使用0
            this.bgColorChannels.g = 0;
            //obj.g = Math.floor(obj.g);
            this.bgColorChannels.b = Math.floor(this.bgColorChannels.b);
            var r = this.bgColorChannels.r.toString(16);
            r = r.length == 2 ? r : "0" + r;
            var g = this.bgColorChannels.g.toString(16);
            g = g.length == 2 ? g : "0" + g;
            var b = this.bgColorChannels.b.toString(16);
            b = b.length == 2 ? b : "0" + b;
            return "#" + r + g + b;
        };
        return BlendMode_Lighter;
    }());
    laya.BlendMode_Lighter = BlendMode_Lighter;
})(laya || (laya = {}));
new laya.BlendMode_Lighter();
