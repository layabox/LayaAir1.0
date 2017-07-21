Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 0.5, 1));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

Laya.loader.create("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", Laya.Handler.create(this, onComplete));

function onComplete() {

    layaMonkey1 = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));
    layaMonkey2 = Laya.Sprite3D.instantiate(layaMonkey1, scene, false, new Laya.Vector3(0, 0, 0));
    layaMonkey3 = scene.addChild(Laya.Sprite3D.instantiate(layaMonkey1, null, false, new Laya.Vector3(0.6, 0, 0)));

    Laya.timer.frameLoop(1, this, animate);
}

var _position = new Laya.Vector3(-0.6, 0, 0);
var _rotate = new Laya.Vector3(0, 1, 0);
var _scale = new Laya.Vector3();
var scaleDelta = 0;
var scaleValue = 0;

function animate() {

    scaleValue = Math.sin(scaleDelta += 0.1);

    _position.y = scaleValue / 2;
    layaMonkey1.transform.position = _position;

    layaMonkey2.transform.rotate(_rotate, false, false);

    _scale.x = _scale.y = _scale.z = Math.abs(scaleValue);
    layaMonkey3.transform.localScale = _scale;
}