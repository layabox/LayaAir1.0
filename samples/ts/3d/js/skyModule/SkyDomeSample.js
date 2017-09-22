var SkyDomeSample = (function () {
    function SkyDomeSample() {
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
        var skyDome = new Laya.SkyDome();
        camera.sky = skyDome;
        skyDome.texture = Laya.Texture2D.load("../../res/threeDimen/env/sp_default/env.png");
    }
    return SkyDomeSample;
}());
new SkyDomeSample;
