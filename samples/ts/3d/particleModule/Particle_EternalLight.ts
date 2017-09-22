class Particle_EternalLight {
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 2, 4));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

        var particleSprite3D: Laya.Sprite3D = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/particle/ETF_Eternal_Light.lh")) as Laya.Sprite3D;
    }
}
new Particle_EternalLight;