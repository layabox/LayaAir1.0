/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Animation = laya.display.Animation;
    var Handler = laya.utils.Handler;
    var Tween = laya.utils.Tween;
    var BlendMode_Lighter = (function () {
        function BlendMode_Lighter() {
            this.w = 1000;
            this.h = 400;
            this.tween = new Tween();
            this.duration = 2000;
            this.obj = { r: 99, g: 0, b: 0xFF };
            Laya.init(this.w, this.h);
            this.createAnimation().blendMode = "lighter";
            this.createAnimation().pos(500, 0);
            this.evalBgColor();
            Laya.timer.frameLoop(1, this, this.renderBg);
        }
        BlendMode_Lighter.prototype.createAnimation = function () {
            var animation = Animation.fromUrl("res/phoenix/phoenix{0001}.jpg", 25);
            Laya.stage.addChild(animation);
            var clips = animation.frames.concat();
            // 反转帧
            clips = clips.reverse();
            // 添加到已有帧末尾
            animation.frames = animation.frames.concat(clips);
            animation.play();
            return animation;
        };
        BlendMode_Lighter.prototype.evalBgColor = function () {
            var color = Math.random() * 0xFFFFFF;
            var channels = this.getColorChannals(color);
            this.tween.to(this.obj, { r: channels[0], g: channels[1], b: channels[2] }, this.duration, null, Handler.create(this, this.onTweenComplete));
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
            Laya.stage.graphics.drawRect(0, 0, this.w, this.h, this.getColor());
        };
        BlendMode_Lighter.prototype.getColor = function () {
            this.obj.r = Math.floor(this.obj.r);
            // 绿色通道使用0
            this.obj.g = 0;
            //this.obj.g = Math.floor(this.obj.g);
            this.obj.b = Math.floor(this.obj.b);
            var r = this.obj.r.toString(16);
            r = r.length == 2 ? r : "0" + r;
            var g = this.obj.g.toString(16);
            g = g.length == 2 ? g : "0" + g;
            var b = this.obj.b.toString(16);
            b = b.length == 2 ? b : "0" + b;
            return "#" + r + g + b;
        };
        return BlendMode_Lighter;
    }());
    laya.BlendMode_Lighter = BlendMode_Lighter;
})(laya || (laya = {}));
new laya.BlendMode_Lighter();
