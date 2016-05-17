/// <reference path="../../libs/LayaAir.d.ts" />
var core;
(function (core) {
    var Stage = laya.display.Stage;
    var Event = laya.events.Event;
    var Loader = laya.net.Loader;
    var Particle2D = laya.particle.Particle2D;
    var Handler = laya.utils.Handler;
    var Stat = laya.utils.Stat;
    var WebGL = laya.webgl.WebGL;
    var Browser = laya.utils.Browser;
    var TestParticleSample2 = (function () {
        function TestParticleSample2() {
            Laya.init(Browser.width, Browser.height, WebGL);
            Stat.show();
            Laya.stage.bgColor = "#000000";
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.on(Event.RESIZE, this, this.onResize);
            Laya.loader.load("res/particles/RadiusMode.part", Handler.create(this, this.onAssetsLoaded), null, Loader.JSOn);
        }
        TestParticleSample2.prototype.onAssetsLoaded = function (settings) {
            this.sp = new Particle2D(settings);
            this.sp.emitter.start();
            this.sp.play();
            this.onResize(null);
            Laya.stage.addChild(this.sp);
        };
        TestParticleSample2.prototype.onResize = function (e) {
            if (!this.sp)
                return;
            this.sp.x = Laya.stage.width / 2;
            this.sp.y = Laya.stage.height / 2;
        };
        return TestParticleSample2;
    }());
    core.TestParticleSample2 = TestParticleSample2;
})(core || (core = {}));
new core.TestParticleSample2();
