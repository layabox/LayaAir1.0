Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
camera.transform.translate(new Laya.Vector3(0, 0.7, 1.3));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
camera.addComponent(CameraMoveScript);

//方向光
var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.color = new Laya.Vector3(0.7, 0.6, 0.6);
directionLight.direction = new Laya.Vector3(0, -1.0, -1.0);

var grid = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh"));

var layaMonkey = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));
layaMonkey.once(Laya.Event.HIERARCHY_LOADED, this, function () {
    var aniSprite3d = layaMonkey.getChildAt(0);
    var animator = aniSprite3d.getComponentByType(Laya.Animator);
    animator.play(null, 1.0, 40, 70);
});

var _quaternion = new Laya.Quaternion();
Laya.timer.frameLoop(1, null, function () {
    Laya.Quaternion.createFromYawPitchRoll(0.025, 0, 0, _quaternion);
    var _direction = directionLight.direction;
    Laya.Vector3.transformQuat(_direction, _quaternion, _direction);
    directionLight.direction = _direction;
});