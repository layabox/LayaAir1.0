/// <reference path="../../libs/LayaAir.d.ts" />
var tween;
(function (tween) {
    var Sprite = laya.display.Sprite;
    var Tween = laya.utils.Tween;
    var SimpleTweenSample = (function () {
        function SimpleTweenSample() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.setup();
        }
        SimpleTweenSample.prototype.setup = function () {
            var terminalX = 200;
            var characterA = this.createCharacter("res/cartoonCharacters/1.png");
            characterA.pivot(46.5, 50);
            characterA.y = 100;
            var characterB = this.createCharacter("res/cartoonCharacters/2.png");
            characterB.pivot(34, 50);
            characterB.y = 250;
            Laya.stage.graphics.drawLine(terminalX, 0, terminalX, Laya.stage.height, "#FFFFFF");
            // characterA使用Tween.to缓动
            Tween.to(characterA, { x: terminalX }, 1000);
            // characterB使用Tween.from缓动
            characterB.x = terminalX;
            Tween.from(characterB, { x: 0 }, 1000);
        };
        SimpleTweenSample.prototype.createCharacter = function (skin) {
            var character = new Sprite();
            character.loadImage(skin);
            Laya.stage.addChild(character);
            return character;
        };
        return SimpleTweenSample;
    }());
    tween.SimpleTweenSample = SimpleTweenSample;
})(tween || (tween = {}));
new tween.SimpleTweenSample();
