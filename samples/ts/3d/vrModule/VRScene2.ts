class VRScene2 {
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/Arena/Arena.ls")) as Laya.Scene;

        //与3d场景的不同是添加了vr相机
        var vrCamera: Laya.VRCamera = scene.addChild(new Laya.VRCamera(0.03, 0, 0, 0.1, 100)) as Laya.VRCamera;
        vrCamera.transform.translate(new Laya.Vector3(0, 2, 0));
        vrCamera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
        vrCamera.addComponent(VRCameraMoveScript);

        var skyBox: Laya.SkyBox = new Laya.SkyBox();
        skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
        vrCamera.sky = skyBox;
    }
}
new VRScene2;