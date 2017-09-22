class MultiCamera {
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera1: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        camera1.clearColor = new Laya.Vector4(0.3, 0.3, 0.3, 1.0);
        camera1.transform.translate(new Laya.Vector3(0, 0, 1.5));
        camera1.normalizedViewport = new Laya.Viewport(0, 0, 0.5, 1.0);

        var camera2: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        camera2.clearColor = new Laya.Vector4(0.0, 0.0, 1.0, 1.0);
        camera2.transform.translate(new Laya.Vector3(0, 0, 1.5));
        camera2.normalizedViewport = new Laya.Viewport(0.5, 0.0, 0.5, 0.5);
        camera2.addComponent(CameraMoveScript);
        camera2.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
        var skyBox: Laya.SkyBox = new Laya.SkyBox();
        skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
        camera2.sky = skyBox;

        var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;

        var layaMonkey: Laya.Sprite3D = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Laya.Sprite3D;
    }
}
new MultiCamera;