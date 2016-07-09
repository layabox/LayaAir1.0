/// <reference path="../../../bin/ts/LayaAir.d.ts" />
module laya {
    import Stage = laya.display.Stage;
    import Loader = laya.net.Loader;
    import Particle2D = laya.particle.Particle2D;
    import ParticleSettings = laya.particle.ParticleSettings;
    import Browser = laya.utils.Browser;
    import Handler = laya.utils.Handler;
    import Stat = laya.utils.Stat;
    import WebGL = laya.webgl.WebGL;

    export class Particle_T3 {
        private sp: Particle2D;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";

            Stat.show();

            Laya.loader.load("res/particles/particleNew.part", Handler.create(this, this.onAssetsLoaded), null, Loader.JSON);
        }

        public onAssetsLoaded(settings: ParticleSettings): void {
            this.sp = new Particle2D(settings);
            this.sp.emitter.start();
            this.sp.play();
            Laya.stage.addChild(this.sp);

            this.sp.x = Laya.stage.width / 2;
            this.sp.y = Laya.stage.height / 2;
        }
    }
}
new laya.Particle_T3();