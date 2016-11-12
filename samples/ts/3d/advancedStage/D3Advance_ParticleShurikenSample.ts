module ParticleShurikenSample {

    export class ParticleShurikenSample {

        constructor() {
            Laya3D.init(0, 0,true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;
            var camera = (scene.addChild(new Laya.Camera(0, 0.3, 1000))) as Laya.Camera;
            camera.transform.translate(new Laya.Vector3(0, 0, 100));
            //camera.transform.rotate(new Laya.Vector3(0, 0, 0), false, false);
            camera.clearColor = null;
            camera.addComponent(CameraMoveScript);

            var grid = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh")) as Laya.Sprite3D;
            grid.transform.localScale = new Laya.Vector3(100, 100, 100);


            var settingPath:string = "../../res/threeDimen/particle/shurikenParticle0.json";
            Laya.loader.load(settingPath, Laya.Handler.create(null, function(setting:Object):void {
                var preBasePath:string = Laya.URL.basePath;
				Laya.URL.basePath =Laya.URL.getPath(Laya.URL.formatURL(settingPath));
                var particle =Laya.Utils3D.loadParticle(setting);
                Laya.URL.basePath = preBasePath;

                scene.addChild(particle);
                //particle.transform.localScale = new Vector3(10, 10, 10);
            }), null, Laya.Loader.JSON);
        }

    }
}
new ParticleShurikenSample.ParticleShurikenSample();