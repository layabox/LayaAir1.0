class VRScene1 {
    private rotation: Laya.Vector3;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        this.rotation = new Laya.Vector3(0, 0.002, 0);

        //与3d场景的不同是添加了vr相机
        var vrCamera: Laya.VRCamera = scene.addChild(new Laya.VRCamera(0.03, 0, 0, 0.1, 100)) as Laya.VRCamera;
        vrCamera.transform.translate(new Laya.Vector3(0, 0.1, 10));
        vrCamera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
        vrCamera.addComponent(VRCameraMoveScript);

        var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.color = new Laya.Vector3(1, 1, 1);

        var earth: Laya.Sprite3D = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/earth/EarthPlanet.lh")) as Laya.Sprite3D;

        var skyBox: Laya.SkyBox = new Laya.SkyBox();
        skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox3/skyCube.ltc");
        vrCamera.sky = skyBox;

        Laya.timer.frameLoop(1, this, function (): void {
            earth.transform.rotate(this.rotation, true);
        });
    }
}
new VRScene1;