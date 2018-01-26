Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 0.5, 1.5));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.direction = new Laya.Vector3(0, -0.8, -1);
directionLight.color = new Laya.Vector3(0.5, 0.5, 0.8);

var skyBox = new Laya.SkyBox();
skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
camera.sky = skyBox;

var earth1 = scene.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh()));
earth1.transform.position = new Laya.Vector3(-0.6, 0, 0);

var earth2 = scene.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh()));
earth2.transform.position = new Laya.Vector3(0.6, 0, 0);
var material = new Laya.StandardMaterial();
//漫反射贴图
material.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/earth.png");
earth2.meshRender.material = material;

var rotation = new Laya.Vector3(0, 0.01, 0);
Laya.timer.frameLoop(1, null, function () {
    earth1.transform.rotate(rotation, false);
    earth2.transform.rotate(rotation, false);
});