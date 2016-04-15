/// <reference path="../../libs/LayaAir.d.ts" />
var performanceTest;
(function (performanceTest) {
    var Sprite = laya.display.Sprite;
    var Loader = laya.net.Loader;
    var Handler = laya.utils.Handler;
    var Stat = laya.utils.Stat;
    var WebGL = laya.webgl.WebGL;
    var Browser = laya.utils.Browser;
    var Test2 = (function () {
        function Test2() {
            this.colAmount = 100;
            this.extraSpace = 50;
            this.moveSpeed = 2;
            this.rotateSpeed = 2;
            Laya.init(Browser.width, Browser.height, WebGL);
            Stat.show();
            Laya.loader.load("res/cartoonCharacters/cartoonCharactors.json", Handler.create(this, this.initCharactors), null, Loader.ATLAS);
        }
        Test2.prototype.initCharactors = function () {
            this.charactorGroup = [];
            for (var i = 0; i < this.colAmount; ++i) {
                var tx = (Laya.stage.width + this.extraSpace * 2) / this.colAmount * i - this.extraSpace;
                var tr = 360 / this.colAmount * i;
                this.createCharactor("cartoonCharactors/1.png", 46, 50, tr).pos(tx, 50);
                this.createCharactor("cartoonCharactors/2.png", 34, 50, tr).pos(tx, 150);
                this.createCharactor("cartoonCharactors/3.png", 42, 50, tr).pos(tx, 250);
                this.createCharactor("cartoonCharactors/4.png", 48, 50, tr).pos(tx, 350);
                this.createCharactor("cartoonCharactors/5.png", 36, 50, tr).pos(tx, 450);
            }
            Laya.timer.frameLoop(1, this, this.animate);
        };
        Test2.prototype.createCharactor = function (skin, pivotX, pivotY, rotation) {
            var charactor = new Sprite();
            charactor.loadImage(skin);
            charactor.rotation = rotation;
            charactor.pivot(pivotX, pivotY);
            Laya.stage.addChild(charactor);
            this.charactorGroup.push(charactor);
            return charactor;
        };
        Test2.prototype.animate = function () {
            for (var i = this.charactorGroup.length - 1; i >= 0; --i) {
                this.animateCharactor(this.charactorGroup[i]);
            }
        };
        Test2.prototype.animateCharactor = function (charactor) {
            charactor.x += this.moveSpeed;
            charactor.rotation += this.rotateSpeed;
            if (charactor.x > Laya.stage.width + this.extraSpace) {
                charactor.x = -this.extraSpace;
            }
        };
        return Test2;
    }());
    performanceTest.Test2 = Test2;
})(performanceTest || (performanceTest = {}));
new performanceTest.Test2();
