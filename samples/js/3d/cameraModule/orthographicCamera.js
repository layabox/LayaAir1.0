Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var dialog = Laya.stage.addChild(new Laya.Image("../../res/threeDimen/texture/earth.png"));

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
camera.transform.rotate(new Laya.Vector3(-30, 0, 0), false, false);
camera.transform.translate(new Laya.Vector3(0, 0.5, 500));
camera.orthographicProjection = true;

var directionLight = scene.addChild(new Laya.DirectionLight());

var layaMonkey = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));
var translate = new Laya.Vector3(500, 500, 0);
var rotation = new Laya.Vector3(0, 0.01, 0);
layaMonkey.once(Laya.Event.HIERARCHY_LOADED, this, function () {
    layaMonkey.transform.localScale = new Laya.Vector3(300, 300, 300);
    Laya.Utils3D.convert3DCoordTo2DScreenCoord(translate, translate);
    layaMonkey.transform.position = translate;
    Laya.timer.frameLoop(1, this, function () {
        layaMonkey.transform.rotate(rotation);
    });
});

Laya.stage.on(Laya.Event.RESIZE, null, function () {
    camera.orthographicVerticalSize = Laya.RenderState.clientHeight;
});