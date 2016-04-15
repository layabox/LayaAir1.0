/// <reference path="../../libs/LayaAir.d.ts" />
var tween;
(function (tween) {
    var Text = laya.display.Text;
    var Ease = laya.utils.Ease;
    var Tween = laya.utils.Tween;
    var LettersTween = (function () {
        function LettersTween() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.setup();
        }
        LettersTween.prototype.setup = function () {
            var demoString = "LayaBox";
            for (var i = 0, len = demoString.length; i < len; ++i) {
                var letterText = this.createLetter(demoString.charAt(i));
                letterText.x = 400 / len * i + 50;
                Tween.to(letterText, { y: 200 }, 1000, Ease.elasticOut, null, i * 1000);
            }
        };
        LettersTween.prototype.createLetter = function (char) {
            var letter = new Text();
            letter.text = char;
            letter.color = "#FFFFFF";
            letter.font = "Impact";
            letter.fontSize = 110;
            Laya.stage.addChild(letter);
            return letter;
        };
        return LettersTween;
    }());
    tween.LettersTween = LettersTween;
})(tween || (tween = {}));
new tween.LettersTween();
