var Vector3 = Laya.Vector3;

var mesh;
var reflectTexture;
var material;

//是否抗锯齿
//Config.isAntialias = true;
Laya3D.init(0, 0);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.Scene());
scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;

scene.currentCamera = (scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100)));
scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.5));
scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
Laya.stage.on(Laya.Event.RESIZE, null, function () {
				scene.currentCamera.viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
});

var sprit = scene.addChild(new Laya.Sprite3D());

//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
var mesh = Laya.Mesh.load("../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm");
meshSprite = sprit.addChild(new Laya.MeshSprite3D(mesh));
mesh.once(Laya.Event.LOADED, null, function () {
				meshSprite.materials[0].once(Laya.Event.LOADED, null, function () {
		material = meshSprite.materials[0];
		material.luminance = 0;
		material.cullFace = false;
		(material && reflectTexture) && (material.reflectTexture = reflectTexture);
				});
});
meshSprite.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
meshSprite.transform.localScale = new Vector3(0.5, 0.5, 0.5);
meshSprite.transform.localRotation = new Laya.Quaternion(-0.7071068, 0.0, 0.0, 0.7071068);

//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
var webGLImageCube = new Laya.WebGLImageCube(["../../res/threeDimen/skyBox/px.jpg", "../../res/threeDimen/skyBox/nx.jpg", "../../res/threeDimen/skyBox/py.jpg", "../../res/threeDimen/skyBox/ny.jpg", "../../res/threeDimen/skyBox/pz.jpg", "../../res/threeDimen/skyBox/nz.jpg"], 1024);
webGLImageCube.once(Laya.Event.LOADED, null, function (imgCube) {
				reflectTexture = new Laya.Texture(imgCube);
				imgCube.mipmap = true;
				(material && reflectTexture) && (meshSprite.materials[0].reflectTexture = reflectTexture);
});

Laya.timer.frameLoop(1, null, function () {
				meshSprite.transform.rotate(new Vector3(0, 0.01, 0), false);
});

