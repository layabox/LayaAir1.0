var SkyBoxSample = (function () {
    function SkyBoxSample() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
        camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);
        camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
        //天空盒
        var skyBox = new Laya.SkyBox();
        camera.sky = skyBox;
        skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox1/skyCube.ltc");
    }
    return SkyBoxSample;
}());
new SkyBoxSample;
