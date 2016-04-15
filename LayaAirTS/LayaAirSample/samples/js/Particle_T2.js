/// <reference path="../../libs/LayaAir.d.ts" />
var core;
(function (core) {
    var Stage = laya.display.Stage;
    var Event = laya.events.Event;
    var Particle2D = laya.particle.Particle2D;
    var Handler = laya.utils.Handler;
    var Stat = laya.utils.Stat;
    var WebGL = laya.webgl.WebGL;
    var Browser = laya.utils.Browser;
    var TestParticleSample2 = (function () {
        function TestParticleSample2() {
            Laya.init(Browser.width, Browser.height, WebGL);
            Laya.stage.bgColor = "#000000";
            Laya.stage.sizeMode = Stage.SIZE_FULL;
            Laya.stage.on(Event.RESIZE, this, this.onResize);
            Stat.show();
            this.loadParticleFile("res/particles/RadiusMode.json");
        }
        TestParticleSample2.prototype.loadParticleFile = function (fileName) {
            Laya.loader.load(fileName, Handler.create(this, this.test));
        };
        TestParticleSample2.prototype.test = function (settings) {
            if (this.sp) {
                this.sp.stop();
                this.sp.removeSelf();
            }
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
