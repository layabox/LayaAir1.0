/// <reference path="../../libs/LayaAir.d.ts" />
module tween {
    import Text=laya.display.Text;
    import Ease=laya.utils.Ease;
    import Tween=laya.utils.Tween;
    export class LettersTween {

        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            this.setup();
        }

        private  setup():void {
            var demoString:String = "LayaBox";

            for (var i:number = 0, len = demoString.length; i < len; ++i) {
                var letterText:Text = this.createLetter(demoString.charAt(i));
                letterText.x = 400 / len * i + 50;

                Tween.to(letterText, {y: 200}, 1000, Ease.elasticOut, null, i * 1000);
            }
        }

        private  createLetter(char:string):Text {
            var letter:Text = new Text();
            letter.text = char;
            letter.color = "#FFFFFF";
            letter.font = "Impact";
            letter.fontSize = 110;
            Laya.stage.addChild(letter);

            return letter;
        }
    }
}
new tween.LettersTween();