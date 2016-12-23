var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var Loader = Laya.Loader;
    var Particle2D = Laya.Particle2D;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var Stat = Laya.Stat;
    var WebGL = Laya.WebGL;
    var URL = Laya.URL;
    var Particle_T2 = (function () {
        function Particle_T2() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Stat.show();
            URL.basePath += "../../";
            Laya.loader.load("res/particles/RadiusMode.part", Handler.create(this, this.onAssetsLoaded), null, Loader.JSON);
        }
        Particle_T2.prototype.onAssetsLoaded = function (settings) {
            this.sp = new Particle2D(settings);
            this.sp.emitter.start();
            this.sp.play();
            Laya.stage.addChild(this.sp);
            this.sp.x = Laya.stage.width / 2;
            this.sp.y = Laya.stage.height / 2;
        };
        return Particle_T2;
    }());
    laya.Particle_T2 = Particle_T2;
})(laya || (laya = {}));
new laya.Particle_T2();
