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


            var particleRoot:Laya.Sprite3D = Laya.Sprite3D.load("../../res/threeDimen/particle/particleSystem0.lh");
            scene.addChild(particleRoot) as Laya.Sprite3D;
            var particle:Laya.ShuriKenParticle3D;
            particleRoot.once(Laya.Event.HIERARCHY_LOADED, null, function():void {
                particle = scene.getChildAt(2).getChildAt(0) as Laya.ShuriKenParticle3D;
                particle.transform.rotate(new Laya.Vector3(-60 / 180 * Math.PI, -50 / 180 * Math.PI, 90 / 180 * Math.PI));
                particle.transform.localPosition = new Laya.Vector3(0, 0, 0);
            });
        }

    }
}
new ParticleShurikenSample.ParticleShurikenSample();