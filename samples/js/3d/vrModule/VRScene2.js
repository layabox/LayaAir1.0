Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/Arena/Arena.ls"))

//与3d场景的不同是添加了vr相机
var vrCamera = scene.addChild(new Laya.VRCamera(0.03, 0, 0, 0.1, 100));
vrCamera.transform.translate(new Laya.Vector3(0, 2, 0));
vrCamera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
vrCamera.addComponent(VRCameraMoveScript);

var skyBox = new Laya.SkyBox();
skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox2/skyCube.ltc");
vrCamera.sky = skyBox;
