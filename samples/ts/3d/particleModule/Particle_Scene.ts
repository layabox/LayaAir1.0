class Particle_Scene {
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/particle/Example_01.ls")) as Laya.Scene;

        var camera: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 1, 0));
        camera.addComponent(CameraMoveScript);
    }
}
new Particle_Scene;