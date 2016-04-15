/// <reference path="../../libs/LayaAir.d.ts" />
var core;
(function (core) {
    var Skeleton = laya.ani.bone.Skeleton;
    var Templet = laya.ani.bone.Templet;
    var Loader = laya.net.Loader;
    var Handler = laya.utils.Handler;
    var Stat = laya.utils.Stat;
    var WebGL = laya.webgl.WebGL;
    var Browser = laya.utils.Browser;
    var TestAnim = (function () {
        function TestAnim() {
            this.robotAmount = 90;
            this.colAmount = 15;
            this.robotScale = 0.3;
            this.rowAmount = Math.ceil(this.robotAmount / this.colAmount);
            WebGL.enable();
            Laya.init(Browser.width, Browser.height, WebGL);
            Stat.show();
            var assets = [];
            assets.push({ url: "res/robot/data.bin", type: Loader.BUFFER });
            assets.push({ url: "res/robot/texture.png", type: Loader.IMAGE });
            Laya.loader.load(assets, Handler.create(this, this.onAssetsLoaded));
        }
        TestAnim.prototype.onAssetsLoaded = function () {
            var data = Loader.getRes("res/robot/data.bin");
            var img = Loader.getRes("res/robot/texture.png");
            var temp = new Templet(data, img);
            this.textureWidth = temp.textureWidth;
            this.textureHeight = temp.textureHeight;
            var horizontalGap = (Laya.stage.width - this.textureWidth * this.robotScale) / this.colAmount;
            var verticalGap = (Laya.stage.height - this.textureHeight * this.robotScale) / this.rowAmount;
            for (var i = 0; i < this.robotAmount; i++) {
                var col = i % this.colAmount;
                var row = i / this.colAmount | 0;
                var robot = this.createRobot(temp);
                robot.pos(horizontalGap * col, verticalGap * row);
                robot.stAnimName("Walk");
                robot.play();
            }
        };
        TestAnim.prototype.createRobot = function (templet) {
            var sk = new Skeleton(templet);
            sk.pivot(-this.textureWidth, -this.textureHeight);
            sk.scaleX = sk.scaleY = this.robotScale;
            Laya.stage.addChild(sk);
            return sk;
        };
        return TestAnim;
    }());
    core.TestAnim = TestAnim;
})(core || (core = {}));
new core.TestAnim();
