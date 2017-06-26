var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Browser = Laya.Browser;
    var Tween = Laya.Tween;
    var WebGL = Laya.WebGL;
    var Tween_SimpleSample = (function () {
        function Tween_SimpleSample() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Tween_SimpleSample.prototype.setup = function () {
            var terminalX = 200;
            var characterA = this.createCharacter("../../res/cartoonCharacters/1.png");
            characterA.pivot(46.5, 50);
            characterA.y = 100;
            var characterB = this.createCharacter("../../res/cartoonCharacters/2.png");
            characterB.pivot(34, 50);
            characterB.y = 250;
            Laya.stage.graphics.drawLine(terminalX, 0, terminalX, Laya.stage.height, "#FFFFFF");
            // characterA使用Tween.to缓动
            Tween.to(characterA, { x: terminalX }, 1000);
            // characterB使用Tween.from缓动
            characterB.x = terminalX;
            Tween.from(characterB, { x: 0 }, 1000);
        };
        Tween_SimpleSample.prototype.createCharacter = function (skin) {
            var character = new Sprite();
            character.loadImage(skin);
            Laya.stage.addChild(character);
            return character;
        };
        return Tween_SimpleSample;
    }());
    laya.Tween_SimpleSample = Tween_SimpleSample;
})(laya || (laya = {}));
new laya.Tween_SimpleSample();
