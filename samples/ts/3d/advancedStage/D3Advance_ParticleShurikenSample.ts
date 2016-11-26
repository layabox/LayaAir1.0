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
            camera.clearColor = null;
            camera.addComponent(CameraMoveScript);

            var grid = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh")) as Laya.Sprite3D;
            grid.transform.localScale = new Laya.Vector3(100, 100, 100);


            var settingPath:string = "../../res/threeDimen/particle/shurikenParticle0.json";
            Laya.loader.load(settingPath, Laya.Handler.create(null, function(setting:Object):void {
                var sprite3D:Laya.Sprite3D = new Laya.Sprite3D();
				sprite3D.transform.localScale = new Laya.Vector3(1,1,1);
				scene.addChild(sprite3D);

                var preBasePath:string = Laya.URL.basePath;
				Laya.URL.basePath =Laya.URL.getPath(Laya.URL.formatURL(settingPath));
                var particle =Laya.Utils3D.loadParticle(setting);
                Laya.URL.basePath = preBasePath;
                particle.transform.rotate(new Laya.Vector3(0,0, 0), true, false);
			    particle.transform.localScale = new Laya.Vector3(1, 1, 1);

                sprite3D.addChild(particle);
            }), null, Laya.Loader.JSON);
        }

    }
}
new ParticleShurikenSample.ParticleShurikenSample();