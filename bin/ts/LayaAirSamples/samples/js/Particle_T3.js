/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Stage = laya.display.Stage;
    var Loader = laya.net.Loader;
    var Particle2D = laya.particle.Particle2D;
    var Browser = laya.utils.Browser;
    var Handler = laya.utils.Handler;
    var Stat = laya.utils.Stat;
    var WebGL = laya.webgl.WebGL;
    var Particle_T3 = (function () {
        function Particle_T3() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Stat.show();
            Laya.loader.load("res/particles/particleNew.part", Handler.create(this, this.onAssetsLoaded), null, Loader.JSON);
        }
        Particle_T3.prototype.onAssetsLoaded = function (settings) {
            this.sp = new Particle2D(settings);
            this.sp.emitter.start();
            this.sp.play();
            Laya.stage.addChild(this.sp);
            this.sp.x = Laya.stage.width / 2;
            this.sp.y = Laya.stage.height / 2;
        };
        return Particle_T3;
    }());
    laya.Particle_T3 = Particle_T3;
})(laya || (laya = {}));
new laya.Particle_T3();
