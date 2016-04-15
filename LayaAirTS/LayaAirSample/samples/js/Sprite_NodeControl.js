/// <reference path="../../libs/LayaAir.d.ts" />
var sprites;
(function (sprites) {
    var Sprite = laya.display.Sprite;
    var SpriteNodeControl = (function () {
        function SpriteNodeControl() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            //显示两只猩猩
            this.ape1 = new Sprite();
            this.ape2 = new Sprite();
            this.ape1.loadImage("res/apes/monkey2.png");
            this.ape2.loadImage("res/apes/monkey2.png");
            this.ape1.pivot(55, 72);
            this.ape2.pivot(55, 72);
            this.ape1.pos(275, 200);
            this.ape2.pos(200, 0);
            //一只猩猩在舞台上，另一只被添加成第一只猩猩的子级
            Laya.stage.addChild(this.ape1);
            this.ape1.addChild(this.ape2);
            Laya.timer.frameLoop(1, this, this.animate);
        }
        SpriteNodeControl.prototype.animate = function (e) {
            this.ape1.rotation += 2;
            this.ape2.rotation -= 4;
        };
        return SpriteNodeControl;
    }());
    sprites.SpriteNodeControl = SpriteNodeControl;
})(sprites || (sprites = {}));
new sprites.SpriteNodeControl();
