Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 0.35, 1));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

var directionLight = scene.addChild(new Laya.DirectionLight());

Laya.loader.create("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", Laya.Handler.create(this, onComplete));

function onComplete() {

    layaMonkey3D = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));

    layaMonkey2D = Laya.stage.addChild(new Laya.Image("../../res/threeDimen/monkey.png"));

    Laya.timer.frameLoop(1, this, animate);
}

var _position = new Laya.Vector3();
var _outPos = new Laya.Vector3();
var scaleDelta = 0;
function animate() {

    _position.x = Math.sin(scaleDelta += 0.01);
    layaMonkey3D.transform.position = _position;

    camera.viewport.project(layaMonkey3D.transform.position, camera.projectionViewMatrix, _outPos);

    //获取的2d坐标必须做兼容屏幕适配操作
    layaMonkey2D.pos(_outPos.x / Laya.stage.clientScaleX, _outPos.y / Laya.stage.clientScaleY);
}