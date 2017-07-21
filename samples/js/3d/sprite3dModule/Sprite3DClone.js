Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 0.5, 1));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);


Laya.loader.create("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", Laya.Handler.create(this, onComplete));

function onComplete() {

    var layaMonkey = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));

    //克隆sprite3d
    var layaMonkey_clone1 = Laya.Sprite3D.instantiate(layaMonkey, scene, false, new Laya.Vector3(0.6, 0, 0));
    //克隆sprite3d
    var layaMonkey_clone2 = scene.addChild(Laya.Sprite3D.instantiate(layaMonkey, null, false, new Laya.Vector3(-0.6, 0, 0)));
}