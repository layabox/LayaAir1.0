Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 1.3, 1.8));
camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.direction = new Laya.Vector3(0, -0.8, -1);
directionLight.color = new Laya.Vector3(0.7, 0.6, 0.6);

var textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox1/skyCube.ltc");

var skyBox = new Laya.SkyBox();
skyBox.textureCube = textureCube;
camera.sky = skyBox;

var teapot1 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm")));
teapot1.transform.position = new Laya.Vector3(-0.8, 0, 0);
teapot1.transform.rotation = new Laya.Quaternion(0.7071068, 0, 0, -0.7071067);

var teapot2 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm")));
teapot2.transform.position = new Laya.Vector3(0.8, 0, 0);
teapot2.transform.rotation = new Laya.Quaternion(0.7071068, 0, 0, -0.7071067);
teapot2.meshFilter.sharedMesh.once(Laya.Event.LOADED, null, function () {
    var material = teapot2.meshRender.material;
    //反射贴图
    material.renderMode = Laya.StandardMaterial.RENDERMODE_OPAQUEDOUBLEFACE;
    material.reflectTexture = textureCube;
});

var rotation = new Laya.Vector3(0, 0.01, 0);
Laya.timer.frameLoop(1, null, function () {
    teapot1.transform.rotate(rotation, false);
    teapot2.transform.rotate(rotation, false);
});