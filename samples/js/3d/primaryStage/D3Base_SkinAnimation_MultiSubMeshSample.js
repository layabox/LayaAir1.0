var skinMesh;
var skinAni;

//是否抗锯齿
//Config.isAntialias = true;
Laya3D.init(0, 0);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.Scene());

scene.currentCamera = (scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100)));
scene.currentCamera.transform.translate(new Laya.Vector3(0, 0.8, 1.0));
scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
scene.currentCamera.clearColor = null;
Laya.stage.on(Laya.Event.RESIZE, null, function () {
    scene.currentCamera.viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
});

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.direction = new Laya.Vector3(0, -0.8, -1);
directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
directionLight.specularColor = new Laya.Vector3(2.0, 2.0, 1.6);
directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);
scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;

skinMesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/dude/dude-him.lm")));
skinMesh.transform.localRotationEuler = new Laya.Vector3(0, 3.14, 0);
skinAni = skinMesh.addComponent(Laya.SkinAnimations);
skinAni.url = "../../res/threeDimen/skinModel/dude/dude.ani";
skinAni.play();