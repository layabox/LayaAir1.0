Laya3D.init(0, 0,true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 0.8, 1.0));
camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
camera.clearColor = null;
camera.addComponent(CameraMoveScript);

var pointLight = scene.addChild(new Laya.PointLight());
pointLight.transform.position = new Laya.Vector3(0, 0.6, 0.3);
pointLight.range = 1.0;
pointLight.attenuation = new Laya.Vector3(0.6, 0.6, 0.6);
pointLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
pointLight.specularColor = new Laya.Vector3(2.0, 2.0, 1.6);
pointLight.diffuseColor = new Laya.Vector3(1, 1, 1);
scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;

var skinMesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/dude/dude-him.lm")));

