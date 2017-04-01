module laya {
    import Stage = Laya.Stage;
    import Loader = Laya.Loader;
    import Particle2D = Laya.Particle2D;
    import ParticleSetting = Laya.ParticleSetting;
    import Browser = Laya.Browser;
    import Handler = Laya.Handler;
    import Stat = Laya.Stat;
    import WebGL = Laya.WebGL;
    import URL = Laya.URL;

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

            URL.basePath += "../../";
            Laya.loader.load("res/particles/particleNew.part", Handler.create(this, this.onAssetsLoaded), null, Loader.JSON);
        }

        public onAssetsLoaded(settings: ParticleSetting): void {
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