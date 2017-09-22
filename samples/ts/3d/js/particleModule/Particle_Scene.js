var Particle_Scene = (function () {
    function Particle_Scene() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/particle/Example_01.ls"));
        var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
        camera.transform.translate(new Laya.Vector3(0, 1, 0));
        camera.addComponent(CameraMoveScript);
    }
    return Particle_Scene;
}());
new Particle_Scene;
