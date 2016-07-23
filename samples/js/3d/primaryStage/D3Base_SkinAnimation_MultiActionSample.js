var currentState = 0;
var skinAni0;
var skinAni1;
var skinAni2;
var skinAni3;

//是否抗锯齿
//Config.isAntialias = true;
Laya3D.init(0, 0);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

loadUI();
var scene = Laya.stage.addChild(new Laya.Scene());

scene.currentCamera = scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100));
scene.currentCamera.transform.translate(new Laya.Vector3(0, 2.2, 3.0));
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

var rootSkinMesh = scene.addChild(new Laya.Sprite3D());
var skinMesh0 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT0.lm")));
var skinMesh1 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT1.lm")));
var skinMesh2 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT2.lm")));
var skinMesh3 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT3.lm")));

skinAni0 = skinMesh0.addComponent(Laya.SkinAnimations);
skinAni0.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
skinAni0.play(0, 0.6);
skinAni1 = skinMesh1.addComponent(Laya.SkinAnimations);
skinAni1.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
skinAni1.play(0, 0.6);
skinAni2 = skinMesh2.addComponent(Laya.SkinAnimations);
skinAni2.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
skinAni2.play(0, 0.6);
skinAni3 = skinMesh3.addComponent(Laya.SkinAnimations);
skinAni3.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
skinAni3.play(0, 0.6);

function loadUI() {
    Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(null, function () {
        var btn = new Laya.Button();
        btn.skin = "../../res/threeDimen/ui/button.png";
        btn.label = "切换动作";
        btn.labelBold = true;
        btn.labelSize = 20;
        btn.sizeGrid = "4,4,4,4";
        btn.size(120, 30);
        btn.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
        btn.pos(Laya.stage.width / 2 - btn.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 50 * Laya.Browser.pixelRatio);
        btn.strokeColors = "#ff0000,#ffff00,#00ffff";
        btn.on(Laya.Event.CLICK, this, onclick);
        Laya.stage.addChild(btn);

        Laya.stage.on(Laya.Event.RESIZE, null, function () {
            btn.pos(Laya.stage.width / 2 - btn.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 50 * Laya.Browser.pixelRatio);
        });
    }));
}

function onclick() {
    switch (currentState) {
        case 0:
            skinAni0.url = "../../res/threeDimen/skinModel/nvXia/yequanaidanv.ani";
            skinAni0.play();
            skinAni1.url = "../../res/threeDimen/skinModel/nvXia/yequanaidanv.ani";
            skinAni1.play();
            skinAni2.url = "../../res/threeDimen/skinModel/nvXia/yequanaidanv.ani";
            skinAni2.play();
            skinAni3.url = "../../res/threeDimen/skinModel/nvXia/yequanaidanv.ani";
            skinAni3.play();
            break;
        case 1:
            skinAni0.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
            skinAni0.play(0, 0.6);
            skinAni1.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
            skinAni1.play(0, 0.6);
            skinAni2.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
            skinAni2.play(0, 0.6);
            skinAni3.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
            skinAni3.play(0, 0.6);
            break;
    }

    currentState++;
    (currentState > 1) && (currentState = 0);
}