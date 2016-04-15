/// <reference path="../../libs/LayaAir.d.ts" />
var sprites;
(function (sprites) {
    var Sprite = laya.display.Sprite;
    var SpriteContainer = (function () {
        function SpriteContainer() {
            Laya.init(500, 500);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            // 每只猩猩距离中心点150像素
            var layoutRadius = 150;
            var radianUnit = Math.PI / 2;
            this.apesCtn = new Sprite();
            Laya.stage.addChild(this.apesCtn);
            // 添加4张猩猩图片
            for (var i = 0; i < 4; i++) {
                var ape = new Sprite();
                ape.loadImage("res/apes/monkey" + i + ".png");
                ape.pivot(55, 72);
                // 以圆周排列猩猩
                ape.pos(Math.cos(radianUnit * i) * layoutRadius, Math.sin(radianUnit * i) * layoutRadius);
                this.apesCtn.addChild(ape);
            }
            // 将容器移动到舞台中央
            this.apesCtn.pos(250, 250);
            Laya.timer.frameLoop(1, this, this.animate);
        }
        SpriteContainer.prototype.animate = function (e) {
            this.apesCtn.rotation += 1;
        };
        return SpriteContainer;
    }());
    sprites.SpriteContainer = SpriteContainer;
})(sprites || (sprites = {}));
new sprites.SpriteContainer();
