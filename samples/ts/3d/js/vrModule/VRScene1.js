var VRScene1 = (function () {
    function VRScene1() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        this.rotation = new Laya.Vector3(0, 0.002, 0);
        //与3d场景的不同是添加了vr相机
        var vrCamera = scene.addChild(new Laya.VRCamera(0.03, 0, 0, 0.1, 100));
        vrCamera.transform.translate(new Laya.Vector3(0, 0.1, 10));
        vrCamera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
        vrCamera.addComponent(VRCameraMoveScript);
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.color = new Laya.Vector3(1, 1, 1);
        var earth = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/earth/EarthPlanet.lh"));
        var skyBox = new Laya.SkyBox();
        skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox3/skyCube.ltc");
        vrCamera.sky = skyBox;
        Laya.timer.frameLoop(1, this, function () {
            earth.transform.rotate(this.rotation, true);
        });
    }
    return VRScene1;
}());
new VRScene1;
