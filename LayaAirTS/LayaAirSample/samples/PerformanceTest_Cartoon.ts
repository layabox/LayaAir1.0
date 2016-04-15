/// <reference path="../../libs/LayaAir.d.ts" />
module performanceTest {
    import Sprite=laya.display.Sprite;
    import Loader=laya.net.Loader;
    import Handler=laya.utils.Handler;
    import Stat=laya.utils.Stat;
    import WebGL=laya.webgl.WebGL;
    import Browser=laya.utils.Browser;
    export class Test2 {
        private  colAmount:number = 100;
        private  extraSpace:number = 50;
        private  moveSpeed:number = 2;
        private  rotateSpeed:number = 2;

        private  charactorGroup:Array<any>;

        constructor() {
            Laya.init(Browser.width, Browser.height, WebGL);
            Stat.show();
            Laya.loader.load("res/cartoonCharacters/cartoonCharactors.json", Handler.create(this, this.initCharactors), null, Loader.ATLAS);
        }

        private  initCharactors():void {
            this.charactorGroup = [];

            for (var i:number = 0; i < this.colAmount; ++i) {
                var tx:number = (Laya.stage.width + this.extraSpace * 2) / this.colAmount * i - this.extraSpace;
                var tr:number = 360 / this.colAmount * i;

                this.createCharactor("cartoonCharactors/1.png", 46, 50, tr).pos(tx, 50);
                this.createCharactor("cartoonCharactors/2.png", 34, 50, tr).pos(tx, 150);
                this.createCharactor("cartoonCharactors/3.png", 42, 50, tr).pos(tx, 250);
                this.createCharactor("cartoonCharactors/4.png", 48, 50, tr).pos(tx, 350);
                this.createCharactor("cartoonCharactors/5.png", 36, 50, tr).pos(tx, 450);
            }

            Laya.timer.frameLoop(1, this, this.animate);
        }

        private  createCharactor(skin:string, pivotX:number, pivotY:number, rotation:number):Sprite {
            var charactor:Sprite = new Sprite();
            charactor.loadImage(skin);
            charactor.rotation = rotation;
            charactor.pivot(pivotX, pivotY);
            Laya.stage.addChild(charactor);
            this.charactorGroup.push(charactor);

            return charactor;
        }

        private  animate():void {
            for (var i:number = this.charactorGroup.length - 1; i >= 0; --i) {
                this.animateCharactor(this.charactorGroup[i]);
            }
        }

        private  animateCharactor(charactor:Sprite):void {
            charactor.x += this.moveSpeed;
            charactor.rotation += this.rotateSpeed;

            if (charactor.x > Laya.stage.width + this.extraSpace) {
                charactor.x = -this.extraSpace;
            }
        }
    }

}
new performanceTest.Test2();