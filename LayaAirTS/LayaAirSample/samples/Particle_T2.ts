/// <reference path="../../libs/LayaAir.d.ts" />
module core {
    import Stage=laya.display.Stage;
    import Event=laya.events.Event;
    import Loader=laya.net.Loader;
    import Particle2D=laya.particle.Particle2D;
    import ParticleSettings=laya.particle.ParticleSettings;
    import Handler=laya.utils.Handler;
    import Stat=laya.utils.Stat;
    import WebGL=laya.webgl.WebGL;
    import Browser=laya.utils.Browser;
    export class TestParticleSample2 {
        private  sp:Particle2D;

        constructor() {
            Laya.init(Browser.width, Browser.height,WebGL);
            Laya.stage.bgColor = "#000000";
            Laya.stage.sizeMode = Stage.SIZE_FULL;
            Laya.stage.on(Event.RESIZE, this, this.onResize);
            Stat.show();
            this.loadParticleFile("res/particles/RadiusMode.json");
        }

        public  loadParticleFile(fileName:string):void {
            Laya.loader.load(fileName, Handler.create(this, this.test));
        }

        public  test(settings:ParticleSettings):void {
            if (this.sp) {
                this.sp.stop();
                this.sp.removeSelf();
            }
            this.sp = new Particle2D(settings);
            this.sp.emitter.start();
            this.sp.play();
            this.onResize(null);
            Laya.stage.addChild(this.sp);
        }

        private  onResize(e:Event):void {
            if (!this.sp)return;
            this.sp.x = Laya.stage.width / 2;
            this.sp.y = Laya.stage.height / 2;
        }
    }

}
new core.TestParticleSample2();