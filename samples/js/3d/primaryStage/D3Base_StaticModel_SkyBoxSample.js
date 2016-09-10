Laya3D.init(0,0,true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.Scene());
scene.shadingMode = Laya.BaseScene.VERTEX_SHADING;

scene.currentCamera = scene.addChild(new Laya.Camera(0, 0.1, 100));
scene.currentCamera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

var skyBox = new Laya.SkyBox();
scene.currentCamera.sky = skyBox;
scene.currentCamera.addComponent(CameraMoveScript);

var webGLImageCube = new Laya.WebGLImageCube(["../../res/threeDimen/skyBox/px.jpg", "../../res/threeDimen/skyBox/nx.jpg", "../../res/threeDimen/skyBox/py.jpg", "../../res/threeDimen/skyBox/ny.jpg", "../../res/threeDimen/skyBox/pz.jpg", "../../res/threeDimen/skyBox/nz.jpg"], 1024);
webGLImageCube.once(Laya.Event.LOADED,null,function(imgCube){
    var textureCube = new Laya.Texture(imgCube);
    skyBox.textureCube = textureCube;
});

var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm")));
