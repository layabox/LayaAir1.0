Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
camera.transform.translate(new Laya.Vector3(0, 0.7, 1.3));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
camera.addComponent(CameraMoveScript);

//点光源
var pointLight = scene.addChild(new Laya.PointLight());
pointLight.ambientColor = new Laya.Vector3(0.0, 0.0, 0.0);
pointLight.specularColor = new Laya.Vector3(0.3, 0.3, 0.9);
pointLight.diffuseColor = new Laya.Vector3(0.1189446, 0.5907708, 0.7352941);
pointLight.transform.position = new Laya.Vector3(0.4, 0.4, 0.0);
pointLight.attenuation = new Laya.Vector3(0.0, 0.0, 3.0);
pointLight.range = 3.0;

var grid = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh"));

var layaMonkey = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));
layaMonkey.once(Laya.Event.HIERARCHY_LOADED, this, function () {
    var aniSprite3d = layaMonkey.getChildAt(0);
    var animator = aniSprite3d.getComponentByType(Laya.Animator);
    animator.play(null, 1.0, 75, 110);
});

var _position = new Laya.Vector3();
var _quaternion = new Laya.Quaternion();
Laya.timer.frameLoop(1, null, function () {

    Laya.Quaternion.createFromYawPitchRoll(0.025, 0, 0, _quaternion);
    Laya.Vector3.transformQuat(pointLight.transform.position, _quaternion, _position);
    pointLight.transform.position = _position;
});