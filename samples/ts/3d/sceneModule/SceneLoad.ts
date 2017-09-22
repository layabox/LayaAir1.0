class SceneLoad {
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/Arena/Arena.ls")) as Laya.Scene;

        var camera: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 2, 0));
        camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
        camera.addComponent(CameraMoveScript);

        var skyBox: Laya.SkyBox = new Laya.SkyBox();
        skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
        camera.sky = skyBox;
    }
}
new SceneLoad;