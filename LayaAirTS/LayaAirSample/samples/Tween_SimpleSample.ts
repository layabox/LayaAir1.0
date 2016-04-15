/// <reference path="../../libs/LayaAir.d.ts" />
module tween {
    import Sprite=laya.display.Sprite;
    import Tween=laya.utils.Tween;
    export class SimpleTweenSample {

        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            this.setup();
        }

        private  setup():void {
            var terminalX:number = 200;

            var characterA:Sprite = this.createCharacter("res/cartoonCharacters/1.png");
            characterA.pivot(46.5, 50);
            characterA.y = 100;

            var characterB:Sprite = this.createCharacter("res/cartoonCharacters/2.png");
            characterB.pivot(34, 50);
            characterB.y = 250;

            Laya.stage.graphics.drawLine(terminalX, 0, terminalX, Laya.stage.height, "#FFFFFF");

            // characterA使用Tween.to缓动
            Tween.to(characterA, {x: terminalX}, 1000);
            // characterB使用Tween.from缓动
            characterB.x = terminalX;
            Tween.from(characterB, {x: 0}, 1000);
        }

        private  createCharacter(skin:string):Sprite {
            var character:Sprite = new Sprite();
            character.loadImage(skin);
            Laya.stage.addChild(character);

            return character;
        }
    }
}
new tween.SimpleTweenSample();