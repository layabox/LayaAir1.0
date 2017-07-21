Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/Arena/Arena.ls"))

//与3d场景的不同是添加了vr相机
var vrCamera = scene.addChild(new Laya.VRCamera(0.03, 0, 0, 0.1, 100));
vrCamera.transform.translate(new Laya.Vector3(0, 2, 0));
vrCamera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
vrCamera.addComponent(VRCameraMoveScript);

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.direction = new Laya.Vector3(0, -0.8, -1);
directionLight.ambientColor = new Laya.Vector3(0.8, 0.8, 0.8);
directionLight.specularColor = new Laya.Vector3(0.5, 0.5, 1.0);
directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);

var skyBox = new Laya.SkyBox();
skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
vrCamera.sky = skyBox;
